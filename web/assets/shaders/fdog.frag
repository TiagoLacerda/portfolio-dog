#version 300 es
precision mediump float;

out vec4 outColor;

uniform vec2 u_resolution;
uniform float u_radius;
uniform float u_sigma_e;
uniform float u_sigma_m;
uniform float u_k;
uniform float u_tau;
uniform float u_epsilon;
uniform float u_phi;

uniform sampler2D u_texture;
uniform sampler2D u_grayscale;
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

// Gaussian-blur along the tangent flow field
float LIC(
    sampler2D grayscale,
    sampler2D flow,
    vec2 resolution,
    vec2 uv,
    int radius,
    float sigma
) {
    float weight = gaussian(0.0f, sigma);
    float total = weight;

    float value = texture(grayscale, uv).r * weight;

    // Travel forward along the flow line
    vec2 st = uv;
    vec2 oldTangent = texture(flow, uv).zw;

    for(int i = 1; i <= radius; ++i) {
        vec2 tangent = texture(flow, st).zw / resolution;
        if(dot(oldTangent, tangent) > 0.0f) {
            // Angle is smaller than between oldTangent, -tangent
            st += tangent;
        } else {
            // Angle is bigger than between oldTangent, -tangent
            st -= tangent;
        }
        weight = gaussian(float(i), sigma);
        value += texture(grayscale, st).r * weight;
        total += weight;
    }

    // Travel backward along the flow line
    st = uv;
    oldTangent = texture(flow, uv).zw;

    for(int i = 1; i <= radius; ++i) {
        vec2 tangent = texture(flow, st).zw / resolution;
        if(dot(oldTangent, tangent) > 0.0f) {
            // Angle is smaller than between oldTangent, -tangent
            st -= tangent;
        } else {
            // Angle is bigger than between oldTangent, -tangent
            st += tangent;
        }
        weight = gaussian(float(i), sigma);
        value += texture(grayscale, st).r * weight;
        total += weight;
    }

    return value / total;
}

float threshold(float u, float epsilon, float phi) {
    return u >= epsilon ? 1.0f : 1.0f + tanh(phi * (u - epsilon));
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;

    vec4 flow = texture(u_flow, uv); // orth.xy, tang.xy

    float small = blur_orthogonal(u_grayscale, u_resolution, flow.xy, uv, int(u_sigma_e * 2.5f), u_sigma_e);
    float large = blur_orthogonal(u_grayscale, u_resolution, flow.xy, uv, int(u_sigma_e * 2.5f), u_sigma_e * u_k);
    float u = ((1.0f + u_tau) * small) - (u_tau * large);

    float orth = threshold(u, u_epsilon, u_phi);
    float tang = LIC(u_grayscale, u_flow, u_resolution, uv, int(u_sigma_m * 2.5f), u_sigma_m);

    outColor = vec4(vec3(orth), 1.0f);
}