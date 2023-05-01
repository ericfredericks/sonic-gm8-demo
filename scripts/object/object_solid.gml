#define object_solid
var IGNORE_YSP_JUMP_ROLL,IGNORE_SIDES,IGNORE_BOTTOM,STORE_X_ON_LANDING;
IGNORE_YSP_JUMP_ROLL = argument0;
IGNORE_SIDES = argument1;
IGNORE_BOTTOM = argument2;
STORE_X_ON_LANDING = argument3;

// aabb check with player
if (!beingStoodOn && !obj_player.objectControl) {
    var combinedWidth,combinedHeight;
    var leftDist,topDist;
    combinedWidth = w+obj_player.W_PUSH+1;
    combinedHeight = obj_player.h+h;
    leftDist = obj_player.x-x + combinedWidth;
    if ((leftDist >= 0) && (leftDist <= (combinedWidth*2))) {
        topDist = obj_player.y-y + 4 + combinedHeight;
        if ((topDist >= 0) && (topDist <= (combinedHeight*2))) {
            // choose direction, distance to push player
            var xDist,yDist;
            xDist = leftDist - combinedWidth*2*(obj_player.x>x);
            yDist = topDist - (4+combinedHeight*2)*(obj_player.y>y);
            if ((abs(xDist) > abs(yDist))
            || IGNORE_SIDES) {
                if (!IGNORE_BOTTOM) {
                    if (yDist<0) {
                        if (obj_player.ysp<0) {
                            obj_player.y -= yDist;
                            obj_player.ysp = 0;
                        }
                    }
                }
                if ((yDist>0) && (yDist<16)) {
                    yDist -= 4;
                    var xCompare;
                    xCompare = x+combinedWidth - obj_player.x;
                    if ((xCompare>=0)
                    &&  (xCompare<(combinedWidth*2))) {
                        if (obj_player.ysp >= 0) {
                            obj_player.y -= yDist+1;
                            obj_player.falling = false;
                            if (!IGNORE_YSP_JUMP_ROLL) {
                                if (obj_player.rolling || obj_player.jumping) {
                                    obj_player.y -= 5;
                                    obj_player.w = obj_player.W_NONE;
                                    obj_player.h = obj_player.H_NONE;
                                    obj_player.rolling = false;
                                    obj_player.jumping = false;
                                }
                                obj_player.ysp = 0;
                            }
                            obj_player.sprung = false;
                            obj_player.ang = 0;
                            obj_player.standingOnObject = id;
                            beingStoodOn = true;
                            obj_player.gsp = obj_player.xsp;
                            if (STORE_X_ON_LANDING) {
                                xOnLanding = floor(obj_player.x-obj_player.xsp)-x;
                            }
                        }
                    }
                }
            } else {
                if (abs(yDist) > 4) {
                    obj_player.x -= xDist;
                    if (((xDist>0) && (obj_player.xsp>0))
                    ||  ((xDist<0) && (obj_player.xsp<0))) {
                        obj_player.xsp = 0;
                        obj_player.gsp = 0;
                        obj_player.pushingObject = true;
                        beingPushed = true;
                    }
                }
            }
        }
    }
}

