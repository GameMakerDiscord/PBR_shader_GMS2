
attribute vec3 in_Position;                     // (x,y,z)
attribute vec3 in_Normal;                       // (x,y,z)
attribute vec2 in_TextureCoord;                 // (u,v)
attribute vec4 in_Colour;                       // (r,g,b,a)

varying vec3 v_Normal;
varying vec4 v_Colour;
varying vec2 v_UV;
varying vec3 v_Position;

void main()
{
    vec4 pos = vec4( in_Position, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * pos;
    
    v_Position = vec3( gm_Matrices[ MATRIX_WORLD ] * pos );
    v_Normal = normalize( vec3(gm_Matrices[ MATRIX_WORLD ] * vec4(in_Normal.xyz, 0.0)));
    v_UV = in_TextureCoord;
    v_Colour = in_Colour;
}
