#ifndef CPLIB_VERIFY_LONGDOUBLE_REFERENCE_H
#define CPLIB_VERIFY_LONGDOUBLE_REFERENCE_H
#include <stddef.h>
#include <stdint.h>
#ifdef __cplusplus
extern "C" {
#endif
long double ld_ref_parse(const char *s);
int ld_ref_format(char *buffer, size_t n, long double x);
long double ld_ref_binary(int op, long double x, long double y);
long double ld_ref_unary(int op, long double x);
long double ld_ref_fma(long double x, long double y, long double z);
long double ld_ref_u64(uint64_t x);
long double ld_ref_i64(int64_t x);
uint64_t ld_ref_to_u64(long double x);
int64_t ld_ref_to_i64(long double x);
long double ld_ref_array(long double *xs, size_t count);
long double ld_ref_callback(long double (*fn)(long double), long double x);
int ld_ref_signbit(long double x);
int ld_ref_classify(long double x);
int ld_ref_meta(int field);
long double ld_ref_bound(int field);
int ld_ref_rounding(int mode);
#ifdef __cplusplus
}
#endif
#endif
