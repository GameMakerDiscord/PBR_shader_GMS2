///@description trace values
///@arg params
var str = string(get_timer()) + " ";
var i = -1;
while(++i < argument_count) str += string(argument[i]) + " ";
show_debug_message(str);