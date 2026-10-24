CC = gcc
SRC = src/matmul.c
BIN = bin

.PHONY: all clean

all: $(BIN)/matmul_O0 $(BIN)/matmul_O3

$(BIN):
	mkdir -p $(BIN)

$(BIN)/matmul_O0: $(SRC) | $(BIN)
	$(CC) -O0 -g -fno-tree-vectorize -o $@ $<

$(BIN)/matmul_O3: $(SRC) | $(BIN)
	$(CC) -O3 -g -march=native -fopt-info-vec-optimized -o $@ $< 2> $(BIN)/matmul_O3.vec.log

clean:
	rm -rf $(BIN)
