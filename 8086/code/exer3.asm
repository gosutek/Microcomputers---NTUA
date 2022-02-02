READ MACRO 
    MOV AH, 8
    INT 21H
ENDM

PRINTLN MACRO
    PUSH AX
    PUSH DX
    MOV DL,13
    MOV AH,2
    INT 21H
    MOV DL,10
    MOV AH,2
    INT 21H
    POP DX
    POP AX
ENDM

PRINT_CHAR MACRO CHAR
    PUSH AX
    PUSH DX
    MOV DL,CHAR
    MOV AH,2
    INT 21H
    POP DX
    POP AX
ENDM  

PRINT_NUMBER MACRO CHAR
    PUSH AX
    PUSH DX
    MOV DL,CHAR
    ADD DL,30H
    MOV AH,2
    INT 21H
    POP DX
    POP AX
ENDM 

MAIN PROC FAR
start:   
    ; Get first digit
    CALL HEX_KEYB 
    MOV BH,AL  
    
    ; Get second digit
    CALL HEX_KEYB
    MOV BL,AL
    SHL BL,4  
    
    ; Get third digit
    CALL HEX_KEYB
    ADD BL,AL
    
    PRINT_CHAR '=' 
      
    CALL PRINT_DEC
    PRINT_CHAR '='
     
    
    CALL PRINT_OCT
    PRINT_CHAR '=' 

    CALL PRINT_BIN
    PRINTLN
    
    JMP start
MAIN ENDP

HEX_KEYB PROC NEAR
    PUSH DX 
    IGNORE:
    READ 
    CMP AL, 'Q' 
    JE ADDR2
    CMP AL,30H 
    JL IGNORE 
    CMP AL,39H
    JG ADDR1
    PUSH AX
    PRINT_CHAR AL
    POP AX
    SUB AL,30H 
    JMP ADDR2
    ADDR1: CMP AL,'A'
    JL IGNORE
    CMP AL,'F'
    JG IGNORE
    PUSH AX
    PRINT_CHAR AL
    POP AX
    SUB AL,37H
    ADDR2: POP DX 
    RET   
HEX_KEYB ENDP


PRINT_DEC PROC NEAR  
    PUSH BX
    MOV AX,BX
    MOV BL,100
    DIV BL
    MOV AH,0
    MOV BL,10
    DIV BL
      
    PRINT_NUMBER AL
    ; Subtract the thousands calculated
    ; We subtract because the remainder that
    ; is returned in AH can overflow. For example
    ; 3999/1000 has remainder 999 which is more
    ; than one byte and cannot fit in AH to get
    ; it directly from there
    ;MOV CL,AL

    MOV DX,1000
    MOV AH,0
    MUL DX
    POP BX
    PUSH BX 
    SUB BX,AX
    
    ; If the thousands are not 0 display
    ; the number
    ;CMP CL,0
    ;JE three_decimal_digits  
    

three_decimal_digits:
    MOV AX,BX
    MOV BL,100
    DIV BL
    
    ; Here the remainder will always fit in
    ; the AH so we can get it directly from
    ; there
    MOV BL,AH 
    MOV BH,0
    CMP AL,0
    ;JE two_decimal_digits
    PRINT_NUMBER AL

two_decimal_digits:
    MOV AX,BX
    MOV BL,10
    DIV BL
    
    ; Get the last two digits from the 
    ; remainder and quotidient respectively
    PRINT_NUMBER AL
    PRINT_NUMBER AH
    
    POP BX   
    RET   
PRINT_DEC ENDP

PRINT_OCT PROC NEAR 
    ; Here three bits are directly
    ; one character in the octal system
    ; so we divide them in triads
    
    ; First 3 bits
    MOV AL,BH
    SHR AL,1
    AND AL,0x07
    PRINT_NUMBER AL
    
    ; Second 3 bits
    MOV AL,BH
    AND AL,0x01
    SHL AL,2
    MOV AH,BL
    SHR AH,6
    AND AH,0x07
    OR AL,AH
    PRINT_NUMBER AL
     
    ; Third 3 bits
    MOV AL,BL
    SHR AL,3
    AND AL,0x07
    PRINT_NUMBER AL
    
    ; Fourth 3 bits
    MOV AL,BL
    AND AL,0x07
    PRINT_NUMBER AL
    
    RET   
PRINT_OCT ENDP  

PRINT_BIN PROC NEAR
    ; In this function we loop
    ; through all the bits one
    ; by one
            
    ; First 4 bits are in BH
    ROL BH,4
    MOV CX,4 
first_4_bits:
    ROL BH,1
    MOV AL,BH  
    AND AL,01H
    ADD AL,30H 
    PRINT_CHAR AL
    LOOP first_4_bits  
    
    ; First 8 bits are in BL
    MOV AL,BL
    MOV CX,8
last_8_bits:
    ROL BL,1
    MOV AL,BL 
    AND AL,01H
    ADD AL,30H 
    PRINT_CHAR AL
    LOOP last_8_bits
    RET
PRINT_BIN ENDP
