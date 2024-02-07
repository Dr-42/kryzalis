#include <cpu/ports.h>
#include <driver/vga.h>

volatile vga_char *TEXT_AREA = (vga_char*) VGA_START;


uint8_t vga_color(const uint8_t fg_color, const uint8_t bg_color){
    // Put bg color in the higher 4 bits and mask those of fg
    return (bg_color << 4) | (fg_color & 0x0F);
}


void clearwin(uint8_t fg_color, uint8_t bg_color){
    const char space = ' ';
    uint8_t clear_color = vga_color(fg_color, bg_color);

    const vga_char clear_char = {
        .character = space,
        .style = clear_color
    };

    for(uint64_t i = 0; i < VGA_EXTENT; i++) {
        TEXT_AREA[i] = clear_char;
    }
    set_cursor_pos(0, VGA_HEIGHT - 1);
}


void putchar(const char character, const uint8_t fg_color, const uint8_t bg_color){
    uint8_t style = vga_color(fg_color, bg_color);
    vga_char printed = {
        .character = character,
        .style = style
    };

    uint16_t position = get_cursor_pos();
    if (character == '\n'){
        uint16_t y = position / VGA_WIDTH;
        set_cursor_pos(VGA_WIDTH - 1, y);
    } else {
        TEXT_AREA[position] = printed;
    }
}


void putstr(const char *string, const uint8_t fg_color, const uint8_t bg_color){
    while (*string != '\0'){
        putchar(*string++, fg_color, bg_color);
        advance_cursor();
    }
}


uint16_t get_cursor_pos(){
    uint16_t position = 0;

    byte_out(CURSOR_PORT_COMMAND, 0x0F);
    position |= byte_in(CURSOR_PORT_DATA);

    byte_out(CURSOR_PORT_COMMAND, 0x0E);
    position |= byte_in(CURSOR_PORT_DATA) << 8;

    return position;
}


void show_cursor(){
    uint8_t current;

    byte_out(CURSOR_PORT_COMMAND, 0x0A);
    current = byte_in(CURSOR_PORT_DATA);
    byte_out(CURSOR_PORT_DATA, current & 0xC0);

    byte_out(CURSOR_PORT_COMMAND, 0x0B);
    current = byte_in(CURSOR_PORT_DATA);
    byte_out(CURSOR_PORT_DATA, current & 0xE0);
}


void hide_cursor(){
    byte_out(CURSOR_PORT_COMMAND, 0x0A);
    byte_out(CURSOR_PORT_DATA, 0x20);
}


void advance_cursor(){
    uint16_t pos = get_cursor_pos();
    pos++;

    if (pos >= VGA_EXTENT){
        // Move everything up one line
        for (uint16_t i = 0; i < VGA_EXTENT - VGA_WIDTH; i++){
            TEXT_AREA[i] = TEXT_AREA[i + VGA_WIDTH];
        }

        // Clear the last line
        for (uint16_t i = VGA_EXTENT - VGA_WIDTH; i < VGA_EXTENT; i++){
            TEXT_AREA[i].character = ' ';
        }

        pos = VGA_EXTENT - VGA_WIDTH;
    }

    byte_out(CURSOR_PORT_COMMAND, 0x0F);
    byte_out(CURSOR_PORT_DATA, (uint8_t) (pos & 0xFF));

    byte_out(CURSOR_PORT_COMMAND, 0x0E);
    byte_out(CURSOR_PORT_DATA, (uint8_t) ((pos >> 8) & 0xFF));
}


void set_cursor_pos(uint8_t x, uint8_t y){
    uint16_t pos = x + ((uint16_t) VGA_WIDTH * y);

    if (pos >= VGA_EXTENT){
        pos = VGA_EXTENT - 1;
    }

    byte_out(CURSOR_PORT_COMMAND, 0x0F);
    byte_out(CURSOR_PORT_DATA, (uint8_t) (pos & 0xFF));

    byte_out(CURSOR_PORT_COMMAND, 0x0E);
    byte_out(CURSOR_PORT_DATA, (uint8_t) ((pos >> 8) & 0xFF));
}

