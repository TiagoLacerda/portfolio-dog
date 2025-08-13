import 'dart:js_interop';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_shaders/app/core/adapters/webgl/shader_pipeline.dart';
import 'package:web/web.dart' as web;

class MyShaderPipeline extends ShaderPipeline {
  MyShaderPipeline({
    super.width,
    super.height,
  });

  late web.WebGLProgram grayscale;
  late web.WebGLProgram sobel;
  late web.WebGLProgram blur;
  late web.WebGLProgram flow;
  late web.WebGLProgram fdog;
  late web.WebGLProgram dither;
  late web.WebGLTexture texture0;
  late web.WebGLTexture texture1;
  late web.WebGLTexture texture2;
  late web.WebGLTexture texture3;
  late web.WebGLTexture texture4;
  late web.WebGLTexture texture5;
  late web.WebGLFramebuffer framebuffer;

  /// Load and compile shaders and textures, intermediate frame buffer and fullscreen quad VBO.
  Future<void> initialize() async {
    final vertSource = await rootBundle.loadString('shaders/vert.vert');
    final grayscaleSource = await rootBundle.loadString('shaders/grayscale.frag');
    final sobelSource = await rootBundle.loadString('shaders/sobel.frag');
    final blurSource = await rootBundle.loadString('shaders/blur.frag');
    final flowSource = await rootBundle.loadString('shaders/flow.frag');
    final fdogSource = await rootBundle.loadString('shaders/fdog.frag');
    final ditherSource = await rootBundle.loadString('shaders/dither.frag');

    grayscale = ShaderPipeline.loadShaderProgram(gl, vertSource, grayscaleSource);
    sobel = ShaderPipeline.loadShaderProgram(gl, vertSource, sobelSource);
    blur = ShaderPipeline.loadShaderProgram(gl, vertSource, blurSource);
    flow = ShaderPipeline.loadShaderProgram(gl, vertSource, flowSource);
    fdog = ShaderPipeline.loadShaderProgram(gl, vertSource, fdogSource);
    dither = ShaderPipeline.loadShaderProgram(gl, vertSource, ditherSource);

    texture0 = (await ShaderPipeline.createTexture(gl, 'web/assets/images/lalaland.jpg'))!;
    texture1 = (await ShaderPipeline.createTexture(gl, null, canvas.width, canvas.height))!;
    texture2 = (await ShaderPipeline.createTexture(gl, null, canvas.width, canvas.height))!;
    texture3 = (await ShaderPipeline.createTexture(gl, null, canvas.width, canvas.height))!;
    texture4 = (await ShaderPipeline.createTexture(gl, null, canvas.width, canvas.height))!;
    texture5 = (await ShaderPipeline.createTexture(gl, null, canvas.width, canvas.height))!;

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

    framebuffer = gl.createFramebuffer()!;
    gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, framebuffer);
    gl.framebufferTexture2D(
      web.WebGL2RenderingContext.FRAMEBUFFER,
      web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
      web.WebGL2RenderingContext.TEXTURE_2D,
      texture1,
      0,
    );

    final status = gl.checkFramebufferStatus(
      web.WebGL2RenderingContext.FRAMEBUFFER,
    );

    if (status != web.WebGL2RenderingContext.FRAMEBUFFER_COMPLETE) {
      throw Exception('Framebuffer incomplete: $status');
    }
  }

  void draw(
    int radius,
    double sigmaC,
    double sigmaM,
    double sigmaE,
    double sigmaA,
    double k,
    double tau,
    double epsilon,
    double phi,
    double s,
  ) {
    // Grayscale

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

    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(web.WebGL2RenderingContext.COLOR_BUFFER_BIT);

    gl.useProgram(grayscale);
    gl.uniform2f(
      gl.getUniformLocation(grayscale, 'u_resolution'),
      canvas.width,
      canvas.height,
    );
    gl.uniform1i(
      gl.getUniformLocation(grayscale, 'u_sampler'),
      0,
    );

    gl.drawArrays(web.WebGL2RenderingContext.TRIANGLES, 0, 6);

    // Sobel filter

    // gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, framebuffer);
    gl.framebufferTexture2D(
      web.WebGL2RenderingContext.FRAMEBUFFER,
      web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
      web.WebGL2RenderingContext.TEXTURE_2D,
      texture2,
      0,
    );
    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture1);

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

    // gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, framebuffer);
    gl.framebufferTexture2D(
      web.WebGL2RenderingContext.FRAMEBUFFER,
      web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
      web.WebGL2RenderingContext.TEXTURE_2D,
      texture3,
      0,
    );

    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(web.WebGL2RenderingContext.COLOR_BUFFER_BIT);

    gl.useProgram(blur);
    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture2);
    gl.uniform2f(
      gl.getUniformLocation(blur, 'u_resolution'),
      canvas.width,
      canvas.height,
    );
    gl.uniform1f(
      gl.getUniformLocation(blur, 'u_radius'),
      radius.toDouble(),
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

    // Flow analysis

    // gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, null);
    gl.framebufferTexture2D(
      web.WebGL2RenderingContext.FRAMEBUFFER,
      web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
      web.WebGL2RenderingContext.TEXTURE_2D,
      texture4,
      0,
    );

    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(web.WebGL2RenderingContext.COLOR_BUFFER_BIT);

    gl.useProgram(flow);
    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture3);
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

    // Flow-based Difference of Gaussians

    // gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, null);
    gl.framebufferTexture2D(
      web.WebGL2RenderingContext.FRAMEBUFFER,
      web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
      web.WebGL2RenderingContext.TEXTURE_2D,
      texture5,
      0,
    );

    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(web.WebGL2RenderingContext.COLOR_BUFFER_BIT);

    gl.useProgram(fdog);
    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture0);
    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE1);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture1);
    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE2);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture4);
    gl.uniform2f(
      gl.getUniformLocation(fdog, 'u_resolution'),
      canvas.width,
      canvas.height,
    );
    gl.uniform1f(
      gl.getUniformLocation(fdog, 'u_radius'),
      radius.toDouble(),
    );
    gl.uniform1f(
      gl.getUniformLocation(fdog, 'u_sigma_e'),
      sigmaE,
    );
    gl.uniform1f(
      gl.getUniformLocation(fdog, 'u_sigma_m'),
      sigmaM,
    );
    gl.uniform1f(
      gl.getUniformLocation(fdog, 'u_k'),
      k,
    );
    gl.uniform1f(
      gl.getUniformLocation(fdog, 'u_tau'),
      tau,
    );
    gl.uniform1f(
      gl.getUniformLocation(fdog, 'u_epsilon'),
      epsilon,
    );
    gl.uniform1f(
      gl.getUniformLocation(fdog, 'u_phi'),
      phi,
    );
    gl.uniform1i(
      gl.getUniformLocation(fdog, 'u_texture'),
      0,
    );
    gl.uniform1i(
      gl.getUniformLocation(fdog, 'u_grayscale'),
      1,
    );
    gl.uniform1i(
      gl.getUniformLocation(fdog, 'u_flow'),
      2,
    );

    gl.drawArrays(web.WebGL2RenderingContext.TRIANGLES, 0, 6);

    // Dither

    gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, null);

    gl.viewport(0, 0, canvas.width, canvas.height);
    gl.clearColor(0.0, 0.0, 0.0, 1.0);
    gl.clear(web.WebGL2RenderingContext.COLOR_BUFFER_BIT);

    gl.useProgram(dither);
    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, texture5);
    gl.uniform2f(
      gl.getUniformLocation(dither, 'u_resolution'),
      canvas.width,
      canvas.height,
    );
    gl.uniform1f(
      gl.getUniformLocation(dither, 'u_s'),
      s,
    );
    gl.uniform1i(
      gl.getUniformLocation(dither, 'u_sampler'),
      0,
    );

    gl.drawArrays(web.WebGL2RenderingContext.TRIANGLES, 0, 6);
  }
}
