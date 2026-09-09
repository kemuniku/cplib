---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix.nim
    title: cplib/matrix/matrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix.nim
    title: cplib/matrix/matrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_product_avx2_test.nim
    title: verify/matrix/matrix_product_avx2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_product_avx2_test.nim
    title: verify/matrix/matrix_product_avx2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_product_avx2_unit_test.nim
    title: verify/matrix/matrix_product_avx2_unit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_product_avx2_unit_test.nim
    title: verify/matrix/matrix_product_avx2_unit_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATRIX_MATRIX_PRODUCT_AVX2:\n    const CPLIB_MATRIX_MATRIX_PRODUCT_AVX2*\
    \ = 1\n\n    when not defined(cpp):\n        {.error: \"matrix_product_avx2 requires\
    \ the C++ backend (nim cpp)\".}\n    when not (defined(amd64) or defined(i386)):\n\
    \        {.error: \"matrix_product_avx2 requires an x86 CPU with AVX2\".}\n  \
    \  {.passC: \"-mavx2\".}\n\n    import cplib/matrix/matrix\n    import cplib/modint/modint\n\
    \n    {.emit: \"\"\"\n#ifndef CPLIB_MATRIX_KERNEL_HPP\n#define CPLIB_MATRIX_KERNEL_HPP\n\
    #include <immintrin.h>\n#include <stdint.h>\n#include <stdlib.h>\n#include <string.h>\n\
    #include <algorithm>\n#include <memory>\n#include <new>\n#include <limits>\nnamespace\
    \ cplib_mat_detail {\nstatic size_t elements(size_t n,size_t m){\n  // \u8981\u7D20\
    \u6570\u3068\u30D0\u30A4\u30C8\u6570\u306E\u30AA\u30FC\u30D0\u30FC\u30D5\u30ED\
    \u30FC\u3092\u691C\u67FB\u3059\u308B\u3002\n  if(n && m>(std::numeric_limits<size_t>::max()/sizeof(uint32_t))/n)throw\
    \ std::bad_alloc();\n  return n*m;\n}\nstatic uint32_t* allocate(size_t n,size_t\
    \ m,size_t k,bool clear){\n  // \u4F5C\u696D\u7528\u306E3\u884C\u5217\u3092\u30B5\
    \u30A4\u30BA\u691C\u67FB\u4ED8\u304D\u3067\u307E\u3068\u3081\u3066\u78BA\u4FDD\
    \u3059\u308B\u3002\n  size_t x=elements(n,m),y=elements(m,k),z=elements(n,k);\n\
    \  size_t limit=std::numeric_limits<size_t>::max()/sizeof(uint32_t);\n  if(x>limit-y\
    \ || x+y>limit-z)throw std::bad_alloc();\n  size_t count=x+y+z;\n  uint32_t *result=(uint32_t*)(clear?calloc(count,sizeof(uint32_t)):malloc(count*sizeof(uint32_t)));\n\
    \  if(!result)throw std::bad_alloc();\n  return result;\n}\nstruct Mod {\n  uint32_t\
    \ p, ni, r2;\n  __m256i vp, vi;\n  explicit Mod(uint32_t q):p(q) {\n    // Montgomery\u5909\
    \u63DB\u306B\u5FC5\u8981\u306A\u6CD5\u3068\u5B9A\u6570\u3092\u6E96\u5099\u3059\
    \u308B\u3002\n    uint32_t inv=q;\n    for(int i=0;i<5;i++) inv*=2-q*inv;\n  \
    \  ni=-inv; r2=(uint64_t(0)-uint64_t(q))%q;\n    vp=_mm256_set1_epi32(q); vi=_mm256_set1_epi32(ni);\n\
    \  }\n  uint32_t red(uint64_t t) const {\n    // 64bit\u306E\u7A4D\u3092Montgomery\u9084\
    \u5143\u3057\u3066\u6B63\u898F\u5316\u3059\u308B\u3002\n    uint32_t z=(t+uint64_t(uint32_t(t)*ni)*p)>>32;\n\
    \    return z>=p?z-p:z;\n  }\n  __m256i add(__m256i a,__m256i b) const {\n   \
    \ // \u6B63\u898F\u5316\u3055\u308C\u305F8\u8981\u7D20\u3092\u6CD5\u306E\u4E0B\
    \u3067\u52A0\u7B97\u3059\u308B\u3002\n    __m256i x=_mm256_add_epi32(a,b);\n \
    \   return _mm256_min_epu32(x,_mm256_sub_epi32(x,vp));\n  }\n  __m256i sub(__m256i\
    \ a,__m256i b) const {\n    // \u6B63\u898F\u5316\u3055\u308C\u305F8\u8981\u7D20\
    \u3092\u6CD5\u306E\u4E0B\u3067\u6E1B\u7B97\u3059\u308B\u3002\n    __m256i x=_mm256_sub_epi32(a,b);\n\
    \    return _mm256_min_epu32(x,_mm256_add_epi32(x,vp));\n  }\n  __m256i red8(__m256i\
    \ e,__m256i o) const {\n    // 8\u9805\u306E\u7A4D\u3068\u524D\u56DE\u306E\u548C\
    \u3092\u307E\u3068\u3081\u3066Montgomery\u9084\u5143\u3059\u308B\u3002\n    //\
    \ R=2^32\u3001\u5404\u5024<p\u306A\u3089\u88DC\u6B63\u8FBC\u307F\u30672*p*R+8*p*p<2^64\u3001\
    \u9084\u5143\u5F8C\u306F4*p\u672A\u6E80\u3002\n    __m256i me=_mm256_mul_epu32(_mm256_mul_epu32(e,vi),vp);\n\
    \    __m256i mo=_mm256_mul_epu32(_mm256_mul_epu32(o,vi),vp);\n    e=_mm256_srli_epi64(_mm256_add_epi64(e,me),32);\n\
    \    o=_mm256_add_epi64(o,mo);\n    __m256i r=_mm256_blend_epi32(e,o,0xaa);\n\
    \    r=_mm256_min_epu32(r,_mm256_sub_epi32(r,_mm256_add_epi32(vp,vp)));\n    return\
    \ _mm256_min_epu32(r,_mm256_sub_epi32(r,vp));\n  }\n};\nstatic void base(const\
    \ uint32_t *a,const uint32_t *b,uint32_t *c,size_t n,size_t m,size_t k,size_t\
    \ sa,size_t sb,size_t sc,const Mod &q){\n  // 4\u884C8\u5217\u3092\u540C\u6642\
    \u306B\u8A08\u7B97\u3057\u30018\u9805\u3054\u3068\u306B\u5270\u4F59\u3092\u53D6\
    \u308B\u3002\n  for(size_t i=0;i<n;i+=4) for(size_t j=0;j<k;j+=8){\n    __m256i\
    \ c0=_mm256_setzero_si256(),c1=c0,c2=c0,c3=c0;\n    for(size_t h=0;h<m;h+=8){\n\
    \      // \u524D\u56DE\u306E\u548C\u3092R\u500D\u3057\u3066\u7D2F\u7A4D\u5668\u306B\
    \u5165\u308C\u3001\u30EC\u30B8\u30B9\u30BF\u4E0D\u8DB3\u306B\u3088\u308B\u9000\
    \u907F\u3092\u907F\u3051\u308B\u3002\n      __m256i e0=_mm256_slli_epi64(c0,32),o0=_mm256_blend_epi32(_mm256_setzero_si256(),c0,0xaa);\n\
    \      __m256i e1=_mm256_slli_epi64(c1,32),o1=_mm256_blend_epi32(_mm256_setzero_si256(),c1,0xaa);\n\
    \      __m256i e2=_mm256_slli_epi64(c2,32),o2=_mm256_blend_epi32(_mm256_setzero_si256(),c2,0xaa);\n\
    \      __m256i e3=_mm256_slli_epi64(c3,32),o3=_mm256_blend_epi32(_mm256_setzero_si256(),c3,0xaa);\n\
    \      for(size_t z=h;z<h+8;z++){\n        __m256i v=_mm256_loadu_si256((const\
    \ __m256i*)(b+z*sb+j));\n        __m256i w=_mm256_srli_epi64(v,32);\n        __m256i\
    \ x=_mm256_set1_epi32(a[i*sa+z]);\n        e0=_mm256_add_epi64(e0,_mm256_mul_epu32(x,v));\
    \ o0=_mm256_add_epi64(o0,_mm256_mul_epu32(x,w));\n        x=_mm256_set1_epi32(a[(i+1)*sa+z]);\n\
    \        e1=_mm256_add_epi64(e1,_mm256_mul_epu32(x,v)); o1=_mm256_add_epi64(o1,_mm256_mul_epu32(x,w));\n\
    \        x=_mm256_set1_epi32(a[(i+2)*sa+z]);\n        e2=_mm256_add_epi64(e2,_mm256_mul_epu32(x,v));\
    \ o2=_mm256_add_epi64(o2,_mm256_mul_epu32(x,w));\n        x=_mm256_set1_epi32(a[(i+3)*sa+z]);\n\
    \        e3=_mm256_add_epi64(e3,_mm256_mul_epu32(x,v)); o3=_mm256_add_epi64(o3,_mm256_mul_epu32(x,w));\n\
    \      }\n      c0=q.red8(e0,o0); c1=q.red8(e1,o1);\n      c2=q.red8(e2,o2); c3=q.red8(e3,o3);\n\
    \    }\n    _mm256_storeu_si256((__m256i*)(c+i*sc+j),c0); _mm256_storeu_si256((__m256i*)(c+(i+1)*sc+j),c1);\n\
    \    _mm256_storeu_si256((__m256i*)(c+(i+2)*sc+j),c2); _mm256_storeu_si256((__m256i*)(c+(i+3)*sc+j),c3);\n\
    \  }\n}\nstatic void combine(const uint32_t *a,const uint32_t *b,uint32_t *c,size_t\
    \ n,size_t m,size_t sa,size_t sb,size_t sc,bool minus,const Mod&q){\n  // \u6307\
    \u5B9A\u3055\u308C\u305F\u90E8\u5206\u884C\u5217\u3069\u3046\u3057\u306E\u548C\
    \u307E\u305F\u306F\u5DEE\u3092\u6C42\u3081\u308B\u3002\n  for(size_t i=0;i<n;i++)for(size_t\
    \ j=0;j<m;j+=8){\n    __m256i x=_mm256_loadu_si256((const __m256i*)(a+i*sa+j));\n\
    \    __m256i y=_mm256_loadu_si256((const __m256i*)(b+i*sb+j));\n    _mm256_storeu_si256((__m256i*)(c+i*sc+j),minus?q.sub(x,y):q.add(x,y));\n\
    \  }\n}\nstatic void rec(const uint32_t*a,const uint32_t*b,uint32_t*c,size_t n,size_t\
    \ m,size_t k,size_t sa,size_t sb,size_t sc,const Mod&q){\n  // \u9577\u65B9\u5F62\
    \u306E\u90E8\u5206\u884C\u5217\u3092Strassen\u6CD5\u3067\u518D\u5E30\u7684\u306B\
    \u4E57\u7B97\u3059\u308B\u3002\n  if(std::min(n,std::min(m,k))<=64 || (n%8) ||(m%16)||(k%16)){base(a,b,c,n,m,k,sa,sb,sc,q);return;}\n\
    \  size_t nn=n/2,mm=m/2,kk=k/2;\n  std::unique_ptr<uint32_t, decltype(&free)>\
    \ storage(allocate(nn,mm,kk,false),&free);\n  uint32_t *buf=storage.get();\n \
    \ uint32_t *x=buf,*y=x+nn*mm,*t=y+mm*kk;\n  const uint32_t *a11=a,*a12=a+mm,*a21=a+nn*sa,*a22=a21+mm;\n\
    \  const uint32_t *b11=b,*b12=b+kk,*b21=b+mm*sb,*b22=b21+kk;\n  uint32_t *c11=c,*c12=c+kk,*c21=c+nn*sc,*c22=c21+kk;\n\
    \  for(size_t i=0;i<n;i++)memset(c+i*sc,0,k*4);\n  combine(a11,a22,x,nn,mm,sa,sa,mm,false,q);combine(b11,b22,y,mm,kk,sb,sb,kk,false,q);\n\
    \  rec(x,y,t,nn,mm,kk,mm,kk,kk,q);\n  combine(c11,t,c11,nn,kk,sc,kk,sc,false,q);combine(c22,t,c22,nn,kk,sc,kk,sc,false,q);\n\
    \  combine(a21,a22,x,nn,mm,sa,sa,mm,false,q);rec(x,b11,t,nn,mm,kk,mm,sb,kk,q);\n\
    \  combine(c21,t,c21,nn,kk,sc,kk,sc,false,q);combine(c22,t,c22,nn,kk,sc,kk,sc,true,q);\n\
    \  combine(b12,b22,y,mm,kk,sb,sb,kk,true,q);rec(a11,y,t,nn,mm,kk,sa,kk,kk,q);\n\
    \  combine(c12,t,c12,nn,kk,sc,kk,sc,false,q);combine(c22,t,c22,nn,kk,sc,kk,sc,false,q);\n\
    \  combine(b21,b11,y,mm,kk,sb,sb,kk,true,q);rec(a22,y,t,nn,mm,kk,sa,kk,kk,q);\n\
    \  combine(c11,t,c11,nn,kk,sc,kk,sc,false,q);combine(c21,t,c21,nn,kk,sc,kk,sc,false,q);\n\
    \  combine(a11,a12,x,nn,mm,sa,sa,mm,false,q);rec(x,b22,t,nn,mm,kk,mm,sb,kk,q);\n\
    \  combine(c11,t,c11,nn,kk,sc,kk,sc,true,q);combine(c12,t,c12,nn,kk,sc,kk,sc,false,q);\n\
    \  combine(a21,a11,x,nn,mm,sa,sa,mm,true,q);combine(b11,b12,y,mm,kk,sb,sb,kk,false,q);\n\
    \  rec(x,y,t,nn,mm,kk,mm,kk,kk,q);combine(c22,t,c22,nn,kk,sc,kk,sc,false,q);\n\
    \  combine(a12,a22,x,nn,mm,sa,sa,mm,true,q);combine(b21,b22,y,mm,kk,sb,sb,kk,false,q);\n\
    \  rec(x,y,t,nn,mm,kk,mm,kk,kk,q);combine(c11,t,c11,nn,kk,sc,kk,sc,false,q);\n\
    }\n}\nstatic void cplib_matrix_product(const uint32_t*a,const uint32_t*b,uint32_t*c,int\
    \ n,int m,int k,uint32_t p){\n  // \u6B63\u898F\u5316\u3055\u308C\u305F\u884C\u512A\
    \u5148\u914D\u5217\u306E\u884C\u5217\u7A4D\u3092AVX2\u3067\u8A08\u7B97\u3059\u308B\
    \u3002\n  if(!n||!k)return;\n  size_t rows=size_t(n),inner=size_t(m),cols=size_t(k);\n\
    \  if(!m||p==1){memset(c,0,cplib_mat_detail::elements(rows,cols)*sizeof(uint32_t));return;}\n\
    \  cplib_mat_detail::Mod q(p);\n  size_t unit=16;\n  while(unit<128 && unit*8<std::min(rows,std::min(inner,cols)))unit*=2;\n\
    \  size_t nn=(rows+unit-1)/unit*unit,mm=(inner+unit-1)/unit*unit,kk=(cols+unit-1)/unit*unit;\n\
    \  std::unique_ptr<uint32_t, decltype(&free)> storage(cplib_mat_detail::allocate(nn,mm,kk,true),&free);\n\
    \  uint32_t*aa=storage.get(),*bb=aa+nn*mm,*cc=bb+mm*kk;\n  for(size_t i=0;i<rows;i++)for(size_t\
    \ j=0;j<inner;j++)aa[i*mm+j]=q.red(uint64_t(a[i*inner+j])*q.r2);\n  for(size_t\
    \ i=0;i<inner;i++)for(size_t j=0;j<cols;j++)bb[i*kk+j]=q.red(uint64_t(b[i*cols+j])*q.r2);\n\
    \  cplib_mat_detail::rec(aa,bb,cc,nn,mm,kk,mm,kk,kk,q);\n  for(size_t i=0;i<rows;i++)for(size_t\
    \ j=0;j<cols;j++)c[i*cols+j]=q.red(cc[i*kk+j]);\n}\n#endif\n\"\"\".}\n\n    proc\
    \ matrixProductKernel(a, b, c: ptr uint32, n, m, k: cint,\n            modulus:\
    \ uint32) {.importcpp: \"cplib_matrix_product(@)\", nodecl.}\n\n    proc matrixProduct*(a,\
    \ b: openArray[uint32], n, m, k: int,\n            modulus: uint32 = 998244353u32):\
    \ seq[uint32] =\n        ## \u884C\u512A\u5148\u306E n\xD7m \u884C\u5217\u3068\
    \ m\xD7k \u884C\u5217\u306E\u7A4D\u3092\u3001\u5947\u6570 modulus < 2^30 \u3067\
    \u6C42\u3081\u308B\u3002\n        ## \u5165\u529B\u8981\u7D20\u306F 0 \u4EE5\u4E0A\
    \ modulus \u672A\u6E80\u3002AVX2\u5BFE\u5FDCCPU\u3068C++\u30D0\u30C3\u30AF\u30A8\
    \u30F3\u30C9\u304C\u5FC5\u8981\u3002\n        doAssert modulus > 0 and modulus\
    \ < (1u32 shl 30) and\n            (modulus and 1u32) == 1, \"modulus must be\
    \ odd and in [1, 2^30)\"\n        doAssert n >= 0 and m >= 0 and k >= 0, \"negative\
    \ matrix dimension\"\n        doAssert n <= high(cint).int and m <= high(cint).int\
    \ and\n            k <= high(cint).int, \"matrix dimension exceeds int32\"\n \
    \       doAssert n == 0 or m <= high(int) div n, \"matrix size overflow\"\n  \
    \      doAssert m == 0 or k <= high(int) div m, \"matrix size overflow\"\n   \
    \     doAssert n == 0 or k <= high(int) div n, \"matrix size overflow\"\n    \
    \    doAssert a.len == n * m and b.len == m * k, \"matrix size mismatch\"\n  \
    \      for value in a:\n            assert value < modulus, \"matrix entries must\
    \ be less than modulus\"\n        for value in b:\n            assert value <\
    \ modulus, \"matrix entries must be less than modulus\"\n        result = newSeq[uint32](n\
    \ * k)\n        if n == 0 or m == 0 or k == 0 or modulus == 1:\n            return\n\
    \        matrixProductKernel(unsafeAddr a[0], unsafeAddr b[0], addr result[0],\n\
    \            n.cint, m.cint, k.cint, modulus)\n\n    proc matrixProduct*(a, b:\
    \ openArray[seq[uint32]],\n            modulus: uint32 = 998244353u32): seq[seq[uint32]]\
    \ =\n        ## \u4E8C\u6B21\u5143\u914D\u5217\u306E\u884C\u5217\u7A4D\u3092\u6C42\
    \u3081\u308B\u3002\u7A7A\u914D\u5217\u306E\u5217\u6570\u306F0\u3068\u307F\u306A\
    \u3059\u3002\n        let n = a.len\n        let m = if n == 0: 0 else: a[0].len\n\
    \        let k = if b.len == 0: 0 else: b[0].len\n        doAssert m == b.len,\
    \ \"matrix size mismatch\"\n        for row in a:\n            doAssert row.len\
    \ == m, \"ragged matrix\"\n        for row in b:\n            doAssert row.len\
    \ == k, \"ragged matrix\"\n        doAssert n == 0 or m <= high(int) div n, \"\
    matrix size overflow\"\n        doAssert m == 0 or k <= high(int) div m, \"matrix\
    \ size overflow\"\n        var flatA = newSeq[uint32](n * m)\n        var flatB\
    \ = newSeq[uint32](m * k)\n        for i in 0 ..< n:\n            if m > 0:\n\
    \                copyMem(addr flatA[i * m], unsafeAddr a[i][0], m * sizeof(uint32))\n\
    \        for i in 0 ..< m:\n            if k > 0:\n                copyMem(addr\
    \ flatB[i * k], unsafeAddr b[i][0], k * sizeof(uint32))\n        let flatC = matrixProduct(flatA,\
    \ flatB, n, m, k, modulus)\n        result = newSeq[seq[uint32]](n)\n        for\
    \ i in 0 ..< n:\n            result[i] = newSeq[uint32](k)\n            if k >\
    \ 0:\n                copyMem(addr result[i][0], unsafeAddr flatC[i * k], k *\
    \ sizeof(uint32))\n\n    proc matrixProduct*[T](a, b: Matrix[T]): Matrix[T] =\n\
    \        ## \u65E2\u5B58\u306Emodint\u884C\u5217\u3092\u516C\u958B\u5024\u3078\
    \u5909\u63DB\u3057\u3001AVX2\u3067\u7A4D\u3092\u6C42\u3081\u308B\u3002\n     \
    \   when T isnot MontgomeryModint and T isnot BarrettModint:\n            {.error:\
    \ \"matrixProduct requires MontgomeryModint or BarrettModint\".}\n        let\
    \ n = a.h\n        let m = a.w\n        let k = b.w\n        doAssert m == b.h,\
    \ \"matrix size mismatch\"\n        let modulus = T.umod.uint32\n        doAssert\
    \ modulus > 0 and modulus < (1u32 shl 30) and\n            (modulus and 1u32)\
    \ == 1, \"modulus must be odd and in [1, 2^30)\"\n        doAssert n == 0 or m\
    \ <= high(int) div n, \"matrix size overflow\"\n        doAssert m == 0 or k <=\
    \ high(int) div m, \"matrix size overflow\"\n        var flatA = newSeq[uint32](n\
    \ * m)\n        var flatB = newSeq[uint32](m * k)\n        for i in 0 ..< n:\n\
    \            doAssert a[i].len == m, \"ragged matrix\"\n            for j in 0\
    \ ..< m:\n                flatA[i * m + j] = a[i, j].val.uint32\n        for i\
    \ in 0 ..< m:\n            doAssert b[i].len == k, \"ragged matrix\"\n       \
    \     for j in 0 ..< k:\n                flatB[i * k + j] = b[i, j].val.uint32\n\
    \        let flatC = matrixProduct(flatA, flatB, n, m, k, modulus)\n        result\
    \ = initMatrix(n, k, T.init(0))\n        for i in 0 ..< n:\n            for j\
    \ in 0 ..< k:\n                result[i, j] = T.init(flatC[i * k + j].int)\n"
  dependsOn:
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/matrix/matrix.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/matrix/matrix.nim
  - cplib/math/isqrt.nim
  isVerificationFile: false
  path: cplib/matrix/matrix_product_avx2.nim
  requiredBy: []
  timestamp: '2026-09-08 11:14:25+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/matrix/matrix_product_avx2_unit_test.nim
  - verify/matrix/matrix_product_avx2_unit_test.nim
  - verify/matrix/matrix_product_avx2_test.nim
  - verify/matrix/matrix_product_avx2_test.nim
documentation_of: cplib/matrix/matrix_product_avx2.nim
layout: document
redirect_from:
- /library/cplib/matrix/matrix_product_avx2.nim
- /library/cplib/matrix/matrix_product_avx2.nim.html
title: cplib/matrix/matrix_product_avx2.nim
---
