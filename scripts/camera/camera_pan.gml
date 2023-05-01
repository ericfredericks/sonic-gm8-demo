#define camera_pan
if (panSpd < abs(panChange)) {
    pan += sign(panChange) * panSpd;
    panChange -= sign(panChange) * panSpd;
}
else {
    pan += panChange;
    panChange = 0;
}

