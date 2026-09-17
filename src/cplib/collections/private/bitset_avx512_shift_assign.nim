## 破壊的シフトを入力を壊さない方向でSIMD処理します。
{.emit: """
#include <immintrin.h>
#include <stdint.h>
#include <stddef.h>
__attribute__((target("avx2"))) static void cplib_assign_left_4(uint64_t *x, size_t n, size_t k) {
size_t off = k >> 6; unsigned b = k & 63;
const __m128i s = _mm_cvtsi32_si128(b), t = _mm_cvtsi32_si128(64-b);
size_t end = n;
while (end >= off + (b != 0) + 4) {
size_t j = end - 4;
__m256i v = _mm256_loadu_si256((const __m256i *)(x+(j-off)));
if (b) v = _mm256_or_si256(_mm256_sll_epi64(v,s), _mm256_srl_epi64(_mm256_loadu_si256((const __m256i *)(x+(j-off-1))),t));
_mm256_storeu_si256((__m256i *)(x+(j)), v);
end -= 4;
}
while (end > off) { size_t j = --end; uint64_t v = x[j-off] << b; if (b && j > off) v |= x[j-off-1] >> (64-b); x[j] = v; }
for (size_t z = 0; z < off; ++z) x[z] = 0;
}
__attribute__((target("avx2"))) static void cplib_assign_right_4(uint64_t *x, size_t n, size_t k) {
size_t off = k >> 6; unsigned b = k & 63;
const __m128i s = _mm_cvtsi32_si128(b), t = _mm_cvtsi32_si128(64-b);
size_t j = 0, count = n-off;
while (j + 4 + (b != 0) <= count) {
__m256i v = _mm256_loadu_si256((const __m256i *)(x+(j+off)));
if (b) v = _mm256_or_si256(_mm256_srl_epi64(v,s), _mm256_sll_epi64(_mm256_loadu_si256((const __m256i *)(x+(j+off+1))),t));
_mm256_storeu_si256((__m256i *)(x+(j)), v);
j += 4;
}
for (; j < count; ++j) { uint64_t v = x[j+off] >> b; if (b && j+off+1 < n) v |= x[j+off+1] << (64-b); x[j] = v; }
for (; j < n; ++j) x[j] = 0;
}
__attribute__((target("avx512f"))) static void cplib_assign_left_8(uint64_t *x, size_t n, size_t k) {
size_t off = k >> 6; unsigned b = k & 63;
const __m128i s = _mm_cvtsi32_si128(b), t = _mm_cvtsi32_si128(64-b);
size_t end = n;
while (end >= off + (b != 0) + 8) {
size_t j = end - 8;
__m512i v = _mm512_loadu_si512((const void *)(x+(j-off)));
if (b) v = _mm512_or_si512(_mm512_sll_epi64(v,s), _mm512_srl_epi64(_mm512_loadu_si512((const void *)(x+(j-off-1))),t));
_mm512_storeu_si512((void *)(x+(j)), v);
end -= 8;
}
while (end > off) { size_t j = --end; uint64_t v = x[j-off] << b; if (b && j > off) v |= x[j-off-1] >> (64-b); x[j] = v; }
for (size_t z = 0; z < off; ++z) x[z] = 0;
}
__attribute__((target("avx512f"))) static void cplib_assign_right_8(uint64_t *x, size_t n, size_t k) {
size_t off = k >> 6; unsigned b = k & 63;
const __m128i s = _mm_cvtsi32_si128(b), t = _mm_cvtsi32_si128(64-b);
size_t j = 0, count = n-off;
while (j + 8 + (b != 0) <= count) {
__m512i v = _mm512_loadu_si512((const void *)(x+(j+off)));
if (b) v = _mm512_or_si512(_mm512_srl_epi64(v,s), _mm512_sll_epi64(_mm512_loadu_si512((const void *)(x+(j+off+1))),t));
_mm512_storeu_si512((void *)(x+(j)), v);
j += 8;
}
for (; j < count; ++j) { uint64_t v = x[j+off] >> b; if (b && j+off+1 < n) v |= x[j+off+1] << (64-b); x[j] = v; }
for (; j < n; ++j) x[j] = 0;
}
static void cplib_assign_left(uint64_t *x, size_t n, size_t k) {
if (__builtin_cpu_supports("avx512f")) cplib_assign_left_8(x,n,k); else cplib_assign_left_4(x,n,k);
}
static void cplib_assign_right(uint64_t *x, size_t n, size_t k) {
if (__builtin_cpu_supports("avx512f")) cplib_assign_right_8(x,n,k); else cplib_assign_right_4(x,n,k);
}
""".}

proc avxShiftLeftAssign(x: ptr uint64, n, k: csize_t) {.importc: "cplib_assign_left", nodecl.}
proc avxShiftRightAssign(x: ptr uint64, n, k: csize_t) {.importc: "cplib_assign_right", nodecl.}
