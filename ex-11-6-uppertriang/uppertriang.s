  .syntax unified
  .cpu cortex-m4
  .thumb
  .global  Main

Main:

  @ An upper triangular matrix is a square matrix in which all
  @  entries below the main diagonal (top-left to bottom right)
  @  are zero

  @ result = TRUE;
  @ for (r = 1; r < N; r++)
  @ {
  @   for (c = 0; c < r; c++)
  @   {
  @     elem = matrix[r][c];
  @     if (elem != 0)
  @     {
  @       result = FALSE;
  @     }
  @   }
  @ }

  MOV     R0, #1                  @ result = TRUE;
                                  @
  MOV     R4, #1                  @ for (r = 1; r < N; r++)
whR:                              @ {
  CMP     R4, R2                  @
  BHS     ewhR                    @
                                  @
  MOV     R5, #0                  @   for (c = 0; c < r; c++)
whC:                              @   {
  CMP     R5, R4                  @
  BHS     ewhC                    @
                                  @
  MUL     R6, R4, R2              @     elem = matrix[r][c];
  ADD     R6, R6, R5              @
  LDR     R7, [R1, R6, LSL #2]    @
                                  @
  CMP     R7, #0                  @     if (elem != 0)
  BEQ     endifz                  @     {
  MOV     R0, #0                  @       result = false;
endifz:                           @     }
  ADD     R5, R5, #1              @   
  B       whC                     @   }
ewhC:                             @
  ADD     R4, R4, #1              @   
  B       whR                     @ }
ewhR:

  LDR   R0, = 1              @  result = TRUE;
  LDR   R3, = 1              @ r = 1;
  LDR   R5, = 0              @ index = 0;
For:              @  for (r = 1; r < N; r++)
  CMP   R3, R2              @  {
  BHS   EndFor              @    for (c = 0; c < r; c++)
  LDR   R4, = 0              @    {
For1:                       @      elem = matrix[r][c];
  CMP   R4, R3              @      if (elem != 0)
  BHS   EndFor1              @      {
  MUL   R5, R3, R2
  ADD   R5, R5, R4              
  LDR   R6, [R1, R5, LSL #2]
  ADD   R4, R4, #1
  CMP   R6, #0      
  BEQ   For1
  LDR   R0, = 0       @        result = FALSE;
  B     EndFor 
EndFor1:                @      }
  ADD   R3, R3, #1              @    }
  B     For              @  }
EndFor:

End_Main:
  BX      LR

  .end