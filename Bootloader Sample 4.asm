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
    je install_binary
    cmp al, '2'
    je display_message
    jmp print_menu

install_binary:
    mov ah, 0x02   
    mov al, 1      
    mov ch, 0      
    mov cl, 3      
    mov dh, 0      
    mov dl, 0x80   
    mov bx, 0x8000 
    int 0x13       

    mov ah, 0x03   
    mov al, 1      
    mov ch, 0      
    mov cl, 100    
    int 0x13      
    jmp success

display_message:
    mov si, ascii_art
    call print_string
    jmp $

success:
    mov si, success_msg
    call print_string
    jmp $

print_string:
    lodsb
    or al, al
    jz return
    mov ah, 0x0e
    int 0x10
    jmp print_string

return:
    ret

menu_options:
    db 'Press 1 to Install Binary, 2 to Display Message', 0

success_msg:
    db 'Operation Completed Successfully!', 0

ascii_art:
    db 'ASCII Art Goes Here...', 0

times 510 - ($ - $$) db 0
dw 0xaa55
