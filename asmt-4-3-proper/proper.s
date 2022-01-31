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
  @ TIP: To view memory when debugging your program you can ...
  @
  @   Add the following watch expression: (unsigned char [64]) strA
  @
  @   OR
  @
  @   Open a Memory View specifying the address 0x20000000 and length at least 11
  @   You can open a Memory View with ctrl-shift-p type view memory (cmd-shift-p on a Mac)
  @


For:                       @ for ( firstCharacter = firstCharacter[address1] ; firstCharacter < 0x41  
  LDRB    R2, [R1]           @        +     ||   firstCharacter > 0x5A && firstCharacter < 0x61    
  CMP     R2, #0x00          @        +     ||    firstCharacter > 0x7A ('not a letter') ;  )  
  BEQ     EndWh             
  CMP     R2, #0x41           
  BLO     NonLetter          
  CMP     R2, 0x5B           
  BLO     EndFor              @  This for loop is for handling strings that have x amount of            
  CMP     R2, #0x61           @  of non-letter characters at the start.
  BLO     NonLetter
  CMP     R2, 0x7A
  BLO     EndFor              

NonLetter:                   @        {
  ADD     R1, R1, #1         @             address1 = address1 + 1;
  B       For              @        }

EndFor:  
  LDRB    R2, [R1]            @ firstCharacter = firstCharacter[address1]; 

  CMP     R2, #0x60           @ if ( firstCharacter > 0x60 && nextCharacter < 0x7B ('lower case'))
  BLS     FirstChar           @    {   
  CMP     R2, #0x7B           
  BHS     FirstChar        
  SUB     R2, R2, #0x20       @       firstCharacter = firstCharacter - 0x20;     
  STRB    R2, [R1]            @       store firstCharacter [address1]
                              @    }
FirstChar:  
  ADD     R1, R1, #1          @ address1 = address1 + 1;
  LDRB    R2, [R1]            @ nextCharacter = nextCharacter[address1]
  
While:                       @ while (  nextCharacter != null )
  CMP     R2, #0x00           @ {
  BEQ     EndWh

If:  
  CMP     R2, #0x20           @   if ( nextCharacter = 0x20 ('space') )
  BNE     Else                @      { 

  ADD     R1, R1, #1          @         address1 = address1 + 1;
  LDRB    R2, [R1]            @         nextCharacter = nextCharacter[address1]
  CMP     R2, #0x60           
  BLS     CorrectCase         @         if  ( nextCharacter > 0x60 && nextCharacter < 0x7B  )
  CMP     R2, #0x7B           @             {
  BHS     CorrectCase      
  SUB     R2, R2, #0x20       @                 nextCharacter = nextCharacter - 0x20;     
  STRB    R2, [R1]            @                 store nextCharacter [address1]    
                              @             }
CorrectCase:      
  ADD     R1, R1, #1          @         address1 = address1 + 1; 
  LDRB    R2, [R1]            @         nextCharacter = nextCharacter[address1]
  B       While              @       }

Else:                         @   else 
  CMP     R2, #0x5A           @       { 
  BHI     CorrectCase         @         if ( nextCharacter > 0x40 && nextCharacter < 0x5B ('upper case') )
  CMP     R2, #0x41           @            {
  BLO     CorrectCase          
  ADD     R2, R2, #0x20       @                 nextCharacter = nextCharacter + 0x20;     
  STRB    R2, [R1]            @                 store nextCharacter[address1]
  B       CorrectCase         @             }
                              @         address1 = address1 + 1; 
                              @         nextCharacter = nextCharacter[address1] 
                              @        }
EndWh:                       @  }

  @ End of program ... check your result

End_Main:
  BX    lr

