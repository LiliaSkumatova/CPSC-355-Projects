
                                                                     //Number of arguments register
                                                                     //The arguments array register


                                                                   
                                                                    //User input for month
                                                                      //User input for day
                                                                   


                                                              
                                                               
                                                              


spr_m:    .string "Spring"                                                              //Spring
smr_m:    .string "Summer"                                                              //Summer
fal_m:    .string "Fall"                                                                //Fall
wint_m:    .string "Winter"                                                             //Winter

//Declaring strings for all the months
month1:     .string "January"                                                           //January
month2:     .string "February"                                                          //February
month3:     .string "March"                                                             //March
month4:     .string "April"                                                             //April
month5:     .string "May"                                                               //May
month6:     .string "June"                                                              //June
month7:     .string "July"                                                              //July
month8:     .string "August"                                                            //August
month9:     .string "September"                                                         //September
month10:    .string "October"                                                           //October
month11:    .string "November"                                                          //November
month12:    .string "December"                                                          //December


//Declaring strings for the suffixes
suff_th:    .string "th"                                                                 //th suffix
suff_st:    .string "st"                                                                 //st suffix
suff_nd:    .string "nd"                                                                 //nd suffix
suff_rd:    .string "rd"                                                                 //rd suffix

//Declaring printout strings for he answer and the error messages
usage:    .string "usage: a5b mm dd\n"                                                  //Error message for improper number of arguments
error1:   .string "Error: Invalid input\n"                                              //Invalid input error
error2:   .string "Error: This month doesn't have this number of days\n"                //Invalid day error
answer:   .string "%s %d%s is %s\n"                                                     

//Array creation
          .data                                                                         
          .balign 8                                                                     //Double-word allignment

month_m:  .dword month1, month2, month3, month4, month5, month6, month7, month8, month9, month10, month11, month12  //Creates months array
season_m: .dword wint_m, spr_m, smr_m, fal_m                                                                         //Creates seasons array
suffix_m: .dword suff_th, suff_st, suff_nd, suff_rd                                                                 //Creates suffix array



          .text                                                                         
          .balign 4                                                                    
          .global main                                                                  

main:
          stp x29, x30, [sp, -16]!                                                      
          mov x29, sp                                                                   

          mov w19, w0                                                                
          mov x20, x1                                                                

          cmp w19, 3                                                                 //Checking if input has 3 argument
          b.eq next1                                                                    
          adrp x0, usage                                                                
          add x0, x0, :lo12:usage                                                       
          bl printf                                                                     
          b end                                                                         //terminates

next1:
          mov w24, 1                                                               //Sets w24 to 1
          ldr x0, [x20, w24, SXTW 3]                                            
          bl atoi                                                                       //Calls atoi using branch and link
          mov w21, w0                                                               //Puts atoi's returned value into w21
          mov w24, 2                                                               
          ldr x0, [x20, w24, SXTW 3]                                            //Loads the third element of argv into x0
          bl atoi                                                                       //Calls atoi
          mov w22, w0                                                                 //Puts atoi's returned value into the w22

          cmp w21, 0                                                                
          b.le error                                                                    //If it is less than or equal to 0
          cmp w21, 12                                                               
          b.gt error                                                                    //If it is greater than 12
          cmp w22, 31                                                                 
          b.gt error                                                                    //If it is greater than 31
          cmp w22, 0                                                                  
          b.le error                                                                    //If it is less than or equal to 0
          b next2                                                                       

error:
          adrp x0, error1                                                               
          add x0, x0, :lo12:error1                                                      
          bl printf                                                                     
          b end                                                                         //ends

next2:
          cmp w21, 2                                                                //Checks if February
          b.ne next3                                                                    //If the month is not February
          cmp w22, 28                                                                 //Otherwise, if the month is February, check the number of days(less than 28)
          b.gt day_error                                                                

next3:
          cmp w21, 4                                                                //Checks if it is April
          b.eq check                                                                    
          cmp w21, 6                                                                //Checks if month is June
          b.eq check                                                                    
          cmp w21, 9                                                                //Checks if month is September
          b.eq check                                                                    
          cmp w21, 11                                                               //Checks if month is November
          b.eq check                                                                    
          b next4                                                                       //the month is a 31 day month and day is valid.

check:
          cmp w22, 31                                                                 //Checks if day is equal to 31
          b.ne next4                                                                    

day_error:
          adrp x0, error2                                                              
          add x0, x0, :lo12:error2                                                     
          bl printf                                                                    
          b end                                                                        //ends

next4:
          cmp w21, 2                                                               //Checks if month is greater than 2
          b.gt april_may                                                               
          mov w23, 0                                                              //If it's not,so set w23 to 0 
          b next5                                                                     

april_may:
          cmp w21, 4                                                               //Checks if month is less than 
          b.lt march                                                                   
          cmp w21, 5                                                               //Checks if month is greater than 5
          b.gt july_august                                                             
          mov w23, 1                                                              //Set w23 to 1 (Spring)
          b next5                                                                      

july_august:
          cmp w21, 7                                                               //Checks if month is less than 7 
          b.lt june                                                                    
          cmp w21, 8                                                               //Checks if month is greater than 8 
          b.gt oct_nov                                                                 
          mov w23, 2                                                              //Sets w23 to 2
          b next5                                                                      

oct_nov:
          cmp w21, 10                                                              //Checks if month is less than 10
          b.lt september                                                              
          cmp w21, 11                                                              //Checks if month is greater than 11
          b.gt december                                                                
          mov w23, 3                                                              //Set the w23 to 3
          b next5                                                                      

march:
          mov w23, 0                                                              //Sets season index to 0 for Winter
          cmp w22, 20                                                                
          b.le next5                                                                   
          mov w23, 1                                                              //If not,Sets the w23 to 1 for Spring
          b next5                                                                      

june:
          mov w23, 1                                                              //Sets season index to 1 for Spring
          cmp w22, 20                                                                
          b.le next5                                                                   
          mov w23, 2                                                              //If not,Sets the w23 to 2 for Summer
          b next5                                                                      

september:
          mov w23, 2                                                              //Sets season index to 2 for Summer
          cmp w22, 20                                                                
          b.le next5                                                                   
          mov w23, 3                                                              //If not,Sets season index to 3 for Fall
          b next5                                                                      

december:
          mov w23, 3                                                              //Sets season index to 3 for Fall
          cmp w22, 20                                                                
          b.le next5                                                                   
          mov w23, 0                                                              //If not,sets season index to 0 for Winter

next5:
          cmp w22, 1                                                                 //Checks if the day is 1
          b.eq suff1                                                                   
          cmp w22, 21                                                                //Checks if the day is 21.
          b.eq suff1                                                                   
          cmp w22, 31                                                                //Checks if the day is 31,
          b.eq suff1                                                                   

          cmp w22, 2                                                                 //Checks if the day is 2
          b.eq suff2                                                                   
          cmp w22, 22                                                                //Checks if the day is 22
          b.eq suff2                                                                   

          cmp w22, 3                                                                 //Checks if the day is 3
          b.eq suff3                                                                   
          cmp w22, 23                                                                //Checks if the day is 23
          b.eq suff3                                                                   

          mov w24, 0                                                              //Else,sets suffix index to 0 
          b output                                                                     
suff1:
          mov w24, 1                                                              //If day is 1, 21 or 31 sets w24 to 1 
          b output                                                                     
suff2:
          mov w24, 2                                                              //If day is 2 or 22, sets w24 to 2 
          b output                                                                     
suff3:
          mov w24, 3                                                              //If day index is 3 or 23, set w24 to 3

output:
          adrp x25, month_m                                                   
          add x25, x25, :lo12:month_m                                

          adrp x26, season_m                                                 
          add x26, x26, :lo12:season_m                             

          adrp x27, suffix_m                                                 
          add x27, x27, :lo12:suffix_m                             

          sub w21,w21,1                                                        //Takes care of the zero-based indexing or arrays
          adrp x0, answer                                                              
          add x0, x0, :lo12:answer                                                     
          ldr x1, [x25, w21, SXTW 3]                                      
          mov w2, w22                                                                
          ldr x3, [x27, w24, SXTW 3]                                    
          ldr x4, [x26, w23, SXTW 3]                                     
          bl printf                                                                    

//End program
end:
          mov w0, 0                                                                    
          ldp x29, x30, [sp], 16                                                       //Deallocates memory
          ret                                                                          
