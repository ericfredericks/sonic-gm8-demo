#define object_player_camera_y_falling

if (obj_player.vFocalPoint == DEFAULT_VFOCALPOINT) {
    if ((obj_player.y+obj_player.ysp)>(obj_camera.y+obj_player.vFocalPoint+32)) {        
        obj_camera.y = min(
            obj_player.y+obj_player.ysp-(obj_player.vFocalPoint+32),
            CAMERA_BBOUND-CAMERA_HEIGHT);
        view_yview[CAMERA_0] = obj_camera.y;
    }
    if ((obj_player.y+obj_player.ysp)<(obj_camera.y+obj_player.vFocalPoint-32)) {
        obj_camera.y = max(
            obj_player.y+obj_player.ysp-(obj_player.vFocalPoint-32),
            CAMERA_UBOUND);
        view_yview[CAMERA_0] = obj_camera.y;
    }
} else {
    obj_camera.y = obj_player.y-obj_player.vFocalPoint;
    view_yview[CAMERA_0] = obj_camera.y;
}

