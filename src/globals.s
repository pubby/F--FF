.include "globals.inc"

.segment "ZEROPAGE"

subroutine_temp: .res 1
ptr_temp: .res 2

nmi_counter:    .res 1
frame_number:    .res 1

; Line Drawing
from_x_sub: .res 1
from_x:     .res 2
from_y_sub: .res 1
from_y:     .res 2
to_x_sub:   .res 1
to_x:       .res 2
to_y_sub:   .res 1
to_y:       .res 2

px: .res 2
py: .res 2
fx: .res 2
fy: .res 2

; Game
p1:
p1_buttons_held: .res 1
p1_buttons_pressed: .res 1
p1_x:     .res 2
p1_y:     .res 2
p1_dir:   .res 1
p1_speed: .res 2

p2:
p2_buttons_held: .res 1
p2_buttons_pressed: .res 1
p2_x:     .res 2
p2_y:     .res 2
p2_dir:   .res 1
p2_speed: .res 2

; Multiplication
multiplicand: .res 2
multiplier:   .res 2
product:      .res 2

trig_ptr1: .res 2
trig_ptr2: .res 2
trig_ptr3: .res 2
trig_ptr4: .res 2

.segment "BSS" ; RAM
nt_buffer: .res 32*22

.segment "SMALL_TABLES"
banktable:
.repeat 16, i
    .byt i
.endrepeat
