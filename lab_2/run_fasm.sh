#!/bin/bash
set -e

ROOT="$(cd "$(dirname "$0")" && pwd)"

if ! command -v fasm >/dev/null 2>&1; then
    echo "Ошибка: FASM не найден."
    echo "Установите flat assembler (fasm), затем повторите запуск."
    exit 1
fi

build_task () {
    local dir="$1"
    local num="$2"
    echo "=== Задание $num ==="
    cd "$ROOT/$dir"
    fasm "task${num}.asm" "task${num}.o"
    ld -o "task${num}.out" "task${num}.o"
    "./task${num}.out"
    echo
}

build_task "01_reverse_string" 1
build_task "02_matrix" 2
build_task "03_triangle" 3
build_task "04_sum_digits" 4
build_task "05_compare_asm_c" 5

cd "$ROOT/05_compare_asm_c"
gcc -Os -s task5.c -o task5_c.out
echo "=== Задание 5: C ==="
./task5_c.out

echo
echo "Размеры:"
ls -lh "$ROOT"/05_compare_asm_c/task5.o        "$ROOT"/05_compare_asm_c/task5.out        "$ROOT"/05_compare_asm_c/task5_c.out
