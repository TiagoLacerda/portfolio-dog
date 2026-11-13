#version 300 es
precision highp float;
precision highp sampler2D;

out vec4 outColor;

uniform vec2 u_resolution;
uniform vec2 u_paper_size;

uniform sampler2D u_sampler;
uniform sampler2D u_paper;

void main() {
    vec3 color = texture(u_sampler, gl_FragCoord.xy / u_resolution).rgb;
    vec3 paper = texture(u_paper, gl_FragCoord.xy / u_paper_size).rgb;

    outColor = vec4(color * paper, 1.0f);
}
