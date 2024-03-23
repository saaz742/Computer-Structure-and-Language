;check kardane olgo mibashad va daghighan manand dastoore soal anjam mishavad 

StSeg   Segment STACK 'STACK'
        DB 100H DUP (?)
StSeg   ENDS

DtSeg   Segment

LIST DB 2000 DUP (?)  
MSGFALSE DB 13,10,"FALSE$"
MSGTRUE DB 13,10,"TRUE $"


DtSeg   ENDS

CDSeg   Segment
        ASSUME CS:CDSeg,DS:DtSeg,SS:StSeg
Start:
        MOV AX,DtSeg             ; set DS to point to the data segment
        MOV DS,AX 
        
        MOV CX,2000              ;tedad dafat 
        MOV SI,OFFSET LIST       ;be ebtedaye list eshare
COMPARE:     
        CMP CX,0                 ;be entehaye list residim payan yabad
        JE EXIT 
        
        MOV AX,[SI]              ;meghdare arraye eshare shode ra dar ax mirizim
        MOV AX,170               ;ahh barabar 170 mibashad
        CMP AX,170               ;meghdar ra ba 170 check mikonim ke aya dorost ast ya kheir
        JE  TRUE
        JNE FALSE

FALSE:  
        LEA DX,MSGFALSE     ;false namayesh va az barname kharej mishavim
        MOV AH,09h
        INT 21h                   
        JMP EXIT            ;terminate program
                             
        
TRUE:  
        LEA DX,MSGTRUE       ;true namayesh va be badi miravim 
        MOV AH,09h
        INT 21h        
        JMP MORE              
                   
MORE: 
      MOV AX,0               ;khali mikonim
      INC SI                 ;eshare be khane bad
      DEC CX                 ;kaheshe tedade dafat
      MOV AX,[SI]            ;khane eshare shode dar ax mirizim
      MOV AX,55h             ;agar ba 55h barabar bood be ebteda bazgahte agar khir false chap va kharej shavad
      CMP AX,55h             
      JNE FALSE
      JE COMPARE
                           
                     
EXIT:   
        MOV AH,4CH              ; DOS: terminate program
        MOV AL,0                ; return code will be 0
        INT 21H                 ; terminate the program
CDSeg   ENDS
END Start