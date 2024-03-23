;fibonacchi F(N+2) = F(N)+ F(N+1)
;manande avali ast ama chon bish az 16 bit (2byte = 2 register) ast
;az 2 register baraye mohasebe estefade mikonim

StSeg   Segment STACK 'STACK'
        DB 100H DUP (?)
StSeg   ENDS

DtSeg   Segment 
    
        FIRST DD 1
        SECOND DD 1
        THIRD DD ?


DtSeg   ENDS

CDSeg   Segment
        ASSUME CS:CDSeg,DS:DtSeg,SS:StSeg
Start:
        MOV AX,DtSeg    ; set DS to point to the data segment
        MOV DS,AX
        
      MOV CX,28         ;28 adad barayw 30 omi jolo miravim
         
FIBO:   
      MOV DX,FIRST         ;adade aval 2byte aval ra dar dx mirizim 
      MOV AX,FIRST+2       ;adade aval 2byte dovom ra dar dx mirizim
      ADD DX,SECOND        ;first += second
      ADC AX,SECOND+2      ;ba carry mohasebe         
      MOV THIRD,DX         ;javab ra dar 3
      MOV THIRD+2,AX      
      MOV DX,SECOND        ;2 ra dar 1 mirizim
      MOV AX,SECOND+2       
      MOV FIRST,DX
      MOV FIRST+2,AX
      MOV DX,THIRD         ;3 3 dar 2 mirizim
      MOV AX,THIRD+2
      MOV SECOND,DX
      MOV SECOND+2,AX
      
      LOOP FIBO            ;edame midahim
    

EXIT:                
        MOV AH,4CH  ; DOS: terminate program
        MOV AL,0    ; return code will be 0
        INT 21H     ; terminate the program
CDSeg   ENDS
END Start



