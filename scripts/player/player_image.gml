#define player_image
image_angle = 0;
if (!jumping&&!rolling&&!braking) {
    image_angle = round(ang/45)*45;
}
if (!falling) {
    if (sign(gsp)!=0) {
        image_xscale = sign(gsp);
    }
} else {
    if (sign(xsp)!=0) {
        image_xscale = sign(xsp);
    }
}
image_index = 0;
if (balancing) {image_index = 2;}
if (jumping||rolling) {image_index = 1;}
if (braking) {image_index = 4;}
if (looking) {image_index = 5;}
if (ducking) {image_index = 6;}
if (spindash) {image_index = 3;}
if (!balancing
&&  !braking
&&  !jumping
&&  !rolling
&&  !looking
&&  !ducking) {
    if (!falling) {
        if ((gsp!=0) && !pushingObject) {
            image_index = 7;
        }
    } else {
        if (!standingOnObject || (xsp != 0)) {
            image_index = 7;
        }
    }
}

