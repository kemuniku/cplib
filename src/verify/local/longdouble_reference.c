#include "longdouble_reference.h"
#include <float.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <fenv.h>

long double ld_ref_parse(const char *s) { return strtold(s, NULL); }
int ld_ref_format(char *buffer, size_t n, long double x) {
    return snprintf(buffer, n, "%.*Lg", DECIMAL_DIG, x);
}
long double ld_ref_binary(int op, long double x, long double y) {
    switch (op) {
    case 0: return x+y;
    case 1: return x-y;
    case 2: return x*y;
    case 3: return x/y;
    case 4: return powl(x,y);
    case 5: return atan2l(x,y);
    case 6: return hypotl(x,y);
    case 7: return fmodl(x,y);
    case 8: return copysignl(x,y);
    default: return nextafterl(x,y);
    }
}
long double ld_ref_unary(int op, long double x) {
    switch (op) {
    case 0: return fabsl(x);
    case 1: return sqrtl(x);
    case 2: return cbrtl(x);
    case 3: return expl(x);
    case 4: return exp2l(x);
    case 5: return logl(x);
    case 6: return log2l(x);
    case 7: return log10l(x);
    case 8: return sinl(x);
    case 9: return cosl(x);
    case 10: return tanl(x);
    case 11: return asinl(x);
    case 12: return acosl(x);
    case 13: return atanl(x);
    case 14: return floorl(x);
    case 15: return ceill(x);
    case 16: return truncl(x);
    case 17: return roundl(x);
    case 18: return expm1l(x);
    default: return log1pl(x);
    }
}
long double ld_ref_fma(long double x, long double y, long double z) { return fmal(x,y,z); }
long double ld_ref_u64(uint64_t x) { return (long double)x; }
long double ld_ref_i64(int64_t x) { return (long double)x; }
uint64_t ld_ref_to_u64(long double x) { return (uint64_t)x; }
int64_t ld_ref_to_i64(long double x) { return (int64_t)x; }
long double ld_ref_array(long double *xs, size_t count) {
    long double total = 0;
    size_t i;
    for (i=0; i<count; ++i) { total += xs[i]; xs[i] += 1; }
    return total;
}
long double ld_ref_callback(long double (*fn)(long double), long double x) { return fn(x); }
int ld_ref_signbit(long double x) { return signbit(x) != 0; }
int ld_ref_classify(long double x) { return isnan(x) ? 2 : isinf(x) ? 1 : 0; }
int ld_ref_meta(int field) {
    switch(field) {
    case 0: return sizeof(long double);
    case 1: return LDBL_MANT_DIG;
    case 2: return LDBL_DIG;
    case 3: return DECIMAL_DIG;
    case 4: return FLT_RADIX;
    case 5: return LDBL_MIN_EXP;
    default: return LDBL_MAX_EXP;
    }
}
long double ld_ref_bound(int field) {
    switch(field) {
    case 0: return LDBL_EPSILON;
    case 1: return LDBL_MIN;
    case 2: return LDBL_MAX;
    default: return nextafterl(0.L, 1.L);
    }
}
int ld_ref_rounding(int mode) {
    switch(mode) {
    case 0: return fesetround(FE_TONEAREST);
    case 1: return fesetround(FE_DOWNWARD);
    case 2: return fesetround(FE_UPWARD);
    default: return fesetround(FE_TOWARDZERO);
    }
}
#ifdef CPLIB_LONGDOUBLE_REFERENCE_MAIN
int main(void) {
    const char *inputs[] = {"1.0000000000000000001", "9007199254740993",
                           "0.1", "-0", "1e-4932", "1e4932"};
    size_t i;
    printf("size=%d mantissa=%d digits=%d decimal=%d radix=%d minExp=%d maxExp=%d\n",
           ld_ref_meta(0),ld_ref_meta(1),ld_ref_meta(2),ld_ref_meta(3),
           ld_ref_meta(4),ld_ref_meta(5),ld_ref_meta(6));
    for(i=0;i<sizeof(inputs)/sizeof(inputs[0]);++i) {
        long double x=ld_ref_parse(inputs[i]);
        printf("parse %s => %.*Lg\n",inputs[i],DECIMAL_DIG,x);
    }
    printf("epsilon cancellation=%.*Lg sqrt2=%.*Lg\n",DECIMAL_DIG,
           (1.L+LDBL_EPSILON)-1.L,DECIMAL_DIG,sqrtl(2.L));
    return 0;
}
#endif
