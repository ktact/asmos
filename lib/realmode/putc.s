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


