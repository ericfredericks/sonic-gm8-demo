#define player_spindash
if (ducking) {
    spinrev -= min((spinrev div 0.125)/256,spinrev);
    if (obj_input.aBtn && !obj_input.aHold) {
        spindash = true;
        spinrev = min(spinrev+2,8);
    }
}
else {
    if (spindash) {
        gsp = image_xscale * (8+(floor(spinrev)/2));
        spindash = false;
        rolling = true;
        y += 5;
        h = H_CURL;
        w = W_CURL;
    }
    spinrev = 0;
}

