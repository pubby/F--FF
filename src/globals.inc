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
menu_scroll = scratchpad+3
menu_icy_x = scratchpad+4
menu_spicy_x = scratchpad+5
menu_dicey_x = scratchpad+6
menu_update_ptr = scratchpad+7 ; 2 bytes

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

.globalzp update_ptr
    ; Zero-out zeropage
    lda #0
    sta PPUMASK
    sta PPUCTRL
    ldx #game_zp_start

.globalzp game_zp_start
.global game_bss_start
.global game_bss_end

.globalzp nmi_counter
.globalzp frame_number
.globalzp frame_ready
.globalzp subframes_left

; Game
.globalzp p1
.globalzp p1_buttons_held
.globalzp p1_buttons_pressed
.globalzp p1_x
.globalzp p1_y
.globalzp p1_dir
.global p1_speed
.global p1_dir_speed
.global p1_lift
.global p1_track_index
.global p1_boost_tank
.global p1_boost_timer
.global p1_boost
.global p1_slowdown

.globalzp p2
.globalzp p2_buttons_held
.globalzp p2_buttons_pressed
.globalzp p2_x
.globalzp p2_y
.globalzp p2_dir
.global p2_speed
.global p2_dir_speed
.global p2_lift
.global p2_track_index
.global p2_boost_tank
.global p2_boost_timer
.global p2_boost
.global p2_slowdown

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

; Music
.globalzp penguin_zp
.globalzp gs_zp

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

; misc
.global track_number

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

.global camera_height
.global local_camera_height

.global p1_pre_explosion
.global p1_explosion
.global p1_lap
.global p1_text_timer
.global p1_jump
.global p1_boost_tank_sub

.global p2_pre_explosion
.global p2_explosion
.global p2_lap
.global p2_text_timer
.global p2_jump
.global p2_boost_tank_sub

.global needs_completion
.global completion_timer

.globalzp draw_distance
.globalzp draw_distance_minus_one

.global lap_time_sub
.global lap_time_0
.global lap_time_1
.global lap_time_2
.global lap_time_3

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
.global timer
.global two_player
.global ship_entrance
.global countdown

.global ship_jump_table

.endif
