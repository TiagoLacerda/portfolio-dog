#version 460 core

#extension GL_GOOGLE_include_directive : enable

#include <flutter/runtime_effect.glsl>

#ifdef GL_ES
precision mediump float;
#endif

uniform float u_width;
uniform float u_height;

uniform sampler2D u_blurred_s;
uniform sampler2D u_blurred_l;

out vec4 fragColor;

vec2 FlutterFragCoord();

void main() {
  vec2 coordinates = FlutterFragCoord() / vec2(u_width, u_height);
  
  vec4 s = texture(u_blurred_s, coordinates);
  vec4 l = texture(u_blurred_l, coordinates);

  vec4 dog = l - s;

  fragColor = dog;
}
