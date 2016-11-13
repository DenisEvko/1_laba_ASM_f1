	PRESERVE8								;8-BIT VIRAVNIVANIYE STEKA											;X
	THUMB									;UAL (Unified Assembly Language)

	GET stm32f10x.s							;#include "stm32f10x.a"	
	GET config.s

	AREA RESET, CODE, READONLY				;стартовый сегмент (стартап) 
											;разбивает прогорамму на отдельные секции							(что, как работает, для чего)

	DCD STACK_TOP							;определение констант	0x20000100									(зачем??)
	DCD Reset_Handler																							;че за константа, откуда она

Reset_Handler PROC							;START OF PROGRAM
	EXPORT	Reset_Handler																						;что это

init										;initialisation MK													;X
											;RCC_APB2ENR
											;BitBanding_BASE + (REG_ADDR *32) + BIT_NUMBER * 4
	MOV32	R0,	PERIPH_BB_BASE + RCC_APB2ENR * 32 + 4 * 4		
											;0x42000000 + 0x40021018 * 32 + 4 * 4 (тактирование порта C)
	MOV 	R1, #1							;ZNACHENIE																				
	STR		R1, [R0]						;сохраняет регистр R1 по адресу в R0								
	
	MOV32	R0,	GPIOC_CRH					;0x40011004	настройка работы 9-го вывода							;что именно записывается в R0?
	MOV		R1,	#3																								;что за число?
	
	LDR		R3, [R0] 						;считывает содержимое CRH в R3
	BFI		R3, R1, #4,	#4					;в R3 пишем R1 начиная с бита: 4, колличество бит: 2				;почему 2?, BFI?, 
	STR		R3, [R0]						;GPIOC_CRH <- содержимое R3

loop
	MOV32	R0,	GPIOC_BSRR
	
	MOV		R1,	#(PIN9)						;0x00000200 - PIN9
	STR		R1,	[R0]						;PC9 <- "1"
	BL		delay
	
	MOV		R1,	#(PIN9<<16)
	STR		R1,	[R0]						;PC9 <- "1"
	BL		delay
	
	B		loop
	
delay
	LDR 	R5,	=0x220000
delay_loop
	SUBS	R5,	#1
	IT		NE
	BNE		delay_loop	
	BX	LR
				
	ENDP
	END
