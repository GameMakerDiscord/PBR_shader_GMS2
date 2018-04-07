/// @param name
/// @param params
var name    = argument[0];
var uni     = shader_get_uniform( shader_current(), name );
switch argument_count - 1
{
    case 1:
        shader_set_uniform_f( uni, argument[1] );
    break;
    case 2:
        shader_set_uniform_f( uni, argument[1], argument[2] );
    break;
    case 3:
        shader_set_uniform_f( uni, argument[1], argument[2], argument[3] );
    break;
    case 4:
        shader_set_uniform_f( uni, argument[1], argument[2], argument[3], argument[4] );
    break;
}