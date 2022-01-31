  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @
  @   Write an ARM Assembly Language Program that will determine
  @   whether the unsigned number in R1 is a prime number
  @
  @ Output:
  @   R0: 1 if the number in R1 is prime
  @       0 if the number in R1 is not prime
  @

  
  @ *** your solution goes here ***
 


  MOV     R5, #1            @ divisor = 1
  CMP     R1, #0            @ if  (number = 0) 
  BEQ     Composite         @ { number = composite }
  CMP     R1, R5            @ if (number = 1) 
  BEQ     Composite         @ { number = composite }

While:                     @ for ( testNumber = number; divisor < testNumber; divisor++)
  ADD     R5, R5, #1       
  CMP     R1, R5           @ if (number = divisor)
  BEQ     Prime            @ {  number = prime  }
  MOV     R6, R1           
While1:                    @      for ( testNumber = number; testNumber >= divisor; )   
  CMP     R6, R5        
  BLT     While
  SUB     R6, R6, R5       @          testNumber = testNumber - divisor
  CMP     R6, #0           @          if (testNumber = 0)
  BEQ     Composite        @          {   number = prime    }  
  B       While1

Composite:
  MOV     R0, #0
  B       End
 
Prime:
  MOV     R0, #1

End:  

  @ End of program ... check your result

End_Main:
  BX    lr

.end
