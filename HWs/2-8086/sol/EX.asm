;file k gharare dar an benevisim sakhte sepas fili k az an mikhainm ra baz va shoro be khandan mikonim
;gar baze charha madnazar ma naboodand haman ra chap agar bozorg boodand koochak va agar kochak boodand bozorg miknonim

StSeg   Segment STACK 'STACK'
        DB 100H DUP (?)
StSeg   ENDS

DtSeg   Segment
    
    CHAR db 0      
    INPUT db "input.txt", 0 
    INHAND dw 0
    OUTPUT db "output.txt", 0
    OUTHAND dw 0
    
    saved_area dw 128 dup(0) 
    
DtSeg   ENDS

CDSeg   Segment
        ASSUME CS:CDSeg,DS:DtSeg,SS:StSeg
Start:
        MOV AX,DtSeg    ; set DS to point to the data segment
        MOV DS,AX
        MOV ES,AX

CREATEOUT:
    MOV CX, 0
    MOV AH, 3CH          ;sakht va baz kardane file baraye khorooji 
    LEA DX, OUTPUT
    INT 21H
    MOV OUTHAND, AX    
    MOV BX, OUTHAND
    MOV AH, 3EH          ;bastane file ijad shode baraye khorooji
    INT 21H     

OPENIN:    
    MOV AL, 0
    LEA DX, INPUT        ;baz kardane file vorodi va gharar dadane neshangar khod
    MOV AH, 3DH
    INT 21H
    MOV INHAND, AX

OPENOUT:    
    MOv AL, 1
    LEA DX, OUTPUT        ;baz kardane file khorooji va gharar dadane neshangar khod
    MOV AH, 3DH
    INT 21H
    MOV OUTHAND, AX

READIN:    
    MOV BX, INHAND
    MOV CX, 1
    LEA DX, CHAR          ;khandane file voroodi
    MOV AH, 3FH
    INT 21H
        
    CMP AX, 0             ;agar character peyda nashod payan
    JE  CLOSE

CHANGECHAR:        
    MOV DL, CHAR             ;agar kode asci kamtaraz a bashad check miknd k capital ast ya kheir
    CMP DL,'a'
    JL ISCAP                 ;agar bshtar bood haman ra chap konad
    CMP DL, 'z'
    JG WRITE

    SUB DL, 32               ;agar bein a va z bood 32 az code an kam conad ba capital bokonad    
    MOV CHAR, DL
    call WRITE               ;meghdar jadid ra benevisad
 
ISCAP:
    CMP DL,'A'               ;agar kamtar az ascii A bood haman ra benevisad
    JL  WRITE
    
    CMP DL,'Z'               ;agar bishtar az Z bood  haman ra benevisad
    JG  WRITE
    
    ADD DL,32                ;agar bein bood yani yek harfe capital ast va ba afzoodan 32 be small tabdil mishavad
    MOV CHAR, DL

WRITE:            
    MOV BX, OUTHAND          ;charhaye jadid ra dar file khoroji minevisad
    MOV CX, 1                   
    LEA DX, CHAR
    MOV AH, 40h
    INT 21H        
    JMP READIN               ;bekhandan edame dahad
    
CLOSE:    
    MOV BX, OUTHAND          ;file khorooji ra mibandad
    MOV AH, 3EH
    INT 21H
       
    MOV BX, INHAND           ;file voroodi a mibandad
    MOV AH, 3EH
    INT 21H 
  
EXIT:
        MOV AH,4CH  ; DOS: terminate program
        MOV AL,0    ; return code will be 0
        INT 21H     ; terminate the program
CDSeg   ENDS
END Start