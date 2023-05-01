#define camera_pos

if (!xLocked) {
    x += xsp;
    view_xview[CAMERA_0] = x + pan;
}
y += ysp;
view_yview[CAMERA_0] = y;

if (!xLocked) {
    tile_layer_shift(BACKGROUND_LAYER,((x+pan)-(prevX+prevPan))/2,0);
}
tile_layer_shift(BACKGROUND_LAYER,0,(y-prevY)/2);
prevX = x;
prevPan = pan;
prevY = y;

