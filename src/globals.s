.include "globals.inc"

.segment "ZEROPAGE"

debug: .res 2
subroutine_temp: .res 1
ptr_temp: .res 2

nmi_x: .res 1
nmi_y: .res 1

nmi_counter:    .res 1
frame_number:   .res 1
frame_ready:    .res 1
subframes_left: .res 1

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

; Line Drawing
from_x_sub:  .res 1
from_x:      .res 2
from_y_sub:  .res 1
from_y:      .res 2
to_x_sub:    .res 1
to_x:        .res 2
to_y_sub:    .res 1
to_y:        .res 2

l1100: .res 1
l1010: .res 1
l0110: .res 1
l1001: .res 1
l0101: .res 1
l0011: .res 1
l0001: .res 1
l0010: .res 1
l0100: .res 1
l1000: .res 1

; Multiplication
multiply_sub: .res 1

; Rendering
y_temp: .res 1
recip_ptr: .res 2

lx_lo_ptr: .res 2
lx_hi_ptr: .res 2
ly_lo_ptr: .res 2
ly_hi_ptr: .res 2
rx_lo_ptr: .res 2
rx_hi_ptr: .res 2
ry_lo_ptr: .res 2
ry_hi_ptr: .res 2

.segment "BSS" ; RAM
pad_size = 6

scratchpad:
scratchpad_lx_lo: .res pad_size
scratchpad_lx_hi: .res pad_size
scratchpad_ly_lo: .res pad_size
scratchpad_ly_hi: .res pad_size
scratchpad_rx_lo: .res pad_size
scratchpad_rx_hi: .res pad_size
scratchpad_ry_lo: .res pad_size
scratchpad_ry_hi: .res pad_size

depthpad_lx_lo: .res pad_size
depthpad_lx_hi: .res pad_size
depthpad_ly_lo: .res pad_size
depthpad_ly_hi: .res pad_size
depthpad_rx_lo: .res pad_size
depthpad_rx_hi: .res pad_size
depthpad_ry_lo: .res pad_size
depthpad_ry_hi: .res pad_size

nt_buffer: .res 32*22

.segment "SMALL_TABLES"
banktable:
.repeat 16, i
    .byt i
.endrepeat
