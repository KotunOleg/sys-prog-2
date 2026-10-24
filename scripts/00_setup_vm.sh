#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo apt-get install -y \
    build-essential \
    linux-tools-common \
    linux-tools-generic \
    linux-tools-"$(uname -r)" \
    git \
    time \
    binutils \
    msr-tools \
    linux-cpupower

sudo modprobe msr || true

git clone https://github.com/brendangregg/FlameGraph.git tools/FlameGraph 2>/dev/null || true

echo "kernel.perf_event_paranoid=-1" | sudo tee /etc/sysctl.d/99-perf.conf
sudo sysctl --system
