#define player_step

// debug move
if (mouse_check_button(mb_left)) {
    x = mouse_x;
    y = mouse_y;
    player_init();
}
if (mouse_check_button(mb_right)) {
    if (room != room_last) {
        room_goto_next();
    }
    else {
        room_goto(room_first);
    }
}

if (!objectControl) {
    if (!falling) {
        if (!rolling) {
            player_spindash();
            // slope
            slope = slp;
            gsp -= slope*sin(degtorad(ang));
            if ((x-w+xsp)<(obj_camera.x+CAMERA_WIDTH)) {
                player_jump();
            }
            player_groundinput();
            // new xsp and ysp
            if (!sprung) {
                xsp = cos(degtorad(ang))*gsp;
                ysp = -sin(degtorad(ang))*gsp;
                if (jumping) {
                    xsp -= jmp*sin(degtorad(ang));
                    ysp -= jmp*cos(degtorad(ang));
                }
            }
            // balancing, looking, and ducking
            balancing = false;
            looking = false;
            if (!duckTimer) {ducking = false;}
            if (!controlLock) {
                if ((gsp == 0)
                &&  ((sensorA&&!sensorB)||(sensorB&&!sensorA))
                &&  !player_K()) {
                    if ( (!sensorA&&(image_xscale<0))
                    ||   (!sensorB&&(image_xscale>0)) ) {
                        balancing = true;
                    }
                }
                if (!balancing
                &&  !jumping
                && (gsp == 0)
                && !mode) {
                    looking = obj_input.yAxis<0;
                    if (obj_input.yAxis>0) {
                        ducking = true;
                        duckTimer = 4;
                    }
                }
            }
            if (duckTimer > 0) {duckTimer -= 1;}
            // sensor E activation
            sensorE = ((gsp != 0)||standingOnObject)
            && ((ang<90)||(ang>270)||!(ang mod 90));
            if (sensorE) {
                player_E();
            }
            if (!controlLock) {
                // start roll
                if ((obj_input.yAxis>0)
                && (abs(xsp)>=0.5)
                && !mode) {
                    if (!jumping && !rolling) {
                        w = W_CURL;
                        h = H_CURL;
                        y += 5;
                        rolling = true;
                        looking = false;
                        ducking = false;
                    }
                }
            }
            player_camera();
            if (!standingOnObject
            && ((x-w+xsp)<(obj_camera.x+CAMERA_WIDTH))) {
                player_AB();
            }
            // move player
            x += xsp;
            y += ysp;
            // set mode
            mode = round(ang/90);
            if (mode == 4) {mode = 0;}
            // slip off slope
            if ((ang >= 46)&&(ang <= 315)) {
                if (abs(gsp)<fall) {
                    if (!horizontalLockTime) {
                        falling = true;
                        horizontalLockTime = 30;
                    }
                }
            }
            player_image();
            // decrement horizontal lock
            if (horizontalLockTime > 0) {
                horizontalLockTime -= 1;
            }
        }
        else {
            // slope
            slope = slprolldown;
            if (sign(gsp)==sign(sin(degtorad(ang)))) {
                slope = slprollup;
            }
            gsp -= slope*sin(degtorad(ang));
            if ((x-w+xsp)<(obj_camera.x+CAMERA_WIDTH)) {
                player_jump();
            }
            player_rollinput();
            // new xsp and ysp
            if (!sprung) {
                xsp = cos(degtorad(ang))*gsp;
                ysp = -sin(degtorad(ang))*gsp;
                if (jumping) {
                    xsp -= jmp*sin(degtorad(ang));
                    ysp -= jmp*cos(degtorad(ang));
                }
            }
            // sensor E activation
            sensorE = ((gsp != 0)||standingOnObject)
            && ((ang<90)||(ang>270)||!(ang mod 90));
            if (sensorE) {
                player_E();
            }
            player_camera();
            if (!standingOnObject
            && ((x-w+xsp)<(obj_camera.x+CAMERA_WIDTH))) {
                player_AB();
            }
            // move player
            x += xsp;
            y += ysp;
            // set mode
            mode = round(ang/90);
            if (mode == 4) {mode = 0;}
            // slip off slope
            if ((ang >= 46)&&(ang <= 315)) {
                if (abs(gsp)<fall) {
                    if (!horizontalLockTime) {
                        falling = true;
                        horizontalLockTime = 30;
                    }
                }
            }
            player_image();
            // decrement horizontal lock
            if (horizontalLockTime > 0) {
                horizontalLockTime -= 1;
            }
            // end roll
            if (rolling && (gsp == 0)) {
                w = W_NONE;
                h = H_NONE;
                y -= 5;
                rolling = false;
            }
        }
    }
    else {
        gsp = 0;
        player_fallinput();
        // rotate angle to zero
        if (ang != 0) {
            if (ang <= 180) {
                ang -= min(2.8125,ang);
            }
            else {
                ang = min(ang+2.8125,360);
                if (ang == 360) {
                    ang = 0;
                }
            }
        }
        // set mode to zero
        mode = 0;
        if (((x+w+xsp)>=obj_camera.x+CAMERA_WIDTH)) {
            x = obj_camera.x+CAMERA_WIDTH - w;
            xsp = 0;
        }
        // sensor activation
        sensorE = xsp != 0;
        sensorsAB = ysp > 0;
        sensorsCD = ysp < 0;
        if (sensorE) {
            player_E();
        }
        if (sensorsAB) {
            player_AB();
        }
        if (sensorsCD) {
            player_CD();
        }
        player_camera();
        // move player
        x += xsp;
        y += ysp;
        if (ysp < 16) {
            ysp += grv;
            if (ysp > 16) {
                ysp = 16;
            }
        }
        if (!falling) {
            player_landing();
            if (rolling || jumping) {
                y -= 5;
                w = W_NONE;
                h = H_NONE;
                rolling = false;
                jumping = false;
            }
            sprung = false;
        }
        player_image();
    }
    
    if (jumping && standingOnObject) {
        standingOnObject = false;
    }
    pushingObject = false;
}
else {
    player_camera();
    image_index = 1;
}

