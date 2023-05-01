#define collision_layer_step

if (obj_player.objectControl) {exit;}
if (direction == VERTICAL) {
    if ((obj_player.y >= y-radius)
    &&  (obj_player.y < y+radius)) {
        if ((grounded && !obj_player.falling)
        ||  !grounded) {
            if (currentSide == LESSER) {
                if (obj_player.x >= x) {
                    //if (!onlySetPriority) {obj_player.collisionLayer = layerTo;}
                    obj_player.collisionLayer = layerTo;
                    obj_player.depth = priorityTo;
                }
            } else {
                if (obj_player.x < x) {
                    //if (!onlySetPriority) {obj_player.collisionLayer = layerFrom;}
                    obj_player.collisionLayer = layerFrom;
                    obj_player.depth = priorityFrom;
                }
            }
        }
    }
    currentSide = (obj_player.x >= x) * GREATER;
} else {
    if ((obj_player.x >= x-radius)
    &&  (obj_player.x < x+radius)) {
        if ((grounded && !obj_player.falling)
        ||  !grounded) {
            if (currentSide == LESSER) {
                if (obj_player.y >= y) {
                    //if (!onlySetPriority) {obj_player.collisionLayer = layerTo;}
                    obj_player.collisionLayer = layerTo;
                    obj_player.depth = priorityTo;
                }
            } else {
                if (obj_player.y < y) {
                    //if (!onlySetPriority) {obj_player.collisionLayer = layerFrom;}
                    obj_player.collisionLayer = layerFrom;
                    obj_player.depth = priorityFrom;
                }
            }
        }
    }
    currentSide = (obj_player.y >= y) * GREATER;
}

