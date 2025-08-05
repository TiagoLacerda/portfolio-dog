#version 460 core

#extension GL_GOOGLE_include_directive : enable

#include <flutter/runtime_effect.glsl>

#ifdef GL_ES
precision mediump float;
#endif

uniform float r;
uniform float g;
uniform float b;
uniform vec2 uSize;
uniform sampler2D uTexture;

out vec4 fragColor;

vec2 FlutterFragCoord();

void main() {
  vec2 uv = FlutterFragCoord().xy / uSize;
  vec4 color = texture(uTexture, uv);
  fragColor = color * vec4(r, g, b, 1.0);
}