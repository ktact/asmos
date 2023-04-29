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
