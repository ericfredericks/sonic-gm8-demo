#define player_rollinput
gsp -= sign(gsp)*min(rollfrc,abs(gsp));

if (!horizontalLockTime) {
    if (((obj_input.xAxis < 0)&&!controlLock)
    && (gsp > 0)) {
        gsp -= rolldec;
        if (gsp < 0) {
            gsp = -0.5;
        }
    }
    if ((((obj_input.xAxis > 0)&&!controlLock)||holdRight)
    && (gsp < 0)) {
        gsp += rolldec;
        if (gsp > 0) {
            gsp = 0.5;
        }
    }
}

