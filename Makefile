CC=gcc
LD=ld
ASM=nasm

CFLAGS=-Wall -Wextra -nostdlib -ffreestanding -mno-red-zone -m64 -g
INCLUDES=-Isrc/kernel/include

BOOTLOADER_ASMS=$(shell find src/bootloader -name "*.s")
BOOTLOADER_OBJS=$(patsubst src/bootloader/%.s, build/bootloader/%.o, $(BOOTLOADER_ASMS))

KERNEL_SRCS=$(shell find src/kernel -name "*.c")
KERNEL_HEADERS=$(shell find src/kernel -name "*.h")
KERNEL_OBJS=$(patsubst src/kernel/%.c, build/kernel/%.o, $(KERNEL_SRCS))

KERNEL_ASMS=$(shell find src/kernel -name "*.s")
KERNEL_OBJS+=$(patsubst src/kernel/%.s, build/kernel/%.o, $(KERNEL_ASMS))

prebuild:
	mkdir -p iso/boot/grub
	mkdir -p build/bootloader
	mkdir -p build/kernel

build: prebuild $(BOOTLOADER_OBJS) $(KERNEL_OBJS)
	cp src/grub.cfg iso/boot/grub/grub.cfg
	$(LD) -m elf_x86_64 -nostdlib -T src/linker.ld -o build/bootloader/kernel.bin $(BOOTLOADER_OBJS) $(KERNEL_OBJS)
	cp build/bootloader/kernel.bin iso/boot/kernel.bin
	grub2-mkrescue -o build/kernel.iso iso

build/bootloader/%.o: src/bootloader/%.s
	$(ASM) -g -f elf64 -F dwarf $< -o $@

build/kernel/%.o: src/kernel/%.c
	mkdir -p $(dir $@)
	$(CC) -g -c $(CFLAGS) $(INCLUDES) $< -o $@

build/kernel/%.o: src/kernel/%.s
	mkdir -p $(dir $@)
	$(ASM) -g -f elf64 -F dwarf $< -o $@

clean:
	rm -rf build
	rm -rf iso
run: build
	qemu-system-x86_64 -cdrom build/kernel.iso

debug: build
	qemu-system-x86_64 -cdrom build/kernel.iso -s -S &
	gdb build/bootloader/kernel.bin -ex "target remote localhost:1234"

