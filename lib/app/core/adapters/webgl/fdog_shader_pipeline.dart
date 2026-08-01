import 'dart:js_interop';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;

import 'fdog_shader_pipeline_extensions.dart';
import 'shader_pipeline.dart';

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
  late web.WebGLProgram colorMapping;
  late web.WebGLProgram blend;

  late web.WebGLTexture texture0;
  late web.WebGLTexture texture1;
  late web.WebGLTexture texture2;
  late web.WebGLTexture texture3;
  late web.WebGLTexture texture4;
  late web.WebGLTexture texture5;
  late web.WebGLTexture texture6;
  late web.WebGLTexture texture7;
  late web.WebGLTexture texture8;
  late web.WebGLTexture colorMap;

  late web.WebGLFramebuffer framebuffer;

  double scale = 1.0;

  /// Width and height, in pixels, of the input image.
  Size imageSize = Size.zero;

  /// Width of the [colorMap] texture.
  int colorMapSize = 0;

  bool useColorQuantization = false;
  bool useColorMapping = false;
  bool useColorBlending = false;

  int color2int(Color color) => (color.toARGB32() & 0x00FFFFFF);

  void setScale(double scale) {
    this.scale = scale;

    final w = (imageSize.width * scale).toInt();
    final h = (imageSize.height * scale).toInt();

    canvas.width = w;
    canvas.height = h;
    canvas.style.width = '${w}px';
    canvas.style.height = '${h}px';

    final textures = [
      texture1,
      texture2,
      texture3,
      texture4,
      texture5,
      texture6,
      texture7,
      texture8,
    ];

    for (var texture in textures) {
      gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture);
      gl.texImage2D(
        web.WebGL2RenderingContext.TEXTURE_2D,
        0,
        web.WebGL2RenderingContext.RGBA,
        w.toJS,
        h.toJS,
        0.toJS,
        web.WebGL2RenderingContext.RGBA,
        web.WebGL2RenderingContext.UNSIGNED_BYTE,
        null,
      );
    }
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

    final textures = [
      texture1,
      texture2,
      texture3,
      texture4,
      texture5,
      texture6,
      texture7,
      texture8,
    ];

    for (var texture in textures) {
      updateTextureWithSize(texture, width: w, height: h);
    }
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
    final vertSource = await rootBundle.loadString('shaders/vert.vert');
    final grayscaleSource = await rootBundle.loadString('shaders/grayscale.frag');
    final sobelSource = await rootBundle.loadString('shaders/sobel.frag');
    final blurSource = await rootBundle.loadString('shaders/gaussian_blur.frag');
    final flowSource = await rootBundle.loadString('shaders/flow.frag');
    final orthogonalDogSource = await rootBundle.loadString('shaders/orthogonal_dog.frag');
    final tangentBlurSource = await rootBundle.loadString('shaders/tangent_blur.frag');
    final colorMappingSource = await rootBundle.loadString('shaders/color_mapping.frag');
    final blendSource = await rootBundle.loadString('shaders/blend.frag');

    grayscale = createShaderProgram(vertSource, grayscaleSource);
    sobel = createShaderProgram(vertSource, sobelSource);
    blur = createShaderProgram(vertSource, blurSource);
    flow = createShaderProgram(vertSource, flowSource);
    orthogonalDog = createShaderProgram(vertSource, orthogonalDogSource);
    tangentBlur = createShaderProgram(vertSource, tangentBlurSource);
    colorMapping = createShaderProgram(vertSource, colorMappingSource);
    blend = createShaderProgram(vertSource, blendSource);

    texture0 = createTexture(canvas.width, canvas.height);
    texture1 = createTexture(canvas.width, canvas.height);
    texture2 = createTexture(canvas.width, canvas.height);
    texture3 = createTexture(canvas.width, canvas.height);
    texture4 = createTexture(canvas.width, canvas.height);
    texture5 = createTexture(canvas.width, canvas.height);
    texture6 = createTexture(canvas.width, canvas.height);
    texture7 = createTexture(canvas.width, canvas.height);
    texture8 = createTexture(canvas.width, canvas.height);
    colorMap = createTexture(colorMapSize, 1);

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
      sigma: sigmaE,
      k: k,
      tau: tau,
      epsilon: epsilon,
      phi: phi,
      sourceTexture: texture1,
      vectorTexture: texture4,
      targetTexture: texture5,
    );

    // Pass 6 - Edge-tangent blur (Line Integral Convolution)

    useLineIntegralConvolutionProgram(
      resolution: (width, height),
      sigma: sigmaM,
      sourceTexture: texture5,
      vectorTexture: texture4,
      targetTexture: texture6,
    );

    // Pass 7 - Color-quantization and color-mapping

    if (useColorQuantization) {
      useColorQuantizationProgram(
        resolution: (width, height),
        numColors: numColors,
        sourceTexture: texture6,
        targetTexture: texture7,
      );
    }

    // Pass 8 - Anti-aliasing LIC

    useLineIntegralConvolutionProgram(
      resolution: (width, height),
      sigma: sigmaA,
      sourceTexture: useColorQuantization ? texture7 : texture6,
      vectorTexture: texture4,
      targetTexture: useColorBlending ? texture8 : null,
    );

    // Pass 9 - Color-blending

    if (useColorBlending) {
      useColorBlendingProgram(
        resolution: (width, height),
        sourceTextureA: texture0,
        sourceTextureB: texture8,
        targetTexture: null,
      );
    }
  }
}
