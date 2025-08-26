#version 300 es
precision mediump float;

out vec4 outColor;

uniform vec2 u_resolution;

uniform sampler2D u_sampler;

/// Return the eigenvalues such that the first value is higher than (or equal to) the second.
vec2 eigenvalues(float E, float F, float G) {
    float base = (E + G);
    float root = sqrt(((E - G) * (E - G)) + (4.0f * F * F));
    return 0.5f * vec2(base + root, base - root);
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution;

    vec3 S = texture(u_sampler, uv).xyz;

    float E = S.x;
    float F = S.y;
    float G = S.z;

    vec2 lambda = eigenvalues(E, F, G);

    // jkyprian's paper defines eigenvector as follows, and states that they are intentionally not normalized...
    // vec2 v1 = vec2(F, lambda.x - E);
    // vec2 v2 = vec2(lambda.y - G, F);

    // ...which differs from Acerola's definition of the eigenvector that points to the direction of least change (DoG video at 5:15).
    // vec2 v2 = vec2(lambda.x - E, -F);

    // This is jkyprian's definition, but normalized to unit length and remapped to [0, 1] range, as textures are setup to hold unsigned values.
    // vec2 v2 = vec2(F, lambda.x - E) * 0.5f + 0.5f;
    // vec2 v1 = vec2(lambda.y - G, F) * 0.5f + 0.5f;

    // ... and this would be Acerola's.
    vec2 v2 = normalize(vec2(lambda.x - E, -F)) * 0.5f + 0.5f;
    vec2 v1 = normalize(vec2(-F, E - lambda.x)) * 0.5f + 0.5f;

    outColor = vec4(v1, v2);
}