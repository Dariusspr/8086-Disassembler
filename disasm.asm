; Darius Spruogis
; 2023

.model small
.stack 100h

inputBuffSize = 256

; Sizes of arrays
oneByteInstructionArraySize1 = 51
oneByteInstructionArraySize2 = 39
twoByteInstructionArraySize = 2
inOutArraySize = 2
modRegRMArraySize = 3
wAccImmediateArraySize = 9
wModRegRMArraySize = 2
dWModRegRMArraySize = 9
threeBitsWModRMArraySize = 7
threeBitsVWModRMArraySize = 7
threeBitsSWModRMArraySize = 8
jumps1ByteArraySize = 21
threeBitsModRMArraySize = 7
jump2BytesArraySize = 2
jump4BytesArraySize = 2
returnsArraySize = 2
WAdrAdrArraySize = 2
modArraySize = 8
segmentArraySize = 4
; positions of output parts
hexCodePosition = 12 ; hexdecimal position
mnemonicPosition = 40 ; mnemonic intructions position

.data
    infoMsg db "usage: [inputFile] [outputFile]$"
    inputFileErrorMsg db "failed to open input file$"
    outputFileErrorMsg db "failed to create output file$"

    inputFileName db 40 dup (?)
    inputFileHandle dw ?
    inputBuff db inputBuffSize dup (?)
    inputBuffPos dw 0
    inputBuffbytesleft dw 0
    
    ; Temporary buffer for mnemonic part
    mnemonicBuff db 40 dup (?)
    mnemonicBuffPos dw 0

    outputFileName db 40 dup (?)
    outputFileHandle dw ?
    outputBuff db 100 dup (?)
    outputBuffPos dw 0
    codeBytePos dw 100h


    ; Flags
    d db 0 ; d = s = v
    w db 0
    modd db 0
    reg db 0 ; reg = sreg
    rm db 0
    prefix db 0

    instructionHex db 0 ; temporary variable to save byte

    ;;;;;;;;;;;;;;;;;;; INSTRUCTIONS ARRAYS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ; Array element - instruction's value of the first byte and instruction's mnemonic
    ; Instruction are grouped by their operands in increasing order(value of first byte) in arrays
    oneByteInstructionArray1 db 6H, "PUSH ES", 0, 7H, "POP ES", 0, 0EH, "PUSH CS", 0, 16H, "PUSH SS", 0, 17H, "POP SS", 0, 1EH, "PUSH DS", 0, 1FH, "POP DS", 0, 27H, "DAA", 0, 2FH, "DAS", 0, 37H, "AAA", 0, 3FH, "AAS", 0, 40H, "INC AX", 0, 41H, "INC CX", 0, 42H, "INC DX", 0, 43H, "INC BX", 0, 44H, "INC SP", 0, 45H, "INC BP", 0, 46H, "INC SI", 0, 47H, "INC DI", 0, 48H, "DEC AX", 0, 49H, "DEC CX", 0, 4AH, "DEC DX", 0, 4BH, "DEC BX", 0, 4CH, "DEC SP", 0, 4DH, "DEC BP", 0, 4EH, "DEC SI", 0, 4FH, "DEC DI", 0, 50H, "PUSH AX", 0, 51H, "PUSH CX", 0, 52H, "PUSH DX", 0, 53H, "PUSH BX", 0, 54H, "PUSH SP", 0, 55H, "PUSH BP", 0, 56H, "PUSH SI", 0, 57H, "PUSH DI", 0, 58H, "POP AX", 0, 59H, "POP CX", 0, 5AH, "POP DX", 0, 5BH, "POP BX", 0, 5CH, "POP SP", 0, 5DH, "POP BP", 0, 5EH, "POP SI", 0, 5FH, "POP DI", 0, 90h, "NOP", 0, 91h, "CXHG AX, CX", 0, 92h, "CXHG AX, DX", 0, 93h, "CXHG AX, BX", 0, 94h, "CXHG AX, SP", 0, 95h, "CXHG AX, BP", 0, 96h, "CXHG AX, SI", 0, 97h, "CXHG AX, DI", 0
    oneByteInstructionArray2 db 98H, "CBW", 0, 99H, "CWD", 0, 9BH, "WAIT", 0, 9CH, "PUSHF", 0, 9DH, "POPF", 0, 9EH, "SAHF", 0, 9FH, "LAHF", 0, 0A4H, "MOVSB", 0, 0A5H, "MOVSW", 0, 0A6H, "CMPSB", 0, 0A7H, "CMPSW", 0, 0AAH, "STOSB", 0, 0ABH, "STOSW", 0, 0ACH, "LODSB", 0, 0ADH, "LODSW", 0, 0AEH, "SCASB", 0, 0AFH, "SCASW", 0, 0C3H, "RET", 0, 0CBH, "RET", 0, 0CCH, "INT 3H", 0, 0CEH, "INTO", 0, 0CFH, "IRET", 0, 0D7H, "XLAT", 0, 0ECH, "IN AL, DX", 0, 0EDH, "IN AX, DX", 0, 0EEH, "OUT DX, AL", 0, 0EFH, "OUT DX, AX", 0, 0F0H, "LOCK", 0, 0F2H, "REPNZ", 0, 0F3H, "REP", 0, 0F4H, "HLT", 0, 0F5H, "CMC", 0, 0F8H, "CLC", 0, 0F9H, "STC", 0, 0FAH, "CLI", 0, 0FBH, "STI", 0, 0FCH, "CLD", 0, 0FDH, "STD", 0
    
    twoByteInstructionArray Db 0D4H, "AAM", 0, 0D5H, "AAD", 0
    
    modRegRMArray db 8DH, "LEA ", 0, 0C4H, "LES ", 0, 0C5H, "LDS ", 0
    wAccImmediateArray db 4H, "ADD ", 0, 0CH, "OR ", 0, 14H, "ADC ", 0, 1CH, "SBB ", 0, 24H, "AND ", 0, 2CH, "SUB ", 0, 34H, "XOR ", 0, 3CH, "CMP ", 0, 0A8H, "TEST ", 0
    wModRegRMArray db 84H, "TEST ", 0, 86H, "XCHG ", 0
    dWModRegRMArray db 0H, "ADD ", 0, 08H, "OR ", 0, 10H, "ADC ", 0, 18H, "SBB ", 0, 20H, "AND ", 0, 28H, "SUB ", 0, 30H, "XOR ", 0, 38H, "CMP ", 0, 88H, "MOV ", 0
    
    threeBitsWModRMArray db 000B, "TEST ", 0, 010B, "NOT ", 0, 011B, "NEG ", 0, 100B, "MUL ", 0, 101B, "IMUL ", 0, 110B, "DIV ", 0, 111B, "IDIV ", 0
    threeBitsVWModRMArray db 000B, "ROL ", 0, 001B, "ROR ", 0, 010B, "RCL ", 0, 011B, "RCR ", 0, 100B, "SHL ", 0, 101B, "SHR ", 0, 111B, "SAR ", 0
    threeBitsSWModRMArray db 000B, "ADD ", 0, 001B, "OR ", 0, 010B, "ADC ", 0, 011B, "SBB ", 0, 100B, "AND ", 0, 101B, "SUB ", 0, 110B, "XOR ", 0, 111B, "CMP ", 0
    threeBitsModRMArray db 000B, "INC ", 0, 001B, "DEC ", 0, 010B, "CALL ", 0, 011B, "CALL ", 0, 100B, "JMP ", 0, 101B, "JMP ", 0, 110B, "PUSH ", 0
   
    jumps1ByteArray db 70H, "JO ", 0, 71H, "JNO ", 0, 72H, "JB ", 0, 73H, "JAE ", 0, 74H, "JE ", 0, 75H, "JNE ", 0, 76H, "JNA ", 0, 77H, "JA ", 0, 78H, "JS ", 0, 79H, "JNS ", 0, 7AH, "JP ", 0, 7BH, "JNP ", 0, 7CH, "JL ", 0, 7DH, "JNL ", 0, 7EH, "JLE ", 0, 7FH, "JG ", 0, 0E0H, "LOOPNE ", 0, 0E1H, "LOOPE ", 0, 0E2H, "LOOP ", 0, 0E3H, "JCXZ ", 0, 0EBH, "JMP ", 0 
    jump2BytesArray db 0E8H, "CALL ", 0, 0E9H, "JMP ", 0
    jump4BytesArray db 9AH, "CALL ", 0, 0EAH, "JMP ", 0
    
    returnsArray db 0C2H, "RET ", 0, 0CAH, "RET ", 0
    inOutArray db 0E4H, "IN ", 0, 0E6H, "OUT ", 0

    wAdrAdrArray db 0A0H, "MOV ", 0, 0A2H, "MOV ", 0

    insWModRMOpOpMov db 0C6H, "MOV ", 0
    insWRegOpOpMov db 0B0H, "MOV ", 0
    insDModSregRMMov db 8CH, "MOV ", 0
    insModRMPop db 8FH, "POP ", 0
    insInt db 0CDH, "INT ", 0
    insUnknown db "UNKNOWN",0

    segmentArray db 26H, "ES", 0, 2EH, "CS", 0, 36H, "SS", 0, 3EH, "DS", 0
    register8Array db "AL", 0, "CL", 0, "DL", 0, "BL", 0, "AH", 0, "CH", 0, "DH", 0, "BH", 0
    register16Array db "AX", 0, "CX", 0, "DX", 0, "BX", 0, "SP", 0, "BP", 0, "SI", 0, "DI", 0
    modArray db 000B, "BX+SI", 0, 001B, "BX+DI", 0, 010B, "BP+SI", 0, 011B, "BP+DI", 0, 100B, "SI", 0, 101B, "DI", 0, 110B, "BP", 0, 111B, "BX", 0

    wordPtr db "WORD PTR ", 0
    bytePtr db "BYTE PTR ", 0
.code

; Append string from position [array + index] to mnemonic bufffer
APPEND_STRING_MNEMONIC macro array, index
    push ax bx
    lea bx, [array + index]
    call copy_string_mnemonic
    pop bx ax
endm

; Append  ", " to output buffer
APPEND_COMMA_MNEMONIC macro
    PUT_BYTE_MNEMONIC ','
    PUT_BYTE_MNEMONIC ' '
endm 

; Append byte to output buffer
PUT_BYTE_MNEMONIC macro BYTE
    push ax
    mov al, BYTE
    call append_BYTE_mnemonic
    pop ax
endm 

; Append byte to output buffer
PUT_BYTE_OUTPUT macro BYTE
    push ax
    mov al, BYTE
    call append_BYTE_output
    pop ax
endm 

; Append spaces in output buffer upto endpos position
APPEND_SPACES_OUTPUT macro endPos
    local append_loop
    push cx ax
    mov cx, endPos
    sub cx, [outputbuffpos]
    mov al, ' '
    append_loop:
        call append_BYTE_output
        loop append_loop
    pop ax cx
endm 

; Determines, what is the size of register(8 or 16bits), and appends it to mnemonic array
; position - register's position in array
APPEND_CORRECT_REGISTER macro position
    local reg8, reg16, end
    cmp w, 0
    je reg8
    reg16:
        APPEND_STRING_MNEMONIC register16Array, position
        jmp end
    reg8:
        APPEND_STRING_MNEMONIC register8Array, position
        jmp end 
    end:
endm

; Appends current segment register to mnemonic array
; position - segment's position in array
APPEND_SREG macro position
    APPEND_STRING_MNEMONIC segmentArray, position
endm

; Read one byte and append its hexadecimal value to some buffer
; append_BYTE_output - to output buffer, append_BYTE_mnemonic - to mnemonic buffer
READ_APPEND_HEX_BYTE macro appendProcedure
    call read_input_byte
    APPEND_HEX_BYTE al, appendProcedure
endm 

; Read two bytes and append their hexadecimal value to some buffer
; append_BYTE_output - to output buffer, append_BYTE_mnemonic - to mnemonic buffer
READ_APPEND_HEX_WORD macro appendProcedure
    call read_input_byte
    push ax
    call read_input_byte
    APPEND_HEX_BYTE al, appendProcedure
    pop ax
    APPEND_HEX_BYTE al, appendProcedure
    PUT_BYTE_MNEMONIC 'h'
endm 

; Convert al to hexadecimal ascii and append to some buffer
; append_BYTE_output - to output buffer, append_BYTE_mnemonic - to mnemonic buffer
APPEND_HEX_BYTE macro value, appendProcedure
    local hex_convert_loop, hex_letter, append_hex_ascii
    push ax cx
    mov ah, value
    call convert_hex
    call appendProcedure
    mov al, ah
    call appendProcedure
    pop cx ax
endm

; Used when you can't identify instruction by only its first byte
; Checks if current byte can be part of instruction array, where all instructions start with same byte
; If (firstByte <= current byte value(al) <= firstByte + firstbyteDiff) then this instruction belongs to the current array
; call SEARCH_FOR_INSTRUCTION to find instrucition by its second byte
THREE_BITS_SEARCH macro firstByte, firstByteDiff, instructionArraySize, instructionArray, maxInstructionDifference, nextOperation
    local skip_this
    ; check if byte(al) can be part of instruction in current array(instructionArray)
    cmp al, firstByte
    jb skip_this
    mov dl, firstByte
    add dl, firstByteDiff
    cmp al, dl
    ja skip_this

    call read_input_byte ; to get second byte of instruction

    call get_mod
    call get_reg
    call get_rm
    mov al, reg ; reg bits indicate instruction
    SEARCH_FOR_INSTRUCTION instructionArraySize, instructionArray, maxInstructionDifference, nextOperation
    skip_this:
endm

; To identify instruction by its first (sometimes second - check THREE_BITS_SEARCH) byte
; If (first instruction byte(dh) <= current byte value(al) <= first instruction byte(dh) + maxInstructionDifference) then instruction is found
; Bx points to instructionArray, and is used to get value of the first byte of instruction in the current array(instructionArray)
; If instruction is found, call procedure for further analysis of that instruction 
; Instructions are grouped in a way, that each element in array can be further analysed by the same procedure
SEARCH_FOR_INSTRUCTION macro instructionArraySize, instructionArray, maxInstructionDifference, nextOperation
    local searching_instructions, continue_searching, end_searching

    mov cx, instructionArraySize
    lea bx, instructionArray
    
    searching_instructions:
        ; check if byte(al) is the current instruction pointed by register bx
        cmp al, [bx]
        jb end_searching
        mov dh, [bx] ; store value of first byte of current instructon
        add dh, maxInstructionDifference
        cmp al, dh
        ja continue_searching

        inc bx
        call copy_string_mnemonic ; save mnemonic of given byte

        call nextOperation

        jmp print_output
        
        continue_searching:
            call get_next_element
        
        loop searching_instructions
    end_searching:

endm

; Search for rm mnemonic, given rm hex value(rm)
proc search_rm
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
search_rm endp

; Increment bx until its [bx] value is 0 - reaches end of current element in array
; PARAM: bx(adress of given buffer)
proc get_next_element
    nex_element_loop:
    inc bx
    cmp byte ptr [bx], 0
    jne nex_element_loop
    inc bx ; current [bx] is 0, so increment bx to point to hex value of instruction
    ret
get_next_element endp

; Copy byte of given buffer to mnemonic buffer
; Stops, when pointed byte is 0
; PARAM: bx(adress of given buffer)
proc copy_string_mnemonic
    push ax bx dx
    copy_array_loop_mnemonic:
        mov al, [bx]
        cmp al, 0
        je end_copying_element
        call append_BYTE_mnemonic
        inc bx
         
        jne copy_array_loop_mnemonic
        
    end_copying_element:

    pop dx bx ax
    ret
copy_string_mnemonic endp

; Copy cx'th bytes of given buffer to output buffer
; PARAM: bx(adress of given buffer), cx (bytes to copy)
proc copy_string_output
    push ax bx dx cx
    copy_array_loop_ouput:
        mov al, [bx]
        call append_BYTE_output
        inc bx 
        loop copy_array_loop_ouput
        
    pop cx dx bx ax
    ret
copy_string_output endp

; If first command line bytes are '?/' print info msg
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

; Skip spaces in command line
; PARAM: bx(current position in command line)
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

; Read command line's one argument to given buffer
; PARAM: si(inputFileName/outputFileName buffer), bx(current position in command line)
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

; Opens file and returns its handle
; If unsuccessful, print error msg, terminate
; PARAM: dx(file name)
; OUT: ax (file handle)
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

; Opens file and returns its handle
; If unsuccessful, print error msg, terminate
; PARAM: dx(file name)
; OUT: ax (file handle)
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

; Prints info msg, calls terminate_program
proc invalid_arguments 
    mov ah, 9
    lea dx, [infoMsg]
    int 21h

    call terminate_program
invalid_arguments endp

; From given file Read (max 255) bytes to input buffer
; PARAM: bx(file handle) dx(input buffer)
proc read_file_to_buffer 
    mov ah, 3Fh
    mov cx, inputBuffSize
    int 21h
    ret
read_file_to_buffer endp

; Saves current input byte to al
; If reached file end, terminate program
proc read_input_byte
    
    ; If input buffer is not empty, read from it
    ; else fill input buffer with file content
    cmp [inputBuffBytesLeft], 0
    jne read_input_buff_byte  
    
    mov bx, [inputFileHandle]
    lea dx, inputBuff
    call read_file_to_buffer

    cmp ax, 0
    je file_end
    
    ; Resets input buffer
    mov [inputBuffBytesLeft], ax
    mov [inputBuffPos], 0

    read_input_buff_byte: ; read to register al
        xor ax, ax
        mov bx, [inputBuffPos]
        mov al, inputBuff[bx]
        dec [inputBuffBytesleft]
        inc [inputBuffPos]
        inc [codebytepos]
        APPEND_HEX_BYTE al, append_BYTE_output
    ret
              
    file_end:      
        mov bx, [inputfilehandle] 
        call close_file
        mov bx, [outputfilehandle]
        call close_file
        
        call terminate_program  
read_input_byte endp

; PARAM: ah(current byte)
; OUT: ax (hexadecimal format)
proc convert_hex
    push bx cx
    xor bx, bx
    mov cx, 2
    hex_convert_loop:
        shr bx, 8
        xor al, al
        rol ax, 4

        cmp al, 9
        jbe hex_letter
        
        add al, 'A' - 10    ;  ABCDEF - value
        jmp append_hex_ascii
        
        hex_letter:
            add al, '0'  ; 0123456789 - value
        
        append_hex_ascii:
            mov bh, al

        loop hex_convert_loop
    mov ax, bx
    pop cx bx
    ret
convert_hex endp

; Append current byte to output buffer
; PARAM: al(current byte)
proc append_BYTE_output
    push bx

    mov bx, [outputBuffPos]
    mov [outputBuff + bx], al
    inc [outputBuffPos]

    pop bx
    ret
append_BYTE_output endp

; Append current byte to mnemonic buffer
; PARAM: al(current byte)
proc append_BYTE_mnemonic
    push bx

    mov bx, [mnemonicbuffpos]
    mov [mnemonicbuff + bx], al
    inc [mnemonicbuffpos]

    pop bx
    ret
append_BYTE_mnemonic endp

; Prints output buffer content in file
proc fprint_line
    mov al,  0dh ; carriage return
    call append_BYTE_output
    mov al,  0ah ; line feed
    call append_BYTE_output
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

; Appends cs:100, cs:101, cs:104...  to output buffer
proc append_pos
    push ax cx bx
    
    mov cx, 2
    lea bx, [segmentarray+5]
    call copy_string_output
    PUT_BYTE_OUTPUT ':'

    mov ax, [codeBytePos]
    APPEND_HEX_BYTE ah, append_BYTE_output
    APPEND_HEX_BYTE al, append_BYTE_output

    PUT_BYTE_OUTPUT ':'
    PUT_BYTE_OUTPUT ' '

    pop bx cx ax
    ret
append_pos endp

; PARAM: al
proc get_dw
    mov d, al
    shr d, 1
    and d, 00000001b
    mov w, al
    and w, 00000001b
    ret
get_dw endp

; PARAM: al
proc get_mod
    mov modd, al
    shr modd, 6
    and modd, 00000011b
    ret
get_mod endp

; PARAM: al
proc get_reg 
    mov reg, al
    shr reg, 3
    and reg, 00000111b 
    ret
get_reg endp

; PARAM: al
proc get_rm
    mov rm, al
    and rm, 00000111b
    ret
get_rm endp

; Gets position of reg'th register in segmentArray
; PARAM: reg
proc get_reg_pos
    xor ax, ax
    mov al, [reg]
    mov bl, 3
    mul bl
    mov bx, ax
    ret
get_reg_pos endp

; Gets position of reg'th segment in segmentArray
; PARAM: reg
proc get_sreg_pos
    xor ax, ax
    mov al, [reg]
    mov bl, 4
    mul bl
    mov bx, ax
    inc bx
    ret
get_sreg_pos endp

; Adds rm part to mnemonic buffer
proc append_rm
    cmp modd, 11b
    je rm_reg
    cmp modd, 00b
    je efficient_add_1
    jmp efficient_add_2
    rm_reg: ; if register
        mov bh, rm
        mov reg, bh
        call get_reg_pos
        APPEND_CORRECT_REGISTER bx
    ret  

    efficient_add_1: ; without offset
        APPEND_STRING_MNEMONIC bytePtr, 0
        
        ; adds prefix, if exists
        xor dx, dx
        cmp dl, prefix
        je append_rm_skipPrefix1
        xor bx, bx
        mov bl, prefix
        APPEND_SREG bx
        PUT_BYTE_MNEMONIC ':'

        append_rm_skipPrefix1:
            PUT_BYTE_MNEMONIC '['
            cmp rm, 110b
            jne not_direct_address
            cmp modd, 00b
            jne not_direct_address
            READ_APPEND_HEX_WORD append_BYTE_mnemonic
            jmp append_rm_end

        not_direct_address:
            call search_rm
            call copy_string_mnemonic
            jmp append_rm_end
    
    efficient_add_2: ; with offset
        
        cmp modd, 01b
        je rm_append_bytePtr
       
        APPEND_STRING_MNEMONIC wordPtr, 0
        jmp append_rm_continue2
        rm_append_bytePtr:
            APPEND_STRING_MNEMONIC bytePtr, 0

        append_rm_continue2:

            ; adds prefix, if exists
            xor dx, dx
            cmp dl, prefix
            je append_rm_skipPrefix2
            xor bx, bx
            mov bl, prefix
            APPEND_SREG bx
            PUT_BYTE_MNEMONIC ':'

            append_rm_skipPrefix2:
                PUT_BYTE_MNEMONIC '['
                call search_rm
                call copy_string_mnemonic
                PUT_BYTE_MNEMONIC '+'
                
                cmp modd, 01b
                je read_offset_byte
                READ_APPEND_HEX_WORD append_BYTE_mnemonic
                jmp append_rm_end
                read_offset_byte:
                READ_APPEND_HEX_BYTE append_BYTE_mnemonic
                PUT_BYTE_MNEMONIC 'h'
                jmp append_rm_end
    
    append_rm_end:
    PUT_BYTE_MNEMONIC ']'
    ret
append_rm endp

; Adds immediate operand to mnemonic buffer
proc append_immediate_data
    cmp w, 1
    je imm_word
        READ_APPEND_HEX_BYTE append_BYTE_mnemonic
        PUT_BYTE_MNEMONIC 'h'
        ret
    imm_word:
        READ_APPEND_HEX_WORD append_BYTE_mnemonic
        ret
append_immediate_data endp

; is current byte a prefix?
; If so, save segment's position (in prefixes array) in variable 'prefix'
proc check_prefix
    xor cx, cx
    mov cl, segmentArraySize
    lea bx, segmentArray  
    check_prefix_loop:
        cmp al, [bx]
        jne check_prefix_continue

        ; Calculate and store segment pos in prefix
        xor bx,bx
        mov prefix, cl
        mov cl, segmentArraySize
        sub cl, prefix
        xchg reg, cl
        call get_sreg_pos
        xchg reg, cl
        mov prefix, bl  

        call read_input_byte
        ret
        check_prefix_continue:
        call get_next_element
        loop check_prefix_loop
     ret
check_prefix endp

proc reset_flags
    mov modd, 0
    mov reg, 0
    mov rm, 0
    mov prefix, 0
    ret
reset_flags endp

;;;;;;;;;;;;;;;;;; ANALYSYING INSTRUCTION GROUPS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; for 1 byte instructions
proc skip_proc
    ret
skip_proc endp

proc inOut_analysis     
    push ax
    READ_APPEND_HEX_BYTE append_BYTE_output
    mov [instructionhex], al
    pop ax
   
    cmp al, 0E6H ; is out? 
    jae is_out
    is_in:
        APPEND_CORRECT_REGISTER 0
        APPEND_COMMA_MNEMONIC
        APPEND_HEX_BYTE instructionhex, append_BYTE_mnemonic
        PUT_BYTE_MNEMONIC 'h'
        ret

    is_out:
        APPEND_HEX_BYTE instructionhex, append_BYTE_mnemonic
        PUT_BYTE_MNEMONIC 'h'
        APPEND_COMMA_MNEMONIC
        APPEND_CORRECT_REGISTER 0      
        ret
inOut_analysis endp

proc modRegRM_analysis
    mov w, 1

    call read_input_byte

    call get_mod
    call get_reg
    call get_rm

    call get_reg_pos
    APPEND_CORRECT_REGISTER bx
    APPEND_COMMA_MNEMONIC

    call append_rm

    ret
modRegRM_analysis endp

proc threeBitsWModRM_analysis
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

proc threeBitsVWModRM_analysis
    call append_rm
    APPEND_COMMA_MNEMONIC
    cmp d, 1 ; d = v
    je v_cl
    PUT_BYTE_MNEMONIC '1'
    ret
    v_cl:
        APPEND_STRING_MNEMONIC register8Array, 3
        ret
threeBitsVWModRM_analysis endp

proc threeBitsSWModRM_analysis
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
    APPEND_HEX_BYTE ah, append_BYTE_mnemonic
    APPEND_HEX_BYTE al, append_BYTE_mnemonic
    PUT_BYTE_MNEMONIC 'h'
    ret
threeBitsSWModRM_analysis endp
    
proc threeBitsModRM_analysis
    call append_rm
    ret
threeBitsModRM_analysis endp

proc wAxImmediate_analysis
    APPEND_CORRECT_REGISTER 0
    APPEND_COMMA_MNEMONIC
    call append_immediate_data
    ret
wAxImmediate_analysis endp

proc wModRegRM_analysis
    call read_input_byte
    call get_mod
    call get_reg
    call get_rm
    
    call append_rm
    APPEND_COMMA_MNEMONIC
    call get_reg_pos
    APPEND_CORRECT_REGISTER bx
    ret
wModRegRM_analysis endp

proc dWModRegRM_analysis
    call read_input_byte
    call get_mod
    call get_reg
    call get_rm

    cmp d, 0
    je dWModRegRM_rev

    call get_reg_pos
    APPEND_CORRECT_REGISTER bx
    APPEND_COMMA_MNEMONIC
    call append_rm
    ret
    dWModRegRM_rev:
    call append_rm
    APPEND_COMMA_MNEMONIC
    call get_reg_pos
    APPEND_CORRECT_REGISTER bx
    ret
dWModRegRM_analysis endp

proc jumps1Byte_analysis
    xor ax, ax
    call read_input_byte
    cmp ax, 127 ; [-128, 127], if above 32767, offset is negative
    ja jumps1Byte_negative
    add ax, codeBytePos
    APPEND_HEX_BYTE ah append_BYTE_mnemonic
    APPEND_HEX_BYTE al append_BYTE_mnemonic
    PUT_BYTE_MNEMONIC 'h'
    ret
    jumps1Byte_negative:
        not ax
        inc ax
        mov dx, ax
        mov ax, codeBytePos
        sub ax, 100h
        sub ax, dx
        APPEND_HEX_BYTE ah append_BYTE_mnemonic
        APPEND_HEX_BYTE al append_BYTE_mnemonic
        PUT_BYTE_MNEMONIC 'h'
        ret
jumps1Byte_analysis endp

proc jump2Bytes_analysis
    call read_input_byte
    mov ch, al  
    call read_input_byte
    mov ah, ch
    xchg ah, al
    cmp ax, 32767 ; [-32768, 32767], if above 32767, offset is negative
    ja jump2Bytes_negative
    add ax, codeBytePos
    APPEND_HEX_BYTE ah append_BYTE_mnemonic
    APPEND_HEX_BYTE al append_BYTE_mnemonic
    PUT_BYTE_MNEMONIC 'h'
    ret
    jump2Bytes_negative:
        not ax
        inc ax
        mov dx, ax
        mov ax, codeBytePos
        sub ax, dx
        APPEND_HEX_BYTE ah append_BYTE_mnemonic
        APPEND_HEX_BYTE al append_BYTE_mnemonic
        PUT_BYTE_MNEMONIC 'h'
        ret
jump2Bytes_analysis endp

proc jump4Bytes_analysis
    call read_input_byte
    push ax
    call read_input_byte
    push ax
    call read_input_byte
    push ax
    call read_input_byte
    APPEND_HEX_BYTE al append_BYTE_mnemonic
    pop ax
    APPEND_HEX_BYTE al append_BYTE_mnemonic
    PUT_BYTE_MNEMONIC ':'
    pop ax
    APPEND_HEX_BYTE al append_BYTE_mnemonic
    pop ax
    APPEND_HEX_BYTE al append_BYTE_mnemonic
    ret
jump4Bytes_analysis endp

proc returns_analysis
    mov w, 1
    call append_immediate_data
    ret
returns_analysis endp

proc int_analysis
    READ_APPEND_HEX_BYTE append_BYTE_mnemonic
    PUT_BYTE_MNEMONIC 'h'
    ret
int_analysis endp

proc insModRMPop_analysis
    call read_input_byte
    call get_mod
    call get_rm
    call append_rm
    ret
insModRMPop_analysis endp

proc insDModSregRMMov_analysis
    call read_input_byte
    call get_mod
    call get_reg
    call get_rm

    cmp d, 1
    je insDModSregRMMov_rev
    call append_rm
    APPEND_COMMA_MNEMONIC
    call get_sreg_pos
    APPEND_SREG bx
    ret
    insDModSregRMMov_rev:
    call get_sreg_pos
    APPEND_SREG bx
    APPEND_COMMA_MNEMONIC
    call append_rm
    ret
insDModSregRMMov_analysis endp

proc insWAdrAdr_analysis
    cmp d, 1
    je insWAdrAdr_reverse
    APPEND_CORRECT_REGISTER 0
    APPEND_COMMA_MNEMONIC
    READ_APPEND_HEX_WORD append_BYTE_mnemonic
    ret
    insWAdrAdr_reverse:
        READ_APPEND_HEX_WORD append_BYTE_mnemonic
        APPEND_COMMA_MNEMONIC
        APPEND_CORRECT_REGISTER 0
        ret
insWAdrAdr_analysis endp

proc insWModRMOpOpMov_analysis
    call read_input_byte
    call get_mod
    call get_rm
    call append_rm
    APPEND_COMMA_MNEMONIC
    call append_immediate_data
    ret
insWModRMOpOpMov_analysis endp

proc insWRegOpOpMov_analysis
    mov w, 1000b
    and w, al
    shr w, 3
    and al, 111b
    mov [reg], al

    call get_reg_pos
    APPEND_CORRECT_REGISTER bx
    APPEND_COMMA_MNEMONIC
    call append_immediate_data
    ret
insWRegOpOpMov_analysis endp

main:
    mov ax, @data
    mov ds, ax
    
    call check_help

    ;;;;;;;;;;;;;;;;;;;;;;; READING COMMAND LINE ARGUMENTS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    xor cx, cx
    mov cl, es:[80h] ; length of command line 
    cmp cx, 0
    jne read_argument1
    call invalid_arguments
    
    read_argument1:
        mov bx, 82h ; Position of first symbol after space in command line arguments buffer
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

    ;;;;;;;;;;;;;;;;;;;;;;; PREPARING FILES, GETTING HANDLES ;;;;;;;;;;;;;;;;;;;;;
    
    lea dx, inputFileName
    call setup_input_file
    mov inputFileHandle, ax

    lea dx, outputFileName
    call setup_output_file
    mov outputFileHandle, ax

    ;;;;;;;;;;;;;;;;;;;;;;; NEW ITERATION - NEW INSTRUCTION ;;;;;;;;;;;;;;;;;
    main_loop:
        call append_pos
        call reset_flags
        APPEND_SPACES_OUTPUT hexCodePosition

        call read_input_byte
        
        call check_prefix

        call get_DW
        
        SEARCH_FOR_INSTRUCTION oneByteInstructionArraySize1, oneByteInstructionArray1, 0, skip_proc
        SEARCH_FOR_INSTRUCTION oneByteInstructionArraySize2, oneByteInstructionArray2, 0, skip_proc

        SEARCH_FOR_INSTRUCTION twoByteInstructionArraySize, twoByteInstructionArray, 0, read_input_byte

        SEARCH_FOR_INSTRUCTION inOutArraySize, inOutArray, 1 inOut_analysis
        SEARCH_FOR_INSTRUCTION modRegRMArraySize, modRegRMArray, 0, modRegRM_analysis
        SEARCH_FOR_INSTRUCTION wAccImmediateArraySize, wAccImmediateArray, 1, wAxImmediate_analysis
        SEARCH_FOR_INSTRUCTION wModRegRMArraySize, wModRegRMArray, 1, wModRegRM_analysis 
        SEARCH_FOR_INSTRUCTION dWModRegRMArraySize, dWModRegRMArray, 3, dWModRegRM_analysis
        SEARCH_FOR_INSTRUCTION jumps1ByteArraySize, jumps1ByteArray, 0 jumps1Byte_analysis
        SEARCH_FOR_INSTRUCTION jump2BytesArraySize, jump2BytesArray, 0, jump2Bytes_analysis
        SEARCH_FOR_INSTRUCTION jump4BytesArraySize, jump4BytesArray, 0, jump4Bytes_analysis
        SEARCH_FOR_INSTRUCTION returnsArraySize, returnsArray, 0, returns_analysis
        SEARCH_FOR_INSTRUCTION WAdrAdrArraySize, WAdrAdrArray, 1, insWAdrAdr_analysis
        SEARCH_FOR_INSTRUCTION 1, insInt, 0, int_analysis
        SEARCH_FOR_INSTRUCTION 1, insModRMPop, 0, insModRMPop_analysis
        SEARCH_FOR_INSTRUCTION 1, insDModSregRMMov, 2, insDModSregRMMov_analysis
        SEARCH_FOR_INSTRUCTION 1, insWModRMOpOpMov, 1, insWModRMOpOpMov_analysis
        SEARCH_FOR_INSTRUCTION 1, insWRegOpOpMov, 16, insWRegOpOpMov_analysis

        THREE_BITS_SEARCH 0F6h, 1, threeBitsWModRMArraySize, threeBitsWModRMArray, 0, threeBitsWModRM_analysis
        THREE_BITS_SEARCH 0D0h, 3, threeBitsVWModRMArraySize, threeBitsVWModRMArray, 0,  threeBitsVWModRM_analysis
        THREE_BITS_SEARCH 80h, 3, threeBitsSWModRMArraySize, threeBitsSWModRMArray, 0,  threeBitsSWModRM_analysis
        THREE_BITS_SEARCH 0FEh, 1, threeBitsModRMArraySize, threeBitsModRMArray, 0,  threeBitsModRM_analysis
        
        
        unknown_instruction:
            lea bx, [insunknown]
            call copy_string_mnemonic
            jmp print_output

        print_output:
            APPEND_SPACES_OUTPUT mnemonicPosition
            lea bx, [mnemonicbuff]
            mov cx, [mnemonicBuffPos]
            call copy_string_output
            call fprint_line

        jmp main_loop
end main