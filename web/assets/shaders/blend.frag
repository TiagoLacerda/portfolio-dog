#version 300 es
precision mediump float;

out vec4 outColor;

uniform vec2 u_resolution;

uniform sampler2D u_a;
uniform sampler2D u_b;

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    vec4 a = texture(u_a, uv);
    vec4 b = texture(u_b, uv);

    // outColor = b.r < 0.5f ? mix(vec4(0.0f), a, b.r * 2.0f) : mix(a, vec4(1.0f), (b.r - 0.5f) * 2.0f);
    // outColor = b;
    outColor = a * b;
}