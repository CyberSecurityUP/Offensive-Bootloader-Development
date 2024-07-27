bits 16
org 0x7c00

start:
    ; Configura o segmento de dados
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; Limpa a tela
    mov ah, 0x06
    xor al, al
    xor cx, cx
    mov dx, 0x184f
    mov bh, 0x1E  ; Cor de fundo azul e texto branco
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
    ; Espera a entrada do usuário
    xor ah, ah
    int 0x16    ; BIOS interrupção para teclado
    ; Compara a tecla pressionada
    cmp al, '1'
    je load_os1
    cmp al, '2'
    je load_os2
    ; Se nenhum input válido, mostra o menu novamente
    jmp print_menu

load_os1:
    ; Código para carregar e executar o primeiro sistema operacional
    call load_and_jump

load_os2:
    ; Código para carregar e executar o segundo sistema operacional
    call load_and_jump

load_and_jump:
    ; Placeholder para funcionalidade de carregamento
    ; Implementar o carregamento de um SO aqui
    ; Por agora, apenas reinicia
    jmp 0xFFFF:0x0000  ; Realiza um salto para reiniciar

menu_options:
    db 'Escolha o sistema operacional:', 13, 10
    db 'Pressione 1 para o SO 1', 13, 10
    db 'Pressione 2 para o SO 2', 13, 10, 0

; Preenche o restante do bootloader para 510 bytes com 0s
times 510 - ($ - $$) db 0

; Número mágico do bootloader
dw 0xaa55

