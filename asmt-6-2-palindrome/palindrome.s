  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

  @
  @ write your program here
  @


  @ This while loop will create 2 modified copies of the string in R1.
  @ The copies will only store the numbers and upper case versions of the letters. 
  @ It will disregard punctuation and spaces.

  LDR     R3, =0x20000000           @ modifiedString1Address = 0x20000000;
  LDR     R4, =0x2000AAAA           @ modifiedString2Address = 0x2000AAAA;
    
  @ This is the program initialising R3 and R4 in RAM. It'll put the modified strings in these addresses in RAM

  
  MOV     R0, #1                    @ boolean isPalindrome = true;
  MOV     R5, #0                    @ int byteCount = 0;

While:    
  LDRB    R2, [R1]                  @ while ( byte != null )          
  CMP     R2, #0x00                 @ {
  BEQ     EndWh                     @   load byte [address1]                     
  CMP     R2, #0x5A                 @   if ( byte > 0x5A )
  BLS     EndIf                     @   {
  BIC     R2, R2, #0x20             @       clear the 5th bit (this will essentially capitalise all the lower case letters)
                                    @   }
EndIf:                              
  CMP     R2, #0x30                 @   if ( (byte >= 0x30 && byte <= 0x39) || (byte >= 0x41 && byte <= 0x5A) )
  BLO     EndIf1                    @   {  
  CMP     R2, #0x39                 
  BLS     Copy                      
  CMP     R2, #0x41                 @       These tests check to see if the byte is either a capital letter or a number. 
  BLO     EndIf1                    @       The lower case letters will be capitalised as above.
  CMP     R2, #0x5A                 
  BHI     EndIf1                    @       if the byte is a capital letter or a number: 

Copy:                              
  STRB    R2, [R3]                  @       store byte in modifiedString1
  STRB    R2, [R4]                  @       store byte in modifiedString2
  ADD     R3, R3, #1                @       modifiedString1Address++;
  ADD     R4, R4, #1                @       modifiedString2Address++;
  ADD     R5, R5, #1                @       byteCount++;
                                    @   }
EndIf1:
  ADD     R1, R1, #1                @   originalStringAddress++;
  B       While                     @ }

  @ Now there's a modified string in R3 and R4 of the string in R1 with only upper case letters and numbers.

EndWh:  
  SUB     R3, R3, R5                @ This resets modifiedString1Address to the start of the string.
  SUB     R4, R4, #1                @ This puts the modifiedString2Address to the end of the string.                           
  
  
  
  @ The below while loop goes through the modified strings. The modified strings are the same.
  @ It goes through modifiedString2 backwards and modifiedString1 forwards.
  @ If the words are palindromes the byte loaded in from each string should equal each other.
  @ If not it will set isPalindrome to false


While1:                             @ while ( byteCount != 0 && isPalindrome )
  CMP     R5, #0                    @ {  
  BEQ     EndWh1
  LDRB    R6, [R3]                  @   modifiedByte1 = loaded from modifiedString1Address
  LDRB    R7, [R4]                  @   modifiedByte2 = loaded from modifiedString2Address
  CMP     R6, R7                    @   if ( modifiedByte1 == modifiedByte2 )
  BNE     NotPalindromes            @   {
  ADD     R3, R3, #1                @       modifiedString1Address++;
  SUB     R4, R4, #1                @       modifiedString2Address++;
  SUB     R5, R5, #1                @       byteCount--;
  B       While1                    @   }
                                    @   else
NotPalindromes:                     @   {
  MOV     R0, #0                    @     isPalindrome = false;
                                    @   }
EndWh1:                             @ }
  

  @ End of program ... check your result

End_Main:
  BX    lr

