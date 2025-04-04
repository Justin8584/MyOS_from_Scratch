int my_func(int arg);

void caller()
{
    my_func(0xdede);
}

int my_func(int arg)
{
    return arg;
}