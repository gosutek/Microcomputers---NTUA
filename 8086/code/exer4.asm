INCLUDE macros.asm

DATA SEGMENT
    CHAR_ARR DB 20 DUP(?);array of 20 unassigned variables (chars)
    NUM_ARR DB 20 DUP(?);array of 20 unsassigned variables (numbers)
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA
    
    MAIN PROC FAR
            MOV AX,DATA
            MOV DS,AX
            
           
        START:
            MOV DI,0    ;index register = 0
            MOV BX,0    ;second index register = 0
        NEXT_CHAR:
            INPUT_CHAR  ;get character from standard input
            CMP AL,61   ; AL == "="?, then exit
            JE FINISH
            CMP AL,13   ; AL == "\n"? then print result
            JE PRINT_CAPITALS
            CMP AL,48   ; AL < "0"? then skip
            JB NEXT_CHAR
            CMP AL,122  ; AL > "z"? then skip
            JA NEXT_CHAR
            CMP AL,57   ; AL <= "9"? then save num
            JBE KEEP_NUM
            CMP AL,97   ; AL < "a"? then save char
            JB NEXT_CHAR
        KEEP_CHAR:
            PRINT_CHAR AL
            MOV CHAR_ARR[BX],AL
            INC BX
            JMP CHECK
        KEEP_NUM:
            PRINT_CHAR AL
            MOV NUM_ARR[DI],AL
            INC DI
        CHECK:          ;adding indexes to check if 20 is reached
            MOV AX,DI
            ADD AX,BX
            CMP AX,20
            JB NEXT_CHAR
        PRINT_CAPITALS:
            PRINTLN
            MOV CX,BX
            MOV DI,0
        BLOCK1:         ;loop for all CHAR_ARR and print
            MOV AL,CHAR_ARR[DI]
            SUB AL,32
            PRINT_CHAR AL
            INC DI
            LOOP BLOCK1
        PRINT_NUM:
            PRINT_CHAR "-"
            MOV CX,DI
            MOV DI,0
        BLOCK2:         ;loop for all NUM_ARR and print 
            MOV AL,NUM_ARR[DI]
            PRINT_CHAR AL
            INC DI
            LOOP BLOCK2
            PRINTLN
            PRINTLN
            JMP START
            
        FINISH:
            EXIT
    MAIN ENDP
CODE ENDS
END MAIN

