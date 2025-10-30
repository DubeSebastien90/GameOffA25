// shd_tentacle.fsh (Fragment Shader)
varying vec4 v_vColour;
varying vec2 v_vTexcoord;

//uniform sampler2D gm_BaseTexture;

void main()
{
    vec4 texel = texture2D(gm_BaseTexture, v_vTexcoord);

    gl_FragColor = v_vColour * texel;
}