  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  
  @
  @ write your program here
  @


  MOV    R2, #1                         @ bitCount = 1;
  MOV    R0, #0                         @ oneCount = 0;  

While:                                  @ while ( bitCount <= 32 )  
  CMP     R2, #32                       @ {
  BHI     EndWh
  MOV     R3, #0                        @    currentOneCount = 0;
  MOVS    R1, R1, LSL #1                @    signed logical shift left by 1 bit
  BCC     Else                          @    if ( carry flag set )
                                        @    {
While1:                                 @        while ( carry flag set )
  BCC     EndWh1                        @        {
  ADD     R3, R3, #1                    @            currentOneCount = currentOneCount + 1;
  MOVS    R1, R1, LSL #1                @            signed logical shift left by 1 bit
  B       While1                        @        }

EndWh1:                                 @        if ( currentOneCount > oneCount )
  CMP     R3, R0                        @        { 
  BLS     EndIf1                        @            oneCount = currentOneCount;
  MOV     R0, R3                        @        }

EndIf1:
  ADD     R2, R2, R3                    @        bitCount = bitCount + currentOneCount;   
  B       EndIf                         @    }

Else:                                   @    else
  ADD     R2, R2, #1                    @    {
                                        @        bitCount++;
EndIf:                                  @    }
  B       While                         @  }

EndWh:


  @ End of program ... check your result

End_Main:
  BX    lr

.end
