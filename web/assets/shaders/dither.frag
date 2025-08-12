#version 300 es
precision mediump float;

out vec4 outColor;

uniform vec2 u_resolution;
uniform float u_s;

uniform sampler2D u_sampler;

const float[16] bayer4x4 = float[16](0.0f, 12.0f, 3.0f, 15.0f, 8.0f, 4.0f, 11.0f, 7.0f, 2.0f, 14.0f, 1.0f, 13.0f, 10.0f, 6.0f, 9.0f, 5.0f);

void main() {
  vec2 uv = gl_FragCoord.xy / u_resolution;
  int x = int(gl_FragCoord.x) % 4;
  int y = int(gl_FragCoord.y) % 4;
  float noise = bayer4x4[y * 4 + x] / 16.0f - 0.5f;
  vec4 color = texture(u_sampler, uv);
  outColor = vec4(color.rgb + noise * u_s, color.a);
}