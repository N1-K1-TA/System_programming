#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[])
{
    if (argc != 4)
    {
        printf("Usage: ./calc_c a b c\n");
        return 1;
    }

    int a = atoi(argv[1]);
    int b = atoi(argv[2]);
    int c = atoi(argv[3]);

    int result = (((((a + c) - b) * c) * c) - c);

    printf("Expression: (((((a+c)-b)*c)*c)-c)\n");
    printf("a = %d, b = %d, c = %d\n", a, b, c);
    printf("Result = %d\n", result);

    return 0;
}
