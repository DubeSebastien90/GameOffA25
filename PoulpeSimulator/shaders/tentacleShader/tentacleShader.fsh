varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float pixelH;
uniform float springs[10];
uniform float springCount;
uniform float u_perpDirX;
uniform float u_perpDirY;

void main()
{
    vec2 p = v_vTexcoord;

    // Interpolation entre joints
    int chunk = int(floor(p.x * springCount));
    int nextChunk = int(min(float(chunk + 1), springCount - 1.0));
    float chunkPercent = (p.x * springCount) - float(chunk);

    float offset = mix(springs[chunk], springs[nextChunk], chunkPercent);

    // Décalage perpendiculaire
    p.x += u_perpDirX * offset / pixelH;
    p.y += u_perpDirY * offset / pixelH;

    // clamp pour éviter disparition
    p.x = clamp(p.x, 0.0, 1.0);
    p.y = clamp(p.y, 0.0, 1.0);

    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, p);
}
