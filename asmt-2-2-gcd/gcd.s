  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Write an ARM Assembly Language Program that will compute
  @   the GCD (greatest common divisor) of two numbers in R2 and R3.
  
  @ *** your solution goes here ***

  CMP     R2, #0                @if (a = 0 || b = 0)
  BEQ     ValueEqualsZero       @ {
  CMP     R3, #0                @    result = 0
  BEQ     ValueEqualsZero       @ } else{
While:                          @         while ( a != b )
  CMP     R2, R3                @         {
  BLE     AEqualsOrLessB        @           if ( a > b )
  SUB     R2, R2, R3            @           {
  B       While                 @             a = a − b ;
AEqualsOrLessB:                 @           }
  CMP     R2, R3                @           else
  BEQ     AEqualsB              @           {
  SUB     R3, R3, R2            @             b = b − a ;
  B       While                 @            }
AEqualsB:                       @        }
  MOV     R0, R2
  B       End_Main              @ result = a }
ValueEqualsZero:
  MOV     R0, #0                

  @ End of program ... check your result

End_Main:
  BX    lr

.end
