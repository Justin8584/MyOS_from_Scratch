# # Simple Makefile for our OS

# # Path to our tools
# CC = x86_64-elf-gcc
# LD = x86_64-elf-ld
# ASM = nasm
# QEMU = qemu-system-x86_64
# CFLAGS = -ffreestanding -m32

# # First rule is the one executed when no parameters are fed to the Makefile
# all: run

# # Choose which boot sector to use

# # BOOTSECT = boot/boot_sect_memory.bin
# # BOOTSECT = boot/boot_sect_main.bin
# # BOOTSECT = boot/boot_sect_disk.bin
# BOOTSECT = boot/boot_sect_pm.bin

# # Rule to build the OS image
# os-image.bin: $(BOOTSECT)
# 	cat $^ > os-image.bin

# # # Rule to build the boot sectors
# # boot/boot_sect_memory.bin: boot/boot_sect_memory.asm
# # 	$(ASM) $< -f bin -o $@

# # boot/boot_sect_memory_org.bin: boot/boot_sect_memory_org.asm
# # 	$(ASM) $< -f bin -o $@

# # boot/boot_sect_stack.bin: boot/boot_sect_stack.asm
# # 	$(ASM) $< -f bin -o $@

# # boot/boot_sect_main.bin: boot/boot_sect_main.asm boot/print.asm boot/print_hex.asm
# # 	$(ASM) $< -f bin -o $@

# # boot/boot_sect_disk.bin: boot/boot_sect_disk.asm boot/print.asm boot/print_hex.asm boot/disk.asm
# # 	$(ASM) $< -f bin -o $@

# boot/boot_sect_pm.bin: boot/boot_sect_pm.asm boot/print.asm boot/gdt.asm boot/32bit-print.asm boot/switch_pm.asm
# 	$(ASM) $< -f bin -o $@

# # Rule to run our OS in QEMU
# run: os-image.bin
# 	$(QEMU) -fda os-image.bin $

# # Clean up built files
# clean:
# 	rm -rf *.bin *.o
# 	rm -rf boot/*.bin boot/*.o

# Makefile for our OS with C kernel support

#######################################################
# Path to our tools
# CC = x86_64-elf-gcc
# LD = x86_64-elf-ld
# ASM = nasm
# QEMU = qemu-system-x86_64
# CFLAGS = -ffreestanding -m32

# # First rule is the one executed when no parameters are fed to the Makefile
# all: function.bin

# # Compile a C file to an object file
# function.o: kernel/function.c
# 	$(CC) $(CFLAGS) -c $< -o $@

# # Convert the object to a binary file
# function.bin: function.o
# 	$(LD) -m elf_i386 -o $@ -Ttext 0x0 --oformat binary $

# # Disassemble the binary
# function.dis: function.bin
# 	ndisasm -b 32 $< > $@

# # Clean up built files
# clean:
# 	rm -rf *.bin *.o *.dis
# 	rm -rf kernel/*.o boot/*.bin


# Makefile for our OS with C kernel

# Path to our tools
CC = x86_64-elf-gcc
LD = x86_64-elf-ld
ASM = nasm
QEMU = qemu-system-x86_64
CFLAGS = -ffreestanding -m32

# First rule is the one executed when no parameters are fed to the Makefile
all: run

# Rule to build the OS image
os-image.bin: boot/bootsect.bin kernel.bin
	cat $^ > os-image.bin

# Build the kernel binary
kernel.bin: boot/kernel_entry.o kernel/kernel.o
	$(LD) -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

# Build the kernel object files
kernel/kernel.o: kernel/kernel.c
	$(CC) $(CFLAGS) -c $< -o $@

# Build the kernel entry
boot/kernel_entry.o: boot/kernel_entry.asm
	$(ASM) $< -f elf -o $@

# Build the bootsector
boot/bootsect.bin: boot/bootsect.asm
	$(ASM) $< -f bin -o $@

# Rule to run our OS in QEMU
run: os-image.bin
	$(QEMU) -fda os-image.bin $

# Clean up built files
clean:
	rm -rf *.bin *.o *.dis
	rm -rf kernel/*.o boot/*.bin boot/*.o