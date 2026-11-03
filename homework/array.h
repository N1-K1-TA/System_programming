#ifndef ARRAY_H
#define ARRAY_H

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

// Создание массива заданного размера через анонимное отображение (mmap)
int* create_array(size_t size);

// Освобождение памяти массива (munmap)
void free_array(int* ptr, size_t size);

// Заполнение массива случайными числами в диапазоне [min_val, max_val]
void fill_random(int* ptr, size_t size, int min_val, int max_val);

// Получение списка нечетных чисел
size_t get_odd_numbers(const int* src, size_t src_size, int* dst);

// Подсчет количества простых чисел в массиве
size_t count_primes(const int* ptr, size_t size);

// Реверсирование элементов массива на месте
void reverse_array(int* ptr, size_t size);

#ifdef __cplusplus
}
#endif

#endif // ARRAY_H
