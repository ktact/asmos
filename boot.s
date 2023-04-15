    ; Define load position of the boot loader
    LOAD_POSITION_OF_BOOT_LOADER equ 0x7c00

    ; Specify the load address to assembler
    ORG LOAD_POSITION_OF_BOOT_LOADER

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

    mov al, 'A'    ; AL = character to output
    mov ah, 0x0E
    mov bx, 0x0000 ; Set the page number/color of character to 0
    int 0x10       ; Video BIOS Call

    ; Infinite loop
    jmp $

ALIGN 2, db 0
BOOT:
.DRIVE:
    dw 0

    ; Put the boot flat at byte 510(0x01FE)
    times 510 - ($ - $$) db 0x00
    db 0x55,0xAA
