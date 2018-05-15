/// setting up camera and environment
var camx, camy, camz;
draw_clear( c_dkgray );
with obj_camera 
{
    camx = cpx;
    camy = cpy;
    camz = cpz;
    event_perform( ev_draw, 0 );
}

/// setting up shader, light direction and color, camera position,
/// reflection sampler, BRDF LUT sampler
/// helmet texture samplers
var sha = sha_pbr_fwd;
shader_set( sha );
shader_set_float(   "u_LightDirection", -1,1,0 );
shader_set_float(   "u_Camera", camx, camy, camz );
shader_set_float(   "u_LightColor", 1,1,1);
shader_set_sampler( "u_equirect_spec", tex_equirect_spec );
shader_set_sampler( "u_brdfLUT", tex_brdfLUT );
shader_set_sampler( "u_emission", tex_emv );
shader_set_sampler( "u_normal", tex_nrm );
shader_set_sampler( "u_MetalicRoughnessSampler", tex_arm );
var uni = shader_get_sampler_index( sha, "u_equirect_spec" ); /// this sampler shouldn't use mipmaps
gpu_set_tex_max_mip_ext( uni, 0 );
gpu_set_cullmode(cull_clockwise);
vertex_submit( buff, pr_trianglelist, tex_alb );
shader_reset();

/// draw skybox
var sha = sha_env_equirect;
shader_set( sha );
var uni = shader_get_sampler_index( sha, "gm_BaseTexture" ); // this sampler shoudn't use mipmaps
gpu_set_tex_max_mip_ext( uni, 0 );
var s = -512;
var mtx;
with obj_camera mtx = matrix_build( cpx, cpy, cpz, 0, 0, 0, s, s, s );
matrix_set( matrix_world, mtx );
gpu_set_cullmode(cull_noculling);
vertex_submit( buff_cube, pr_trianglelist, env_tex );
matrix_set( matrix_world, matrix_build_identity() );
shader_reset();