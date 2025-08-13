import 'dart:developer';
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:web/web.dart' as web;

abstract class ShaderPipeline {
  final web.HTMLCanvasElement canvas;
  late web.WebGL2RenderingContext gl;

  ShaderPipeline({
    int width = 800,
    int height = 600,
  }) : canvas = web.HTMLCanvasElement()
         ..width = width
         ..height = height
         ..style.border = '1px solid black' {
    ui_web.platformViewRegistry.registerViewFactory(
      'webgl-canvas',
      (_) => canvas,
    );

    log('Canvas is ${canvas.width}x${canvas.height}');

    final context = canvas.getContext('webgl2') as web.WebGL2RenderingContext?;

    if (context == null) {
      throw Exception('WebGL2 not supported');
    }

    gl = context;
  }

  /// Create a WebGL texture, either empty or from an image;
  static Future<web.WebGLTexture?> createTexture(
    web.WebGL2RenderingContext gl, [
    String? path,
    int? width,
    int? height,
  ]) async {
    assert(path != null || (width != null && height != null));
    web.HTMLImageElement? image;

    if (path != null) {
      image = web.HTMLImageElement()..src = path;
      await image.onLoad.first;
    }

    final texture = gl.createTexture();
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture);

    if (path != null) {
      gl.pixelStorei(
        web.WebGL2RenderingContext.UNPACK_FLIP_Y_WEBGL,
        1,
      ); // Flip vertical axis
      gl.texImage2D(
        web.WebGL2RenderingContext.TEXTURE_2D,
        0,
        web.WebGL2RenderingContext.RGBA,
        web.WebGL2RenderingContext.RGBA.toJS,
        web.WebGL2RenderingContext.UNSIGNED_BYTE.toJS,
        image!,
      );
    } else {
      gl.texImage2D(
        web.WebGL2RenderingContext.TEXTURE_2D,
        0,
        web.WebGL2RenderingContext.RGBA as dynamic,
        width!.toJS,
        height!.toJS,
        0.toJS,
        web.WebGL2RenderingContext.RGBA as dynamic,
        web.WebGL2RenderingContext.UNSIGNED_BYTE as dynamic,
        null,
      );
    }

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

    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture);

    return texture;
  }

  static web.WebGLShader compileShader(
    web.WebGL2RenderingContext gl,
    int type,
    String source,
  ) {
    final shader = gl.createShader(type)!;

    gl.shaderSource(shader, source);
    gl.compileShader(shader);

    // final success = gl
    //     .getShaderParameter(shader, web.WebGL2RenderingContext.COMPILE_STATUS)
    //     .dartify();

    // if (success != false) {
    //   final log = gl.getShaderInfoLog(shader);
    //   throw Exception('Shader compile error: $log');
    // }

    gl.getShaderParameter(shader, web.WebGL2RenderingContext.COMPILE_STATUS);
    log(gl.getShaderInfoLog(shader).toString());

    return shader;
  }

  static web.WebGLProgram loadShaderProgram(
    web.WebGL2RenderingContext gl,
    String vertexShaderSource,
    String fragmentShaderSource,
  ) {
    final vertexShader = compileShader(
      gl,
      web.WebGL2RenderingContext.VERTEX_SHADER,
      vertexShaderSource,
    );
    final fragmentShader = compileShader(
      gl,
      web.WebGL2RenderingContext.FRAGMENT_SHADER,
      fragmentShaderSource,
    );

    final program = gl.createProgram()!;
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);

    // final success = gl
    //     .getProgramParameter(program, web.WebGL2RenderingContext.LINK_STATUS)
    //     .dartify();

    // if (success != false) {
    //   final log = gl.getProgramInfoLog(program);
    //   throw Exception('Program link error: $log');
    // }

    gl.getProgramParameter(program, web.WebGL2RenderingContext.LINK_STATUS);
    log(gl.getProgramInfoLog(program).toString());

    return program;
  }
}
