;adad ra voroodi migirim maghsoom elaih ra khode adad gharar dade va har bar taghsim karde agar taghsim shod ezafe mikonim
;ava sepas harseri az an mikahim ta be 0 beresad

StSeg   Segment STACK 'STACK'
        DB 100H DUP (?)
StSeg   ENDS

DtSeg   Segment
 
NUMBER DW ?
SUM DW ?   
MULTI    DB  10 
YESMSG DB 13,10,"YES $"

DtSeg   ENDS

CDSeg   Segment
        ASSUME CS:CDSeg,DS:DtSeg,SS:StSeg
Start:
        MOV AX,DtSeg    ; set DS to point to the data segment
        MOV DS,AX
INPUT:                   
       MOV AH,1              ;voroodi migirad
       INT 21H
       MOV AH,0              
       
       CMP AL,13             ;payan vorodi grftn(enter)
       JE TONUMBER           ;jump to put number as an input
       
                              
       SUB AX,48             ;code asciibe adad tabdil mishavad
       MOV CX,AX             ;addad ra dar cx migozarad     
       MOV AL,DL             
       MUL MULTI             ;martabe ra dar 10 zarb mikonad t
       MOV DX,AX       
       ADD DX,CX             ;raghame jadid ra be ghabli ezafe mikonad       
       MOV CX,0              ;cx ra 0 mikond     
       JMP INPUT             ;vorodi jadid
       
TONUMBER:       
       PUSH DX           ;dx ra be unvane yek adad darnazar migirim      
       MOV DX,0          ;DX khali miknim
       
       MOV BX,0          ;khali mikonim
       POP BX

    
SETDIV:      
            MOV CX,0
            MOV AX,0               ;khali mikonad            
            MOV NUMBER,BX          ;adad ra dar number va ax mirizad
            MOV AX,NUMBER
            MOV CL,BL              ;khode adad ra dar maghsoom elaih mirizad

SUBMULI:         
            CMP CL,0              ;agar payan yafte bashad maghsoom elaih 0 shavad
            JE CHECK
            
            MOV AX,NUMBER         ;adad ra bar ci k az khod shoro shode taghsim mikonim
            DIV CL          
            CMP AH,0
            JE EQUAL 
            CALL DECDIV
           
EQUAL:                              ;maghsoom va maghsoom elaih barabar nabood jam mikonim
            CMP CL,BL
            JNE ADDSUM
            JE DECDIV
            
ADDSUM:        
           ADD SUM,CX             ;cx maghsoom elaih ast maghsoom elaih ra jam mikonim
           JMP DECDIV    

DECDIV:
            DEC CL
            JMP SUBMULI

CHECK:                               
            MOV AX,0              ;ax ra khali mikonim
            MOV AX,NUMBER         ;ADAD RA DAR AX MIRIZIM
            CMP SUM,AX            ;adad ra ba jam moghayese mikonim
            JE DIVIDABLE          ;barabar bood ghabele taghsim mibashad
            JNE UNDIVIDABLE       ;barabar nabashad sharayet bargharar nemibashad


DIVIDABLE:
          LEA DX,YESMSG     ;payam yes ra namayesh midahad
          MOV AH,09h
          INT 21h
          JMP EXIT
          
UNDIVIDABLE: 
          XOR AX,AX         ;jam ra dar ax mirizad ta namayesh dahad
          MOV AX,SUM
          CALL DISPLAY
          
DISPLAY:  ;chap adad            
    MOV CX,0          ;khali mikonim
    MOV DX,0

PUSHDIGIT:
    CMP AX,0          ;0 bood chap mikonim
    JE  POPDIGIT        
    MOV BX,10         ;baraye ragham peyda kardan adad 10 10e
    DIV BX            ;ragham rast ra peyda mikonim
    PUSH DX           ;raghame bedast amade ra 
    INC CX            ;tedade argham ra afzayesh midahim
    MOV DX,0            ;dx ra 0 mikonim
    JMP PUSHDIGIT     ;ta payan yaftan argham edame midahim 

POPDIGIT:    
     POP DX                ;avalin raghame vared shode ra kharejh miknim
     ADD DX,48             ;chap miknim
     MOV AH,02h            
     INT 21h
     DEC CX                  ;tedade ragham ra kam mikonim
     JNE POPDIGIT            ;ragham baghi moonde bood be aval baz migardim
   
EXIT:
        MOV AH,4CH  ; DOS: terminate program
        MOV AL,0    ; return code will be 0
        INT 21H     ; terminate the program
CDSeg   ENDS
END Start