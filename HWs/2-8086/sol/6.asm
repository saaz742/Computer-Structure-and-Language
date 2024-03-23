
StSeg   Segment STACK 'STACK'
        DB 100H DUP (?)
StSeg   ENDS

DtSeg   Segment
 
NUMBER DW 32768
RESULT DW  32768
ZERO   DW  0
RESULT2 DW 0
YESMSG DB 13,10,"-$",
DtSeg   ENDS
          
CDSeg   Segment
        ASSUME CS:CDSeg,DS:DtSeg,SS:StSeg
Start:
        MOV AX,DtSeg    ; set DS to point to the data segment
        MOV DS,AX
        
        
       

DECR: 
      MOV BX,RESULT  
      MOV CX,RESULT
      CMP CX,0
      JE TOINCR
      
      DEC BX
      MOV RESULT,BX
      DEC CX
      MOV AX,RESULT
      CALL OUTDEC
      CALL NEWLINE
      LOOP DECR

TOINCR:
     MOV BX,NUMBER
     MOV RESULT,BX
     MOV AX,ZERO
     CALL OUTDEC
     ;CALL NEWLINE
     MOV BX,RESULT2


INCR:
    MOV CX,RESULT
    CMP CX,0
    JE EXIT
    
    INC BX
    MOV RESULT2,BX
    DEC CX
    MOV RESULT,CX
    MOV AX,RESULT2 
    CALL LINE
    CALL OUTDEC
    ;CALL NEWLINE
    LOOP INCR
    JMP EXIT

OUTDEC PROC
  PUSH BX                        
  PUSH CX                        
  PUSH DX                        

  CMP AX, 0                      
  JGE START1                     

  MOV DL, "-"                    
  CALL BYTE

  NEG AX                         

START1:                        
    XOR CX, CX                     
    MOV BX, 10                     

OUTPUT:                       
    XOR DX, DX                   
    DIV BX                       
    PUSH DX                     
    INC CX                       
    OR AX, AX                    
    JNE OUTPUT                   

  MOV AH, 2                    

DISPLAY:                      
    POP DX                       
    OR DL, 30H                   
    INT 21H                      
    LOOP DISPLAY                 

  POP DX                         
  POP CX                         
  POP BX                         

  RET                           
OUTDEC ENDP


BYTE proc
  PUSH AX
  MOV AH,2
  INT 21h
  POP AX    
  RET
BYTE endp


NEWLINE proc
    PUSH AX
    PUSH DX
    MOV AH,2
    MOV DL,0AH
    INT 21h   
    MOV DL,0DH
    INT 21h 

    POP DX
    POP AX
    RET
NEWLINE endp

LINE proc
    PUSH AX
    PUSH DX 
   LEA DX,YESMSG  ;load string
        MOV AH, 09H    ;chape string
        INT 21H
    POP DX
    POP AX
    RET
LINE endp 

EXIT:
        MOV AH,4CH  ; DOS: terminate program
        MOV AL,0    ; return code will be 0
        INT 21H     ; terminate the program
CDSeg   ENDS
END Start