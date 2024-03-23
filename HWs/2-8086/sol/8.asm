;2 adad ra az vorodi khande bozorgtar va kochek tar ra bedast avarde 
;sepas ba estefade az algorithm paein mohasebe mikonim

StSeg   Segment STACK 'STACK'
        DB 100H DUP (?)
StSeg   ENDS

DtSeg   Segment
       
        HIGH DW ?
        LOW DW ?
        DIGITNUMBER DW 0 
        COUNTER DB 2 
        

        MULTI    DB  10    
        HELPER DW 0
       

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
       DEC COUNTER       ;decrement number of inputs
       JNZ INPUT         ;adade dovom ra migirad
       
       MOV BX,0          ;khali mikonim
       MOV DX,0          ;adadha dar bx va dx hastand
       POP BX
       POP DX       
       CMP DX,BX         ;adade bozorgtar ra peyda mikonad do addad dar bx va dx hastand
       JNS CHANGE
       JMP SET 
        
CHANGE:                   ;jaye 2 moteghayer ra taghir midahim
      MOV HELPER,DX
      MOV DX,0
      MOV DX,BX
      MOV BX,0
      MOV BX,HELPER
      JMP SET                
       
SET:       
      MOV CX,BX            ;adad bozorgtar ra dar cx mirizim
      MOV HIGH,BX          ;adad bozorgtar ra dar moteghayer high mirizim
      MOV LOW,DX           ;adad bozorgtar ra dar moteghyer low mirizim

;while (a!= 0)
; if(max%high)             
;  lcm = max             
; max +=high

            
WHILE:             
      MOV DX,0                ;DX khali baraye baghimande     
      MOV AX,CX               ;ax = max
      DIV WORD PTR LOW        ;max % low
      CMP DX,0                ;agar baghimande 0 bood
      JE LCM              
      
      ADD CX,WORD PTR HIGH    ;MAX += HIGH
      JMP WHILE                           
                           
LCM:                    
     MOV AX,CX             ;lcm =max
     MOV DX,0
     DIV WORD PTR MULTI    ;lcm %10
     PUSH DX               ;ragham ra vared mikonad
     INC DIGITNUMBER       ;tedad argham ra ziad mikonad
     CMP AX,0              ;age argham 0 bood
     JE OUTPUT             ;print bokonad
     
     MOV CX,AX             ;adad ra dar counter mizarad ta dobare anjam shavad
     JMP LCM           
     

OUTPUT:
     POP DX                ;avalin raghame vared shode ra kharejh miknim
     ADD DX,48             ;chap miknim
     MOV AH,02h            
     INT 21h
     DEC DIGITNUMBER       ;tedade ragham ra kam mikonim
     JNE OUTPUT            ;ragham baghi moonde bood be aval baz migardim
     

EXIT:
        MOV AH,4CH  ; DOS: terminate program
        MOV AL,0    ; return code will be 0
        INT 21H     ; terminate the program
CDSeg   ENDS
END Start