#define moving_box_platform_pseudo

/* notes on object $6B
(see platform_pseudo for notes on osc data)
object offset $34 : start x
object offset $30 : start y
object offset $2e : start status
object offset $38 : y acceleration
object status : contains xflip (bit 0), yflip (bit 1), beingstoodon (bits 3-4)
uses osc data 8,28,42,0,40,44,46,48,50,52,54

init function:
    d0 = (bits 5-7 of object param) >> 3
    if (d0 == 0) {
        object w = 32
        object h = 12
    }
    if (d0 == 4) {
        object w = 16
        object h = 16
    }
    object offset $34 = object x
    object offset $30 = object y
    object offset $2e = object status
    d0 = (bits 0-3 of object param) - 8
    if (d0 >= 0) branch main function
    d0 = d0 << 2
    a2 = osc data[42] + d0
    if (a2[0] >= 0) branch main function
    bit 0 of object offset $2e = !bit 0 of object offset $2e
    
main function:
    object param &= $f
    if (object param == 0) return
    if (object param == xx) branch move function xx

move function 1 (loc_27E68):
    d1 = 64
    d0 = osc data[8].b
    branch move function 2b

move function 2:
    d1 = 96
    d0 = osc data[28].b

move function 2b:
    if (bit 0 of object status) d0 = -d0 + d1
    object x = start x - d0
    return
    
move function 3:
    d1 = 64
    d0 = osc data[8].b
    branch move function 4b
    
move function 4:
    d1 = 128
    d0 = osc data[28].b
    
move function 4b:
    if (bit 0 of object status) d0 = -d0 + d1
    object y = start y - d0
    return
    
move function 5 (loc_27EC4):
    object y = ((osc data[0].b) >> 1) + start y
    if (!beingstoodon) return
    object param += 1
    return
    
move function 6:
    object y += object ysp << 8
    object ysp += 8
    d0 = camera bbound + 224
    if (object y > d0) object param = 0
    return

move function 7:
    if (object offset $38 == 0) {
        if (!beingstoodon) return
        object offset $38 = 8
    }
    object x += object xsp << 8
    object y += object ysp << 8
    if (object ysp == 680) object offset $38 = -object offset $38

    object ysp += object offset $38
    if (object ysp != 0) return
    object param = 0
    return

move function 8:
    d1 = 16
    d0 = (osc data[40].b) >> 1
    d3 = osc data[42]
    branch move function bb
    
move function 9:
    d1 = 48
    d0 = osc data[44].b
    d3 = osc data[46]
    branch move function bb
    
move function a:
    d1 = 80
    d0 = osc data[48].b
    d3 = osc data[50]
    branch move function bb
    
move function b:
    d1 = 112
    d0 = osc data[52].b
    d3 = osc data[54]
    
move function bb:
    if (d3 == 0) {
        object offset $2e += 1
        object offset $2e &= 3
    }
    d2 = object offset $2e & 3
    if (d2 == 0) {
        d0 -= d1
        object x = d0 + object offset $34
        d1 = -d1
        object y = d1 + object offset $30
        return
    }
    d2 -= 1
    if (d2 == 0) {
        d1 -= 1
        d0 -= d1
        d0 = -d0
        object y = d0 + object offset $30
        d1 += 1
        object x = d1 + object offset $34
        return
    }
    d2 -= 1
    if (d2 == 0) {
        d1 -= 1
        d0 -= d1
        d0 = -d0
        object x = d0 + object offset $34
        d1 += 1
        object y = d1 + object offset $30
        return
    }
    d0 -= d1
    object y = d0 + object offset $30
    d1 = -d1
    object x = d1 + object offset $34
    return

*/

