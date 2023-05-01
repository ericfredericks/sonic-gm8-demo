#define player_groundinput
braking = false;

if (!canBrake) {
    canBrake = abs(gsp)>3.5;
}
if (ang
||  (gsp==0)
||  (obj_input.xAxis==0)
||  jumping
||  rolling) {
    canBrake = false;
}

if (((obj_input.xAxis < 0)&&!controlLock)
&& !horizontalLockTime) {
    if (gsp > 0) {
        gsp -= dec;
        if (canBrake) {
            braking = true;
        }
    }
    else if (gsp > -top) {
        gsp -= acc;
        if (gsp < -top) {
            gsp = -top;
        }
    }
}
else
if ((((obj_input.xAxis > 0)&&!controlLock)||holdRight)
&& !horizontalLockTime) {
    if (gsp < 0) {
        gsp += dec;
        if (canBrake) {
            braking = true;
        }
    }
    else if (gsp < top) {
        gsp += acc;
        if (gsp > top) {
            gsp = top;
        }
    }
}
else {
    gsp -= sign(gsp)*min(frc,abs(gsp));
}

