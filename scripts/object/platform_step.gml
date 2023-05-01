#define platform_step

if (!global.oscillatedThisFrame) {
    object_oscillate();
    global.oscillatedThisFrame = true;
}

if (behavior == $00) {
    xoffOsc = global.oscData8;
    if (xflip) {xoffOsc = -xoffOsc + 64;}
    xoffOsc = -xoffOsc;
}
if (behavior == $01) {
    xoffOsc = global.oscData12;
    if (xflip) {xoffOsc = -xoffOsc + 96;}
    xoffOsc = -xoffOsc;
}
if (behavior == $02) {
    yoffOsc = global.oscData28;
    if (xflip) {yoffOsc = -yoffOsc + 128;}
    yoffOsc = -yoffOsc;
}
if (behavior == $03) {
    if (beingStoodOn) {behavior = $04;}
}
else if (behavior == $04) {
    var i;
    i = yoff - 96;
    if (i < y) {yoffSpd -= 0.03125;} // 8 * 1/256
    else {yoffSpd += 0.03125;}
    if (abs(yoffSpd) < 0.001) {behavior = $05;}
    yoffOsc += yoffSpd;
}
if (behavior == $06) {
    var i;
    i = yoff - 96;
    if (i < y) {yoffSpd -= 0.03125;}
    else {yoffSpd += 0.03125;}
    yoffOsc += yoffSpd;
}
if (behavior == $07) {
    var i;
    i = yoff + 96;
    if (i < y) {yoffSpd -= 0.03125;}
    else {yoffSpd += 0.03125;}
    yoffOsc += yoffSpd;
}
if ((behavior == $08)
||  (behavior == $09)
||  (behavior == $0a)
||  (behavior == $0b)) {
    xoffOsc = global.oscData56;
    xoffOsc -= 64;
    yoffOsc = global.oscData60;
    yoffOsc -= 64;
    if (behavior & $02) {
        xoffOsc = -xoffOsc;
        yoffOsc = -yoffOsc;
    }
    if (behavior & $01) {
        var i;
        xoffOsc = -xoffOsc;
        i = xoffOsc;
        xoffOsc = yoffOsc;
        yoffOsc = i;
    }
}
if ((behavior == $0c)
||  (behavior == $0d)
||  (behavior == $0e)
||  (behavior == $0f)) {
    xoffOsc = global.oscData56;
    xoffOsc -= 64;
    yoffOsc = global.oscData60;
    yoffOsc -= 64;
    if (behavior & $02) {
        xoffOsc = -xoffOsc;
        yoffOsc = -yoffOsc;
    }
    if (behavior & $01) {
        var i;
        xoffOsc = -xoffOsc;
        i = xoffOsc;
        xoffOsc = yoffOsc;
        yoffOsc = i;
    }
    xoffOsc = -xoffOsc;
}
x = xoff + xoffOsc;
y = yoff + yoffOsc;

object_solid(false,true,true,true);

object_being_stood_on();
if (beingStoodOn) {
    var xOnLanding2;
    xOnLanding += obj_player.xsp;
    xOnLanding2 = floor(xOnLanding);
    obj_player.x = xoff+xoffOsc+xOnLanding2;
    obj_player.y = yoff+yoffOsc-h-obj_player.h-1;
    object_player_camera_y();
    object_player_camera_x();
}

