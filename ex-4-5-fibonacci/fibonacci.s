  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Calculate Fibonacci number Fn, where n is stored in R1
  @ Store the result in R0

  @ *** your solution goes here ***

  CMP     R1, #0                  @ if (curr = 0)       
  BNE     ElseIfOne               @ {  
  MOV     R0, #0                  @   fn = 0
  B       EndWhFib                @ }

ElseIfOne:                        @ else
  CMP     R1, #1                  @ { 
  BNE     ElseGreaterThanOne      @   if (curr = 1)
  MOV     R0, #1                  @   {
  B       EndWhFib                @     fn =1
                                  @   }   

                                  @   else
ElseGreaterThanOne:               @   {
  MOV     R4, #0                  @     fn = 0
  MOV     R5, #1                  @     fn1 = 1
  MOV     R0, #1                  @     fn2 = 1
  MOV     R6, #2                  @     curr = 2
WhileFib:
  CMP     R6, R1                  @     while (curr < n)
  BHS     EndWhFib                @     {
  MOV     R4, R5                  @       fn2 = fn1
  MOV     R5, R0                  @       fn1 = fn
  ADD     R6, R6, #1              @       curr = curr + 1
  ADD     R0, R5, R4              @       fn = fn1 + fn2
  B       WhileFib                @     }
 EndWhFib:                        @    }
                                  @ } 


  @ End of program ... check your result

End_Main:
  BX    lr

.end