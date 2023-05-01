#define staircase_step

// in footage the staircase seems to wait ~16 frames before moving
// and the furthest box "leads" going up/down 1px

if (!stoodOnOnce) {
    var i;
    for (i=0;i<4;i+=1) {
        if (box[i].beingStoodOn) {
            stoodOnOnce = true;
            break;
        }
    }
}
if ((fc < (16+96+1))
&&  (fc >= 16)) {
    if (behavior == $00) {if (stoodOnOnce) {behavior = $01;}}
    else if (behavior == $01) {
        box[1].y += 1/3;
        box[2].y += 2/3;
        box[3].y += 1;
    }
    if (behavior == $04) {if (stoodOnOnce) {behavior = $05;}}
    else if (behavior == $05) {
        box[1].y -= 1/3;
        box[2].y -= 2/3;
        box[3].y -= 1;
    }
}
if (stoodOnOnce) {
    if (fc < (16+96+2)) {fc += 1;}
}

