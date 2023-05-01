#define editor_alloc

var FILE;
FILE = file_bin_open("rodata/cpz1_startpos.bin",0);
obj_player.x = file_bin_read_byte(FILE) << 8;
obj_player.x += file_bin_read_byte(FILE);
obj_player.y = file_bin_read_byte(FILE) << 8;
obj_player.y += file_bin_read_byte(FILE);
file_bin_close(FILE);

var xpos,ypos;
xpos = max(obj_player.x-CAMERA_W2,CAMERA_LBOUND);
ypos = max(obj_player.y-DEFAULT_VFOCALPOINT,CAMERA_UBOUND);
instance_create(xpos,ypos,obj_camera);

cpz1_layout = buffer_create();
if (!buffer_read_from_file(
    cpz1_layout,
    "rodata/cpz1_layout.bin")) {
    buffer_destroy(cpz1_layout);
    show_message("Http Dll: Error");
    exit;
}
var i,j,k;
k = 0;
for (j=0;j<32;j+=1) {
    var layer;
    layer = (!(j mod 2))*FOREGROUND_LAYER + (j mod 2)*BACKGROUND_LAYER;
    for (i=0;i<128;i+=1) {
        var chunk;
        chunk = buffer_read_uint8(cpz1_layout);
        var chunkHi,chunkLo;
        chunkHi = (chunk&$F0)>>4;
        chunkLo = chunk&$0F;
        if (layer == FOREGROUND_LAYER) {
            tile_add(bg_cpz,chunkLo<<CHUNK_SHIFT,chunkHi<<CHUNK_SHIFT,
            CHUNK_SIZE,CHUNK_SIZE,i<<CHUNK_SHIFT,k<<CHUNK_SHIFT,layer);
        } else {
            tile_add(bg_cpz,chunkLo<<CHUNK_SHIFT,chunkHi<<CHUNK_SHIFT,
            CHUNK_SIZE,CHUNK_SIZE,(i<<CHUNK_SHIFT)+xpos,(k<<CHUNK_SHIFT)+ypos-64,layer);
        }
    }
    if (j mod 2) {
        k+=1;
    }
}
buffer_destroy(cpz1_layout);

cpz1_objects = buffer_create();
if (!buffer_read_from_file(
    cpz1_objects,
    "rodata/cpz1_objects.bin")) {
    buffer_destroy(cpz1_objects);
    show_message("Http Dll: Error");
    exit;
}
var newObjects;
newObjects = true;
while (newObjects) {
    var o,xpos,ypos,respawn,vflip,hflip,object,params;
    xpos = buffer_read_uint8(cpz1_objects) << 8;
    xpos += buffer_read_uint8(cpz1_objects);
    ypos = buffer_read_uint8(cpz1_objects);
    respawn = ypos & $80;
    vflip = ypos & $40;
    hflip = ypos & $20;
    ypos = (ypos&$0F) << 8;
    ypos += buffer_read_uint8(cpz1_objects);
    object = buffer_read_uint8(cpz1_objects);
    params = buffer_read_uint8(cpz1_objects);
    
    // END LEVEL SIGNPOST
    if (object == $0D) {
        o = instance_create(xpos,ypos,obj_signpost);
        o.w = 24;
        o.h = 24;
        o.prevImageIndex = 0;
        o.active = false;
        o.spinFrame = 0;
        o.sparkleFrame = 0;
        o.finalFrame = 0;
        o.fc = 0;
        o.animLoop = 0;
        o.secondaryActive = 0;
        newObjects = false;
    }
    
    // COLLISION PLANE SWITCHER
    if (object == $03) {
        o = instance_create(xpos,ypos,obj_collision_plane_switcher);
        o.radius = (4 << (params&$03)) << 3;
        o.direction = (params & $04) >> 2;
        o.layerTo = ((params & $08)>>3) * COLLISION_LAYER_B;
        if (!o.layerTo) {o.layerTo = COLLISION_LAYER_A;}
        o.layerFrom = ((params & $10)>>4) * COLLISION_LAYER_B;
        if (!o.layerFrom) {o.layerFrom = COLLISION_LAYER_A;}
        o.priorityTo = ((params & $20)>>5) * PRIORITY_LAYER_HIGH;
        if (!o.priorityTo) {o.priorityTo = PRIORITY_LAYER_LOW;}
        o.priorityFrom = ((params & $40)>>6) * PRIORITY_LAYER_HIGH;
        if (!o.priorityFrom) {o.priorityFrom = PRIORITY_LAYER_LOW;}
        o.grounded = (params & $80) >> 7;
        o.onlySetPriority = (o.layerTo == o.layerFrom);
        o.currentSide = LESSER;
    }
    
    // SPRING
    if (object == $41) {
        var facing;
        facing = params >> 4;
        if (!(params&$2)) {
            if (facing == UP) {object_set_sprite(obj_spring,spr_redspring_up);}
            if (facing == RIGHT) {object_set_sprite(obj_spring,spr_redspring_right);}
            if (facing == DOWN) {object_set_sprite(obj_spring,spr_redspring_down);}
            if (hflip) {object_set_sprite(obj_spring,spr_redspring_left);}
        } else {
            if (facing == UP) {object_set_sprite(obj_spring,spr_ylwspring_up);}
            if (facing == RIGHT) {object_set_sprite(obj_spring,spr_ylwspring_right);}
            if (facing == DOWN) {object_set_sprite(obj_spring,spr_ylwspring_down);}
            if (hflip) {object_set_sprite(obj_spring,spr_ylwspring_left);}
        }
        o = instance_create(xpos,ypos,obj_spring);
        o.facing = facing;
        if ((o.facing == RIGHT) && hflip) {o.facing = LEFT;}
        o.fc = 0;
        o.beingStoodOn = false;
        o.beingPushed = false;
        if (!(params&$2)) {o.pow = 16;}
        else {o.pow = 10;}
        if ((o.facing == UP)||(o.facing == DOWN)) {o.w = 16; o.h = 8;}
        if ((o.facing == RIGHT)||(o.facing == LEFT)) {o.w = 8; o.h = 16;}
    }
    
    // PLATFORM
    if (object == $19) {
        if (params & $10) {object_set_sprite(obj_platform,spr_thinplatform);}
        else {object_set_sprite(obj_platform,spr_platform);}
        o = instance_create(xpos,ypos,obj_platform);
        o.xoff = xpos;
        o.yoff = ypos;
        o.xoffOsc = 0;
        o.yoffOsc = 0;
        o.xoffSpd = 0;
        o.yoffSpd = 0;
        o.xOnLanding = 0;
        o.beingStoodOn = false;
        o.behavior = params & $0F;
        o.xflip = hflip;
        if ((o.behavior == $03) && hflip) {o.yoff -= 192;}
        if (o.behavior == $07) {o.yoff -= 192;}
        if (params & $10) {o.w = 24; o.h = 8;}
        else {o.w = 32; o.h = 8;}
    }
    
    // BOOSTER FLICKER
    if (object == $1B) {
        o = instance_create(xpos,ypos,obj_booster_flicker);
        o.pow = 16;
        o.fc = 0;
        o.w = 8;
        o.h = 8;
        o.hflip = hflip;
        o.depth = FOREGROUND_LAYER-1;
    }
    
    // ROTATING FLOOR
    if (object == $0B) {
        o = instance_create(xpos,ypos,obj_rotating_floor);
        o.beingStoodOn = false;
        o.w = 16;
        o.h = 16;
        o.animFrame = params << 3;
        o.prevImageIndex = 0;
        o.animating = false;
        o.rotated = false;
        o.fc = 0;
    }
    
    // STAIRCASE
    if (object == $78) {
        o = instance_create(xpos,ypos,obj_staircase);
        o.box[0] = instance_create(xpos,ypos,obj_box_platform);
        o.box[1] = instance_create(xpos+32,ypos,obj_box_platform);
        o.box[2] = instance_create(xpos+64,ypos,obj_box_platform);
        o.box[3] = instance_create(xpos+96,ypos,obj_box_platform);
        var i;
        for (i=0;i<4;i+=1) {
            o.box[i].w = 16;
            o.box[i].h = 16;
            o.box[i].beingStoodOn = false;
            o.box[i].beingPushed = false;
        }
        o.behavior = params;
        o.stoodOnOnce = false;
        o.fc = 0;
    }
    
    // ONE-WAY BARRIER
    if (object == $2D) {
        o = instance_create(xpos,ypos,obj_oneway);
        o.gate[0] = instance_create(xpos,ypos-16,obj_gate);
        o.gate[0].prevImageIndex = 0;
        o.gate[0].visible = false;
        o.gate[1] = instance_create(xpos,ypos+16,obj_gate);
        o.gate[1].prevImageIndex = 0;
        o.gate[1].visible = false;
        o.w = 8;
        o.h = 32;
        o.fc = 0;
        o.up = true;
        o.animate = false;
        o.xflip = hflip;
        o.rectLeft = o.x + (!o.xflip)*-512 + (o.xflip)*-24;
        o.rectRight = o.x + (!o.xflip)*24 + (o.xflip)*512;
        o.beingPushed = false;
        o.beingStoodOn = false;
    }
    
    // SPIN TUBE
    if (object == $1E) {
        o = instance_create(xpos,ypos,obj_spintube);
        var i;
        i = params & $03;
        if (i == 0) {o.xRange = 160;}
        if (i == 1) {o.xRange = 256;}
        if (i == 2) {o.xRange = 288;}
        o.behavior = params;
        o.path = 0;
        o.phase = 0;
        o.newPosTimer = 0;
        o.newPathTimer = 0;
        o.previousIndex = 0;
        o.activeInstance = 0;
    }
    // PIPE SEAL
    if (object == $32) {
        o = instance_create(xpos,ypos,obj_pipeseal);
        o.w = 16;
        o.h = 16;
        o.beingPushed = false;
        o.beingStoodOn = false;
        o.depth = PRIORITY_LAYER_LOW;
    }
    // PIPE SPRING
    if (object == $7b) {
        o = instance_create(xpos,ypos-8,obj_pipespring);
        if (params & $02) {o.pow = 10.5};
        else {o.pow = 16;}
        o.beingPushed = false;
        o.beingStoodOn = false;
        o.prevImageIndex = 0;
        o.fc = 0;
        o.animate = false;
        o.animIndex = 0;
        o.durFrame = 0;
        o.animOffset = -1;
        o.w = 16;
        o.h = 8;
    }
    
    // BALL SNAKE
    if (object == $1d) {
        o = instance_create(xpos,ypos,obj_ballsnake);
        o.phase = INIT;
        o.xflip = hflip;
        o.param = params;
    }
    
    // INVISIBLE SOLID BLOCK
    if (object == $74) {
        o = instance_create(xpos,ypos,obj_invisible_solid_block);
        o.beingPushed = false;
        o.beingStoodOn = false;
        o.w = ((params & $F0) + 16) >> 2;
        o.h = ((params & $0F) + 1) << 3;
    }
    
    // MOVING BOX PLATFORM
    if (object == $6b) {
        o = instance_create(xpos,ypos,obj_moving_box_platform);
        o.beingStoodOn = false;
        o.beingPushed = false;
        if (params & $E0) {o.w = 32; o.h = 12;}
        else {o.w = 16; o.h = 16;}
        o.startX = o.x;
        o.startY = o.y;
        o.xflip = hflip;
        o.yflip = vflip;
        o.xoffOsc = 0;
        o.yoffOsc = 0;
        o.yoffSpd = 0;
        o.yoffAcc = 0;
        o.rotatingStatus = (hflip | vflip) >> 5;
        o.behavior = params & $0F;
        o.xOnLanding = 0;
    }
}
buffer_destroy(cpz1_objects);

global.signpost_sparklePos[0] = -24;
global.signpost_sparklePos[1] = -16;
global.signpost_sparklePos[2] = 8;
global.signpost_sparklePos[3] = 8;
global.signpost_sparklePos[4] = -16;
global.signpost_sparklePos[5] = 0;
global.signpost_sparklePos[6] = 24;
global.signpost_sparklePos[7] = -8;
global.signpost_sparklePos[8] = 0;
global.signpost_sparklePos[9] = -8;
global.signpost_sparklePos[10] = 16;
global.signpost_sparklePos[11] = 0;
global.signpost_sparklePos[12] = -24;
global.signpost_sparklePos[13] = 8;
global.signpost_sparklePos[14] = 24;
global.signpost_sparklePos[15] = 16;

global.pipespring_anim[0] = 3; // flip animation
global.pipespring_anim[1] = 1;
global.pipespring_anim[2] = 2;
global.pipespring_anim[3] = 2;
global.pipespring_anim[4] = 2;
global.pipespring_anim[5] = 1;
global.pipespring_anim[6] = 0;
global.pipespring_anim[7] = $FF;
global.pipespring_anim[8] = 1; // spring animation
global.pipespring_anim[9] = 3;
global.pipespring_anim[10] = 0;
global.pipespring_anim[11] = $FF;

global.oscData0 = $80;
global.oscData8 = $80;
global.oscData12 = $80;
global.oscData28 = $80;
global.oscData40 = $20; // $2080 & $FF00
global.oscData44 = $30; // $3080 & $FF00
global.oscData48 = $50; // $5080 & $FF00
global.oscData52 = $70; // $7080 & $FF00
global.oscData56 = $80;
global.oscData60 = $40; // $4000 & $FF00
global.oscSpeed0 = 0;
global.oscSpeed8 = 0;
global.oscSpeed12 = 0;
global.oscSpeed28 = 0;
global.oscSpeed40 = 0.703125; // $B4 * 1/256
global.oscSpeed44 = 1.054687; // $10E * 1/256
global.oscSpeed48 = 1.757812; // $1C2 * 1/256
global.oscSpeed52 = 2.460937; // $276 * 1/256
global.oscSpeed56 = 0;
global.oscSpeed60 = 0.992187; // $FE * 1/256
global.oscDir0 = 0;
global.oscDir8 = 0;
global.oscDir12 = 0;
global.oscDir28 = 0;
global.oscDir40 = 1;
global.oscDir44 = 1;
global.oscDir48 = 1;
global.oscDir52 = 1;
global.oscDir56 = 0;
global.oscDir60 = 1;
global.oscillatedThisFrame = false;

global.obj1e_entryexit = buffer_create();
if (!buffer_read_from_file(
    global.obj1e_entryexit,
    "rodata/obj1e_entryexit.bin")) {
    buffer_destroy(global.obj1e_entryexit);
    show_message("Http Dll: Error");
    exit;
}
global.obj1e_maintube = buffer_create();
if (!buffer_read_from_file(
    global.obj1e_maintube,
    "rodata/obj1e_maintube.bin")) {
    buffer_destroy(global.obj1e_maintube);
    show_message("Http Dll: Error");
    exit;
}
global.obj1e_byte = buffer_create();
if (!buffer_read_from_file(
    global.obj1e_byte,
    "rodata/obj1e_byte.bin")) {
    buffer_destroy(global.obj1e_byte);
    show_message("Http Dll: Error");
    exit;
}

