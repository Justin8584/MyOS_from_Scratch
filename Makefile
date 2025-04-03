# Simple Makefile for our OS

# Path to our tools
CC = x86_64-elf-gcc
LD = x86_64-elf-ld
ASM = nasm
QEMU = qemu-system-x86_64

# First rule is the one executed when no parameters are fed to the Makefile
all: run

# Choose which boot sector to use
# BOOTSECT = boot/boot_sect_memory.bin
BOOTSECT = boot/boot_sect_main.bin

# Rule to build the OS image
os-image.bin: $(BOOTSECT)
	cat $^ > os-image.bin

# # Rule to build the boot sectors
# boot/boot_sect_memory.bin: boot/boot_sect_memory.asm
# 	$(ASM) $< -f bin -o $@

# boot/boot_sect_memory_org.bin: boot/boot_sect_memory_org.asm
# 	$(ASM) $< -f bin -o $@

# boot/boot_sect_stack.bin: boot/boot_sect_stack.asm
# 	$(ASM) $< -f bin -o $@

boot/boot_sect_main.bin: boot/boot_sect_main.asm boot/print.asm boot/print_hex.asm
	$(ASM) $< -f bin -o $@

# Rule to run our OS in QEMU
run: os-image.bin
	$(QEMU) -fda os-image.bin $

# Clean up built files
clean:
	rm -rf *.bin *.o
	rm -rf boot/*.bin boot/*.o