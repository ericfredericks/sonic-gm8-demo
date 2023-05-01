#define ballsnake_step

if (phase == INIT) {
    ysp = -4.5;
    var i,amtBalls,waitPhase,o;
    amtBalls = param & $0F;
    if (param & $F0) {waitPhase = WAIT_2;}
    else {waitPhase = WAIT_1;}
    o = id;
    for (i=0;i<amtBalls;i+=1) {
        if (i > 0) {
            o = instance_create(x,y,obj_ballsnake);
        }
        o.phase = waitPhase;
        o.startX = o.x;
        o.startY = o.y;
        o.ysp = ysp;
        o.startYsp = o.ysp;
        o.xoff = 96;
        o.xacc = 0.042968;
        o.xaccSwap = false;
        o.depth = PRIORITY_LAYER_LOW;
        o.xsp = 0;
        if (xflip) {
            o.xacc = -o.xacc;
            o.xoff = -o.xoff;
        }
        o.countdown = i*3;
    }
    exit;
}
if ((phase == WAIT_1)||(phase == WAIT_2)) {
    countdown -= 1;
    if (!(countdown < 0)) {exit;}
    if (phase == WAIT_1) {phase = MOVE_ARC;}
    if (phase == WAIT_2) {phase = MOVE_STRAIGHT;}
    countdown = 59;
    exit;
}
if (phase == MOVE_ARC) {
    x += xsp;
    y += ysp;
    xsp += xacc;
    ysp += 0.09375;
    if (ysp >= 0 && !xaccSwap) {
        xacc = -xacc;
        xaccSwap = true;
    }
    if (y >= startY) {
        ysp = startYsp;
        xsp = 0;
        phase = WAIT_1;
        xaccSwap = false;
    }
    exit;
}
if (phase == MOVE_STRAIGHT) {
    x += xsp;
    y += ysp;
    ysp += 0.09375;
    if (ysp >= 0) {
        x = startX + xoff;
    }
    if (y >= startY) {
        ysp = startYsp;
        x = startX;
        phase = WAIT_2;
    }
    exit;
}

