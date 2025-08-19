#version 300 es
precision mediump float;

out vec4 outColor;

uniform vec2 u_resolution;
uniform float u_sigma;
uniform float u_k;
uniform float u_tau;
uniform float u_epsilon;
uniform float u_phi;

uniform sampler2D u_sampler;
uniform sampler2D u_flow;

float gaussian(float x, float sigma) {
    return exp(-(x * x) / (2.0f * sigma * sigma));
}

float blur_orthogonal(
    sampler2D sampler,
    vec2 resolution,
    vec2 direction,
    vec2 uv,
    int radius,
    float sigma
) {
    vec2 offset = direction / resolution;

    float value = 0.0f;
    float sum = 0.0f;

    for(int i = -radius; i <= radius; ++i) {
        float w = gaussian(float(i), sigma);
        value += texture(sampler, uv + offset * float(i)).r * w;
        sum += w;
    }

    return value / sum;
}

float threshold(float u, float epsilon, float phi) {
    return u >= epsilon ? 1.0f : 1.0f + tanh(phi * (u - epsilon));
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    int radius = max(5, int(3.0f * u_sigma));

    vec4 flow = texture(u_flow, uv); // orth.xy, tang.xy
    float small = blur_orthogonal(u_sampler, u_resolution, flow.xy, uv, radius, u_sigma);
    float large = blur_orthogonal(u_sampler, u_resolution, flow.xy, uv, radius, u_sigma * u_k);
    float u = ((1.0f + u_tau) * small) - (u_tau * large);

    float orth = threshold(u, u_epsilon, u_phi);

    outColor = vec4(vec3(orth), 1.0f);
}