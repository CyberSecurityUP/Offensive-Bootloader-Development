bits 16
org 0x7c00

start:
    ; Configuração inicial do segmento de dados
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; Limpa a tela
    mov ah, 0x06
    xor al, al
    xor cx, cx
    mov dx, 0x184f
    mov bh, 0x1E
    int 0x10

    ; Exibe o menu
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
    int 0x16    ; Espera uma entrada do teclado
    cmp al, '1'
    je install_binary
    cmp al, '2'
    je display_message
    jmp print_menu

install_binary:
    ; Supõe que o binário está no setor 3 e copia para o setor 100
    mov ah, 0x02   ; Função de leitura de disco
    mov al, 1      ; Ler 1 setor
    mov ch, 0      ; Cilindro 0
    mov cl, 3      ; Setor 3
    mov dh, 0      ; Cabeça 0
    mov dl, 0x80   ; Drive (0x80 = primeiro disco rígido)
    mov bx, 0x8000 ; Endereço na memória para carregar o binário
    int 0x13       ; Interação do BIOS para leitura de disco

    mov ah, 0x03   ; Função de escrita de disco
    mov al, 1      ; Escrever 1 setor
    mov ch, 0      ; Cilindro 0
    mov cl, 100    ; Setor 100
    int 0x13       ; Interação do BIOS para escrita de disco
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
