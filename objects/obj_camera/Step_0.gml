/// @description
if mouse_wheel_up() rad /= 1.1;
if mouse_wheel_down() rad *= 1.1;
var mx  = display_mouse_get_x();
var my  = display_mouse_get_y();
var dw2 = display_get_width() / 2;
var dh2 = display_get_height() / 2;
var mdx = mx - dw2;
var mdy = my - dh2;
display_mouse_set( dw2, dh2 );
yaw += mdx * .5;
pitch -= mdy * .5;
pitch = clamp( pitch, -89, 89 );

cpx = -rad * dsin(yaw) * dcos(-pitch);
cpy = -rad * dsin(-pitch);
cpz = rad * dcos(yaw) * dcos(-pitch);
cvx = -cpx;
cvy = -cpy;
cvz = -cpz;
cux = 0;
cuy = 1;
cuz = 0;
