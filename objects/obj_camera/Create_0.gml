// in this demo we using polar camera
cpx     = 0;    // camera position x
cpy     = 0;    // camera position y
cpz     = 0;    // camera position z
cvx     = 0;    // camera view x
cvy     = 0;    // camera view y
cvz     = 1;    // camera view z
cux     = 0;    // camera up x
cuy     = -1;   // camera up y
cuz     = 0;    // camera up z
pitch   = 20;   // camera pitch
yaw     = 0;    // camera yaw
rad     = 5;    // caera radius

var dw2 = display_get_width() / 2;
var dh2 = display_get_height() / 2;
display_mouse_set( dw2, dh2 );

// setting up camera projection matrix
var projmat = matrix_build_projection_perspective_fov(90, view_wport / view_hport, 1, 1000);
camera_set_proj_mat( view_camera, projmat);

buff_cube = model_load_obj( ASSETS + "cube.obj" );
env_spr = sprite_add(ASSETS + "clouds.jpg",0,false,true,0,0);
env_tex = sprite_get_texture( env_spr, 0 );