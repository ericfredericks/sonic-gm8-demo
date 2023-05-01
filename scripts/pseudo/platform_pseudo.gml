#define platform_pseudo

/* notes on oscillating numbers
oscillating data :
    16 values that approximate cos(fc) * C
    & 16 speeds to alter the values mixed in between
oscillation control : acceleration direction for each osc data
oscillating data 2 (word_4B24):
    16 accelerations to add/subtract from osc data speed
    & 16 thresholds osc data has to cross to flip acceleration

num init routine (sub_4A70):
    oscillation control = #%0000000001111101
    oscillating data[0] = #$80
    oscillating data[1] = #0
    oscillating data[2] = #$80
    oscillating data[3] = #0
    ...
    osc data[26] = #$7080
    osc data[27] = #$276
    osc data[28] = #$80
    osc data[29] = #0
    osc data[30] = #$4000
    osc data[31] = #$fe
    return
    
num do routine (sub_4AC6):
    a1 = osc data
    a2 = osc data 2
    d1 = #16
    while (d1):
        d2 = a2 acc
        d4 = a2 threshold
        a2 += #4
        if (!(bit d1 of osc control)) {
            a1 spd += d2
            a1 val += a1 spd
            if (d4 <= a1 val.b) bit d1 of osc control = #1
        }
        else {
            a1 spd -= d2
            a1 val += a1 spd
            if (d4 > a1 val.b) bit d1 of osc control = #0
        }
        a1 += #4
        d1 -= #1
    return
*/

/* notes on object $19
object offset $30 : start x
object offset $32 : start y
object status : contains xflip (bit 0), beingstoodon (bits 3-4)

init routine:
    object offset $30 = object x
    object offset $32 = object y    
    object param &= #$f
    if ((object param == #3) && xflip) object y -= #192
    if ((object param == #7)) object y -= #192
    
main routine:
    if (object param > #$b) branch move routine 8
    if (object param > #7) branch move routine 7
    if (object param > #5) branch move routine 6
    if (object param == #5) return
    if (object param == #xx) branch move routine xx+1
    
move routine 1 (loc_2211C):
    d0 = osc data[#8].b (#128<->-#80)
    d1 = #64
    ^^ diameter of platform movement ?
    branch move routine 2b

move routine 2:
    d0 = osc data[#12].b (#128<->#-64)
    d1 = #96
    
move routine 2b:
    if (xflip) d0 = -d0 + d1
    object x = start x - d0
    return
    
move routine 3:
    d0 = osc data[#28].b (#128<->#0)
    d1 = #128
    if (xflip) d0 = -d0 + d1
    object y = start y - d0
    return
    
move routine 4:
    if (beingstoodon) object param += #1
    return

move routine 5:
    d1 = #8
    d0 = start y - #96
    if (d0 < object y) d1 = -d1
    object ysp += d1
    if (object ysp == 0) object param += #1
    ^^ going to require flag in my engine
    return
    
move routine 6:
     d1 = #8
     d0 = start y - #96
     if (d0 < object y) d1 = -d1
     object ysp += d1
     return
     
move routine 7:
    d1 = osc data[#56].b (#128<->#0)
    d1 -= #64
    d2 = osc data[#60].b (#16384<->-#16256)
    d2 -= #64
    if (bit 1 of object param) {
        d1 = -d1
        d2 = -d2
    }
    if (bit 0 of object param) {
        d1 = -d1
        swap d1, d2
    }
    object x = start x + d1
    object y = start y + d2
    return
    
move routine 8:
    d1 = osc data[#56].b (#128<->#0)
    d1 -= #64
    d2 = osc data[#60].b (#16384<->-#16256)
    d2 -= #64
    if (bit 1 of object param) {
        d1 = -d1
        d2 = -d2
    }
    if (bit 0 of object param) {
        d1 = -d1
        swap d1, d2
    }
    d1 = -d1
    object x = start x + d1
    object y = start y + d2
    return
*/

