#define oneway_pseudo

/* notes on object $2d
object offset $32 : start y
object offset $38 : left activation bound
object offset $3a : right activation bound

init routine:
    object offset $32 = object y
    d2 = object x - 512
    d3 = object x + 24
    if (xflip) {
        d2 += 488
        d3 += 488
    }
    object offset $38 = d2
    object offset $3a = d3
    
main routine:
    if (!xflip) {
        d2 = object offset $38
        d3 = object x
        if (secondary routine != 0) d3 = object offset $3a
    }
    else {
        d2 = object x
        d3 = object offset $3a
        if (secondary routine != 0) d2 = object offset $38
    }
    d4 = object offset $32 - 32
    d5 = object offset $32 + 32
    secondary routine = 0
    a1 = player 1
    call check character routine
    a1 = player 2
    call check character routine
    
    if (secondary routine != 0) {
        if (object offset $30 != 64) {
            object offset $30 += 8
            object y = object offset $32 - object offset $30
        }
    }
    else {
        if (object offset $30 != 0) {
            object offset $30 -= 8
            object y = object offset $32 - object offset $30
        }
    }
    return
    
check character routine:
d2 : rectangle left
d4 : rectangle top
d3 : rectangle right
d5 : rectangle bottom
    d0 = player x
    if (d0 < d2) return
    if (d0 >= d3) return
    d0 = player y
    if (d0 < d4) return
    if (d0 >= d5) return
    if (player objcontrol) return
    secondary routine = 1
    return
    
    
    
*/

