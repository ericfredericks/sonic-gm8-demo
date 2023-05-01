#define pipeseal_step

beingPushed = false;

object_solid(true,false,false,false);

if (beingPushed) {
    object_player_camera_x();
}
object_being_stood_on();
if (beingStoodOn) {
    if ((obj_player.jumping || obj_player.rolling)
    &&  (obj_player.ysp > 0)) {
        obj_player.ysp = -4;
        obj_player.standingOnObject = false;
        beingStoodOn = false;
        var o;
        o = instance_create(x-8,y-8,obj_pipeseal_shard);
        o.prevImageIndex = 0;        
        o.depth = PRIORITY_LAYER_LOW;
        o.xsp = -1; o.ysp = -2;
        o = instance_create(x+8,y-8,obj_pipeseal_shard);
        o.prevImageIndex = 1;        
        o.depth = PRIORITY_LAYER_LOW;
        o.xsp = 1; o.ysp = -2;
        o = instance_create(x-8,y+8,obj_pipeseal_shard);
        o.prevImageIndex = 0;        
        o.depth = PRIORITY_LAYER_LOW;
        o.xsp = -0.752941; o.ysp = -1.752941;
        o = instance_create(x+8,y+8,obj_pipeseal_shard);
        o.prevImageIndex = 1;        
        o.depth = PRIORITY_LAYER_LOW;
        o.xsp = 0.752941; o.ysp = -1.752941;
        instance_destroy();
    }
    object_player_camera_y();
}


