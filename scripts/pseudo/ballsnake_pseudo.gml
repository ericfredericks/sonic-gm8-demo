#define ballsnake_pseudo
/* pseudocode adaptation of the original code
object offset $30 : start y (for arc/straight movement)
object offset $32 : counts down until movement
object offset $34 : start ysp (for arc/straight movement)
object offset $36 : x acceleration (for arc movement)
object offset $38 : start x (for straight movement)
object offset $3a : x offset (for straight movement)
object status : contains xflip (bit 0)
a0 : address of object $1d

init routine (loc_22428):
    object routine = wait routine
    object ysp = #-4.5
    d1 = bits 0-3 of object param
    d0 = bits 4-7 of object param
    if != #0, d5 = wait routine 2
    else, d5 = wait routine 1
    d4 = object status
    d2 = #0
    a1 = a0
    branch init ball routine
    
init ball routine (loc_22458):
    loop d1 times:
        if (!first loop) {
            a1 = create instance of object
        }
        a1 id = object id
        a1 x = object x
        a1 y = object y
        a1 routine = d5
        a1 offset $38 = a1 x
        a1 offset $30 = a1 y
        a1 ysp = object ysp
        a1 offset $34 = a1 ysp
        a1 w = #8
        a1 offset $3a = #$60
        a1 offset $36 = #$b
        d4 &= #1
        if (d4 != #0) {
            a1 offset $36 = -a1 offset $36
            a1 offset $3a = -a1 offset $3a
        }
        a1 offset $32 = d2
        d2 += #3
    return
    
wait routine 1 (loc_224D6):
    if (!(--object offset $32 < #0)) branch delete object if offscreen
    object routine = move arc routine
    object offset $32 = #$3b
    branch delete object if offscreen
    
move arc routine (loc_224F4):
    object x += object xsp << #8
    object y += object ysp << #8
    object xsp += object offset $36
    object ysp += #$18
    if (object ysp == #0) object offset $36 = -object offset $36
    
    check if y >= start y:
        d0 = object offset $30
        if (d0 > object y) branch delete object if offscreen
        object ysp = object offset $34
        object xsp = #0
        object routine = wait routine 1
    
    branch delete object if offscreen
    
wait routine 2 (loc_224D6):
    if (!(--object offset $32 < #0)) branch delete object if offscreen
    object routine = move straight routine
    object offset $32 = #$3b
    branch delete object if offscreen
    
move straight routine (loc_22528):
    object x += object xsp << #8
    object y += object ysp << #8
    object ysp += #$18
    if (object ysp == #0) object x = object offset $3a + object offset $38
    
    check if y >= start y:
        d0 = object offset $30
        if (d0 > object y) branch delete object if offscreen
        object ysp = object offset $34
        object x = object offset $38

   branch delete object if offscreen
*/

