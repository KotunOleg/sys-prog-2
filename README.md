# Лабораторна робота: профілювання та оптимізація

Програма: матричне множення (`src/matmul.c`), два варіанти алгоритму:

- `naive` — порядок циклів `ijk`, компілятор не векторизує через strided-доступ до `B`.
- `ikj` — порядок циклів `ikj`, внутрішній цикл по `j` з контигуальним доступом до `B` і `C`, векторизується компілятором (ARM NEON) при `-O3 -march=native`.

Середовище: VirtualBox VM, Ubuntu 24.04 LTS arm64 (Apple Silicon host не підтримує x86_64-гостьові ОС, тому AVX недоступний — SIMD-оптимізацію демонструємо на NEON).

Збірка (у VM):

```
make
```

Дає `bin/matmul_O0` (без оптимізацій) та `bin/matmul_O3` (`-O3 -march=native`).

Запуск: `./bin/matmul_O3 <n> <repeat> <naive|ikj>`

## Структура

- `src/` — вихідний код
- `scripts/` — скрипти для вимірювань (`perf`, `time`, flamegraph, asm diff)
- `results/` — зібрані дані (логи, svg, asm)
- `docs/` — звіт за пунктами завдання

## Порядок виконання (на VM)

1. `scripts/00_setup_vm.sh` — встановлення `perf`, `FlameGraph`, залежностей
2. `make`
3. `scripts/01_flamegraph.sh <n> <repeat> <naive|ikj> <bin>`
4. `scripts/02_time_verbose.sh <n> <repeat> <naive|ikj> <bin>`
5. `scripts/03_perf_stat.sh <n> <repeat> <naive|ikj> <bin>`
6. `scripts/04_perf_record_report.sh <n> <repeat> <naive|ikj> <bin>`
7. `scripts/05_asm_diff.sh`
8. енерговитрати — підхід визначимо після перевірки доступності RAPL/MSR у VM
