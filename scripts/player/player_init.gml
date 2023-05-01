#define player_init

w = W_NONE;
h = H_NONE;

fc = 0;
fc2 = 0;
xsp = 0;
ysp = 0;
gsp = 0;
ang = 0;
mode = 0;
falling = false;
rolling = false;
jumping = false;
braking = false;
canBrake = false;
balancing = false;
looking = false;
ducking = false;
duckTimer = 0;
spinrev = 0;
spindash = false;
slope = slp;
horizontalLockTime = 0;
standingOnObject = false;
pushingObject = false;
sprung = false;
vFocalPoint = DEFAULT_VFOCALPOINT;
objectControl = false;
controlLock = false;
holdRight = false;

sensorsAB = false;
sensorsCD = false;
sensorA = noone;
sensorB = noone;
sensorC = noone;
sensorD = noone;
sensorJ1 = noone;
sensorJ2 = noone;
sensorE = noone;
collisionLayer = COLLISION_LAYER_A;
depth = PRIORITY_LAYER_LOW;

