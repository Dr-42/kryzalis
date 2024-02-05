#include <driver/vga.h>

int kernel_main() {
    set_cursor_pos(0, 0);
    clearwin(COLOR_BLK, COLOR_PRP);

    const char *first = "Now we have a more advanced vga driver that does what we want!\n";

    putstr(first, COLOR_WHT, COLOR_PRP);

    const char *second = "It even wraps the text around the screen and moves the cursor correctly. ";

    putstr(second, COLOR_WHT, COLOR_PRP);

    const char *third = "But.. if we reach the end of the screen it still doesn't quite scroll properly...";

    putstr(third, COLOR_WHT, COLOR_PRP);
    
    return 0;
}
