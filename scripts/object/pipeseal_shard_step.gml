#define pipeseal_shard_step

x += xsp;
y += ysp;
if (ysp < 16) {
    ysp += obj_player.grv;
    if (ysp > 16) {
        ysp = 16;
    }
}
if ((y-8)>=(obj_camera.y+CAMERA_HEIGHT)) {
    instance_destroy();
}

image_index = prevImageIndex;

