import 'dart:js_interop';
import 'dart:ui' as ui;
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
      ..style.imageRendering = 'pixelated';

    ui_web.platformViewRegistry.registerViewFactory(
      viewType,
      (_) => canvas,
    );

    final options = {'preserveDrawingBuffer': true}.jsify();
    final context = canvas.getContext('webgl2', options) as web.WebGL2RenderingContext?;

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
    int height, {
    int internalFormat = web.WebGL2RenderingContext.RGBA,
    int format = web.WebGL2RenderingContext.RGBA,
    int type = web.WebGL2RenderingContext.UNSIGNED_BYTE,
    int textureMinFilter = web.WebGL2RenderingContext.NEAREST,
    int textureMagFilter = web.WebGL2RenderingContext.NEAREST,
    int textureWrapS = web.WebGL2RenderingContext.MIRRORED_REPEAT,
    int textureWrapT = web.WebGL2RenderingContext.MIRRORED_REPEAT,
  }) {
    final texture = gl.createTexture();

    if (texture == null) {
      throw TextureCreationException();
    }

    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture);
    gl.texImage2D(
      web.WebGL2RenderingContext.TEXTURE_2D,
      0,
      internalFormat,
      width.toJS,
      height.toJS,
      0.toJS,
      format,
      type,
      null,
    );

    gl.texParameteri(
      web.WebGL2RenderingContext.TEXTURE_2D,
      web.WebGL2RenderingContext.TEXTURE_MIN_FILTER,
      textureMinFilter,
    );

    gl.texParameteri(
      web.WebGL2RenderingContext.TEXTURE_2D,
      web.WebGL2RenderingContext.TEXTURE_MAG_FILTER,
      textureMagFilter,
    );

    gl.texParameteri(
      web.WebGL2RenderingContext.TEXTURE_2D,
      web.WebGL2RenderingContext.TEXTURE_WRAP_S,
      textureWrapS,
    );

    gl.texParameteri(
      web.WebGL2RenderingContext.TEXTURE_2D,
      web.WebGL2RenderingContext.TEXTURE_WRAP_T,
      textureWrapT,
    );

    return texture;
  }

  void _updateTexture(
    web.WebGLTexture texture, {
    int? textureMinFilter,
    int? textureMagFilter,
    int? textureWrapS,
    int? textureWrapT,
  }) {
    if (textureMinFilter != null) {
      gl.texParameteri(
        web.WebGL2RenderingContext.TEXTURE_2D,
        web.WebGL2RenderingContext.TEXTURE_MIN_FILTER,
        textureMinFilter,
      );
    }

    if (textureMagFilter != null) {
      gl.texParameteri(
        web.WebGL2RenderingContext.TEXTURE_2D,
        web.WebGL2RenderingContext.TEXTURE_MAG_FILTER,
        textureMagFilter,
      );
    }

    if (textureWrapS != null) {
      gl.texParameteri(
        web.WebGL2RenderingContext.TEXTURE_2D,
        web.WebGL2RenderingContext.TEXTURE_WRAP_S,
        textureWrapS,
      );
    }

    if (textureWrapT != null) {
      gl.texParameteri(
        web.WebGL2RenderingContext.TEXTURE_2D,
        web.WebGL2RenderingContext.TEXTURE_WRAP_T,
        textureWrapT,
      );
    }
  }

  Future<void> updateTextureWithImage(
    web.WebGLTexture texture,
    ui.Image image, {
    bool flipY = true,
    int internalFormat = web.WebGL2RenderingContext.RGBA,
    int format = web.WebGL2RenderingContext.RGBA,
    int type = web.WebGL2RenderingContext.UNSIGNED_BYTE,
    int? textureMinFilter,
    int? textureMagFilter,
    int? textureWrapS,
    int? textureWrapT,
  }) async {

    final pixels = (await image.toByteData())!.buffer.asUint8List().toJS;

    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture);
    gl.pixelStorei(web.WebGL2RenderingContext.UNPACK_FLIP_Y_WEBGL, flipY ? 1 : 0);
    gl.texImage2D(
      web.WebGL2RenderingContext.TEXTURE_2D,
      0,
      internalFormat,
      image.width.toJS,
      image.height.toJS,
      0.toJS,
      format,
      type,
      pixels,
    );

    _updateTexture(
      texture,
      textureMinFilter: textureMinFilter,
      textureMagFilter: textureMagFilter,
      textureWrapS: textureWrapS,
      textureWrapT: textureWrapT,
    );
  }

  void updateTextureWithSize(
    web.WebGLTexture texture, {
    required int width,
    required int height,
    int internalFormat = web.WebGL2RenderingContext.RGBA,
    int format = web.WebGL2RenderingContext.RGBA,
    int type = web.WebGL2RenderingContext.UNSIGNED_BYTE,
    int? textureMinFilter,
    int? textureMaxFilter,
    int? textureWrapS,
    int? textureWrapT,
  }) async {
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture);
    gl.texImage2D(
      web.WebGL2RenderingContext.TEXTURE_2D,
      0,
      internalFormat,
      width.toJS,
      height.toJS,
      0.toJS,
      format,
      type,
      null,
    );

    _updateTexture(
      texture,
      textureMinFilter: textureMinFilter,
      textureMagFilter: textureMaxFilter,
      textureWrapS: textureWrapS,
      textureWrapT: textureWrapT,
    );
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

  Future<void> saveImage(String filename) async {
    final dataUrl = canvas.toDataURL('image/png');
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
    anchor.href = dataUrl;
    anchor.download = filename;
    anchor.click();
  }
}
