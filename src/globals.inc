.ifndef GLOBAL_INC
.define GLOBAL_INC

.include "nes.inc"

Dx = 0
Dy = 1


.globalzp subroutine_temp
.globalzp ptr_temp

.globalzp buttons_held
.globalzp buttons_pressed

.globalzp nmi_counter
.globalzp frame_number

.globalzp rng_state

.globalzp from_x
.globalzp from_y
.globalzp to_x
.globalzp to_y

.global nt_buffer

; tables
.global lower_pattern
.global upper_pattern
.global PPxy_lo
.global PPxy_hi
.global PPyx_lo
.global PPyx_hi
.global xdiv
.endif
