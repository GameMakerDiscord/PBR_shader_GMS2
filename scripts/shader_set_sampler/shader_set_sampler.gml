///@description set shader sampler
///@arg {string}    name
///@arg {texture}   texture
var name    = argument[0];
var sampler = shader_get_sampler_index( shader_current(), name );
texture_set_stage( sampler, argument[1] );