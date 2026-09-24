/* Лабораторная работа №2, вариант 19
   ФИО: Сорокин Никита Васильевич
   Задание 5. Аналог задания 4 на C.
*/
#include <stdio.h>
#include <stdint.h>

int main(void) {
    uint64_t n = 5161088985;
    unsigned sum = 0;

    do {
        sum += n % 10;
        n /= 10;
    } while (n != 0);

    printf("%u\n", sum);
    return 0;
}
