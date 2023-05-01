#define osc_update_dir
var DATA,ACC_DIR,THRESHOLD;
DATA = argument0;
ACC_DIR = argument1;
THRESHOLD = argument2;
if (ACC_DIR==0) {if (THRESHOLD <= DATA) {return 1;}}
else {if (THRESHOLD > DATA) {return 0;}}
return ACC_DIR;

