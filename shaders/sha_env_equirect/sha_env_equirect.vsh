attribute vec3 in_Position;

varying vec3 v_Pos;

void main()
{
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4( in_Position, 1.0);;
    v_Pos = normalize(in_Position);
}
