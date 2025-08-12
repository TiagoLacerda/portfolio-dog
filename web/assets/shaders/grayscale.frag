#version 300 es
precision mediump float;

out vec4 outColor;

uniform vec2 u_resolution;

uniform sampler2D u_sampler;

float luminance(vec3 color) {
    return max(0.00001f, dot(color, vec3(0.2127f, 0.7152f, 0.0722f)));
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    outColor = vec4(vec3(luminance(texture(u_sampler, uv).rgb)), 1.0f);
}