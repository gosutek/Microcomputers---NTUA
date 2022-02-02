READ MACRO   
    MOV AH, 8
    INT 21H
ENDM 

PRINT_STR MACRO STR
    PUSH AX
    PUSH DX
    MOV DX,OFFSET STR
    MOV AH,9
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

data segment
    msg1 db 0AH,0DH,"Z=$"    
    msg2 db " W=$"   
    msg3 db 0AH,0DH,"Z+W=$" 
    msg4 db " Z-W=$"
ends

stack segment
    dw   128  dup(0)
ends

code segment
START:
    ; set segment registers:
    MOV AX, data
    MOV DS, AX
    MOV ES, AX  
    
    ; BL holds Z+W
    MOV BL,0  
    
    ; BH holds the sub
    MOV BH,0
                 
    ; Print Z and read the value                  
    PRINT_STR msg1 
    ; We read the first digit of Z
    CALL DEC_KEYB    
    MOV BL,AL
    MOV AL,0x0A
    MUL BL
    MOV BL,AL 
    ; We read the second digit of Z 
    CALL DEC_KEYB
    ADD BL,AL
    
    ; Print W and read the value  
    PRINT_STR msg2
    ; We read the first digit of W 
    CALL DEC_KEYB
    MOV BH,AL
    MOV AL,0x0A
    MUL BH
    MOV BH,AL
    ; We read the second digit of W 
    CALL DEC_KEYB
    ADD BH,AL   
    

    ; Print Z+W 
    PRINT_STR msg3 
    MOV AL,BL
    ADD AL,BH
    CALL PRINT_RESULT

    ; Print Z-W
    PRINT_STR msg4
    MOV AL,BL
    CMP AL, BH 
    ; If AL is less than BH then
    ; do W-Z
    JL display_result_negative
    ; calculate and print Z-W    
display_result_positive:
    SUB AL,BH 
    CALL PRINT_RESULT
    JMP end_of_program
; calculate and print W-Z  
display_result_negative: 
    PRINT_CHAR '-'
    MOV AL,BH
    SUB AL,BL 
    CALL PRINT_RESULT     

end_of_program:
    JMP START   
ends

DEC_KEYB PROC NEAR
    PUSH DX  
    IGNORE:
    READ
    CMP AL, 'Q'
    JE ADDR2
    CMP AL, 30H 
    JL IGNORE 
    CMP AL, 39H
    JG IGNORE
    PUSH AX
    PRINT_CHAR AL 
    POP AX
    SUB AL, 30H 
    ADDR2: POP DX
    RET
DEC_KEYB ENDP

PRINT_RESULT PROC NEAR 
    MOV CX,2
print_numbers:
    ; Get first the 4 MSB and
    ; then the 4 LSB of the byte
    ; and print the result
    ROL AL,4
    MOV DL,AL
    AND DL,0xF
    CMP DL,0
    JNE continue
    CMP CX,2
    JE loop_end
continue:            
    ; Add 30H to display the
    ; character correctly
    ADD DL, 30H
    CMP DL,'9'
    JBE below_9 
    ; If it is 0x0A-0x0F
    ; add 7 to display the
    ; character correctly
    add DL,7
    below_9:
    PUSH AX
    MOV AH,2
    INT 21H    
    POP AX
loop_end: 
    LOOP print_numbers  
    RET
PRINT_RESULT ENDP

END:
end start
