#define AB_get_index_in_128px_mappings
var XPOS,YPOS,TILE;
XPOS = argument0;
YPOS = argument1;
TILE = argument2;
var OFFSET;
OFFSET = tile_get_left(TILE) >> CHUNK_SHIFT;
OFFSET += tile_get_top(TILE) >> CHUNK_SHIFT << 4;
OFFSET = OFFSET << 7;
OFFSET += XPOS >> 4 << 1;
OFFSET += YPOS & $F0;
return OFFSET;

#define AB_apply_solid_mask
var X,LAYER,SENSORS_AB;
X = argument0;
LAYER = argument1;
SENSORS_AB = argument2;
X &= $F0;
if (SENSORS_AB) {X &= $50;}
else {X &= $A0;}
if (LAYER == COLLISION_LAYER_B) {X &= $C0;}
else {X &= $30;}
return X;

#define AB_fix_angle_value
var ANGLE,XFLIP,YFLIP,MODE;
ANGLE = argument0;
XFLIP = argument1;
YFLIP = argument2;
MODE = argument3;
ANGLE = (255-ANGLE)*1.40625;
if (ANGLE == 360) {ANGLE = 0;}
if (!ANGLE) {
    ANGLE = MODE*90;
}
else {
    if (!XFLIP&&YFLIP) {ANGLE = 180-ANGLE;}
    if (XFLIP&&YFLIP) {ANGLE = 180+ANGLE;}
    if (XFLIP&&!YFLIP) {ANGLE = 360-ANGLE;}
}
return ANGLE;

#define AB_get_height
var MODE,XFLIP,YFLIP,XPOS,YPOS,OFFSET,ARRAY_1,ARRAY_2;
MODE = argument0;
XFLIP = argument1;
YFLIP = argument2;
XPOS = argument3;
YPOS = argument4;
OFFSET = argument5;
ARRAY_1 = argument6;
ARRAY_2 = argument7;
var HEIGHT;
if (!(MODE&$01)) {
    if (XFLIP) {OFFSET += TILE_SIZE-1-(XPOS&$0f);}
    else {OFFSET += XPOS & $0f;}
    buffer_set_pos(ARRAY_1,OFFSET);
    HEIGHT = buffer_read_int8(ARRAY_1);
} else {
    if (YFLIP) {OFFSET += TILE_SIZE-1-(YPOS&$0F);}
    else {OFFSET += YPOS & $0F;}
    buffer_set_pos(ARRAY_2,OFFSET);
    HEIGHT = buffer_read_int8(ARRAY_2);
}
return HEIGHT;

#define AB_get_heightmask
var LAYER,HEIGHTMASKS_A,HEIGHTMASKS_B,OFFSET;
LAYER = argument0;
HEIGHTMASKS_A = argument1;
HEIGHTMASKS_B = argument2;
OFFSET = argument3;

if (LAYER == COLLISION_LAYER_A) {
    buffer_set_pos(HEIGHTMASKS_A,OFFSET);
    OFFSET = buffer_read_uint8(HEIGHTMASKS_A);
} else {
    buffer_set_pos(HEIGHTMASKS_B,OFFSET);
    OFFSET = buffer_read_uint8(HEIGHTMASKS_B);
}
return OFFSET;

#define player_AB

// FLOOR SENSOR

var xposA,xposB;
var yposA,yposB;
var xextAB,yextAB;
var widthAB;
widthAB = -(w+1);
switch (mode) {
    case 0:
        xposA = x+xsp+widthAB;
        yposA = y+ysp+h;
        xextAB = 0;
        yextAB = TILE_SIZE;
        xposB = x+xsp-widthAB;
        yposB = y+ysp+h;
        break;
    case 1:
        xposA = x+xsp+h;
        yposA = y+ysp-widthAB;
        xextAB = TILE_SIZE;
        yextAB = 0;
        xposB = x+xsp+h;
        yposB = y+ysp+widthAB;
        break;
    case 2:
        xposA = x+xsp-widthAB;
        yposA = y+ysp-h;
        xextAB = 0;
        yextAB = -TILE_SIZE;
        xposB = x+xsp+widthAB;
        yposB = y+ysp-h;
        break;
    case 3:
        xposA = x+xsp-h;
        yposA = y+ysp+widthAB;
        xextAB = -TILE_SIZE;
        yextAB = 0;
        xposB = x+xsp-h;
        yposB = y+ysp-widthAB;
}
xposA = floor(xposA);
yposA = floor(yposA);
xposB = floor(xposB);
yposB = floor(yposB);

var heightA,angleA;
heightA = 0;
angleA = 0;
sensorA = tile_layer_find(FOREGROUND_LAYER,xposA,yposA);
if (sensorA) {
    var i,j,xflip,yflip,isSolid;
    i = AB_get_index_in_128px_mappings(
        xposA-tile_get_x(sensorA),
        yposA-tile_get_y(sensorA),
        sensorA);
    buffer_set_pos(cpz_dez_128px_mappings,i);
    i = buffer_read_uint8(cpz_dez_128px_mappings);
    isSolid = AB_apply_solid_mask(i,collisionLayer,1);
    if (isSolid) {
        xflip = i & $04;
        yflip = i & $08;
        i = (i&$03) << 8;
        i += buffer_read_uint8(cpz_dez_128px_mappings);
        j = AB_get_heightmask(
            collisionLayer,
            cpz_dez_16px_collision_index_a,
            cpz_dez_16px_collision_index_b,i);
        i = j << 4;
        heightA = AB_get_height(
            mode,
            xflip,yflip,
            xposA,yposA,
            i,collision_array_1,
            collision_array_2);
        if (heightA != 0) {
            if (heightA < 0) {heightA = -heightA;}
            buffer_set_pos(curve_and_resistance_mapping,j);
            angleA = buffer_read_uint8(curve_and_resistance_mapping);
            angleA = AB_fix_angle_value(angleA,xflip,yflip,mode);
        }
    }
}
if (heightA == TILE_SIZE) {
    // regress
    var sensorAA,heightAA;
    sensorAA = tile_layer_find(FOREGROUND_LAYER,xposA-xextAB,yposA-yextAB);
    if (sensorAA) {
        var i,j,xflip,yflip,isSolid;
        i = AB_get_index_in_128px_mappings(
            xposA-xextAB-tile_get_x(sensorAA),
            yposA-yextAB-tile_get_y(sensorAA),
            sensorAA);
        buffer_set_pos(cpz_dez_128px_mappings,i);
        i = buffer_read_uint8(cpz_dez_128px_mappings);
        isSolid = AB_apply_solid_mask(i,collisionLayer,1);
        if (isSolid) {
            xflip = i & $04;
            yflip = i & $08;
            i = (i&$03) << 8;
            i += buffer_read_uint8(cpz_dez_128px_mappings);
            j = AB_get_heightmask(
                collisionLayer,
                cpz_dez_16px_collision_index_a,
                cpz_dez_16px_collision_index_b,i);
            i = j << 4;
            heightAA = AB_get_height(
                mode,
                xflip,yflip,
                xposA-xextAB,yposA-xextAB,
                i,collision_array_1,
                collision_array_2);
            if (heightAA != 0) {
                if (heightAA < 0) {heightAA = -heightAA;}
                heightA = TILE_SIZE+heightAA;
                buffer_set_pos(curve_and_resistance_mapping,j);
                angleA = buffer_read_uint8(curve_and_resistance_mapping);
                angleA = AB_fix_angle_value(angleA,xflip,yflip,mode);
                sensorA = sensorAA;
            }
        }
    }
}
var extension;
extension = false;
if ((heightA == 0) && !falling) {
    // extend
    sensorA = tile_layer_find(FOREGROUND_LAYER,xposA+xextAB,yposA+yextAB);
    if (sensorA) {
        var i,j,xflip,yflip,isSolid;
        i = AB_get_index_in_128px_mappings(
            xposA+xextAB-tile_get_x(sensorA),
            yposA+yextAB-tile_get_y(sensorA),
            sensorA);
        buffer_set_pos(cpz_dez_128px_mappings,i);
        i = buffer_read_uint8(cpz_dez_128px_mappings);
        isSolid = AB_apply_solid_mask(i,collisionLayer,1);
        if (isSolid) {
            xflip = i & $04;
            yflip = i & $08;
            i = (i&$03) << 8;
            i += buffer_read_uint8(cpz_dez_128px_mappings);
            j = AB_get_heightmask(
                collisionLayer,
                cpz_dez_16px_collision_index_a,
                cpz_dez_16px_collision_index_b,i);
            i = j << 4;
            heightA = AB_get_height(
                mode,
                xflip,yflip,
                xposA+xextAB,yposA+yextAB,
                i,collision_array_1,
                collision_array_2);
            if (heightA != 0) {
                if (heightA < 0) {heightA = -heightA;}
                extension = true;
                heightA -= TILE_SIZE;
                buffer_set_pos(curve_and_resistance_mapping,j);
                angleA = buffer_read_uint8(curve_and_resistance_mapping);
                angleA = AB_fix_angle_value(angleA,xflip,yflip,mode);
            }
        }
    }
}
if ((heightA == 0) && !extension) {
    sensorA = noone;
}

var heightB,angleB;
heightB = 0;
angleB = 0;
sensorB = tile_layer_find(FOREGROUND_LAYER,xposB,yposB);
if (sensorB) {
    var i,j,xflip,yflip,isSolid;
    i = AB_get_index_in_128px_mappings(
        xposB-tile_get_x(sensorB),
        yposB-tile_get_y(sensorB),
        sensorB);
    buffer_set_pos(cpz_dez_128px_mappings,i);
    i = buffer_read_uint8(cpz_dez_128px_mappings);
    isSolid = AB_apply_solid_mask(i,collisionLayer,1);
    if (isSolid) {
        xflip = i & $04;
        yflip = i & $08;
        i = (i&$03) << 8;
        i += buffer_read_uint8(cpz_dez_128px_mappings);
        j = AB_get_heightmask(
            collisionLayer,
            cpz_dez_16px_collision_index_a,
            cpz_dez_16px_collision_index_b,i);
        i = j << 4;
        heightB = AB_get_height(
            mode,
            xflip,yflip,
            xposB,yposB,
            i,collision_array_1,
            collision_array_2);
        if (heightB != 0) {
            if (heightB < 0) {heightB = -heightB;}
            buffer_set_pos(curve_and_resistance_mapping,j);
            angleB = buffer_read_uint8(curve_and_resistance_mapping);
            angleB = AB_fix_angle_value(angleB,xflip,yflip,mode);
        }
    }
}
if (heightB == TILE_SIZE) {
    // regress
    var sensorBB,heightBB;
    sensorBB = tile_layer_find(FOREGROUND_LAYER,xposB-xextAB,yposB-yextAB);
    if (sensorBB) {
        var i,j,xflip,yflip,isSolid;
        i = AB_get_index_in_128px_mappings(
            xposB-xextAB-tile_get_x(sensorBB),
            yposB-yextAB-tile_get_y(sensorBB),
            sensorBB);
        buffer_set_pos(cpz_dez_128px_mappings,i);
        i = buffer_read_uint8(cpz_dez_128px_mappings);
        isSolid = AB_apply_solid_mask(i,collisionLayer,1);
        if (isSolid) {
            xflip = i & $04;
            yflip = i & $08;
            i = (i&$03) << 8;
            i += buffer_read_uint8(cpz_dez_128px_mappings);
            j = AB_get_heightmask(
                collisionLayer,
                cpz_dez_16px_collision_index_a,
                cpz_dez_16px_collision_index_b,i);
            i = j << 4;
            heightBB = AB_get_height(
                mode,
                xflip,yflip,
                xposB-xextAB,yposB-yextAB,
                i,collision_array_1,
                collision_array_2);
            if (heightBB != 0) {
                if (heightBB < 0) {heightBB = -heightBB;}
                heightB = TILE_SIZE+heightBB;
                buffer_set_pos(curve_and_resistance_mapping,j);
                angleB = buffer_read_uint8(curve_and_resistance_mapping);
                angleB = AB_fix_angle_value(angleB,xflip,yflip,mode);
                sensorB = sensorBB;
            }
        }
    }
}
extension = false;
if ((heightB == 0) && !falling) {
    // extend
    sensorB = tile_layer_find(FOREGROUND_LAYER,xposB+xextAB,yposB+yextAB);
    if (sensorB) {
        var i,j,xflip,yflip,isSolid;
        i = AB_get_index_in_128px_mappings(
            xposB+xextAB-tile_get_x(sensorB),
            yposB+yextAB-tile_get_y(sensorB),
            sensorB);
        buffer_set_pos(cpz_dez_128px_mappings,i);
        i = buffer_read_uint8(cpz_dez_128px_mappings);
        isSolid = AB_apply_solid_mask(i,collisionLayer,1);
        if (isSolid) {
            xflip = i & $04;
            yflip = i & $08;
            i = (i&$03) << 8;
            i += buffer_read_uint8(cpz_dez_128px_mappings);
            j = AB_get_heightmask(
                collisionLayer,
                cpz_dez_16px_collision_index_a,
                cpz_dez_16px_collision_index_b,i);
            i = j << 4;
            heightB = AB_get_height(
                mode,
                xflip,yflip,
                xposB+xextAB,yposB+yextAB,
                i,collision_array_1,
                collision_array_2);
            if (heightB != 0) {
                if (heightB < 0) {heightB = -heightB;}
                extension = true;
                heightB -= TILE_SIZE;
                buffer_set_pos(curve_and_resistance_mapping,j);
                angleB = buffer_read_uint8(curve_and_resistance_mapping);
                angleB = AB_fix_angle_value(angleB,xflip,yflip,mode);
            }
        }
    }
}
if ((heightB == 0) && !extension) {
    sensorB = noone;
}

// without this player will stick on first frame of jump
if (jumping && !falling) {
    sensorA = noone;
    sensorB = noone;
}

if (((heightA>heightB)&&(sensorA&&sensorB))
||  (sensorA&&!sensorB)) {
    ang = angleA;
    switch (mode)
    {
        case 0:
            y = (yposA&TILE_MASK)+TILE_SIZE-heightA-h-1;
            ysp = 0;
            break;
        case 1:
            x = (xposA&TILE_MASK)+TILE_SIZE-heightA-h-1;
            xsp = 0;
            break;
        case 2:
            y = (yposA&TILE_MASK)+heightA+h+1;
            ysp = 0;
            break;
        case 3:
            x = (xposA&TILE_MASK)+heightA+h+1;
            xsp = 0;
    }
}
if (((heightB>=heightA)&&(sensorA&&sensorB))
||  (sensorB&&!sensorA)) {
    ang = angleB;
    switch (mode)
    {
        case 0:
            y = (yposB&TILE_MASK)+TILE_SIZE-heightB-h-1;
            ysp = 0;
            break;
        case 1:
            x = (xposB&TILE_MASK)+TILE_SIZE-heightB-h-1;
            xsp = 0;
            break;
        case 2:
            y = (yposB&TILE_MASK)+heightB+h+1;
            ysp = 0;
            break;
        case 3:
            x = (xposB&TILE_MASK)+heightB+h+1;
            xsp = 0;
    }
}
if (sensorA || sensorB) {
    falling = false;
} else {
    falling = true;
}

#define player_CD

// CEILING SENSOR

var xposC,yposC;
var xposD,yposD;
var xextCD,yextCD;
var widthCD;
widthCD = w+1;
switch (mode) {
    case 0:
        xposC = x+xsp-widthCD;
        yposC = y+ysp-h;
        xextCD = 0;
        yextCD = -TILE_SIZE;
        xposD = x+xsp+widthCD;
        yposD = y+ysp-h;
        break;
    case 1:
        xposC = x+xsp-h;
        yposC = y+ysp+widthCD;
        xextCD = -TILE_SIZE;
        yextCD = 0;
        xposD = x+xsp-h;
        yposD = y+ysp-widthCD;
        break;
    case 2:
        xposC = x+xsp+widthCD;
        yposC = y+ysp+h;
        xextCD = 0;
        yextCD = TILE_SIZE;
        xposD = x+xsp-widthCD;
        yposD = y+ysp+h;
        break;
    case 3:
        xposC = x+xsp+h;
        yposC = y+ysp-widthCD;
        xextCD = TILE_SIZE;
        yextCD = 0;
        xposD = x+xsp+h;
        yposD = y+ysp+widthCD;
}
xposC = floor(xposC);
yposC = floor(yposC);
xposD = floor(xposD);
yposD = floor(yposD);

var heightC;
heightC = 0;
sensorC = tile_layer_find(FOREGROUND_LAYER,xposC,yposC);
if (sensorC) {
    var i,j,xflip,yflip,isSolid;
    i = AB_get_index_in_128px_mappings(
        xposC-tile_get_x(sensorC),
        yposC-tile_get_y(sensorC),
        sensorC);
    buffer_set_pos(cpz_dez_128px_mappings,i);
    i = buffer_read_uint8(cpz_dez_128px_mappings);
    isSolid = AB_apply_solid_mask(i,collisionLayer,0);
    if (isSolid) {
        xflip = i & $04;
        yflip = i & $08;
        i = (i&$03) << 8;
        i += buffer_read_uint8(cpz_dez_128px_mappings);
        j = AB_get_heightmask(
            collisionLayer,
            cpz_dez_16px_collision_index_a,
            cpz_dez_16px_collision_index_b,i);
        i = j << 4;
        heightC = AB_get_height(
            mode,
            xflip,yflip,
            xposC,yposC,
            i,collision_array_1,
            collision_array_2);
        if (heightC != 0) {
            if (heightC < 0) {heightC = -heightC;}
        }
    }
}
if (heightC == TILE_SIZE) {
    // regress
    var sensorCC,heightCC;
    sensorCC = tile_layer_find(FOREGROUND_LAYER,xposC-xextCD,yposC-yextCD);
    if (sensorCC) {
        var i,j,xflip,yflip,isSolid;
        i = AB_get_index_in_128px_mappings(
            xposC-xextCD-tile_get_x(sensorCC),
            yposC-yextCD-tile_get_y(sensorCC),
            sensorCC);
        buffer_set_pos(cpz_dez_128px_mappings,i);
        i = buffer_read_uint8(cpz_dez_128px_mappings);
        isSolid = AB_apply_solid_mask(i,collisionLayer,0);
        if (isSolid) {
            xflip = i & $04;
            yflip = i & $08;
            i = (i&$03) << 8;
            i += buffer_read_uint8(cpz_dez_128px_mappings);
            j = AB_get_heightmask(
                collisionLayer,
                cpz_dez_16px_collision_index_a,
                cpz_dez_16px_collision_index_b,i);
            i = j << 4;
            heightCC = AB_get_height(
                mode,
                xflip,yflip,
                xposC-xextCD,yposC-xextCD,
                i,collision_array_1,
                collision_array_2);
            if (heightCC != 0) {
                if (heightCC < 0) {heightCC = -heightCC;}
                heightC = TILE_SIZE+heightCC;
                sensorC = sensorCC;
            }
        }
    }
}
var extension;
extension = false;
if ((heightC == 0) && !falling) {
    // extend
    sensorC = tile_layer_find(FOREGROUND_LAYER,xposC+xextCD,yposC+yextCD);
    if (sensorC) {
        var i,j,xflip,yflip,isSolid;
        i = AB_get_index_in_128px_mappings(
            xposC+xextCD-tile_get_x(sensorC),
            yposC+yextCD-tile_get_y(sensorC),
            sensorC);
        buffer_set_pos(cpz_dez_128px_mappings,i);
        i = buffer_read_uint8(cpz_dez_128px_mappings);
        isSolid = AB_apply_solid_mask(i,collisionLayer,0);
        if (isSolid) {
            xflip = i & $04;
            yflip = i & $08;
            i = (i&$03) << 8;
            i += buffer_read_uint8(cpz_dez_128px_mappings);
            j = AB_get_heightmask(
                collisionLayer,
                cpz_dez_16px_collision_index_a,
                cpz_dez_16px_collision_index_b,i);
            i = j << 4;
            heightC = AB_get_height(
                mode,
                xflip,yflip,
                xposC+xextCD,yposC+xextCD,
                i,collision_array_1,
                collision_array_2);
            if (heightC != 0) {
                if (heightC < 0) {heightC = -heightC;}
                extension = true;
                heightC -= TILE_SIZE;
            }
        }
    }
}
if ((heightC == 0) && !extension) {
    sensorC = noone;
}

var heightD;
heightD = 0;
sensorD = tile_layer_find(FOREGROUND_LAYER,xposD,yposD);
if (sensorD) {
    var i,j,xflip,yflip,isSolid;
    i = AB_get_index_in_128px_mappings(
        xposD-tile_get_x(sensorD),
        yposD-tile_get_y(sensorD),
        sensorD);
    buffer_set_pos(cpz_dez_128px_mappings,i);
    i = buffer_read_uint8(cpz_dez_128px_mappings);
    isSolid = AB_apply_solid_mask(i,collisionLayer,0);
    if (isSolid) {
        xflip = i & $04;
        yflip = i & $08;
        i = (i&$03) << 8;
        i += buffer_read_uint8(cpz_dez_128px_mappings);
        j = AB_get_heightmask(
            collisionLayer,
            cpz_dez_16px_collision_index_a,
            cpz_dez_16px_collision_index_b,i);
        i = j << 4;
        heightD = AB_get_height(
            mode,
            xflip,yflip,
            xposD,yposD,
            i,collision_array_1,
            collision_array_2);
        if (heightD != 0) {
            if (heightD < 0) {heightD = -heightD;}
        }
    }
}
if (heightD == TILE_SIZE) {
    // regress
    var sensorDD,heightDD;
    sensorDD = tile_layer_find(FOREGROUND_LAYER,xposD-xextCD,yposD-yextCD);
    if (sensorDD) {
        var i,j,xflip,yflip,isSolid;
        i = AB_get_index_in_128px_mappings(
            xposD-xextCD-tile_get_x(sensorDD),
            yposD-yextCD-tile_get_y(sensorDD),
            sensorDD);
        buffer_set_pos(cpz_dez_128px_mappings,i);
        i = buffer_read_uint8(cpz_dez_128px_mappings);
        isSolid = AB_apply_solid_mask(i,collisionLayer,0);
        if (isSolid) {
            xflip = i & $04;
            yflip = i & $08;
            i = (i&$03) << 8;
            i += buffer_read_uint8(cpz_dez_128px_mappings);
            j = AB_get_heightmask(
                collisionLayer,
                cpz_dez_16px_collision_index_a,
                cpz_dez_16px_collision_index_b,i);
            i = j << 4;
            heightDD = AB_get_height(
                mode,
                xflip,yflip,
                xposD-xextCD,yposD-yextCD,
                i,collision_array_1,
                collision_array_2);
            if (heightDD != 0) {
                if (heightDD < 0) {heightDD = -heightDD;}
                heightD = TILE_SIZE+heightDD;
                sensorD = sensorDD;
            }
        }
    }
}
extension = false;
if ((heightD == 0) && !falling) {
    // extend
    sensorD = tile_layer_find(FOREGROUND_LAYER,xposD+xextCD,yposD+yextCD);
    if (sensorD) {
        var i,j,xflip,yflip,isSolid;
        i = AB_get_index_in_128px_mappings(
            xposD+xextCD-tile_get_x(sensorD),
            yposD+yextCD-tile_get_y(sensorD),
            sensorD);
        buffer_set_pos(cpz_dez_128px_mappings,i);
        i = buffer_read_uint8(cpz_dez_128px_mappings);
        isSolid = AB_apply_solid_mask(i,collisionLayer,0);
        if (isSolid) {
            xflip = i & $04;
            yflip = i & $08;
            i = (i&$03) << 8;
            i += buffer_read_uint8(cpz_dez_128px_mappings);
            j = AB_get_heightmask(
                collisionLayer,
                cpz_dez_16px_collision_index_a,
                cpz_dez_16px_collision_index_b,i);
            i = j << 4;
            heightD = AB_get_height(
                mode,
                xflip,yflip,
                xposD+xextCD,yposD+yextCD,
                i,collision_array_1,
                collision_array_2);
            if (heightD != 0) {
                if (heightD < 0) {heightD = -heightD;}
                extension = true;
                heightD -= TILE_SIZE;
            }
        }
    }
}
if ((heightD == 0) && !extension) {
    sensorD = noone;
}

if (((heightC>heightD)&&(sensorC&&sensorD))
||  (sensorC&&!sensorD)) {
    switch (mode)
    {
        case 2:
            ysp = 0;
            y = (yposC&TILE_MASK)+TILE_SIZE-heightC-h-1;
            break;
        case 3:
            xsp = 0;
            x = (xposC&TILE_MASK)+TILE_SIZE-heightC-h-1;
            break;
        case 0:
            ysp = 0;
            y = (yposC&TILE_MASK)+heightC+h+1;
            break;
        case 1:
            xsp = 0;
            x = (xposC&TILE_MASK)+heightC+h+1;
    }
}
if (((heightD>=heightC)&&(sensorC&&sensorD))
||  (sensorD&&!sensorC)) {
    switch (mode)
    {
        case 2:
            ysp = 0;
            y = (yposD&TILE_MASK)+TILE_SIZE-heightD-h-1;
            break;
        case 3:
            xsp = 0;
            x = (xposD&TILE_MASK)+TILE_SIZE-heightD-h-1;
            break;
        case 0:
            ysp = 0;
            y = (yposD&TILE_MASK)+heightD+h+1;
            break;
        case 1:
            xsp = 0;
            x = (xposD&TILE_MASK)+heightD+h+1;
    }
}

#define player_E

// WALL SENSOR

var xposE,yposE;
var xextE,yextE;
var widthE;
widthE = W_PUSH+1;
var pushAgainstSteps;
if (!ang && !falling && !rolling && !jumping && !standingOnObject) {
    if (mode>>1) {pushAgainstSteps = -8;}
    else {pushAgainstSteps = 8;}
}
else {pushAgainstSteps = 0;}
if (!(mode&$01)) {
    xposE = x+xsp+sign(xsp)*widthE;
    yposE = y+ysp+pushAgainstSteps;
    xextE = sign(xsp)*TILE_SIZE;
    yextE = 0;
} else {
    xposE = x+xsp+pushAgainstSteps;
    yposE = y+ysp+sign(ysp)*widthE;
    xextE = 0;
    yextE = sign(ysp)*TILE_SIZE;
}
xposE = floor(xposE);
yposE = floor(yposE);

var heightE;
heightE = 0;
sensorE = tile_layer_find(FOREGROUND_LAYER,xposE,yposE);
if (sensorE) {
    var i,j,xflip,yflip,isSolid;
    i = AB_get_index_in_128px_mappings(
        xposE-tile_get_x(sensorE),
        yposE-tile_get_y(sensorE),
        sensorE);
    buffer_set_pos(cpz_dez_128px_mappings,i);
    i = buffer_read_uint8(cpz_dez_128px_mappings);
    isSolid = AB_apply_solid_mask(i,collisionLayer,0);
    if (isSolid) {
        xflip = i & $04;
        yflip = i & $08;
        i = (i&$03) << 8;
        i += buffer_read_uint8(cpz_dez_128px_mappings);
        j = AB_get_heightmask(
            collisionLayer,
            cpz_dez_16px_collision_index_a,
            cpz_dez_16px_collision_index_b,i);
        i = j << 4;
        heightE = AB_get_height(
            mode,
            xflip,yflip,
            xposE,yposE,
            i,collision_array_1,
            collision_array_2);
        if (heightE != 0) {
            if (heightE < 0) {heightE = -heightE;}
            if (heightE < TILE_SIZE) {heightE = 0;}
        }
    }
}
if (heightE == TILE_SIZE) {
    // regress
    var sensorEE,heightEE;
    sensorEE = tile_layer_find(FOREGROUND_LAYER,xposE-xextE,yposE-yextE);
    if (sensorEE) {
        var i,j,xflip,yflip,isSolid;
        i = AB_get_index_in_128px_mappings(
            xposE-xextE-tile_get_x(sensorEE),
            yposE-yextE-tile_get_y(sensorEE),
            sensorEE);
        buffer_set_pos(cpz_dez_128px_mappings,i);
        i = buffer_read_uint8(cpz_dez_128px_mappings);
        isSolid = AB_apply_solid_mask(i,collisionLayer,0);
        if (isSolid) {
            xflip = i & $04;
            yflip = i & $08;
            i = (i&$03) << 8;
            i += buffer_read_uint8(cpz_dez_128px_mappings);
            j = AB_get_heightmask(
                collisionLayer,
                cpz_dez_16px_collision_index_a,
                cpz_dez_16px_collision_index_b,i);
            i = j << 4;
            heightEE = AB_get_height(
                mode,
                xflip,yflip,
                xposE-xextE,yposE-xextE,
                i,collision_array_1,
                collision_array_2);
            if (heightEE != 0) {
                if (heightEE < 0) {heightEE = -heightEE;}
                if (heightEE < TILE_SIZE) {heightEE = 0;}
                if (heightEE != 0) {
                    heightE = TILE_SIZE+heightEE;
                    sensorE = sensorEE;
                }
            }
        }
    }
}
if (heightE == 0) {
    sensorE = noone;
}
if (sensorE) {
    gsp = 0;
    if (!(mode&$01)) {
        x = ((xposE&TILE_MASK)+((xsp>0)*TILE_SIZE)-(sign(xsp)*(heightE+widthE)));
        xsp = 0;
    } else {
        y = ((yposE&TILE_MASK)+((ysp>0)*TILE_SIZE)-(sign(ysp)*(heightE+widthE)));
        ysp = 0;
    }
}

#define player_J

// LOW CEILING SENSOR

var xposJ1,yposJ1;
var xposJ2,yposJ2;
var xextJ,yextJ;
var widthJ;
widthJ = W_PUSH;
switch (mode) {
    case 0:
        xposJ1 = x+xsp-widthJ;
        yposJ1 = y+ysp-h;
        xextJ = 0;
        yextJ = -TILE_SIZE;
        xposJ2 = x+xsp+widthJ;
        yposJ2 = y+ysp-h;
        break;
    case 1:
        xposJ1 = x+xsp-h;
        yposJ1 = y+ysp+widthJ;
        xextJ = -TILE_SIZE;
        yextJ = 0;
        xposJ2 = x+xsp-h;
        yposJ2 = y+ysp-widthJ;
        break;
    case 2:
        xposJ1 = x+xsp+widthJ;
        yposJ1 = y+ysp+h;
        xextJ = 0;
        yextJ = TILE_SIZE;
        xposJ2 = x+xsp-widthJ;
        yposJ2 = y+ysp+h;
        break;
    case 3:
        xposJ1 = x+xsp+h;
        yposJ1 = y+ysp-widthJ;
        xextJ = TILE_SIZE;
        yextJ = 0;
        xposJ2 = x+xsp+h;
        yposJ2 = y+ysp+widthJ;
}
xposJ1 = floor(xposJ1);
yposJ2 = floor(yposJ1);
xposJ2 = floor(xposJ2);
yposJ2 = floor(yposJ2);

var heightJ1;
heightJ1 = 0;
sensorJ1 = tile_layer_find(FOREGROUND_LAYER,xposJ1,yposJ1);
if (sensorJ1) {
    var i,j,xflip,yflip,isSolid;
    i = AB_get_index_in_128px_mappings(
        xposJ1-tile_get_x(sensorJ1),
        yposJ1-tile_get_y(sensorJ1),
        sensorJ1);
    buffer_set_pos(cpz_dez_128px_mappings,i);
    i = buffer_read_uint8(cpz_dez_128px_mappings);
    isSolid = AB_apply_solid_mask(i,collisionLayer,0);
    if (isSolid) {
        xflip = i & $04;
        yflip = i & $08;
        i = (i&$03) << 8;
        i += buffer_read_uint8(cpz_dez_128px_mappings);
        j = AB_get_heightmask(
            collisionLayer,
            cpz_dez_16px_collision_index_a,
            cpz_dez_16px_collision_index_b,i);
        i = j << 4;
        heightJ1 = AB_get_height(
            mode,
            xflip,yflip,
            xposJ1,yposJ1,
            i,collision_array_1,
            collision_array_2);
        if (heightJ1 != 0) {
            if (heightJ1 < 0) {heightJ1 = -heightJ1;}
        }
    }
}
if (heightJ1 == TILE_SIZE) {
    // regress
    var sensorJJ1,heightJJ1;
    sensorJJ1 = tile_layer_find(FOREGROUND_LAYER,xposJ1-xextJ,yposJ1-yextJ);
    if (sensorJJ1) {
        var i,j,xflip,yflip,isSolid;
        i = AB_get_index_in_128px_mappings(
            xposJ1-xextJ-tile_get_x(sensorJJ1),
            yposJ1-yextJ-tile_get_y(sensorJJ1),
            sensorJJ1);
        buffer_set_pos(cpz_dez_128px_mappings,i);
        i = buffer_read_uint8(cpz_dez_128px_mappings);
        isSolid = AB_apply_solid_mask(i,collisionLayer,0);
        if (isSolid) {
            xflip = i & $04;
            yflip = i & $08;
            i = (i&$03) << 8;
            i += buffer_read_uint8(cpz_dez_128px_mappings);
            j = AB_get_heightmask(
                collisionLayer,
                cpz_dez_16px_collision_index_a,
                cpz_dez_16px_collision_index_b,i);
            i = j << 4;
            heightJJ1 = AB_get_height(
                mode,
                xflip,yflip,
                xposJ1-xextJ,yposJ1-xextJ,
                i,collision_array_1,
                collision_array_2);
            if (heightJJ1 != 0) {
                if (heightJJ1 < 0) {heightJJ1 = -heightJJ1;}
                heightJ1 = TILE_SIZE+heightJJ1;
                sensorJ1 = sensorJJ1;
            }
        }
    }
}
if (heightJ1 == 0) {
    sensorJ1 = noone;
}

var heightJ2;
heightJ2 = 0;
sensorJ2 = tile_layer_find(FOREGROUND_LAYER,xposJ2,yposJ2);
if (sensorJ2) {
    var i,j,xflip,yflip,isSolid;
    i = AB_get_index_in_128px_mappings(
        xposJ2-tile_get_x(sensorJ2),
        yposJ2-tile_get_y(sensorJ2),
        sensorJ2);
    buffer_set_pos(cpz_dez_128px_mappings,i);
    i = buffer_read_uint8(cpz_dez_128px_mappings);
    isSolid = AB_apply_solid_mask(i,collisionLayer,0);
    if (isSolid) {
        xflip = i & $04;
        yflip = i & $08;
        i = (i&$03) << 8;
        i += buffer_read_uint8(cpz_dez_128px_mappings);
        j = AB_get_heightmask(
            collisionLayer,
            cpz_dez_16px_collision_index_a,
            cpz_dez_16px_collision_index_b,i);
        i = j << 4;
        heightJ2 = AB_get_height(
            mode,
            xflip,yflip,
            xposJ2,yposJ2,
            i,collision_array_1,
            collision_array_2);
        if (heightJ2 != 0) {
            if (heightJ2 < 0) {heightJ2 = -heightJ2;}
        }
    }
}
if (heightJ2 == TILE_SIZE) {
    // regress
    var sensorJJ2,heightJJ2;
    sensorJJ2 = tile_layer_find(FOREGROUND_LAYER,xposJ2-xextJ,yposJ2-yextJ);
    if (sensorJJ2) {
        var i,j,xflip,yflip,isSolid;
        i = AB_get_index_in_128px_mappings(
            xposJ2-xextJ-tile_get_x(sensorJJ2),
            yposJ2-yextJ-tile_get_y(sensorJJ2),
            sensorJJ2);
        buffer_set_pos(cpz_dez_128px_mappings,i);
        i = buffer_read_uint8(cpz_dez_128px_mappings);
        isSolid = AB_apply_solid_mask(i,collisionLayer,0);
        if (isSolid) {
            xflip = i & $04;
            yflip = i & $08;
            i = (i&$03) << 8;
            i += buffer_read_uint8(cpz_dez_128px_mappings);
            j = AB_get_heightmask(
                collisionLayer,
                cpz_dez_16px_collision_index_a,
                cpz_dez_16px_collision_index_b,i);
            i = j << 4;
            heightJJ2 = AB_get_height(
                mode,
                xflip,yflip,
                xposJ2-xextJ,yposJ2-xextJ,
                i,collision_array_1,
                collision_array_2);
            if (heightJJ2 != 0) {
                if (heightJJ2 < 0) {heightJJ2 = -heightJJ2;}
                heightJ2 = TILE_SIZE+heightJJ2;
                sensorJ2 = sensorJJ2;
            }
        }
    }
}
if (heightJ2 == 0) {
    sensorJ2 = noone;
}
if (heightJ1 > heightJ2) {return heightJ1;}
else {return heightJ2;}

#define player_K

// BALANCING SENSOR

var sensorK;
var xposK,yposK;
xposK = x+xsp;
yposK = y+ysp+h;
xposK = floor(xposK);
yposK = floor(yposK);

sensorK = tile_layer_find(FOREGROUND_LAYER,xposK,yposK);
if (sensorK) {
    var i,j,xflip,yflip,isSolid;
    i = AB_get_index_in_128px_mappings(
        xposK-tile_get_x(sensorK),
        yposK-tile_get_y(sensorK),
        sensorK);
    buffer_set_pos(cpz_dez_128px_mappings,i);
    i = buffer_read_uint8(cpz_dez_128px_mappings);
    isSolid = AB_apply_solid_mask(i,collisionLayer,0);
    if (isSolid) {
        xflip = i & $04;
        yflip = i & $08;
        i = (i&$03) << 8;
        i += buffer_read_uint8(cpz_dez_128px_mappings);
        j = AB_get_heightmask(
            collisionLayer,
            cpz_dez_16px_collision_index_a,
            cpz_dez_16px_collision_index_b,i);
        i = j << 4;
        var heightK;
        heightK = AB_get_height(
            mode,
            xflip,yflip,
            xposK,yposK,
            i,collision_array_1,
            collision_array_2);
        return (heightK != 0);
    }
}
return false;

