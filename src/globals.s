.include "globals.inc"

.segment "ZEROPAGE"

subroutine_temp: .res 1
ptr_temp: .res 2

buttons_held: .res 1
buttons_pressed: .res 1

nmi_counter:    .res 1
frame_number:    .res 1

rng_state: .res 2

from_x: .res 2
from_y: .res 2
to_x: .res 2
to_y: .res 2

.segment "BSS" ; RAM
nt_buffer: .res 1024

.segment "RODATA"
xdiv:
.repeat 256, i
    .byt i / 4
.endrepeat
