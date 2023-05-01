#define box_platform_step

beingPushed = false;

object_solid(false,false,false,false);

object_being_stood_on();
if (beingStoodOn) {
    obj_player.y = y-h-obj_player.h-1;
    object_player_camera_y();
}
if (beingPushed) {
    object_player_camera_x();
}

