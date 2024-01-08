define(fp, x29)                                         // fp
define(lr, x30)                                         // lr
define(value_r, w24)                                    
define(i_r, w21)                                        // i counter 
define(tmp_r, w22)                                     // temporary variable

STACKSIZE = 5                                           
FALSE = 0                                               
TRUE = 1                                                
base_r  .req    x20                                     
        .bss
        .global destination                                    // stack global
destination:   .skip   STACKSIZE * 4                           
        .data

        .global top
top:    .word   -1
        .text                                           // read-only
// Define strings
fmt_fl: .string "\nStack overflow! Cannot push value onto stack.\n"
fmt_uw: .string "\nStack underflow! Cannot pop an empty stack.\n"
fmt_ey: .string "\nEmpty Stack\n"
fmt_cn: .string "\nCurrent stack contents:\n"
fmt_top:.string " <-- top of stack"
fmt_new:.string "\n"
fmt_d:  .string "  %d"


            .balign 4                                   
            .global push                                // Make "main" visible
push:       stp     fp, lr, [sp, -16]!                  
            mov     fp, sp                              
            mov     value_r, w0                         
            bl      stackFull                           // call stackFull function
            cmp     w0, FALSE                           // checks if the stackFull function returns false 
            b.eq    else                                // if it is false, branch to else
            adrp    x0, fmt_fl                          
            add     w0, w0, :lo12:fmt_fl                
            bl      printf                              
            b       done                                
else:       adrp    base_r, top                         
            add     base_r, base_r, :lo12:top
            ldr     w1, [base_r]                        // load the value of top into w1 register
            mov     tmp_r, w1                          // move value of top into a temporary register
            add     tmp_r, tmp_r, 1                   // top++
            str     tmp_r, [base_r]                    
            adrp    base_r, destination                       
            add     base_r, base_r, :lo12:destination
            str     value_r, [base_r, tmp_r, SXTW 2]   // store the value into the stack at index of top
done:       ldp     fp, lr, [sp], 16                    
            ret                                         


            .global pop                                 // Make "pop" visible
pop:        stp     fp, lr, [sp, -16]!                  
            mov     fp, sp                              
            bl      stackEmpty                          // call stackEmpty function
            cmp     w0, FALSE                           // checks if the stackEmpty function returns false 
            b.eq    popElse                                // if it is false, branch to popElse
            adrp    x0, fmt_uw                          
            add     w0, w0, :lo12:fmt_uw                
            bl      printf                              
            mov     w0, -1                              // return -1
            b       donePop                               
popElse:       adrp    base_r, top                         
            add     base_r, base_r, :lo12:top
            ldr     w1, [base_r]                        // load the value of top into w1 register
            mov     tmp_r, w1                          // move value of top into a temporary register
            adrp    base_r, destination                        
            add     base_r, base_r, :lo12:destination
            ldr     value_r, [base_r, tmp_r, SXTW 2]   // load the value of stack at index of top into value
            sub     tmp_r, tmp_r, 1                   // top--
            adrp    base_r, top                         
            add     base_r, base_r, :lo12:top
            str     tmp_r, [base_r]                    // store top into memory
            mov     w0, value_r                         // return value
donePop:      ldp     fp, lr, [sp], 16                    
            ret                                         


            .global stackFull                           // Make "stackFull" visible 
stackFull:  stp     fp, lr, [sp, -16]!                  
            mov     fp, sp                              
            mov     w19, STACKSIZE                      // move the size of the stack into a tmp register
            sub     w19, w19, 1                         // stack size - 1
            adrp    base_r, top                         
            add     base_r, base_r, :lo12:top
            ldr     w1, [base_r]                        
            mov     tmp_r, w1                          
            cmp     tmp_r, w19                         
            b.eq    true                                // if equal, branch to true
            mov     w0, FALSE                           // if false, move 0 into return register
            b       stackFullDone                               
true:       mov     w0, TRUE                            // move 1 into return register
stackFullDone:      ldp     fp, lr, [sp], 16                    
            ret                                        


            .global stackEmpty                          // Make "stackEmpty" visible
stackEmpty: stp     fp, lr, [sp, -16]!                  
            mov     fp, sp                              
            adrp    base_r, top                         
            add     base_r, base_r, :lo12:top
            ldr     w1, [base_r]                        
            mov     tmp_r, w1                          
            cmp     tmp_r, -1                          // compare top with -1
            b.eq    true1                               // if top equals to -1, branch to true1
            mov     w0, FALSE                           // if false, move 0 into return register
            b       stackEmptyDone                               
true1:      mov     w0, TRUE                            // if true, move 1 into return register
stackEmptyDone:      ldp     fp, lr, [sp], 16                    
            ret                                         


            .global display                             // Make "display" visible
display:    stp     fp, lr, [sp, -16]!                  
            mov     fp, sp                              
            bl      stackEmpty                          
            cmp     w0, FALSE                           // check if stack is empty                           
            b.eq    last                                // if return value is 0, it means false, then branch to last
            adrp    x0, fmt_ey                          
            add     w0, w0, :lo12:fmt_ey                
            bl      printf                              
            b       displayDone                               
last:       adrp    x0, fmt_cn                          
            add     w0, w0, :lo12:fmt_cn                
            bl      printf                              
            adrp    base_r, top                         
            add     base_r, base_r, :lo12:top
            ldr     w1, [base_r]                        // load the value of top into w1 register
            mov     i_r, w1                             // i = top
            b       test                                // branch to test
start:      // Start of code inside loop
            adrp    base_r, destination                        
            add     base_r, base_r, :lo12:destination
            ldr     value_r, [base_r, i_r, SXTW 2]      // load the value of stack at index of top into value
            adrp    x0, fmt_d                           
            add     w0, w0, :lo12:fmt_d                 
            mov     w1, value_r                         // move value into display register
            bl      printf                              
            adrp    base_r, top                         
            add     base_r, base_r, :lo12:top
            ldr     w1, [base_r]                        // load the value of top into w1 register
            cmp     i_r, w1                             // compare i with top
            sub     i_r, i_r, 1                         // i--
            b.eq    printTop                             // if i ==top, branch to printTop
            b       end                                 
printTop:    adrp    x0, fmt_top                         
            add     w0, w0, :lo12:fmt_top               
            bl      printf                              
end:        adrp    x0, fmt_new                         
            add     w0, w0, :lo12:fmt_new               
            bl      printf                              
test:       cmp     i_r, 0                              // compare i with 0
            b.ge    start                               // if i smaller than 0, exit out of loop
displayDone:      ldp     fp, lr, [sp], 16                    
            ret                                         

