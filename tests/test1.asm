.MODEL      TINY

B_SEG       SEGMENT

ORG         100h
ASSUME      DS:B_SEG, CS:B_SEG, SS:B_SEG

START:
    MY_UNKNOWN db "a"

    CALL MY_LABEL2
    JMP MY_LABEL2

    MOV AX, a
    MOV AL, b
    MOV a, AX
    MOV b, AL
    MOV AL, 15h
    MOV AH, 6h
    MOV CL, 2h
    MOV DH, 8h
    MOV BX, 1234h
    MOV SI, 3122h
    MOV SP, 4222h
    MOV BP, 1111h
    MOV CX, [BX]
    MOV DX, [BX+78h]
    MOV BX, [BX+3456h]
    MOV SI, [BX+SI]
    MOV DI, [BX+SI+1h]
    MOV BP, [BX+SI+3891h]
    MOV SI, [BX+DI]
    MOV SP, [SI]
    MOV BP, [BP+DI+2131h]
    MOV [SI], AX
    MOV [BX], CX
    MOV [BX+111h], BX
    MOV [BX+12h], DX
    MOV [BX+SI+22h], SP
    MOV [BX+SI+00h], DI
    MOV [BX+DI+2212h], DI
    MOV [SI+2h], CX
    MOV AL, [DI]
    MOV AH, [DI+1h]
    MOV BH, [DI+1111h]
    MOV CL, [BP+00h]
    MOV BL, [BP+3456h]
    MOV CH, [BP+SI]
    MOV [BP+SI+123h], AL
    MOV [BP+SI+22h], AH
    MOV [BP+SI], BL
    MOV [BP+2222h], BH
    MOV [BP+12h], CL
    MOV [BP+0000h], CH
    MOV [DI+22h], DH
    MOV [DI+1232h], DL
    MOV BYTE PTR [DI+18h], 22h 
    MOV BYTE PTR [DI+2222h], 11h
    MOV BYTE PTR [BX+12h], 11h
    MOV BYTE PTR [SI], 11h
    MOV WORD PTR [BP+3456h], 1234h
    MOV WORD PTR [BP+SI], 1231h
    MOV WORD PTR [BP+SI+45h], 3213h
    MOV WORD PTR [BP+SI+2222h], 1231h
    MOV WORD PTR [BX+SI], ES
    MOV WORD PTR [DI+7h], CS
    MOV WORD PTR [DI], SS
    MOV WORD PTR [BX+2222h], DS
    MOV ES, WORD PTR [BX+SI]
    MOV SS, WORD PTR [BX]
    MOV DS, WORD PTR [BX+SI+70h]
    MOV AL, BYTE PTR ES:[DI+70h]
    MOV BL, BYTE PTR ES:[DI+2000h]
    MOV CL, BYTE PTR SS:[DI+70h]
    MOV CL, BYTE PTR CS:[DI+70h]
    MOV DX, WORD PTR DS:[DI+70h]
    MOV BYTE PTR ES:[DI+70h], al
    MOV BYTE PTR SS:[DI+2000h], bl
    MOV WORD PTR DS:[DI+70h], dx


    ADD AX, a
    ADD AL, b
    ADD a, AX
    ADD b, AL
    ADD AL, 15h
    ADD AH, 6h
    ADD CL, 2h
    ADD DH, 8h
    ADD BX, 1234h
    ADD SI, 3122h
    ADD SP, 4222h
    ADD BP, 1111h
    ADD CX, [BX]
    ADD DX, [BX+78]
    ADD BX, [BX+3456h]
    ADD SI, [BX+SI]
    ADD DI, [BX+SI+1h]
    ADD BP, [BX+SI+3891h]
    ADD SI, [BX+DI]
    ADD SP, [SI]
    ADD BP, [BP+DI+2131h]
    ADD [SI], AX
    ADD [BX], CX
    ADD [BX+111h], BX
    ADD [BX+12h], DX
    ADD [BX+SI+22h], SP
    ADD [BX+SI+00h], DI
    ADD [BX+DI+2212h], DI
    ADD [SI+2h], CX
    ADD AL, [DI]
    ADD AH, [DI+1h]
    ADD BH, [DI+1111h]
    ADD CL, [BP+00h]
    ADD BL, [BP+3456h]
    ADD CH, [BP+SI]
    ADD [BP+SI+123h], AL
    ADD [BP+SI+22h], AH
    ADD [BP+SI], BL
    ADD [BP+2222h], BH
    ADD [BP+12h], CL
    ADD [BP+0000h], CH
    ADD [DI+22h], DH
    ADD [DI+1232h], DL
    ADD AL, BYTE PTR ES:[DI+70h]
    ADD BL, BYTE PTR ES:[DI+2000h]
    ADD CL, BYTE PTR SS:[DI+70h]
    ADD CL, BYTE PTR CS:[DI+70h]
    ADD DX, WORD PTR DS:[DI+70h]
    ADD BYTE PTR ES:[DI+70h], al
    ADD BYTE PTR SS:[DI+2000h], bl
    ADD BYTE PTR [DI+18h], 22h 
    ADD BYTE PTR [DI+2222h], 11h
    ADD BYTE PTR [BX+12h], 11h
    ADD BYTE PTR [SI], 11h
    ADD WORD PTR [BP+3456h], 1234h
    ADD WORD PTR [BP+SI], 1231h
    ADD WORD PTR [BP+SI+42h], 3213h
    ADD WORD PTR [BP+SI+2222h], 1231h

    SBB AX, a
    SBB AL, b
    SBB a, AX
    SBB b, AL
    SBB AL, 15h
    SBB AH, 6h
    SBB CL, 2h
    SBB DH, 8h
    SBB BX, 1234h
    SBB SI, 3122h
    SBB SP, 4222h
    SBB BP, 1111h
    SBB CX, [BX]
    SBB DX, [BX+78h]
    SBB BX, [BX+3245h]
    SBB SI, [BX+SI]
    SBB DI, [BX+SI+1h]
    SBB BP, [BX+SI+3891h]
    SBB SI, [BX+DI]
    SBB SP, [SI]
    SBB BP, [BP+DI+2131h]
    SBB [SI], AX
    SBB [BX], CX
    SBB [BX+111h], BX
    SBB [BX+12h], DX
    SBB [BX+SI+22h], SP
    SBB [BX+SI+00h], DI
    SBB [BX+DI+2212h], DI
    SBB [SI+2h], CX
    SBB AL, [DI]
    SBB AH, [DI+1h]
    SBB BH, [DI+1111h]
    SBB CL, [BP+00h]
    SBB BL, [BP+3456h]
    SBB CH, [BP+SI]
    SBB [BP+SI+123h], AL
    SBB [BP+SI+22h], AH
    SBB [BP+SI], BL
    SBB [BP+2222h], BH
    SBB [BP+12h], CL
    SBB [BP+0000h], CH
    SBB [DI+22h], DH
    SBB [DI+1232h], DL
    SBB AL, BYTE PTR ES:[DI+70h]
    SBB BL, BYTE PTR ES:[DI+2000h]
    SBB CL, BYTE PTR SS:[DI+70h]
    SBB CL, BYTE PTR CS:[DI+70h]
    SBB DX, WORD PTR DS:[DI+70h]
    SBB BYTE PTR ES:[DI+70h], al
    SBB BYTE PTR SS:[DI+2000h], bl
    SBB BYTE PTR [DI+18h], 22h 
    SBB BYTE PTR [DI+2222h], 11h
    SBB BYTE PTR [BX+12h], 11h
    SBB BYTE PTR [SI], 11h
    SBB WORD PTR [BP+3456h], 1234h
    SBB WORD PTR [BP+SI], 1231h
    SBB WORD PTR [BP+SI+45h], 3213h
    SBB WORD PTR [BP+SI+5678h], 1231h
    
    ADC AX, a
    ADC AL, b
    ADC a, AX
    ADC b, AL
    ADC AL, 15h
    ADC AH, 6h
    ADC CL, 2h
    ADC DH, 8h
    ADC BX, 1234h
    ADC SI, 3122h
    ADC SP, 4222h
    ADC BP, 1111h
    ADC CX, [BX]
    ADC DX, [BX+78h]
    ADC BX, [BX+3456h]
    ADC SI, [BX+SI]
    ADC DI, [BX+SI+1h]
    ADC BP, [BX+SI+3891h]
    ADC SI, [BX+DI]
    ADC SP, [SI]
    ADC BP, [BP+DI+2131h]
    ADC [SI], AX
    ADC [BX], CX
    ADC [BX+111h], BX
    ADC [BX+12h], DX
    ADC [BX+SI+22h], SP
    ADC [BX+SI+00h], DI
    ADC [BX+DI+2212h], DI
    ADC [SI+2h], CX
    ADC AL, [DI]
    ADC AH, [DI+1h]
    ADC BH, [DI+1111h]
    ADC CL, [BP+00h]
    ADC BL, [BP+3456h]
    ADC CH, [BP+SI]
    ADC [BP+SI+123h], AL
    ADC [BP+SI+22h], AH
    ADC [BP+SI], BL
    ADC [BP+2222h], BH
    ADC [BP+12h], CL
    ADC [BP+0000h], CH
    ADC [DI+22h], DH
    ADC [DI+1232h], DL
    ADc AL, BYTE PTR ES:[DI+70h]
    ADC BL, BYTE PTR ES:[DI+2000h]
    ADC CL, BYTE PTR SS:[DI+70h]
    ADC CL, BYTE PTR CS:[DI+70h]
    ADC DX, WORD PTR DS:[DI+70h]
    ADC BYTE PTR ES:[DI+70h], al
    ADC BYTE PTR SS:[DI+2000h], bl
    ADC BYTE PTR [DI+18h], 22h 
    ADC BYTE PTR [DI+2222h], 11h
    ADC BYTE PTR [BX+12h], 11h
    ADC BYTE PTR [SI], 11h
    ADC WORD PTR [BP+3456h], 1234h
    ADC WORD PTR [BP+SI], 1231h
    ADC WORD PTR [BP+SI+45h], 3213h
    ADC WORD PTR [BP+SI+5678h], 1231h

    SUB AX, a
    SUB AL, b
    SUB a, AX
    SUB b, AL
    SUB AL, 15h
    SUB AH, 6h
    SUB CL, 2h
    SUB DH, 8h
    SUB BX, 1234h
    SUB SI, 3122h
    SUB SP, 4222h
    SUB BP, 1111h
    SUB CX, [BX]
    SUB DX, [BX+78h]
    SUB BX, [BX+3456h]
    SUB SI, [BX+SI]
    SUB DI, [BX+SI+1h]
    SUB BP, [BX+SI+3891h]
    SUB SI, [BX+DI]
    SUB SP, [SI]
    SUB BP, [BP+DI+2131h]
    SUB [SI], AX
    SUB [BX], CX
    SUB [BX+111h], BX
    SUB [BX+12h], DX
    SUB [BX+SI+22h], SP
    SUB [BX+SI+00h], DI
    SUB [BX+DI+2212h], DI
    SUB [SI+2h], CX
    SUB AL, [DI]
    SUB AH, [DI+1h]
    SUB BH, [DI+1111h]
    SUB CL, [BP+00h]
    SUB BL, [BP+3456h]
    SUB CH, [BP+SI]
    SUB [BP+SI+123h], AL
    SUB [BP+SI+22h], AH
    SUB [BP+SI], BL
    SUB [BP+2222h], BH
    SUB [BP+12h], CL
    SUB [BP+0000h], CH
    SUB [DI+22h], DH
    SUB [DI+1232h], DL
    SUB AL, BYTE PTR ES:[DI+70h]
    SUB BL, BYTE PTR ES:[DI+2000h]
    SUB CL, BYTE PTR SS:[DI+70h]
    SUB CL, BYTE PTR CS:[DI+70h]
    SUB DX, WORD PTR DS:[DI+70h]
    SUB BYTE PTR ES:[DI+70h], al
    SUB BYTE PTR SS:[DI+2000h], bl
    SUB BYTE PTR [DI+18h], 22h 
    SUB BYTE PTR [DI+2222h], 11h
    SUB BYTE PTR [BX+12h], 11h
    SUB BYTE PTR [SI], 11h
    SUB WORD PTR [BP+3456h], 1234h
    SUB WORD PTR [BP+SI], 1231h
    SUB WORD PTR [BP+SI+45h], 3213h
    SUB WORD PTR [BP+SI+5678h], 1231h

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH BP
    PUSH DI
    PUSH ES
    PUSH CS
    PUSH SS
    PUSH DS
    PUSH WORD PTR [BX]
    PUSH WORD PTR [BX+11h]
    PUSH WORD PTR [BX+2222h]
    PUSH WORD PTR [BX+SI]
    PUSH WORD PTR [BX+SI+2222h]
    PUSH WORD PTR [BX+DI]
    PUSH WORD PTR [DI]
    PUSH WORD PTR [DI+23h]
    PUSH WORD PTR [BP+00]
    PUSH WORD PTR [BP+DI+123h]
    PUSH WORD PTR ES:[DI+70h]
    PUSH WORD PTR ES:[DI+2000h]
    PUSH WORD PTR SS:[DI+70h]
    PUSH WORD PTR CS:[DI+70h]
    PUSH WORD PTR DS:[DI+70h]
    PUSH WORD PTR ES:[DI+70h]
    PUSH WORD PTR SS:[DI+2000h] 

    POP AX
    POP BX
    POP CX
    POP DX
    POP BP
    POP DI
    POP ES
    POP SS
    POP DS
    POP WORD PTR [BX]
    POP WORD PTR [BX+11h]
    POP WORD PTR [BX+2222h]
    POP WORD PTR [BX+SI]
    POP WORD PTR [BX+SI+2222h]
    POP WORD PTR [BX+DI]
    POP WORD PTR [DI]
    POP WORD PTR [DI+23h]
    POP WORD PTR [BP+00]
    POP WORD PTR [BP+DI+123h] 
    POP WORD PTR ES:[DI+70h]
    POP WORD PTR ES:[DI+2000h]
    POP WORD PTR SS:[DI+70h]
    POP WORD PTR CS:[DI+70h]
    POP WORD PTR DS:[DI+70h]
    POP WORD PTR ES:[DI+70h]
    POP WORD PTR SS:[DI+2000h]  
   
    NOP

    XCHG AX, CX
    XCHG AX, DX
    XCHG AX, BX
    XCHG AX, SP
    XCHG AX, BP
    XCHG AX, SI
    XCHG AX, DI
    XCHG AL, AL
    XCHG AH, CL
    XCHG AH, AL
    XCHG BL, DL
    XCHG CH, DH
    XCHG DI, BX
    XCHG CX, BX
    XCHG BX, DX
    XCHG CX, CX
    XCHG BX, SP
    XCHG BP, SI
    XCHG DI, CX
    XCHG DI, DI
    XCHG SI, BP
    XCHG CX, DX
    XCHG CH, BYTE PTR [BX]
    XCHG AL, BYTE PTR [BP]
    XCHG CL, BYTE PTR [BX+SI]
    XCHG AL, BYTE PTR [BP+212h]
    XCHG DL, BYTE PTR [SI+00h]
    XCHG SI, WORD PTR [BX]
    XCHG SI, WORD PTR [BP+DI]
    XCHG CX, WORD PTR [BX+SI]
    XCHG AX, WORD PTR [BP+DI+235h]
    XCHG BP, WORD PTR [SI+2154h]
    XCHG AL, BYTE PTR ES:[DI+70h]
    XCHG BL, BYTE PTR ES:[DI+2000h]
    XCHG CL, BYTE PTR SS:[DI+70h]
    XCHG CL, BYTE PTR CS:[DI+70h]
    XCHG DX, WORD PTR DS:[DI+70h]
    XCHG BYTE PTR ES:[DI+70h], al
    XCHG BYTE PTR SS:[DI+2000h], bl

    OUT 22h, AL
    OUT 2, AX
    IN AX , 2h   
    IN AL, 32h   

    LEA CX, [BX+SI+12H]
    LEA CX, [SI+2131H]
    LES CX, [SI+12H] 
    LES CX, [BP+SI]
    LDS DX, [BX+312H]
    LDS AX, [BX]

    XLAT
    LAHF
    SAHF
    PUSHF
    POPF
    AAA
    DAA
    AAS
    DAS
    AAM
    AAD
    CBW
    CWD
    REP
    REPNZ
    MOVSB
    MOVSW
    CMPSB
    CMPSW
    SCASB
    SCASW
    LODSB
    LODSW
    STOSB
    STOSW
    INTO
    RET
    RETF
    RET 1234h
    RETF 1234h

    INC AX
    INC BX
    INC DX
    INC BYTE PTR [DI+18h]
    INC BYTE PTR [DI+2222h]
    INC BYTE PTR [BX+12h]
    INC BYTE PTR [SI]
    INC WORD PTR [BP+3456h]
    INC WORD PTR [BP+SI]
    INC WORD PTR [BP+SI+45h]
    INC WORD PTR [BP+SI+5678h]
    INC WORD PTR ES:[DI+70h]
    INC WORD PTR ES:[DI+2000h]
    INC WORD PTR SS:[DI+70h]
    INC WORD PTR CS:[DI+70h]
    INC WORD PTR DS:[DI+70h]
    INC WORD PTR ES:[DI+70h]
    INC WORD PTR SS:[DI+2000h] 
    DEC AX
    DEC BX
    DEC CX
    DEC BYTE PTR [DI+18h]
    DEC BYTE PTR [DI+2222h]
    DEC BYTE PTR [BX+12h]
    DEC BYTE PTR [SI]
    DEC WORD PTR [BP+3456h]
    DEC WORD PTR [BP+SI]
    DEC WORD PTR [BP+SI+45h]
    DEC WORD PTR [BP+SI+5678h]
    DEC WORD PTR ES:[DI+70h]
    DEC WORD PTR ES:[DI+2000h]
    DEC WORD PTR SS:[DI+70h]
    DEC WORD PTR CS:[DI+70h]
    DEC WORD PTR DS:[DI+70h]
    DEC WORD PTR ES:[DI+70h]
    DEC WORD PTR SS:[DI+2000h] 

    PUSH AX
    PUSH BX
    PUSH DX
    PUSH CX
    POP AX
    POP DX
    POP AX
    POP CX
    PUSH DS
    PUSH ES
    PUSH SS
    PUSH CS
    POP DS
    POP ES
    POP SS

   
    JA MY_LABEL
    JAE MY_LABEL
    JB MY_LABEL
    JNA MY_LABEL
    JE MY_LABEL
    JCXZ MY_LABEL
    JG MY_LABEL
    JGE MY_LABEL
    JL MY_LABEL
    JLE MY_LABEL
    JNE MY_LABEL
    JNO MY_LABEL
    JNP MY_LABEL
    JP MY_LABEL
    JO MY_LABEL
    JNS MY_LABEL
    JS MY_LABEL

    MY_LABEL:
    JMP MY_LABEL
    INT 3h
    INT 23h
    INT 21h

    IRET
    CLC
    STC
    CMC
    CLD
    STD
    CLI
    STI
    HLT
    WAIT
    LOCK

    CMP AX, a
    CMP AL, b
    CMP a, AX
    CMP b, AL
    CMP AL, 15h
    CMP AH, 6h
    CMP CL, 2h
    CMP DH, 8h
    CMP BX, 1234h
    CMP SI, 3122h
    CMP SP, 4222h
    CMP BP, 1111h
    CMP CX, WORD PTR [BX]
    CMP DX, WORD PTR [BX+78h]
    CMP BX, WORD PTR [BX+3456]
    CMP SI, WORD PTR [BX+SI]
    CMP DI, WORD PTR [BX+SI+1h]
    CMP BP, WORD PTR [BX+SI+3891h]
    CMP SI, WORD PTR [BX+DI]
    CMP SP, WORD PTR [SI]
    CMP BP, WORD PTR [BP+DI+2131h]
    CMP WORD PTR [SI], AX
    CMP WORD PTR [BX], CX
    CMP WORD PTR [BX+111h], BX
    CMP WORD PTR [BX+12h], DX
    CMP WORD PTR [BX+SI+22h], SP
    CMP WORD PTR [BX+SI+00h], DI
    CMP WORD PTR [BX+DI+2212h], DI
    CMP WORD PTR [SI+2h], CX
    CMP AL,BYTE PTR  [DI]
    CMP AH, BYTE PTR [DI+1h]
    CMP BH, BYTE PTR [DI+1111h]
    CMP CL, BYTE PTR [BP+00h]
    CMP BL, BYTE PTR [BP+3456h]
    CMP CH, BYTE PTR [BP+SI]
    CMP BYTE PTR [BP+SI+123h], AL
    CMP BYTE PTR [BP+SI+22h], AH
    CMP BYTE PTR [BP+SI], BL
    CMP BYTE PTR [BP+2222h], BH
    CMP BYTE PTR [BP+12h], CL
    CMP BYTE PTR [BP+0000h], CH
    CMP BYTE PTR [DI+22h], DH
    CMP BYTE PTR [DI+1232h], DL
    CMP AL, BYTE PTR ES:[DI+70h]
    CMP BL, BYTE PTR ES:[DI+2000h]
    CMP CL, BYTE PTR SS:[DI+70h]
    CMP CL, BYTE PTR CS:[DI+70h]
    CMP DX, WORD PTR DS:[DI+70h]
    CMP BYTE PTR ES:[DI+70h], al
    CMP BYTE PTR SS:[DI+2000h], bl
    CMP BYTE PTR [DI+18h], 22h 
    CMP BYTE PTR [DI+2222h], 11h
    CMP BYTE PTR [BX+12h], 11h
    CMP BYTE PTR [SI], 11h
    CMP WORD PTR [BP+3456h], 1234h
    CMP WORD PTR [BP+SI], 1231h
    CMP WORD PTR [BP+SI+45], 3213h
    
    MUL a
    MUL b
    MUL AX
    MUL AL
    MUL CL
    MUL DH
    MUL BX
    MUL SI
    MUL SP
    MUL BP
    MUL CX
    MUL DX
    MUL WORD PTR [BX+3456h]
    MUL WORD PTR [BX+SI]
    MUL WORD PTR [BX+SI+1h]
    MUL WORD PTR [BX+SI+3891h]
    MUL WORD PTR [BX+DI]
    MUL WORD PTR [SI]
    MUL WORD PTR [BP+DI+2131h]
    MUL WORD PTR ES:[DI+70h]
    MUL WORD PTR ES:[DI+2000h]
    MUL WORD PTR SS:[DI+70h]
    MUL WORD PTR CS:[DI+70h]
    MUL WORD PTR DS:[DI+70h]
    MUL WORD PTR ES:[DI+70h]
    MUL WORD PTR SS:[DI+2000h] 
    
    IMUL a
    IMUL b
    IMUL AX
    IMUL AL
    IMUL CL
    IMUL DH
    IMUL BX
    IMUL SI
    IMUL SP
    IMUL BP
    IMUL CX
    IMUL DX
    IMUL WORD PTR [BX+3456h]
    IMUL WORD PTR [BX+SI]
    IMUL WORD PTR [BX+SI+1h]
    IMUL WORD PTR [BX+SI+3891h]
    IMUL WORD PTR [BX+DI]
    IMUL WORD PTR [SI]
    IMUL WORD PTR [BP+DI+2131h]
    IMUL WORD PTR ES:[DI+70h]
    IMUL WORD PTR ES:[DI+2000h]
    IMUL WORD PTR SS:[DI+70h]
    IMUL WORD PTR CS:[DI+70h]
    IMUL WORD PTR DS:[DI+70h]
    IMUL WORD PTR ES:[DI+70h]
    IMUL WORD PTR SS:[DI+2000h] 
    
    DIV a
    DIV b
    DIV AX
    DIV AL
    DIV CL
    DIV DH
    DIV BX
    DIV SI
    DIV SP
    DIV BP
    DIV CX
    DIV DX
    DIV WORD PTR [BX+3456h]
    DIV WORD PTR [BX+SI]
    DIV WORD PTR [BX+SI+1h]
    DIV WORD PTR [BX+SI+3891h]
    DIV WORD PTR [BX+DI]
    DIV WORD PTR [SI]
    DIV WORD PTR [BP+DI+2131h]
    DIV WORD PTR ES:[DI+70h]
    DIV WORD PTR ES:[DI+2000h]
    DIV WORD PTR SS:[DI+70h]
    DIV WORD PTR CS:[DI+70h]
    DIV WORD PTR DS:[DI+70h]
    DIV WORD PTR ES:[DI+70h]
    DIV WORD PTR SS:[DI+2000h] 

    IDIV a
    IDIV b
    IDIV AX
    IDIV AL
    IDIV CL
    IDIV DH
    IDIV BX
    IDIV SI
    IDIV SP
    IDIV BP
    IDIV CX
    IDIV DX
    IDIV WORD PTR [BX+3456h]
    IDIV WORD PTR [BX+SI]
    IDIV WORD PTR [BX+SI+1h]
    IDIV WORD PTR [BX+SI+3891h]
    IDIV WORD PTR [BX+DI]
    IDIV WORD PTR [SI]
    IDIV WORD PTR [BP+DI+2131h]
    IDIV WORD PTR ES:[DI+70h]
    IDIV WORD PTR ES:[DI+2000h]
    IDIV WORD PTR SS:[DI+70h]
    IDIV WORD PTR CS:[DI+70h]
    IDIV WORD PTR DS:[DI+70h]
    IDIV WORD PTR ES:[DI+70h]
    IDIV WORD PTR SS:[DI+2000h] 

    NEG a
    NEG b
    NEG AX
    NEG AL
    NEG CL
    NEG DH
    NEG BX
    NEG SI
    NEG SP
    NEG BP
    NEG CX
    NEG DX
    NEG WORD PTR [BX+3456h]
    NEG WORD PTR [BX+SI]
    NEG WORD PTR [BX+SI+1h]
    NEG WORD PTR [BX+SI+3891h]
    NEG WORD PTR [BX+DI]
    NEG WORD PTR [SI]
    NEG WORD PTR [BP+DI+2131h]
    IDIV WORD PTR ES:[DI+70h]
    IDIV WORD PTR ES:[DI+2000h]
    IDIV WORD PTR SS:[DI+70h]
    IDIV WORD PTR CS:[DI+70h]
    IDIV WORD PTR DS:[DI+70h]
    IDIV WORD PTR ES:[DI+70h]
    IDIV WORD PTR SS:[DI+2000h] 
    
    NOT a
    NOT b
    NOT AX
    NOT AL
    NOT CL
    NOT DH
    NOT BX
    NOT SI
    NOT SP
    NOT BP
    NOT CX
    NOT DX
    NOT WORD PTR [BX+3456h]
    NOT WORD PTR [BX+SI]
    NOT WORD PTR [BX+SI+1h]
    NOT WORD PTR [BX+SI+3891h]
    NOT WORD PTR [BX+DI]
    NOT WORD PTR [SI]
    NOT WORD PTR [BP+DI+2131h]
    NOT WORD PTR ES:[DI+70h]
    NOT WORD PTR ES:[DI+2000h]
    NOT WORD PTR SS:[DI+70h]
    NOT WORD PTR CS:[DI+70h]
    NOT WORD PTR DS:[DI+70h]
    NOT WORD PTR ES:[DI+70h]
    NOT WORD PTR SS:[DI+2000h] 

    SHR AX, 1h
    SHR BX, 1h
    SHR AL, CL
    SHR CX, CL
    SHR BP, 1
    SHR WORD PTR [BX], 1
    SHR BYTE PTR [BX+22h], CL
    SHR WORD PTR [BX+2222h], 1h
    SHR WORD PTR [BX+SI], CL
    SHR BYTE PTR [BX+SI+11h], 1
    SHR WORD PTR [BX+SI+1111h], CL
    SHR WORD PTR [BX+DI], 1
    SHR WORD PTR [BX+DI+00], CL
    SHR WORD PTR [BX+DI+5678h], 1h
    SHR BYTE PTR [SI], CL
    SHR BYTE PTR [SI+2h], CL
    SHR WORD PTR [DI], 1
    SHR WORD PTR [DI+11h], 1h
    SHR WORD PTR [BP+00], CL    
    SHR BYTE PTR [BP+SI], 1
    SHR WORD PTR [BP+SI+59h], CL
    SHR WORD PTR [BP+SI+1118h], 1
    SHR BYTE PTR [BP+DI], CL
    SHR WORD PTR [BP+DI+5228h], CL
    SHR WORD PTR ES:[DI+70h], 1
    SHR WORD PTR ES:[DI+2000h], cl
    SHR WORD PTR SS:[DI+70h], 1
    SHR WORD PTR CS:[DI+70h], 1
    SHR WORD PTR DS:[DI+70h], 1
    SHR WORD PTR ES:[DI+70h], 1
    SHR WORD PTR SS:[DI+2000h], cl
   
    SHL AX, 1h
    SHL BX, 1h
    SHL AL, CL
    SHL CX, CL
    SHL BP, 1h
    SHL WORD PTR [BX], 1
    SHL BYTE PTR [BX+22h], CL
    SHL WORD PTR [BX+2222h], 1h
    SHL WORD PTR [BX+DI+00], CL
    SHL WORD PTR [BX+DI+5678h], 1
    SHL BYTE PTR [SI], CL
    SHL BYTE PTR [SI+2h], CL
    SHL WORD PTR [DI], 1h
    SHL WORD PTR [DI+11h], 1
    SHL WORD PTR [BP+00], CL    
    SHL BYTE PTR [BP+SI], 1h
    SHL WORD PTR [BP+SI+59h], CL
    SHL WORD PTR [BP+SI+1118h], 1h
    SHL BYTE PTR [BP+DI], CL
    SHL WORD PTR [BP+DI+5228h], CL
    SHL WORD PTR ES:[DI+70h], 1
    SHL WORD PTR ES:[DI+2000h], cl
    SHL WORD PTR SS:[DI+70h], 1
    SHL WORD PTR CS:[DI+70h], 1
    SHL WORD PTR DS:[DI+70h], 1
    SHL WORD PTR ES:[DI+70h], 1
    SHL WORD PTR SS:[DI+2000h], cl

    SAR AX, 1h
    SAR BX, 1h
    SAR AL, CL
    SAR CX, CL
    SAR BP, 1h
    SAR WORD PTR [BX], 1
    SAR BYTE PTR [BX+22h], CL
    SAR WORD PTR [BX+2222h], 1h
    SAR WORD PTR [BX+DI+00], CL
    SAR WORD PTR [BX+DI+5678h], 1
    SAR BYTE PTR [SI], CL
    SAR BYTE PTR [SI+2h], CL
    SAR WORD PTR [DI], 1h
    SAR WORD PTR [DI+11h], 1
    SAR WORD PTR [BP+00], CL    
    SAR BYTE PTR [BP+SI], 1h
    SAR WORD PTR [BP+SI+59h], CL
    SAR WORD PTR [BP+SI+1118h], 1h
    SAR BYTE PTR [BP+DI], CL
    SAR WORD PTR [BP+DI+5228h], CL
    SAR WORD PTR ES:[DI+70h], 1
    SAR WORD PTR ES:[DI+2000h], cl
    SAR WORD PTR SS:[DI+70h], 1
    SAR WORD PTR CS:[DI+70h], 1
    SAR WORD PTR DS:[DI+70h], 1
    SAR WORD PTR ES:[DI+70h], 1
    SAR WORD PTR SS:[DI+2000h], cl

    ROL AX, 1h
    ROL BX, 1h
    ROL AL, CL
    ROL CX, CL
    ROL BP, 1h
    ROL WORD PTR [BX], 1
    ROL BYTE PTR [BX+22h], CL
    ROL WORD PTR [BX+2222h], 1h
    ROL WORD PTR [BX+DI+00], CL
    ROL WORD PTR [BX+DI+5678h], 1
    ROL BYTE PTR [SI], CL
    ROL BYTE PTR [SI+2h], CL
    ROL WORD PTR [DI], 1h
    ROL WORD PTR [DI+11h], 1
    ROL WORD PTR [BP+00], CL    
    ROL BYTE PTR [BP+SI], 1h
    ROL WORD PTR [BP+SI+59h], CL
    ROL WORD PTR [BP+SI+1118h], 1h
    ROL BYTE PTR [BP+DI], CL
    ROL WORD PTR [BP+DI+5228h], CL
    ROL WORD PTR ES:[DI+70h], 1
    ROL WORD PTR ES:[DI+2000h], cl
    ROL WORD PTR SS:[DI+70h], 1
    ROL WORD PTR CS:[DI+70h], 1
    ROL WORD PTR DS:[DI+70h], 1
    ROL WORD PTR ES:[DI+70h], 1
    ROL WORD PTR SS:[DI+2000h], cl

    ROR AX, 1h
    ROR BX, 1h
    ROR AL, CL
    ROR CX, CL
    ROR BP, 1h
    ROR WORD PTR [BX], 1
    ROR BYTE PTR [BX+22h], CL
    ROR WORD PTR [BX+2222h], 1h
    ROR WORD PTR [BX+DI+00], CL
    ROR WORD PTR [BX+DI+5678h], 1
    ROR BYTE PTR [SI], CL
    ROR BYTE PTR [SI+2h], CL
    ROR WORD PTR [DI], 1h
    ROR WORD PTR [DI+11h], 1
    ROR WORD PTR [BP+00], CL    
    ROR BYTE PTR [BP+SI], 1h
    ROR WORD PTR [BP+SI+59h], CL
    ROR WORD PTR [BP+SI+1118h], 1h
    ROR BYTE PTR [BP+DI], CL
    ROR WORD PTR [BP+DI+5228h], CL
    ROR WORD PTR ES:[DI+70h], 1
    ROR WORD PTR ES:[DI+2000h], cl
    ROR WORD PTR SS:[DI+70h], 1
    ROR WORD PTR CS:[DI+70h], 1
    ROR WORD PTR DS:[DI+70h], 1
    ROR WORD PTR ES:[DI+70h], 1
    ROR WORD PTR SS:[DI+2000h], cl

    RCL AX, 1h
    RCL BX, 1h
    RCL AL, CL
    RCL CX, CL
    RCL BP, 1h
    RCL WORD PTR [BX], 1
    RCL BYTE PTR [BX+22h], CL
    RCL WORD PTR [BX+2222h], 1h
    RCL WORD PTR [BX+DI+00], CL
    RCL WORD PTR [BX+DI+5678h], 1
    RCL BYTE PTR [SI], CL
    RCL BYTE PTR [SI+2h], CL
    RCL WORD PTR [DI], 1h
    RCL WORD PTR [DI+11h], 1
    RCL WORD PTR [BP+00], CL    
    RCL BYTE PTR [BP+SI], 1h
    RCL WORD PTR [BP+SI+59h], CL
    RCL WORD PTR [BP+SI+1118h], 1h
    RCL BYTE PTR [BP+DI], CL
    RCL WORD PTR [BP+DI+5228h], CL
    RCL WORD PTR ES:[DI+70h], 1
    RCL WORD PTR ES:[DI+2000h], cl
    RCL WORD PTR SS:[DI+70h], 1
    RCL WORD PTR CS:[DI+70h], 1
    RCL WORD PTR DS:[DI+70h], 1
    RCL WORD PTR ES:[DI+70h], 1
    RCL WORD PTR SS:[DI+2000h], cl
    
    RCR AX, 1h
    RCR BX, 1h
    RCR AL, CL
    RCR CX, CL
    RCR BP, 1h
    RCR WORD PTR [BX], 1
    RCR BYTE PTR [BX+22h], CL
    RCR WORD PTR [BX+2222h], 1h
    RCR WORD PTR [BX+DI+00], CL
    RCR WORD PTR [BX+DI+5678h], 1
    RCR BYTE PTR [SI], CL
    RCR BYTE PTR [SI+2h], CL
    RCR WORD PTR [DI], 1h
    RCR WORD PTR [DI+11h], 1
    RCR WORD PTR [BP+00], CL    
    RCR BYTE PTR [BP+SI], 1h
    RCR WORD PTR [BP+SI+59h], CL
    RCR WORD PTR [BP+SI+1118h], 1h
    RCR BYTE PTR [BP+DI], CL
    RCR WORD PTR [BP+DI+5228h], CL
    RCR WORD PTR ES:[DI+70h], 1
    RCR WORD PTR ES:[DI+2000h], cl
    RCR WORD PTR SS:[DI+70h], 1
    RCR WORD PTR CS:[DI+70h], 1
    RCR WORD PTR DS:[DI+70h], 1
    RCR WORD PTR ES:[DI+70h], 1
    RCR WORD PTR SS:[DI+2000h], cl

    AND AX, a
    AND AL, b
    AND a, AX
    AND b, AL
    AND AL, 15h
    AND AH, 6h
    AND CL, 2h
    AND DH, 8h
    AND BX, 1234h
    AND SI, 3122h
    AND SP, 4222h
    AND BP, 1111h
    AND CX, [BX]
    AND DX, [BX+78]
    AND BX, [BX+3456h]
    AND SI, [BX+SI]
    AND DI, [BX+SI+1h]
    AND BP, [BX+SI+3891h]
    AND SI, [BX+DI]
    AND SP, [SI]
    AND BP, [BP+DI+2131h]
    AND [SI], AX
    AND [BX], CX
    AND [BX+111h], BX
    AND [BX+12h], DX
    AND [BX+SI+22h], SP
    AND [BX+SI+00h], DI
    AND [BX+DI+2212h], DI
    AND [SI+2h], CX
    AND AL, [DI]
    AND AH, [DI+1h]
    AND BH, [DI+1111h]
    AND CL, [BP+00h]
    AND BL, [BP+3456h]
    AND CH, [BP+SI]
    AND [BP+SI+123h], AL
    AND [BP+SI+22h], AH
    AND [BP+SI], BL
    AND [BP+2222h], BH
    AND [BP+12h], CL
    AND [BP+0000h], CH
    AND [DI+22h], DH
    AND [DI+1232h], DL
    AND AL, BYTE PTR ES:[DI+70h]
    AND BL, BYTE PTR ES:[DI+2000h]
    AND CL, BYTE PTR SS:[DI+70h]
    AND CL, BYTE PTR CS:[DI+70h]
    AND DX, WORD PTR DS:[DI+70h]
    AND BYTE PTR ES:[DI+70h], al
    AND BYTE PTR SS:[DI+2000h], bl 
    AND BYTE PTR [DI+18h], 22h 
    AND BYTE PTR [DI+2222h], 11h
    AND BYTE PTR [BX+12h], 11h
    AND BYTE PTR [SI], 11h
    AND WORD PTR [BP+3456h], 1234h
    AND WORD PTR [BP+SI], 1231h
    AND WORD PTR [BP+SI+45], 3213h
    AND WORD PTR [BP+SI+5678h], 1231h

    OR AX, a
    OR AL, b
    OR a, AX
    OR b, AL
    OR AL, 15h
    OR AH, 6h
    OR CL, 2h
    OR DH, 8h
    OR BX, 1234h
    OR SI, 3122h
    OR SP, 4222h
    OR BP, 1111h
    OR CX, [BX]
    OR DX, [BX+78h]
    OR BX, [BX+3456h]
    OR SI, [BX+SI]
    OR DI, [BX+SI+1h]
    OR BP, [BX+SI+3891h]
    OR SI, [BX+DI]
    OR SP, [SI]
    OR BP, [BP+DI+2131h]
    OR [SI], AX
    OR [BX], CX
    OR [BX+111h], BX
    OR [BX+12h], DX
    OR [BX+SI+22h], SP
    OR [BX+SI+00h], DI
    OR [BX+DI+2212h], DI
    OR [SI+2h], CX
    OR AL, [DI]
    OR AH, [DI+1h]
    OR BH, [DI+1111h]
    OR CL, [BP+00h]
    OR BL, [BP+3456h]
    OR CH, [BP+SI]
    OR [BP+SI+123h], AL
    OR [BP+SI+22h], AH
    OR [BP+SI], BL
    OR [BP+2222h], BH
    OR [BP+12h], CL
    OR [BP+0000h], CH
    OR [DI+22h], DH
    OR [DI+1232h], DL
    OR AL, BYTE PTR ES:[DI+70h]
    OR BL, BYTE PTR ES:[DI+2000h]
    OR CL, BYTE PTR SS:[DI+70h]
    OR CL, BYTE PTR CS:[DI+70h]
    OR DX, WORD PTR DS:[DI+70h]
    OR BYTE PTR ES:[DI+70h], al
    OR BYTE PTR SS:[DI+2000h], bl
    OR BYTE PTR [DI+18h], 22h 
    OR BYTE PTR [DI+2222h], 11h
    OR BYTE PTR [BX+12h], 11h
    OR BYTE PTR [SI], 11h
    OR WORD PTR [BP+3456h], 1234h
    OR WORD PTR [BP+SI], 1231h
    OR WORD PTR [BP+SI+45], 3213h
    OR WORD PTR [BP+SI+5678h], 1231h

    XOR AX, a
    XOR AL, b
    XOR a, AX
    XOR b, AL
    XOR AL, 15h
    XOR AH, 6h
    XOR CL, 2h
    XOR DH, 8h
    XOR BX, 1234h
    XOR SI, 3122h
    XOR SP, 4222h
    XOR BP, 1111h
    XOR CX, [BX]
    XOR DX, [BX+78h]
    XOR BX, [BX+3456h]
    XOR SI, [BX+SI]
    XOR DI, [BX+SI+1h]
    XOR BP, [BX+SI+3891h]
    XOR SI, [BX+DI]
    XOR SP, [SI]
    XOR BP, [BP+DI+2131h]
    XOR [SI], AX
    XOR [BX], CX
    XOR [BX+111h], BX
    XOR [BX+12h], DX
    XOR [BX+SI+22h], SP
    XOR [BX+SI+00h], DI
    XOR [BX+DI+2212h], DI
    XOR [SI+2h], CX
    XOR AL, [DI]
    XOR AH, [DI+1h]
    XOR BH, [DI+1111h]
    XOR CL, [BP+00h]
    XOR BL, [BP+3456h]
    XOR CH, [BP+SI]
    XOR [BP+SI+123h], AL
    XOR [BP+SI+22h], AH
    XOR [BP+SI], BL
    XOR [BP+2222h], BH
    XOR [BP+12h], CL
    XOR [BP+0000h], CH
    XOR [DI+22h], DH
    XOR [DI+1232h], DL
    XOR AL, BYTE PTR ES:[DI+70h]
    XOR BL, BYTE PTR ES:[DI+2000h]
    XOR CL, BYTE PTR SS:[DI+70h]
    XOR CL, BYTE PTR CS:[DI+70h]
    XOR DX, WORD PTR DS:[DI+70h]
    XOR BYTE PTR ES:[DI+70h], al
    XOR BYTE PTR SS:[DI+2000h], bl
    XOR BYTE PTR [DI+18h], 22h 
    XOR BYTE PTR [DI+2222h], 11h
    XOR BYTE PTR [BX+12h], 11h
    XOR BYTE PTR [SI], 11h
    XOR WORD PTR [BP+3456h], 1234h
    XOR WORD PTR [BP+SI], 1231h
    XOR WORD PTR [BP+SI+45], 3213h
    XOR WORD PTR [BP+SI+5678h], 1231h

    TEST AX, a
    TEST AL, b
    TEST a, AX
    TEST b, AL
    TEST AL, 15h
    TEST AH, 6h
    TEST CL, 2h
    TEST DH, 8h
    TEST BX, 1234h
    TEST SI, 3122h
    TEST SP, 4222h
    TEST BP, 1111h
    TEST CX, [BX]
    TEST DX, [BX+78h]
    TEST BX, [BX+3456h]
    TEST SI, [BX+SI]
    TEST DI, [BX+SI+1h]
    TEST BP, [BX+SI+3891h]
    TEST SI, [BX+DI]
    TEST SP, [SI]
    TEST BP, [BP+DI+2131h]
    TEST [SI], AX
    TEST [BX], CX
    TEST [BX+111h], BX
    TEST [BX+12h], DX
    TEST [BX+SI+22h], SP
    TEST [BX+SI+00h], DI
    TEST [BX+DI+2212h], DI
    TEST [SI+2h], CX
    TEST AL, [DI]
    TEST AH, [DI+1h]
    TEST BH, [DI+1111h]
    TEST CL, [BP+00h]
    TEST BL, [BP+3456h]
    TEST CH, [BP+SI]
    TEST [BP+SI+123h], AL
    TEST [BP+SI+22h], AH
    TEST [BP+SI], BL
    TEST [BP+2222h], BH
    TEST [BP+12h], CL
    TEST [BP+0000h], CH
    TEST [DI+22h], DH
    TEST [DI+1232h], DL
    TEST AL, BYTE PTR ES:[DI+70h]
    TEST BL, BYTE PTR ES:[DI+2000h]
    TEST CL, BYTE PTR SS:[DI+70h]
    TEST CL, BYTE PTR CS:[DI+70h]
    TEST DX, WORD PTR DS:[DI+70h]
    TEST BYTE PTR ES:[DI+70h], al
    TEST BYTE PTR SS:[DI+2000h], bl 
    TEST BYTE PTR [DI+18h], 22h 
    TEST BYTE PTR [DI+2222h], 11h
    TEST BYTE PTR [BX+12h], 11h
    TEST BYTE PTR [SI], 11h
    TEST WORD PTR [BP+3456h], 1234h
    TEST WORD PTR [BP+SI], 1231h
    TEST WORD PTR [BP+SI+45], 3213h
    TEST WORD PTR [BP+SI+5678h], 1231h

    CALL MY_LABEL2
    JMP MY_LABEL2
    MY_LABEL2:
    CALL MY_LABEL2
    JMP MY_LABEL2
    
    CALL MY_PROC
    
    JMP AX
    JMP SI
    JMP BP
    JMP [BX+8h]
    JMP [BX+SI+1231h]
    JMP [BX+DI]  

    CALL AX
    CALL SI
    CALL BP
    CALL [BX+8h]
    CALL [BX+SI+1231h]
    CALL [BX+DI]

    MY_LABEL3:
    LOOP MY_LABEL3
    LOOPE MY_LABEL3
    LOOPNE MY_LABEL3


        
    PROC MY_PROC
    ENDP
    a dw ?
    b db ?
B_SEG       ENDS

END         START