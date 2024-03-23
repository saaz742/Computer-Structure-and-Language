;baraye barax kardane string az stack estefade  mishavad be in soorat ke agar string mojod bood ebteda hame char ha ra be stack vared mikoninm  
;va dar akhar hame ra pop mikonim va string jadid ra misazim va darhar marhale agar mojod nabood be enteha borde mishvd 

StSeg   Segment STACK 'STACK'
        DB 100H DUP (?)
StSeg   ENDS

DtSeg   Segment
  string    db  26        ;max char morede ghabool
            db  ?         ;raghame vared shode
            db  26 dup(0) ;string vared shode
DtSeg   ENDS

CDSeg   Segment
        ASSUME CS:CDSeg,DS:DtSeg,SS:StSeg
Start:
        MOV AX,DtSeg    ; set DS to point to the data segment
        MOV DS,AX        
        MOV AH, 0Ah             ;gereftane string az vorodi
        MOV DX, offset string
        INT 21h              
        MOV SI, offset buff + 1 ;tedade char hara dar esharegar mirizim
        MOV CL,[SI]          ;tedade char hara be cl(counter) vared miknim
        MOV CH,0               ;ch =0
        INC CX                 ;cx ra afzayesh midahim
        ADD SI,CX              ;cx ra be si ezafe miknim ta be entehaye string eshare bokonad
        MOV AL,'$'             ;al =$
        MOV [SI],AL          ;akharin char ra & miknim            
        MOV SI, OFFSET STRING    ;eshare be ebtedaye string voroodi 
        MOV CX, 0H  
                                  ;tedad char ha ra dar counter mirizad
PUSHSTRING:     
         MOV AX, [SI]             ;addresi k si eshare miknd ra dar ax mirizad
         CMP AL, '$'               ;agar address $ bood be marhale bad miravad (string tamam shode ast) 
         JE FINDFIRST  
                                  
         PUSH [SI]                ;agar be akhari nabood be stack vared miknim
         INC SI                   ;esharegar ra 1 khane be jolo mibarad baraye check kardane baghie string si++
         INC CX                   ;counter ra 1 adad ezafe miknim cx++
         JMP PUSHSTRING  
           
           
FINDFIRST: 
          MOV SI, OFFSET STRING  ;ebtedaye string vorodi dade shode ra peyda miknd
         
         
POPSTRING:         
        CMP CX,0      ;counter ra ba 0 moghayese miknd
        JE FIN        ;age 0 bood az loop kharej mishavad

        POP DX        ;akharin ozv stack ra pop miknd
        XOR DH, DH    ;dh ra 0 miknd  
        MOV [SI], DX  ;akarin chizi k pop(kharej) shode ra b si ezafe miknd  
        INC SI         ;si ++
        DEC CX         ;cx --
        JMP POPSTRING   
          
FIN:       
        MOV [SI],'$'   ;be akhare string $ ezafe miknd
        LEA DX,string  ;load string
        MOV AH, 09H    ;chape string
        INT 21H
        MOV AH,4CH  ; DOS: terminate program
        MOV AL,0    ; return code will be 0
        INT 21H     ; terminate the program
CDSeg   ENDS
END Start