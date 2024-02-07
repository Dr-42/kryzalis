#include <driver/vga.h>

int kernel_main() {
    clearwin(COLOR_BLK, COLOR_BLU);

    const char *first = "Now we have a more advanced vga driver that does what we want!\n";
    putstr(first, COLOR_WHT, COLOR_BLU);

    const char *second = "It even wraps the text around the screen and moves the cursor correctly. ";
    putstr(second, COLOR_WHT, COLOR_BLU);

    const char *third = "It uses the last line and shifts everything up when it reaches the end of the screen.\n";
    putstr(third, COLOR_WHT, COLOR_BLU);

    const char *fourth = "Isn't that cool?\n";
    putstr(fourth, COLOR_WHT, COLOR_BLU);
    
    return 0;
}
