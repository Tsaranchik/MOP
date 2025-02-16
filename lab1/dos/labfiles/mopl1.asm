;***************************************************************************************************
; MOPL1.ASM - ???? ???? ??? ???????? 
; ???????? ???? N1 ?? ?????-??????????? ??????????
;***************************************************************************************************
        .MODEL SMALL
        .STACK 200h
	.386
;       ????????? ??????? ?????? ? ?????
        INCLUDE MOPL1.INC	
        INCLUDE MOPL1.MAC

; ??????? ??????
        .DATA    
SLINE	DB	78 DUP (CHSEP), 0
REQ	DB	"Familya I.O.: ",0FFh
MINIS	DB	"MINISTERSTVO OBRAZOVANIYA ROSSIYSKOY FEDERACYI",0
ULSTU	DB	"ULYANOVSKIY GOSUDARSTVENYI TEHNICHESKIY UNIVERSITET",0
DEPT	DB	"Kafedra vychislitelnoy tehniki",0
MOP	DB	"Mashinno-orientirovannoe programirovanie",0
LABR	DB	"Laboratornya rabota N 1",0
REQ1    DB      "Zamedlit` vremya raboty v taktah(-), uskorit` vremya raboty v taktah (+),", 0
;------------- ???? ??????? ------------------------------------------------------------------
REQ2	DB	"vycheslit` functiuy (f), vyiti(ESC)?", 0FFh
;-------------------------------------------------------------------------------------------------
TACTS   DB	"vremya raboty v taktah: ",0FFh
EMPTYS	DB	0
BUFLEN = 70
BUF	DB	BUFLEN
LENS	DB	?
SNAME	DB	BUFLEN DUP (0)
PAUSE	DW	0, 0 ; ????? ? ???? ??? ?????? ?? ???? ????
TI	DB	LENNUM+LENNUM/2 DUP(?), 0 ; ???? ???? ?? ??
                                          ; ????? ??? ????????? "`
TASK_Z  DB      "Z = f11 ? X/8 + Y * 8 : X * 2 - Y * 8. z7 = z8, z11 &= z14, z18 |= z10", 0
TASK_F  DB      "f11 = x1!x2x3 | x2!x3x4 | x3!x4 | x1x4 | !x2!x3", 0
INP_X   DB      "Vvedity X - 20-razryadnoe dvoichnoe chislo: ", 0
INP_Y   DB      "Vvedity Y - 20-razryadnoe dvoichnoe chislo: ", 0
INP_ERR DB      "Vy dopustily oshibky vo vremya vvoda chisla, poprobyite eche raz.", 0
F_ZERO  DB      "f11 = 0", 0
F_ONE   DB      "f11 = 1", 0
Z_OUT   DB      "Z = ", 0
Z_MAIN  DB      "Z = f11 ? X/8 + Y * 8 : X * 2 - Y * 8", 0
Z_BITS  DB      "z7 = z8, z11 &= z14, z18 |= z10", 0
NEXT    DB      "Nazhmite (c) chtoby prodolzyt`", 0

X       DD      0
Y       DD      0
F       DD      0
Z       DD      0

;========================= ????? =========================
        .CODE
; ????? ?????????? ???? LINE ?? ????? POS ????? CNT ????,
; ??????? ???? ADR ?? ??? ???? ???? WFLD
BEGIN	LABEL	NEAR
	; ?????????? ??????? ?????
	MOV	AX,	@DATA
	MOV	DS,	AX
	; ?????????? ??????
	MOV	PAUSE,	PAUSE_L
	MOV	PAUSE+2,PAUSE_H
	PUTLS	REQ	; ????? ?????
	; ???? ?????
	LEA	DX,	BUF
	CALL	GETS	
@@L:	; ?????? ????? ??????? ???? ??????
	; ??? ??????
	; ????????? ??????? ?????? ?????
	FIXTIME
	PUTL	EMPTYS
	PUTL	SLINE	; ???????? ???
	PUTL	EMPTYS
	PUTLSC	MINIS	; ???? 
	PUTL	EMPTYS
	PUTLSC	ULSTU	;  ?  
	PUTL	EMPTYS
	PUTLSC	DEPT	;   ??????? 
	PUTL	EMPTYS
	PUTLSC	MOP	;    ????  
	PUTL	EMPTYS
	PUTLSC	LABR	;     ??????
	PUTL	EMPTYS
	; ???????
	PUTLSC	SNAME   ; ??? ?????
	PUTL	EMPTYS
	; ???????? ???
	PUTL	SLINE
	; ????????? ??????? ????????? ????? 
	DURAT    	; ?????? ????????? ?????
	; ?????????? ?? ??? ? ???? ? ???
	LEA	DI,	TI
	CALL	UTOA10	
	PUTL	TACTS
	PUTL	TI      ; ??? ?? ??
	; ????? ???????
	PUTL	REQ1
;------??? ??? ??? ? ?????? -------------------
	PUTL	REQ2
;--------------------------------------------------------
	CALL	GETCH
	CMP	AL,	'-'    ; ??????? ???????
	JNE	CMINUS
	INC	PAUSE+2        ; ???????? 65536 ???
	JMP	@@L
CMINUS:	CMP	AL,	'+'    ; ?????? ???????
	JNE	LAB_START
	CMP	WORD PTR PAUSE+2, 0		
	JE	BACK
	DEC	PAUSE+2        ; ????? 65536 ???
BACK:	JMP	@@L

LAB_START:
        cmp al, 'f'
        jne CEXIT

OUTPUT_MSGS:
	xor ebx, ebx
	xor eax, eax
        xor di, di

	PUTL EMPTYS
        PUTL EMPTYS
	PUTL TASK_Z
        PUTL EMPTYS
	PUTL EMPTYS
	PUTL TASK_F
	PUTL EMPTYS
        PUTL EMPTYS
	PUTL INP_X
	; mov ah, 9h
	; lea edx, TASK_Z
	; int 21h
	; lea edx, newline
	; int 21h

	; lea edx, TASK_F
	; int 21h
	; lea edx, newline
	; int 21h

	; lea edx, inp_x
	; int 21h
	; lea edx, newline
	; int 21h

	mov ah, 1h
	mov cx, 20

INPUT:
	int 21h
	shl ebx, 1

	cmp al, '0'
	je CYCLE_CHECK
	cmp al, '1'
	jne ENTER_CHECK
	add ebx, 1

CYCLE_CHECK:
	dec cx
	jnz INPUT
	jmp CYCLE_END

ENTER_CHECK:
	cmp al, 0Dh
	jne INPUT_ERROR

CYCLE_END:
	cmp di, 20
	je STORE_Y
	mov X, ebx
	jmp PRP_Y_INPUT

INPUT_ERROR:
        PUTL EMPTYS
        PUTL INP_ERR
        PUTL EMPTYS
        jmp OUTPUT_MSGS

STORE_Y:
	mov Y, ebx
        xor di, di
	jmp CALC_F

PRP_Y_INPUT:
	mov di, 20

	PUTL EMPTYS
	PUTL INP_Y
	; mov ah, 9h
	; lea edx, inp_y
	; int 21h
	; lea edx, newline
	; int 21h

	mov ah, 1h
        mov cx, 20
	jmp INPUT

CALC_F:
	mov ebx, X
        and ebx, 11110b
        shr ebx, 1
        
        cmp ebx, 0001b
        je F_0
        cmp ebx, 0011b
        je F_0
        cmp ebx, 0111b
        je F_0
        
        mov F, 1
        PUTL EMPTYS
        PUTL F_ONE
        PUTL EMPTYS
        jmp CALC_Z
        
F_0:
        PUTL EMPTYS
        PUTL F_ZERO
        PUTL EMPTYS
        
CALC_Z:
        PUTL Z_MAIN
        PUTL EMPTYS
        
        mov eax, X
        mov ebx, Y
        
        cmp F, 1
        je F_1
        
        shl eax, 1
        shl ebx, 3
        sub eax, ebx
        jmp STORE_Z
        
F_1:
        shr eax, 3
        shl ebx, 3
        add eax, ebx
        
STORE_Z:
        mov Z, eax

OUT_Z:
        PUTL Z_OUT
        
        mov ebx, Z
        mov cx, 20
        shl ebx, 12
        
Z_OUT_CYCLE:
        shl ebx, 1
        jc OUT_ONE
        mov dl, '0'
        jmp EXIT_CYCLE

OUT_ONE:
        mov dl, '1'
        
EXIT_CYCLE:
        int 21h
loop Z_OUT_CYCLE

SECOND_Z_OUT_CHECK:
        cmp di, 20
        je CONTINUE

Z_BITS_CHANGE:
        PUTL EMPTYS
        PUTL EMPTYS
        PUTL Z_BITS
        PUTL EMPTYS
        xor di, di
        
        
        mov ebx, Z
        ; z7 = z8
        bt ebx, 8
        jc CHANGE_BIT7
        btr ebx, 7
        jmp NEXT_BIT_1

CHANGE_BIT7:
        bts ebx, 7
        
NEXT_BIT_1:
        ; z11 &= z14
        bt ebx, 14
        jc NEXT_BIT_2
        btr ebx, 11

NEXT_BIT_2:
        ; z18 |= z10
        bt ebx, 10
        jnc Z_OUT_PRP
        bts ebx, 18

Z_OUT_PRP:
        mov di, 20
        mov Z, ebx
        jmp OUT_Z

CONTINUE:
        PUTL EMPTYS
        PUTL NEXT
        
        mov ah, 1h
        int 21h
        cmp al, 'c'
        jne CONTINUE
        jmp CEXIT

CEXIT:	CMP	AL,	CHESC	
	JE	@@E
	TEST	AL,	AL
	JNE	BACK
	CALL	GETCH
	JMP	@@L
	; ??? ?? ?????
@@E:	EXIT	
        EXTRN	PUTSS:  NEAR
        EXTRN	PUTC:   NEAR
	EXTRN   GETCH:  NEAR
	EXTRN   GETS:   NEAR
	EXTRN   SLEN:   NEAR
	EXTRN   UTOA10: NEAR
	END	BEGIN
