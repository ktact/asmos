    ; Define load position of the boot loader
    LOAD_POSITION_OF_BOOT_LOADER equ 0x7c00

    ; Specify the load address to assembler
    ORG LOAD_POSITION_OF_BOOT_LOADER

%include "include/macro.s"

entry:
    ; Jump to IPL
    jmp ipl

    ; BPS(BIOS Parameter Block)
    times 90 - ($ - $$) db 0x90

ipl:
    ; Disable interrupt
    cli

    ; Setting of the segment register
    mov ax, 0x0000
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, LOAD_POSITION_OF_BOOT_LOADER

    ; Enable interrupt
    sti

    ; Store the boot drive
    mov [BOOT.DRIVE], dl

    ; Output "Booting..."
    fcall puts,.s0

    ; Infinite loop
    jmp $

    ; Data definition
.s0 db "Booting...", 0x0A, 0x0D, 0

; Function to output a character to the console
putc:
    ; Construct the stack frame
               ; + 4 | a character to output (the argument of this function)
               ; + 2 | a return address
    push bp    ; + 0 | BP (original value)
    mov bp, sp ; bp points + 0

    ; Save the registers
    push ax
    push bx

    ; Process
    mov al, [bp + 4] ; Get a character to output
    mov ah, 0x0E
    mov bx, 0x0000   ; Set the page number/color of character to 0
    int 0x10         ; Video BIOS Call

    ; Restore the registers
    pop bx
    pop ax

    ; Destruct the stack frame
    mov sp, bp
    pop bp

    ret

; Function to output string to the console
puts:
    ; Construct the stack frame
               ; + 4 | a string to output (the argument of this function)
               ; + 2 | a return address
    push bp    ; + 0 | BP (original value)
    mov bp, sp ; bp points + 0

    ; Save the registers
    push ax
    push bx
    push si

    ; Process
    mov si, [bp + 4] ; Get a string to output
    mov ah, 0x0E
    mov bx, 0x0000
    cld
.10L:         ; DO {
    lodsb     ;   AL = (*SI)++
    cmp al, 0 ;   IF AL == 0 THEN
    je .10E   ;     BREAK
    int 0x10  ;   Video BIOS Call
    jmp .10L  ; } WHILE (1)
.10E:

    ; Restore the registers
    pop si
    pop bx
    pop ax

    ; Destruct the stack frame
    mov sp, bp
    pop bp

    ret

ALIGN 2, db 0
BOOT:
.DRIVE:
    dw 0

    ; Put the boot flat at byte 510(0x01FE)
    times 510 - ($ - $$) db 0x00
    db 0x55,0xAA
