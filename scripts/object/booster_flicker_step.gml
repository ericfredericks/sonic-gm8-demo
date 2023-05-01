#define booster_flicker_step

if ((obj_player.x >= (x-w))
&&  (obj_player.x <= (x+w))
&&  (obj_player.y >= (y-h))
&&  (obj_player.y <= (y+h))) {
    if (!hflip) {obj_player.gsp = pow;}
    else {obj_player.gsp = -pow;}
}

visible = true;
if (fc mod 2) {
    visible = false;
}

fc += 1;
if (fc > 255) {fc = 0;}

