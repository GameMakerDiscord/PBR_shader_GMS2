/// @param string
/// @param delimiter
var delim, str, pos, ind, a, len;
str = argument0;
delim = argument1;
pos = string_pos(delim,str);
ind = 0;
a = [];
while(pos > 0) {
    var s = string_copy(str,1,pos - 1);
    a[ind] = s;
    ind++;
    len = string_length(str) - pos;
    str = string_copy(str,pos + 1,len);
    pos = string_pos(delim,str);
}
a[ind] = string_copy(str,1,string_length(str));
return a;
