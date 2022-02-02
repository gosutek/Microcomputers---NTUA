
INCLUDE macros.asm

DATA SEGMENT
    TABLE DB 128 DUP(?) ;directive to create array of 128 unassigned items
    NUM DB 2            ;variable NUM = 2
DATA ENDS

CODE SEGMENT
    
MAIN PROC FAR
    ASSUME CS:CODE, DS:DATA  ;CS points to code seg, DS points to data seg
    MOV AX,DATA
    MOV DS,AX
    MOV DI,0    ;index register = 0
    MOV CX,128  ;counter register = 128
FILL_TABLE:
    MOV TABLE[DI],CL    ;table[0] = 128
    INC DI              ;DI++
    LOOP FILL_TABLE     ;LOOP while CX-- != 0    
    
    MOV DH,0    ;DX gets the odd value of table
    MOV AX,0    ;AX keeps the cumulative sum
    MOV BX,0    ;odd counter
    MOV DI,0    ;index register to iterate TABLE
    MOV CX,128
CUMSUMODD:
    PUSH AX     ;save current sum
    MOV AH,0    ;AH might not be zero since it holds the current sum therefore we need to make it zero
    MOV AL,TABLE[DI]  ;get TABLE[DI] value on AL
    DIV NUM           ;we basically check for a remainder with division by 2
    CMP AH,0          ;AH is the remainder of the division above
    POP AX            ;get back the current sum
    JE SKIP           ;remainder = 0 then ZF = 1 and jump else ZF = 0 and dont jump
    MOV DL,TABLE[DI]  ;get the odd value  
    ADD AX,DX         ;and add to current sum
    INC BX            ;increment the odd counter so we can do a division for the average
SKIP:                 ;if remainder != 0 then we just get to the next value  
    INC DI
    LOOP CUMSUMODD
      
    MOV DX,0          ;when operand is a word then DIV X ::= AX = (DX AX) / X, DX = remainder
    DIV BX
    CALL PRINT_NUM8_HEX
    PRINTLN ;print new line
    
    MOV AL,TABLE[0]   ;current max
    MOV BL,TABLE[127] ;current min
    MOV DI,0         
    MOV CX,128
FIND_MAX_MIN:
    CMP AL,TABLE[DI]
    JC MAX            ;if AL < TABLE[DI] then CF is set and we jump to MAX
    JMP CHECK_MIN 
MAX:
    MOV AL,TABLE[DI]  ;TABLE[DI] is the new current max
    JMP NEXT          ;get the next number
CHECK_MIN:
    CMP TABLE[DI],BL
    JC MIN            ;if TABLE[DI] < BL then CF is set and we jump to MIN
    JMP NEXT
MIN:
    MOV BL,TABLE[DI]  ;TABLE[DI] is the new current MIN  
NEXT:
    INC DI
    LOOP FIND_MAX_MIN
    ;the following procedures are copied from the lectures
    CALL PRINT_NUM8_HEX
    PRINT_CHAR "/"
    MOV AL,BL
    CALL PRINT_NUM8_HEX
    EXIT    
    
MAIN ENDP

PRINT_NUM8_HEX PROC NEAR
    MOV DL,AL
    AND DL,0F0H
    MOV CL,4
    ROR DL,CL
    CMP DL,0
    JE SKIPFIRST
    CALL PRINT_HEX
SKIPFIRST:
    MOV DL,AL
    AND DL,0FH
    CALL PRINT_HEX
    RET
PRINT_NUM8_HEX ENDP

PRINT_HEX PROC NEAR
    CMP DL,9
    JG ADDR1
    ADD DL,48
    JMP ADDR2
ADDR1:
    ADD DL,55
ADDR2:
    PRINT_CHAR DL
    RET
PRINT_HEX ENDP

CODE ENDS
END MAIN
                                                                          




