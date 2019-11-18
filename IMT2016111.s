     AREA     appcode, CODE, READONLY
     EXPORT __main
	 IMPORT printMsg2p
     ENTRY 
__main  FUNCTION	
; IGNORE THIS PART 	
	    
		
		MOV R5,#319				;X-axis (a)
		MOV R6,#239				;Y-axis (b)
		MOV R7,#13				;'r'
		MOV R11,#0				;'Angle'

VALUE	BL Angle
		ADD R11,R11,#1
		
    	VMOV.F32 S13,R7			;Move the 'r' to S13
		VCVT.F32.U32 S13, S13	;Converting int to floating point
		VMUL.F32 S14,S13,S0		;S14 = r*cos(theta)
		VMOV.F32 S15,R5			;Move the 'a' to S15
		VCVT.F32.U32 S15, S15	;Converting int to floating point
		VADD.F32 S16,S15,S14	;S16 = a + r*cos(theta)
		
		VMUL.F32 S17,S13,S7		;S17 = r*sin(theta)
		VMOV.F32 S18,R6			;Move the 'b' to S18
		VCVT.F32.U32 S18, S18	;Converting int to floating point
		VADD.F32 S19,S18,S17	;S19 = b + r*sin(theta)
		
		;S16 --> x1
		;S19 --> y1
		
		VMOV.F32 R0,S16
		VMOV.F32 R1,S19
		BL printMsg2p

		CMP R11,#360
		BLE VALUE
		B stop

stop    B stop


;SubRoutine to find sin() and Cos()		
Angle	PUSH  {R8, LR}

		MOV R9,#11 				;Number of Terms in Series 'n'
        MOV R10,#1  			;Counting Variable 'i'
        VLDR.F32 S0,=1			;Final answer
        VLDR.F32 S1,=1			;Temp variable 'temp'
        VMOV.F32 S2, R11
		VCVT.F32.U32 S2, S2
		;VLDR.F32 S2,=180		;'x' value in degree
		VLDR.F32 S10,=3.14159		
		VMUL.F32 S2,S2,S10
		VLDR.F32 S11,=180
		VDIV.F32 S2,S2,S11		;'x' value converted into degrees
		VLDR.F32 S3,=-1			;S3 = -1
		
		VMOV.F32 S7,S2			;Final answer 1 = x
        VMOV.F32 S8,S2			;Temp variable 'temp1' = x
		
LOOP    CMP R10,R9				;Compare 'i' and 'n'
		BLE LOOP1				;if i < n goto LOOP
        ;B VALUE					;else goto VALUE
		SUB LR, #0x01
		POP {R8,PC}
		BX lr

LOOP1   ;Cosx
		ADD R2,R10,R10			;value in R2 is 2*i
		SUB R3,R2,#1			;value in R3 in ((2*i) - 1)
		VMUL.F32 S1,S1,S2		;temp = temp*x
		VMUL.F32 S1,S1,S2		;temp = temp*x. So above both lines result in initial temp = initial temp * x^2
		VMUL.F32 S1,S1,S3		;temp = temp * -1 (So that every alternate term is negative)
        VMOV.F32 S5,R2			;Move the value in R2 i.e 2*i to S5
        VCVT.F32.U32 S5, S5		;Converting int to floating point
        VMOV.F32 S6,R3			;Move the value in R3 i.e ((2*i) - 1) to S6
        VCVT.F32.U32 S6, S6		;Converting int to floating point
		VDIV.F32 S1,S1,S5		;temp = temp/ 2*i
		VDIV.F32 S1,S1,S6		;temp = temp/ ((2*i) - 1). So above both lines result in temp = temp / 2*i * ((2*i) - 1)
        VADD.F32 S0,S0,S1		;Final answer = Final answer + temp
		
		;Sinx
		ADD R4,R2,#1			;value in R3 in ((2*i) + 1)
		VMUL.F32 S8,S8,S2		;temp1 = temp1*x
		VMUL.F32 S8,S8,S2		;temp1 = temp1*x. So above both lines result in initial temp = initial temp * x^2
		VMUL.F32 S8,S8,S3		;temp1 = temp1 * -1 (So that every alternate term is negative)
        VMOV.F32 S9,R4			;Move the value in R4 i.e ((2*i) + 1) to S9
        VCVT.F32.U32 S9, S9		;Converting int to floating point
		VDIV.F32 S8,S8,S5		;temp1 = temp1/ 2*i
		VDIV.F32 S8,S8,S9		;temp1 = temp1/ ((2*i) + 1). So above both lines result in temp = temp / 2*i * ((2*i) + 1)
		VADD.F32 S7,S7,S8		;Final answer 1 = Final answer 1 + temp1
		
		ADD R10,R10,#1			;i = i + 1
        B LOOP					;To LOOP

		

        ENDFUNC
        END