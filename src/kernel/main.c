#include "drivers/vga.h"

int kernel_main() {
	clearwin();
	const char* welcome_msg = "Welcome to the kernel. Bye bye assembly";
	putstr(welcome_msg);

	return 0;
}
