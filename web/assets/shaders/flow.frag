#version 300 es
precision highp float;
precision highp sampler2D;

#define ERR 1e-12f

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

    // Both of these are eigenvectors of lambda.x, but each one collapses to zero on some axis-aligned edges:
    // the first when F = 0 and E >= G, the second when F = 0 and G >= E. The longer one is always usable.
    vec2 a = vec2(F, lambda.x - E);
    vec2 b = vec2(lambda.x - G, F);
    vec2 major = dot(a, a) > dot(b, b) ? a : b;
    float lengthSquared = dot(major, major);

    // Isotropic regions have no orientation, which is signaled to the following passes with zero vectors.
    // The flow texture is a float target, so vectors are stored signed, without remapping.
    vec2 v1 = lengthSquared > ERR ? major * inversesqrt(lengthSquared) : vec2(0.0f);
    vec2 v2 = vec2(v1.y, -v1.x);

    outColor = vec4(v1, v2);
}