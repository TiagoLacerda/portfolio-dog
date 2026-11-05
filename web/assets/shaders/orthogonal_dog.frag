#version 300 es
precision highp float;
precision highp sampler2D;

#define ERR 1e-4f

out vec4 outColor;

uniform vec2 u_resolution;
uniform int u_radius_small;
uniform int u_radius_large;
uniform float u_sigma;
uniform float u_k;
uniform float u_tau;

uniform sampler2D u_sampler;
uniform sampler2D u_flow;

float gaussian(float x, float sigma) {
    // The center tap would be 0/0 for a sigma of zero.
    float s = max(sigma, ERR);
    return exp(-(x * x) / (2.0f * s * s));
}

float blur(
    sampler2D sampler,
    vec2 resolution,
    vec2 direction,
    vec2 uv,
    int radius,
    float sigma
) {
    if(dot(direction, direction) < ERR)
        return texture(sampler, uv).r;

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

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    
    vec2 gradient = texture(u_flow, uv).xy;

    float small = blur(u_sampler, u_resolution, gradient, uv, u_radius_small, u_sigma);
    float large = blur(u_sampler, u_resolution, gradient, uv, u_radius_large, u_sigma * u_k);
    float u = ((1.0f + u_tau) * small) - (u_tau * large);

    // Unbounded response. It's thresholded only after being integrated along the tangent flow.
    outColor = vec4(vec3(u), 1.0f);
}