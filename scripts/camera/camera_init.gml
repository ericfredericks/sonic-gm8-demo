#define camera_init

xsp = 0;
ysp = 0;
pan = 0;
panSpd = 0;
panChange = 0;

xLocked = false;
prevX = x;
prevY = y;
prevPan = pan;

view_xview[CAMERA_0] = x;
view_yview[CAMERA_0] = y;

window_set_size(CAMERA_WIDTH*2,CAMERA_HEIGHT*2);

/* GM cannot resize viewport in code
view_enabled = true;
view_visible[CAMERA_0] = true;
window_set_size(CAMERA_WIDTH,CAMERA_HEIGHT);
view_wport[CAMERA_0] = window_get_region_width();
view_hport[CAMERA_0] = window_get_region_height();
window_set_region_scale(0,1);
window_center();
*/

