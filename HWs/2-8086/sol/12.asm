;adad ra az vorodi gerefte va sepas ba haman algorithm fibonnachi dade shode 
;ba taghirate andak bazgashtie morede nazar ra bedast miavarim

StSeg   Segment STACK 'STACK'
        DB 100H DUP (?)
StSeg   ENDS

DtSeg   Segment
        N  DW 0        
        LENGTH DB 0  
        POWER DB 10
        MULTI DB 1                                        
        FINAL DW ?
        NEGMSG DB 13,10,"NEGATIVE$"                                        
        EMPTYMSG     DB 13,10,"ZERO$"
        
      
DtSeg   ENDS

CDSeg   Segment
        ASSUME CS:CDSeg,DS:DtSeg,SS:StSeg
Start:
        MOV AX,DtSeg                               ;set DS to point to the data segment
        MOV DS,AX
        
INPUT:    
        MOV AH,1                     ;voroodi begirad
        INT 21H
        MOV AH,0                  
        CMP AL,13                    ;check krdn payan vorodi(vared kardane enter)
        JE TONUMBER                  ;tabdil be adad                
                           
 
        PUSH AX                      ;char ra ezafe mikonad
        INC LENGTH                   ;n++ toole string ziad mishavad
        JMP INPUT
                                     ;dobare check mishavad
               
TONUMBER:
      CMP LENGTH,0
      JE EXIT 

      POP DX             ;balatarin char ra dar miavarad
      SUB DX,48          ;tabdil be ragham mikonad     
      MOV AX,DX      
      MUL MULTI          ;martabe ra zarb mikonad ta bedast ayad
      MOV DX,AX         
      ADD N,DX           ;adad jadid ra ba ghabli jam mikonad     
      MOV AH,0      
      MOV AL,MULTI       ;martabe ra dar al mirizad va        
      MUL POWER
      MOV MULTI,AL      
      DEC LENGTH            ;toole string ra kam mikonad
      
      CMP LENGTH,1          ;agar akhari bood
      JA  TONUMBER          ;toole reshte bishtar bashad
      JB  CAL               
      
LASTCHAR:                              
     POP DX                   ;akhari (chaptarin) ra kharej mikonad ta baresi konad
     CMP DX,'-'                ;agar alamate - bood edame
     JNE PUSHLAST             ;agar nabood  push
     
     JMP NEGATIVE

PUSHLAST: 
      SUB DX,48          ;tabdil be ragham mikonad     
      MOV AX,DX     
      MUL MULTI         ;martabe ra zarb mikonad ta bedast ayad
      MOV DX,AX         
      ADD N,DX          ;adad jadid ra ba ghabli jam mikonad     
      MOV AH,0      
      MOV AL,MULTI      ;martabe ra dar al mirizad       
      MUL POWER
      MOV MULTI,AL
      PUSH DX            ;akhari ra push mikonad
     

CAL: 
      MOV DX,N                   
      CMP DX,0
      JE ZERO     
     
      XOR CX,CX         ;khali
      MOV CX,N          ;tedad loop
      CALL RECURSIVE             
      MOV FINAL,DX      ;JAVAB 
      CALL EXIT

 
        
RECURSIVE PROC                           
        PUSHF
        
        PUSH AX                       ;zakhire
        PUSH BX        
        MOV DX,2                      ;meghdare avali ra zakhire
        CMP CX,1 
        JLE AGAIN                     ;return adar kamtar az 1 bood
        
        MOV DX,3                      ;adade badi vared mishavad
        CMP CX,2 
        JE AGAIN                      ;returnager 2 bood
        
        MOV BX,CX                     ;save cx
        DEC CX                        ;call f(num-1)
        CALL RECURSIVE                
        
        MOV AX,DX                     ; AH=f(num-1)
        MOV CX,2                      ;move 2 to CX
        MUL CX                        ;AX=2*f(num-1)
        MOV CX,BX                     ;CL=n
        DEC CX                        ;CX--
        DEC CX                        ;CX--
        CALL RECURSIVE                    ;call f(num-2)
       
        NEG DX                        ;f(num-2)
        ADD DX,AX                     ;DX=2*f(num-1)-f(num-2)
        MOV CX,BX                     ;cx = n

AGAIN:
        POP BX
        POP AX
        POPF
        RET

RECURSIVE ENDP            
  
            
ZERO:  
        LEA DX,EMPTYMSG            
        MOV AH,09h
        INT 21h
        JMP EXIT                   
            
NEGATIVE: 
        LEA DX,NEGMSG      
        MOV AH,09h
        INT 21h
        JMP EXIT   
   
EXIT:   
      MOV AH,4CH                     ;DOS: terminate program
      MOV AL,0                       ;return code will be 0    
      INT 21H                        ;terminate the program  
          
CDSeg   ENDS
END Start

        
        
        
        