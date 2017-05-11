.include "globals.inc"

.segment "ZEROPAGE"

debug: .res 1
subroutine_temp: .res 1
ptr_temp: .res 2

p1_buttons_held: .res 1
p1_buttons_pressed: .res 1
p2_buttons_held: .res 1
p2_buttons_pressed: .res 1

nmi_counter:    .res 1
frame_number:    .res 1

rng_state: .res 2

; Line Drawing
from_x_sub: .res 1
from_x:     .res 2
from_y_sub: .res 1
from_y:     .res 2
to_x_sub:   .res 1
to_x:       .res 2
to_y_sub:   .res 1
to_y:       .res 2

from_out_code: .res 1
to_out_code:   .res 1

Dx_sub: .res 1
Dx:     .res 2
Dy_sub: .res 1
Dy:     .res 2
rounded_Dx: .res 1
rounded_Dy: .res 1

px: .res 2
py: .res 2
fx: .res 2
fy: .res 2

inter: .res 1

.segment "BSS" ; RAM
nt_buffer: .res 32*24

.segment "SMALL_TABLES"
banktable:
.repeat 16, i
    .byt i
.endrepeat
