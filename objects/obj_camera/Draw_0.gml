/// setting up camera view matrix
var cam = view_camera;
var viewmat = matrix_build_lookat( cpx, cpy, cpz, cpx + cvx, cpy + cvy, cpz + cvz, cux, cuy, cuz );
camera_set_view_mat(cam, viewmat);
var projmat = matrix_build_projection_perspective_fov(-45, view_wport / view_hport, 1, 1000);
camera_set_proj_mat( view_camera, projmat);
camera_apply(cam);

/// draw environment
var sha = sha_env_equirect;
shader_set( sha );
var uni = shader_get_sampler_index( sha, "gm_BaseTexture" ); // this sampler shoudn't use mipmaps
gpu_set_tex_max_mip_ext( uni, 0 );
var s = -512;
var mtx = matrix_build( cpx, cpy, cpz, 0, 0, 0, s, s, s );
matrix_set( matrix_world, mtx );
vertex_submit( buff_cube, pr_trianglelist, env_tex );
matrix_set( matrix_world, matrix_build_identity() );
shader_reset();