#define rotating_floor_step

image_index = prevImageIndex;

if (image_index < 2) {object_solid(false,true,true,false);}

object_being_stood_on();
if (beingStoodOn) {
    if (image_index > 1) {
        obj_player.standingOnObject = false;
        obj_player.falling = true;
        beingStoodOn = false;
    }
}

if ((fc == animFrame) && !animating) {
    animating = true;
    fc = 0;
}
if (animating) {
    if (!rotated) {
        if (fc == 16) {
            animating = false;
            fc = 0;
            rotated = true;
            animFrame = 48;
        }
        else if (!(fc&$03)) {image_index += 1;}
    }
    else {
        if (fc == 16) {
            animating = false;
            fc = 0;
            rotated = false;
            animFrame = 48;
        }
        else if (!(fc&$03)) {image_index -= 1;}
    }
}

prevImageIndex = image_index;
fc += 1;

