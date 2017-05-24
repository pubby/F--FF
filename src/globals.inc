.ifndef GLOBAL_INC
.define GLOBAL_INC

.include "nes.inc"
.include "macros.inc"

CPU_OAM = $0200
rom_bank = $3FFF

draw_line_octant1 = $0300

.macro bankswitch bank
    lda banktable+bank
    sta banktable+bank
.endmacro

.macro bankswitch_to label
    lda banktable+.lobyte(.bank(label))
    sta banktable+.lobyte(.bank(label))
.endmacro

.globalzp debug
.globalzp subroutine_temp
.globalzp ptr_temp

.globalzp nmi_counter
.globalzp frame_number

.globalzp rng_state

; Line drawing
.globalzp from_x_sub
.globalzp from_x
.globalzp from_y_sub
.globalzp from_y
.globalzp to_x_sub
.globalzp to_x
.globalzp to_y_sub
.globalzp to_y

.globalzp from_out_code
.globalzp to_out_code

.globalzp Dx_sub
.globalzp Dx
.globalzp Dy_sub
.globalzp Dy
.globalzp rounded_Dx
.globalzp rounded_Dy

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

; Multiplication
.globalzp multiplicand
.globalzp multiplier
.globalzp product

.globalzp trig_ptr1
.globalzp trig_ptr2
.globalzp trig_ptr3
.globalzp trig_ptr4

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

.endif
