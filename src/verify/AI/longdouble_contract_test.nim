# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/longdouble
import os
import std/tempfiles


proc peerValue*(x: LongDouble): LongDouble = x + epsilonLongDouble()
proc peerSum*(xs: openArray[LongDouble]): LongDouble =
    result = 0
    for x in xs: result += x
proc peerGeneric*[T](x: T): T = x + x


{.passC: "-frounding-math".}

{.push nodecl, cdecl.}
proc ld_ref_parse(s: cstring): LongDouble {.importc.}
proc ld_ref_format(buffer: cstring, n: csize_t, x: LongDouble): cint {.importc.}
proc ld_ref_binary(op: cint, x, y: LongDouble): LongDouble {.importc.}
proc ld_ref_unary(op: cint, x: LongDouble): LongDouble {.importc.}
proc ld_ref_fma(x, y, z: LongDouble): LongDouble {.importc.}
proc ld_ref_u64(x: uint64): LongDouble {.importc.}
proc ld_ref_i64(x: int64): LongDouble {.importc.}
proc ld_ref_to_u64(x: LongDouble): uint64 {.importc.}
proc ld_ref_to_i64(x: LongDouble): int64 {.importc.}
proc ld_ref_array(xs: ptr LongDouble, count: csize_t): LongDouble {.importc.}
proc ld_ref_callback(fn: proc(x: LongDouble): LongDouble {.cdecl.},
        x: LongDouble): LongDouble {.importc.}
proc ld_ref_signbit(x: LongDouble): cint {.importc.}
proc ld_ref_classify(x: LongDouble): cint {.importc.}
proc ld_ref_meta(field: cint): cint {.importc.}
proc ld_ref_bound(field: cint): LongDouble {.importc.}
proc ld_ref_rounding(mode: cint): cint {.importc.}
{.pop.}

{.emit: """
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
""".}

proc same(a, b: LongDouble) =
    if isNaN(b): doAssert isNaN(a)
    else: doAssert a == b
    if not isNaN(b): doAssert signbit(a) == signbit(b)

proc callback(x: LongDouble): LongDouble {.cdecl.} = x + 1
proc identity(x: LongDouble): LongDouble = x

template rangeError(body: untyped) =
    block:
        var raised = false
        try: discard body
        except RangeDefect: raised = true
        doAssert raised

template valueError(body: untyped) =
    block:
        var raised = false
        try: discard body
        except ValueError: raised = true
        doAssert raised

let info = longDoubleInfo()
for i, value in [info.size, info.mantissaDigits, info.digits, info.decimalDigits,
                  info.radix, info.minExponent, info.maxExponent]:
    doAssert value == int(ld_ref_meta(cint(i)))
same(epsilonLongDouble(), ld_ref_bound(0))
same(minPositiveLongDouble(), ld_ref_bound(1))
same(maxLongDouble(), ld_ref_bound(2))

let inputs = ["0", "-0", "1.0000000000000000001", "0.1", "-0.1",
    "9007199254740993", "18446744073709551615", "-9223372036854775808",
    "0x1.000000000000001p0", "1e-4932", "1e4932", "1e99999", "-1e99999",
    "1e-99999", "-1e-99999", "inf", "-infinity", "nan", "nan(123)"]
for text in inputs:
    let a = parseLongDouble(text)
    let b = ld_ref_parse(text.cstring)
    same(a, b)
    same(parseLongDouble($a), b)
    same(identity(a), b)
    doAssert signbit(a) == (ld_ref_signbit(b) != 0)
    doAssert isNaN(a) == (ld_ref_classify(b) == 2)
    doAssert isInf(a) == (ld_ref_classify(b) == 1)
    var buffer: array[256, char]
    let n = ld_ref_format(cast[cstring](addr buffer[0]), csize_t(buffer.len), b)
    doAssert n > 0 and n < cint(buffer.len)
    doAssert $a == $cast[cstring](addr buffer[0])

let eps = epsilonLongDouble()
let a = to_longdouble(1) + eps
let b = parseLongDouble("0.7")
for op, actual in [a+b, a-b, a*b, a/b, pow(a, b), arctan2(a, b),
                    hypot(a, b), fmod(a, b), copySign(a, b), nextAfter(a, b)]:
    same(actual, ld_ref_binary(cint(op), a, b))
var compound = a
compound += b
same(compound, ld_ref_binary(0, a, b))
compound = a
compound -= b
same(compound, ld_ref_binary(1, a, b))
compound = a
compound *= b
same(compound, ld_ref_binary(2, a, b))
compound = a
compound /= b
same(compound, ld_ref_binary(3, a, b))
for op, actual in [abs(b), sqrt(b), cbrt(b), exp(b), exp2(b), ln(b), log2(b),
    log10(b), sin(b), cos(b), tan(b), arcsin(b), arccos(b), arctan(b),
    floor(b), ceil(b), trunc(b), round(b), expm1(b), ln1p(b)]:
    same(actual, ld_ref_unary(cint(op), b))
same(fma(a, a, -1), ld_ref_fma(a, a, to_longdouble(-1)))
doAssert (a - 1) == eps
if info.radix == 2 and info.mantissaDigits > 53:
    doAssert a.to_float == 1.0
    doAssert a > 1
    doAssert sqrt(to_longdouble(2)) != to_longdouble(sqrt(to_longdouble(2)).to_float)
    doAssert fma(a, 1-eps, -1) != a*(1-eps)-1

for x in [low(int64), -9007199254740993'i64, -1'i64, 0'i64, 1'i64,
          9007199254740993'i64, high(int64)]:
    same(to_longdouble(x), ld_ref_i64(x))
    if info.radix == 2 and info.mantissaDigits >= 64:
        doAssert to_integer(to_longdouble(x), int64) == x
        doAssert ld_ref_to_i64(to_longdouble(x)) == x
for x in [0'u64, 1'u64, 9007199254740993'u64, high(uint64)]:
    same(to_longdouble(x), ld_ref_u64(x))
    if info.radix == 2 and info.mantissaDigits >= 64:
        doAssert to_integer(to_longdouble(x), uint64) == x
        doAssert ld_ref_to_u64(to_longdouble(x)) == x
for text in ["-2.9", "2.9", "-0.99", "0.99"]:
    doAssert to_integer(parseLongDouble(text), int64) == ld_ref_to_i64(
            ld_ref_parse(text.cstring))
rangeError(to_integer(parseLongDouble("9223372036854775808"), int64))
rangeError(to_integer(parseLongDouble("18446744073709551616"), uint64))
rangeError(to_integer(parseLongDouble("-1"), uint64))
rangeError(to_integer(parseLongDouble("inf"), int64))
rangeError(to_integer(parseLongDouble("nan"), uint64))
template integerBoundaries(T: typedesc) =
    block:
        let lo = to_longdouble(low(T))
        let hi = to_longdouble(high(T))
        doAssert to_integer(lo, T) == low(T)
        if sizeof(T) < 8 or info.mantissaDigits >= 64:
            doAssert to_integer(hi, T) == high(T)
            rangeError(to_integer(hi+1, T))
        when T is SomeSignedInt:
            if sizeof(T) < 8 or info.mantissaDigits >= 64:
                rangeError(to_integer(lo-1, T))
integerBoundaries(int8)
integerBoundaries(int16)
integerBoundaries(int32)
integerBoundaries(int64)
integerBoundaries(int)
integerBoundaries(uint8)
integerBoundaries(uint16)
integerBoundaries(uint32)
integerBoundaries(uint64)
integerBoundaries(uint)

var xs = [a, b, maxLongDouble()/4, minPositiveLongDouble()]
let saved = xs
let expected = ((saved[0] + saved[1]) + saved[2]) + saved[3]
same(ld_ref_array(addr xs[0], csize_t(xs.len)), expected)
for i in 0..<xs.len: same(xs[i], saved[i] + 1)
same(ld_ref_callback(callback, a), a+1)
same(peerValue(to_longdouble(1)), a)
same(peerGeneric(a), a+a)
same(peerSum(saved), expected)
var sequence = @[a, b, -a]
same(peerSum(sequence), ld_ref_binary(1, ld_ref_binary(0, a, b), a))
sequence.add(a)
let sequenceCopy = sequence
same(sequenceCopy[3], a)
var boxed: ref LongDouble
new(boxed)
boxed[] = a
same(boxed[], a)
var defaults: array[3, LongDouble]
for x in defaults: same(x, to_longdouble(0))
same(default(LongDouble), to_longdouble(0))

doAssert not signbit(abs(parseLongDouble("-0")))
doAssert isNaN(sqrt(to_longdouble(-1)))
doAssert isInf(maxLongDouble() * 2)
same(parseLongDouble($maxLongDouble()), maxLongDouble())
same(parseLongDouble($minPositiveLongDouble()), minPositiveLongDouble())
same(parseLongDouble($ld_ref_bound(3)), ld_ref_bound(3))
valueError(formatLongDouble(a, -1))
valueError(formatLongDouble(a, int(high(cint))+1))
valueError(cmp(parseLongDouble("nan"), a))
doAssert isInf(to_longdouble(Inf))
doAssert isNaN(to_longdouble(NaN))
doAssert signbit(to_longdouble(-0.0))
doAssert maxLongDouble().to_float == Inf

for mode in 0..3:
    doAssert ld_ref_rounding(cint(mode)) == 0
    let p = parseLongDouble("0.1")
    same(p, ld_ref_parse("0.1"))
    same(a+b, ld_ref_binary(0, a, b))
    same(sqrt(p), ld_ref_unary(1, p))
    doAssert round(parseLongDouble("1.5")) == 2
    doAssert round(parseLongDouble("-1.5")) == -2
    doAssert to_int(parseLongDouble("-2.9")) == -2
doAssert ld_ref_rounding(0) == 0

block:
    let (inputFile, inputPath) = createTempFile("cplib-longdouble-input-", ".txt")
    let (outputFile, outputPath) = createTempFile("cplib-longdouble-output-", ".txt")
    inputFile.write(" \t1.0000000000000000001\n18446744073709551615")
    inputFile.close()
    outputFile.close()
    let savedInput = stdin
    let savedOutput = stdout
    try:
        stdin = open(inputPath)
        stdout = open(outputPath, fmWrite)
        put(read_and_parse_longdouble())
        put(read_and_parse_longdouble())
        var ended = false
        try: discard read_and_parse_longdouble()
        except EOFError: ended = true
        doAssert ended
        stdin.close()
        stdout.close()
    finally:
        stdin = savedInput
        stdout = savedOutput
    let expected = $parseLongDouble("1.0000000000000000001") & "\n" &
                   $parseLongDouble("18446744073709551615") & "\n"
    doAssert readFile(outputPath) == expected
    removeFile(inputPath)
    removeFile(outputPath)

echo "Hello World"
