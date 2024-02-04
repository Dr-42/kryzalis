#ifndef DRIVER_VGA_H
#define DRIVER_VGA_H

typedef struct __attribute__((packed)) {
	char character;
	char style;
} vga_char;


void clearwin();
void putstr(const char* str);

#endif
