/// setting up camera view matrix
var cam = view_camera;
var viewmat = matrix_build_lookat( cpx, cpy, cpz, cpx + cvx, cpy + cvy, cpz + cvz, cux, cuy, cuz );
camera_set_view_mat(cam, viewmat);
var projmat = matrix_build_projection_perspective_fov(-45, view_wport / view_hport, 1, 1000);
camera_set_proj_mat( view_camera, projmat);
camera_apply(cam);