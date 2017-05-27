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

; Rendering
render_temp: .res 1

lx_lo_ptr: .res 2
lx_hi_ptr: .res 2
ly_lo_ptr: .res 2
ly_hi_ptr: .res 2
rx_lo_ptr: .res 2
rx_hi_ptr: .res 2
ry_lo_ptr: .res 2
ry_hi_ptr: .res 2

scratchpad_lx_lo: .res 12
scratchpad_lx_hi: .res 12
scratchpad_ly_lo: .res 12
scratchpad_ly_hi: .res 12
scratchpad_rx_lo: .res 12
scratchpad_rx_hi: .res 12
scratchpad_ry_lo: .res 12
scratchpad_ry_hi: .res 12

.segment "BSS" ; RAM
nt_buffer: .res 32*22

.segment "SMALL_TABLES"
banktable:
.repeat 16, i
    .byt i
.endrepeat
