CC=gcc
LD=ld
ASM=nasm

BOOTLOADER_ASMS=$(shell find src/bootloader -name "*.s")
BOOTLOADER_OBJS=$(patsubst src/bootloader/%.s, build/bootloader/%.o, $(BOOTLOADER_ASMS))

prebuild:
	mkdir -p iso/boot/grub
	mkdir -p build/bootloader

build: prebuild $(BOOTLOADER_OBJS)
	cp src/grub.cfg iso/boot/grub/grub.cfg
	mkdir -p build/bootloader
	$(LD) -m elf_x86_64 -T src/linker.ld -o build/bootloader/kernel.bin $(BOOTLOADER_OBJS)
	cp build/bootloader/kernel.bin iso/boot/kernel.bin
	grub2-mkrescue -o build/bootloader/kernel.iso iso

build/bootloader/%.o: src/bootloader/%.s
	$(ASM) -f elf64 $< -o $@

clean:
	rm -rf build
	rm -rf iso
run: build
	qemu-system-x86_64 -cdrom build/bootloader/kernel.iso

debug: build
	qemu-system-x86_64 -cdrom build/bootloader/kernel.iso -s -S &
	gdb build/bootloader/kernel.bin -ex "target remote localhost:1234"

