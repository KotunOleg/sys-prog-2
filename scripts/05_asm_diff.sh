#!/usr/bin/env bash
set -euo pipefail

mkdir -p results

objdump -d --disassemble=matmul_ijk bin/matmul_O0 > results/asm_ijk_O0.txt
objdump -d --disassemble=matmul_ikj bin/matmul_O0 > results/asm_ikj_O0.txt
objdump -d --disassemble=matmul_ijk bin/matmul_O3 > results/asm_ijk_O3.txt
objdump -d --disassemble=matmul_ikj bin/matmul_O3 > results/asm_ikj_O3.txt

echo "neon (simd) instructions in ijk O3:"
grep -Eci 'fmla|fmul|ld1|st1|v[0-9]+\.[0-9]+[bhsd]' results/asm_ijk_O3.txt || true

echo "neon (simd) instructions in ikj O3:"
grep -Eci 'fmla|fmul|ld1|st1|v[0-9]+\.[0-9]+[bhsd]' results/asm_ikj_O3.txt || true
