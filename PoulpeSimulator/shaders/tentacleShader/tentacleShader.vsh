//
// Tentacle vertex shader
//
attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_spriteW;
uniform float u_spriteH;
uniform float u_springCount;
uniform float u_springs[10]; // Ajuste selon ton nombre max
uniform float u_perpX;
uniform float u_perpY;

void main()
{
    vec4 pos = vec4(in_Position, 1.0);
    v_vTexcoord = in_TextureCoord;
    v_vColour = in_Colour;

    // Convertir coordonnée texture → indice de segment
    float t = 1.0 - in_TextureCoord.y;
    float idx = t * (u_springCount - 1.001); // petit epsilon
	int i = int(floor(idx));
	float f = fract(idx);
	float offset = mix(u_springs[i], u_springs[i + 1], f);

    // Appliquer le déplacement perpendiculaire
    pos.x += u_perpX * offset * 5.0;
	pos.y += u_perpY * offset * 5.0;

    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * pos;
}
