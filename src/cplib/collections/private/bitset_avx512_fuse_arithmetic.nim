## 融合カーネルに埋め込む加算・シフト用の補助関数です。
const fuseArithmeticPrefix = """
#ifndef CPLIB_FUSE_ARITHMETIC_HELPERS
#define CPLIB_FUSE_ARITHMETIC_HELPERS
#include <immintrin.h>
#include <stdint.h>
#include <stddef.h>
static inline uint64_t cplib_fuse_add64(uint64_t a, uint64_t b, unsigned *carry) {
uint64_t sum = a+b, total = sum+*carry;
*carry = (sum<a) | (total<sum);
return total;
}
__attribute__((target("avx512f"))) static inline __m512i cplib_fuse_add512(__m512i a, __m512i b, unsigned *carry) {
__m512i sum = _mm512_add_epi64(a,b);
unsigned g = _mm512_cmp_epu64_mask(sum,a,_MM_CMPINT_LT);
unsigned p = _mm512_cmpeq_epi64_mask(sum,_mm512_set1_epi64(-1));
unsigned c = (p+(g<<1)+*carry)^p;
*carry = c>>8;
return _mm512_mask_add_epi64(sum,(__mmask8)c,sum,_mm512_set1_epi64(1));
}
static inline uint64_t cplib_fuse_word(const uint64_t *x, size_t n, ptrdiff_t i) {
return i>=0 && (size_t)i<n ? x[i] : 0;
}
static inline uint64_t cplib_fuse_shift0(const uint64_t *x, size_t n, size_t i, size_t k, int left) {
ptrdiff_t j = (ptrdiff_t)i + (left ? -(ptrdiff_t)(k>>6) : (ptrdiff_t)(k>>6));
unsigned b=k&63;
uint64_t a=cplib_fuse_word(x,n,j);
if (!b) return a;
return left ? (a<<b)|(cplib_fuse_word(x,n,j-1)>>(64-b)) : (a>>b)|(cplib_fuse_word(x,n,j+1)<<(64-b));
}
"""
const fuseArithmeticHelpers = block:
    var code = fuseArithmeticPrefix
    for width in [256,512]:
        let w = $width
        let lanes = $(width div 64)
        let target = if width == 512: "avx512f" else: "avx2"
        let castType = if width == 512: "void" else: "__m256i"
        code.add("__attribute__((target(\"" & target & "\"))) static inline __m" & w & "i cplib_fuse_load" & w & "(const uint64_t *x,size_t n,ptrdiff_t j) {\n")
        code.add("if (j>=0 && (size_t)j+" & lanes & "<=n) return _mm" & w & "_loadu_si" & w & "((const " & castType & " *)(x+j));\n")
        code.add("uint64_t a[" & lanes & "]; for (int q=0;q<" & lanes & ";++q) a[q]=cplib_fuse_word(x,n,j+q);\nreturn _mm" & w & "_loadu_si" & w & "((const " & castType & " *)a);\n}\n")
        code.add("__attribute__((target(\"" & target & "\"))) static inline __m" & w & "i cplib_fuse_shift" & w & "(const uint64_t *x,size_t n,size_t i,size_t k,int left) {\n")
        code.add("ptrdiff_t j=(ptrdiff_t)i+(left ? -(ptrdiff_t)(k>>6) : (ptrdiff_t)(k>>6)); unsigned b=k&63;\n")
        code.add("__m" & w & "i a=cplib_fuse_load" & w & "(x,n,j); if (!b) return a;\n")
        code.add("__m128i s=_mm_cvtsi32_si128(b), t=_mm_cvtsi32_si128(64-b);\n")
        for left in [true,false]:
            let s1=if left: "sll" else: "srl"
            let s2=if left: "srl" else: "sll"
            code.add((if left: "if (left) " else: "") & "return _mm" & w & "_or_si" & w & "(_mm" & w & "_" & s1 & "_epi64(a,s),_mm" & w & "_" & s2 & "_epi64(cplib_fuse_load" & w & "(x,n,j" & (if left: "-1" else: "+1") & "),t));\n")
        code.add("}\n")
    code & "#endif\n"
