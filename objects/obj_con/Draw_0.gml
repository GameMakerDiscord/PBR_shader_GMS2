/// @description
var camx, camy, camz;
draw_clear( c_dkgray );
with obj_camera 
{
    camx = cpx;
    camy = cpy;
    camz = cpz;
    event_perform( ev_draw, 0 );
}

var sha = sha_pbr_fwd;
shader_set( sha );
shader_set_float(   "u_LightDirection", -1,1,0 );
shader_set_float(   "u_Camera", camx, camy, camz );
shader_set_float(   "u_LightColor", 1,1,1);
shader_set_sampler( "u_equirect_spec", tex_equirect_spec );
shader_set_sampler( "u_brdfLUT", tex_brdfLUT );

var uni = shader_get_sampler_index( sha, "u_equirect_spec" );
gpu_set_tex_max_mip_ext( uni, 0 );

shader_set_sampler( "u_emission", tex_emv );
shader_set_sampler( "u_normal", tex_nrm );
shader_set_sampler( "u_MetalicRoughnessSampler", tex_arm );

vertex_submit( buff, pr_trianglelist, tex_alb );

shader_reset();