varying vec3 v_Pos; 

const float PI = 3.1415926535897932384626433832795;
const float PI2 = PI * 2.0;

void main()
{
    vec3 ray = normalize(v_Pos);
    gl_FragColor = texture2D( gm_BaseTexture, vec2((atan(ray.z, ray.x) / PI2 ) + 0.5, 1. - acos(ray.y) / PI ));
}
