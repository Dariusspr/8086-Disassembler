.model small
.stack 100h

inputBuffSize = 256

; Masyvu dydziai
oneByteInstructionArraySize1 = 51
oneByteInstructionArraySize2 = 39
twoByteInstructionArraySize = 2
inOutArraySize = 2
modRegRMArraySize = 3
wOpOpArraySize = 9
wModRegRMArraySize = 2
dWModRegRMArraySize = 9
threeBitsWModRMArraySize = 7
threeBitsVWModRMArraySize = 7
threeBitsSWModRMArraySize = 8
jumpsOffsetArraySize = 21
threeBitsModRMArraySize = 7
jump2BytesOpArraySize = 2
jump4ytesOpArraySize = 2
returnsArraySize = 2

modArraySize = 8
; HEX MNEMONIC pradzios pozicijos isvesties buferyje
hexCodePos = 12
mnemonicPos = 40

.data
    testMsg1 db "TEST1 ------ $"
    testMsg2 db "TEST2 ------ $"
    testMsg3 db "TEST3 ------ $"


    infoMsg db "usage: [inputFile] [outputFile]$"
    inputFileErrorMsg db "failed to open input file$"
    outputFileErrorMsg db "failed to create output file$"

    inputFileName db 40 dup (?)
    inputFileHandle dw ?
    inputBuff db inputBuffSize dup (?)
    inputBuffPos dw 0
    inputBuffbytesleft dw 0
    
    ; Laikinas mnemonikos buferis
    mnemonicBuff db 40 dup (?)
    mnemonicBuffPos dw 0

    outputFileName db 40 dup (?)
    outputFileHandle dw ?
    outputBuff db 100 dup (?)
    outputBuffPos dw 0
    codeBytePos dw 100h ; FIXME

    ;;;;;;;;;;;;;;;;;;; SUTVARKYTI(DIDEJIMO TVARKA) INSTRUKCIJOMS ATSPAUSDINTI REIKALINGI MASYVAI  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Instrukcijų pirmo baito šešioliktainė reikšmė ir mnemonika

    ; Visos 1 baito instrukcijos DONE
    oneByteInstructionArray1 db 6H, "PUSH ES", 0, 7H, "POP ES", 0, 0EH, "PUSH CS", 0, 16H, "PUSH SS", 0, 17H, "POP SS", 0, 1EH, "PUSH DS", 0, 1FH, "POP DS", 0, 27H, "DAA", 0, 2FH, "DAS", 0, 37H, "AAA", 0, 3FH, "AAS", 0, 40H, "INC AX", 0, 41H, "INC CX", 0, 42H, "INC DX", 0, 43H, "INC BX", 0, 44H, "INC SP", 0, 45H, "INC BP", 0, 46H, "INC SI", 0, 47H, "INC DI", 0, 48H, "DEC AX", 0, 49H, "DEC CX", 0, 4AH, "DEC DX", 0, 4BH, "DEC BX", 0, 4CH, "DEC SP", 0, 4DH, "DEC BP", 0, 4EH, "DEC SI", 0, 4FH, "DEC DI", 0, 50H, "PUSH AX", 0, 51H, "PUSH CX", 0, 52H, "PUSH DX", 0, 53H, "PUSH BX", 0, 54H, "PUSH SP", 0, 55H, "PUSH BP", 0, 56H, "PUSH SI", 0, 57H, "PUSH DI", 0, 58H, "POP AX", 0, 59H, "POP CX", 0, 5AH, "POP DX", 0, 5BH, "POP BX", 0, 5CH, "POP SP", 0, 5DH, "POP BP", 0, 5EH, "POP SI", 0, 5FH, "POP DI", 0, 90h, "NOP", 0, 91h, "CXHG AX, CX", 0, 92h, "CXHG AX, DX", 0, 93h, "CXHG AX, BX", 0, 94h, "CXHG AX, SP", 0, 95h, "CXHG AX, BP", 0, 96h, "CXHG AX, SI", 0, 97h, "CXHG AX, DI", 0
    oneByteInstructionArray2 db 98H, "CBW", 0, 99H, "CWD", 0, 9BH, "WAIT", 0, 9CH, "PUSHF", 0, 9DH, "POPF", 0, 9EH, "SAHF", 0, 9FH, "LAHF", 0, 0A4H, "MOVSB", 0, 0A5H, "MOVSW", 0, 0A6H, "CMPSB", 0, 0A7H, "CMPSW", 0, 0AAH, "STOSB", 0, 0ABH, "STOSW", 0, 0ACH, "LODSB", 0, 0ADH, "LODSW", 0, 0AEH, "SCASB", 0, 0AFH, "SCASW", 0, 0C3H, "RET", 0, 0CBH, "RET", 0, 0CCH, "INT 3H", 0, 0CEH, "INTO", 0, 0CFH, "IRET", 0, 0D7H, "XLAT", 0, 0ECH, "IN AL, DX", 0, 0EDH, "IN AX, DX", 0, 0EEH, "OUT DX, AL", 0, 0EFH, "OUT DX, AX", 0, 0F0H, "LOCK", 0, 0F2H, "REPNZ", 0, 0F3H, "REP", 0, 0F4H, "HLT", 0, 0F5H, "CMC", 0, 0F8H, "CLC", 0, 0F9H, "STC", 0, 0FAH, "CLI", 0, 0FBH, "STI", 0, 0FCH, "CLD", 0, 0FDH, "STD", 0
    ; Visos 2 baitų instrukcijos, nereikalaujančios papildomų veiksmų DONE
    twoByteInstructionArray Db 0D4H, "AAM", 0, 0D5H, "AAD", 0
    ; In/Out instrukcijos DONE
    inOutArray db 0E4H, "IN ", 0, 0E6H, "OUT ", 0
    ; mod reg r/m instrukcijos DONE
    modRegRMArray db 8DH, "LEA ", 0, 0C4H, "LES ", 0, 0C5H, "LDS ", 0
    ; w op op instrukcijos DONE
    wOpOpArray db 4H, "ADD ", 0, 0CH, "OR ", 0, 14H, "ADC ", 0, 1CH, "SBB ", 0, 24H, "AND ", 0, 2CH, "SUB ", 0, 34H, "XOR ", 0, 3CH, "CMP ", 0, 0A8H, "TEST ", 0
    ; w mod reg r/m  instrukcijos DONE
    wModRegRMArray db 84H, "TEST ", 0, 86H, "XCHG ", 0
    ; dw mod reg r/m instrukcijos DONE
    dWModRegRMArray db 0H, "ADD ", 0, 08H, "OR ", 0, 10H, "ADC ", 0, 18H, "SBB ", 0, 20H, "AND ", 0, 28H, "SUB ", 0, 30H, "XOR ", 0, 38H, "CMP ", 0, 88H, "MOV ", 0
    ; 1111 011 w mod xxx r/m instrukcijos DONE
    threeBitsWModRMArray db 000B, "TEST ", 0, 010B, "NOT ", 0, 011B, "NEG ", 0, 100B, "MUL ", 0, 101B, "IMUL ", 0, 110B, "DIV ", 0, 111B, "IDIV ", 0
    ; 1101 00 vw mod xxx r/m instrukcijos DONE
    threeBitsVWModRMArray db 000B, "ROL ", 0, 001B, "ROR ", 0, 010B, "RCL ", 0, 011B, "RCR ", 0, 100B, "SHL ", 0, 101B, "SHR ", 0, 111B, "SAR ", 0
    ; 1000 00 sw mod xxx r/m instrukcijos DONE
    threeBitsSWModRMArray db 000B, "ADD ", 0, 001B, "OR ", 0, 010B, "ADC ", 0, 011B, "SBB ", 0, 100B, "AND ", 0, 101B, "SUB ", 0, 110B, "XOR ", 0, 111B, "CMP ", 0
    ; jumps + offset instrukcijos DONE
    jumpsOffsetArray db 70H, "JO ", 0, 71H, "JNO ", 0, 72H, "JB ", 0, 73H, "JNB ", 0, 74H, "JE ", 0, 75H, "JNE ", 0, 76H, "JNA ", 0, 77H, "JA ", 0, 78H, "JS ", 0, 79H, "JNS ", 0, 7AH, "JP ", 0, 7BH, "JNP ", 0, 7CH, "JL ", 0, 7DH, "JNL ", 0, 7EH, "JLE ", 0, 7FH, "JG ", 0, 0E0H, "LOOPNE ", 0, 0E1H, "LOOPE ", 0, 0E2H, "LOOP ", 0, 0E3H, "JCXZ ", 0, 0EBH, "JMP ", 0 
    ; 1111 1111 mod xxx r/m instrukcijos DONE
    threeBitsModRMArray db 000B, "INC ", 0, 001B, "DEC ", 0, 010B, "CALL ", 0, 011B, "CALL ", 0, 100B, "JMP ", 0, 101B, "JMP ", 0, 110B, "PUSH ", 0
    ; Jump/call 2 bytes op
    jump2BytesOpArray db 0E8H, "CALL ", 0, 0E9H, "JMP ", 0
    ; Jumps/call 4 bytes op
    jump4BytesOpArray db 9AH, "CALL ", 0, 0EAH, "JMP ", 0
    ; returns op op
    returnsArray db 0C2H, "RET ", 0, 0CAH, "RET ", 0

    ; MOV w mod r/m op op 
    insWModRMOpOpMov db 0C6H, "MOV ", 0
    ; MOV w reg op op 
    insWRegOpOpMov db 0B0H, "MOV ", 0
    ; MOV w adr adr
    insWAdrAdrMov db 0A0H, "MOV ", 0
    ; MOV d mod sreg r/m  ??????
    insDModSregRMMov db 8CH, "MOV ", 0
    ; POP mod r/m 
    insModRMPop db 8FH, "POP ", 0
    ; int byte number
    insInt db 0CDH, "INT ", 0
    
    ; xxx mod yyy r/m 
    ;insEsc db 
     
    insUnknown db "NEPAZISTAMA",0

    register8Array db "AL", 0, "CL", 0, "DL", 0, "BL", 0, "AH", 0, "CH", 0, "DH", 0, "BH", 0
    register16Array db "AX", 0, "CX", 0, "DX", 0, "BX", 0, "SP", 0, "BP", 0, "SI", 0, "DI", 0
    segmentArray db "ES", 0, "CS", 0, "SS", 0, "DS", 0
    modArray db 000B, "BX+SI", 0, 001B, "BX+DI", 0, 010B, "BP+SI", 0, 011B, "BP+DI", 0, 100B, "SI", 0, 101B, "DI", 0, 110B, "BP", 0, 111B, "BX", 0

    wordPtr db "WORD PTR ", 0
    bytePtr db "BYTE PTR ", 0
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    d db 0 ; d = s = v
    w db 0
    modd db 0
    reg db 0
    rm db 0
    needWordBytePtr db 0
    instructionHex db 0
    
.code



TESTING1 macro
    mov ah, 9
    lea dx, [testmsg1]
    int 21h
endm 

TESTING2 macro
    mov ah, 9
    lea dx, [testmsg2]
    int 21h
endm 

TESTING3 macro
    mov ah, 9
    lea dx, [testmsg3]
    int 21h
endm 

APPEND_ARRAY_MNEMONIC macro array, index
    push ax bx
    lea bx, [array + index]
    call copy_string_mnemonic
    pop bx ax
endm

; macro vienam kableliu su tarpu padeti output buferyje
APPEND_COMMA_MNEMONIC macro
    push ax
    mov al, ','
    call append_char_mnemonic
    PUT_CHAR_MNEMONIC ' '
    pop ax
endm 

; macro vienam char padeti mnemonic buferyje
PUT_CHAR_MNEMONIC macro char
    push ax
    mov al, char
    call append_char_mnemonic
    pop ax
endm 

; macro vienam char padeti output buferyje
PUT_CHAR_OUTPUT macro char
    push ax
    mov al, char
    call append_char_output
    pop ax
endm 

; Macro tarpu dejimui iki endpos ouput buferyje
APPEND_SPACES_OUTPUT macro endPos
    local append_loop
    push cx ax
    mov cx, endPos
    sub cx, [outputbuffpos]
    mov al, ' '
    append_loop:
        call append_char_output
        loop append_loop
    pop ax cx
endm 

; Macro pasirinkti tinkamam(8 ar 16 bitu) registrui ir ji prideti
APPEND_CORRECT_REGISTER macro index
    local reg8, reg16, end
    cmp w, 0
    je reg8
    reg16:
        APPEND_ARRAY_MNEMONIC register16Array, index
        jmp end
    reg8:
        APPEND_ARRAY_MNEMONIC register8Array, index
        jmp end 
    end:
endm

READ_APPEND_HEX_WORD macro appendProcedure
    call read_input_byte
    push ax
    call read_input_byte
    APPEND_HEX_BYTE al, appendProcedure
    pop ax
    APPEND_HEX_BYTE al, appendProcedure
    PUT_CHAR_MNEMONIC 'h'
endm 

READ_APPEND_HEX_BYTE macro appendProcedure
    call read_input_byte
    APPEND_HEX_BYTE al, appendProcedure
endm 

; macro baito isvertimui i ascii hex ir pridejimui i output arba mnemonic buff
APPEND_HEX_BYTE macro value, appendProcedure
    local hex_convert_loop, hex_letter, append_hex_ascii
    push ax cx
    mov ah, value
    mov cx, 2
    
    hex_convert_loop:
        xor al, al
        rol ax, 4

        cmp al, 9
        jbe hex_letter
        
        add al, 'A' - 10    ;  ABCDEF 
        jmp append_hex_ascii
        
        hex_letter:
            add al, '0'  ; 0123456789
        
        append_hex_ascii:
            call appendProcedure
        
        loop hex_convert_loop
    pop cx ax
endm

; Macro paziurinti ar instrukcija priklauso masyvui, kurio instrukcijos pirmas baitas vienodas
THREE_BYTES_SEARCH macro firstByte, firstByteDiff, instructionArraySize, instructionArray, maxInstructionDifference, nextOperation
    local skip_this
    cmp al, firstByte
    jb skip_this
    mov dl, firstByte
    add dl, firstByteDiff
    cmp al, dl
    ja skip_this
    call read_input_byte

    call get_mod
    call get_reg
    call get_rm
    mov al, reg
    SEARCH_FOR_INSTRUCTION instructionArraySize, instructionArray, maxInstructionDifference, nextOperation
    skip_this:
endm

; Macro padedanti ieskoti instrukcijos masyvuose pagal pirma instrukcijos baita
SEARCH_FOR_INSTRUCTION macro instructionArraySize, instructionArray, maxInstructionDifference, nextOperation
    local searching_instructions, continue_searching, end_searching

    mov cx, instructionArraySize
    lea bx, instructionArray
    
    searching_instructions:
        cmp al, [bx]
        jb end_searching
        mov dh, [bx]
        add dh, maxInstructionDifference
        cmp al, dh
        ja continue_searching
        inc bx
        call copy_string_mnemonic ; issaugoti mneomonic

        call nextOperation ; testi instrukcijos skaityma

        jmp print_output
        
        continue_searching:
            call get_next_element
        
        loop searching_instructions
    end_searching:

endm

; copy string until 0
; PARAM: bx(adress to the start of string)
proc copy_string_mnemonic
    push ax bx dx
    copy_array_loop_mnemonic:
        mov al, [bx]
        cmp al, 0
        je end_copying_element
        call append_char_mnemonic
        inc bx
         
        jne copy_array_loop_mnemonic
        
    end_copying_element:

    pop dx bx ax
    ret
copy_string_mnemonic endp

; copy string until end (cx = 0)
; PARAM: bx(adress to the start of string), cx (size of array)
proc copy_string_output
    push ax bx dx cx
    copy_array_loop_ouput:
        mov al, [bx]
        call append_char_output
        inc bx 
        loop copy_array_loop_ouput
        
    pop cx dx bx ax
    ret
copy_string_output endp

; sudanda mod masyve, bx - i masyvo elemento mnemonic
proc search_mod
    push cx ax
    lea bx, modArray
    mov cx, modArraySize
    searching_mod:
        mov al, [bx]
        cmp al, rm
        jne continue_searching_mod
        inc bx
        pop ax cx
        ret
        continue_searching_mod:
            call get_next_element
        loop searching_mod
    pop  ax cx
    ret
search_mod endp

; Gaunamas naujas masyvo elementas
; PARAM: bx(andresas i kazkuri masyva)
proc get_next_element
    nex_element_loop:
    inc bx
    cmp byte ptr [bx], 0
    jne nex_element_loop
    inc bx ; dabar bx rodo i 0, tai padidinti vienu, jog rodytu sesiokliktaine reiksme
    ret
get_next_element endp

; Atspausdina info ir terminuoja programą, kai pirmi 2 komandos eilutės eilutės batai \?
proc check_help 
    cmp es:[82h], '?/'
    jne not_help
    cmp byte ptr es:[84h], 13 ; carriage return
    jne not_help
    call print_info_msg

    not_help:
        ret
check_help endp

proc print_info_msg 
    mov ah, 9
    lea dx, [infoMsg]
    int 21h

    call terminate_program
print_info_msg endp

; Praleidžia space komandos eilutėje
; PARAM: bx(dabartinė komandos eilutės pozicija)
proc skip_spaces 
    push ax
    check_space:
    mov al, es:[bx]
    cmp al, 20h ; ar space
    jne not_space
    inc bx
    loop check_space
    not_space:
        pop ax
        ret
skip_spaces endp

; Nuskaito komandos eilutės vieną argumentą, kiekvienas baitas, esantis es pozicijoje bx nukopijuojamas į si
; PARAM: si(adresas i inputFileName/outputFileName), bx(dabartinė komandos eilutės pozicija)
proc read_command_line_argument
    push ax
    xor al, al
    copy_byte:
        cmp byte ptr es:[bx], 13 ; carriage return
        je end_reading_line
        cmp byte ptr es:[bx], 20h ; space
        je end_reading_line
        mov al, byte ptr es:[bx]
        mov [si], al
        
        inc si
        inc bx
        loopne copy_byte
    end_reading_line:
    pop ax
    ret
read_command_line_argument endp

; atidaro faila ir grazina file handle ax registre
; Jei nepavyko atidaryti, atspausdina pranesima ir terminuoja programa
; PARAM: dx(failo pavadinimas)
proc setup_input_file 
    mov ax, 3D00h
    int 21h
    jc input_error
    ret

    input_error:
        mov ah, 9
        lea dx, inputFileErrorMsg
        int 21h
        call terminate_program
setup_input_file endp

; atidaro faila ir grazina file handle ax registre
; Jei nepavyko atidaryti, atspausdina pranesima ir terminuoja programa
; PARAM: dx(failo pavadinimas)
proc setup_output_file
    mov ax, 3C00h
    xor cx,cx
    lea dx, outputFileName
    int 21h
    jc @@output_error
    mov outputFileHandle, ax
    ret

    @@output_error:
        mov ah, 9
        lea dx, outputFileErrorMsg
        int 21h
        call terminate_program
setup_output_file endp

; PARAM: bx(file handle)
proc close_file 
    mov ah, 3Eh
    int 21h
    ret
close_file endp

; Atspausdina neteisingu argumentu zinute ir terminuoja programa,
; kai komandos eilutes argumentai neteisingi(maŽiau nei 2 argumentai ir ne \?)
proc invalid_arguments 
    mov ah, 9
    lea dx, [infoMsg]
    int 21h

    call terminate_program
invalid_arguments endp

; Nuskaito iš nurodyto failo max 255 baitus į bufferį
; PARAM: bx(file handle) dx(input bufferis)
proc read_file_to_buffer 
    mov ah, 3Fh
    mov cx, inputBuffSize
    int 21h
    ret
read_file_to_buffer endp

; Įrašo dabartinį skaitomą failo baitą į registrą al
; Jei failas pasiekė pabaigą, readingstatus padidinamas vienetu
proc read_input_byte
    cmp [inputBuffBytesLeft], 0 ; jei buferis tusščas bandyti, toliau skaityti į failo
    jne read_input_buff_byte  ; jei netuščias, iš buferio skaityti į registrą al 

    mov bx, [inputFileHandle]
    lea dx, inputBuff
    call read_file_to_buffer

    cmp ax, 0 ; failo pabaiga?
    je file_end
    
    ; iš naujo nustatyti buferį
    mov [inputBuffBytesLeft], ax
    mov [inputBuffPos], 0

    read_input_buff_byte: ; nuskaityti baitą iš buferio į registrą al
        xor ax, ax
        mov bx, [inputBuffPos]
        mov al, inputBuff[bx]
        dec [inputBuffBytesleft]
        inc [inputBuffPos]
        inc [codebytepos]
        APPEND_HEX_BYTE al, append_char_output
    ret
              
    file_end:      
        mov bx, [inputfilehandle] 
        call close_file
        mov bx, [outputfilehandle]
        call close_file

        call terminate_program  
read_input_byte endp

; Pridėti baitą al į išvesties bufferi
; PARAM: al(baitas, kurį norime atspausdinti)
proc append_char_output
    push bx

    mov bx, [outputBuffPos]
    mov [outputBuff + bx], al
    inc [outputBuffPos]

    pop bx
    ret
append_char_output endp

; Pridėti baitą al į mnemonikos bufferi
; PARAM: al(baitas, kurį norime atspausdinti)
proc append_char_mnemonic
    push bx

    mov bx, [mnemonicbuffpos]
    mov [mnemonicbuff + bx], al
    inc [mnemonicbuffpos]

    pop bx
    ret
append_char_mnemonic endp

; Atspausdina į išvesties failą išvesties buferio turinį
proc fprint_line
    mov al,  0dh ; carriage return
    call append_char_output
    mov al,  0ah ; line feed
    call append_char_output
    mov ah, 40h
    mov bx, [outputfilehandle]
    mov cx, [outputBuffPos]
    lea dx, [outputBuff]
    int 21h

    mov [outputBuffPos], 0
    mov [mnemonicbuffpos], 0
    ret
fprint_line endp

proc terminate_program
    mov ax, 4c00h
    int 21h
terminate_program endp

; Prideda posicija i buferi su formatu
proc append_pos
    push ax cx bx
    
    mov cx, 2
    lea bx, [segmentarray+3]
    call copy_string_output
    PUT_CHAR_OUTPUT ':'

    mov ax, [codeBytePos]
    APPEND_HEX_BYTE ah, append_char_output
    APPEND_HEX_BYTE al, append_char_output

    PUT_CHAR_OUTPUT ':'
    PUT_CHAR_OUTPUT ' '

    pop bx cx ax
    ret
append_pos endp

; Gaunu d ir w
; PARAM: al
proc get_dw
    mov d, al
    shr d, 1
    and d, 00000001b
    mov w, al
    and w, 00000001b
    ret
get_dw endp

; Naudojama kai nuskaitomos 1 baito instrukcijos - daugiau nieko daryti nereikia
proc skip_proc
    ret
skip_proc endp

; Naudojama kai nuskaitomos 2 baito instrukcijos nereikalaujancios papildomu zingsniu
proc skip_byte
    call read_input_byte
    ret
skip_byte endp


; suformatuoja likusią in/out instrukcijų dalį
proc inOut_analysis     
    push ax
    READ_APPEND_HEX_BYTE append_char_output
    mov [instructionhex], al
    pop ax
   
    cmp al, 0E6H ; is out? 
    jae is_out
    is_in:
        APPEND_HEX_BYTE instructionhex, append_char_mnemonic
        PUT_CHAR_MNEMONIC 'h'
        APPEND_COMMA_MNEMONIC
        APPEND_CORRECT_REGISTER 0
        ret

    is_out:
        APPEND_CORRECT_REGISTER 0
        APPEND_COMMA_MNEMONIC
        APPEND_HEX_BYTE instructionhex, append_char_mnemonic
        PUT_CHAR_MNEMONIC 'h'
        
        ret
inOut_analysis endp


proc get_mod
    mov modd, al
    shr modd, 6
    and modd, 00000011b ; no point in this case because remaining are zero cuz of shr
    ret
get_mod endp

proc get_reg 
    mov reg, al
    shr reg, 3
    and reg, 00000111b 
    ret
get_reg endp

proc get_rm
    mov rm, al
    and rm, 00000111b
    ret
get_rm endp

; PARAM: bx (reg index)
proc get_reg_index
    xor ax, ax
    mov al, [reg]
    mov bl, 3
    mul bl
    mov bx, ax
    ret
get_reg_index endp

proc append_rm
    cmp modd, 11b
    je rm_reg
    cmp modd, 00b
    je efficient_add_1
    jmp efficient_add_2
    rm_reg:
        mov bh, rm
        mov reg, bh
        call get_reg_index
        APPEND_CORRECT_REGISTER bx
    ret  

    efficient_add_1:
        cmp needwordbyteptr, 0
        je rm2_no_ptr
        APPEND_ARRAY_MNEMONIC bytePtr, 0
        rm2_no_ptr:
        PUT_CHAR_MNEMONIC '['
        cmp rm, 110b
        jne not_direct_address
        cmp modd, 00b
        jne not_direct_address
        READ_APPEND_HEX_WORD append_char_mnemonic
        jmp append_rm_end

        not_direct_address:
            call search_mod
            call copy_string_mnemonic
            jmp append_rm_end
    
    efficient_add_2:
        cmp [needwordbyteptr], 0
        je rm1_no_ptr
        cmp modd, 01b
        je rm_append_bytePtr
        APPEND_ARRAY_MNEMONIC wordPtr, 0
        jmp rm1_no_ptr
        rm_append_bytePtr:
            APPEND_ARRAY_MNEMONIC bytePtr, 0
        rm1_no_ptr:
            PUT_CHAR_MNEMONIC '['
            call search_mod
            call copy_string_mnemonic
            PUT_CHAR_MNEMONIC '+'
            cmp modd, 01b
            je read_offset_byte
            READ_APPEND_HEX_WORD append_char_mnemonic
            jmp append_rm_end
            read_offset_byte:
            READ_APPEND_HEX_BYTE append_char_mnemonic
            PUT_CHAR_MNEMONIC 'h'
            jmp append_rm_end
    
    append_rm_end:
    PUT_CHAR_MNEMONIC ']'
    ret
append_rm endp

proc modRegRM_analysis
    mov w, 1

    call read_input_byte

    call get_mod
    call get_reg
    call get_rm

    call get_reg_index
    APPEND_CORRECT_REGISTER bx
    APPEND_COMMA_MNEMONIC

    mov needWordBytePtr, 0
    call append_rm

    ret
modRegRM_analysis endp

proc threeBitsWModRM_analysis
    mov needwordbyteptr, 1
    cmp reg, 000b
    je threeBitsWModRM_test
   
    call append_rm
    ret

    threeBitsWModRM_test:
        call append_rm
        APPEND_COMMA_MNEMONIC
        call append_immediate_data
    ret
threeBitsWModRM_analysis endp

proc append_immediate_data
    cmp w, 1
    je imm_word
        READ_APPEND_HEX_BYTE append_char_mnemonic
        PUT_CHAR_MNEMONIC 'h'
        ret
    imm_word:
        READ_APPEND_HEX_WORD append_char_mnemonic
        ret
append_immediate_data endp

proc threeBitsVWModRM_analysis
    mov needwordbyteptr, 1
    call append_rm
    APPEND_COMMA_MNEMONIC
    cmp d, 1 ; d = v
    je v_cl
    PUT_CHAR_MNEMONIC '1'
    ret
    v_cl:
    APPEND_ARRAY_MNEMONIC register8Array, 4
    ret
threeBitsVWModRM_analysis endp

proc threeBitsSWModRM_analysis
    mov needwordbyteptr, 1
    call append_rm
    APPEND_COMMA_MNEMONIC
    
    cmp w, 1
    je threeBitsSWModRM_exception
    
    call append_immediate_data
    ret
    
    threeBitsSWModRM_exception:
    cmp d, 1
    je threeBitsSWModRM_expanded8bits
    call append_immediate_data
    ret

    threeBitsSWModRM_expanded8bits:
    call read_input_byte
    cbw
    APPEND_HEX_BYTE ah, append_char_mnemonic
    APPEND_HEX_BYTE al, append_char_mnemonic
    PUT_CHAR_MNEMONIC 'h'
    ret
threeBitsSWModRM_analysis endp
    
proc threeBitsModRM_analysis
    mov needwordbyteptr, 1 
    call append_rm
    ret
threeBitsModRM_analysis endp

proc wOpOp_analysis
    APPEND_CORRECT_REGISTER 0
    APPEND_COMMA_MNEMONIC
    call append_immediate_data
    ret
wOpOp_analysis endp

proc wModRegRM_analysis
    mov needWordBytePtr, 1 
    call read_input_byte
    call get_mod
    call get_reg
    call get_rm
    
    call append_rm
    APPEND_COMMA_MNEMONIC
    call get_reg_index
    APPEND_CORRECT_REGISTER bx
    ret
wModRegRM_analysis endp

proc dWModRegRM_analysis
    mov needWordBytePtr, 1
    call read_input_byte
    call get_mod
    call get_reg
    call get_rm
    cmp d, 1
    je dWModRegRM_rev

    call get_reg_index
    APPEND_CORRECT_REGISTER bx
    APPEND_COMMA_MNEMONIC
    call append_rm
    ret
    dWModRegRM_rev:
    call append_rm
    APPEND_COMMA_MNEMONIC
    call get_reg_index
    APPEND_CORRECT_REGISTER bx
    ret
dWModRegRM_analysis endp

proc jumpsOffset_analysis
    xor ax, ax
    call read_input_byte
    cmp ax, 127 ; [-128, 127]
    ja jumpsOffset_before
    add ax, codeBytePos
    APPEND_HEX_BYTE ah append_char_mnemonic
    APPEND_HEX_BYTE al append_char_mnemonic
    PUT_CHAR_MNEMONIC 'h'
    ret
    jumpsOffset_before: ; calculate negative offset
        not ax
        inc ax
        mov dx, ax
        mov ax, codeBytePos
        sub ax, 100h
        sub ax, dx
        APPEND_HEX_BYTE ah append_char_mnemonic
        APPEND_HEX_BYTE al append_char_mnemonic
        PUT_CHAR_MNEMONIC 'h'
        ret
jumpsOffset_analysis endp

main:
    mov ax, @data
    mov ds, ax
    
    call check_help

    ;;;;;;;;;;;;;;;;;;;;;;; KOMANDOS EILUTĖS ARGUMENTŲ SKAITYMAS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    xor cx, cx
    mov cl, es:[80h] ; ilgis 
    cmp cx, 0
    jne read_argument1
    call invalid_arguments
    
    read_argument1:
        mov bx, 82h ; pirmas simbolis po space
        mov si, offset inputFileName
        call skip_spaces
        call read_command_line_argument
        cmp cx, 1
        jne read_argument2

    call invalid_arguments
    
    read_argument2:
        mov si, offset outputFileName
        call skip_spaces
        call read_command_line_argument

    ;;;;;;;;;;;;;;;;;;;;;;; FAILŲ PARUOŠIMAS, ATIDARYMAS, HANDLES GAVIMAS ;;;;;;;;;;;;;;;;;;;;;
    
    lea dx, inputFileName
    call setup_input_file
    mov inputFileHandle, ax

    lea dx, outputFileName
    call setup_output_file
    mov outputFileHandle, ax

    ;;;;;;;;;;;;;;;;;;;;;;; NAUJOS KOMANDOS ANALIZE ;;;;;;;;;;;;;;;;;
    main_loop:
        call append_pos
        APPEND_SPACES_OUTPUT hexCodePos

        call read_input_byte
        
        
        call get_DW

        mov [instructionhex], al
        SEARCH_FOR_INSTRUCTION oneByteInstructionArraySize1, oneByteInstructionArray1, 0, skip_proc
        SEARCH_FOR_INSTRUCTION oneByteInstructionArraySize2, oneByteInstructionArray2, 0, skip_proc

        SEARCH_FOR_INSTRUCTION twoByteInstructionArraySize, twoByteInstructionArray, 0, skip_byte

        SEARCH_FOR_INSTRUCTION inOutArraySize, inOutArray, 1 inOut_analysis
        SEARCH_FOR_INSTRUCTION modRegRMArraySize, modRegRMArray, 0, modRegRM_analysis
        SEARCH_FOR_INSTRUCTION wOpOpArraySize, wOpOpArray, 1, wOpOp_analysis
        SEARCH_FOR_INSTRUCTION wModRegRMArraySize, wModRegRMArray, 1, wModRegRM_analysis 
        SEARCH_FOR_INSTRUCTION dWModRegRMArraySize, dWModRegRMArray, 3, dWModRegRM_analysis
        SEARCH_FOR_INSTRUCTION jumpsOffsetArraySize, jumpsOffsetArray, 0 jumpsOffset_analysis

        THREE_BYTES_SEARCH 0F6h, 1, threeBitsWModRMArraySize, threeBitsWModRMArray, 0, threeBitsWModRM_analysis
        THREE_BYTES_SEARCH 0D0h, 3, threeBitsVWModRMArraySize, threeBitsVWModRMArray, 0,  threeBitsVWModRM_analysis
        THREE_BYTES_SEARCH 80h, 3, threeBitsSWModRMArraySize, threeBitsSWModRMArray, 0,  threeBitsSWModRM_analysis
        THREE_BYTES_SEARCH 0FFh, 0, threeBitsModRMArraySize, threeBitsModRMArray, 0,  threeBitsModRM_analysis
        
        
        unknown_instruction:
            lea bx, [insunknown]
            call copy_string_mnemonic
            jmp print_output

        print_output:
            APPEND_SPACES_OUTPUT mnemonicPos
            lea bx, [mnemonicbuff]
            mov cx, [mnemonicBuffPos]
            call copy_string_output
            call fprint_line ; output buferio išvestis į failą

        jmp main_loop
        
        call terminate_program
end main