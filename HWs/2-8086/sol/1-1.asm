;fibonacchi F(N+2) = F(N)+ F(N+1)
;dar inja ba third = second + first
;second = third
;first = second adad ra ta seri 20 bedast miavarim
;chon adadha dar akhar be bish az 8 bit niaz darand bayad az dw estefade konim
;va har khane 2 ta jolotar mibashad

StSeg   Segment STACK 'STACK'
        DB 100H DUP (?)
StSeg   ENDS

DtSeg   Segment 
    
        FIRST DW 1
        SECOND DW 1
        FIBONACCI DW 20 EVEN
        HELP DW 0

DtSeg   ENDS

CDSeg   Segment
        ASSUME CS:CDSeg,DS:DtSeg,SS:StSeg
Start:
        MOV AX,DtSeg    ; set DS to point to the data segment
        MOV DS,AX
        
         
        LEA BX,FIBONACCI   ;ebteda ra bedast miavarim
        MOV [BX],1         ;avalin adad ra vared mikonim
        ADD BX,2           ;2 khane be jolo miravim (16 bit)
        MOV [BX],1         ;dovomin adad seri ra ezafe mikonim
        MOV CX,18          ;conter ra 18 mikonim
         
         
FIBO:   
      MOV DX,FIRST         ;adade aval ra dar dx mirizim
      ADD DX,SECOND        ;first += second
      ADD BX,2             ;2 khane jolo miravim
      MOV AX,SECOND        ; dovomi ra dar avali mirizim
      MOV FIRST,AX
      MOV SECOND,DX        ;jam anha ke sevomi ast ra dar dovomi mirizim
      MOV [BX],DX          ;jam ra zakhire mikonim
      LOOP FIBO            ;edame midahim
    

EXIT:                
        MOV AH,4CH  ; DOS: terminate program
        MOV AL,0    ; return code will be 0
        INT 21H     ; terminate the program
CDSeg   ENDS
END Start



