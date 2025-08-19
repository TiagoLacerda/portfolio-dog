#version 300 es
precision mediump float;

out vec4 outColor;

uniform vec2 u_resolution;
uniform float u_sigma;

uniform sampler2D u_sampler;
uniform sampler2D u_flow;

float gaussian(float x, float sigma) {
    return exp(-(x * x) / (2.0f * sigma * sigma));
}

// Gaussian-blur along the tangent flow field
vec3 LIC(
    sampler2D sampler,
    sampler2D flow,
    vec2 resolution,
    vec2 uv,
    int radius,
    float sigma
) {
    float weight = gaussian(0.0f, sigma);
    float total = weight;

    vec3 value = texture(sampler, uv).rgb * weight;

    vec2 st = uv;
    vec2 oldTangent = texture(flow, st).zw;

    for(int i = 1; i <= radius; ++i) {
        weight = gaussian(float(i), sigma);
        total += weight;

        vec2 tangent = normalize(texture(flow, st).zw);

        // Since eigenvectors don't care for orientation, let's choose the one that's more aligned with the previous tangent
        if(dot(oldTangent, tangent) < 0.0f)
            tangent = -tangent;

        oldTangent = tangent;

        st += tangent / resolution;

        value += texture(sampler, st).rgb * weight;
    }

    st = uv;
    oldTangent = texture(flow, st).zw;

    for(int i = 1; i <= radius; ++i) {
        weight = gaussian(float(i), sigma);
        total += weight;

        vec2 tangent = normalize(texture(flow, st).zw);

        if(dot(oldTangent, tangent) < 0.0f)
            tangent = -tangent;

        oldTangent = tangent;

        st -= tangent / resolution;

        value += texture(sampler, st).rgb * weight;
    }

    return value / total;
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    int radius = max(5, int(3.0f * u_sigma));
    vec3 color = LIC(u_sampler, u_flow, u_resolution, uv, radius, u_sigma);
    outColor = vec4(color, 1.0f);
}