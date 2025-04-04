; Global Descriptor Table (GDT)
; ----------------------------------------------------------------------------
; Function: print_hex
; Description:
;   Defines memory segments for the CPU
;   Each segment descriptor is 8 bytes
;   The first entry must be all zeros (null descriptor)
;    We define a code segment and a data segment
;   The GDT descriptor contains the size and address of the table
; ----------------------------------------------------------------------------

gdt_start:
    ; Null descriptor (required)
    dd 0x0
    dd 0x0

    ; Code descriptor:
    ;   Base = 0, Limit = 4GB, Executable, Readable, Accessed = 0,
    ;   DPL = 0, Present = 1, 32-bit, 4K granularity.
    dw 0xFFFF             ; Limit low (0xFFFF)
    dw 0x0000             ; Base low (0x0000)
    db 0x00               ; Base middle
    db 10011010b          ; Access byte: present, ring 0, code segment, executable, readable
    db 11001111b          ; Flags: 4K granularity, 32-bit, Limit high (0xF)
    db 0x00               ; Base high

    ; Data descriptor:
    ;   Base = 0, Limit = 4GB, Data segment, Read/Write, DPL = 0, Present = 1.
    dw 0xFFFF             ; Limit low
    dw 0x0000             ; Base low
    db 0x00               ; Base middle
    db 10010010b          ; Access byte: present, ring 0, data segment, writable
    db 11001111b          ; Flags: 4K granularity, 32-bit, Limit high
    db 0x00               ; Base high

; GDT for code segment. base = 0x00000000, length = 0xfffff
; for flags, refer to os-dev.pdf document, page 36
gdt_code: 
    dw 0xffff    ; segment length, bits 0-15
    dw 0x0       ; segment base, bits 0-15
    db 0x0       ; segment base, bits 16-23
    db 10011010b ; flags (8 bits)
    db 11001111b ; flags (4 bits) + segment length, bits 16-19
    db 0x0       ; segment base, bits 24-31

; GDT for data segment. base and length identical to code segment
; some flags changed, again, refer to os-dev.pdf
gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

gdt_end:

; GDT descriptor
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; size (16 bit), always one less of its true size
    dd gdt_start ; address (32 bit)

; define some constants for later use
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start