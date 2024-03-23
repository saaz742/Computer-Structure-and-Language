;size har 2 string ra mohasebe mikonim sepas az olgo peyda kardane string dar string estefade mikonim
;olgo=> 2 for to dar to avali be andaze toole string bozorg va for badi beandaze tafrigh ando ast va dar an barabari char ha check mishavad 


StSeg   Segment STACK 'STACK'
        DB 100H DUP (?)
StSeg   ENDS

DtSeg   Segment
 STRING   db  26       
          db  ?        
          db  26 dup(0)
    SUBSTRING DB 'ea$'
    LENSTR DB 0
    LENSUB DB 0

    NOMSG DB 'NO$'
    YESMSG DB 'YES$'
DtSeg   ENDS
         
          
      DISPLAY MACRO MSG  ;chap string
      MOV AH,9
      LEA DX,MSG
      INT 21H
      ENDM      
               
CDSeg   Segment
        ASSUME CS:CDSeg,DS:DtSeg,SS:StSeg
Start:
        MOV AX,DtSeg    ; set DS to point to the data segment
        MOV DS,AX
        
           
    MOV AH, 0Ah             ;voroodi migirad
    MOV DX, offset STRING
    INT 21h

    
    LEA SI,STRING         ;vorodi ra ba neshangar load mikne
    
    
FINDSTRLEN:                 ;peyda kardane tool string
    CMP [SI],'$'       ;pointer si ra ba alamate akhare string moghayese miknim    
    JE FINDFIRST       ;age sefr bood(yeki boodn) be FINDFIRST miparim
    
    INC LENSTR         ;LENSTR++  toole string ra afzayesh midahad
    INC SI             ;harfe badi
    JMP FINDSTRLEN           
    
    
FINDFIRST:
    LEA DI,SUBSTRING      ;ebtedaye substr ra peyda va dar di mirize
    
    
FINDSUBLEN:                 
    CMP [DI],'$'        ;neshangare di ro ba akhare str moghayese mikonad ke akhar ast ya kheir
    JE LEN              ;yeki bood marhalebad mir
    
    INC LENSUB          ;lensub++ toole substring ra afzayesh midahad
    INC DI
    JMP FINDSUBLEN
   
   
LEN:
    LEA SI,STRING        ;string load
    MOV AL,LENSTR        ;al += lenstr
    SUB AL,LENSUB        ;al -= lensub
    MOV CL,AL            ;baraye for lenstr-lensubstr ra dar counter mirizad
    MOV CH,0
   
   
FIRST:                   ;for baraye moghayese barabari
    MOV AL,[SI]          
    CMP AL,SUBSTRING[0]  ;char ba avalin harfe sub moghayese mishavad
    JE CMPR              ;barabar bood baraye baghie horof be badi miravad
    INC SI               ;nabood edame midahad
    LOOP FIRST
    CALL NOTEQUAL        ;ba hich kodam barabar nabood be notequal miravad
   
   
CMPR: 
    INC SI                ;neshangar ra afzayesh midahad
    MOV AL,[SI]           ;meghdar ra dar al mirizad
    CMP AL,SUBSTRING[1]   ;harfe dovom ham moghayese mikonad
    JZ EQUAL              ;0 bood barabar ast va be equal miravad
    CALL  NOTEQUAL        ;nabood be notequal miravad
  
NOTEQUAL:
    DISPLAY NOMSG         ;msg no ra namayesh midahad
    JMP EXIT
   

EQUAL: 
    DISPLAY YESMSG        ;masage yes ra namayesh midahad
    JMP EXIT
   
   
EXIT:
        MOV AH,4CH  ; DOS: terminate program
        MOV AL,0    ; return code will be 0
        INT 21H     ; terminate the program
CDSeg   ENDS
END Start