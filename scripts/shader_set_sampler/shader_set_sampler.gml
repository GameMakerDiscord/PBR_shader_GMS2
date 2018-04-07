/// @param name
/// @param texture
var name    = argument[0];
var sampler = shader_get_sampler_index( shader_current(), name );
texture_set_stage( sampler, argument[1] );