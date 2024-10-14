#include <stdio.h>
#include <stdint.h>

typedef struct {
    uint16_t bits;  // 16-bit bfloat16 representation
} bf16_t;

/*bf16 to fp32*/
static inline float bf16_to_fp32(bf16_t h) {
    union {
        float f;
        uint32_t i;
    } u = {.i = (uint32_t)h.bits << 16};
    return u.f;
}

/*fp32 to bf16*/
static inline bf16_t fp32_to_bf16(float s) {
    bf16_t h;
    union {
        float f;
        uint32_t i;
    } u = {.f = s};

    
    if ((u.i & 0x7fffffff) > 0x7f800000) { /* NaN */
        h.bits = (u.i >> 16) | 64;         /* force to quiet */
        return h;
    }
    h.bits = (u.i + (0x7fff + ((u.i >> 0x10) & 1))) >> 0x10;
    return h;
}

/*print*/
void process(float t){

    printf("Original float value: %f\n", t);
    
    union {
        float a;
        uint32_t i;
    } f= {.a = t};

    printf("float32 bits: ");
    
    for (int j = 31; j >= 0; j--) {
        printf("%d", (f.i >> j) & 1);
    }
    printf("\n");

    bf16_t bf = fp32_to_bf16(t);
    
    printf("Converted bfloat16 bits:");
    for (int i = 15; i >= 0; i--) {
        printf("%d", (bf.bits >> i) & 1);
    }
    printf("\n");

    /*bfloat16 to float32*/
    float fp = bf16_to_fp32(bf);
    union {
        float b;
        uint32_t i;
    } fb= {.b= t};
    printf("Converted back to float32 bits:");
    for (int j = 31; j >= 0; j--) {
        printf("%d", (fb.i >> j) & 1);
    }
    printf("\n");
}

int main() {
    float test0= -1.45;
    float test1=  2.55;
    float test2= -3.99;
    process(test0);
    process(test1);
    process(test2);
    return 0;
}
