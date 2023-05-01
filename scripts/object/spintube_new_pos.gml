#define spintube_new_pos
var C,D;
C = argument0;
D = argument1;
var A,B,DX,DY;
A = 1; B = 1;
DX = C - obj_player.x;
if (DX < 0) {A = -1;}
DY = D - obj_player.y;
if (DY < 0) {B = -1;}

if (abs(DX) <= abs(DY)) {
    DY = abs(floor(DY/8));
    if (DX != 0) {DX = floor(DX/DY);}
    obj_player.xsp = DX;
    obj_player.ysp = 8 * sign(B);
    return DY;
}
DX = abs(floor(DX/8));
if ((DY!=0)&&(DX!=0)) {DY = floor(DY/DX);}
obj_player.ysp = DY;
obj_player.xsp = 8 * sign(A);
return DX;

