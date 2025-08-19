#version 300 es
precision mediump float;

out vec4 outColor;

uniform vec2 u_resolution;
uniform int u_radius;
uniform float u_sigma;

uniform sampler2D u_sampler;

float gaussian(float x, float sigma) {
    return exp(-(x * x) / (2.0f * sigma * sigma));
}

vec3 blur(sampler2D sampler, vec2 resolution, vec2 coordinates, int radius, float sigma) {
    vec2 texelSize = 1.0f / resolution;
    vec3 color = vec3(0.0f);

    float sum = 0.0f;

    for(int i = -radius; i <= radius; ++i) {
        for(int j = -radius; j <= radius; ++j) {
            vec2 offset = vec2(i, j) * texelSize;
            float w = gaussian(float(i), sigma) * gaussian(float(j), sigma);
            color += texture(sampler, coordinates + offset).rgb * w;
            sum += w;
        }
    }

    return color / sum;
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    vec3 blurred = blur(u_sampler, u_resolution, uv, u_radius, u_sigma);
    outColor = vec4(blurred, 1.0f);
}
