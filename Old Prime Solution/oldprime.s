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


  @ AKS Test: if ((x - 1)^p - x^p + 1) is evenly divisible by p, then p is a prime number
  @ where p = the number you wish to test for its primality

  @ for simplicity and to avoid errors x = 2   

  @ using 2 as x will always give equation 2 - 2^p
  @ this will give a negative value for all unsigned values greater than one, and as we need absolute value new equation the equation 2^p-2 will work
  @ for simplicity sake both 0 and 1 are identifed as composite numbers as they're not prime. 2 is recognised as prime 

 
 LDR    R7, = 1         @ count = 1;
 LDR    R5, =2          @ x = 2;
 LDR    R6, =1          @ result = 1;
 CMP    R1, #0          @ if ( p = 0 )
 BEQ    NotPrime        @  { p = composite }
 CMP    R1, #1          @ if ( p = 1 )
 BEQ    NotPrime        @   { p = composite }
 CMP    R1, #2          @ if ( p = 2 )
 BEQ    Prime           @   { p = prime }
 CMP    R1, #30

While:                  @ while ( count <= p; )
  CMP   R7, R1          
  BHI   EndWh
  MUL   R6, R6, R5      @ result = result * 2;    ( result will = 2^p ) 
  ADD   R7, R7, #1      @ count = count + 1;
  B     While           
  
EndWh:
  ADDS  R6, R6, #0   
  SUB   R6, R6, R5     @ result = result - 2;
  
DivWhile:              @ ( while result >= p; )
  CMP   R6, R1
  BLO   EndDivWh
  SUB   R6, R6, R1     @ result = result - p;
  B     DivWhile

EndDivWh:
  CMP   R6, #0         @ if (result = 0)
  BEQ   Prime          @ { p is a prime number }


NotPrime:
  MOV   R0, #0         @ else
  B     End            @ { p is a composite number }

Prime:
  MOV   R0, #1
  B     End  

End:

  @ End of program ... check your result

End_Main:
  BX    lr

.end
