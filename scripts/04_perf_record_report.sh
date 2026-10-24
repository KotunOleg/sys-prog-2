#!/usr/bin/env bash
set -euo pipefail

N=${1:-512}
REPEAT=${2:-20}
IMPL=${3:-ikj}
BIN=${4:-bin/matmul_O3}
TAG=${5:-$(basename "$BIN")_${IMPL}}

mkdir -p results

perf record -g -o "results/perf_report_${TAG}.data" -- "$BIN" "$N" "$REPEAT" "$IMPL"

perf report -i "results/perf_report_${TAG}.data" --stdio > "results/perf_report_${TAG}.txt"

echo "report: results/perf_report_${TAG}.txt"
