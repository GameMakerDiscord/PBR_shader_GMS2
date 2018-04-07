#extension GL_OES_standard_derivatives : enable

varying vec3 v_Normal;
varying vec4 v_Colour;
varying vec2 v_UV;
varying vec3 v_Position;

uniform vec3 u_LightDirection;
uniform vec3 u_Camera;
uniform vec3 u_LightColor;
uniform sampler2D u_MetalicRoughnessSampler;
uniform sampler2D u_emission;
uniform sampler2D u_normal;
uniform sampler2D u_equirect_spec;
uniform sampler2D u_brdfLUT;

const float PI = 3.141592653589793;
const float PI2 = PI * 2.0;
const float c_MinRoughness = 0.04;

float microfacetDistribution(float cos_theta, float rough_sqr) {
    float rough_quad = rough_sqr * rough_sqr;
    float cos_sqr = cos_theta * cos_theta;
    float k = cos_sqr * rough_quad + (1.0 - cos_sqr);
    return rough_quad / ( PI * k * k );
}

float geometricOcclusion(float cos_theta, float rough_sqr) {
    float cos_sqr = cos_theta * cos_theta;
    float tan2 = ( 1. - cos_sqr ) / cos_sqr;
    float geom = 2. / ( 1. + sqrt( 1. + rough_sqr * rough_sqr * tan2 ) );
    return geom;
}

vec3 specularReflection(float VH, vec3 reflectance0, vec3 reflectance90)
{
    return reflectance0 + (reflectance90 - reflectance0) * pow(clamp(1.0 - VH, 0.0, 1.0), 5.0);
}

vec4 srgb_to_linear( vec4 srgbIn )
{
    vec3 linOut = pow(srgbIn.rgb, vec3(2.2));
    return vec4( linOut, srgbIn.a );
}

vec2 envMapEquirect( vec3 ray ) {
  return vec2((atan(ray.z, ray.x) / PI2 ) + 0.5, 1.0 - acos(ray.y) / PI );
}

vec3 getIBLContribution(float roughness, float NV, vec3 in_diff, vec3 in_spec, vec3 n, vec3 reflection)
{
    float lod = floor( roughness * 7.0 );
    float spec_off = 1.0 - pow( 2.0, -lod );
    vec3 brdf = srgb_to_linear(texture2D(u_brdfLUT, vec2( NV, 1.0 - roughness ))).rgb;
    vec2 diff_uv = envMapEquirect( -n );
    diff_uv = clamp( diff_uv, .01, .99 );
    diff_uv = ( diff_uv * vec2( 1.0, 0.5 ) + 1.0 ) * .5;
    vec2 spec_uv = envMapEquirect( -reflection );
    spec_uv *= pow( 2.0, -lod );
    float uv_offset = mix(.001,.009, roughness );
    spec_uv = clamp( spec_uv, uv_offset, 1.0 - uv_offset );
    spec_uv.t = spec_uv.t * .5 + spec_off;
    vec3 diffuseLight = srgb_to_linear( texture2D(u_equirect_spec, diff_uv ) ).rgb;
    vec3 specularLight = srgb_to_linear( texture2D(u_equirect_spec, spec_uv ) ).rgb;
    vec3 diffuse_clr = diffuseLight * in_diff;
    vec3 specular_clr = specularLight * ( in_spec * brdf.x + brdf.y);
    
    return diffuse_clr + specular_clr;
}

vec3 getNormal()
{
    vec3 pos_dx = dFdx( v_Position );
    vec3 pos_dy = dFdy( v_Position );
    vec3 tex_dx = dFdx(vec3( v_UV, 0.0 ));
    vec3 tex_dy = dFdy(vec3( v_UV, 0.0 ));
    vec3 t = ( tex_dy.t * pos_dx - tex_dx.t * pos_dy ) / ( tex_dx.s * tex_dy.t - tex_dy.s * tex_dx.t );
    vec3 ng = normalize( v_Normal );
    t = normalize( t - ng * dot(ng, t) );
    vec3 b = normalize(cross( ng, t) );
    mat3 tbn = mat3( t, b, ng );
    vec3 n = texture2D( u_normal, v_UV ).rgb;
    n = normalize( tbn * ((2.0 * n - 1.0) ));
    return n;
}

void main()
{
    vec4 metalrough = texture2D( u_MetalicRoughnessSampler, v_UV );
    float roughness = clamp(metalrough.g, c_MinRoughness, 1.0);
    float metallic = clamp(metalrough.b, 0.0, 1.0);
    float rough_sqr = roughness * roughness;
    vec4 baseColor = srgb_to_linear( texture2D( gm_BaseTexture, v_UV ) );
    vec3 f0 = vec3(0.04);
    vec3 diffuseColor = baseColor.rgb * (vec3(1.0) - f0);
    diffuseColor *= 1.0 - metallic;
    vec3 specularColor = mix(f0, baseColor.rgb, metallic);
    float reflectance = max(max(specularColor.r, specularColor.g), specularColor.b);
    float reflectance90 = clamp(reflectance * 25.0, 0.0, 1.0);
    vec3 specularEnvironmentR0 = specularColor.rgb;
    vec3 specularEnvironmentR90 = vec3(reflectance90);
    
    vec3 n = getNormal();
    vec3 v = normalize(u_Camera - v_Position);
    vec3 l = normalize(u_LightDirection);
    vec3 h = normalize( v + l );
    vec3 reflection = -normalize(reflect(v, n));
    float NL = clamp(dot(n, l), 0.001, 1.0);
    float NV = abs(dot(n, v)) + 0.001;
    float NH = clamp(dot(n, h), 0.0, 1.0);
    float VH = clamp(dot(v, h), 0.0, 1.0);
    
    vec3  F = specularReflection( VH, specularEnvironmentR0, specularEnvironmentR90 );
    float G = geometricOcclusion( NV, rough_sqr) * geometricOcclusion( NL, rough_sqr);
    float D = microfacetDistribution( NH, rough_sqr);

    vec3 diffuseContrib = (1.0 - F) * diffuseColor / PI;
    vec3 specContrib = F * G * D / (4.0 * NL * NV);
    vec3 clr = NL * u_LightColor * (diffuseContrib + specContrib);
    
    /// IMAGE BASED LIGHTING
    clr += getIBLContribution( roughness, NV, diffuseColor, specularColor, n, reflection);
    
    /// AMBIENT OCLUSION
    clr *= texture2D( u_MetalicRoughnessSampler, v_UV ).r;
    
    /// EMISSION
    clr += srgb_to_linear(texture2D(u_emission, v_UV)).rgb;;
    
    gl_FragColor =  vec4( pow(clr,vec3(1.0/2.2)), 1.0 );
}