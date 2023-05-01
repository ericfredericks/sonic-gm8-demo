#define oneway_step

var rl,rr;
if (xflip) {
    rr = rectRight;
    if (up) {rl = rectLeft;}
    else {rl = x;}
}
else {
    rl = rectLeft;
    if (up) {rr = rectRight;}
    else {rr = x;}
}
if ((obj_player.x >= rl)
&&  (obj_player.x <= rr)
&&  (obj_player.y >= (y-32))
&&  (obj_player.y <= (y+32))) {
    if (!obj_player.objectControl) {
        if (!up) {animate = true;}
        up = true;
    }
}
else {
    if (up) {animate = true;}
    up = false;
}

beingPushed = false;
if (!up) {
    object_solid(false,false,false,false);
    if (beingPushed) {
        object_player_camera_x();
    }
}

gate[0].image_index = gate[0].prevImageIndex;
gate[1].image_index = gate[1].prevImageIndex;
if (animate) {
    if (fc == 0) {
        gate[0].visible = false;
        gate[1].visible = false;
    }
    if (fc == 1) {
        gate[0].visible = true;
        gate[0].image_index = 0;
        gate[1].visible = false;
    }
    if (fc == 2) {
        gate[0].visible = true;
        gate[0].image_index = 1;
        gate[1].visible = false;
    }
    if (fc == 3) {
        gate[0].visible = true;
        gate[1].visible = true;
        gate[0].image_index = 1;
        gate[1].image_index = 0;
    }
    if (fc == 4) {
        gate[0].visible = true;
        gate[1].visible = true;
        gate[0].image_index = 1;
        gate[1].image_index = 1;
    }
    if (!up) {
        if (fc < 4) {fc += 1;}
        else {animate = false;}
    }
    else {
        if (fc > 0) {fc -= 1;}
        else {animate = false;}
    }
}
gate[0].prevImageIndex = gate[0].image_index;
gate[1].prevImageIndex = gate[1].image_index;

