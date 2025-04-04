#include "../drivers/screen.h"

void main()
{
    // Try a single print operation
    char *video_memory = (char *)0xb8000;
    *video_memory = 'X';
    *(video_memory + 1) = 0x0f;

    clear_screen();
    kprint_at("X", 1, 6);
    kprint_at("This text spans multiple lines", 75, 10);
    kprint_at("There is a line\nbreak", 0, 20);
    kprint("There is a line\nbreak");
    kprint_at("What happens when we run out of space?", 45, 24);

    // Loop forever
    for (;;)
        ;
}