  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ Write an ARM Assembly Language Program that will convert
  @   a signed value (integer) in R3 into three ASCII characters that
  @   represent the integer as a decimal value in ASCII form, prefixed
  @   by the sign (+/-).
  @ The first character in R0 should represent the sign
  @ The second character in R1 should represent the most significaint digit
  @ The third character in R2 should represent the least significant digit
  @ Store 'N', '/', 'A' if the integer is outside the range -99 ... 0 ... +99

  
  @ *** your solution goes here ***


  @ R2 = R3
  
  @ if (R2 < -99 || R2 > 99)
  
  @ { System.out.println("N/A"); }
  
  @ else
  
  @ {   if (R2 = 0)
  @     { System.out.print(" ");   System.out.print("0");   System.out.print("0"); }

  @     else
  
  @     {     if (R2 < 0)  
  
  @           {    while ( R1 = 0; ( R2 <= -10); R1++)
  @               {        R2 = R2 + 10;  }
  
  @                 R2 = R2 * -1
  @                 R2 = R2 + 0x30
  @                 R1 = R1 + 0x30
  @                 System.out.println("-" " R1" "R2"); }

  @           else
  
  @           {  while ( R1 = 0; (R2 >= 10); R1++)
  @             {     R2 = R2 - 10;   }

  @               R2 = R2 + 0x30;
  @               R1 = R1 + 0x30;
  @               System.out.println ("+" "R1" "R2"); } 


  MOV     R2, R3
  MOV     R1, #0

  CMP     R2, #-99
  BLT     Error
  CMP     R2, #99
  BGT     Error    
  CMP     R2, #0
  BEQ     EqualsZero

  CMP     R2, #0
  BGT     GreaterThanZero     

LessThanZero:
  CMP     R2, #-10
  BGT     EndWh
  ADD     R2, R2, #10
  ADD     R1, R1, #1
  B       LessThanZero

EndWh:
  LDR     R5, =-1
  MUL     R2, R2, R5
  ADD     R2, R2, #0x30
  ADD     R1, R1, #0x30
  MOV     R0, #0x2D
  B       End

GreaterThanZero:
  CMP     R2, #10
  BLT     EndWh1
  SUB     R2, R2, #10
  ADD     R1, R1, #1
  B       GreaterThanZero

EndWh1:
  ADD     R2, R2, #0x30
  ADD     R1, R1, #0x30
  MOV     R0, #0x2B
  B       End

Error:
  MOV     R0, #0x4E
  MOV     R1, #0x2F
  MOV     R2, #0x41
  B       End

EqualsZero:
  MOV     R0, #0x20
  MOV     R1, #0x30
  MOV     R2, #0x30
  B       End

  
End:  
  
  @ End of program ... check your result

End_Main:
  BX    lr

.end
