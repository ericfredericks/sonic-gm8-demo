#define player_landing
// shallow
if ((ang <= 23)
|| (ang > 338)) {
    gsp = xsp;
}
// half steep
if (((ang > 23)&&(ang <= 45))
|| ((ang > 315)&&(ang <= 338))) {
    gsp = ysp*0.5*-sign(sin(degtorad(ang)));
    if (abs(xsp) > ysp) {
        gsp = xsp;
    }
}
// full steep
if (((ang > 45)&&(ang<=90))
|| ((ang>270)&&(ang <=315))) {
    gsp = ysp*-sign(sin(degtorad(ang)));
    if (abs(xsp)>ysp) {
        gsp = xsp;
    }
}
// slope
if (((ang > 90)&&(ang <= 135))
|| ((ang>225)&&(ang<=270))) {
    gsp = ysp*-sign(sin(degtorad(ang)));
}
// ceiling
if ((ang > 135)&&(ang<=225)) {
    ysp = 0;
}

