  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

  @
  @ write your program here
  @

            
  MOV   R0, #0          @ mode = 0;
  MOV   R3, #0          @ modeCount = 0;
  MOV   R4, #0          @ i1 = 0;

While:
  CMP   R4, R2           @ while ( i1 < totalNumberOfInts) 
  BHS   EndWh            @ {     
  LDR   R5, [R1]         @   value1 = word[address1];
  MOV   R6, #0           @   count = 0;
  ADD   R7, R1, #4       @   address2 = address1 + 4;
  ADD   R8, R4, #1       @   i2 = i2 +1;
        
While1:                  @   while (i2 < totalNumberOfInts)
  CMP   R8, R2       
  BHS   EndWh1       
  LDR   R9, [R7]         @   {
  CMP   R9, R5           @     value2 = word[address2];
  BNE NotEqual           @     if ( value1 == value2) 
  ADD   R6, R6, #1       @     {  count = count + 1;
      
NotEqual:  @ {       
  ADD   R8, R8, #1       @     i2 = i2 + 1;
  ADD   R7, R7, #4       @     address2 = address2 + 4;
  B     While1           @     }
        
EndWh1:        
  CMP   R6, R3           @     if ( count > modeCount )
  BLS   CountLess        @     {
  MOV   R0, R5           @     mode = value1;
  MOV   R3, R6           @     modeCount = count;
                         @     }
CountLess:
  ADD   R4, R4, #1       @   i1 = i1 + 1;
  ADD   R1, R1, #4       @   address1 = address1 + 4;     
  B     While            @   }
EndWh:                   @ }




  @ End of program ... check your result

End_Main:
  BX    lr

