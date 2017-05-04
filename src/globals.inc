.ifndef GLOBAL_INC
.define GLOBAL_INC

.include "nes.inc"

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

.globalzp subroutine_temp
.globalzp ptr_temp

.globalzp p1_buttons_held
.globalzp p1_buttons_pressed
.globalzp p2_buttons_held
.globalzp p2_buttons_pressed

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

.globalzp inter

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
