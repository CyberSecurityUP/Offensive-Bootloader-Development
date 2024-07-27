BITS 16           ; 16-bit code for real mode
ORG 0x7c00        ; Standard loading address for the bootloader

start:
    xor ax, ax    ; Clear the AX register
    mov ds, ax    ; Set the data segment to 0
    mov es, ax    ; Set the extra segment to 0

    ; Stack configuration
    mov ss, ax
    mov sp, 0x7c00
    cli            ; Disable interrupts

    ; Clear the screen
    mov ah, 0x06
    xor al, al
    xor cx, cx
    mov dx, 184Fh
    mov bh, 0x1E
    int 10h

    ; Display the ASCII art
    mov si, joas_art
print_char:
    lodsb          ; Load the next byte from the string into AL
    test al, al    ; Test if it's the null byte
    jz done        ; If zero, finish
    cmp al, 13     ; Check if it's a carriage return
    jne print_next_char
    int 10h        ; Print new line
print_next_char:
    mov ah, 0x0E   ; BIOS function to display a character
    int 10h        ; BIOS interrupt for video
    jmp print_char ; Continue printing

done:
    jmp $          ; Infinite loop to keep the bootloader active

joas_art:
    db ' JJJJ   OOO   AAAAA  SSSS', 13, 10
    db '   JJ  O   O  A   A  S   ', 13, 10
    db '   JJ  O   O  AAAAA  SSS ', 13, 10
    db 'J  JJ  O   O  A   A     S', 13, 10
    db ' JJJJ   OOO   A   A  SSSS', 13, 10, 0

; Fill up to 510 bytes with zeros
times 510 - ($ - $$) db 0
dw 0xaa55           ; Boot signature
