#version 300 es
precision highp float;
precision highp sampler2D;

out vec4 outColor;

uniform vec2 u_resolution;

uniform sampler2D u_sampler;

vec2 sobel(sampler2D sampler, vec2 resolution, vec2 uv) {
    vec2 d = 1.0f / resolution;

    float tl = texture(sampler, uv + d * vec2(-1.0f, -1.0f)).r;
    float l  = texture(sampler, uv + d * vec2(-1.0f,  0.0f)).r;
    float bl = texture(sampler, uv + d * vec2(-1.0f,  1.0f)).r;
    float t  = texture(sampler, uv + d * vec2( 0.0f, -1.0f)).r;
    float b  = texture(sampler, uv + d * vec2( 0.0f,  1.0f)).r;
    float tr = texture(sampler, uv + d * vec2( 1.0f, -1.0f)).r;
    float r  = texture(sampler, uv + d * vec2( 1.0f,  0.0f)).r;
    float br = texture(sampler, uv + d * vec2( 1.0f,  1.0f)).r;

    float gx = -tl - 2.0f * l - bl + tr + 2.0 * r + br;
    float gy = -tl - 2.0f * t - tr + bl + 2.0 * b + br;

    return vec2(gx, gy);
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;

    vec2 g = sobel(u_sampler, u_resolution, uv);

    outColor = vec4(g.x * g.x, g.x * g.y, g.y * g.y, 1.0f);
}