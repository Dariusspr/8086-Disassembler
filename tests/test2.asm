.MODEL      TINY

B_SEG       SEGMENT

ORG         100h
ASSUME      DS:B_SEG, CS:B_SEG, SS:B_SEG

START:

    PUSH DS
    MOV AX, WORD PTR ES:[BX+DI+3213h]
    MOV DX, 2131h
    XCHG AX, DX
    AAS
    SUB AX, DX
    NOT AX
    MOV CL, DL
    ROL AX, CL
    REP
    CMP AX, DX
    JNE LOOP_LABEL
    XOR AX, AX
    LOOP_LABEL:
        INC AL
        LOOP LOOP_LABEL
    POP DX
    
B_SEG       ENDS

END         START
