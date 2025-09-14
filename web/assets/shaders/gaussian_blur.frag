#version 300 es
precision mediump float;

out vec4 outColor;

uniform vec2 u_resolution;
uniform vec2 u_direction;
uniform int u_radius;
uniform float u_sigma;

uniform sampler2D u_sampler;

float gaussian(float x, float sigma) {
    return exp(-(x * x) / (2.0f * sigma * sigma));
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;

    vec2 d = normalize(u_direction) / u_resolution; // Assume direction in normalized in CPU.

    vec3 color = texture(u_sampler, uv).rgb;
    float sum = 1.0f;

    for(int i = 1; i < u_radius; ++i) {
        float k = float(i);
        float w = gaussian(k, u_sigma);
        color += texture(u_sampler, uv + d * k).rgb * w;
        color += texture(u_sampler, uv - d * k).rgb * w;
        sum += w + w;
    }

    color /= sum;

    outColor = vec4(color, 1.0f);
}
