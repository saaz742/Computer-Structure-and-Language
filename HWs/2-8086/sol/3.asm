;dar inja yek adade bcd 6 raghami darim ke bayad besoorat 10 10 dar ayad 
;argham ra joda karde va ba formul tabdil va chap mikonim 

StSeg   Segment STACK 'STACK'
        DB 100H DUP (?)
StSeg   ENDS

DtSeg   Segment
     
        BCDNUM DW 0AFBFH
        LENGTH DB 0

DtSeg   ENDS

CDSeg   Segment
        ASSUME CS:CDSeg,DS:DtSeg,SS:StSeg
Start:
        MOV AX,DtSeg    ; set DS to point to the data segment
        MOV DS,AX
        
    MOV AX,BCDNUM
    MOV BX,000Ah

DIGIT:
    INC LENGTH       ;afzayesh shomarande tool
    DIV BX           ;jodasaz ragham
    PUSH DX          ;push ragham
    CMP AX,0         ;adad ba sefr moghayese
    MOV DX,00h
    JE FIN
    JMP DIGIT

FIN:
    MOV CL,LENGTH    ;tool ra vared mikonim
    MOV CH,00h
   
OUTPUT:
    POP DX          ;kharej kardan
    ADD DL,30h      ;tabdil va chap
    MOV AH,02h
    INT 21h
    LOOP OUTPUT

EXIT:
        MOV AH,4CH  ; DOS: terminate program
        MOV AL,0    ; return code will be 0
        INT 21H     ; terminate the program
CDSeg   ENDS
END Start