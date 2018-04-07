/// @description
application_surface_enable(false);
var w = 1920;
var h = 1080;
view_visible = true;
view_enabled = true;
var cam = view_camera;
camera_set_view_size( cam, w, h );
window_set_size( w, h );
view_wport = w;
view_hport = h;
var px = (display_get_width() - w ) * .5;
var py = (display_get_height() - h ) * .5;
window_set_position( px, py );
window_set_fullscreen(true);
display_reset(0,1);

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_normal();
vertex_format_add_texcoord();
vertex_format_add_colour();
global.vertex_format = vertex_format_end()

cube = model_load_obj( ASSETS + "cube.obj" );

tex_brdfLUT             = sprite_get_texture( spr_brdf_LUT, 0 );
spr_radiance            = sprite_add( ASSETS + "clouds_radiance.jpg",0,false,true,0,0);
tex_equirect_spec       = sprite_get_texture( spr_radiance, 0 );

var name = "helmet";
buff = model_load_obj(ASSETS + name + ".obj");
tex_alb     = sprite_get_texture( sprite_add(ASSETS + name + "_alb.jpg",0,false,true,0,0), 0 );
tex_arm     = sprite_get_texture( sprite_add(ASSETS + name + "_arm.jpg",0,false,true,0,0), 0 );
tex_nrm     = sprite_get_texture( sprite_add(ASSETS + name + "_nrm.jpg",0,false,true,0,0), 0 );
tex_emv     = sprite_get_texture( sprite_add(ASSETS + name + "_emv.jpg",0,false,true,0,0), 0 );

angle = 0;
gpu_set_texfilter(true);
gpu_set_texrepeat(true);
gpu_set_zwriteenable(true);
gpu_set_ztestenable(true);
gpu_set_cullmode(cull_counterclockwise);
gpu_set_tex_mip_filter( tf_anisotropic );

instance_create_layer( x, y, layer, obj_camera );