#version 300 es
precision mediump float;

out vec4 outColor;

uniform vec2 u_resolution;

uniform sampler2D u_sampler;

vec4 tensor(sampler2D sampler, vec2 resolution, vec2 coordinates) {
    vec2 d = vec2(1.0f, 1.0f) / resolution;

    vec3 Sx = (1.0f * texture(sampler, coordinates + vec2(-d.x, -d.y)).rgb +
        2.0f * texture(sampler, coordinates + vec2(-d.x, 0.0f)).rgb +
        1.0f * texture(sampler, coordinates + vec2(-d.x, d.y)).rgb +
        -1.0f * texture(sampler, coordinates + vec2(d.x, -d.y)).rgb +
        -2.0f * texture(sampler, coordinates + vec2(d.x, 0.0f)).rgb +
        -1.0f * texture(sampler, coordinates + vec2(d.x, d.y)).rgb) / 4.0f;

    vec3 Sy = (1.0f * texture(sampler, coordinates + vec2(-d.x, -d.y)).rgb +
        2.0f * texture(sampler, coordinates + vec2(0.0f, -d.y)).rgb +
        1.0f * texture(sampler, coordinates + vec2(d.x, -d.y)).rgb +
        -1.0f * texture(sampler, coordinates + vec2(-d.x, d.y)).rgb +
        -2.0f * texture(sampler, coordinates + vec2(0.0f, d.y)).rgb +
        -1.0f * texture(sampler, coordinates + vec2(d.x, d.y)).rgb) / 4.0f;

    return vec4(dot(Sx, Sx), dot(Sy, Sy), dot(Sx, Sy), 1.0f);
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    vec4 S = tensor(u_sampler, u_resolution, uv);
    outColor = S;
}
