#version 460 core

#extension GL_GOOGLE_include_directive : enable

#include <flutter/runtime_effect.glsl>

#ifdef GL_ES
precision mediump float;
#endif

#define MAX_RADIUS 31

uniform float u_width;
uniform float u_height;
uniform float u_radius;
uniform float u_horizontal;
uniform float u_weights[MAX_RADIUS + 1];

uniform sampler2D u_sampler;

out vec4 fragColor;

vec2 FlutterFragCoord();

void main() {
  vec2 coordinates = FlutterFragCoord() / vec2(u_width, u_height);
  vec2 direction = u_horizontal == 1 ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
  vec2 offset = direction / vec2(u_width, u_height);
  vec4 color = texture(u_sampler, coordinates) * u_weights[0];

  for(int i = 1; i < MAX_RADIUS + 1; ++i) {
    float index = float(i);

    if(index > u_radius) {
      break;
    }

    color += texture(u_sampler, coordinates + offset * index) * u_weights[i];
    color += texture(u_sampler, coordinates - offset * index) * u_weights[i];
  }

  fragColor = color;
}
