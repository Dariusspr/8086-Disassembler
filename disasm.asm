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
threeBitsWModRegRMArraySize = 7
threeBitsVWModRMArraySize = 7
threeBitsSWModRMArraySize = 8
jumpsOffsetArraySize = 21
threeBitsModRMArraySize = 5
threeBitswModRMArraySize = 2
jump2BOpArraySize = 2
jump4OpArraySize = 2
returnsArraySize = 2

; HEX MNEMONIC pradzios pozicijos isvesties buferyje
hexCodePos = 10
mnemonicPos = 20

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
    outputBuff db 70 dup (?)
    outputBuffPos dw 0
    codeBytePos dw 100h ; FIXME

    ;;;;;;;;;;;;;;;;;;; SUTVARKYTI(DIDEJIMO TVARKA) INSTRUKCIJOMS ATSPINDINTI REIKALINGI MASYVAI  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Instrukcijų pirmo baito šešioliktainė reikšmė ir mnemonika

    ; Visos 1 baito instrukcijos
    oneByteInstructionArray1 db 6H, "PUSH ES", 0, 7H, "POP ES", 0, 0EH, "PUSH CS", 0, 16H, "PUSH SS", 0, 17H, "POP SS", 0, 1EH, "PUSH DS", 0, 1FH, "POP DS", 0, 27H, "DAA", 0, 2FH, "DAS", 0, 37H, "AAA", 0, 3FH, "AAS", 0, 40H, "INC AX", 0, 41H, "INC CX", 0, 42H, "INC DX", 0, 43H, "INC BX", 0, 44H, "INC SP", 0, 45H, "INC BP", 0, 46H, "INC SI", 0, 47H, "INC DI", 0, 48H, "DEC AX", 0, 49H, "DEC CX", 0, 4AH, "DEC DX", 0, 4BH, "DEC BX", 0, 4CH, "DEC SP", 0, 4DH, "DEC BP", 0, 4EH, "DEC SI", 0, 4FH, "DEC DI", 0, 50H, "PUSH AX", 0, 51H, "PUSH CX", 0, 52H, "PUSH DX", 0, 53H, "PUSH BX", 0, 54H, "PUSH SP", 0, 55H, "PUSH BP", 0, 56H, "PUSH SI", 0, 57H, "PUSH DI", 0, 58H, "POP AX", 0, 59H, "POP CX", 0, 5AH, "POP DX", 0, 5BH, "POP BX", 0, 5CH, "POP SP", 0, 5DH, "POP BP", 0, 5EH, "POP SI", 0, 5FH, "POP DI", 0, 90h, "NOP", 0, 91h, "CXHG AX, CX", 0, 92h, "CXHG AX, DX", 0, 93h, "CXHG AX, BX", 0, 94h, "CXHG AX, SP", 0, 95h, "CXHG AX, BP", 0, 96h, "CXHG AX, SI", 0, 97h, "CXHG AX, DI", 0
    oneByteInstructionArray2 db 98H, "CBW", 0, 99H, "CWD", 0, 9BH, "WAIT", 0, 9CH, "PUSHF", 0, 9DH, "POPF", 0, 9EH, "SAHF", 0, 9FH, "LAHF", 0, 0A4H, "MOVSB", 0, 0A5H, "MOVSW", 0, 0A6H, "CMPSB", 0, 0A7H, "CMPSW", 0, 0AAH, "STOSB", 0, 0ABH, "STOSW", 0, 0ACH, "LODSB", 0, 0ADH, "LODSW", 0, 0AEH, "SCASB", 0, 0AFH, "SCASW", 0, 0C3H, "RET", 0, 0CBH, "RET", 0, 0CCH, "INT 3H", 0, 0CEH, "INTO", 0, 0CFH, "IRET", 0, 0D7H, "XLAT", 0, 0ECH, "IN AL, DX", 0, 0EDH, "IN AX, DX", 0, 0EEH, "OUT DX, AL", 0, 0EFH, "OUT DX, AX", 0, 0F0H, "LOCK", 0, 0F2H, "REPNZ", 0, 0F3H, "REP", 0, 0F4H, "HLT", 0, 0F5H, "CMC", 0, 0F8H, "CLC", 0, 0F9H, "STC", 0, 0FAH, "CLI", 0, 0FBH, "STI", 0, 0FCH, "CLD", 0, 0FDH, "STD", 0
    ; Visos 2 baitų instrukcijos, nereikalaujančios papildomų veiksmų
    twoByteInstructionArray Db 0D4H, "AAM", 0, 0D5H, "AAD", 0
    ; In/Out instrukcijos
    inOutArray db 0E4H, "IN ", 0, 0E6H, "OUT ", 0
    ; mod reg r/m instrukcijos
    modRegRMArray db 8DH, "LEA ", 0, 0C4H, "LES ", 0, 0C5H, "LDS ", 0
    ; w op op instrukcijos
    wOpOpArray db 4H, "ADD ", 0, 0CH, "OR ", 0, 14H, "ADC ", 0, 1CH, "SBB ", 0, 24H, "AND ", 0, 2CH, "SUB ", 0, 34H, "XOR ", 0, 3CH, "CMP ", 0, 0A8H, "TEST ", 0
    ; w mod reg r/m  instrukcijos
    wModRegRMArray db 84H, "TEST ", 0, 86H, "XCHG ", 0
    ; dw mod reg r/m instrukcijos
    dWModRegRMArray db 0H, "ADD ", 0, 08H, "OR ", 0, 10H, "ADC ", 0, 18H, "SBB ", 0, 20H, "AND ", 0, 28H, "SUB ", 0, 30H, "XOR ", 0, 38H, "CMP ", 0, 88H, "MOV ", 0
    ; 1111 011 w mod xxx r/m instrukcijos
    threeBitsWModRegRMArray db 000B, "TEST", 0, 010B, "NOT ", 0, 011B, "NEG ", 0, 100B, "MUL ", 0, 101B, "IMUL ", 0, 110B, "DIV ", 0, 111B, "IDIV ", 0
    ; 1101 00 vw mod xxx r/m instrukcijos
    threeBitsVWModRMArray db 000B, "ROL ", 0, 001B, "ROR ", 0, 010B, "RCL ", 0, 011B, "RCR ", 0, 100B, "SHL ", 0, 101B, "SHR ", 0, 111B, "SAR ", 0
    ; 1000 00 sw mod xxx r/m instrukcijos
    threeBitsSWModRMArray db 000B, "ADD ", 0, 001B, "OR ", 0, 010B, "ADC ", 0, 011B, "SBB ", 0, 100B, "AND ", 0, 101B, "SUB ", 0, 110B, "XOR ", 0, 111B, "CMP ", 0
    ; jumps + offset instrukcijos
    jumpsOffsetArray db 70H, "JO ", 0, 71H, "JNO ", 0, 72H, "JB ", 0, 73H, "JNB ", 0, 74H, "JE ", 0, 75H, "JNE ", 0, 76H, "JNA ", 0, 77H, "JA ", 0, 78H, "JS ", 0, 79H, "JNS ", 0, 7AH, "JP ", 0, 7BH, "JNP ", 0, 7CH, "JL ", 0, 7DH, "JNL ", 0, 7EH, "JLE ", 0, 7FH, "JG ", 0, 0E0H, "LOOPNE ", 0, 0E1H, "LOOPE ", 0, 0E2H, "LOOP ", 0, 0E3H, "JCXZ ", 0, 0EBH, "JMP ", 0 
    ; 1111 1111 mod xxx r/m instrukcijos
    threeBitsModRMArray db 010B, "CALL ", 0, 011B, "CALL ", 0, 100B, "JMP ", 0, 101B, "JMP ", 0, 110B, "PUSH ", 0
    ; 1111 111w mod xxx r/m
    threeBitswModRMArray db 000B, "INC ", 0, 001B, "DEC ", 0
    ; Jump/call 2 bytes op
    jump2BOpArray db 0E8H, "CALL ", 0, 0E9H, "JMP ", 0
    ; Jumps/call 4 bytes op
    jump4OpArray db 9AH, "CALL ", 0, 0EAH, "JMP ", 0
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
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    d db 0
    w db 0
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

; macro vienam tarpui padeti output buferyje
APPEND_SPACE_OUTPUT macro
    push ax
    mov al, ' '
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

; Macro appendConvertedHex pridejimui
APPEND_INSTRUCTION_BYTE macro value
    push ax
    mov ah, value
    call append_converted_hex
    pop ax
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
        mov dh, [bx]
        mov [instructionhex], dh ; issaugoti hex

        APPEND_INSTRUCTION_BYTE dh
        APPEND_SPACE_OUTPUT

        inc bx
        call copy_string_mnemonic ; issaugtoi mneomonic

        call nextOperation ; testi instrukcijos skaityma

        jmp print_output
        
        continue_searching:
            call get_next_element
        
        loop searching_instructions
    end_searching:

endm

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

; PARAM: bx(adress to the start of string), cx (size of array)
proc copy_string_output
    push ax bx dx cx
    copy_array_loop_ouput:
        mov al, [bx]
        cmp al, 0

        call append_char_output
        inc bx 
        loop copy_array_loop_ouput
        
    pop cx dx bx ax
    ret
copy_string_output endp

; Gaunamas naujas masyvo elementas
; PARAM: bx(andresas i kazkur instrukciju masyva)
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

; Konvertuoja ah i hex ascii ir prideda i output buferi
; PARAM: ah
proc append_converted_hex
    push ax cx dx
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
            call append_char_output
        
        loop hex_convert_loop
        pop dx cx ax
    ret 
append_converted_hex endp

; Prideda posicija i buferi su formatu
proc append_pos
    push ax


    mov al, 'c'
    call append_char_output
    mov al, 's'
    call append_char_output
    mov al, ':'
    call append_char_output

    mov ax, [codeBytePos]
    call append_converted_hex
    mov ah, al
    call append_converted_hex

    mov al, ':'
    call append_char_output
    mov al, ' '
    call append_char_output

    pop ax
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
        
        
        call get_dw

        ; Visos 1 baito instrukcijos
        SEARCH_FOR_INSTRUCTION oneByteInstructionArraySize1, oneByteInstructionArray1, 0, skip_proc
        SEARCH_FOR_INSTRUCTION oneByteInstructionArraySize2, oneByteInstructionArray2, 0, skip_proc
        ; 2 baitu nereikalaujancios papildomo darbo
        SEARCH_FOR_INSTRUCTION twoByteInstructionArraySize, twoByteInstructionArray, 0, read_input_byte ; skip 1 byte

        unknown_instruction:
            APPEND_INSTRUCTION_BYTE al
           
            lea bx, [insunknown]
            call copy_string_mnemonic
            jmp print_output

        compare_2_bytes:


        print_output:
            APPEND_SPACES_OUTPUT mnemonicPos
            lea bx, [mnemonicbuff]
            mov cx, [mnemonicBuffPos]
            call copy_string_output
            call fprint_line ; output buferio išvestis į failą

        jmp main_loop
        
        call terminate_program
end main