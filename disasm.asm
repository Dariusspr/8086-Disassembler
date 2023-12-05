.model small
.stack 100h

inputBuffSize = 256

oneByteInstructionArraySize = 81
twoByteInstructionArraySize = 2


.data
    infoMsg db "usage: [inputFile] [outputFile]$"
    inputFileErrorMsg db "failed to open input file$"
    outputFileErrorMsg db "failed to create output file$"

    inputFileName db 40 dup (?)
    inputFileHandle dw ?
    inputBuff db inputBuffSize dup (?)
    inputBuffPos dw 0
    inputBuffbytesleft dw 0
    
    outputFileName db 40 dup (?)
    outputFileHandle dw ?
    outputBuff db 70 dup (?)
    outputBuffPos dw 0
    codeBytePos dw 100h

    ; Visos 1 baito instrukcijos, jų šešioliktainė reikšmė ir mnemonika
    oneByteInstructionArray db 6H, "PUSH ES", 0, 7H, "POP ES", 0, 0EH, "PUSH CS", 0, 16H, "PUSH SS", 0, 17H, "POP SS", 0, 1EH, "PUSH DS", 0, 1FH, "POP DS", 0, 27H, "DAA", 0, 2FH, "DAS", 0, 37H, "AAA", 0, 3FH, "AAS", 0, 40H, "INC AX", 0, 41H, "INC CX", 0, 42H, "INC DX", 0, 43H, "INC BX", 0, 44H, "INC SP", 0, 45H, "INC BP", 0, 46H, "INC SI", 0, 47H, "INC DI", 0, 48H, "DEC AX", 0, 49H, "DEC CX", 0, 4AH, "DEC DX", 0, 4BH, "DEC BX", 0, 4CH, "DEC SP", 0, 4DH, "DEC BP", 0, 4EH, "DEC SI", 0, 4FH, "DEC DI", 0, 50H, "PUSH AX", 0, 51H, "PUSH CX", 0, 52H, "PUSH DX", 0, 53H, "PUSH BX", 0, 54H, "PUSH SP", 0, 55H, "PUSH BP", 0, 56H, "PUSH SI", 0, 57H, "PUSH DI", 0, 58H, "POP AX", 0, 59H, "POP CX", 0, 5AH, "POP DX", 0, 5BH, "POP BX", 0, 5CH, "POP SP", 0, 5DH, "POP BP", 0, 5EH,"POP SI",0, 5FH, "POP DI",0, 98H, "CBW", 0, 99H, "CWD", 0, 9BH, "WAIT", 0, 9CH, "PUSHF", 0, 9DH, "POPF", 0, 9EH, "SAHF", 0, 9FH, "LAHF", 0, 0A4H, "MOVSB", 0, 0A5H, "MOVSW", 0, 0A6H, "CMPSB", 0, 0A7H, "CMPSW", 0, 0AAH, "STOSB", 0, 0ABH, "STOSW", 0, 0ACH, "LODSB", 0, 0ADH, "LODSW", 0, 0AEH, "SCASB", 0, 0AFH, "SCASW", 0, 0C3H, "RET", 0, 0CBH, "RET", 0, 0CCH, "INT 3H", 0, 0CEH, "INTO", 0, 0CFH, "IRET", 0, 0D7H, "XLAT", 0, 0ECH, "IN AL, DX", 0, 0EDH, "IN AX, DX", 0, 0EEH, "OUT DX, AL", 0, 0EFH, "OUT DX, AX", 0, 0F0H, "LOCK", 0, 0F2H, "REPNZ", 0, 0F3H, "REP", 0, 0F4H, "HLT", 0, 0F5H, "CMC", 0, 0F8H, "CLC", 0, 0F9H, "STC", 0, 0FAH, "CLI", 0, 0FBH, "STI", 0, 0FCH, "CLD", 0, 0FDH, "STD", 0
    ; Visos 2 baitų instrukcijos, nereikalaujančios papildomų veiksmų, jų pirmo baito šešioliktainė reikšmė ir mnemonika
    twoByteInstructionArray DB 0D4H, "AAM", 0, 0D5H, "AAD", 0, 


    d db 0
    w db 0

    insUnknown db "NEPAZISTAMA$"
.code

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
proc append_char 
    mov bx, [outputBuffPos]
    mov [outputBuff + bx], al
    inc [outputBuffPos]
    ret
append_char endp

; Atspausdina į išvesties failą išvesties buferio turinį
proc fprint_line
    mov al,  0dh ; carriage return
    call append_char
    mov al,  0ah ; line feed
    call append_char
    mov ah, 40h
    mov bx, [outputfilehandle]
    mov cx, [outputBuffPos]
    lea dx, [outputBuff]
    int 21h

    mov [outputBuffPos], 0
    ret
fprint_line endp

proc terminate_program
    mov ax, 4c00h
    int 21h
terminate_program endp

; Konvertuoja al i hex ascii ir prideda i output buferi
;PARAM: al
proc convertToHex
    push cx dx
    mov cx, 2
    
    hex_convert_loop:
        xor al,al
        rol ax, 4

        cmp al, 9
        jbe hex_letter
        
        add al, 'A' - 10    ;  ABCDEF 
        jmp append_hex_ascii
        
        hex_letter:
            add al, '0'  ; 0123456789
        
        append_hex_ascii:
            call append_char
        
        loop hex_convert_loop
        pop dx cx
    ret 
convertToHex endp

; Prideda posicija i buferi su formatu
proc append_pos
    push ax

    mov al, 'c'
    call append_char
    mov al, 's'
    call append_char
    mov al, ':'
    call append_char

    mov ax, [codeBytePos]
    call convertToHex
    mov al, ah
    call convertToHex

    mov al, ':'
    call append_char
    mov al, ' '
    call append_char
    
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

        call read_input_byte
        call get_dw



        call fprint_line ; buferio išvestis į failą

        jmp main_loop
        
        call terminate_program
end main