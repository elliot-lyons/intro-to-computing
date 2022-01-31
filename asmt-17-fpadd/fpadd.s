  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  
  .global   fp_add

@ fp_add subroutine
@ Add two IEEE-754 floating point numbers
@
@ Paramaters:
@   R0: a - first number
@   R1: b - second number
@
@ Return:
@   R0: result - a+b
@
fp_add:
  PUSH    {R1-R10, LR}              @ add any registers R4...R12 that you use

  MOV   R4, R0                      @ localA = a;
  MOV   R5, R1                      @ localB = b;

  BL    fp_exp                      
  MOV   R6, R0                      @ aExp = fp_exp(localA);
  
  MOV   R0, R5
  BL    fp_exp
  MOV   R7, R0                      @ bExp = fp_exp(localB);
  
  MOV   R0, R4
  BL    fp_frac                     
  MOV   R8, R0                      @ aFrac = fp_frac(localA);
  
  MOV   R0, R5
  BL    fp_frac
  MOV   R9, R0                     @ bFrac = fp_frac(localB);  

  CMP   R6, R7                      @ if (aExp != bExp)
  BEQ   .LAddNormalised             @ {
  BLT   .LAddLessThan               @   if (aExp > bExp)
                                    @   {
  SUB   R10, R6, R7                 @       difference = aExp - bExp;
  MOV   R9, R9, ASR R10             @       shift bFrac right by difference bits;
  MOV   R7, R6                      @       bExp = aExp;
  B     .LAddNormalised             @   }

.LAddLessThan:                      @   else
                                    @   {
  SUB   R10, R7, R6                 @     difference = bExp - aExp;
  MOV   R8, R8, ASR R10             @     shift aFrac right by difference bits;
  MOV   R6, R7                      @     aExp = bExp;
                                    @   }
                                    @ }
.LAddNormalised:
  ADD   R0, R8, R9                  @ resultFrac =  aFrac + bFrac;
  MOV   R1, R6
  BL    fp_enc                      @ result = fp_enc(resultFrac, aExp);
   
  POP     {R1-R10, PC}              @ add any registers R4...R12 that you use


@ fp_exp subroutine
@ Obtain the exponent of an IEEE-754 (single precision) number as a signed
@   integer (2's complement)
@
@ Parameters:
@   R0: IEEE-754 number
@
@ Return:
@   R0: exponent (signed integer using 2's complement)


fp_exp:
  PUSH    {R4, LR}                  @ add any registers R4...R12 that you use

  MOV   R4, R0                      @ int localNumber = number;
  BIC   R4, #0x807FFFFF             @ clear bits[0 - 22, 31];
  MOV   R4, R4, LSR #23             @ shift right by 23 bits;
  SUB   R4, R4, #127                @ int result = localNumber - 127;
  
  MOV   R0, R4                      @ return result;  

  POP     {R4, PC}                  @ add any registers R4...R12 that you use



@ fp_frac subroutine
@ Obtain the fraction of an IEEE-754 (single precision) number.
@
@ The returned fraction will include the 'hidden' bit to the left
@   of the radix point (at bit 23). The radix point should be considered to be
@   between bits 22 and 23.
@
@ The returned fraction will be in 2's complement form, reflecting the sign
@   (sign bit) of the original IEEE-754 number.
@
@ Parameters:
@   R0: IEEE-754 number
@
@ Return:
@   R0: fraction (signed fraction, including the 'hidden' bit, in 2's
@         complement form)


fp_frac:
  PUSH    {R4-R5, LR}               @ add any registers R4...R12 that you use

  MOV   R4, R0                      @ localNumber = number;

  MOV   R5, R4, LSR #31
  
  BIC   R4, #0xFF000000             @ clear bits [31 - 24];
  ORR   R4, #0x00800000             @ set bit [23];

  CMP   R5, #1                      @ if (MSB(localNumber) == 1)
  BNE   .LFracEndIf                 @ {
  NEG   R4, R4                      @   turn result to negative;  
                                    @ }

.LFracEndIf:
  MOV   R0, R4                      @ return localNumber;
  
  POP     {R4-R5, PC}               @ add any registers R4...R12 that you use



@ fp_enc subroutine
@ Encode an IEEE-754 (single precision) floating point number given the
@   fraction (in 2's complement form) and the exponent (also in 2's
@   complement form).
@
@ Fractions that are not normalised will be normalised by the subroutine,
@   with a corresponding adjustment made to the exponent.
@
@ Parameters:
@   R0: fraction (in 2's complement form)
@   R1: exponent (in 2's complement form)
@
@ Return:
@   R0: IEEE-754 single precision floating point number


fp_enc:
  PUSH    {R4-R8, LR}               @ add any registers R4...R12 that you use

  MOV   R4, R0                      @ localFrac = fraction;
  MOV   R5, R1                      @ localExp = exponent;
  LDR   R6, = 0                     @ result = 0;
  LDR   R9, = 8                     @ eight = 8;

  CMP   R4, #0                      @ if (localFrac < 0)
  BGE   .LEncEndIf                  @ {
  ORR   R6, #0x80000000             @   MSB(result) = 1;          (this sets the sign of the result to 1, ie negative)
  NEG   R4, R4                      @   turn localFrac back into positive number
                                    @ }
.LEncEndIf:                                    
  CLZ   R7, R4                      @ count = leadingZeros(localFrac); (this counts the number of leading zeros in localFrac)
  CMP   R7, #8                      
  BEQ   .LEncNormalised             @ if (count < 8)
  BGT   .LEncGreaterThan            @ {
  SUB   R8, R9, R7                  @   n = 8 - count;
  MOV   R4, R4, LSR R8              @   shift localFrac right by n bits;
  ADD   R5, R5, R8                  @   localExp += n;
  B     .LEncNormalised             @ }     (localFrac and exponent are now normalised) 
  
                                    @ if (count > 8)
.LEncGreaterThan:                   @ {
  SUB   R8, R7, R9                  @   n = count - 8;
  MOV   R4, R4, LSL R8              @   shift localFrac left by n bits;
  SUB   R5, R5, R8                  @   localExp -= n;
                                    @ }     (localFrac and exponent are now normalised)
.LEncNormalised:  
  BIC   R4, #0x00800000             @ hide hidden bit[23]
  ADD   R5, R5, #127                @ exponent += 127;
  MOV   R5, R5, LSL #23             @ shift exponent left by 23 bits;
  ADD   R6, R6, R5                  @ result += localExp;
  ADD   R6, R6, R4                  @ result += localFrac;
  
  MOV   R0, R6                      @ return result;                      

  POP     {R4-R8, PC}               @ add any registers R4...R12 that you use


.end