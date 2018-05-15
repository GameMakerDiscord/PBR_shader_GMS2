///@arg {string} fileneme
var buffer = buffer_load(argument0);
var vbuff = vertex_create_buffer_from_buffer(buffer, global.vertex_format);
vertex_freeze(vbuff);
buffer_delete(buffer);
return vbuff;