/// @param filename
var filename        = argument0;
var file            = file_text_open_read( filename );
var objects         = [];
var vertex_list     = ds_list_create();
var normal_list     = ds_list_create();
var textur_list     = ds_list_create();
var faces_list      = noone; // ds_list
ds_list_add( vertex_list, [0,0,0] );
ds_list_add( normal_list, [0,0,0] );
ds_list_add( textur_list, [0,0] );
var object          = noone; // array
while !file_text_eof( file )
{
    var line = file_text_readln( file );
    if string_char_at( line, 1 ) == "#" then continue;
    var a = string_to_array(line," ");
    var cmd = a[0];
    switch cmd
    {
        case "mtlib":
            var mat_name = a[1];
            continue;
        break;
        case "o":
            var obj_name    = a[1];
            object = [];
            faces_list = ds_list_create();
            object[OBJ_FACE] = faces_list;
            object[OBJ_NAME] = obj_name;
            object[OBJ_TYPE] = OBJ_TYPE_NORMAL;
            array_push( objects, object );
            continue;
        break;
        case "v":
            var data = [ -real(a[1]), real(a[2]), real(a[3]) ];
            ds_list_add( vertex_list, data );
        break;
        case "vt":
            var data = [ real(a[1]), real(a[2]) ];
            ds_list_add( textur_list, data );
        break;
        case "vn":
            var data = [ -real(a[1]), real(a[2]), real(a[3]) ];
            ds_list_add( normal_list, data );
        break;
        case "l":
            var data = [ real(a[1]), real(a[2]) ];
            ds_list_add( faces_list, data );
            object[@OBJ_TYPE] = OBJ_TYPE_PATH;
        case "usemtl":
            continue;
        break;
        case "s":
            continue;
        break;
        case "f":
            var data = [];
            var i = 0;
            while ++i < array_length_1d( a )
            {
                data[i-1] = a[i];
            }
            ds_list_add( faces_list, data );
        break;
        default:
            continue;
        break;
    }
}
file_text_close(file);

var index = -1;
while ++index < array_length_1d( objects )
{
    object = objects[index];
    var type      = object[OBJ_TYPE];
    faces_list   = object[OBJ_FACE];
    if type == OBJ_TYPE_PATH then 
    {
        ds_list_destroy( faces_list );
        continue;
    }
    
    var buff = vertex_create_buffer();
    vertex_begin(buff,global.vertex_format);
    i = -1;
    while ++i < ds_list_size( faces_list )
    {
        var face_array = faces_list[|i];
        var len = array_length_1d( face_array );
        var order = [ 0, 2, 1, 3, 2, 0 ];
        var points_array = [];
        var j = -1;
        while ++j < len
        {
            var point = string_to_array( face_array[ j ], "/" );
            points_array[j] = point;
        }
        if len == 4 then len = 6;
        var tex = [0,0];
        var j = -1;
        while ++j < len
        {
            var n = order[ j ];
            var point = points_array[ n ];
            var pos = vertex_list[|real( point[ 0 ] ) ];
            if ds_list_size( textur_list ) > 1 then
                tex = textur_list[|real( point[ 1 ] ) ];
            var nrm = normal_list[|real( point[ 2 ] ) ];
            var px = pos[0];
            var py = pos[1];
            var pz = pos[2];
            var nx = nrm[0];
            var ny = nrm[1];
            var nz = nrm[2];
            var tu = tex[0];
            var tv = tex[1];
            vertex_position_3d(buff,px,py,pz);
            vertex_normal(buff,nx,ny,nz);
            vertex_texcoord(buff,tu,1-tv);
            vertex_color(buff,c_white,1);
        }
    }
    ds_list_destroy( faces_list );
    vertex_end(buff);
    vertex_freeze(buff);
    object[@OBJ_BUFF] = buff;
}

ds_list_destroy(vertex_list);
ds_list_destroy(textur_list);
ds_list_destroy(normal_list);

if array_length_1d( objects ) == 1
{
    var object = objects[0];
    return object[OBJ_BUFF];
}
else return objects;