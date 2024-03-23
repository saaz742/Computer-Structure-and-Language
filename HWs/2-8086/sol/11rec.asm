;n ra voroodi migirim va az binary search bazgahti estefade mikonim    
;be in soorat k har seri vasat arraye ra entekhab va samte chap o rast ra joda va baresi miknim
;be sooart bazgahti enghad edame miabad ta yeki baghi bemanad

StSeg   Segment STACK 'STACK'
        DB 100H DUP (?)
StSeg   ENDS

DtSeg   Segment
        LIST DW 1,2,3,5,233
        FIRST DW 0
        LAST DW 9 
        MID DW ?
        TWO DW 2
        LENGTH DW 5
        N DW 0
        POSITON DW -1
 
DtSeg   ENDS

CDSeg   Segment
        ASSUME CS:CDSeg,DS:DtSeg,SS:StSeg
Start:
        MOV AX,DtSeg    ; set DS to point to the data segment
        MOV DS,AX
        
        CALL INDEC          ;voroodi
        MOV N,AX         
        CALL SEARCH         ;search
        CMP POSITON,0       ;agar nabood -1 chap konim
        JL  NOTFOUND       

FIN:     
     MOV DX,POSITON         ;makan ra chap
     ADD DX,48
     MOV AH,2
     INT 21H
     CALL TERM


NOTFOUND:
     MOV DX,'-'         ;chape string -1
     MOV AH,2
     INT 21H
     MOV DX,1
     ADD DX,48
     MOV AH,2
     INT 21H
     CALL TERM
                          

INDEC PROC
  PUSH BX                    ;cl tool    
  PUSH CX                    ;ch alamat                                        
  XOR DL, DL                   
  JMP READ                      
                        
READ:                   
    MOV bx,0                  ;khali   
    MOV CX,0                     
    MOV DX,0                     

    CALL INBYTE                       

    CMP AL, "-"               ;manfi
    JE MINUS                      

    CMP AL, "+"               ;mosbat
    JE PLUS                       

    JMP SKIP               

MINUS:                        
    MOV CH, 1                  ;baraye alamat 1 darnazar migirm   
    INC CL                     ;toole adad ra afzayesh midahim    
    JMP INPUT                     

PLUS:                         
    MOV CH, 2                  ;alamate mosbat ra 2 mizarim    
    INC CL                         

INPUT:                        
    CALL INBYTE                     

SKIP:                 

CON:  
      CMP AL, ' '                  ;khali
      JE ENDINPUT                

      CMP AL, 10                  ;\n
      JE ENDINPUT                

      CMP AL, 13                  ;\r
      JNE NOPRINTLINE

PRINTLINE :
    JMP ENDINPUT                

NOPRINTLINE:
    CMP AL, 08H                   ; compare AL with 8H
    JNE BACKSPACE                           

    CMP CH, 0                    
    JNE CHECKMINUS      

    CMP CL, 0                             
    JMP BACK               

CHECKMINUS:         
    CMP CH, 1                    
    JNE CHECKPLUS       

    CMP CL, 1                    
    JE REMOVESIGN        

CHECKPLUS:          
    CMP CL, 1                    
    JE REMOVESIGN        
    JMP BACK               

REMOVESIGN:             ;hazfe alamate + o-
    CALL REMOVECHAR                  
    JMP READ                  

BACK:                  
    MOV AX, BX                   
    MOV BX, 10                   
    DIV BX                       ; AX=AX/BX
    MOV BX, AX                   
    CALL REMOVECHAR                    
    DEC CL                       
    JMP INPUT                   

BACKSPACE:              
    INC CL                       
    CMP AL, '0'                  
    JL ERROR                    
    CMP AL, '9'                  
    JG ERROR                    

    AND AX, 000FH                ;asci be decimal                                 
    PUSH AX                      
    MOV AX, 10                   
    MUL BX                       ; AX=AX*BX
    MOV BX, AX                   
    POP AX                       
    ADD BX, AX                   
    JMP INPUT                     

ERROR:                        
    MOV DL,AL                     ;gheire ragham
    JMP EXIT

ENDINPUT:                          
    MOV DL,CL                      ;manfi mikonim voroodi ra
    NEG DL
    CMP CH, 1                      ;age manfi kharej
    JNE EXIT                      
    NEG BX                         ;nabood manfi

EXIT:                         
    MOV AX, BX                                              
    POP CX                         
    POP BX                         
  RET                            
INDEC ENDP



INBYTE proc
    MOV AH,1             ;byte voroodi
    INT 21h               
    RET
INBYTE endp


REMOVECHAR proc
  PUSH AX
  PUSH DX
  MOV AH, 2                    
  MOV DL, ' '                  ;DL=\' \'
  INT 21H                      

  MOV DL, 8H                   
  INT 21H 

  POP DX
  POP AX         
  RET            
REMOVECHAR endp

      
SEARCH  PROC 
    
      PUSHF          
              
        MOV DX,LAST     ;agar bozorg az kochak bozorgtar shavad be payan residim
        CMP FIRST,DX
        JG  AGAIN
              
        MOV DX,0              
        LEA BX,LIST    ;ebtedaye array ra mirizim                
        MOV DX,0
        MOV AX,LAST    ;mid=(last-first)/2
        SUB AX,FIRST
        DIV TWO
        ADD AX,FIRST   ;mid +=first
        MUL TWO        ;mid*2
        MOV MID,AX              
        ADD BX,MID     ;be vasate arraye boro                             
        MOV AX,MID     ;mid%2
        MOV DX,0
        DIV TWO
        MOV MID,AX                 
        MOV DX,N  
        MOV AX,[BX]    ;lis[mid]?n
        CMP [BX],DX
        JL AFMID      ;list[mid] <n
        JE POS        ;list[mid] = n
        JG BEMID     ;list[mid]>n
                           
 
BEMID:          
       DEC MID             ;binary search dar nesfe aval
       MOV DX,MID
       MOV LAST,DX
       CALL SEARCH
       JMP AGAIN             
              
AFMID:   
       INC MID            ;binary search nesfe dovom 
       MOV DX,MID
       MOV FIRST,DX
       CALL SEARCH
       JMP AGAIN          ;baghie tikeha
                          
POS: 
       MOV DX,MID           ;mid darvaghe meghdar pointer ast
       MOV POSITON,DX
       JMP AGAIN  
              
AGAIN:          
                POPF         
                ret
SEARCH    endp                  

TERM:
        MOV AH,4CH  ; DOS: terminate program
        MOV AL,0    ; return code will be 0
        INT 21H     ; terminate the program
CDSeg   ENDS
END Start