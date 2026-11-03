#include <stdio.h>
#include <stdlib.h>
#include "array.h"

void print_array(const char* label, const int* arr, size_t size) {
    printf("%s [размер %zu]: ", label, size);
    for (size_t i = 0; i < size; ++i) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

int main() {
    size_t n = 12;
    printf("=== Демонстрация работы с массивом в анонимной памяти (FASM + C) ===\n\n");

    int* arr = create_array(n);
    if (!arr) {
        fprintf(stderr, "Ошибка: не удалось выделить память через mmap!\n");
        return 1;
    }
    printf("1. Массив успешно создан в анонимном отображении (mmap) по адресу: %p\n", (void*)arr);

    fill_random(arr, n, 1, 50);
    print_array("2. Исходный массив (заполнен случайными числами [1..50])", arr, n);

    size_t primes_count = count_primes(arr, n);
    printf("3. Количество простых чисел в массиве: %zu\n", primes_count);

    int* odd_arr = create_array(n);
    if (odd_arr) {
        size_t odd_count = get_odd_numbers(arr, n, odd_arr);
        print_array("4. Список нечетных чисел", odd_arr, odd_count);
        free_array(odd_arr, n);
    }

    reverse_array(arr, n);
    print_array("5. Массив после реверсирования", arr, n);

    free_array(arr, n);
    printf("\nПамять успешно освобождена через munmap.\n");

    return 0;
}
