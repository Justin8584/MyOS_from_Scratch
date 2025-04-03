; A simple boot sector program that loops forever
loop:
    jmp loop

; Fill the rest of the boot sector with zeros, except for the magic number
times 510-($-$$) db 0  ; $ is the current address, $$ is the start address
                      ; This fills up to the 510th byte with zeros
dw 0xaa55             ; The magic number that tells the BIOS this is a boot sector