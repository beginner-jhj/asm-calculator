section .data
    num1_prompt db "Enter first number: ", 0
    len_num1_prompt equ $ - num1_prompt

    num2_prompt db "Enter second number: ", 0
    len_num2_prompt equ $ - num2_prompt

    op_prompt db "Enter operation (+, -, *, /): ", 0
    len_op_prompt equ $ - op_prompt

    result_msg db "Result: ", 0
    len_result_msg equ $ - result_msg

    newline db 10, 0

section .bss
    num1 resb 12
    num2 resb 12
    op resb 2

    num1_value resd 1
    num2_value resd 1

    result resb 12


section .text
    global _start

_start:
    ; Prompt for first number
    mov eax, 4
    mov ebx, 1
    mov ecx, num1_prompt
    mov edx, len_num1_prompt
    int 0x80

    ; Read first number
    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 12
    int 0x80

    call ascii_to_int
    mov [num1_value], eax

    ; Prompt for second number
    mov eax, 4
    mov ebx, 1
    mov ecx, num2_prompt
    mov edx, len_num2_prompt
    int 0x80

    ; Read second number
    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 12
    int 0x80

    call ascii_to_int
    mov [num2_value], eax

    ; Prompt for operation
    mov eax, 4  
    mov ebx, 1
    mov ecx, op_prompt
    mov edx, len_op_prompt
    int 0x80

    ; Read operation
    mov eax, 3
    mov ebx, 0
    mov ecx, op
    mov edx, 2
    int 0x80

    ; Perform operation
    cmp byte [op], '+'  ; Check if operation is addition
    je add_numbers

    cmp byte [op], '-'  ; Check if operation is subtraction
    je subtract

    cmp byte [op], '*'  ; Check if operation is multiplication
    je multiply

    cmp byte [op], '/'  ; Check if operation is division
    je divide

    mov eax, 1           ; Invalid operation
    xor ebx, ebx         ; Exit code 0  
    int 0x80

ascii_to_int:
    ; Convert ASCII to integer
    xor eax, eax          ; Clear EAX for result
    xor bl,bl ;Negative flag

    mov dl, [ecx]
    cmp dl, '-'
    jne .convert_char_to_int
    inc ecx              ; Skip the '-' character
    mov bl, 1            ; Set negative flag

.convert_char_to_int:
    mov dl, [ecx]
    cmp dl, 0            ; Check for null terminator
    je .done             ; If null terminator, we're done
    cmp dl, 10
    je .done             ; If newline, we're done
    sub dl, '0'          ; Convert ASCII to integer
    imul eax, eax, 10    ; Multiply current result by 10
    add eax, edx         ; Add the new digit
    inc ecx              ; Move to the next character
    jmp .convert_char_to_int

.done:
    cmp bl, 1            ; Check if negative flag is set
    jne .finished
    neg eax

.finished:
    ret


add_numbers:
    mov eax, [num1_value]
    add eax, [num2_value]
    jmp show_result

subtract:
    mov eax, [num1_value]
    sub eax, [num2_value]
    jmp show_result

multiply:
    mov eax, [num1_value]
    imul eax, [num2_value]
    jmp show_result

divide:
    mov eax, [num1_value]
    mov ebx, [num2_value]
    cmp ebx, 0
    je .exit             ; Exit if division by zero
    xor edx, edx         ; Clear EDX for division
    div ebx              ; Divide EAX by EBX
    jmp show_result

.exit:
    mov eax, 1           ; Exit syscall number
    xor ebx, ebx         ; Exit code 0
    int 0x80

show_result:
    push eax

    mov eax, 4           ; Syscall number for sys_write
    mov ebx, 1           ; File descriptor 1 (stdout)
    mov ecx, result_msg  ; Message to print
    mov edx, len_result_msg ; Length of the message
    int 0x80             ; Call kernel

    pop eax
    call int_to_ascii

    mov eax,4
    mov ebx, 1
    mov ecx, esi
    mov edx, edi         ; EDI contains the length of the string
    int 0x80             ; Print the result

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80             ; Call kernel to print newline

    mov eax, 1           ; Syscall number for sys_exit
    xor ebx, ebx         ; Exit code 0
    int 0x80             ; Call kernel to exit


int_to_ascii:
    mov ecx, 10
    mov esi, result
    add esi, 11          ; Reserve space for 10 digits + null terminator
    mov byte [esi], 0    ; Null terminator
    dec esi

    mov edi, 0
    test eax, eax ; Check if EAX is negative
    jns .convert_loop    ; If not negative, proceed with conversion

    neg eax              
    mov edi, 1          ; Set EDI to indicate negative number


.convert_loop:
    xor edx, edx
    div ecx
    add dl,'0'
    mov [esi], dl
    dec esi
    test eax, eax ; Check if EAX is zero
    jnz .convert_loop

    cmp edi, 1
    jne .finish_conversion ; If not negative, skip adding '-'
    mov byte [esi], '-'    ; Add negative sign
    dec esi                ; Move ESI back to the start of the string




.finish_conversion:
    inc esi              ; Move ESI to the start of the string

    mov edi, result
    add edi, 11
    sub edi, esi         ; Calculate length of the string

    ret

