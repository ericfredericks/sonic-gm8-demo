#define osc_update_speed
var SPD,ACC_DIR,ACC;
SPD = argument0;
ACC_DIR = argument1;
ACC = argument2;
return ((ACC_DIR==0)*(SPD+ACC))+((ACC_DIR!=0)*(SPD-ACC));

