#define input_step
aHold = aBtn;
lHold = lBtn;
rHold = rBtn;
downHold = yAxis>0;
startHold = startBtn;
xAxis = -keyboard_check(vk_left)+keyboard_check(vk_right);
xAxis += round(joystick_xpos(1));
yAxis = -keyboard_check(vk_up)+keyboard_check(vk_down);
yAxis += round(joystick_ypos(1));
aBtn = keyboard_check(ord('Z'))+joystick_check_button(1,1);
lBtn = keyboard_check(ord('A'))+joystick_check_button(1,3);
rBtn = keyboard_check(ord('X'))+joystick_check_button(1,2);
startBtn = keyboard_check(vk_enter);


