bits 16
org 0x7c00

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    mov ah, 0x06
    xor al, al
    xor cx, cx
    mov dx, 0x184f
    mov bh, 0x1E  
    int 0x10

    mov si, menu_options
print_menu:
    lodsb
    test al, al
    jz wait_for_input
    mov ah, 0x0e
    int 0x10
    jmp print_menu

wait_for_input:
    xor ah, ah
    int 0x16    
    cmp al, '1'
    je load_os1
    cmp al, '2'
    je load_os2
    jmp print_menu

load_os1:
    call load_and_jump

load_os2:
    call load_and_jump

load_and_jump:
    jmp 0xFFFF:0x0000  ; Realiza um salto para reiniciar

menu_options:
    db 'Select Operation System:', 13, 10
    db 'Press 1 for SO 1', 13, 10
    db 'Press 2 for  SO 2', 13, 10, 0

times 510 - ($ - $$) db 0

dw 0xaa55

