#version 300 es
precision mediump float;

out vec4 outColor;

uniform vec2 u_resolution;

uniform sampler2D u_sampler;

vec2 eigenvalues(float E, float F, float G) {
    float base = E + G;
    float root = sqrt(pow(E - G, 2.0f) + 4.0f * F * F);

    return vec2(base + root, base - root) / 2.0f;
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    vec3 tensor = texture(u_sampler, uv).xyz;
    float E = tensor.x;
    float G = tensor.y;
    float F = tensor.z;

    vec2 lambda = eigenvalues(E, F, G);

    vec2 v1 = vec2(F, lambda.x - E);
    // vec2 v2 = vec2(lambda.y - G, F);

    outColor = vec4(v1.x, v1.y, 0.0f, 1.0f);
    // outColor = texture(u_sampler, uv);
}