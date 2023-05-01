#define player_jump
if (!spindash
&& obj_input.aBtn
&& !obj_input.aHold
&& !controlLock
&& !looking
&& !ducking
&& !jumping) {
    var heightJ;
    heightJ = player_J();
    if (heightJ < (TILE_SIZE+6)) {
        if (!rolling) {
            y += 5;
            w = W_CURL;
            h = H_CURL;
        }
        jumping = true;
        horizontalLockTime = 0;
    }
}

