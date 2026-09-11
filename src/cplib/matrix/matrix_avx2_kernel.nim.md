---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_avx2_field_impl.nim
    title: cplib/matrix/matrix_avx2_field_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_avx2_field_impl.nim
    title: cplib/matrix/matrix_avx2_field_impl.nim
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_avx2.nim
    title: cplib/matrix/matrix_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_avx2.nim
    title: cplib/matrix/matrix_avx2.nim
  - icon: ':warning:'
    path: cplib/matrix/static_matrix_avx2.nim
    title: cplib/matrix/static_matrix_avx2.nim
  - icon: ':warning:'
    path: cplib/matrix/static_matrix_avx2.nim
    title: cplib/matrix/static_matrix_avx2.nim
  - icon: ':warning:'
    path: verify/matrix/linear_algebra/field_algorithms_unit.nim
    title: verify/matrix/linear_algebra/field_algorithms_unit.nim
  - icon: ':warning:'
    path: verify/matrix/linear_algebra/field_algorithms_unit.nim
    title: verify/matrix/linear_algebra/field_algorithms_unit.nim
  - icon: ':warning:'
    path: verify/matrix/linear_algebra/judge_driver.nim
    title: verify/matrix/linear_algebra/judge_driver.nim
  - icon: ':warning:'
    path: verify/matrix/linear_algebra/judge_driver.nim
    title: verify/matrix/linear_algebra/judge_driver.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_avx2_gc_test.nim
    title: verify/matrix/matrix_avx2_gc_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_avx2_gc_test.nim
    title: verify/matrix/matrix_avx2_gc_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_avx2_test.nim
    title: verify/matrix/matrix_avx2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_avx2_test.nim
    title: verify/matrix/matrix_avx2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_avx2_unit_test.nim
    title: verify/matrix/matrix_avx2_unit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_avx2_unit_test.nim
    title: verify/matrix/matrix_avx2_unit_test.nim
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
  code: "when not declared CPLIB_MATRIX_MATRIX_AVX2_KERNEL:\n    const CPLIB_MATRIX_MATRIX_AVX2_KERNEL*\
    \ = 1\n    when not defined(cpp):\n        {.error: \"matrix_avx2 requires the\
    \ C++ backend (nim cpp)\".}\n    when not (defined(amd64) or defined(i386)):\n\
    \        {.error: \"matrix_avx2 requires an x86 CPU with AVX2\".}\n    {.passC:\
    \ \"-mavx2\".}\n\n\n    {.emit: \"\"\"\n#ifndef CPLIB_MATRIX_KERNEL_HPP\n#define\
    \ CPLIB_MATRIX_KERNEL_HPP\n#include <immintrin.h>\n#include <stdint.h>\n#include\
    \ <stdlib.h>\n#include <string.h>\n#include <stdio.h>\n#include <algorithm>\n\
    #include <memory>\n#include <new>\n#include <limits>\nnamespace cplib_mat_detail\
    \ {\nstatic size_t elements(size_t n,size_t m){\n  // \u8981\u7D20\u6570\u3068\
    \u30D0\u30A4\u30C8\u6570\u306E\u30AA\u30FC\u30D0\u30FC\u30D5\u30ED\u30FC\u3092\
    \u691C\u67FB\u3059\u308B\u3002\n  if(n && m>(std::numeric_limits<size_t>::max()/sizeof(uint32_t))/n)throw\
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
    }\n}\ntemplate<bool Montgomery>\nstatic void cplib_matrix_product_impl(const uint32_t*a,const\
    \ uint32_t*b,uint32_t*c,int n,int m,int k,uint32_t p){\n  // \u6B63\u898F\u5316\
    \u3055\u308C\u305F\u884C\u512A\u5148\u914D\u5217\u306E\u884C\u5217\u7A4D\u3092\
    AVX2\u3067\u8A08\u7B97\u3059\u308B\u3002\n  if(!n||!k)return;\n  size_t rows=size_t(n),inner=size_t(m),cols=size_t(k);\n\
    \  if(!m||p==1){memset(c,0,cplib_mat_detail::elements(rows,cols)*sizeof(uint32_t));return;}\n\
    \  cplib_mat_detail::Mod q(p);\n  size_t unit=16;\n  while(unit<128 && unit*8<std::min(rows,std::min(inner,cols)))unit*=2;\n\
    \  size_t nn=(rows+unit-1)/unit*unit,mm=(inner+unit-1)/unit*unit,kk=(cols+unit-1)/unit*unit;\n\
    \  std::unique_ptr<uint32_t, decltype(&free)> storage(cplib_mat_detail::allocate(nn,mm,kk,true),&free);\n\
    \  uint32_t*aa=storage.get(),*bb=aa+nn*mm,*cc=bb+mm*kk;\n  for(size_t i=0;i<rows;i++)for(size_t\
    \ j=0;j<inner;j++)aa[i*mm+j]=Montgomery ? (a[i*inner+j]>=p?a[i*inner+j]-p:a[i*inner+j])\
    \ : q.red(uint64_t(a[i*inner+j])*q.r2);\n  for(size_t i=0;i<inner;i++)for(size_t\
    \ j=0;j<cols;j++)bb[i*kk+j]=Montgomery ? (b[i*cols+j]>=p?b[i*cols+j]-p:b[i*cols+j])\
    \ : q.red(uint64_t(b[i*cols+j])*q.r2);\n  cplib_mat_detail::rec(aa,bb,cc,nn,mm,kk,mm,kk,kk,q);\n\
    \  for(size_t i=0;i<rows;i++)for(size_t j=0;j<cols;j++)c[i*cols+j]=Montgomery\
    \ ? cc[i*kk+j] : q.red(cc[i*kk+j]);\n}\nstatic void cplib_matrix_product(const\
    \ uint32_t*a,const uint32_t*b,uint32_t*c,int n,int m,int k,uint32_t p){\n  //\
    \ \u516C\u958B\u5024\u306E\u884C\u5217\u3092\u4E57\u7B97\u3057\u3066\u516C\u958B\
    \u5024\u3078\u623B\u3059\u3002\n  cplib_matrix_product_impl<false>(a,b,c,n,m,k,p);\n\
    }\nstatic void cplib_matrix_product_montgomery(const uint32_t*a,const uint32_t*b,uint32_t*c,int\
    \ n,int m,int k,uint32_t p){\n  // Montgomery\u5185\u90E8\u5024\u306E\u307E\u307E\
    \u884C\u5217\u3092\u4E57\u7B97\u3059\u308B\u3002\n  cplib_matrix_product_impl<true>(a,b,c,n,m,k,p);\n\
    }\nstruct CplibMatrixDigits {\n  char data[10000][4];\n  constexpr CplibMatrixDigits():data{}\
    \ {\n    // 4\u6841\u306E\u6587\u5B57\u5217\u8868\u3092\u30B3\u30F3\u30D1\u30A4\
    \u30EB\u6642\u306B\u6E96\u5099\u3059\u308B\u3002\n    for(unsigned i=0;i<10000;i++){\n\
    \      data[i][0]=char('0'+i/1000);\n      data[i][1]=char('0'+i/100%10);\n  \
    \    data[i][2]=char('0'+i/10%10);\n      data[i][3]=char('0'+i%10);\n    }\n\
    \  }\n};\nstatic constexpr CplibMatrixDigits cplib_matrix_digits{};\nstatic inline\
    \ char* cplib_matrix_write_small(char* output,uint32_t value){\n  // 4\u6841\u4EE5\
    \u4E0B\u306E\u6574\u6570\u3092\u5148\u982D\u306E0\u3092\u7701\u3044\u3066\u66F8\
    \u304D\u51FA\u3059\u3002\n  if(value>=1000){memcpy(output,cplib_matrix_digits.data[value],4);return\
    \ output+4;}\n  if(value>=100){memcpy(output,cplib_matrix_digits.data[value]+1,3);return\
    \ output+3;}\n  if(value>=10){memcpy(output,cplib_matrix_digits.data[value]+2,2);return\
    \ output+2;}\n  *output=char('0'+value);return output+1;\n}\ntemplate<bool Montgomery>\n\
    static size_t cplib_matrix_join_impl(const uint32_t* values,size_t count,uint32_t\
    \ p,char* output,const char* separator,size_t separator_length){\n  // \u8981\u7D20\
    \u3054\u3068\u306E\u6587\u5B57\u5217\u78BA\u4FDD\u3092\u907F\u3051\u30014\u6841\
    \u306E\u8868\u3067\u884C\u5168\u4F53\u3092\u76F4\u63A5\u66F8\u304D\u51FA\u3059\
    \u3002\n  cplib_mat_detail::Mod q(p);\n  char* cursor=output;\n  for(size_t i=0;i<count;i++){\n\
    \    uint32_t value=Montgomery?q.red(values[i]):(values[i]>=p?values[i]-p:values[i]);\n\
    \    if(value<10000){cursor=cplib_matrix_write_small(cursor,value);}\n    else\
    \ {\n      const uint32_t quotient=value/10000,low=value-quotient*10000;\n   \
    \   if(quotient<10000){cursor=cplib_matrix_write_small(cursor,quotient);}\n  \
    \    else {\n        const uint32_t high=quotient/10000,middle=quotient-high*10000;\n\
    \        cursor=cplib_matrix_write_small(cursor,high);\n        memcpy(cursor,cplib_matrix_digits.data[middle],4);cursor+=4;\n\
    \      }\n      memcpy(cursor,cplib_matrix_digits.data[low],4);cursor+=4;\n  \
    \  }\n    if(i+1<count){\n      if(separator_length==1){*cursor++=separator[0];}\n\
    \      else if(separator_length!=0){memcpy(cursor,separator,separator_length);cursor+=separator_length;}\n\
    \    }\n  }\n  return size_t(cursor-output);\n}\nstatic size_t cplib_matrix_join(const\
    \ uint32_t* values,size_t count,uint32_t p,bool montgomery,char* output,const\
    \ char* separator,size_t separator_length){\n  // modint\u306E\u5185\u90E8\u5F62\
    \u5F0F\u306B\u5408\u3063\u305F\u884C\u306E\u6587\u5B57\u5217\u5316\u3092\u9078\
    \u629E\u3059\u308B\u3002\n  if(montgomery)return cplib_matrix_join_impl<true>(values,count,p,output,separator,separator_length);\n\
    \  return cplib_matrix_join_impl<false>(values,count,p,output,separator,separator_length);\n\
    }\nstatic void cplib_matrix_convert(const uint32_t* values,uint32_t* output,size_t\
    \ count,uint32_t p,bool montgomery){\n  // \u516C\u958B\u5024\u306E\u914D\u5217\
    \u3092\u4E00\u62EC\u3057\u3066modint\u306E\u5185\u90E8\u5F62\u5F0F\u3078\u5909\
    \u63DB\u3059\u308B\u3002\n  if(!montgomery){memcpy(output,values,count*sizeof(uint32_t));return;}\n\
    \  cplib_mat_detail::Mod q(p);\n  for(size_t i=0;i<count;i++)output[i]=q.red(uint64_t(values[i])*q.r2);\n\
    }\ntemplate<bool Montgomery>\nstatic void cplib_matrix_write_row_impl(const uint32_t*\
    \ values,size_t count,uint32_t p,FILE* output){\n  // \u6587\u5B57\u5217\u30AA\
    \u30D6\u30B8\u30A7\u30AF\u30C8\u3092\u78BA\u4FDD\u305B\u305A\u3001\u56FA\u5B9A\
    \u30D0\u30C3\u30D5\u30A1\u304B\u3089\u884C\u3092\u51FA\u529B\u3059\u308B\u3002\
    \n  if(count==0){fwrite(\"\\n\",1,1,output);return;}\n  char buffer[16384];\n\
    \  for(size_t begin=0;begin<count;begin+=1024){\n    const size_t length=std::min(size_t(1024),count-begin);\n\
    \    const size_t written=cplib_matrix_join_impl<Montgomery>(values+begin,length,p,buffer,\"\
    \ \",1);\n    buffer[written]=begin+length==count?'\\n':' ';\n    fwrite(buffer,1,written+1,output);\n\
    \  }\n}\nstatic void cplib_matrix_write_row(const uint32_t* values,size_t count,uint32_t\
    \ p,bool montgomery,FILE* output){\n  // modint\u306E\u5185\u90E8\u5F62\u5F0F\u306B\
    \u5408\u308F\u305B\u3066\u7A7A\u767D\u533A\u5207\u308A\u306E\u884C\u3092\u51FA\
    \u529B\u3059\u308B\u3002\n  if(montgomery)cplib_matrix_write_row_impl<true>(values,count,p,output);\n\
    \  else cplib_matrix_write_row_impl<false>(values,count,p,output);\n}\n#endif\n\
    \"\"\".}\n\n    proc canonicalKernel(a, b, c: ptr uint32, n, m, k: cint,\n   \
    \         modulus: uint32) {.importcpp: \"cplib_matrix_product(@)\", nodecl.}\n\
    \n    proc montgomeryKernel(a, b, c: ptr uint32, n, m, k: cint,\n            modulus:\
    \ uint32) {.importcpp: \"cplib_matrix_product_montgomery(@)\", nodecl.}\n\n  \
    \  proc joinKernel(values: ptr uint32, count: csize_t, modulus: uint32,\n    \
    \        montgomery: bool, output: ptr char, separator: cstring,\n           \
    \ separatorLen: csize_t): csize_t {.importcpp: \"cplib_matrix_join(@)\", nodecl.}\n\
    \n    proc convertKernel(values, output: ptr uint32, count: csize_t,\n       \
    \     modulus: uint32, montgomery: bool) {.importcpp: \"cplib_matrix_convert(@)\"\
    , nodecl.}\n\n    proc writeRowKernel(values: ptr uint32, count: csize_t, modulus:\
    \ uint32,\n            montgomery: bool, output: File) {.importcpp: \"cplib_matrix_write_row(@)\"\
    , nodecl.}\n\n    proc matrixProductKernel*(a, b, c: ptr uint32, n, m, k: cint,\n\
    \            modulus: uint32) =\n        ## \u691C\u8A3C\u6E08\u307F\u306E\u5F62\
    \u72B6\u3068\u516C\u958B\u5024\u30D0\u30C3\u30D5\u30A1\u3092\u5185\u90E8\u30AB\
    \u30FC\u30CD\u30EB\u3078\u6E21\u3059\u3002\n        canonicalKernel(a, b, c, n,\
    \ m, k, modulus)\n\n    proc matrixProductMontgomeryKernel*(a, b, c: ptr uint32,\
    \ n, m, k: cint,\n            modulus: uint32) =\n        ## \u691C\u8A3C\u6E08\
    \u307F\u306E\u5F62\u72B6\u3068[0,2*modulus)\u306EMontgomery\u5185\u90E8\u5024\u3092\
    \u76F4\u63A5\u4E57\u7B97\u3059\u308B\u3002\n        montgomeryKernel(a, b, c,\
    \ n, m, k, modulus)\n\n    proc matrixJoinValues*(values: ptr uint32, count: int,\
    \ modulus: uint32,\n            montgomery: bool, separator: string): string =\n\
    \        ## \u9023\u7D9A\u3057\u305Fmodint\u5185\u90E8\u5024\u3092\u4F59\u5206\
    \u306A\u914D\u5217\u5909\u63DB\u306A\u3057\u3067\u6587\u5B57\u5217\u306B\u3059\
    \u308B\u3002\n        if count == 0: return \"\"\n        doAssert count <= high(int)\
    \ div 10, \"matrix string size overflow\"\n        doAssert count == 1 or separator.len\
    \ <= (high(int) - count * 10) div (count - 1),\n            \"matrix string size\
    \ overflow\"\n        result = newString(count * 10 + (count - 1) * separator.len)\n\
    \        let written = joinKernel(values, count.csize_t, modulus, montgomery,\n\
    \            addr result[0], separator.cstring, separator.len.csize_t)\n     \
    \   result.setLen(written.int)\n\n    proc matrixConvertValues*(values, output:\
    \ ptr uint32, count: int,\n            modulus: uint32, montgomery: bool) =\n\
    \        ## \u6B63\u898F\u5316\u6E08\u307F\u516C\u958B\u5024\u3092modint\u306E\
    \u5185\u90E8\u5F62\u5F0F\u3078\u4E00\u62EC\u5909\u63DB\u3059\u308B\u3002\n   \
    \     if count > 0:\n            convertKernel(values, output, count.csize_t,\
    \ modulus, montgomery)\n\n    proc matrixWriteRow*(values: ptr uint32, count:\
    \ int, modulus: uint32,\n            montgomery: bool, output: File) =\n     \
    \   ## modint\u5185\u90E8\u5024\u3092\u4E00\u6642\u914D\u5217\u3084\u6587\u5B57\
    \u5217\u3092\u4F5C\u3089\u305A\u7A7A\u767D\u533A\u5207\u308A\u3067\u51FA\u529B\
    \u3059\u308B\u3002\n        writeRowKernel(values, count.csize_t, modulus, montgomery,\
    \ output)\n\n    include cplib/matrix/matrix_avx2_field_impl\n"
  dependsOn:
  - cplib/matrix/matrix_avx2_field_impl.nim
  - cplib/matrix/matrix_avx2_field_impl.nim
  isVerificationFile: false
  path: cplib/matrix/matrix_avx2_kernel.nim
  requiredBy:
  - verify/matrix/linear_algebra/field_algorithms_unit.nim
  - verify/matrix/linear_algebra/field_algorithms_unit.nim
  - verify/matrix/linear_algebra/judge_driver.nim
  - verify/matrix/linear_algebra/judge_driver.nim
  - cplib/matrix/matrix_avx2.nim
  - cplib/matrix/matrix_avx2.nim
  - cplib/matrix/static_matrix_avx2.nim
  - cplib/matrix/static_matrix_avx2.nim
  timestamp: '2026-09-11 02:58:09+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/matrix/matrix_avx2_test.nim
  - verify/matrix/matrix_avx2_test.nim
  - verify/matrix/matrix_avx2_unit_test.nim
  - verify/matrix/matrix_avx2_unit_test.nim
  - verify/matrix/matrix_avx2_gc_test.nim
  - verify/matrix/matrix_avx2_gc_test.nim
documentation_of: cplib/matrix/matrix_avx2_kernel.nim
layout: document
redirect_from:
- /library/cplib/matrix/matrix_avx2_kernel.nim
- /library/cplib/matrix/matrix_avx2_kernel.nim.html
title: cplib/matrix/matrix_avx2_kernel.nim
---
