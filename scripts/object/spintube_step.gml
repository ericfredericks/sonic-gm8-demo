#define spintube_step

if (phase == 0) {
    if (mouse_check_button(mb_left)) {exit;}
    var xDist,yDist;
    xDist = obj_player.x-x;
    if (xDist >= xRange) {exit;}
    if (xDist < 0) {exit;}
    yDist = obj_player.y-y;
    if (yDist >= 128) {exit;}
    if (yDist < 0) {exit;}
    
    var goingBackwards;
    goingBackwards = path < 0;
    
    var offset;
    if (xRange == 160) {offset = 0;}
    if (xRange == 288) {offset = 8;}
    if (xRange == 256) {
        offset = 4;
        xDist = -xDist + 160;
    }
    if ((xDist >= 128) || (xDist < 0)) {
        var i;
        i = (behavior >> 2) & $0F;
        if ((i < 10)||(i == 11)||(i == 14)) {obj_spintube.path = irandom(1);}
        if ((i == 13)||(i == 15)) {obj_spintube.path = 1;}
        else {obj_spintube.path = 0;}
    }
    else {
        obj_spintube.path = 2;
        if (yDist < 64) {obj_spintube.path = 3;}
    }

    buffer_set_pos(global.obj1e_entryexit,((path+offset)<<1)&$1E);
    offset = word_swap(buffer_read_uint16(global.obj1e_entryexit));
    buffer_set_pos(global.obj1e_entryexit,offset);
    obj_spintube.newPathTimer = word_swap(buffer_read_uint16(global.obj1e_entryexit)) - 4;
    if (goingBackwards && (path == 0)) {
        buffer_set_pos(global.obj1e_entryexit,offset+2+newPathTimer);
        obj_player.x = word_swap(buffer_read_uint16(global.obj1e_entryexit)) + x;
        obj_player.y = word_swap(buffer_read_uint16(global.obj1e_entryexit)) + y;
        buffer_set_pos(global.obj1e_entryexit,offset+2+newPathTimer-4);
        obj_spintube.path = -4;
    }
    else {
        obj_player.x = word_swap(buffer_read_uint16(global.obj1e_entryexit)) + x;
        obj_player.y = word_swap(buffer_read_uint16(global.obj1e_entryexit)) + y;
    }
    obj_spintube.previousIndex = buffer_get_pos(global.obj1e_entryexit);
    var c,d;
    c = word_swap(buffer_read_uint16(global.obj1e_entryexit)) + x;
    d = word_swap(buffer_read_uint16(global.obj1e_entryexit)) + y;
    
    obj_spintube.phase = 2;
    obj_player.objectControl = true;
    obj_player.rolling = true;
    obj_player.gsp = sign(obj_player.gsp) * 8;
    obj_player.falling = true;
    obj_player.jumping = false;
    obj_player.depth = PRIORITY_LAYER_LOW;
    obj_spintube.newPosTimer = spintube_new_pos(c,d); // sets player xsp,ysp
    obj_spintube.activeInstance = id;
    exit;
}
if (phase == 2) {
    if (id != activeInstance) {exit;}
    // move to next tube position
    newPosTimer -= 1;
    if (newPosTimer >= 0) {
        obj_player.x += obj_player.xsp;
        obj_player.y += obj_player.ysp;
        exit;
    }
    buffer_set_pos(global.obj1e_entryexit,previousIndex);
    obj_player.x = word_swap(buffer_read_uint16(global.obj1e_entryexit)) + x;
    obj_player.y = word_swap(buffer_read_uint16(global.obj1e_entryexit)) + y;
    if (path < 0) {
        // go to previous position
        buffer_set_pos(global.obj1e_entryexit,previousIndex-4);
    }
    obj_spintube.previousIndex = buffer_get_pos(global.obj1e_entryexit);
    
    // decide new position, new path or end tube
    newPathTimer -= 4;
    if (newPathTimer != 0) {
        var c,d;
        c = word_swap(buffer_read_uint16(global.obj1e_entryexit)) + x;
        d = word_swap(buffer_read_uint16(global.obj1e_entryexit)) + y;
        obj_spintube.newPosTimer = spintube_new_pos(c,d); // sets player xsp,ysp
        exit;
    }
    if ((path < 4)&&!(path<0)) {
        buffer_set_pos(global.obj1e_byte,(behavior&$FC)+path);
        obj_spintube.path = 4;
        var b;
        b = buffer_read_int8(global.obj1e_byte);
        if (b != 0) {
            obj_spintube.newPathTimer = spintube_new_path(b); // sets player x,y
            var c,d;
            obj_spintube.previousIndex = buffer_get_pos(global.obj1e_maintube);
            c = word_swap(buffer_read_uint16(global.obj1e_maintube));
            d = word_swap(buffer_read_uint16(global.obj1e_maintube));
            obj_spintube.newPosTimer = spintube_new_pos(c,d);
            obj_spintube.phase = 4;
            exit;
        }
    }
    obj_spintube.phase = 6;
    obj_player.objectControl = false;
    exit;
}
if (phase == 4) {
    if (id != activeInstance) {exit;}
    // move to next tube position
    newPosTimer -= 1;
    if (newPosTimer >= 0) {
        obj_player.x += obj_player.xsp;
        obj_player.y += obj_player.ysp;
        exit;
    }
    buffer_set_pos(global.obj1e_maintube,previousIndex);
    obj_player.x = word_swap(buffer_read_uint16(global.obj1e_maintube));
    obj_player.y = word_swap(buffer_read_uint16(global.obj1e_maintube));
    if (path < 0) {
        // go to previous position
        buffer_set_pos(global.obj1e_maintube,previousIndex-4);
    }
    obj_spintube.previousIndex = buffer_get_pos(global.obj1e_maintube);
    
    // decide new position or end path
    newPathTimer -= 4;
    if (newPathTimer != 0) {
        var c,d;
        c = word_swap(buffer_read_uint16(global.obj1e_maintube));
        d = word_swap(buffer_read_uint16(global.obj1e_maintube));
        obj_spintube.newPosTimer = spintube_new_pos(c,d);
        exit;
    }
    obj_spintube.phase = 0;
    exit;
}
if (phase == 6) {
    if (id != activeInstance) {exit;}
    var xDist,yDist;
    xDist = obj_player.x-x;
    if ((xDist >= xRange)
    ||  (xDist < 0)) {
        obj_spintube.phase = 0;
        obj_spintube.activeInstance = noone;
        obj_spintube.path = 0;
        exit;
    }
    yDist = obj_player.y-y;
    if ((yDist >= 128)
    ||  (yDist < 0)) {
        obj_spintube.phase = 0;
        obj_spintube.activeInstance = noone;
        obj_spintube.path = 0;
        exit;
    }
    exit;
}

