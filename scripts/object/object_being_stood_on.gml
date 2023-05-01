#define object_being_stood_on
if (beingStoodOn
&& (!obj_player.standingOnObject||(obj_player.standingOnObject!=id))) {
    beingStoodOn = false;
}
if (beingStoodOn) {
    var xDist,combinedWidth;
    combinedWidth = w+obj_player.W_PUSH+1;
    xDist = (obj_player.x-x) + combinedWidth;
    if ((xDist < 0) || (xDist >= (combinedWidth*2))) {
        obj_player.standingOnObject = false;
        obj_player.falling = true;
        beingStoodOn = false;
    }
}

