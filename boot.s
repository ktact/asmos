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
    ; Infinite loop
    jmp $

    ; Put the boot flat at byte 510(0x01FE)
    times 510 - ($ - $$) db 0x00
    db 0x55,0xAA
