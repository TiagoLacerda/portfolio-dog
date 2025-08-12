#version 300 es
precision mediump float;

out vec4 outColor;

uniform vec2 u_resolution;

uniform sampler2D u_sampler;

vec2 sobel(sampler2D sampler, vec2 uv, vec2 texel) {
    float tl = texture(sampler, uv + texel * vec2(-1, -1)).r;
    float l = texture(sampler, uv + texel * vec2(-1, 0)).r;
    float bl = texture(sampler, uv + texel * vec2(-1, 1)).r;
    float t = texture(sampler, uv + texel * vec2(0, -1)).r;
    float b = texture(sampler, uv + texel * vec2(0, 1)).r;
    float tr = texture(sampler, uv + texel * vec2(1, -1)).r;
    float r = texture(sampler, uv + texel * vec2(1, 0)).r;
    float br = texture(sampler, uv + texel * vec2(1, 1)).r;

    float x = -tl - 2.0f * l - bl + tr + 2.0f * r + br;
    float y = tl + 2.0f * t + tr - bl - 2.0f * b - br;

    return vec2(x, y);
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    vec2 texel = 1.0f / u_resolution;

    vec2 g = sobel(u_sampler, uv, texel);

    outColor = vec4(g.x * g.x, g.y * g.y, g.x * g.y, 1.0f);
}