//m.asm






format:	.string "x = %d, y = %d, min = %d\n"
		.balign 4
		.global main

main:           stp     fp, lr, [sp, -16]!
                mov     fp, sp

                mov     x19, -10
		mov	x21, 5840
		b test

top:		// Calculate y = 5x^4 - 448x^2 - 63x + 10
		mul x20, x19, x19  //x^2
		mul x20, x20, x19  //x^3
		mul x20, x20, x19  //x^4
		mov x22, 5
		mul x20,x20, x22

		mul x22, x19, x19 //x22 = x^2
		mov x23, -448
		madd x20, x22, x23, x20 //-448x^2

		mov x22, -63
		madd x20, x22, x19, x20 //y = -63*x + y
		mov x22, 10
		add x20, x20, x22

		
		cmp x20, x21		//compare min to current min
		b.gt skip_update
		
		//update the x21
		mov x21, x20
skip_update:
		//print everything out
		ldr	x0, =format
		mov	x1, x19
		mov	x2, x20
		mov	x3, x21
		bl printf
		add x19, x19, 1
		b test

test:		cmp	x19, 11
		b.lt top

exit:		ldp     x29, x30, [sp], 16
        	ret