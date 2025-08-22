#version 300 es
precision mediump float;

out vec4 outColor;

uniform vec2 u_resolution;

uniform sampler2D u_sampler;

/// Return the eigenvalues such that the first value is higher than (or equal to) the second.
vec2 eigenvalues(float E, float F, float G) {
    float base = 0.5f * (E + G);
    float root = 0.5f * sqrt(pow(E - G, 2.0f) + 4.0f * F * F);
    return vec2(base + root, base - root);
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;
    vec3 S = texture(u_sampler, uv).xyz;
    float E = S.x; // Gx * Gx
    float G = S.y; // Gy * Gy
    float F = S.z; // Gx * Gy

    vec2 lambda = eigenvalues(E, F, G);

    // jkyprian's paper defines eigenvector as follows, and states that they are intentionally not normalized...
    vec2 v1 = normalize(vec2(F, lambda.x - E));
    vec2 v2 = normalize(vec2(lambda.y - G, F));

    // ...which differs from Acerola's definition of the eigenvector that points to the direction of least change (DoG video at 5:15).
    // vec2 t = vec2(lambda.x - E, -F);

    outColor = vec4(v1.x, v1.y, v2.x, v2.y);
}