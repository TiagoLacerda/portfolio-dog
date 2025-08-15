import 'dart:js_interop';
import 'dart:typed_data';
import 'dart:ui_web' as ui_web;

import 'package:web/web.dart' as web;

import 'exceptions/webgl_exceptions.dart';

abstract class ShaderPipeline {
  late final web.HTMLCanvasElement canvas;
  late final web.WebGL2RenderingContext gl;
  final String viewType;

  ShaderPipeline({
    width = 800,
    height = 600,
    this.viewType = 'webgl-canvas',
  }) {
    canvas = web.HTMLCanvasElement()
      ..width = width
      ..height = height
      ..style.border = '1px solid black'
      ..style.imageRendering = 'pixelated';

    ui_web.platformViewRegistry.registerViewFactory(
      viewType,
      (_) => canvas,
    );

    final context = canvas.getContext('webgl2') as web.WebGL2RenderingContext?;

    if (context == null) {
      throw WebglNotSupportedException();
    }

    gl = context;
  }

  web.WebGLShader compileShader(
    int type,
    String source,
  ) {
    final shader = gl.createShader(type)!;

    gl.shaderSource(shader, source);
    gl.compileShader(shader);

    final success = gl.getShaderParameter(shader, web.WebGL2RenderingContext.COMPILE_STATUS).dartify();

    if (success != true) {
      final e = gl.getShaderInfoLog(shader);
      throw ShaderCompilationException(e.toString());
    }

    return shader;
  }

  web.WebGLProgram createShaderProgram(
    String vertexShaderSource,
    String fragmentShaderSource,
  ) {
    final vertexShader = compileShader(
      web.WebGL2RenderingContext.VERTEX_SHADER,
      vertexShaderSource,
    );

    final fragmentShader = compileShader(
      web.WebGL2RenderingContext.FRAGMENT_SHADER,
      fragmentShaderSource,
    );

    final program = gl.createProgram()!;
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);

    final success = gl.getProgramParameter(program, web.WebGL2RenderingContext.LINK_STATUS).dartify();

    if (success != true) {
      final e = gl.getProgramInfoLog(program);
      throw ProgramLinkException(e.toString());
    }

    return program;
  }

  web.WebGLTexture createTexture(
    int width,
    int height,
  ) {
    final texture = gl.createTexture();

    if (texture == null) {
      throw TextureCreationException();
    }

    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture);
    gl.texImage2D(
      web.WebGL2RenderingContext.TEXTURE_2D,
      0,
      web.WebGL2RenderingContext.RGBA as dynamic,
      width.toJS,
      height.toJS,
      0.toJS,
      web.WebGL2RenderingContext.RGBA as dynamic,
      web.WebGL2RenderingContext.UNSIGNED_BYTE as dynamic,
      null,
    );

    gl.texParameteri(
      web.WebGL2RenderingContext.TEXTURE_2D,
      web.WebGL2RenderingContext.TEXTURE_MIN_FILTER,
      web.WebGL2RenderingContext.NEAREST,
    );

    gl.texParameteri(
      web.WebGL2RenderingContext.TEXTURE_2D,
      web.WebGL2RenderingContext.TEXTURE_MAG_FILTER,
      web.WebGL2RenderingContext.NEAREST,
    );

    gl.texParameteri(
      web.WebGL2RenderingContext.TEXTURE_2D,
      web.WebGL2RenderingContext.TEXTURE_WRAP_S,
      web.WebGL2RenderingContext.MIRRORED_REPEAT,
    );

    gl.texParameteri(
      web.WebGL2RenderingContext.TEXTURE_2D,
      web.WebGL2RenderingContext.TEXTURE_WRAP_T,
      web.WebGL2RenderingContext.MIRRORED_REPEAT,
    );

    return texture;
  }

  web.WebGLTexture createPaletteTexture(
    List<int> colors,
  ) {
    final texture = gl.createTexture();

    if (texture == null) {
      throw TextureCreationException();
    }

    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture);

    final data = Uint8List(colors.length * 3);

    for (int i = 0; i < colors.length; ++i) {
      final color = colors[i];
      data[i * 3 + 0] = (color >> 16) & 0xFF;
      data[i * 3 + 1] = (color >> 8) & 0xFF;
      data[i * 3 + 2] = (color) & 0xFF;
    }

    gl.texImage2D(
      web.WebGL2RenderingContext.TEXTURE_2D,
      0,
      web.WebGL2RenderingContext.RGB,
      colors.length.toJS,
      1.toJS,
      0.toJS,
      web.WebGL2RenderingContext.RGB,
      web.WebGL2RenderingContext.UNSIGNED_BYTE,
      data.toJS,
    );

    gl.texParameteri(
      web.WebGL2RenderingContext.TEXTURE_2D,
      web.WebGL2RenderingContext.TEXTURE_MIN_FILTER,
      web.WebGL2RenderingContext.NEAREST,
    );

    gl.texParameteri(
      web.WebGL2RenderingContext.TEXTURE_2D,
      web.WebGL2RenderingContext.TEXTURE_MAG_FILTER,
      web.WebGL2RenderingContext.NEAREST,
    );

    gl.texParameteri(
      web.WebGL2RenderingContext.TEXTURE_2D,
      web.WebGL2RenderingContext.TEXTURE_WRAP_S,
      web.WebGL2RenderingContext.CLAMP_TO_EDGE,
    );

    gl.texParameteri(
      web.WebGL2RenderingContext.TEXTURE_2D,
      web.WebGL2RenderingContext.TEXTURE_WRAP_T,
      web.WebGL2RenderingContext.CLAMP_TO_EDGE,
    );

    return texture;
  }

  web.WebGLFramebuffer createFrameBuffer(
    web.WebGLTexture texture,
  ) {
    final framebuffer = gl.createFramebuffer();

    if (framebuffer == null) {
      throw FrameBufferCreationException();
    }

    gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, framebuffer);

    gl.framebufferTexture2D(
      web.WebGL2RenderingContext.FRAMEBUFFER,
      web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
      web.WebGL2RenderingContext.TEXTURE_2D,
      texture,
      0,
    );

    final status = gl.checkFramebufferStatus(
      web.WebGL2RenderingContext.FRAMEBUFFER,
    );

    if (status != web.WebGL2RenderingContext.FRAMEBUFFER_COMPLETE) {
      throw FrameBufferCreationException('Framebuffer incomplete: $status');
    }

    return framebuffer;
  }
}
