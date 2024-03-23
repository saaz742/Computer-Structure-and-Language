;dar in barname darvaghe adade aval ra ba loop be tedade aval jam mikonim
;chon adad sahih hastand bayad manfi boodn niz check shavad va agar manfi
;bashand mosbat shavand

StSeg   Segment STACK 'STACK'
        DB 100H DUP (?)
StSeg   ENDS

DtSeg   Segment 
    
        FIRST DW -100
        SECOND DW -2
        THIRD DW 0
        BOOLEAN DB 0 
        
DtSeg   ENDS

CDSeg   Segment
        ASSUME CS:CDSeg,DS:DtSeg,SS:StSeg
Start:
        MOV AX,DtSeg    ; set DS to point to the data segment
        MOV DS,AX        
        
        MOV AX,FIRST            ;adade aval ra dar AX mirizad
        MOV CX,SECOND           ;adade dovom ra dar counter mirizad ta mohasebe konad 
        CMP SECOND,0            ;check mishavad adad agar adadae 2 0 bood 
        JE  EXIT                ;agar 0 bood kharej shavad 
        JL  POSITIVE            ;agar manfi bood be tabe bere
    
    
MULTIPLICATION:
     ADD THIRD,AX            ;adade aval ra ke dar AX hast be andaze dovomi loop mizanim
     LOOP MULTIPLICATION 
     CALL CHECK          
       

POSITIVE:
     MOV BOOLEAN,1           ;chon manfi ast namade manfi ra midahim
     NOT CX                  ;CX ke adade dovom dar an ast chon manfi ast mosbat miknim
     ADD CX,1                ;chon taghir alamat midahad ba 1 jam mishavad 
     CALL  MULTIPLICATION         

CHECK: 
     CMP BOOLEAN,0           ;agar 0 bood mosbat ast
     JE EXIT                 ;agar 0 bood yani manfi nist va barname tamam mishavad    
     NOT THIRD               ;natije ra chon manfi ast mosbat mikonad
     ADD THIRD,1  
    
        
EXIT:      
        MOV AH,4CH  ; DOS: terminate program
        MOV AL,0    ; return code will be 0
        INT 21H     ; terminate the program
CDSeg   ENDS
END Start