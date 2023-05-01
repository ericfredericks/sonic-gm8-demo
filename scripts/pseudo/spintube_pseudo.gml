#define spintube_pseudo

/* notes on object $1e
object offset $2c : object mode (player 1)
object offset $36 : object mode (player 2)
object offset $2a : threshold for x collision
a2 : address of tube data
a4[0] : object mode
a4[1] : path to take
a4[2] : counts down until player is moved to new tube pos
a4[4] : counts down until new path is needed
a4[6] : stores copy of a2

init routine:
    d0 = (bits 0-1 of object param) << 1
    if (d0 == 0) object offset $2a = 160
    if (d0 == 2) object offset $2a = 256
    if (d0 == 4) object offset $2a = 288
    
main routine:
    a1 = player 1
    a4 = object offset $2c
    call +
    a1 = player 2
    a4 = object offset $36
+   if (a4 == 0) branch mode 0 routine
    if (a4 == 2) branch mode 2 routine
    if (a4 == 4) branch mode 4 routine
    if (a4 == 6) branch mode 6 routine
    
mode 0 routine (loc_225FC):
    if (debug mode) return
    d2 = object offset $2a
    d0 = player x - object x
    if (d0 >= d2 || d0 < 0) return
    d1 = player y - object y
    if (d1 >= 128 || d1 < 0) return
    
    d3 = 0
    if (d2 == 288) d3 = 8
    if (d2 == 256) {
        d3 = 4
        d0 = -d0 + 160
    }
    
    if (d0 >= 128 || d0 < 0) {
        d0 = (bits 2-5 of object param) >> 2
        if (d0 < 10 || d0 == 11 || d0 == 14) {
            d2 = timer second & 1
        }
        if (d0 == 13 || d0 == 15) d2 = 1
        else d2 = 0
    }
    else {
        d2 = 2
        if (d1 < 64) d2 = 3
    }
    ^^ i set path to -4 if path is set = 0 here
    ^^ and path was = -4 coming in
    ^^ (phase 4 becomes 0 if a maintube section is complete)
    
    a4[1] = d2
    d2 = ((d2 + d3) << 1) & $1e
    a2 = tube entry/exit data + d2
    a4[4] = a2++[0] - 4
    d4 = a2++[0] + object x
    player x = d4
    d5 = a2++[0] + object y
    player y = d5
    a4[6] = a2
    d4 = a2++[0] + object x
    d5 = a2++[0] + object y
    a4[0] += 2
    player objcontrol = 129
    player anim = roll
    player gsp = sign(gsp) * 8
    player xsp = 0
    player ysp = 0
    object beingpushed = false
    player pushingobject = false
    player falling = true
    player jumping = false
    d2 = 8
    call update spd routine
    return

mode 2 routine (loc_2271A) :
    move to next position:
        a4[2] -= 1
        if (a4[2] >= 0) {
            player x += player xsp
            player y += player ysp
            return
        }
    
        a2 = a4[6]
        d4 = a2++[0] + object x
        player x = d4
        d5 = a2++[0] + object y
        player y = d5
        if (a4[1] < 0) a2 -= 8
        a4[6] = a2
    
    decide new position, new path or end:
        a4[4] -= 4
        if (a4[4] != 0) {
            d4 = a2++[0] + object x
            d5 = a2++[0] + object y
            d2 = 8
            branch update spd routine
        }
        if (abs(a4[1]) < 4) {
            d0 = (bits 2-7 of object param) + a4[1]
            a4[1] = 4
            d0 = spintube byte[d0]
            if (d0 != 0) branch new path routine
        }
        a4[0] = 6
        player objcontrol = false
        return
        
mode 4 routine (loc_227FE):
    move to new position:
        a4[2] -= 1
        if (a4[2] >= 0) {
            player x += player xsp
            player y += player ysp
            return
        }
    
        a2 = a4[6]
        d4 = a2++[0]
        player x = d4
        d5 = a2++[0]
        player y = d5
        if (a4[1] < 0) a2 -= 8
        a4[6] = a2
        
    decide new position, new path or end:
        a4[4] -= 4
        if (a4[4] != 0) {
            d4 = a2++[0]
            d5 = a2++[0]
            d2 = 8
            branch update spd routine
        }
        a4[0] = 0
        return
        
mode 6 routine (loc_2286A):
    d2 = object offset $2a
    d0 = player x - object x
    if (d0 >= d2) a4[0] = 0
    else {
        d1 = player y - object y
        if (d1 >= 128) a4[0] = 0
    }
    return
        
new path routine (loc_22892):
^^ no clue how this isnt bugged
^^ changed in implementation
    if (d0 < 0) {
        d0 = -d0 << 1
        a4[1] = -4
        a2 = tube main data + d0
        d0 = a2++[0] - 4
        a4[4] = d0
        a2 += d0
        d4 = a2++[0]
        player x = d4
        d5 = a2++[0]
        player y = d5
        a2 -= 8
    }
    else {
        d0 = d0 << 1
        a2 = tube main data + d0
        a4[4] = a2++[0] - 4
        d4 = a2++[0]
        player x = d4
        d5 = a2++[0]
        player y = d5
    }
    a4[6] = a2
    d4 = a2++[0]
    d5 = a2++[0]
    d2 = 8
    call update spd routine
    a4[0] += 2
    return
    
update spd routine (loc_22902):
^^ d2 is changed from param = $800
d4 : next frame's tube x data
d5 : next frame's tube y data
    d2 = 1
    d3 = d2
    d0 = d4 - player x
    if (d0 < 0) {
        d2 = -1
        d0 = -d0
    }
    d1 = d5 - player y
    if (d1 < 0) {
        d3 = -1
        d1 = -d1
    }
    if (d0 <= d1) {
        d1 = d5 - player y
        word_swap(d1)
        d1 /= 8 * sign(d3)
        d0 = d4 - player x
        if (d0 != 0) {
            word_swap(d0)
            d0 /= d1
        }
        player xsp = d0
        player ysp = 8 * sign(d3)
        a4[2] = abs(d1)
        return
    }
    d0 = d4 - player x
    word_swap(d0)
    d0 /= 2048 * sign(d2)
    d1 = d5 - player y
    if (d1 != 0) {
        word_swap(d1)
        d1 /= d0
    }
    player ysp = d1
    player xsp = 8 * sign(d2)
    a4[2] = abs(d0)
    return   
        
*/

