#define pipespring_step

image_index = prevImageIndex;
beingPushed = false;

object_solid(false,false,true,false);

if (!beingStoodOn) {
    if ((obj_player.x >= (x-16))
    &&  (obj_player.x < (x+16))
    &&  (obj_player.y >= y)
    &&  (obj_player.y < (y+32))) {
        if (animOffset != 0) {
            animOffset = 0;
            animate = true;
            animIndex = 0;
            fc = 0;
        }
    }
}
if (beingPushed) {
    object_player_camera_x();
}
object_being_stood_on();
if (beingStoodOn) {
    animOffset = 8;
    animate = true;
    animIndex = 0;
    fc = 0;
    obj_player.y += 4;
    obj_player.ysp = -pow;
    obj_player.standingOnObject = false;
    beingStoodOn = false;
    obj_player.sprung = true;
    obj_player.jumping = true;
    if (!obj_player.rolling && !obj_player.jumping) {
        obj_player.y += 5;
        obj_player.w = W_CURL;
        obj_player.h = H_CURL;
    }
}
if (animate) {
    if (animIndex == 0) {
        durFrame = global.pipespring_anim[animOffset+animIndex];
        animIndex += 1;
        fc = durFrame;
    }
    if (global.pipespring_anim[animOffset+animIndex] == $FF) {
        animate = false;
    }
    if (animate) {
        if (fc == durFrame) {
            image_index = global.pipespring_anim[animOffset+animIndex];
            animIndex += 1;
            fc = 0;
        }
        fc += 1;
    }
}

prevImageIndex = image_index;

