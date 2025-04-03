# Simple Makefile for our OS

# Path to our cross-compiler
CC = x86_64-elf-gcc
LD = x86_64-elf-ld
ASM = nasm
QEMU = qemu-system-x86_64

# First rule is the one executed when no parameters are fed to the Makefile
all: run

# Rule to build the OS image
os-image.bin: boot/boot_sect_hello.bin
	cat $^ > os-image.bin

# Rule to build the boot sector
boot/boot_sect_hello.bin: boot/boot_sect_hello.asm
	$(ASM) $< -f bin -o $@

# Rule to run our OS in QEMU
run: os-image.bin
	$(QEMU) -fda os-image.bin $

# Clean up built files
clean:
	rm -rf *.bin *.o
	rm -rf boot/*.bin boot/*.o