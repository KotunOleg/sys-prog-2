#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

static float *alloc_matrix(int n) {
    return malloc(sizeof(float) * (size_t)n * (size_t)n);
}

static void fill_matrix(float *m, int n, unsigned seed) {
    unsigned x = seed;
    for (size_t i = 0; i < (size_t)n * n; i++) {
        x = x * 1103515245u + 12345u;
        m[i] = (float)(x % 1000) / 1000.0f;
    }
}

static void matmul_ijk(const float *a, const float *b, float *c, int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            float sum = 0.0f;
            for (int k = 0; k < n; k++) {
                sum += a[i * n + k] * b[k * n + j];
            }
            c[i * n + j] = sum;
        }
    }
}

static void matmul_ikj(const float *a, const float *b, float *c, int n) {
    memset(c, 0, sizeof(float) * (size_t)n * (size_t)n);
    for (int i = 0; i < n; i++) {
        for (int k = 0; k < n; k++) {
            float aik = a[i * n + k];
            for (int j = 0; j < n; j++) {
                c[i * n + j] += aik * b[k * n + j];
            }
        }
    }
}

static double checksum(const float *m, int n) {
    double s = 0.0;
    for (size_t i = 0; i < (size_t)n * n; i++) {
        s += m[i];
    }
    return s;
}

int main(int argc, char **argv) {
    if (argc < 4) {
        fprintf(stderr, "usage: %s <n> <repeat> <naive|ikj>\n", argv[0]);
        return 1;
    }

    int n = atoi(argv[1]);
    int repeat = atoi(argv[2]);
    const char *impl = argv[3];

    float *a = alloc_matrix(n);
    float *b = alloc_matrix(n);
    float *c = alloc_matrix(n);

    fill_matrix(a, n, 1);
    fill_matrix(b, n, 2);

    void (*fn)(const float *, const float *, float *, int);
    if (strcmp(impl, "naive") == 0) {
        fn = matmul_ijk;
    } else if (strcmp(impl, "ikj") == 0) {
        fn = matmul_ikj;
    } else {
        fprintf(stderr, "unknown impl: %s\n", impl);
        return 1;
    }

    for (int r = 0; r < repeat; r++) {
        fn(a, b, c, n);
    }

    printf("n=%d repeat=%d impl=%s checksum=%f\n", n, repeat, impl, checksum(c, n));

    free(a);
    free(b);
    free(c);
    return 0;
}
