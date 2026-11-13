import 'dart:js_interop';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;

import '../../../utils/utils.dart';
import 'enums/color_blending.dart';
import 'fdog_shader_pipeline_extensions.dart';
import '../shader_pipeline.dart';

class FDoGShaderPipeline extends ShaderPipeline {
  FDoGShaderPipeline({
    super.width,
    super.height,
  });

  late web.WebGLProgram grayscale;
  late web.WebGLProgram sobel;
  late web.WebGLProgram blur;
  late web.WebGLProgram flow;
  late web.WebGLProgram orthogonalDog;
  late web.WebGLProgram tangentBlur;
  late web.WebGLProgram threshold;
  late web.WebGLProgram colorMapping;
  late web.WebGLProgram crossHatching;
  late web.WebGLProgram blend;
  late web.WebGLProgram paper;

  late web.WebGLTexture texture0;
  late web.WebGLTexture texture1;
  late web.WebGLTexture texture2;
  late web.WebGLTexture texture3;
  late web.WebGLTexture texture4;
  late web.WebGLTexture texture5;
  late web.WebGLTexture texture6;
  late web.WebGLTexture texture7;
  late web.WebGLTexture texture8;
  late web.WebGLTexture texture9;
  late web.WebGLTexture texture10;
  late web.WebGLTexture colorMap;
  late web.WebGLTexture paperTexture;
  late List<web.WebGLTexture> crossHatchingTextures;

  late web.WebGLFramebuffer framebuffer;

  /// Upper bound for kernel radii, which keeps extreme σ values from stalling the GPU.
  static const maxKernelRadius = 32;

  double scale = 1.0;

  /// Width and height, in pixels, of the input image.
  Size imageSize = Size.zero;

  /// Width of the [colorMap] texture.
  int colorMapSize = 0;

  Size paperSize = Size.zero;

  Size crossHatchingSize = Size.zero;

  bool useColorQuantization = false;
  bool useColorMapping = false;
  bool useCrossHatching = false;
  ColorBlending colorBlending = ColorBlending.none;
  bool usePaperTexture = false;

  int color2int(Color color) => (color.toARGB32() & 0x00FFFFFF);

  /// Radius of a Gaussian kernel that extends [extent] standard deviations from its center.
  int kernelRadius(double sigma, {double extent = 2.0}) => min((sigma * extent).ceil(), maxKernelRadius);

  /// Intermediate textures holding values in the [0, 1] range.
  List<web.WebGLTexture> get _byteTextures => [texture1, texture7, texture8, texture9, texture10];

  /// Intermediate textures holding signed or unbounded values: the structure tensor, the flow field and the DoG response.
  List<web.WebGLTexture> get _floatTextures => [texture2, texture3, texture4, texture5, texture6];

  void _resizeIntermediateTextures(int width, int height) {
    for (var texture in _byteTextures) {
      updateTextureWithSize(texture, width: width, height: height);
    }

    for (var texture in _floatTextures) {
      updateTextureWithSize(
        texture,
        width: width,
        height: height,
        internalFormat: web.WebGL2RenderingContext.RGBA16F,
        type: web.WebGL2RenderingContext.HALF_FLOAT,
      );
    }
  }

  void setScale(double scale) {
    this.scale = scale;

    final w = (imageSize.width * scale).toInt();
    final h = (imageSize.height * scale).toInt();

    canvas.width = w;
    canvas.height = h;
    canvas.style.width = '${w}px';
    canvas.style.height = '${h}px';

    _resizeIntermediateTextures(w, h);
  }

  Future<void> setImage(Image image) async {
    final w = image.width;
    final h = image.height;

    scale = 1.0;
    imageSize = Size(w.toDouble(), h.toDouble());

    canvas.width = w;
    canvas.height = h;
    canvas.style.width = '${w}px';
    canvas.style.height = '${h}px';

    gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, null);
    gl.viewport(0, 0, w, h);
    gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, framebuffer);
    gl.viewport(0, 0, w, h);

    await updateTextureWithImage(texture0, image);

    _resizeIntermediateTextures(w, h);
  }

  void setColorMap(List<Color> colors) {
    colorMapSize = colors.length;

    final buffer = Uint8List(colors.length * 4);

    for (int i = 0; i < colors.length; ++i) {
      buffer[i * 4 + 0] = (colors[i].r * 255.0).round() & 0xff;
      buffer[i * 4 + 1] = (colors[i].g * 255.0).round() & 0xff;
      buffer[i * 4 + 2] = (colors[i].b * 255.0).round() & 0xff;
      buffer[i * 4 + 3] = (colors[i].a * 255.0).round() & 0xff;
    }

    //

    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, colorMap);
    gl.texImage2D(
      web.WebGL2RenderingContext.TEXTURE_2D,
      0,
      web.WebGL2RenderingContext.RGBA,
      colorMapSize.toJS,
      1.toJS,
      0.toJS,
      web.WebGL2RenderingContext.RGBA,
      web.WebGL2RenderingContext.UNSIGNED_BYTE,
      buffer.toJS,
    );
  }

  /// Load and compile shaders and textures, intermediate frame buffer and fullscreen quad VBO.
  Future<void> initialize() async {
    enableFloatRenderTargets();

    final vertSource = await rootBundle.loadString('shaders/vert.vert');
    final grayscaleSource = await rootBundle.loadString('shaders/grayscale.frag');
    final sobelSource = await rootBundle.loadString('shaders/sobel.frag');
    final blurSource = await rootBundle.loadString('shaders/gaussian_blur.frag');
    final flowSource = await rootBundle.loadString('shaders/flow.frag');
    final orthogonalDogSource = await rootBundle.loadString('shaders/orthogonal_dog.frag');
    final tangentBlurSource = await rootBundle.loadString('shaders/tangent_blur.frag');
    final thresholdSource = await rootBundle.loadString('shaders/threshold.frag');
    final colorMappingSource = await rootBundle.loadString('shaders/color_mapping.frag');
    final crossHatchingSource = await rootBundle.loadString('shaders/cross_hatching.frag');
    final blendSource = await rootBundle.loadString('shaders/blend.frag');
    final paperSource = await rootBundle.loadString('shaders/paper.frag');

    grayscale = createShaderProgram(vertSource, grayscaleSource);
    sobel = createShaderProgram(vertSource, sobelSource);
    blur = createShaderProgram(vertSource, blurSource);
    flow = createShaderProgram(vertSource, flowSource);
    orthogonalDog = createShaderProgram(vertSource, orthogonalDogSource);
    tangentBlur = createShaderProgram(vertSource, tangentBlurSource);
    threshold = createShaderProgram(vertSource, thresholdSource);
    colorMapping = createShaderProgram(vertSource, colorMappingSource);
    crossHatching = createShaderProgram(vertSource, crossHatchingSource);
    blend = createShaderProgram(vertSource, blendSource);
    paper = createShaderProgram(vertSource, paperSource);

    web.WebGLTexture createByteTexture({bool linear = false}) => createTexture(
      canvas.width,
      canvas.height,
      textureMinFilter: linear ? web.WebGL2RenderingContext.LINEAR : web.WebGL2RenderingContext.NEAREST,
      textureMagFilter: linear ? web.WebGL2RenderingContext.LINEAR : web.WebGL2RenderingContext.NEAREST,
    );

    web.WebGLTexture createFloatTexture({bool linear = false}) => createTexture(
      canvas.width,
      canvas.height,
      internalFormat: web.WebGL2RenderingContext.RGBA16F,
      type: web.WebGL2RenderingContext.HALF_FLOAT,
      textureMinFilter: linear ? web.WebGL2RenderingContext.LINEAR : web.WebGL2RenderingContext.NEAREST,
      textureMagFilter: linear ? web.WebGL2RenderingContext.LINEAR : web.WebGL2RenderingContext.NEAREST,
    );

    // Textures read at fractional offsets by the DoG and LIC passes are linearly filtered. The flow field isn't,
    // as interpolating between eigenvectors of opposite orientations would cancel them out.
    texture0 = createTexture(canvas.width, canvas.height);
    texture1 = createByteTexture(linear: true);
    texture2 = createFloatTexture();
    texture3 = createFloatTexture();
    texture4 = createFloatTexture();
    texture5 = createFloatTexture(linear: true);
    texture6 = createFloatTexture();
    texture7 = createByteTexture(linear: true);
    texture8 = createByteTexture(linear: true);
    texture9 = createByteTexture();
    texture10 = createByteTexture();
    colorMap = createTexture(colorMapSize, 1);

    final paperImage = await Utils.loadImageFromAsset('images/paper.png');

    paperTexture = createByteTexture(linear: true);

    if (paperImage != null) {
      paperSize = Size(paperImage.width.toDouble(), paperImage.height.toDouble());
      await updateTextureWithImage(paperTexture, paperImage);
      paperImage.dispose();
    }

    crossHatchingTextures = [];

    for (var i = 1; i <= 4; ++i) {
      final texture = createTexture(
        1,
        1,
        textureMinFilter: web.WebGL2RenderingContext.LINEAR,
        textureMagFilter: web.WebGL2RenderingContext.LINEAR,
        textureWrapS: web.WebGL2RenderingContext.REPEAT,
        textureWrapT: web.WebGL2RenderingContext.REPEAT,
      );

      final image = await Utils.loadImageFromAsset('images/cross-hatching-$i.png');

      if (image != null) {
        crossHatchingSize = Size(image.width.toDouble(), image.height.toDouble());
        await updateTextureWithImage(texture, image);
        image.dispose();
      }

      crossHatchingTextures.add(texture);
    }

    framebuffer = createFrameBuffer(texture1);

    // Fullscreen quad
    final vertices = [-1.0, -1.0, 1.0, -1.0, -1.0, 1.0, -1.0, 1.0, 1.0, -1.0, 1.0, 1.0];

    final vbo = gl.createBuffer();
    gl.bindBuffer(web.WebGL2RenderingContext.ARRAY_BUFFER, vbo);
    gl.bufferData(
      web.WebGL2RenderingContext.ARRAY_BUFFER,
      Float32List.fromList(vertices).toJS,
      web.WebGL2RenderingContext.STATIC_DRAW,
    );

    final location = gl.getAttribLocation(sobel, 'a_position');
    gl.enableVertexAttribArray(location);
    gl.vertexAttribPointer(
      location,
      2,
      web.WebGL2RenderingContext.FLOAT,
      false,
      0,
      0,
    );
  }

  void draw(
    double sigmaC,
    double sigmaE,
    double sigmaM,
    double sigmaA,
    double k,
    double tau,
    double epsilon,
    double phi,
    int numColors,
    (double, double, double, double) crossHatchingAngles,
    (double, double, double, double) crossHatchingThresholds,
    double crossHatchingScale,
  ) {
    final width = (imageSize.width * scale).toInt();
    final height = (imageSize.height * scale).toInt();

    gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, null);
    gl.viewport(0, 0, width, height);
    gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, framebuffer);
    gl.viewport(0, 0, width, height);

    // Pass 1 - Grayscale

    useGrayscaleProgram(
      resolution: (width, height),
      sourceTexture: texture0,
      targetTexture: texture1,
    );

    // Pass 2 - Sobel filter

    useSobelProgram(
      resolution: (width, height),
      sourceTexture: texture1,
      targetTexture: texture2,
    );

    // Pass 3 - Gaussian blur on structure-tensor

    useGaussianBlurProgram(
      resolution: (width, height),
      radius: kernelRadius(sigmaC, extent: 2.45),
      sigma: sigmaC,
      sourceTexture: texture2,
      bufferTexture: texture4,
      targetTexture: texture3,
    );

    // Pass 4 - Structure-tensor eigenanalysis

    useFlowProgram(
      resolution: (width, height),
      sourceTexture: texture3,
      targetTexture: texture4,
    );

    // Pass 5 - Edge-orthogonal Difference of Gaussians

    useDifferenceOfGaussiansProgram(
      resolution: (width, height),
      radiusSmall: kernelRadius(sigmaE),
      radiusLarge: kernelRadius(sigmaE * k),
      sigma: sigmaE,
      k: k,
      tau: tau,
      sourceTexture: texture1,
      vectorTexture: texture4,
      targetTexture: texture5,
    );

    // Pass 6 - Edge-tangent blur (Line Integral Convolution)

    useLineIntegralConvolutionProgram(
      resolution: (width, height),
      radius: kernelRadius(sigmaM),
      sigma: sigmaM,
      sourceTexture: texture5,
      vectorTexture: texture4,
      targetTexture: texture6,
    );

    // Pass 7 - Thresholding, which also provides the edge layer for cross-hatching

    useThresholdProgram(
      resolution: (width, height),
      epsilon: epsilon,
      phi: phi,
      sourceTexture: texture6,
      targetTexture: texture7,
    );

    // Pass 8 - Cross-hatching, or color-quantization and color-mapping

    if (useCrossHatching) {
      useCrossHatchingProgram(
        resolution: (width, height),
        hatchSize: crossHatchingSize * crossHatchingScale,
        angles: crossHatchingAngles,
        thresholds: crossHatchingThresholds,
        phi: phi,
        sourceTexture: texture6,
        edgesTexture: texture7,
        hatchTextures: crossHatchingTextures,
        targetTexture: texture8,
      );
    } else if (useColorQuantization) {
      useColorQuantizationProgram(
        resolution: (width, height),
        numColors: numColors,
        sourceTexture: texture7,
        targetTexture: texture8,
      );
    }

    // Optional steps after pass 9 ping-pong between texture9 and texture10, and the last one draws to the canvas.

    var remainingSteps = [
      colorBlending != ColorBlending.none,
      usePaperTexture,
    ].where((enabled) => enabled).length;

    var output = texture10;

    web.WebGLTexture? nextTarget() {
      if (remainingSteps-- == 0) return null;
      output = output == texture9 ? texture10 : texture9;
      return output;
    }

    // Pass 9 - Anti-aliasing LIC

    useLineIntegralConvolutionProgram(
      resolution: (width, height),
      radius: kernelRadius(sigmaA),
      sigma: sigmaA,
      sourceTexture: useCrossHatching || useColorQuantization ? texture8 : texture7,
      vectorTexture: texture4,
      targetTexture: nextTarget(),
    );

    // Pass 10 - Color-blending

    if (colorBlending != ColorBlending.none) {
      final source = output;

      useColorBlendingProgram(
        resolution: (width, height),
        mode: colorBlending,
        sourceTextureA: texture0,
        sourceTextureB: source,
        targetTexture: nextTarget(),
      );
    }

    // Pass 11 - Paper texture

    if (usePaperTexture) {
      final source = output;

      usePaperTextureProgram(
        resolution: (width, height),
        paperSize: paperSize,
        sourceTexture: source,
        paperTexture: paperTexture,
        targetTexture: nextTarget(),
      );
    }
  }
}
