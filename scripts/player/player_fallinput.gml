#define player_fallinput

if (!sprung
&&  jumping
&&  !obj_input.aBtn
&&  (ysp < -4)) {
    ysp = -4;
}

if (((obj_input.xAxis < 0)&&!controlLock)
&&  !horizontalLockTime) {
    if (xsp > -top) {
        xsp -= air;
        if (xsp < -top) {
            xsp = -top;
        }
    }
}
else
if ((((obj_input.xAxis > 0)&&!controlLock)||holdRight)
&&  !horizontalLockTime) {
    if (xsp < top) {
        xsp += air;
        if (xsp > top) {
            xsp = top;
        }
    }
}

if ((ysp < 0)
&& (ysp > -4)
&& (abs(xsp)>0.125)) {
    xsp *= 0.96875;
}

