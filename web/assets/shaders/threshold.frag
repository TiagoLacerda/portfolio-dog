#version 300 es
precision highp float;
precision highp sampler2D;

out vec4 outColor;

uniform vec2 u_resolution;
uniform float u_epsilon;
uniform float u_phi;

uniform sampler2D u_sampler;

float threshold(float u, float epsilon, float phi) {
    return u >= epsilon ? 1.0f : 1.0f + tanh(phi * (u - epsilon));
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    float u = texture(u_sampler, uv).r;
    outColor = vec4(vec3(threshold(u, u_epsilon, u_phi)), 1.0f);
}
