//m.asm

define(xcoord, x19)
define(ycoord, x20)
define(minimum, x21)
define(tmp, x22)

format:	.string "x = %d, y = %d, min = %d\n"
		.balign 4
		.global main

main:           stp     fp, lr, [sp, -16]!
                mov     fp, sp

                mov     xcoord, -10
		mov	minimum, 5840
		b test

top:		// Calculate y = 5x^4 - 448x^2 - 63x + 10
		mul ycoord, xcoord, xcoord  //x^2
		mul ycoord, ycoord, xcoord  //x^3
		mul ycoord, ycoord, xcoord  //x^4
		mov tmp, 5
		mul ycoord,ycoord, tmp

		mul tmp, xcoord, xcoord //tmp = x^2
		mov x23, -448
		madd ycoord, tmp, x23, ycoord //-448x^2

		mov tmp, -63
		madd ycoord, tmp, xcoord, ycoord //y = -63*x + y
		mov tmp, 10
		add ycoord, ycoord, tmp

		
		cmp ycoord, minimum		//compare min to current min
		b.gt skip_update
		
		//update the minimum
		mov minimum, ycoord
skip_update:
		//print everything out
		ldr	x0, =format
		mov	x1, xcoord
		mov	x2, ycoordret
		mov	x3, minimum
		bl printf
		add xcoord, xcoord, 1
		b test

test:		cmp	xcoord, 11
		b.lt top

exit:		ldp     x29, x30, [sp], 16
        	ret