#version 300 es
precision mediump float;

out vec4 outColor;

uniform vec2 u_resolution;
uniform float u_sigma_m;

uniform sampler2D u_sampler;
uniform sampler2D u_flow;

float gaussian(float x, float sigma) {
    return exp(-(x * x) / (2.0f * sigma * sigma));
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

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    float tang = LIC(u_sampler, u_flow, u_resolution, uv, int(u_sigma_m * 2.5f), u_sigma_m);
    outColor = vec4(vec3(tang), 1.0f);
}