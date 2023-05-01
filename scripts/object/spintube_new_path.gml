#define spintube_new_path

var X;
X = argument0;
var Y;
if (X < 0) {
    obj_spintube.path = -4;
    buffer_set_pos(global.obj1e_maintube,(-X)<<1);
    X = word_swap(buffer_read_uint16(global.obj1e_maintube));
    buffer_set_pos(global.obj1e_maintube,X);
    Y = word_swap(buffer_read_uint16(global.obj1e_maintube)) - 4;
    buffer_set_pos(global.obj1e_maintube,X+2+Y);
    obj_player.x = word_swap(buffer_read_uint16(global.obj1e_maintube));
    obj_player.y = word_swap(buffer_read_uint16(global.obj1e_maintube));
    buffer_set_pos(global.obj1e_maintube,X+2+Y-4);
}
else {
    buffer_set_pos(global.obj1e_maintube,X<<1);
    X = word_swap(buffer_read_uint16(global.obj1e_maintube));
    buffer_set_pos(global.obj1e_maintube,X);
    Y = word_swap(buffer_read_uint16(global.obj1e_maintube)) - 4;
    obj_player.x = word_swap(buffer_read_uint16(global.obj1e_maintube));
    obj_player.y = word_swap(buffer_read_uint16(global.obj1e_maintube));
}
return Y;

