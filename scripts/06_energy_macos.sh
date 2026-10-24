#!/usr/bin/env bash
set -euo pipefail

BIN=$1
IMPL=$2
N=$3
REPEAT=$4
TAG=$5

mkdir -p results

sudo /usr/bin/powermetrics -i 100 -n 400 --samplers cpu_power,tasks \
    --show-process-energy -o "results/power_${TAG}.txt" 2>/dev/null &
PM_PID=$!

sleep 2
START=$(date +%s)
"$BIN" "$N" "$REPEAT" "$IMPL"
END=$(date +%s)
sleep 2

sudo kill "$PM_PID" 2>/dev/null || true
wait "$PM_PID" 2>/dev/null || true

echo "elapsed_seconds=$((END - START))" > "results/power_${TAG}_elapsed.txt"
cat "results/power_${TAG}_elapsed.txt"
