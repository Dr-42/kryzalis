//#include <cpu/ports.h>
#include <stdint.h>

uint8_t byte_in(uint16_t port){
    // We're using inline assembly to read from the port

    // "=a" (result) means to put value of rax in result
    // "d" (port) means put value of port in dx

    // asm instructions use the form "command" : "output" : "input"
    // Use the "in" assembly command to read from a port
    uint8_t result;
    __asm__ volatile (
        ".intel_syntax\n"
        "in %%al, %%dx\n" 
        ".att_syntax\n"
        : "=a" (result) 
        : "d" (port));
    return result;
}


void byte_out(uint16_t port, uint8_t data){
    // Use the "out" command to write to a port
    __asm__ volatile (
        ".intel_syntax\n"
        "out %%dx, %%al\n" 
        ".att_syntax\n"
        :
        : "a" (data), "d" (port));
}
