;dar in barname har char ra az voroodi migirim va dar stack mirizim
;va pas az payan az stack kharej karde dar 10^n zarb va ba ghablo jam
;mikonim ta voroodi be soorate adad shenakhte shavad 

StSeg   Segment STACK 'STACK'
        DB 100H DUP (?)
StSeg   ENDS

DtSeg   Segment
        
        STRING DW 0 
        LENGTH DB 0 
        POWER DB 10
        MULTI DB 1              
        

DtSeg   ENDS

CDSeg   Segment
        ASSUME CS:CDSeg,DS:DtSeg,SS:StSeg
Start:
        MOV AX,DtSeg    ; set DS to point to the data segment
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

      POP DX        ;balatarin char ra dar miavarad
      SUB DX,48     ;tabdil be ragham mikonad     
      MOV AX,DX     
      MUL MULTI      ;martabe ra zarb mikonad ta bedast ayad
      MOV DX,AX         
      ADD STRING,DX ;adad jadid ra ba ghabli jam mikonad     
      MOV AH,0      
      MOV AL,MULTI   ;martabe ra dar al mirizad va        
      MUL POWER
      MOV MULTI,AL      
      DEC LENGTH            ;toole string ra kam mikonad
      
      CMP LENGTH,1          ;agar akhari bood
      JA  TONUMBER          ;toole reshte bishtar bashad
      JB  EXIT              ;0 bahshad va tamam shode bashad
      
LASTCHAR:                              
     POP DX                   ;akhari (chaptarin) ra kharej mikonad ta baresi konad
     CMP DX,'-'                ;agar alamate - bood edame
     JNE PUSHLAST             ;agar nabood  push
     
     NOT STRING               ;chon adad manfi ast az nazar arzesh niz manfi mikonim
     ADD STRING,1             ;alamate manfi niz ezafe mikonim
     PUSH DX
     CALL EXIT

PUSHLAST: 
      SUB DX,48     ;tabdil be ragham mikonad     
      MOV AX,DX     
      MUL MULTI      ;martabe ra zarb mikonad ta bedast ayad
      MOV DX,AX         
      ADD STRING,DX ;adad jadid ra ba ghabli jam mikonad     
      MOV AH,0      
      MOV AL,MULTI   ;martabe ra dar al mirizad       
      MUL POWER
      MOV MULTI,AL
      PUSH DX      ;akhari ra push mikonad      

EXIT:    
        LEA DX,STRING
        MOV AH, 09H    ;chape string
        INT 21H 
     
        MOV AH,4CH  ; DOS: terminate program
        MOV AL,0    ; return code will be 0
        INT 21H     ; terminate the program
CDSeg   ENDS
END Start