  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:
  

  @
  @ write your program here
  @


  @
  @ Debugging tips:
  @
  @ If using the View Memory window
  @   - view originalString using address "&originalString" and size 32
  @   - view newString using address "&newString" and size 32
  @
  @ If using a Watch Expression (array with ASCII character codes)
  @   view originalString using expression "(char[32])originalString"
  @   view newString using expression "(char[32])newString"
  @
  @ If using a Watch Expression (just see the string)
  @   view originalString using expression "(char*)&originalString"
  @   view newString using expression "(char*)&newString"
  @


  @ End of program ... check your result


  @ This part of the code is especially for the first character 
  @ It is the only time the first letter, even, after a space or a character isn't capitalised.
  @ In this programme spaces and characters are treated as the same.

FirstCharacter:               @ while ( !null && firstCharacter )    
  LDRB  R2, [R1]              @ {
  CMP   R2, #0x00             @   byteA = byte[addressA];
  BEQ   End                   
  CMP   R2, #0x41             @   if ( byteA < 'A' || (byteA > 'Z' && byteA < 'a') || byteA > 'z' )
  BLO   Characters1           @   {
  CMP   R2, #0x5B             @       byteA is a space or a character and is therefore disregarded
  BLO   Uncapitalise          @   }
  CMP   R2, #0x60             @   if ( byteA > '@' && byteA < '[' )
  BLO   Characters1           @   {
  CMP   R2, #0x7A             @       byteA is a capital letter, and needs to be changed to lower case. 
  BHI   Characters1           @       it is done so in the function 'Uncapitalise'
  B     CorrectCase           @   }
                              @   if ( byteA > '`' && byteA < '{')
Characters1:                  @   {
  ADD   R1, R1, #1            @     byteA is in lower case, which is correct. It will be stored in memory
  B     FirstCharacter        @     using the function 'Capitalise'
                              @    } 
                              @  }

  @ This part of the code then deals with the rest of the string.

                              @ while ( !null )
NextCharacter:                @ {
  ADD   R1, R1, #1            @   addressA = addressA + 1;
  LDRB  R2, [R1]              @   byteA = byte[addressA];
  CMP   R2, #0x00             @   if ( (byteA < 'A') || (byteA > 'Z' && byteA < 'a') || byteA > 'z' ) 
  BEQ   End                   @   {
  CMP   R2, #0x41             @     byteA is a non-letter character and is treated in the 'Characters'
  BLO   Characters            @         function.
  CMP   R2, #0x5B             @   }
  BLO   Uncapitalise          @   if ( byteA > '@' && byteA < '[')
  CMP   R2, #0x61             @   {
  BLO   Characters            @      byteA is a capital letter when it shouldn't be. 
  CMP   R2, #0x7B             @      It's turned into lower case in the 'Uncapitalise' function.
  BLO   CorrectCase           @   }
                              @   else        
                              @   { The letter is in lower case, which is correct. It is stored in
                              @     memory using the 'CorrectCase' function.   }

Characters:                   @  This is the 'Characters' function.
  ADD   R1, R1, #1            @  It filters through the string until a letter appears.
  LDRB  R2, [R1]              @  When one does, it then checks to see if it is in upper case. 
  CMP   R2, #0x00             @  If it is, as it should. The program jumps to the 'CorrectCase' function.
  BEQ   End                   @  There, it stores the letter in memory.
  CMP   R2, #0x41              
  BLO   Characters             
  CMP   R2, #0x61             @  If it is a lower case letter, the program naturally flows
  BLO   CorrectCase           @  to the 'Capitalise' function.
  CMP   R2, #0x7A
  BHI   Characters

Capitalise:                   @  This is the 'Capitalise' function.
  BIC   R2, R2, #0x20         @  This clears bit 5, making the letter upper case.
                              @  The program again flows into the 'CorrectCase' function

CorrectCase:                  @  If a letter has gotten here, it is ready to be stored in memory.
  STRB  R2, [R0]              @  store byteA in newStringAddress;
  ADD   R0, R0, #1            @  newStringAddress = newStringAddress + 1;
  B     NextCharacter         @  break to NextCharacter; 
  
Uncapitalise:                 @  This is the 'Uncapitalise' function
  ORR   R2, R2, #0x20         @  This sets bit 5, making the letter lower case.   
  B     CorrectCase           @  The program jumps back to the 'CorrectCase' function
                              @  to store the lower case letter.
End:                          @  }

End_Main:
  BX    lr

