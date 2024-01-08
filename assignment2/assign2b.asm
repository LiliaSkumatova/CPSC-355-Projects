//assign2b.asm

define(x, w21)
define(y, w22)
define(t1, w23)
define(t2, w24)
define(t3, w25)
define(t4, w26)

fmt:	.string	"original: 0x%08X    reversed: 0x%08X\n"
	.balign 4
	.global main

main:
	stp	x29, x30, [sp, -16]!
	mov	x29, sp
	
	//step 1
	//t1 = (x & 0x55555555) << 1;
	mov	x, 0x7F807F80
	mov	t1, 0x55555555
	and	t1, x, t1
	lsl	t1, t1, 1
	//t2 = (x >> 1) & 0x55555555;
	lsr	t2, x, 1
	and	t2, t2, 0x55555555
	//y = t1 | t2;
	orr	y, t1, t2

	//step 2
	//t1 = (y & 0x33333333) << 2;
	and	t1, y, 0x33333333
	lsl	t1, t1, 2
	//t2 = (y >> 2) & 0x33333333;
	lsr	t2, y, 2
	and	t2, t2, 0x33333333
	//y = t1 | t2;
	orr	y, t1, t2

	//step 3
	//t1 = (y & 0x0F0F0F0F) << 4;
	and	t1, y, 0x0F0F0F0F
	lsl	t1, t1, 4
	//t2 = (y >> 4) & 0x0F0F0F0F;
	lsr	t2, y, 4
	and	t2, t2, 0x0F0F0F0F
  	//y = t1 | t2;
	orr	y, t1, t2

	//step 4
	//t1 = y << 24;
	lsl	t1, y, 24
  	//t2 = (y & 0xFF00) << 8;
	and	t2, y, 0xFF00
	lsl	t2, t2, 8
 	//t3 = (y >> 8) & 0xFF00;
	lsr	t3, y, 8
	and	t3, t3, 0xFF00
  	//t4 = y >> 24;
	lsr	t4, y, 24
  	//y = t1 | t2 | t3 | t4;
	orr	y, t1, t2
	orr	y, y, t3
	orr	y, y, t4

	ldr	w0, =fmt
	mov	w1, x
	mov	w2, y
	bl	printf
	
	ldp	x29, x30, [sp], 16
	ret
	

	
	