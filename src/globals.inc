.ifndef GLOBAL_INC
.define GLOBAL_INC

.include "nes.inc"
.include "macros.inc"

CPU_OAM = $0200
rom_bank = $3FFF

FB_READY  = 1 << 0
FPS_READY = 1 << 1

TF_BLANK = 1 << 0
TF_JUMP = 1 << 1

SPLITSCREEN_LEFT = 1
SPLITSCREEN_RIGHT = 2

draw_line_octant1 = $0300

Dx_sub      = 0 ; 1 byte
Dx          = 1 ; 2 bytes
Dy_sub      = 3 ; 1 byte
Dy          = 4 ; 2 bytes
rounded_Dx  = 6 ; 1 byte
rounded_Dy  = 7 ; 1 byte
to_out_code = 6 ; 1 byte, shared with rounded_Dx

menu_state = scratchpad+0
menu_data = scratchpad+1
menu_timer = scratchpad+2
menu_scroll = scratchpad+3
menu_icy_x = scratchpad+4
menu_spicy_x = scratchpad+5
menu_dicey_x = scratchpad+6
menu_cursor = scratchpad+7
menu_update_ptr = scratchpad+8 ; 2 bytes

MENU_2P = 1
MENU_SHOW_CURSOR = 2

PLAYERS_2 = %10000000


multiply = $78
.define multiply_label(l, o) .lobyte(multiply + .ident(.sprintf("mvar_%s", .string(l))) - multiply_code + o)

.macro bankswitch bank
    lda #bank
    sta *-1
.endmacro

.macro bankswitch_y
    lda banktable, y
    sta banktable, y
.endmacro

.macro bankswitch_to label
    lda #.lobyte(.bank(label))
    sta *-1
.endmacro

.globalzp debug
.globalzp subroutine_temp
.globalzp ptr_temp

.globalzp nmi_x
.globalzp nmi_y
.globalzp nmi_bank
.globalzp nmi_ptr

.globalzp nmi_counter
.globalzp frame_number
.globalzp frame_ready
.globalzp subframes_left

.globalzp update_ptr

; Game
.globalzp p1
.globalzp p1_buttons_held
.globalzp p1_buttons_pressed
.globalzp p1_x
.globalzp p1_y
.globalzp p1_dir
.globalzp p1_speed
.globalzp p1_dir_speed
.globalzp p1_lift
.globalzp p1_track_index
.globalzp p1_boost_tank
.globalzp p1_boost_timer
.globalzp p1_boost
.globalzp p1_slowdown

.globalzp p2
.globalzp p2_buttons_held
.globalzp p2_buttons_pressed
.globalzp p2_x
.globalzp p2_y
.globalzp p2_dir
.globalzp p2_speed
.globalzp p2_dir_speed
.globalzp p2_lift
.globalzp p2_track_index
.globalzp p2_boost_tank
.globalzp p2_boost_timer
.globalzp p2_boost
.globalzp p2_slowdown

.globalzp level_length

.globalzp lx_lo_ptr
.globalzp lx_hi_ptr
.globalzp ly_lo_ptr
.globalzp ly_hi_ptr
.globalzp rx_lo_ptr
.globalzp rx_hi_ptr
.globalzp ry_lo_ptr
.globalzp ry_hi_ptr
.globalzp tf_ptr

; Line drawing
.globalzp from_x_sub
.globalzp from_x
.globalzp from_y_sub
.globalzp from_y
.globalzp to_x_sub
.globalzp to_x
.globalzp to_y_sub
.globalzp to_y

.globalzp line_splitscreen

.globalzp l1100
.globalzp l1010
.globalzp l0110
.globalzp l1001
.globalzp l0101
.globalzp l0011
.globalzp l0001
.globalzp l0010
.globalzp l0100
.globalzp l1000

; Multiplication
.globalzp multiply_sub

; Rendering
.globalzp y_temp
.globalzp recip_ptr

.global tokumaru_storage
.global scratchpad
.global scratchpad_lx_lo
.global scratchpad_lx_hi
.global scratchpad_ly_lo
.global scratchpad_ly_hi
.global scratchpad_rx_lo
.global scratchpad_rx_hi
.global scratchpad_ry_lo
.global scratchpad_ry_hi

.global depthpad_lx_lo
.global depthpad_lx_hi
.global depthpad_ly_lo
.global depthpad_ly_hi
.global depthpad_rx_lo
.global depthpad_rx_hi
.global depthpad_ry_lo
.global depthpad_ry_hi

; Buffers
.global nt_buffer

; tables
.global banktable

.global PPxy_lo
.global PPxy_hi
.global PPxy_offset

.global PPyx_lo
.global PPyx_hi
.global PPyx_offset

.global NPxy_lo
.global NPxy_hi
.global NPxy_offset

.global NPyx_lo
.global NPyx_hi
.global NPyx_offset

.global recip_and_table
.global recip_or_table
.global recip_asl_table
.global recip_index_table

.global positive_asl
.global negative_asl

.global time_sub
.global time_digits

.global boost_regen_timer
.global game_flags
.global camera_height
.global local_camera_height

.global p1_pre_explosion
.global p1_explosion
.global p1_lap
.global p1_text_timer
.global p1_z
.global p1_zspeed

.global p2_pre_explosion
.global p2_explosion
.global p2_lap
.global p2_text_timer
.global p2_z
.global p2_zspeed

; Multiply Labels
.global multiply_code
.global mvar_p5
.global mvar_p6
.global mvar_p7
.global mvar_p8
.global mvar_p1
.global mvar_p2
.global mvar_p3
.global mvar_p4
.global mvar_s0
.global mvar_s1
.global mvar_ms
.global mvar_q5
.global mvar_q6
.global mvar_q7
.global mvar_q8
.global mvar_hh2
.global mvar_q1
.global mvar_q2 
.global mvar_q3 
.global mvar_q4 
.global mvar_hl1
.global mvar_lh2
.global mvar_hl2
.global mvar_lh1
.global mvar_ll1
.global mvar_la
.global mvar_r3
.global mvar_r2 
.global mvar_stx_temp
.global mvar_jump_neg
.global mvar_jump_pos
.global mvar_last_branch
.global mvar_FF
.global multiply_code_end

; Palette
.global palette_buffer

.endif
