#!/usr/bin/env bash
set -euo pipefail

N=${1:-512}
REPEAT=${2:-20}
IMPL=${3:-ikj}
BIN=${4:-bin/matmul_O3}

mkdir -p results

perf record -F 999 -g --call-graph dwarf -o results/perf_${IMPL}.data -- "$BIN" "$N" "$REPEAT" "$IMPL"

perf script -i results/perf_${IMPL}.data \
    | tools/FlameGraph/stackcollapse-perf.pl \
    > results/collapsed_${IMPL}.txt

tools/FlameGraph/flamegraph.pl results/collapsed_${IMPL}.txt \
    > results/flamegraph_${IMPL}.svg

echo "flamegraph: results/flamegraph_${IMPL}.svg"
