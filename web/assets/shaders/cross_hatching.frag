#version 300 es
precision highp float;
precision highp sampler2D;

out vec4 outColor;

uniform vec2 u_resolution;
uniform vec2 u_hatch_size;
uniform vec4 u_angles;
uniform vec4 u_thresholds;
uniform float u_phi;

uniform sampler2D u_sampler;
uniform sampler2D u_edges;
uniform sampler2D u_hatch_1;
uniform sampler2D u_hatch_2;
uniform sampler2D u_hatch_3;
uniform sampler2D u_hatch_4;

float threshold(float u, float epsilon, float phi) {
    return u >= epsilon ? 1.0f : 1.0f + tanh(phi * (u - epsilon));
}

float hatch(sampler2D hatchTexture, float angle, float epsilon, float tone) {
    float c = cos(angle);
    float s = sin(angle);
    vec2 uv = mat2(c, s, -s, c) * gl_FragCoord.xy / u_hatch_size;

    // Textures arrive with premultiplied alpha, so transparent texels are composited over white.
    vec4 texel = texture(hatchTexture, uv);
    float stroke = texel.r + 1.0f - texel.a;

    return mix(stroke, 1.0f, threshold(tone, epsilon, u_phi));
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    float tone = texture(u_sampler, uv).r;
    float edges = texture(u_edges, uv).r;

    float hatching = hatch(u_hatch_1, u_angles.x, u_thresholds.x, tone) *
        hatch(u_hatch_2, u_angles.y, u_thresholds.y, tone) *
        hatch(u_hatch_3, u_angles.z, u_thresholds.z, tone) *
        hatch(u_hatch_4, u_angles.w, u_thresholds.w, tone);

    outColor = vec4(vec3(edges * hatching), 1.0f);
}
