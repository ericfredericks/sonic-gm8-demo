#define spring_step

beingPushed = false;

object_solid(false,false,false,false);

if (beingPushed) {
    if ((facing == RIGHT) && (obj_player.x>x)) {
        obj_player.x -= 8;
        obj_player.xsp = pow;
        obj_player.gsp = pow;
        obj_player.pushingObject = false;
        beingPushed = false;
        fc = 3;
        obj_player.horizontalLockTime = 16;
    }
    if ((facing == LEFT) && (obj_player.x<x)) {
        obj_player.x += 8;
        obj_player.xsp = -pow;
        obj_player.gsp = -pow;
        obj_player.pushingObject = false;
        beingPushed = false;
        fc = 3;
        obj_player.horizontalLockTime = 16;
    }
    object_player_camera_x();
}
object_being_stood_on();
if (beingStoodOn) {
    if (facing == UP) {
        obj_player.y += 8;
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
        fc = 3;
    }
}

image_index = 0;
if (fc == 1) {image_index = 1;}
if (fc > 0) {fc -= 1;}

