import 'dart:math';
import 'dart:ui';

import 'package:web/web.dart' as web;

import 'enums/color_blending.dart';
import 'fdog_shader_pipeline.dart';

extension ShaderCallers on FDoGShaderPipeline {
  void useGrayscaleProgram({
    required (int, int) resolution,
    required web.WebGLTexture sourceTexture,
    web.WebGLTexture? targetTexture,
  }) {
    if (targetTexture == null) {
      gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, null);
    } else {
      gl.framebufferTexture2D(
        web.WebGL2RenderingContext.FRAMEBUFFER,
        web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
        web.WebGL2RenderingContext.TEXTURE_2D,
        targetTexture,
        0,
      );
    }

    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, sourceTexture);

    gl.useProgram(grayscale);
    gl.uniform2f(
      gl.getUniformLocation(grayscale, 'u_resolution'),
      resolution.$1,
      resolution.$2,
    );
    gl.uniform1i(
      gl.getUniformLocation(grayscale, 'u_sampler'),
      0,
    );

    gl.drawArrays(web.WebGL2RenderingContext.TRIANGLES, 0, 6);
  }

  void useSobelProgram({
    required (int, int) resolution,
    required web.WebGLTexture sourceTexture,
    web.WebGLTexture? targetTexture,
  }) {
    if (targetTexture == null) {
      gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, null);
    } else {
      gl.framebufferTexture2D(
        web.WebGL2RenderingContext.FRAMEBUFFER,
        web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
        web.WebGL2RenderingContext.TEXTURE_2D,
        targetTexture,
        0,
      );
    }

    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, sourceTexture);

    gl.useProgram(sobel);
    gl.uniform2f(
      gl.getUniformLocation(sobel, 'u_resolution'),
      resolution.$1,
      resolution.$2,
    );
    gl.uniform1i(
      gl.getUniformLocation(sobel, 'u_sampler'),
      0,
    );

    gl.drawArrays(web.WebGL2RenderingContext.TRIANGLES, 0, 6);
  }

  void useGaussianBlurProgram({
    required (int, int) resolution,
    required int radius,
    required double sigma,
    required web.WebGLTexture sourceTexture,
    required web.WebGLTexture bufferTexture,
    web.WebGLTexture? targetTexture,
  }) {
    gl.framebufferTexture2D(
      web.WebGL2RenderingContext.FRAMEBUFFER,
      web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
      web.WebGL2RenderingContext.TEXTURE_2D,
      bufferTexture,
      0,
    );

    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, sourceTexture);

    gl.useProgram(blur);
    gl.uniform2f(
      gl.getUniformLocation(blur, 'u_resolution'),
      resolution.$1,
      resolution.$2,
    );
    gl.uniform2f(
      gl.getUniformLocation(blur, 'u_direction'),
      1.0,
      0.0,
    );
    gl.uniform1i(
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

    if (targetTexture == null) {
      gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, null);
    } else {
      gl.framebufferTexture2D(
        web.WebGL2RenderingContext.FRAMEBUFFER,
        web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
        web.WebGL2RenderingContext.TEXTURE_2D,
        targetTexture,
        0,
      );
    }

    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, bufferTexture);

    gl.useProgram(blur);
    gl.uniform2f(
      gl.getUniformLocation(blur, 'u_resolution'),
      resolution.$1,
      resolution.$2,
    );
    gl.uniform2f(
      gl.getUniformLocation(blur, 'u_direction'),
      0.0,
      1.0,
    );
    gl.uniform1i(
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
  }

  void useFlowProgram({
    required (int, int) resolution,
    required web.WebGLTexture sourceTexture,
    web.WebGLTexture? targetTexture,
  }) {
    if (targetTexture == null) {
      gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, null);
    } else {
      gl.framebufferTexture2D(
        web.WebGL2RenderingContext.FRAMEBUFFER,
        web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
        web.WebGL2RenderingContext.TEXTURE_2D,
        targetTexture,
        0,
      );
    }

    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, sourceTexture);

    gl.useProgram(flow);
    gl.uniform2f(
      gl.getUniformLocation(flow, 'u_resolution'),
      resolution.$1,
      resolution.$2,
    );
    gl.uniform1i(
      gl.getUniformLocation(flow, 'u_sampler'),
      0,
    );

    gl.drawArrays(web.WebGL2RenderingContext.TRIANGLES, 0, 6);
  }

  void useDifferenceOfGaussiansProgram({
    required (int, int) resolution,
    required int radiusSmall,
    required int radiusLarge,
    required double sigma,
    required double k,
    required double tau,
    required web.WebGLTexture sourceTexture,
    required web.WebGLTexture vectorTexture,
    web.WebGLTexture? targetTexture,
  }) {
    if (targetTexture == null) {
      gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, null);
    } else {
      gl.framebufferTexture2D(
        web.WebGL2RenderingContext.FRAMEBUFFER,
        web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
        web.WebGL2RenderingContext.TEXTURE_2D,
        targetTexture,
        0,
      );
    }

    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, sourceTexture);
    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE1);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, vectorTexture);

    gl.useProgram(orthogonalDog);
    gl.uniform2f(
      gl.getUniformLocation(orthogonalDog, 'u_resolution'),
      resolution.$1,
      resolution.$2,
    );
    gl.uniform1i(
      gl.getUniformLocation(orthogonalDog, 'u_radius_small'),
      radiusSmall,
    );
    gl.uniform1i(
      gl.getUniformLocation(orthogonalDog, 'u_radius_large'),
      radiusLarge,
    );
    gl.uniform1f(
      gl.getUniformLocation(orthogonalDog, 'u_sigma'),
      sigma,
    );
    gl.uniform1f(
      gl.getUniformLocation(orthogonalDog, 'u_k'),
      k,
    );
    gl.uniform1f(
      gl.getUniformLocation(orthogonalDog, 'u_tau'),
      tau,
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
  }

  void useLineIntegralConvolutionProgram({
    required (int, int) resolution,
    required int radius,
    required double sigma,
    required web.WebGLTexture sourceTexture,
    required web.WebGLTexture vectorTexture,
    web.WebGLTexture? targetTexture,
  }) {
    if (targetTexture == null) {
      gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, null);
    } else {
      gl.framebufferTexture2D(
        web.WebGL2RenderingContext.FRAMEBUFFER,
        web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
        web.WebGL2RenderingContext.TEXTURE_2D,
        targetTexture,
        0,
      );
    }

    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, sourceTexture);
    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE1);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, vectorTexture);

    gl.useProgram(tangentBlur);
    gl.uniform2f(
      gl.getUniformLocation(tangentBlur, 'u_resolution'),
      resolution.$1,
      resolution.$2,
    );
    gl.uniform1i(
      gl.getUniformLocation(tangentBlur, 'u_radius'),
      radius,
    );
    gl.uniform1f(
      gl.getUniformLocation(tangentBlur, 'u_sigma'),
      sigma,
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

  void useThresholdProgram({
    required (int, int) resolution,
    required double epsilon,
    required double phi,
    required web.WebGLTexture sourceTexture,
    web.WebGLTexture? targetTexture,
  }) {
    if (targetTexture == null) {
      gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, null);
    } else {
      gl.framebufferTexture2D(
        web.WebGL2RenderingContext.FRAMEBUFFER,
        web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
        web.WebGL2RenderingContext.TEXTURE_2D,
        targetTexture,
        0,
      );
    }

    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, sourceTexture);

    gl.useProgram(threshold);
    gl.uniform2f(
      gl.getUniformLocation(threshold, 'u_resolution'),
      resolution.$1,
      resolution.$2,
    );
    gl.uniform1f(
      gl.getUniformLocation(threshold, 'u_epsilon'),
      epsilon,
    );
    gl.uniform1f(
      gl.getUniformLocation(threshold, 'u_phi'),
      phi,
    );
    gl.uniform1i(
      gl.getUniformLocation(threshold, 'u_sampler'),
      0,
    );

    gl.drawArrays(web.WebGL2RenderingContext.TRIANGLES, 0, 6);
  }

  void useColorQuantizationProgram({
    required (int, int) resolution,
    required int numColors,
    required web.WebGLTexture sourceTexture,
    web.WebGLTexture? targetTexture,
  }) {
    if (targetTexture == null) {
      gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, null);
    } else {
      gl.framebufferTexture2D(
        web.WebGL2RenderingContext.FRAMEBUFFER,
        web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
        web.WebGL2RenderingContext.TEXTURE_2D,
        targetTexture,
        0,
      );
    }

    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, sourceTexture);
    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE1);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, colorMap);

    gl.useProgram(colorMapping);
    gl.uniform2f(
      gl.getUniformLocation(colorMapping, 'u_resolution'),
      resolution.$1,
      resolution.$2,
    );
    gl.uniform1i(
      gl.getUniformLocation(colorMapping, 'u_n'),
      useColorMapping ? min(numColors, colorMapSize) : numColors,
    );
    gl.uniform1i(
      gl.getUniformLocation(colorMapping, 'u_use_color_mapping'),
      useColorMapping ? 1 : 0,
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

  void useColorBlendingProgram({
    required (int, int) resolution,
    required ColorBlending mode,
    required web.WebGLTexture sourceTextureA,
    required web.WebGLTexture sourceTextureB,
    web.WebGLTexture? targetTexture,
  }) {
    if (targetTexture == null) {
      gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, null);
    } else {
      gl.framebufferTexture2D(
        web.WebGL2RenderingContext.FRAMEBUFFER,
        web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
        web.WebGL2RenderingContext.TEXTURE_2D,
        targetTexture,
        0,
      );
    }

    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, sourceTextureA);
    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE1);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, sourceTextureB);

    gl.useProgram(blend);
    gl.uniform2f(
      gl.getUniformLocation(blend, 'u_resolution'),
      resolution.$1,
      resolution.$2,
    );
    gl.uniform1i(
      gl.getUniformLocation(blend, 'u_mode'),
      mode.shaderValue,
    );
    gl.uniform1i(
      gl.getUniformLocation(blend, 'u_a'),
      0,
    );
    gl.uniform1i(
      gl.getUniformLocation(blend, 'u_b'),
      1,
    );

    gl.drawArrays(web.WebGL2RenderingContext.TRIANGLES, 0, 6);
  }

  void usePaperTextureProgram({
    required (int, int) resolution,
    required Size paperSize,
    required web.WebGLTexture sourceTexture,
    required web.WebGLTexture paperTexture,
    web.WebGLTexture? targetTexture,
  }) {
    if (targetTexture == null) {
      gl.bindFramebuffer(web.WebGL2RenderingContext.FRAMEBUFFER, null);
    } else {
      gl.framebufferTexture2D(
        web.WebGL2RenderingContext.FRAMEBUFFER,
        web.WebGL2RenderingContext.COLOR_ATTACHMENT0,
        web.WebGL2RenderingContext.TEXTURE_2D,
        targetTexture,
        0,
      );
    }

    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE0);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, sourceTexture);
    gl.activeTexture(web.WebGL2RenderingContext.TEXTURE1);
    gl.bindTexture(web.WebGL2RenderingContext.TEXTURE_2D, paperTexture);

    gl.useProgram(paper);
    gl.uniform2f(
      gl.getUniformLocation(paper, 'u_resolution'),
      resolution.$1,
      resolution.$2,
    );
    gl.uniform2f(
      gl.getUniformLocation(paper, 'u_paper_size'),
      paperSize.width,
      paperSize.height,
    );
    gl.uniform1i(
      gl.getUniformLocation(paper, 'u_sampler'),
      0,
    );
    gl.uniform1i(
      gl.getUniformLocation(paper, 'u_paper'),
      1,
    );

    gl.drawArrays(web.WebGL2RenderingContext.TRIANGLES, 0, 6);
  }
}
