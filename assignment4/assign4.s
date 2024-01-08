printPyramid1:   .string "Pyramid %s \n\tCenter = (%d, %d)\n"		// format for print

printPyramid2:   .string "\tBase width = %d  Base length = %d\n"	// Format the printing

printPyramid3:   .string "\tHeight = %d\n"			// Format the printing

printPyramid4:   .string "\tVolume = %d\n\n"			// Format the printing

main1:          .string "Initial pyramid values:\n"		// Format the printing

main2:          .string "\nNew pyramid values:\n"		// Format the printing

khefre:          .string "khefre"					

cheops:         .string "cheops"				

                .balign 4					// Set printing alignment
                .global main

False = 0							
True = 1							

coord_x = 0							// Offset for int x in struct coord
coord_y = 4							// Offset for int y in struct coord
coord_size = 8							// Size of struct coord
size_s = 8							
size_width = 0						// Offset for width in struct size
size_length = 4						// Offset for length in struct size
size_size = 8						// Size of struct size
pyramid_s = 16							
pyramid_origin = 0						// Offset for struct coord origin in struct pyramid
pyramid_base = 8							// Offset for struct size base in struct pyramid
pyramid_height = 16						// Offset for int height in struct pyramid
pyramid_volume = 20						// Offset for int volume in struct pyramid
pyramid_size = coord_size + size_size + 8			// Size of struct pyramid

khafrepyramid_s = pyramid_s + pyramid_size				// Calculation 
cheopspyramid_s = khafrepyramid_s + pyramid_size			// Calculation
result_s = cheopspyramid_s + pyramid_size				// Calculation
khafrepyramid_size = 24						// Size of firstPyramid
cheopspyramid_size = 24						// Size of secondPyramid

int_size = 4							
char_size = 1							

						// Set macros
        					
        				
        					

main_alloc = -(16 + khafrepyramid_size + cheopspyramid_size) & -16	// Calculate the allocation size for main
main_dealloc = -main_alloc					// Calculate the deallocation size for main

main:   stp     x29, x30, [sp, main_alloc]!			// Allocate memory for main function
        mov     x29, sp

	add	x8, x29, khafrepyramid_s				
	mov	w2, 10
	mov	w3, 10
	mov	w4, 9
        bl      newPyramid					// Call newPyramid function to create a new pyramid
gdb1:
	add     x8, x29, cheopspyramid_s				// Calculate the address of x8 (Where secondpyramid start)
	mov	w2, 15
	mov	w3, 15
	mov	w4, 18
        bl      newPyramid					// Call newPyramid function to create a new pyramid
gdb2:
        ldr     x0, =main1					// Load string "Initial pyramid value:" to x0
        bl      printf						// Print the string

	ldr	w4, =khefre					
	add     x8, x29, khafrepyramid_s				
	bl	printPyramid					// Print the string

	ldr     w4, =cheops					// Load argument to print values of the initial second pyramid
        add     x8, x29, cheopspyramid_s
        bl      printPyramid					// Print the string

	add	x0, x29, khafrepyramid_s			// Load argument to call function equalSize
	add	x1, x29, cheopspyramid_s
	bl	equalSize					

        ldr     w28, [x29, result_s]			// Load the return value of function equalSize
        cmp     w28, True					// Compare
        b.eq    skip						

	add     x8, x29, cheopspyramid_s				
        mov     w1, 9						
        bl      expand
	
gdb3:
	add	x8, x29, cheopspyramid_s			
        mov     w1, 27						
        mov     w2, -10						
        bl      relocate					//call function relocate	

	add	x8, x29, khafrepyramid_s			
        mov     w1, -23						
        mov     w2, 17						//call function relocate
        bl      relocate
							
skip:   ldr     x0, =main2					
        bl      printf						// Print the string

	ldr     w4, =khefre					// Load argument to print values of the changed first pyramid
        add     x8, x29, khafrepyramid_s
        bl      printPyramid					// Print the string

	ldr     w4, =cheops					// Load argument to print values of the changed second pyramid
        add     x8, x29, cheopspyramid_s
        bl      printPyramid					// Print the string

	ldr	x0, 0						// Deallocate memory and end main function
        ldp     x29, x30, [sp], main_dealloc
        ret

newPyramid_alloc = -(16 + pyramid_size) & -16			// Calculate the allocation size
newPyramid_dealloc = -newPyramid_alloc				// Calculate the deallocation size

newPyramid:
        stp     x29, x30, [sp, newPyramid_alloc]!		// Allocate memory for function newPyramid
        mov     x29, sp	

	mov 	x27, x8				// make easier to read
        mov     w19, 0						
        str     w19, [x27, pyramid_origin + coord_x]	

        mov     w19, 0						
        str     w19, [x27, pyramid_origin + coord_y]	

        mov     w19, w2							//w19 = w2
        str     w19, [x27, pyramid_base + size_width]	// Store the value of w19 to width

        mov     w19, w3							// w19 = w3
        str     w19, [x27, pyramid_base + size_length]	// Store the value of w19 to length

        mov     w19, w4							// w19 = w4
        str     w19, [x27, pyramid_height]			// Store the value of w19 to height

        ldr     w19, [x27, pyramid_base + size_width]	// Load the width to w19
        ldr     w21, [x27, pyramid_base + size_length]	// Load the length to w21
        ldr     w22, [x27, pyramid_height]			// Load the height to w22
        mul     w19, w19, w21						// w19 = width * length
        mul     w19, w19, w22						// w19 = (width * length) * height
	mov	w6, 3				
	sdiv	w19, w19, w6						//w19 = ((width * length) * height)/3
        str     w19, [x27, pyramid_volume]			// Store to volume

        ldp     x29, x30, [sp], newPyramid_dealloc		// Deallocate memory
        ret

printPyramid_alloc = -(16 + char_size + pyramid_size) & -16	// Calculate memory allocation size
printPyramid_dealloc = -printPyramid_alloc			// Calculate memory deallocation size

printPyramid:
        stp     x29, x30, [sp, printPyramid_alloc]!		// Allocate memory for function printPyramid
        mov     x29, sp

	mov	x25, x8						

        ldr     x0, =printPyramid1				// Format the printing
	mov	w1, w4
        ldr     w2, [x25, pyramid_origin + coord_x]
        ldr     w3, [x25, pyramid_origin + coord_y]
        bl      printf						

        ldr     x0, =printPyramid2				// Format the printing
        ldr     w1, [x25, pyramid_base + size_width]
        ldr     w2, [x25, pyramid_base + size_length]
        bl      printf						

        ldr     x0, =printPyramid3				// Format the printing
        ldr     w1, [x25, pyramid_height]
        bl      printf						

        ldr     x0, =printPyramid4				// Format the printing
        ldr     w1, [x25, pyramid_volume]
        bl      printf						

        ldp     x29, x30, [sp], printPyramid_dealloc		// Deallocate memory
        ret

equalSize_alloc = -(16 + pyramid_size + pyramid_size) & -16	// Calculate memory allocation size
equalSize_dealloc = -equalSize_alloc				// Calculate memory deallocation size

equalSize:
        stp     x29, x30, [sp, equalSize_alloc]!		// Allocate memory
        mov     x29, sp

        mov     w28, False					
	mov	x24, x0						// relocate
	mov	x25, x1						// relocate

        ldr     w10, [x24, pyramid_base + size_width]	// Load the width of p.1
        ldr     w11, [x25, pyramid_base + size_width]	// Load the width of p.2
        cmp     w10, w11					// Compare the widths
        b.ne    return						

        ldr     w10, [x24, pyramid_base + size_length]	// Load the length of p.1
        ldr     w11, [x25, pyramid_base + size_length]	// Load the length of p.2
        cmp     w10, w11					// Compare the lengths
        b.ne    return						

        ldr     w10, [x24, pyramid_height]			// Load the height of p.1
        ldr     w11, [x25, pyramid_height]			// Load the height of p.2
        cmp     w10, w11					// Compare the heights
        b.ne    return						

return: str     w28, [x29, result_s]			// Store the value of w28

        ldp     x29, x30, [sp], equalSize_dealloc		// Deallocate memory
        ret

expand_alloc = -(16 + pyramid_size + int_size) & -16		// Calculate memory allocation size
expand_dealloc = -expand_alloc					// Calculate memory deallocation size

expand:  stp     x29, x30, [sp, expand_alloc]!			// Allocate memory
        mov     x29, sp

        ldr     w24, [x8, pyramid_base + size_width]	// Load the width of pyramid p
        mul     w24, w24, w1				// p->base.width *= factor
        str     w24, [x8, pyramid_base + size_width]	// Store the width of pyramid p

        ldr     w24, [x8, pyramid_base + size_length]	
        mul     w24, w24, w1				// p->base.length *= factor
        str     w24, [x8, pyramid_base + size_length]	

        ldr     w24, [x8, pyramid_height]			
        mul     w24, w24, w1				// p->base.height *= factor
        str     w24, [x8, pyramid_height]			

        ldr     w24, [x8, pyramid_base + size_width]	
        mov     w25, w24				// w25 = p->base.width
        ldr     w24, [x8, pyramid_base + size_length]	
        mul     w25, w25, w24				// w25 = p->base.width * p->base.length
        ldr     w24, [x8, pyramid_height]		
        mul     w25, w25, w24				// w25 = p->base.width * p->base.length * p->height
	mov	w6, 3
	sdiv	w25, w25, w6

        str     w25, [x8, pyramid_volume]			

        ldp     x29, x30, [sp], expand_dealloc		// Deallocate memory
        ret

relocate_alloc = -(16 + pyramid_size + int_size + int_size) & -16	// Calculate memory allocation size
relocate_dealloc = -relocate_alloc					// Calculate memory deallocation size

relocate:   stp     x29, x30, [sp, relocate_alloc]!			// Allocate memory
        mov     x29, sp
	
        ldr     w23, [x8, pyramid_origin + coord_x]		
        add     w23, w23, w1					
        str     w23, [x8, pyramid_origin + coord_x]		

        ldr     w23, [x8, pyramid_origin + coord_y]		
        add     w23, w23, w2					
        str     w23, [x8, pyramid_origin + coord_y]		

        ldp     x29, x30, [sp], relocate_dealloc			// Deallocate memory 
        ret
