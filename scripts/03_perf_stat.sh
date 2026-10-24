#!/usr/bin/env bash
set -euo pipefail

N=${1:-512}
REPEAT=${2:-20}
IMPL=${3:-ikj}
BIN=${4:-bin/matmul_O3}
TAG=${5:-$(basename "$BIN")_${IMPL}}

mkdir -p results

perf stat -d -r 5 -o "results/perfstat_${TAG}.txt" -- "$BIN" "$N" "$REPEAT" "$IMPL"

cat "results/perfstat_${TAG}.txt"
