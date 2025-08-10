import 'dart:developer';
import 'dart:js_interop';
import 'dart:typed_data';
import 'dart:ui_web' as ui_web;

import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;

class ShaderPipeline {
  web.HTMLCanvasElement canvas;
  late web.WebGL2RenderingContext gl;

  late web.WebGLProgram sobel;
  late web.WebGLProgram blur;
  late web.WebGLProgram flow;
  late web.WebGLTexture texture0;
  late web.WebGLTexture texture1;
  late web.WebGLTexture texture2;
  late web.WebGLFramebuffer framebuffer;

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

    final context = canvas.getContext('webgl2') as web.WebGL2RenderingContext?;

    if (context == null) {
      throw Exception('WebGL2 not supported');
    }

    gl = context;
  }

  Future<web.WebGLTexture?> createTexture([String? path]) async {
    web.HTMLImageElement? image;

    if (path != null) {
      try {
        image = web.HTMLImageElement()..src = path;
        await image.onLoad.first;
      } catch (e) {
        log(e.toString());
      }
    }

    final texture = gl.createTexture();
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture);

    if (image != null) {
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
        image,
      );
    } else {
      gl.texImage2D(
        web.WebGL2RenderingContext.TEXTURE_2D,
        0,
        web.WebGL2RenderingContext.RGBA as dynamic,
        canvas.width.toJS,
        canvas.height.toJS,
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

  void initialize() async {
    final vertSource = await rootBundle.loadString(
      'shaders/vert.vert',
    );

    final sobelSource = await rootBundle.loadString(
      'shaders/sobel.frag',
    );

    final blurSource = await rootBundle.loadString(
      'shaders/blur.frag',
    );

    final flowSource = await rootBundle.loadString(
      'shaders/flow.frag',
    );

    sobel = loadShaderProgram(
      gl,
      vertSource,
      sobelSource,
    );

    blur = loadShaderProgram(
      gl,
      vertSource,
      blurSource,
    );

    flow = loadShaderProgram(
      gl,
      vertSource,
      flowSource,
    );

    // ------------------------- BUFFERS SETUP -------------------------

    // Fullscreen quad
    final vertices = [
      -1.0,
      -1.0,
      1.0,
      -1.0,
      -1.0,
      1.0,
      -1.0,
      1.0,
      1.0,
      -1.0,
      1.0,
      1.0,
    ];

    final vbo = gl.createBuffer();
    gl.bindBuffer(web.WebGL2RenderingContext.ARRAY_BUFFER, vbo);
    gl.bufferData(
      web.WebGL2RenderingContext.ARRAY_BUFFER,
      Float32List.fromList(vertices).toJS,
      web.WebGL2RenderingContext.STATIC_DRAW,
    );

    final positionLocation = gl.getAttribLocation(sobel, 'a_position');
    gl.enableVertexAttribArray(positionLocation);
    gl.vertexAttribPointer(
      positionLocation,
      2,
      web.WebGL2RenderingContext.FLOAT,
      false,
      0,
      0,
    );

    // ------------------------- FRAME BUFFER -------------------------

    texture0 = (await createTexture('web/assets/images/lalaland.jpg'))!;
    texture1 = (await createTexture())!;
    texture2 = (await createTexture())!;

    framebuffer = gl.createFramebuffer()!;
    gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, framebuffer);
    gl.framebufferTexture2D(
      web.WebGL2RenderingContext.FRAMEBUFFER,
      web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
      web.WebGL2RenderingContext.TEXTURE_2D,
      texture1,
      0,
    );

    // Check framebuffer completeness
    final status = gl.checkFramebufferStatus(
      web.WebGL2RenderingContext.FRAMEBUFFER,
    );
    if (status != web.WebGL2RenderingContext.FRAMEBUFFER_COMPLETE) {
      throw Exception('Framebuffer incomplete: $status');
    }

    // ------------------------- TEXTURE -------------------------

    draw(gl, 9.0, 3.0);
  }

  void draw(web.WebGL2RenderingContext gl, double radius, double sigma) {
    // Sobel filter

    gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, framebuffer);
    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture0);

    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(web.WebGL2RenderingContext.COLOR_BUFFER_BIT);

    gl.useProgram(sobel);
    gl.uniform2f(
      gl.getUniformLocation(sobel, 'u_resolution'),
      canvas.width,
      canvas.height,
    );
    gl.uniform1i(
      gl.getUniformLocation(sobel, 'u_sampler'),
      0,
    );

    gl.drawArrays(web.WebGL2RenderingContext.TRIANGLES, 0, 6);

    // Gaussian blur

    // gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, null);
    gl.framebufferTexture2D(
      web.WebGL2RenderingContext.FRAMEBUFFER,
      web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
      web.WebGL2RenderingContext.TEXTURE_2D,
      texture2,
      0,
    );

    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(web.WebGL2RenderingContext.COLOR_BUFFER_BIT);

    gl.useProgram(blur);
    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture1);
    gl.uniform2f(
      gl.getUniformLocation(blur, 'u_resolution'),
      canvas.width,
      canvas.height,
    );
    gl.uniform1f(
      gl.getUniformLocation(blur, 'u_radius'),
      radius,
    );
    gl.uniform1f(
      gl.getUniformLocation(blur, 'u_sigma'),
      sigma,
    );
    gl.uniform1i(
      gl.getUniformLocation(blur, 'u_sampler'),
      0,
    );

    gl.drawArrays(web.WebGL2RenderingContext.TRIANGLES, 0, 6);

    // Flow analysis

    gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, null);

    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(web.WebGL2RenderingContext.COLOR_BUFFER_BIT);

    gl.useProgram(flow);
    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture2);
    gl.uniform2f(
      gl.getUniformLocation(flow, 'u_resolution'),
      canvas.width,
      canvas.height,
    );
    gl.uniform1i(
      gl.getUniformLocation(flow, 'u_sampler'),
      0,
    );

    gl.drawArrays(web.WebGL2RenderingContext.TRIANGLES, 0, 6);
  }
}
