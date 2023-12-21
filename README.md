# 8086 Disassembler

## Overview

Disassembler is designed to translate all machine code instructions from 16-bit x86 architecture into human-readable assembly language.

ts all 8086 microprocessor instructions.

## Examples

https://github.com/Dariusspr/8086-Disassembler/tree/main/tests/test2.asm

Disassembling above file generates the following output:
```asm
CS:0100:    1E                          PUSH DS
CS:0101:    268B811332                  MOV AX, WORD PTR ES:[BX+DI+3213h]
CS:0106:    BA3121                      MOV DX, 2131h
CS:0109:    92                          CXHG AX, DX
CS:010A:    3F                          AAS
CS:010B:    2BC2                        SUB AX, DX
CS:010D:    F7D0                        NOT AX
CS:010F:    8ACA                        MOV CL, DL
CS:0111:    D3C0                        ROL AX, CL
CS:0113:    F3                          REP
CS:0114:    3BC2                        CMP AX, DX
CS:0116:    7502                        JNE 011Ah
CS:0118:    33C0                        XOR AX, AX
CS:011A:    FEC0                        INC AL
CS:011C:    E2FC                        LOOP 011Ah
CS:011E:    5A                          POP DX
```
More examples can be found in the [tests](https://github.com/Dariusspr/8086-Disassembler/tree/main/tests/) directory of this repository.
## Prerequisites

- **Environment:** Ensure that you have a suitable environment for running 8086 assembly code(DOSBox, Emu8086, etc...).
- **Assembler:** Ensure that you have installed an assembler, such as TASM, capable of handling 16-bit programs.

## Installation
Clone the repository:

```bash
git clone https://github.com/Dariusspr/8086-Disassembler.git
```

## Usage
#### Notes
- Place the disasm.asm file and other relevant files in the same directory as your assembler (such as TASM).
- The following commands are executed within the DOSBox environment.
#### Mount drive
```
mount c c:/.../tasm/
```
```
c:
```
#### Create .com file
```
tasm fileName
```
```
tlink /t fileName
```

#### Create disasm.exe
```
tasm disasm
```
```
tlink disasm
```
#### Run disassembler
```
disasm fileName.com outputFile
```