#define signpost_step

image_index = prevImageIndex;

if ((obj_player.x >= x)
&&  (obj_player.x < (x+32))
&&  !active) {
    active = true;
    obj_camera.xLocked = true;
    if (!finalFrame) {
        finalFrame = 4;
    }
    secondaryActive = 1;
}

if (active) {
    if (secondaryActive == 1) {
        image_index += 1;
        if (image_index == 4) {
            image_index = 0;
        }
        spinFrame -= 1;
        if (spinFrame < 0) {
            spinFrame = 60;
            animLoop += 1;
            if (animLoop == 3) {
                secondaryActive = 2;
                image_index = finalFrame;
            }
        }
        fc -= 1;
        if (fc < 0) {
            fc = 11;
            var o;
            o = instance_create(
                x + global.signpost_sparklePos[sparkleFrame],
                y + global.signpost_sparklePos[sparkleFrame+1],
                obj_sparkle);
            o.prevImageIndex = 0;
            o.fc = 0;
            o.animLoop = 0;
            sparkleFrame += 2;
            sparkleFrame &= $e;
        }
    }
    if (secondaryActive == 2) {
        if (!obj_player.controlLock) {
            obj_player.controlLock = true;
            obj_player.holdRight = true;
        }
        if ((obj_player.x-obj_player.w) >= (obj_camera.x+CAMERA_WIDTH)) {
            secondaryActive = 0;
        }
    }
    if (secondaryActive == 0) {
        if (obj_input.startBtn) {
            game_restart();
        }
    }
}

prevImageIndex = image_index;


