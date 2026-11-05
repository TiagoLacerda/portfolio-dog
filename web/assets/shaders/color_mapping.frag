#version 300 es
precision highp float;
precision highp sampler2D;

out vec4 outColor;

uniform vec2 u_resolution;
uniform int u_n;
uniform int u_use_color_mapping;

uniform sampler2D u_sampler;
uniform sampler2D u_colors;

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    float luminance = texture(u_sampler, uv).r;
    float n = float(u_n);
    float q = floor(luminance * (n - 1.0f) + 0.5f) / (n - 1.0f);

    vec3 color = vec3(q);

    if(u_use_color_mapping == 1) {
        color = texture(u_colors, vec2(q, 0.5f)).rgb;
    }

    outColor = vec4(color, 1.0f);
}
