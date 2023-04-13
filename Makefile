boot: boot.s
	nasm boot.s -o boot.img -l boot.lst

run: boot.img
	qemu-system-i386 boot.img

clean:
	rm -f boot.img boot.lst

.PHONY: clean
