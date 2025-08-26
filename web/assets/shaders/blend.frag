#version 300 es
precision mediump float;

out vec4 outColor;

uniform vec2 u_resolution;

uniform sampler2D u_a;
uniform sampler2D u_b;

float cubicThrough(float x, float a, float c) {
    return (x * x * ((c - a * a) * x + (a * a * a - c))) / (a * a * (a - 1.0f));
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    vec4 a = texture(u_a, uv);
    vec4 b = texture(u_b, uv);

    float r = cubicThrough(b.r, 0.5f, a.r);
    float g = cubicThrough(b.g, 0.5f, a.g);
    float B = cubicThrough(b.b, 0.5f, a.b);

    outColor = vec4(r, g, B, 1.0f);
    // outColor = a * b;

}