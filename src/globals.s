.include "globals.inc"

.segment "ZEROPAGE"

debug: .res 1
subroutine_temp: .res 1
ptr_temp: .res 2

nmi_x: .res 1
nmi_y: .res 1
nmi_bank: .res 1
nmi_ptr: .res 2

update_ptr: .res 2

game_zp_start:

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
p1_dir:   .res 2
p1_speed: .res 2
p1_dir_speed: .res 1
p1_lift: .res 1
p1_track_index: .res 1
p1_boost_tank: .res 1
p1_boost_timer: .res 1
p1_boost: .res 1
p1_slowdown: .res 1

p2:
p2_buttons_held: .res 1
p2_buttons_pressed: .res 1
p2_x:     .res 2
p2_y:     .res 2
p2_dir:   .res 2
p2_speed: .res 2
p2_dir_speed: .res 1
p2_lift: .res 1
p2_track_index: .res 1
p2_boost_tank: .res 1
p2_boost_timer: .res 1
p2_boost: .res 1
p2_slowdown: .res 1

level_length: .res 1

lx_lo_ptr: .res 2
lx_hi_ptr: .res 2
ly_lo_ptr: .res 2
ly_hi_ptr: .res 2
rx_lo_ptr: .res 2
rx_hi_ptr: .res 2
ry_lo_ptr: .res 2
ry_hi_ptr: .res 2
tf_ptr: .res 2

; Line Drawing
from_x_sub:  .res 1
from_x:      .res 2
from_y_sub:  .res 1
from_y:      .res 2
to_x_sub:    .res 1
to_x:        .res 2
to_y_sub:    .res 1
to_y:        .res 2

line_splitscreen: .res 1

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

.segment "BSS" ; RAM
pad_size = 6

tokumaru_storage:
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

game_bss_start:

time_sub: .res 1
time_digits: .res 4

camera_height: .res 1
local_camera_height: .res 1

p1_pre_explosion: .res 1
p1_explosion: .res 1
p1_lap: .res 1
p1_text_timer: .res 1
p1_jump: .res 1
p1_boost_tank_sub: .res 1

p2_pre_explosion: .res 1
p2_explosion: .res 1
p2_lap: .res 1
p2_text_timer: .res 1
p2_jump: .res 1
p2_boost_tank_sub: .res 1

game_bss_end: .res 1

.align 256
nt_buffer: .res 32*22

palette_buffer: .res 32

track_number: .res 1
timer: .res 1
two_player: .res 1
ship_entrance: .res 1
countdown: .res 1

.segment "SMALL_TABLES"
banktable:
.repeat 16, i
    .byt i
.endrepeat
ship_jump_table:
.byt 0
.byt 1
.byt 3
.byt 5
.byt 6
.byt 8
.byt 9
.byt 11
.byt 12
.byt 14
.byt 15
.byt 16
.byt 17
.byt 18
.byt 19
.byt 20
.byt 21
.byt 22
.byt 23
.byt 23
.byt 24
.byt 24
.byt 25
.byt 25
.byt 26
.byt 26
.byt 26
.byt 27
.byt 27
.byt 27
.byt 27
.byt 27
.byt 27
.byt 26
.byt 26
.byt 26
.byt 25
.byt 25
.byt 24
.byt 24
.byt 23
.byt 23
.byt 22
.byt 21
.byt 20
.byt 19
.byt 18
.byt 17
.byt 16
.byt 15
.byt 14
.byt 12
.byt 11
.byt 9
.byt 8
.byt 6
.byt 5
.byt 3
.byt 1
.byt 0
.byt 0
.byt 0
.byt 0
.byt 0
