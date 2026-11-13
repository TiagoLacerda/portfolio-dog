#version 300 es
precision highp float;
precision highp sampler2D;

#define MODE_NONE 0
#define MODE_LINEAR 1
#define MODE_TWO_POINT_LINEAR 2
#define MODE_BICUBIC 3

out vec4 outColor;

uniform vec2 u_resolution;
uniform int u_mode;

uniform sampler2D u_a;
uniform sampler2D u_b;

float linearThrough(float x, float a, float c) {
    return x < a ? mix(0.0f, c, x / a) : mix(c, 1.0f, (x - a) / (1.0f - a));
}

float cubicThrough(float x, float a, float c) {
    return (x * x * ((c - a * a) * x + (a * a * a - c))) / (a * a * (a - 1.0f));
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    vec3 a = texture(u_a, uv).rgb;
    vec3 b = texture(u_b, uv).rgb;

    vec3 color;

    if(u_mode == MODE_LINEAR) {
        color = a * b;
    } else if(u_mode == MODE_TWO_POINT_LINEAR) {
        color = vec3(linearThrough(b.r, 0.5f, a.r), linearThrough(b.g, 0.5f, a.g), linearThrough(b.b, 0.5f, a.b));
    } else if(u_mode == MODE_BICUBIC) {
        color = vec3(cubicThrough(b.r, 0.5f, a.r), cubicThrough(b.g, 0.5f, a.g), cubicThrough(b.b, 0.5f, a.b));
    } else {
        color = b;
    }

    outColor = vec4(color, 1.0f);
}
