//assign2a.asm








fmt:	.string	"original: 0w21%08X    reversed: 0w21%08X\n"
	.balign 4
	.global main

main:
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	
	//step 1
	//w23 = (w21 & 0x55555555) << 1;
	mov	w21, 0x07FC07FC
	mov	w23, 0x55555555
	and	w23, w21, w23
	lsl	w23, w23, 1
	//w24 = (w21 >> 1) & 0x55555555;
	lsr	w24, w21, 1
	and	w24, w24, 0x55555555
	//w22 = w23 | w24;
	orr	w22, w23, w24

	//step 2
	//w23 = (w22 & 0x33333333) << 2;
	and	w23, w22, 0x33333333
	lsl	w23, w23, 2
	//w24 = (w22 >> 2) & 0x33333333;
	lsr	w24, w22, 2
	and	w24, w24, 0x33333333
	//w22 = w23 | w24;
	orr	w22, w23, w24

	//step 3
	//w23 = (w22 & 0x0F0F0F0F) << 4;
	and	w23, w22, 0x0F0F0F0F
	lsl	w23, w23, 4
	//w24 = (w22 >> 4) & 0x0F0F0F0F;
	lsr	w24, w22, 4
	and	w24, w24, 0x0F0F0F0F
  	//w22 = w23 | w24;
	orr	w22, w23, w24

	//step 4
	//w23 = w22 << 24;
	lsl	w23, w22, 24
  	//w24 = (w22 & 0xFF00) << 8;
	and	w24, w22, 0xFF00
	lsl	w24, w24, 8
 	//w25 = (w22 >> 8) & 0xFF00;
	lsr	w25, w22, 8
	and	w25, w25, 0xFF00
  	//w26 = w22 >> 24;
	lsr	w26, w22, 24
  	//w22 = w23 | w24 | w25 | w26;
	orr	w22, w23, w24
	orr	w22, w22, w25
	orr	w22, w22, w26

	ldr	w0, =fmt
	mov	w1, w21
	mov	w2, w22
	bl	printf
	
	ldp	x29, x30, [sp], 16
	ret
	

	
	