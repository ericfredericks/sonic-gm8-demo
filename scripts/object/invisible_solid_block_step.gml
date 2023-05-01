#define invisible_solid_block_step

beingPushed = false;

object_solid(false,false,false,false);

if (beingPushed) {
    object_player_camera_x();
}
object_being_stood_on();
if (beingStoodOn) {
    object_player_camera_y();
}

