#define object_player_camera_y

if (obj_player.vFocalPoint == DEFAULT_VFOCALPOINT) {
    if ((obj_player.y-(5*(obj_player.jumping||obj_player.rolling)))
    !=  (obj_camera.y+obj_player.vFocalPoint)) {
        var diff,spd;
        diff = (obj_camera.y+obj_player.vFocalPoint)-obj_player.y;
        spd = 4*(abs(obj_player.ysp)<obj_player.top)
        + obj_player.top*(abs(obj_player.ysp)==obj_player.top)
        + abs(diff)*(abs(obj_player.ysp)>obj_player.top);
        obj_camera.y = median(
            obj_camera.y - sign(diff)*min(spd,abs(diff)),
            CAMERA_BBOUND-CAMERA_HEIGHT,
            CAMERA_UBOUND
        );
        view_yview[CAMERA_0] = obj_camera.y;
    }
} else {
    obj_camera.y = obj_player.y-obj_player.vFocalPoint;
    view_yview[CAMERA_0] = obj_camera.y;
}

