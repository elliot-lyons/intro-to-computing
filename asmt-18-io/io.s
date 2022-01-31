  .syntax unified
  .cpu cortex-m4
  .thumb
  .global Main
  .global SysTick_Handler
  .global EXTI0_IRQHandler

@ Uncomment if you are providing a EXTI0_IRQHandler subroutine
@  .global EXTI0_IRQHandler

  @ Definitions are in definitions.s to keep this file "clean"
  .include "definitions.s"

  .equ    BLINK_PERIOD, 1000

@
@ To debug this program, you need to change your "Run and Debug"
@   configuration from "Emulate current ARM .s file" to "Graphic Emulate
@   current ARM .s file".
@
@ You can do this is either of the followig two ways:
@
@   1. Switch to the Run and Debug panel ("ladybug/play" icon on the left).
@      Change the dropdown at the top of the Run and Debug panel to "Graphic
@      Emulate current ARM .s file".
@
@   2. ctrl-shift-P (cmd-shift-P on a Mac) and type "Select and Start Debugging".
@      When prompted, select "Graphic Emulate ...".
@



Main:
  PUSH    {R4-R9, LR}

  MOV     R6, #8                    @ int count = 8;
  LDR     R7, = count           
  STR     R6, [R7]                  @ storing count in memory

  MOV     R8, #1                    @ boolean buttonStatus = true;   
  LDR     R9, = buttonStatus  
  STR     R8, [R9]                  @ storing buttonStatus in memory

  @ Enable GPIO port D by enabling its clock
  LDR     R4, =RCC_AHB1ENR
  LDR     R5, [R4]
  ORR     R5, R5, RCC_AHB1ENR_GPIODEN
  STR     R5, [R4]

  LDR     R4, =countdown            @ setting the interval timer to periods of 1000ms
  LDR     R5, =BLINK_PERIOD
  STR     R5, [R4]  


  @ Configure SysTick Timer to generate an interrupt every 1ms

  LDR   R4, =SYSTICK_CSR            @ Stop SysTick timer
  LDR   R5, =0                      @   by writing 0 to CSR
  STR   R5, [R4]                    @   CSR is the Control and Status Register
  
  LDR   R4, =SYSTICK_LOAD           @ Set SysTick LOAD for 1ms delay
  LDR   R5, =0x3E7F                 @ Assuming a 16MHz clock,
  STR   R5, [R4]                    @   16x10^6 / 10^3 - 1 = 15999 = 0x3E7F

  LDR   R4, =SYSTICK_VAL            @   Reset SysTick internal counter to 0
  LDR   R5, =0x1                    @     by writing any value
  STR   R5, [R4]

  LDR   R4, =SYSTICK_CSR            @   Start SysTick timer by setting CSR to 0x7
  LDR   R5, =0x7                    @     set CLKSOURCE (bit 2) to system clock (1)
  STR   R5, [R4]                    @     set TICKINT (bit 1) to 1 to enable interrupts
                                    @     set ENABLE (bit 0) to 1

                                    @ Enable (unmask) interrupts on external interrupt Line0
  LDR     R4, =EXTI_IMR
  LDR     R5, [R4]
  ORR     R5, R5, #1
  STR     R5, [R4]

  @ Set falling edge detection on Line0
  LDR     R4, =EXTI_FTSR
  LDR     R5, [R4]
  ORR     R5, R5, #1
  STR     R5, [R4]

  @ Enable NVIC interrupt #6 (external interrupt Line0)
  LDR     R4, =NVIC_ISER
  MOV     R5, #(1<<6)
  STR     R5, [R4]

  @ Nothing else to do in Main
  @ Idle loop forever (welcome to interrupts!)
Idle_Loop:
  B     Idle_Loop
  
End_Main:
  POP   {R4-R9,PC}


@
@ SysTick interrupt handler
@
  .type  SysTick_Handler, %function
SysTick_Handler:

  PUSH  {R4-R9, LR}

  LDR     R6, = count
  LDR     R7, [R6]
  LDR     R8, = buttonStatus
  LDR     R9, [R8]

  CMP     R9, #0                      @ if (buttonStatus == true)
  BEQ     .LendIfDelay                @ {

  LDR     R4, =countdown              @   loading countdown from memory
  LDR     R5, [R4]                    @ 
  CMP     R5, #0                      @ 
  BEQ     .LelseFire                  @   if (countdown != 0)
                                      @   {
  SUB     R5, R5, #1                  @     countdown = countdown - 1;
  STR     R5, [R4]                    @ 

  B       .LendIfDelay                @   }

.LelseFire:                           @   else 
  CMP     R7, #7                      @   {  
  BLO     .LelseFire1                 @      if (count >= 7)
                                      @      {
  LDR     R4, =GPIOD_MODER    
  LDR     R5, [R4]                    @         Read ...
  BIC     R5, #(0b11<<(LD3_PIN*2))    @         Modify ...
  ORR     R5, #(0b01<<(LD3_PIN*2))    @         write 01 to bits 
  STR     R5, [R4]                    @         Write   
  LDR     R4, =GPIOD_ODR              @         Invert LD3
  LDR     R5, [R4]                    @     
  EOR     R5, #(0b1<<(LD3_PIN))       @         GPIOD_ODR = GPIOD_ODR ^ (1<<LD3_PIN);
  STR     R5, [R4]                    @       

  LDR     R4, =countdown              @         countdown = BLINK_PERIOD;
  LDR     R5, =BLINK_PERIOD             
  STR     R5, [R4]                      
  SUB     R7, R7, #1                  @         count--;
  B       .LendIfDelay                @      }

.LelseFire1:                          @      else if (count >= 5)
  CMP     R7, #5                      @      { 
  BLO     .LelseFire2   

  LDR     R4, =GPIOD_MODER    
  LDR     R5, [R4]                    @         Read ...
  BIC     R5, #(0b11<<(LD4_PIN*2))    @         Modify ...
  ORR     R5, #(0b01<<(LD4_PIN*2))    @         write 01 to bits 
  STR     R5, [R4]                    @         Write   
  LDR     R4, =GPIOD_ODR              @         Invert LD4
  LDR     R5, [R4]                    @     
  EOR     R5, #(0b1<<(LD4_PIN))       @         GPIOD_ODR = GPIOD_ODR ^ (1<<LD4_PIN);
  STR     R5, [R4]                    @       

  LDR     R4, =countdown              @         countdown = BLINK_PERIOD;
  LDR     R5, =BLINK_PERIOD             
  STR     R5, [R4]                      
  SUB     R7, R7, #1                  @         count--;
  B       .LendIfDelay                @      }

.LelseFire2:    
  CMP     R7, #3                      @      else if (count >= 3)
  BLO     .LelseFire3                 @      {

  LDR     R4, =GPIOD_MODER    
  LDR     R5, [R4]                    @         Read ...
  BIC     R5, #(0b11<<(LD5_PIN*2))    @         Modify ...
  ORR     R5, #(0b01<<(LD5_PIN*2))    @         write 01 to bits 
  STR     R5, [R4]                    @         Write   
  LDR     R4, =GPIOD_ODR              @         Invert LD5
  LDR     R5, [R4]                    @     
  EOR     R5, #(0b1<<(LD5_PIN))       @         GPIOD_ODR = GPIOD_ODR ^ (1<<LD5_PIN);
  STR     R5, [R4]                    @       

  LDR     R4, =countdown              @         countdown = BLINK_PERIOD;
  LDR     R5, =BLINK_PERIOD               
  STR     R5, [R4]                        
  SUB     R7, R7, #1                  @         count--;
  B       .LendIfDelay                @      }

.LelseFire3:                          @      else
                                      @      {
  LDR     R4, =GPIOD_MODER        
  LDR     R5, [R4]                    @         Read ...
  BIC     R5, #(0b11<<(LD6_PIN*2))    @         Modify ...
  ORR     R5, #(0b01<<(LD6_PIN*2))    @         write 01 to bits 
  STR     R5, [R4]                    @         Write   
  LDR     R4, =GPIOD_ODR              @         Invert LD6
  LDR     R5, [R4]                    @     
  EOR     R5, #(0b1<<(LD6_PIN))       @         GPIOD_ODR = GPIOD_ODR ^ (1<<LD6_PIN);
  STR     R5, [R4]                    @       

  LDR     R4, =countdown              @         countdown = BLINK_PERIOD;
  LDR     R5, =BLINK_PERIOD           @     
  STR     R5, [R4]                    @       }

  CMP     R7, #1                      @       if (count > 1)
  BEQ     .LelseFire4                 @       {
  SUB     R7, R7, #1                  @           count--;
  B       .LendIfDelay                @       }

.LelseFire4:                          @       else {
  MOV     R7, #8                      @           count = 8;
                                      @       }
.LendIfDelay:                         @     }
                                      @   }
  
  STR     R7, [R6]                    @ storing count back in memory
  LDR     R4, =SCB_ICSR               @ Clear (acknowledge) the interrupt
  LDR     R5, =SCB_ICSR_PENDSTCLR
  STR     R5, [R4]   

  @ Return from interrupt handler
  POP  {R4-R9, PC}

  .type  EXTI0_IRQHandler, %function
EXTI0_IRQHandler:

  PUSH  {R4-R7, LR}

  LDR     R8, = buttonStatus          @ loading buttonStatus from memory
  LDR     R9, [R8]  

  LDR     R6, = count                 @ loading count from memory
  LDR     R7, [R6]                      

                                      @ switch (count) {
  CMP     R7, #3                      @ case 3:
  BEQ     .Lred 
  CMP     R7, #7                      @ case 7:
  BEQ     .Lorange                    @ invert orange; (and break only if count == 7)
  CMP     R7, #5                      @ case 5:
  BEQ     .Lgreen                     @ invert green; (and break only if count == 5)
  CMP     R7, #1                      @ case 1:
  BEQ     .Lblue                      @ invert blue;
  B       .LredEnd                    @ }

.Lred:
.Lorange:  
  LDR     R4, =GPIOD_MODER    
  LDR     R5, [R4]                    @       Read ...
  BIC     R5, #(0b11<<(LD3_PIN*2))    @       Modify ...
  ORR     R5, #(0b01<<(LD3_PIN*2))    @       write 01 to bits 
  STR     R5, [R4]                    @       Write   
  LDR     R4, =GPIOD_ODR              @         Invert LD3
  LDR     R5, [R4]                    @     
  EOR     R5, #(0b1<<(LD3_PIN))       @         GPIOD_ODR = GPIOD_ODR ^ (1<<LD3_PIN);
  STR     R5, [R4]                    @       
  CMP     R7, #7                      @         break only if count == 7;
  BEQ     .LredEnd

.Lgreen:
  LDR     R4, =GPIOD_MODER    
  LDR     R5, [R4]                    @       Read ...
  BIC     R5, #(0b11<<(LD4_PIN*2))    @       Modify ...
  ORR     R5, #(0b01<<(LD4_PIN*2))    @       write 01 to bits 
  STR     R5, [R4]                    @       Write   
  LDR     R4, =GPIOD_ODR              @         Invert LD4
  LDR     R5, [R4]                    @     
  EOR     R5, #(0b1<<(LD4_PIN))       @         GPIOD_ODR = GPIOD_ODR ^ (1<<LD4_PIN);
  STR     R5, [R4]                    @       
  CMP     R7, #5                      @         break only if count == 5;
  BEQ     .LredEnd

.Lblue:
  LDR     R4, =GPIOD_MODER        
  LDR     R5, [R4]                    @       Read ...
  BIC     R5, #(0b11<<(LD6_PIN*2))    @       Modify ...
  ORR     R5, #(0b01<<(LD6_PIN*2))    @       write 01 to bits 
  STR     R5, [R4]                    @       Write   
  LDR     R4, =GPIOD_ODR              @         Invert LD6
  LDR     R5, [R4]                    @     
  EOR     R5, #(0b1<<(LD6_PIN))       @         GPIOD_ODR = GPIOD_ODR ^ (1<<LD6_PIN);
  STR     R5, [R4]                    @       

.LredEnd: 
  CMP   R9, #0                        @ if (buttonStatus == false)
  BNE   .LbuttonTrue                  @ {
  MOV   R9, #1                        @   buttonStatus = true; 
  B     .LelseButtonEnd               @ }

.LbuttonTrue:                         @ else {   
  MOV   R9, #0                        @   buttonStatus = false;
                                      @ }
.LelseButtonEnd:    
  STR   R9, [R8]                      @ storing buttonStatus back into memory

  LDR   R4, =EXTI_PR                  @ Clear (acknowledge) the interrupt
  MOV   R5, #(1<<0)                   @
  STR   R5, [R4]                      @

  @ Return from interrupt handler
  POP  {R4-R7, PC}



  .section .data

countdown:
  .space  4

count:
  .space  4

buttonStatus:
  .space  4      

  .end
