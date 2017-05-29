.ifndef GLOBAL_INC
.define GLOBAL_INC

.include "nes.inc"
.include "macros.inc"

CPU_OAM = $0200
rom_bank = $3FFF

draw_line_octant1 = $0300

Dx_sub      = 0 ; 1 byte
Dx          = 1 ; 2 bytes
Dy_sub      = 3 ; 1 byte
Dy          = 4 ; 2 bytes
rounded_Dx  = 6 ; 1 byte
rounded_Dy  = 7 ; 1 byte
to_out_code = 6 ; 1 byte, shared with rounded_Dx

.macro bankswitch bank
    lda banktable+bank
    sta banktable+bank
.endmacro

.macro bankswitch_to label
    lda banktable+.lobyte(.bank(label))
    sta banktable+.lobyte(.bank(label))
.endmacro

.globalzp subroutine_temp
.globalzp ptr_temp

.globalzp nmi_counter
.globalzp frame_number

.globalzp rng_state

.globalzp px
.globalzp py
.globalzp fx
.globalzp fy

; Game
.globalzp p1
.globalzp p1_buttons_held
.globalzp p1_buttons_pressed
.globalzp p1_x
.globalzp p1_y
.globalzp p1_dir
.globalzp p1_speed

.globalzp p2
.globalzp p2_buttons_held
.globalzp p2_buttons_pressed
.globalzp p2_x
.globalzp p2_y
.globalzp p2_dir
.globalzp p2_speed

; Line drawing
.globalzp from_x_sub
.globalzp from_x
.globalzp from_y_sub
.globalzp from_y
.globalzp to_x_sub
.globalzp to_x
.globalzp to_y_sub
.globalzp to_y

; Rendering
.globalzp y_temp

.globalzp lx_lo_ptr
.globalzp lx_hi_ptr
.globalzp ly_lo_ptr
.globalzp ly_hi_ptr
.globalzp rx_lo_ptr
.globalzp rx_hi_ptr
.globalzp ry_lo_ptr
.globalzp ry_hi_ptr

.globalzp scratchpad_lx_lo
.globalzp scratchpad_lx_hi
.globalzp scratchpad_ly_lo
.globalzp scratchpad_ly_hi
.globalzp scratchpad_rx_lo
.globalzp scratchpad_rx_hi
.globalzp scratchpad_ry_lo
.globalzp scratchpad_ry_hi


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
.global recip_index_table

.endif
