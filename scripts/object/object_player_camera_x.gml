#define object_player_camera_x

if (obj_player.x>(obj_camera.x+CAMERA_W2)) {
    if (obj_player.x<=(CAMERA_RBOUND-CAMERA_W2-obj_camera.pan)) {
        obj_camera.x = obj_player.x-CAMERA_W2;
        view_xview[CAMERA_0] = obj_player.x-CAMERA_W2+obj_camera.pan;
    }
    else {
        obj_camera.pan = max(0,
        CAMERA_RBOUND-CAMERA_W2-obj_player.x);
        if (obj_camera.pan > 0) {
            obj_camera.x = obj_player.x-CAMERA_W2;
            view_xview[CAMERA_0] = obj_player.x-CAMERA_W2+obj_camera.pan;
        } else {
            obj_camera.x = CAMERA_RBOUND-CAMERA_WIDTH;
            view_xview[CAMERA_0] = CAMERA_RBOUND-CAMERA_WIDTH;
        }
    }
}
if (obj_player.x<(obj_camera.x+CAMERA_W2)) {
    if (obj_player.x>=(CAMERA_LBOUND+CAMERA_W2-obj_camera.pan)) {
        obj_camera.x = obj_player.x-CAMERA_W2;
        view_xview[CAMERA_0] = obj_player.x-CAMERA_W2+obj_camera.pan;
    }
    else {
        obj_camera.pan = min(0,
        CAMERA_LBOUND+CAMERA_W2-obj_player.x);
        if (obj_camera.pan < 0) {
            obj_camera.x = obj_player.x-CAMERA_W2;
            view_xview[CAMERA_0] = obj_player.x-CAMERA_W2+obj_camera.pan;       
        } else {
            obj_camera.x = CAMERA_LBOUND;
            view_xview[CAMERA_0] = CAMERA_LBOUND;
        }
    }
}

