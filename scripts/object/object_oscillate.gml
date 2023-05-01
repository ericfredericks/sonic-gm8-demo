#define object_oscillate

global.oscSpeed0 = osc_update_speed(global.oscSpeed0,global.oscDir0,0.007812); // 2 * 1/256
global.oscData0 += global.oscSpeed0;
global.oscDir0 = osc_update_dir(global.oscData0,global.oscDir0,$10);

global.oscSpeed8 = osc_update_speed(global.oscSpeed8,global.oscDir8,0.007812);
global.oscData8 += global.oscSpeed8;
global.oscDir8 = osc_update_dir(global.oscData8,global.oscDir8,$20);

global.oscSpeed12 = osc_update_speed(global.oscSpeed12,global.oscDir12,0.007812);
global.oscData12 += global.oscSpeed12;
global.oscDir12 = osc_update_dir(global.oscData12,global.oscDir12,$30);

global.oscSpeed28 = osc_update_speed(global.oscSpeed28,global.oscDir28,0.015625); // 4 * 1/256
global.oscData28 += global.oscSpeed28;
global.oscDir28 = osc_update_dir(global.oscData28,global.oscDir28,$40);

global.oscSpeed40 = osc_update_speed(global.oscSpeed40,global.oscDir40,0.007812);
global.oscData40 += global.oscSpeed40;
global.oscDir40 = osc_update_dir(global.oscData40,global.oscDir40,$20);

global.oscSpeed44 = osc_update_speed(global.oscSpeed44,global.oscDir44,0.011718); // 3 * 1/256
global.oscData44 += global.oscSpeed44;
global.oscDir44 = osc_update_dir(global.oscData44,global.oscDir44,$30);

global.oscSpeed48 = osc_update_speed(global.oscSpeed48,global.oscDir48,0.019531); // 5 * 1/256
global.oscData48 += global.oscSpeed48;
global.oscDir48 = osc_update_dir(global.oscData48,global.oscDir48,$50);

global.oscSpeed52 = osc_update_speed(global.oscSpeed52,global.oscDir52,0.027343); // 7 * 1/256
global.oscData52 += global.oscSpeed52;
global.oscDir52 = osc_update_dir(global.oscData52,global.oscDir52,$70);

global.oscSpeed56 = osc_update_speed(global.oscSpeed56,global.oscDir56,0.007812);
global.oscData56 += global.oscSpeed56;
global.oscDir56 = osc_update_dir(global.oscData56,global.oscDir56,$40);

global.oscSpeed60 = osc_update_speed(global.oscSpeed60,global.oscDir60,0.007812);
global.oscData60 += global.oscSpeed60;
global.oscDir60 = osc_update_dir(global.oscData60,global.oscDir60,$40);

