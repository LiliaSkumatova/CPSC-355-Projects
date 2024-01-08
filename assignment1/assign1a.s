//assign1a.s
format:	.string "x = %d, y = %d, min = %d\n"
		.balign 4
		.global main

main:   	stp     fp, lr, [sp, -16]!
        	mov     fp, sp

		mov	x19, -10
		mov	x23, 5840	//min value set it as the greatest possible value

top:		cmp	x19, 11
		b.ge	exit

		// Calculate y = 5x^4 - 448x^2 - 63x + 10
		mov x20, x19                // x20 = x (for y = 5x^4)
    		mul x20, x20, x20            // x20 = x^2
    		mul x20, x20, x20         // x20 = x^4
		mov x24, 5
    		mul x20, x20, x24	      // x20 = 5x^4

    		mov x21, x19                // x21 = x (for y = -448x^2)
   		mul x21, x21, x21	      // x21 = x^2
    		mov x24, -448
		mul x21, x21, x24	      //x21 = -448x^2

    		mov x22, x19	              // x22 = x (for y = -63x)
    		mov x24, -63
		mul x22, x22, x24	      // x22 = -63x

   		add x20, x20, x21		//adding all together
   		add x20, x20, x22
		mov x24, 10
   		add x20, x20, x24
		
		cmp x20, x23		//compare min to current min
		b.gt skip_update
		
		//update the minimum
		mov x23, x20
skip_update:
		//print everything out
		ldr	x0, =format
		mov	x1, x19
		mov	x2, x20
		mov	x3, x23
		bl printf
		

increment:	add	x19, x19, 1
		b	top	
	

        
exit:   	ldp     x29, x30, [sp], 16
        	ret
