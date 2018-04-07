/// @description
cpx = 0;
cpy = 0;
cpz = 0;
cvx = 0;
cvy = 0;
cvz = 1;
cux = 0;
cuy = -1;
cuz = 0;
roll = 0;
pitch = 20;
rad = 5;
yaw = 0;

var dw2 = display_get_width() / 2;
var dh2 = display_get_height() / 2;
display_mouse_set( dw2, dh2 );

var projmat = matrix_build_projection_perspective_fov(90, view_wport / view_hport, 1, 1000);
camera_set_proj_mat( view_camera, projmat);

buff_cube = model_load_obj( ASSETS + "cube.obj" );
env_spr = sprite_add(ASSETS + "clouds.jpg",0,false,true,0,0);
env_tex = sprite_get_texture( env_spr, 0 );