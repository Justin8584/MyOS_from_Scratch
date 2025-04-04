; kernel_entry.asm
; This is the kernel entry file that’s loaded at KERNEL_OFFSET (0x1000)
[bits 32]
global _start
_start:
    ; Optionally, set up a new stack if needed.
    mov esp, 0x90000    ; Example: set stack pointer

    ; (Your kernel initialization code goes here.)
    ; For demonstration, we’ll just display a message and then halt.
    ; (Assume you have a print routine for 32-bit mode, e.g., print_string_pm.)
    mov ebx, kernel_msg
    ; TODO: print_string_pm
    ; call print_string_pm

    ; Halt the CPU.
.hang:
    cli
    hlt
    jmp .hang

kernel_msg db "Kernel started successfully!", 0