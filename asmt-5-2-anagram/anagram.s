  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

  @
  @ write your program here
  @


  LDR     R0, =1                @ boolean anagramTest = true;
  LDR     R5, =0                @ countA = 0;
  LDR     R6, =0                @ countB = 0;
  
  @ this is to test to see if the strings have the same amount of letters, if they don't they're not anagrams

CountStringA:                 @ while ( byteA != null )
  LDRB    R3, [R1]            @ {  byteA = byte[addressA]
  CMP     R3, #0x00      
  BEQ     CountStringB
  ADD     R5, R5, #1          @    countA++;
  ADD     R1, R1, #1          @    addressA++;
  B       CountStringA        @ }

CountStringB:                 @ while ( byteB != null )
  LDRB    R4, [R2]            @ {   byteB = byte[addressB]
  CMP     R4, #0x00           
  BEQ     CompareStrings
  ADD     R6, R6, #1          @     countB++;
  ADD     R2, R2, #1          @     addressB++;
  B       CountStringB        @ }

CompareStrings:               @ if ( countA != countB )
  CMP     R5, R6              @ {
  BNE     NotAnagrams         @     anagramTest = false;
                              @ }
  SUB     R1, R1, R5          @ this resets addressA and addressB to their original addresses
  SUB     R2, R2, R6 

  LDR     R5, =0              @ this resets countA and countB to 0
  LDR     R6, =0      

While:                        @ while ( byteA != null && anagramTest == true )
  LDRB     R3, [R1]           @ {
  CMP      R3, 0x00           @     for ( int countB = 0; byteB != null && anagramTest == true; countB++ )
  LDR      R6, =0             @     this initialises countB to 0
  BEQ      EndWhile           @     {   


For:                          @           if ( byteB != byteA )      these sets of if statements test to see whether the byte in
  LDRB     R4, [R2]           @           {                          byteB is the upper/lower/exact version of the byte in byteA
  CMP      R4, 0x00           @             byteB = byteB + 0x20; 
  BEQ      NotAnagrams
  CMP      R3, R4             @             if ( byteB != byteA )             
  BEQ      EndFor             @             {
  ADD      R4, R4, #0x20      @                 byteB = byteB - 0x40;
  CMP      R3, R4
  BEQ      EndFor             @                 if ( byteB != byteA )
  SUB      R4, R4, #0x40      @                 {
  CMP      R3, R4             @                     anagramTest = false;
  BEQ      EndFor             @                 }
  ADD      R6, R6, #1         @              }                              
  ADD      R2, R2, #1         @           }    
  B        For                @      countB++;
                              @      addressB++;
EndFor:                       @      }
  STR     R6, [R9]
  ADD     R9, R9, #4
  SUB     R2, R2, R6          @  this resets addressB back to its original address
  ADD     R1, R1, #1          @  addressA++;
  ADD     R5, R5, #1          @  countA++;
  B       While               @ }

EndWhile:
  SUB     R1, R1, R5          @ this resets addressA to its original address, B is already at its original address          

NotAnagrams:
  LDR     R0, =0              @ anagramTest = false;

Anagrams:


End:



  @ End of program ... check your result

End_Main:
  BX    lr

