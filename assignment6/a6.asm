
                .data                            // Switch to data section.                                   
                .balign 8                        // Ensures that instruction addresses are divisible by 8.

                    
minimum:         .double 0r1.0e-13                // exit comparison variable).
null_m:         .double 0r0.0                    // null variable.
tmp_m:         .double 0r0.0                    // tmp variable.
div_m:          .double 0r100.0                  // Define variable to divide value by 100 (i.e. temp = (double)value / 100.0).



                .text                            // Switch to .text section.                                   
                .balign 4                        // Ensures that instruction addresses are divisible by 4.


label:      .string "Input value (x):\tarctan(x):\t\n\n"   				// prints the cols
negx:       .string " %.10f   "                                                 	// neg x
posx:       .string "  %.10f    "                                               	// pos x
arctanp:     .string "   %.10f\n"                                                	// the output
error:      .string "Error: Incorrect number of arguments.\n"                   	//arguments error.
abort:      .string "Can't open file/ write .   Aborting.\n"                    	// open/write file error.
open:       .string "\nOpening file: %s\n"                                     		// file is opened.
end:        .string "\nEnd of file reached.\n\n"                              		//end of file is reached."


                define(base_r, x24)                      // buffer base address.
                define(value_r, w19)                     // integer value.
                define(fd_r, w20)                        // floating double.
                define(argc_r, w21)                      
                define(argv_r, x23)                     

                LOWER_LIMIT = -95                        
                UPPER_LIMIT = +95                        
                INCREMENT = 5                            

                alloc = -(16 + buffer_size) & -16        // Allocates.
                dealloc = -alloc                         // Deallocates
                buffer_size = 8                          // 8 bytes. 
                buffer_s = 16                           

                fp	.req	x29                          //frame pointer register.
                lr	.req	x30                          //link register.  



 		.global main                              
               .balign 4                                 

main:           stp     fp, lr, [sp, alloc]!             
                mov     fp, sp                           

                mov     argc_r, w0                       // argc_r moved to register w0.
                mov     argv_r, x1                       // argv_r moved to register x1.
                cmp     argc_r, 2                        // check if equal 2
                b.eq    file_opened                    
                
                adrp    x0, error                                                    
                add     x0, x0, :lo12:error          
                bl      printf                           
                b       exit                            

file_opened:  adrp    x0, open                      
                add     x0, x0, :lo12:open           
                ldr     x1, [argv_r, 8]                  // Loads the value of argv_r to register x1.   
                bl      printf                           

                mov     x0, -100                         // 1st argument
                ldr     x1, [argv_r, 8]                  // 2nd argument
                mov     w2, 0                            // 3rd argument
                mov     w3, 0                            // 4th argument
                
                mov     x8, 56                           // 56 = opening file
                svc     0                                // system function.
                mov     fd_r, w0                         

                cmp     fd_r, 0                          // doing error check here
                b.ge    file_continue                    

                adrp    x0, abort			// Loads the address         
                add     x0, x0, :lo12:abort         
                bl      printf                          

                mov     x0, -1                           // Return -1
                b       exit                            

file_continue:  add     base_r, fp, buffer_s             //calculate the base address.

                adrp    x0, label                        
                add     x0, x0, :lo12:label          
                bl      printf                          

                mov     value_r, LOWER_LIMIT             
                b       test                            

read_inputs:    mov     w0, fd_r                         // 1st argument
                mov     x1, base_r                       // 2nd argument
                mov     w2, buffer_size                  // 3rd argument

                mov     x8, 63                           // 63 = file reading.
                svc     0                                
                mov     x25, x0                          // Records number of the bytes read.
                cmp     x25, buffer_size                 // check if number of bytes read =! 8
                b.ne    file_close                            

                ldr     d0, [base_r]                     

                adrp    x9, null_m                        
                add     x0, x9, :lo12:null_m             
                ldr     d15, [x9]                        // Loads value 0.0

                fcmp    d0, d15                          // x >= 0  
                b.ge    space                           

                adrp    x0, negx                      
                add     x0, x0, :lo12:negx          
                bl      printf                           
                b       tmp                        

space:          adrp    x0, posx                     
                add     x0, x0, :lo12:posx           
                bl      printf                          

tmp:      adrp    x9, tmp_m                       // Loads the address of tmp_m.  
                add     x9, x9, :lo12:tmp_m             
                ldr     d0, [x9]                         

                scvtf   d1, value_r                      // Converts float to double
                        
                adrp    x9, div_m                        // Loads the address of div_m.  
                add     x9, x9, :lo12:div_m              
                ldr     d2, [x9]                         

                fdiv    d0, d1, d2                       // Divide value_r by 100 this gives us the input we want
                bl      arctan                            

                adrp    x0, arctanp                     
                add     x0, x0, :lo12:arctanp        
                bl      printf                           

                add     value_r, value_r, INCREMENT      // Add increment

test:           cmp     value_r, UPPER_LIMIT             // check: value_r <= UPPER_LIMIT,
                b.le    read_inputs                          

file_close:          adrp    x0, end                      // Loads the address of end 
                add     x0, x0, :lo12:end            
                bl      printf                           

                mov     w0, fd_r                         // 1st argument.
                mov     x8, 57                           // 57 = closing file.
                svc     0                               

exit:           ldp     fp, lr, [sp], dealloc            
                ret                                      



		.global main                              
               .balign 4                                

arctan:         stp     fp, lr, [sp, -16]!               
                mov     fp, sp                           

                fmov    d9, d0                              // save d0 in tmp register 

                adrp    x9, minimum                          // address of minimum
                add     x9, x9, :lo12:minimum                 
                ldr     d10, [x9]                            

                adrp    x9, null_m                          // Get the 0
                add     x0, x9, :lo12:null_m                 
                ldr     d16, [x9]                            //d16 is what contains the total sum
                ldr     d15, [x9]                           

                mov     w12, 1                               

                fmov    d12, 1.0                          

arctan_top:     cmp     w12, 1                               
                b.gt    arctan_bottom                       //  check if > 1

                fmov    d14, d9                             
                fmov    d2, d14                             
                b       absolute_function                       

arctan_bottom:  fmov    d14, d2                             // x^n                    
                fmul    d14, d14, d9                        
                fmul    d14, d14, d9                        
                fneg    d14, d14                            // Negating
                fmov    d2, d14                             // save x^n before dividing by n
                fdiv    d14, d14, d12                       // (x^n)/ n

absolute_function:  fadd    d16, d16, d14                       
                add     w12, w12, 1                          // Incrementing by 1
                fmov    d1, 2.0                             
                fadd    d12, d12, d1                        // increment n by 2

                fcmp    d14, d15                            // check if positive or negative
                b.gt    arctan_loop                         //positive

                fneg    d14, d14                            // negative = negate it
                fabs    d17, d14                            
                fcmp    d17, d10                                                                         
                b.gt    arctan_top                          // x^n/n > 1.0e-13 
                b       arctan_exit                         //done

arctan_loop:    fcmp    d14, d10                            
                b.gt    arctan_top                          // x^n/n > 1.0e-13 

arctan_exit:    fmov    d0, d16                             

                ldp     fp, lr, [sp], 16                   
                ret  

