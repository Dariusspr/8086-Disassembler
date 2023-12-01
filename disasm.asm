.model small
.stack 100h

inputBuffSize = 256

.data
    infoMsg db "usage: [inputFile] [outputFile]", 24h
    inputFileErrorMsg db "failed to open input file", 24h
    outputFileErrorMsg db "failed to create output file", 24h

    inputFileName db 40 dup (?)
    inputFileHandle dw ?
    inputBuff db inputBuffSize dup (?)
    inputBuffPos dw 0
    inputBuffbytesleft dw 0
    
    outputFileName db 40 dup (?)
    outputFileHandle dw ?
    outputBuff db 60 dup (?)
    outputBuffPos dw 0
    
    
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
proc read_input
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
read_input endp

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
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    main_loop:
    
        call read_input


        call append_char


        call fprint_line ; buferio išvestis į failą

        jmp main_loop
        
        call terminate_program
end main