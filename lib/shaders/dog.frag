#version 460 core

#extension GL_GOOGLE_include_directive : enable

#include <flutter/runtime_effect.glsl>

#ifdef GL_ES
precision mediump float;
#endif

uniform float u_width;
uniform float u_height;
uniform float u_epsilon;

uniform sampler2D u_blurred_s;
uniform sampler2D u_blurred_l;

out vec4 fragColor;

vec2 FlutterFragCoord();

float luminance(vec4 color) {
  return 0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b;
}

void main() {
  vec2 coordinates = FlutterFragCoord() / vec2(u_width, u_height);

  vec4 s = texture(u_blurred_s, coordinates);
  vec4 l = texture(u_blurred_l, coordinates);

  float value = luminance(l - s);

  vec4 color = value >= u_epsilon ? vec4(1.0) : vec4(0.0);

  fragColor = color;
}
