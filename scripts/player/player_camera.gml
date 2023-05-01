#define player_camera

if ((x-w+xsp)<CAMERA_LBOUND) {
    x = CAMERA_LBOUND + w;
    xsp = 0;
    gsp = 0;
}

var panLeftCond,panRightCond;
panLeftCond = (obj_input.lBtn&&!obj_input.lHold);
panRightCond = (obj_input.rBtn&&!obj_input.rHold);
if (panRightCond && obj_camera.pan==0 && obj_camera.panChange==0) {
    obj_camera.panChange = 64;
    obj_camera.panSpd = 2;
}
if (panLeftCond && obj_camera.pan>0 && obj_camera.panChange==0) {
    obj_camera.panChange = -obj_camera.pan;
    obj_camera.panSpd = 2;
}
if (panLeftCond && obj_camera.pan==0 && obj_camera.panChange==0) {
    obj_camera.panChange = -64;
    obj_camera.panSpd = 2;
}
if (panRightCond && obj_camera.pan<0 && obj_camera.panChange==0) {
    obj_camera.panChange = -obj_camera.pan;
    obj_camera.panSpd = 2;
}
/*
// KEEP -- auto camera
panLeftCond = (xsp == top);
panRightCond = (xsp == -top);
if (panRightCond && obj_camera.pan==0 && obj_camera.panChange==0) {
    obj_camera.panChange = 64;
    obj_camera.panSpd = 2;
}
if (obj_camera.pan>0 && xsp<0 && obj_camera.panChange==0) {
    obj_camera.panChange = -obj_camera.pan;
    obj_camera.panSpd = 2;
}
if (panLeftCond && obj_camera.pan==0 && obj_camera.panChange==0) {
    obj_camera.panChange = -64;
    obj_camera.panSpd = 2;
}
if (obj_camera.pan<0 && xsp>0 && obj_camera.panChange==0) {
    obj_camera.panChange = -obj_camera.pan;
    obj_camera.panSpd = 2;
}
*/
if (!obj_camera.xLocked) {
    if ((x+xsp)>(obj_camera.x+CAMERA_W2)) {
        if ((x+xsp)<=(CAMERA_RBOUND-CAMERA_W2-obj_camera.pan)) {
            obj_camera.x = x+xsp-CAMERA_W2;
            view_xview[CAMERA_0] = x+xsp-CAMERA_W2+obj_camera.pan;
        }
        else {
            obj_camera.pan = max(0,
            CAMERA_RBOUND-CAMERA_W2-(x+xsp));
            if (obj_camera.pan > 0) {
                obj_camera.x = x+xsp-CAMERA_W2;
                view_xview[CAMERA_0] = x+xsp-CAMERA_W2+obj_camera.pan;
            } else {
                obj_camera.x = CAMERA_RBOUND-CAMERA_WIDTH;
                view_xview[CAMERA_0] = CAMERA_RBOUND-CAMERA_WIDTH;
            }
        }
    }
    if ((x+xsp)<(obj_camera.x+CAMERA_W2)) {
        if ((x+xsp)>=(CAMERA_LBOUND+CAMERA_W2-obj_camera.pan)) {
            obj_camera.x = x+xsp-CAMERA_W2;
            view_xview[CAMERA_0] = x+xsp-CAMERA_W2+obj_camera.pan;
        }
        else {
            obj_camera.pan = min(0,
            CAMERA_LBOUND+CAMERA_W2-(x+xsp));
            if (obj_camera.pan < 0) {
                obj_camera.x = x+xsp-CAMERA_W2;
                view_xview[CAMERA_0] = x+xsp-CAMERA_W2+obj_camera.pan;       
            } else {
                obj_camera.x = CAMERA_LBOUND;
                view_xview[CAMERA_0] = CAMERA_LBOUND;
            }
        }
    }
}

if (looking) {
    if (vFocalPoint < UPPER_VFOCALPOINT) {
        vFocalPoint += 2;
        if (vFocalPoint > UPPER_VFOCALPOINT) {
            vFocalPoint = UPPER_VFOCALPOINT;
        }
    }
    obj_camera.y = y+ysp-vFocalPoint;
    view_yview[CAMERA_0] = obj_camera.y;
}
else {
    if (vFocalPoint != DEFAULT_VFOCALPOINT) {
        if ((y+ysp)<=(obj_camera.y+DEFAULT_VFOCALPOINT)) {
            vFocalPoint = DEFAULT_VFOCALPOINT;
        }
    }
    if (vFocalPoint > DEFAULT_VFOCALPOINT) {
        vFocalPoint -= 2;
        if (vFocalPoint < DEFAULT_VFOCALPOINT) {
            vFocalPoint = DEFAULT_VFOCALPOINT;
        }
        obj_camera.y = y+ysp-vFocalPoint;
        view_yview[CAMERA_0] = obj_camera.y;
    }
}

if (falling) {
    if (vFocalPoint == DEFAULT_VFOCALPOINT) {
        if ((y+ysp)>(obj_camera.y+vFocalPoint+32)) {        
            obj_camera.y = min(
                y+ysp-(vFocalPoint+32),
                CAMERA_BBOUND-CAMERA_HEIGHT);
            view_yview[CAMERA_0] = obj_camera.y;
        }
        if ((y+ysp)<(obj_camera.y+vFocalPoint-32)) {
            obj_camera.y = max(
                y+ysp-(vFocalPoint-32),
                CAMERA_UBOUND);
            view_yview[CAMERA_0] = obj_camera.y;
        }
    }
}
else {
    if (vFocalPoint == DEFAULT_VFOCALPOINT) {
        if ((y+ysp-(5*(jumping||rolling)))!=(obj_camera.y+vFocalPoint)) {
            var diff,spd;
            diff = (obj_camera.y+vFocalPoint)-(y+ysp);
            spd = 4*(abs(ysp)<top)
            + top*(abs(ysp)==top)
            + abs(diff)*(abs(ysp)>top);
            obj_camera.y = median(
                obj_camera.y - sign(diff)*min(spd,abs(diff)),
                CAMERA_BBOUND-CAMERA_HEIGHT,
                CAMERA_UBOUND
            );
            view_yview[CAMERA_0] = obj_camera.y;
        }
    }
}

