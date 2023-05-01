#define moving_box_platform_step

if (!global.oscillatedThisFrame) {
    object_oscillate();
    global.oscillatedThisFrame = true;
}
if (behavior == $01) {
    xoffOsc = global.oscData8;
    if (xflip) {xoffOsc = -xoffOsc + 64;}
    xoffOsc = -xoffOsc;
}
if (behavior == $02) {
    xoffOsc = global.oscData28;
    if (xflip) {xoffOsc = -xoffOsc + 96;}
    xoffOsc = -xoffOsc;
}
if (behavior == $03) {
    yoffOsc = global.oscData8;
    if (xflip) {yoffOsc = -yoffOsc + 64;}
    yoffOsc = -yoffOsc;
}
if (behavior == $04) {
    yoffOsc = global.oscData28;
    if (xflip) {yoffOsc = -yoffOsc + 128;}
    yoffOsc = -yoffOsc;
}
if (behavior == $05) {
    if (beingStoodOn) {behavior = $06;}
}
else if (behavior == $06) {
    yoffSpd += 0.03125; // 8 * 1/256
    yoffOsc += yoffSpd;
    var i;
    i = startY + yoffOsc;
    if (i > (CAMERA_BBOUND + 224)) {behavior = $00;}
}
if (behavior == $07) {
    if (yoffAcc == 0) {
        if (beingStoodOn) {yoffAcc = 8;}
    }
    if (yoffAcc != 0) {
        if (yoffSpd == 680) {yoffAcc = -yoffAcc;}
        yoffSpd += yoffAcc;
        yoffOsc += yoffSpd;
        if (yoffSpd == 0) {behavior = $00;}
    }
}
if (behavior == $08) {
    // y here might actually be an x value, or vice versa
    // depends on where the platform is in its square of movement
    yoffOsc = 16;
    xoffOsc = global.oscData40 / 2;
    xoffSpd = global.oscSpeed40;
}
if (behavior == $09) {
    yoffOsc = 48;
    xoffOsc = global.oscData44;
    xoffSpd = global.oscSpeed44;
}
if (behavior == $0a) {
    yoffOsc = 80;
    xoffOsc = global.oscData48;
    xoffSpd = global.oscSpeed48;
}
if (behavior == $0b) {
    yoffOsc = 112;
    xoffOsc = global.oscData52;
    xoffSpd = global.oscSpeed52;
}
if ((behavior == $08)
||  (behavior == $09)
||  (behavior == $0a)
||  (behavior == $0b)) {
    if (abs(xoffSpd) < 0.001) {
        rotatingStatus += 1;
        rotatingStatus &= $3;
    }
    var j;
    j = rotatingStatus;
    while (true) {
        if (j == 0) {
            xoffOsc = xoffOsc - yoffOsc;
            yoffOsc = -yoffOsc;
            break;
        }
        j -= 1;
        if (j == 0) {
            var i;
            i = yoffOsc;
            yoffOsc = -(xoffOsc - (yoffOsc-1));
            xoffOsc = i;
            break;
        }
        j -= 1;
        if (j == 0) {
            xoffOsc = -(xoffOsc - (yoffOsc-1));
            break;
        }
        var i;
        i = yoffOsc;
        yoffOsc = xoffOsc - yoffOsc;
        xoffOsc = -i;
        break;
    }
}
x = startX + xoffOsc;
y = startY + yoffOsc;

beingPushed = false;

object_solid(false,false,false,true);

object_being_stood_on();
if (beingStoodOn) {
    var xOnLanding2;
    xOnLanding += obj_player.xsp;
    xOnLanding2 = floor(xOnLanding);
    obj_player.x = startX+xoffOsc+xOnLanding2;
    obj_player.y = startY+yoffOsc-h-obj_player.h-1;
    object_player_camera_y();
    object_player_camera_x();
}
if (beingPushed) {
    object_player_camera_x();
}

