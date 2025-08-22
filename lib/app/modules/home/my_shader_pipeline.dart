import 'dart:js_interop';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;

import '../../core/adapters/webgl/shader_pipeline.dart';

typedef DrawFunction =
    void Function(
      int radius,
      double sigmaC,
      double sigmaM,
      double sigmaE,
      double sigmaA,
      double k,
      double tau,
      double epsilon,
      double phi,
    );

class MyShaderPipeline extends ShaderPipeline with ChangeNotifier {
  MyShaderPipeline({
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

  late web.WebGLTexture texture0;
  late web.WebGLTexture texture1;
  late web.WebGLTexture texture2;
  late web.WebGLTexture texture3;
  late web.WebGLTexture texture4;
  late web.WebGLTexture texture5;
  late web.WebGLTexture texture6;
  late web.WebGLTexture texture7;
  late web.WebGLTexture colorMap;

  late web.WebGLFramebuffer framebuffer;

  double scale = 1.0;

  /// Width and height, in pixels, of the input image.
  Size imageSize = Size.zero;

  /// How many values the [colorMap] currently supports.
  ///
  /// See also: [colorMapUsed].
  int colorMapSize = 32;

  /// How many values from [colorMap] are currently being used for color-mapping.
  ///
  /// See also: [colorMapSize].
  int colorMapUsed = 0;

  bool get useColorMapping => colorMapUsed >= 2;

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

    notifyListeners();
  }

  Future<void> setImage(Image image) async {
    final pixels = (await image.toByteData())!.buffer.asUint8List().toJS;
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

    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture0);
    gl.pixelStorei(web.WebGL2RenderingContext.UNPACK_FLIP_Y_WEBGL, 1);
    gl.texImage2D(
      web.WebGL2RenderingContext.TEXTURE_2D,
      0,
      web.WebGL2RenderingContext.RGBA,
      w.toJS,
      h.toJS,
      0.toJS,
      web.WebGL2RenderingContext.RGBA,
      web.WebGL2RenderingContext.UNSIGNED_BYTE,
      pixels,
    );

    final textures = [
      texture1,
      texture2,
      texture3,
      texture4,
      texture5,
      texture6,
      texture7,
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

  void setColorMap(List<Color> colors) {
    if (colors.length < 2) {
      colorMapUsed = 0;
      return;
    }

    final buffer = Uint8List(colors.length * 4);

    for (int i = 0; i < colors.length; ++i) {
      buffer[i * 4 + 0] = (colors[i].r * 255.0).round() & 0xff;
      buffer[i * 4 + 1] = (colors[i].g * 255.0).round() & 0xff;
      buffer[i * 4 + 2] = (colors[i].b * 255.0).round() & 0xff;
      buffer[i * 4 + 3] = (colors[i].a * 255.0).round() & 0xff;
    }

    colorMapUsed = colors.length;

    //

    if (colorMapUsed > colorMapSize || colorMapUsed < colorMapSize / 2) {
      colorMapSize = colorMapUsed;

      gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, colorMap);
      gl.texImage2D(
        web.WebGL2RenderingContext.TEXTURE_2D,
        0,
        web.WebGL2RenderingContext.RGBA,
        colorMapUsed.toJS,
        1.toJS,
        0.toJS,
        web.WebGL2RenderingContext.RGBA,
        web.WebGL2RenderingContext.UNSIGNED_BYTE,
        buffer.toJS,
      );
    } else {
      gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, colorMap);
      gl.texSubImage2D(
        web.WebGL2RenderingContext.TEXTURE_2D,
        0,
        0,
        0,
        colorMapUsed.toJS,
        1.toJS,
        web.WebGL2RenderingContext.RGBA.toJS,
        web.WebGL2RenderingContext.UNSIGNED_BYTE,
        buffer.toJS,
      );
    }
  }

  /// Load and compile shaders and textures, intermediate frame buffer and fullscreen quad VBO.
  Future<void> initialize() async {
    final vertSource = await rootBundle.loadString('shaders/vert.vert');
    final grayscaleSource = await rootBundle.loadString('shaders/grayscale.frag');
    final sobelSource = await rootBundle.loadString('shaders/sobel.frag');
    final blurSource = await rootBundle.loadString('shaders/blur.frag');
    final flowSource = await rootBundle.loadString('shaders/flow.frag');
    final orthogonalDogSource = await rootBundle.loadString('shaders/orthogonal_dog.frag');
    final tangentBlurSource = await rootBundle.loadString('shaders/tangent_blur.frag');
    final colorMappingSource = await rootBundle.loadString('shaders/color_mapping.frag');

    grayscale = createShaderProgram(vertSource, grayscaleSource);
    sobel = createShaderProgram(vertSource, sobelSource);
    blur = createShaderProgram(vertSource, blurSource);
    flow = createShaderProgram(vertSource, flowSource);
    orthogonalDog = createShaderProgram(vertSource, orthogonalDogSource);
    tangentBlur = createShaderProgram(vertSource, tangentBlurSource);
    colorMapping = createShaderProgram(vertSource, colorMappingSource);

    texture0 = createTexture(canvas.width, canvas.height);
    texture1 = createTexture(canvas.width, canvas.height);
    texture2 = createTexture(canvas.width, canvas.height);
    texture3 = createTexture(canvas.width, canvas.height);
    texture4 = createTexture(canvas.width, canvas.height);
    texture5 = createTexture(canvas.width, canvas.height);
    texture6 = createTexture(canvas.width, canvas.height);
    texture7 = createTexture(canvas.width, canvas.height);
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
    double sigmaM,
    double sigmaE,
    double sigmaA,
    double k,
    double tau,
    double epsilon,
    double phi,
  ) {
    // Pass 1 - Grayscale

    final width = (imageSize.width * scale).toInt();
    final height = (imageSize.height * scale).toInt();

    gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, framebuffer);
    gl.framebufferTexture2D(
      web.WebGL2RenderingContext.FRAMEBUFFER,
      web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
      web.WebGL2RenderingContext.TEXTURE_2D,
      texture1,
      0,
    );

    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture0);

    gl.viewport(0, 0, width, height);
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(web.WebGL2RenderingContext.COLOR_BUFFER_BIT);

    gl.useProgram(grayscale);
    gl.uniform2f(
      gl.getUniformLocation(grayscale, 'u_resolution'),
      width,
      height,
    );
    gl.uniform1i(
      gl.getUniformLocation(grayscale, 'u_sampler'),
      0,
    );

    gl.drawArrays(web.WebGL2RenderingContext.TRIANGLES, 0, 6);

    // Pass 2 - Sobel filter

    gl.framebufferTexture2D(
      web.WebGL2RenderingContext.FRAMEBUFFER,
      web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
      web.WebGL2RenderingContext.TEXTURE_2D,
      texture2,
      0,
    );

    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture1);

    gl.viewport(0, 0, width, height);
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(web.WebGL2RenderingContext.COLOR_BUFFER_BIT);

    gl.useProgram(sobel);
    gl.uniform2f(
      gl.getUniformLocation(sobel, 'u_resolution'),
      width,
      height,
    );
    gl.uniform1i(
      gl.getUniformLocation(sobel, 'u_sampler'),
      0,
    );

    gl.drawArrays(web.WebGL2RenderingContext.TRIANGLES, 0, 6);

    // Pass 3 - Gaussian blur

    gl.framebufferTexture2D(
      web.WebGL2RenderingContext.FRAMEBUFFER,
      web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
      web.WebGL2RenderingContext.TEXTURE_2D,
      texture3,
      0,
    );

    gl.viewport(0, 0, width, height);
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(web.WebGL2RenderingContext.COLOR_BUFFER_BIT);

    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture2);

    gl.useProgram(blur);
    gl.uniform2f(
      gl.getUniformLocation(blur, 'u_resolution'),
      width,
      height,
    );
    gl.uniform1i(
      gl.getUniformLocation(blur, 'u_radius'),
      max(5.0, 3.0 * sigmaC).floor(),
    );
    gl.uniform1f(
      gl.getUniformLocation(blur, 'u_sigma'),
      sigmaC,
    );
    gl.uniform1i(
      gl.getUniformLocation(blur, 'u_sampler'),
      0,
    );

    gl.drawArrays(web.WebGL2RenderingContext.TRIANGLES, 0, 6);

    // Pass 4 - Flow analysis

    gl.framebufferTexture2D(
      web.WebGL2RenderingContext.FRAMEBUFFER,
      web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
      web.WebGL2RenderingContext.TEXTURE_2D,
      texture4,
      0,
    );

    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture3);

    gl.viewport(0, 0, width, height);
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(web.WebGL2RenderingContext.COLOR_BUFFER_BIT);

    gl.useProgram(flow);
    gl.uniform2f(
      gl.getUniformLocation(flow, 'u_resolution'),
      width,
      height,
    );
    gl.uniform1i(
      gl.getUniformLocation(flow, 'u_sampler'),
      0,
    );

    gl.drawArrays(web.WebGL2RenderingContext.TRIANGLES, 0, 6);

    // Pass 5 - Flow-orthogonal Difference of Gaussians

    gl.framebufferTexture2D(
      web.WebGL2RenderingContext.FRAMEBUFFER,
      web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
      web.WebGL2RenderingContext.TEXTURE_2D,
      texture5,
      0,
    );

    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture1);
    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE1);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture4);

    gl.viewport(0, 0, width, height);
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(web.WebGL2RenderingContext.COLOR_BUFFER_BIT);

    gl.useProgram(orthogonalDog);
    gl.uniform2f(
      gl.getUniformLocation(orthogonalDog, 'u_resolution'),
      width,
      height,
    );
    gl.uniform1f(
      gl.getUniformLocation(orthogonalDog, 'u_sigma'),
      sigmaE,
    );
    gl.uniform1f(
      gl.getUniformLocation(orthogonalDog, 'u_k'),
      k,
    );
    gl.uniform1f(
      gl.getUniformLocation(orthogonalDog, 'u_tau'),
      tau,
    );
    gl.uniform1f(
      gl.getUniformLocation(orthogonalDog, 'u_epsilon'),
      epsilon,
    );
    gl.uniform1f(
      gl.getUniformLocation(orthogonalDog, 'u_phi'),
      phi,
    );
    gl.uniform1i(
      gl.getUniformLocation(orthogonalDog, 'u_sampler'),
      0,
    );
    gl.uniform1i(
      gl.getUniformLocation(orthogonalDog, 'u_flow'),
      1,
    );

    gl.drawArrays(web.WebGL2RenderingContext.TRIANGLES, 0, 6);

    // Pass 6 - Flow-tangent blur (LIC)

    gl.framebufferTexture2D(
      web.WebGL2RenderingContext.FRAMEBUFFER,
      web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
      web.WebGL2RenderingContext.TEXTURE_2D,
      texture6,
      0,
    );

    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture5);
    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE1);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture4);

    gl.viewport(0, 0, width, height);
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(web.WebGL2RenderingContext.COLOR_BUFFER_BIT);

    gl.useProgram(tangentBlur);
    gl.uniform2f(
      gl.getUniformLocation(tangentBlur, 'u_resolution'),
      width,
      height,
    );
    gl.uniform1f(
      gl.getUniformLocation(tangentBlur, 'u_sigma'),
      sigmaM,
    );
    gl.uniform1i(
      gl.getUniformLocation(tangentBlur, 'u_sampler'),
      0,
    );
    gl.uniform1i(
      gl.getUniformLocation(tangentBlur, 'u_flow'),
      1,
    );

    gl.drawArrays(web.WebGL2RenderingContext.TRIANGLES, 0, 6);

    // Pass 7 - Color quantization and mapping

    if (useColorMapping) {
      gl.framebufferTexture2D(
        web.WebGL2RenderingContext.FRAMEBUFFER,
        web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
        web.WebGL2RenderingContext.TEXTURE_2D,
        texture7,
        0,
      );

      gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
      gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture6);
      gl.activeTexture(web.WebGL2RenderingContext.TEXTURE1);
      gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, colorMap);

      gl.viewport(0, 0, width, height);
      gl.clearColor(0.0, 0.0, 0.0, 1.0);
      gl.clear(web.WebGL2RenderingContext.COLOR_BUFFER_BIT);

      gl.useProgram(colorMapping);
      gl.uniform2f(
        gl.getUniformLocation(colorMapping, 'u_resolution'),
        width,
        height,
      );
      gl.uniform1i(
        gl.getUniformLocation(colorMapping, 'u_n'),
        colorMapUsed,
      );
      gl.uniform1i(
        gl.getUniformLocation(colorMapping, 'u_sampler'),
        0,
      );
      gl.uniform1i(
        gl.getUniformLocation(colorMapping, 'u_colors'),
        1,
      );

      gl.drawArrays(web.WebGL2RenderingContext.TRIANGLES, 0, 6);
    }

    // Pass 8 - Anti-aliasing LIC

    gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, null);

    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, useColorMapping ? texture7 : texture6);
    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE1);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture4);

    gl.viewport(0, 0, width, height);
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(web.WebGL2RenderingContext.COLOR_BUFFER_BIT);

    gl.useProgram(tangentBlur);
    gl.uniform2f(
      gl.getUniformLocation(tangentBlur, 'u_resolution'),
      width,
      height,
    );
    gl.uniform1f(
      gl.getUniformLocation(tangentBlur, 'u_sigma'),
      sigmaA,
    );
    gl.uniform1i(
      gl.getUniformLocation(tangentBlur, 'u_sampler'),
      0,
    );
    gl.uniform1i(
      gl.getUniformLocation(tangentBlur, 'u_flow'),
      1,
    );

    gl.drawArrays(web.WebGL2RenderingContext.TRIANGLES, 0, 6);
  }
}
