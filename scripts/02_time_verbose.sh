#!/usr/bin/env bash
set -euo pipefail

N=${1:-512}
REPEAT=${2:-20}
IMPL=${3:-ikj}
BIN=${4:-bin/matmul_O3}
TAG=${5:-$(basename "$BIN")_${IMPL}}

mkdir -p results

/usr/bin/time --verbose -o "results/time_${TAG}.txt" "$BIN" "$N" "$REPEAT" "$IMPL"

cat "results/time_${TAG}.txt"
