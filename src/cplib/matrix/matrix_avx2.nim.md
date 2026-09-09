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
  code: "import hashes\nimport cplib/modint/modint\n\nwhen not declared CPLIB_MATRIX_MATRIX_AVX2:\n\
    \    const CPLIB_MATRIX_MATRIX_AVX2* = 1\n    when not defined(cpp):\n       \
    \ {.error: \"matrix_avx2 requires the C++ backend (nim cpp)\".}\n    when not\
    \ (defined(amd64) or defined(i386)):\n        {.error: \"matrix_avx2 requires\
    \ an x86 CPU with AVX2\".}\n    {.passC: \"-mavx2\".}\n\n\n    {.emit: \"\"\"\n\
    #ifndef CPLIB_MATRIX_KERNEL_HPP\n#define CPLIB_MATRIX_KERNEL_HPP\n#include <immintrin.h>\n\
    #include <stdint.h>\n#include <stdlib.h>\n#include <string.h>\n#include <stdio.h>\n\
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
    \ output)\n\n    proc matrixProduct*(a, b: openArray[uint32], n, m, k: int,\n\
    \            modulus: uint32 = 998244353u32): seq[uint32] =\n        ## \u884C\
    \u512A\u5148\u306E\u4E00\u6B21\u5143\u914D\u5217\u306E\u884C\u5217\u7A4D\u3092\
    AVX2\u3067\u8A08\u7B97\u3059\u308B\u3002\n        doAssert modulus > 0 and modulus\
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
    \ =\n        ## \u4E8C\u6B21\u5143\u914D\u5217\u306E\u884C\u5217\u7A4D\u3092AVX2\u3067\
    \u8A08\u7B97\u3059\u308B\u3002\n        let n = a.len\n        let m = if n ==\
    \ 0: 0 else: a[0].len\n        let k = if b.len == 0: 0 else: b[0].len\n     \
    \   doAssert m == b.len, \"matrix size mismatch\"\n        for row in a:\n   \
    \         doAssert row.len == m, \"ragged matrix\"\n        for row in b:\n  \
    \          doAssert row.len == k, \"ragged matrix\"\n        doAssert n == 0 or\
    \ m <= high(int) div n, \"matrix size overflow\"\n        doAssert m == 0 or k\
    \ <= high(int) div m, \"matrix size overflow\"\n        var flatA = newSeq[uint32](n\
    \ * m)\n        var flatB = newSeq[uint32](m * k)\n        for i in 0 ..< n:\n\
    \            if m > 0:\n                copyMem(addr flatA[i * m], unsafeAddr\
    \ a[i][0], m * sizeof(uint32))\n        for i in 0 ..< m:\n            if k >\
    \ 0:\n                copyMem(addr flatB[i * k], unsafeAddr b[i][0], k * sizeof(uint32))\n\
    \        let flatC = matrixProduct(flatA, flatB, n, m, k, modulus)\n        result\
    \ = newSeq[seq[uint32]](n)\n        for i in 0 ..< n:\n            result[i] =\
    \ newSeq[uint32](k)\n            if k > 0:\n                copyMem(addr result[i][0],\
    \ unsafeAddr flatC[i * k], k * sizeof(uint32))\n\n\n    type\n        MatrixStorage[T]\
    \ = ref object\n            values: seq[T]\n        Matrix*[T] = object\n    \
    \        storage: MatrixStorage[T]\n            height, width: int\n         \
    \   modulus: uint32\n        MatrixRow*[T] = object\n            storage: MatrixStorage[T]\n\
    \            offset, length: int\n        MutableMatrixRow*[T] = object\n    \
    \        storage: MatrixStorage[T]\n            offset, length: int\n\n    proc\
    \ `=copy`[T](destination: var Matrix[T], source: Matrix[T]) =\n        ## \u884C\
    \u30D3\u30E5\u30FC\u306F\u8A18\u61B6\u57DF\u3092\u5171\u6709\u3057\u3001\u884C\
    \u5217\u305D\u306E\u3082\u306E\u306E\u4EE3\u5165\u306F\u5024\u3092\u30B3\u30D4\
    \u30FC\u3059\u308B\u3002\n        destination.height = source.height\n       \
    \ destination.width = source.width\n        destination.modulus = source.modulus\n\
    \        if destination.storage == source.storage:\n            return\n     \
    \   if source.storage.isNil:\n            destination.storage = nil\n        else:\n\
    \            var storage = MatrixStorage[T](values: newSeq[T](source.storage.values.len))\n\
    \            for i, value in source.storage.values:\n                storage.values[i]\
    \ = value\n            destination.storage = storage\n\n    proc matrixModulus[T]():\
    \ uint32 {.inline.} =\n        ## \u5229\u7528\u53EF\u80FD\u306Amodint\u578B\u3068\
    \u6CD5\u3092\u691C\u67FB\u3059\u308B\u3002\n        when T isnot MontgomeryModint\
    \ and T isnot BarrettModint:\n            {.error: \"matrix_avx2.Matrix requires\
    \ MontgomeryModint or BarrettModint\".}\n        static:\n            doAssert\
    \ sizeof(T) == sizeof(uint32)\n            doAssert alignof(T) == alignof(uint32)\n\
    \        result = T.umod.uint32\n        doAssert result > 0 and result < (1u32\
    \ shl 30) and (result and 1) == 1,\n            \"modulus must be odd and in [1,\
    \ 2^30)\"\n\n    proc matrixSize(h, w: int): int {.inline.} =\n        ## \u5BF8\
    \u6CD5\u3068\u9023\u7D9A\u914D\u5217\u306E\u8981\u7D20\u6570\u3092\u691C\u67FB\
    \u3059\u308B\u3002\n        doAssert h >= 0 and w >= 0 and h <= high(cint).int\
    \ and w <= high(cint).int,\n            \"invalid matrix dimensions\"\n      \
    \  doAssert h == 0 or w <= (high(int) div sizeof(uint32)) div h,\n           \
    \ \"matrix size overflow\"\n        h * w\n\n    proc checkModulus[T](a: Matrix[T])\
    \ {.inline.} =\n        ## dynamic modint\u306E\u6CD5\u304C\u884C\u5217\u4F5C\u6210\
    \u5F8C\u306B\u5909\u66F4\u3055\u308C\u3066\u3044\u306A\u3044\u3053\u3068\u3092\
    \u78BA\u8A8D\u3059\u308B\u3002\n        let modulus = matrixModulus[T]()\n   \
    \     doAssert a.modulus == 0 or a.modulus == modulus, \"matrix modulus has changed\"\
    \n\n    proc scalar[T](value: T or SomeInteger): T {.inline.} =\n        ## \u6574\
    \u6570\u3092\u6B63\u898F\u5316\u3057\u3066\u304B\u3089modint\u3078\u5909\u63DB\
    \u3059\u308B\u3002\n        when value is T:\n            value\n        elif\
    \ value is SomeUnsignedInt:\n            T.init((value.uint64 mod T.umod.uint64).int)\n\
    \        else:\n            T.init((value.int64 mod T.umod.int64).int)\n\n   \
    \ proc initMatrix*[T](h, w: int, value: T): Matrix[T] =\n        ## h\u884Cw\u5217\
    \u306E\u9023\u7D9A\u914D\u5217\u3092\u78BA\u4FDD\u3057\u3001\u5168\u8981\u7D20\
    \u3092\u6307\u5B9A\u3057\u305F\u5024\u3067\u521D\u671F\u5316\u3059\u308B\u3002\
    \n        let modulus = matrixModulus[T]()\n        let size = matrixSize(h, w)\n\
    \        result = Matrix[T](height: h, width: w, modulus: modulus,\n         \
    \   storage: MatrixStorage[T](values: newSeq[T](size)))\n        let v = scalar[T](value)\n\
    \        for x in result.storage.values.mitems:\n            x = v\n\n    proc\
    \ initMatrix*[T](h, w: int, value: SomeInteger): Matrix[T] =\n        ## \u6574\
    \u6570\u3092\u6CD5\u3067\u6B63\u898F\u5316\u3057\u3066\u5168\u8981\u7D20\u3092\
    \u521D\u671F\u5316\u3059\u308B\u3002\n        bind initMatrix\n        discard\
    \ matrixModulus[T]()\n        initMatrix[T](h, w, scalar[T](value))\n\n    proc\
    \ initMatrix*[T](h, w: int): Matrix[T] =\n        ## h\u884Cw\u5217\u306E\u96F6\
    \u884C\u5217\u3092\u4F5C\u308B\u3002\n        let modulus = matrixModulus[T]()\n\
    \        let size = matrixSize(h, w)\n        Matrix[T](height: h, width: w, modulus:\
    \ modulus,\n            storage: MatrixStorage[T](values: newSeq[T](size)))\n\n\
    \    proc initMatrix*[T](h, w: int, values: sink seq[T]): Matrix[T] =\n      \
    \  ## \u884C\u512A\u5148\u306E\u914D\u5217\u3092\u884C\u5217\u3078\u79FB\u3057\
    \u3001\u4E0D\u8981\u306A\u8981\u7D20\u30B3\u30D4\u30FC\u3092\u907F\u3051\u308B\
    \u3002\n        let modulus = matrixModulus[T]()\n        doAssert values.len\
    \ == matrixSize(h, w), \"matrix size mismatch\"\n        result = Matrix[T](height:\
    \ h, width: w, modulus: modulus,\n            storage: MatrixStorage[T](values:\
    \ values))\n\n    proc initMatrix*[T](h, w: int, values: openArray[uint32]): Matrix[T]\
    \ =\n        ## \u6B63\u898F\u5316\u6E08\u307F\u306E\u516C\u958B\u5024\u304B\u3089\
    modint\u306E\u9023\u7D9A\u884C\u5217\u3092\u4F5C\u308B\u3002\n        result =\
    \ initMatrix[T](h, w)\n        doAssert values.len == result.storage.values.len,\
    \ \"matrix size mismatch\"\n        for value in values:\n            assert value\
    \ < result.modulus, \"matrix entries must be less than modulus\"\n        if values.len\
    \ > 0:\n            matrixConvertValues(unsafeAddr values[0],\n              \
    \  cast[ptr uint32](addr result.storage.values[0]), values.len,\n            \
    \    result.modulus, T is MontgomeryModint)\n\n    proc initMatrixOwned[T](h,\
    \ w: int, values: var seq[uint32]): Matrix[T] =\n        ## \u6240\u6709\u6A29\
    \u3092\u6301\u3064\u516C\u958B\u5024\u914D\u5217\u3092\u6D88\u8CBB\u3057\u3001\
    \u540C\u3058\u9818\u57DF\u3092modint\u914D\u5217\u3068\u3057\u3066\u4F7F\u3046\
    \u3002\n        let modulus = matrixModulus[T]()\n        doAssert values.len\
    \ == matrixSize(h, w), \"matrix size mismatch\"\n        for value in values:\n\
    \            assert value < modulus, \"matrix entries must be less than modulus\"\
    \n        result = Matrix[T](height: h, width: w, modulus: modulus,\n        \
    \    storage: MatrixStorage[T]())\n        # \u4E21modint\u306F\u53C2\u7167\u3092\
    \u542B\u307E\u306A\u3044uint32\u30D5\u30A3\u30FC\u30EB\u30C91\u500B\u3002\u578B\
    \u3092\u5408\u308F\u305B\u3066\u304B\u3089move\u3059\u308B\u3002\n        result.storage.values\
    \ = move(cast[ptr seq[T]](addr values)[])\n        when T is MontgomeryModint:\n\
    \            if result.storage.values.len > 0:\n                let data = cast[ptr\
    \ uint32](addr result.storage.values[0])\n                matrixConvertValues(data,\
    \ data, result.storage.values.len, modulus, true)\n\n    template initMatrix*[T](h,\
    \ w: int, values: seq[uint32]): untyped =\n        ## \u4E00\u6642\u914D\u5217\
    \u306F\u30B3\u30D4\u30FC\u305B\u305A\u53D6\u308A\u8FBC\u307F\u3001\u518D\u5229\
    \u7528\u3059\u308B\u914D\u5217\u306F\u901A\u5E38\u306E\u5024\u30B3\u30D4\u30FC\
    \u3067\u4FDD\u8B77\u3059\u308B\u3002\n        block:\n            let rows = h\n\
    \            let columns = w\n            var owned: seq[uint32] = values\n  \
    \          initMatrixOwned[T](rows, columns, owned)\n\n    proc initMatrix*[T](values:\
    \ openArray[seq[T]]): Matrix[T] =\n        ## \u4E8C\u6B21\u5143\u914D\u5217\u3092\
    \u9023\u7D9A\u914D\u7F6E\u306E\u884C\u5217\u3078\u30B3\u30D4\u30FC\u3059\u308B\
    \u3002\n        let h = values.len\n        let w = if h == 0: 0 else: values[0].len\n\
    \        result = initMatrix[T](h, w)\n        for i, row in values:\n       \
    \     doAssert row.len == w, \"ragged matrix\"\n            for j, value in row:\n\
    \                result.storage.values[i * w + j] = value\n\n    proc toMatrix*[T](values:\
    \ openArray[seq[T]]): Matrix[T] =\n        ## \u4E8C\u6B21\u5143\u914D\u5217\u3092\
    \u884C\u5217\u3078\u5909\u63DB\u3059\u308B\u3002\n        bind initMatrix\n  \
    \      initMatrix(values)\n\n    proc initMatrix*[T](values: openArray[T], vertical:\
    \ bool = false): Matrix[T] =\n        ## \u4E00\u6B21\u5143\u914D\u5217\u3092\
    1\u884C\u307E\u305F\u306F1\u5217\u306E\u884C\u5217\u3078\u5909\u63DB\u3059\u308B\
    \u3002\n        bind initMatrix\n        let h = if vertical: values.len else:\
    \ 1\n        let w = if vertical: 1 else: values.len\n        initMatrix[T](h,\
    \ w, @values)\n\n    proc h*[T](a: Matrix[T]): int {.inline.} =\n        ## \u884C\
    \u6570\u3092\u8FD4\u3059\u3002\n        a.height\n    proc w*[T](a: Matrix[T]):\
    \ int {.inline.} =\n        ## \u5217\u6570\u3092\u8FD4\u3059\u3002\u884C\u6570\
    0\u306E\u5834\u5408\u3082\u5217\u6570\u3092\u4FDD\u6301\u3059\u308B\u3002\n  \
    \      a.width\n\n    template checkIndex(index, size: int) =\n        ## \u901A\
    \u5E38\u306E\u914D\u5217\u3068\u540C\u3058\u30B3\u30F3\u30D1\u30A4\u30EB\u8A2D\
    \u5B9A\u3067\u6DFB\u5B57\u3092\u691C\u67FB\u3059\u308B\u3002\n        when compileOption(\"\
    boundChecks\"):\n            if index < 0 or index >= size:\n                raise\
    \ newException(IndexDefect, \"matrix index out of bounds\")\n\n    proc `[]`*[T](a:\
    \ Matrix[T], r, c: int): T {.inline.} =\n        ## \u6307\u5B9A\u3057\u305F\u8981\
    \u7D20\u3092\u8AAD\u307F\u53D6\u308B\u3002\n        checkIndex(r, a.height)\n\
    \        checkIndex(c, a.width)\n        a.storage.values[r * a.width + c]\n \
    \   proc `[]`*[T](a: var Matrix[T], r, c: int): var T {.inline.} =\n        ##\
    \ \u6307\u5B9A\u3057\u305F\u8981\u7D20\u3078\u306E\u5909\u66F4\u53EF\u80FD\u306A\
    \u53C2\u7167\u3092\u8FD4\u3059\u3002\n        checkIndex(r, a.height)\n      \
    \  checkIndex(c, a.width)\n        a.storage.values[r * a.width + c]\n    proc\
    \ `[]=`*[T](a: var Matrix[T], r, c: int, value: T or SomeInteger) {.inline.} =\n\
    \        ## \u6307\u5B9A\u3057\u305F\u8981\u7D20\u3078\u4EE3\u5165\u3059\u308B\
    \u3002\n        checkIndex(r, a.height)\n        checkIndex(c, a.width)\n    \
    \    a.storage.values[r * a.width + c] = scalar[T](value)\n\n    proc `[]`*[T](a:\
    \ Matrix[T], r: int): MatrixRow[T] {.inline.} =\n        ## \u884C\u3092\u30B3\
    \u30D4\u30FC\u305B\u305A\u8AAD\u307F\u53D6\u308A\u5C02\u7528\u30D3\u30E5\u30FC\
    \u3068\u3057\u3066\u8FD4\u3059\u3002\n        checkIndex(r, a.height)\n      \
    \  MatrixRow[T](storage: a.storage, offset: r * a.width, length: a.width)\n  \
    \  proc `[]`*[T](a: var Matrix[T], r: int): MutableMatrixRow[T] {.inline.} =\n\
    \        ## \u5143\u306E\u884C\u5217\u3092\u66F8\u304D\u63DB\u3048\u3089\u308C\
    \u308B\u884C\u30D3\u30E5\u30FC\u3092\u8FD4\u3059\u3002\n        checkIndex(r,\
    \ a.height)\n        MutableMatrixRow[T](storage: a.storage, offset: r * a.width,\
    \ length: a.width)\n    proc `[]`*[T](row: MatrixRow[T], column: int): T {.inline.}\
    \ =\n        ## \u884C\u30D3\u30E5\u30FC\u306E\u8981\u7D20\u3092\u8AAD\u307F\u53D6\
    \u308B\u3002\n        checkIndex(column, row.length)\n        row.storage.values[row.offset\
    \ + column]\n    proc `[]`*[T](row: MutableMatrixRow[T], column: int): var T {.inline.}\
    \ =\n        ## \u884C\u30D3\u30E5\u30FC\u304B\u3089\u5143\u306E\u8981\u7D20\u3078\
    \u306E\u53C2\u7167\u3092\u8FD4\u3059\u3002\n        checkIndex(column, row.length)\n\
    \        row.storage.values[row.offset + column]\n    proc `[]=`*[T](row: MutableMatrixRow[T],\
    \ column: int, value: T or SomeInteger) {.inline.} =\n        ## \u884C\u30D3\u30E5\
    \u30FC\u3092\u901A\u3057\u3066\u5143\u306E\u884C\u5217\u3078\u4EE3\u5165\u3059\
    \u308B\u3002\n        checkIndex(column, row.length)\n        row.storage.values[row.offset\
    \ + column] = scalar[T](value)\n    proc len*[T](row: MatrixRow[T] or MutableMatrixRow[T]):\
    \ int {.inline.} =\n        ## \u884C\u30D3\u30E5\u30FC\u306E\u5217\u6570\u3092\
    \u8FD4\u3059\u3002\n        row.length\n    iterator items*[T](row: MatrixRow[T]\
    \ or MutableMatrixRow[T]): T =\n        ## \u884C\u306E\u8981\u7D20\u3092\u5DE6\
    \u304B\u3089\u9806\u306B\u5217\u6319\u3059\u308B\u3002\n        for i in 0 ..<\
    \ row.length:\n            yield row.storage.values[row.offset + i]\n    iterator\
    \ pairs*[T](row: MatrixRow[T] or MutableMatrixRow[T]): (int, T) =\n        ##\
    \ \u884C\u306E\u5217\u756A\u53F7\u3068\u8981\u7D20\u3092\u5217\u6319\u3059\u308B\
    \u3002\n        for i in 0 ..< row.length:\n            yield (i, row.storage.values[row.offset\
    \ + i])\n    iterator mitems*[T](row: MutableMatrixRow[T]): var T =\n        ##\
    \ \u884C\u306E\u5404\u8981\u7D20\u3092\u5909\u66F4\u53EF\u80FD\u306A\u53C2\u7167\
    \u3068\u3057\u3066\u5217\u6319\u3059\u308B\u3002\n        for i in 0 ..< row.length:\n\
    \            yield row.storage.values[row.offset + i]\n    proc toSeq*[T](row:\
    \ MatrixRow[T] or MutableMatrixRow[T]): seq[T] =\n        ## \u884C\u30D3\u30E5\
    \u30FC\u3092\u72EC\u7ACB\u3057\u305F\u914D\u5217\u3078\u30B3\u30D4\u30FC\u3059\
    \u308B\u3002\n        result = newSeq[T](row.length)\n        for i in 0 ..< row.length:\n\
    \            result[i] = row.storage.values[row.offset + i]\n    proc join*[T](row:\
    \ MatrixRow[T] or MutableMatrixRow[T], sep: string = \"\"): string =\n       \
    \ ## \u884C\u306E\u5024\u3092\u6307\u5B9A\u3057\u305F\u533A\u5207\u308A\u6587\u5B57\
    \u3067\u9023\u7D50\u3059\u308B\u3002\n        if row.length == 0: return \"\"\n\
    \        let modulus = matrixModulus[T]()\n        let values = cast[ptr uint32](unsafeAddr\
    \ row.storage.values[row.offset])\n        matrixJoinValues(values, row.length,\
    \ modulus, T is MontgomeryModint, sep)\n    proc writeRow*[T](row: MatrixRow[T]\
    \ or MutableMatrixRow[T], output: File = stdout) =\n        ## \u884C\u3092\u7A7A\
    \u767D\u533A\u5207\u308A\u3068\u6539\u884C\u3067\u51FA\u529B\u3057\u3001\u4E00\
    \u6642\u6587\u5B57\u5217\u306E\u78BA\u4FDD\u3092\u907F\u3051\u308B\u3002\n   \
    \     let modulus = matrixModulus[T]()\n        let values = if row.length ==\
    \ 0: nil else:\n            cast[ptr uint32](unsafeAddr row.storage.values[row.offset])\n\
    \        matrixWriteRow(values, row.length, modulus, T is MontgomeryModint, output)\n\
    \    proc `[]=`*[T](a: var Matrix[T], r: int, row: openArray[T]) =\n        ##\
    \ \u5217\u6570\u3092\u4FDD\u3063\u305F\u307E\u307E\u884C\u306E\u5168\u8981\u7D20\
    \u3092\u7F6E\u304D\u63DB\u3048\u308B\u3002\n        checkIndex(r, a.height)\n\
    \        doAssert row.len == a.width, \"matrix row size mismatch\"\n        for\
    \ j, value in row:\n            a.storage.values[r * a.width + j] = value\n  \
    \  proc `[]=`*[T](a: var Matrix[T], r: int, row: MatrixRow[T] or MutableMatrixRow[T])\
    \ =\n        ## \u5225\u306E\u884C\u30D3\u30E5\u30FC\u306E\u5185\u5BB9\u3092\u6307\
    \u5B9A\u3057\u305F\u884C\u3078\u30B3\u30D4\u30FC\u3059\u308B\u3002\n        checkIndex(r,\
    \ a.height)\n        doAssert row.len == a.width, \"matrix row size mismatch\"\
    \n        for j in 0 ..< row.len:\n            a.storage.values[r * a.width +\
    \ j] = row[j]\n\n    proc `*`*[T](a, b: Matrix[T]): Matrix[T] =\n        ## \u9023\
    \u7D9A\u914D\u7F6E\u3055\u308C\u305Fmodint\u3092\u76F4\u63A5AVX2\u30AB\u30FC\u30CD\
    \u30EB\u3078\u6E21\u3057\u3066\u4E57\u7B97\u3059\u308B\u3002\n        checkModulus(a)\n\
    \        checkModulus(b)\n        doAssert a.width == b.height, \"matrix size\
    \ mismatch\"\n        result = initMatrix[T](a.height, b.width)\n        if a.height\
    \ == 0 or a.width == 0 or b.width == 0 or result.modulus == 1:\n            return\n\
    \        let ap = cast[ptr uint32](unsafeAddr a.storage.values[0])\n        let\
    \ bp = cast[ptr uint32](unsafeAddr b.storage.values[0])\n        let cp = cast[ptr\
    \ uint32](addr result.storage.values[0])\n        when T is MontgomeryModint:\n\
    \            matrixProductMontgomeryKernel(ap, bp, cp, a.height.cint,\n      \
    \          a.width.cint, b.width.cint, result.modulus)\n        else:\n      \
    \      matrixProductKernel(ap, bp, cp, a.height.cint,\n                a.width.cint,\
    \ b.width.cint, result.modulus)\n    proc `*=`*[T](a: var Matrix[T], b: Matrix[T])\
    \ =\n        ## \u4F59\u5206\u306A\u5DE6\u884C\u5217\u306E\u30B3\u30D4\u30FC\u3092\
    \u4F5C\u3089\u305A\u306B\u7A4D\u3067\u7F6E\u304D\u63DB\u3048\u308B\u3002\n   \
    \     var product = a * b\n        swap(a, product)\n    proc matrixProduct*[T](a,\
    \ b: Matrix[T]): Matrix[T] =\n        ## \u95A2\u6570\u5F62\u5F0F\u3067\u9AD8\u901F\
    \u884C\u5217\u306E\u7A4D\u3092\u6C42\u3081\u308B\u3002\n        a * b\n\n    template\
    \ defineAssignment(assign, op: untyped) =\n        ## \u52A0\u6E1B\u7B97\u3068\
    \u5BFE\u5FDC\u3059\u308B\u4EE3\u5165\u6F14\u7B97\u5B50\u3092\u307E\u3068\u3081\
    \u3066\u5B9A\u7FA9\u3059\u308B\u3002\n        proc assign*[T](a: var Matrix[T],\
    \ b: Matrix[T]) =\n            ## \u540C\u3058\u5F62\u72B6\u306E\u884C\u5217\u3069\
    \u3046\u3057\u3092\u6210\u5206\u3054\u3068\u306B\u6F14\u7B97\u3059\u308B\u3002\
    \n            checkModulus(a)\n            checkModulus(b)\n            doAssert\
    \ a.h == b.h and a.w == b.w, \"matrix size mismatch\"\n            for i in 0\
    \ ..< a.h * a.w:\n                assign(a.storage.values[i], b.storage.values[i])\n\
    \        proc assign*[T](a: var Matrix[T], value: T or SomeInteger) =\n      \
    \      ## \u5168\u8981\u7D20\u3068\u30B9\u30AB\u30E9\u30FC\u3092\u6210\u5206\u3054\
    \u3068\u306B\u6F14\u7B97\u3059\u308B\u3002\n            checkModulus(a)\n    \
    \        let v = scalar[T](value)\n            for i in 0 ..< a.h * a.w:\n   \
    \             assign(a.storage.values[i], v)\n        proc op*[T](a, b: Matrix[T]):\
    \ Matrix[T] =\n            ## \u540C\u3058\u5F62\u72B6\u306E\u884C\u5217\u306E\
    \u6F14\u7B97\u7D50\u679C\u3092\u65B0\u3057\u3044\u884C\u5217\u306B\u8FD4\u3059\
    \u3002\n            result = a\n            assign(result, b)\n        proc op*[T](a:\
    \ Matrix[T], value: T or SomeInteger): Matrix[T] =\n            ## \u5404\u8981\
    \u7D20\u3068\u30B9\u30AB\u30E9\u30FC\u306E\u6F14\u7B97\u7D50\u679C\u3092\u65B0\
    \u3057\u3044\u884C\u5217\u306B\u8FD4\u3059\u3002\n            result = a\n   \
    \         assign(result, value)\n    defineAssignment(`+=`, `+`)\n    defineAssignment(`-=`,\
    \ `-`)\n\n    proc `-`*[T](a: Matrix[T]): Matrix[T] =\n        ## \u5404\u8981\
    \u7D20\u306E\u52A0\u6CD5\u9006\u5143\u3092\u6C42\u3081\u308B\u3002\n        result\
    \ = initMatrix[T](a.h, a.w)\n        result -= a\n    proc `+`*[T](value: T, a:\
    \ Matrix[T]): Matrix[T] =\n        ## \u30B9\u30AB\u30E9\u30FC\u3068\u884C\u5217\
    \u306E\u5404\u8981\u7D20\u3092\u52A0\u7B97\u3059\u308B\u3002\n        a + value\n\
    \    proc `-`*[T](value: T, a: Matrix[T]): Matrix[T] =\n        ## \u30B9\u30AB\
    \u30E9\u30FC\u304B\u3089\u884C\u5217\u306E\u5404\u8981\u7D20\u3092\u5F15\u304F\
    \u3002\n        bind initMatrix\n        result = initMatrix[T](a.h, a.w, value)\n\
    \        result -= a\n    proc `*=`*[T](a: var Matrix[T], value: T or SomeInteger)\
    \ =\n        ## \u884C\u5217\u306E\u5168\u8981\u7D20\u3092\u30B9\u30AB\u30E9\u30FC\
    \u500D\u3059\u308B\u3002\n        checkModulus(a)\n        let v = scalar[T](value)\n\
    \        for i in 0 ..< a.h * a.w:\n            a.storage.values[i] *= v\n   \
    \ proc `*`*[T](a: Matrix[T], value: T or SomeInteger): Matrix[T] =\n        ##\
    \ \u30B9\u30AB\u30E9\u30FC\u500D\u3057\u305F\u884C\u5217\u3092\u65B0\u3057\u304F\
    \u8FD4\u3059\u3002\n        result = a\n        result *= value\n    proc `*`*[T](value:\
    \ T, a: Matrix[T]): Matrix[T] =\n        ## \u30B9\u30AB\u30E9\u30FC\u500D\u3057\
    \u305F\u884C\u5217\u3092\u65B0\u3057\u304F\u8FD4\u3059\u3002\n        a * value\n\
    \n    proc `+`*[T](value: SomeInteger, a: Matrix[T]): Matrix[T] =\n        ##\
    \ \u6574\u6570\u3068\u884C\u5217\u306E\u5404\u8981\u7D20\u3092\u52A0\u7B97\u3059\
    \u308B\u3002\n        a + scalar[T](value)\n    proc `-`*[T](value: SomeInteger,\
    \ a: Matrix[T]): Matrix[T] =\n        ## \u6574\u6570\u304B\u3089\u884C\u5217\u306E\
    \u5404\u8981\u7D20\u3092\u5F15\u304F\u3002\n        scalar[T](value) - a\n   \
    \ proc `*`*[T](value: SomeInteger, a: Matrix[T]): Matrix[T] =\n        ## \u6574\
    \u6570\u3067\u884C\u5217\u3092\u30B9\u30AB\u30E9\u30FC\u500D\u3059\u308B\u3002\
    \n        a * scalar[T](value)\n\n    proc identity_matrix*[T](n: int, one, zero:\
    \ T): Matrix[T] =\n        ## \u6307\u5B9A\u3057\u305F\u5BFE\u89D2\u6210\u5206\
    \u3068\u975E\u5BFE\u89D2\u6210\u5206\u304B\u3089\u6B63\u65B9\u884C\u5217\u3092\
    \u4F5C\u308B\u3002\n        bind initMatrix\n        result = initMatrix[T](n,\
    \ n, zero)\n        for i in 0 ..< n:\n            result[i, i] = one\n    proc\
    \ identity_matrix*[T](n: int): Matrix[T] =\n        ## n\u884Cn\u5217\u306E\u5358\
    \u4F4D\u884C\u5217\u3092\u4F5C\u308B\u3002\n        bind identity_matrix\n   \
    \     identity_matrix[T](n, T.init(1), T.init(0))\n    proc pow*[T](a: Matrix[T],\
    \ exponent: int): Matrix[T] =\n        ## \u975E\u8CA0\u6574\u6570\u4E57\u3092\
    \u7E70\u308A\u8FD4\u3057\u4E8C\u4E57\u6CD5\u3067\u6C42\u3081\u308B\u3002\n   \
    \     bind identity_matrix\n        checkModulus(a)\n        doAssert a.h == a.w\
    \ and exponent >= 0, \"invalid matrix power\"\n        if exponent == 0:\n   \
    \         return identity_matrix[T](a.h)\n        if exponent == 1:\n        \
    \    return a\n        var base = a\n        var n = exponent\n        var initialized\
    \ = false\n        while n > 0:\n            if (n and 1) != 0:\n            \
    \    if initialized:\n                    result *= base\n                else:\n\
    \                    result = base\n                    initialized = true\n \
    \           n = n shr 1\n            if n != 0: base *= base\n    proc `**`*[T](a:\
    \ Matrix[T], exponent: int): Matrix[T] =\n        ## \u884C\u5217\u306E\u975E\u8CA0\
    \u6574\u6570\u4E57\u3092\u6C42\u3081\u308B\u3002\n        a.pow(exponent)\n  \
    \  proc sum*[T](a: Matrix[T]): T =\n        ## \u5168\u8981\u7D20\u306E\u548C\u3092\
    \u6C42\u3081\u308B\u3002\n        checkModulus(a)\n        result = T.init(0)\n\
    \        for i in 0 ..< a.h * a.w:\n            result += a.storage.values[i]\n\
    \    proc `==`*[T](a, b: Matrix[T]): bool =\n        ## modint\u306E\u5197\u9577\
    \u306A\u5185\u90E8\u8868\u73FE\u306B\u3088\u3089\u305A\u5F62\u72B6\u3068\u5024\
    \u3092\u6BD4\u8F03\u3059\u308B\u3002\n        checkModulus(a)\n        checkModulus(b)\n\
    \        if a.h != b.h or a.w != b.w: return false\n        let modulus = T.umod.int\n\
    \        for i in 0 ..< a.h * a.w:\n            if a.storage.values[i].val mod\
    \ modulus != b.storage.values[i].val mod modulus:\n                return false\n\
    \        true\n    proc hash*[T](a: Matrix[T]): Hash =\n        ## \u5F62\u72B6\
    \u3068\u6B63\u898F\u5316\u3057\u305F\u5024\u304B\u3089\u30CF\u30C3\u30B7\u30E5\
    \u3092\u6C42\u3081\u308B\u3002\n        checkModulus(a)\n        result = hash((a.h,\
    \ a.w, T.umod.int))\n        for i in 0 ..< a.h * a.w:\n            result = result\
    \ !& hash(a.storage.values[i].val mod T.umod.int)\n        result = !$result\n\
    \    proc `$`*[T](a: Matrix[T]): string =\n        ## \u5404\u884C\u3092\u7A7A\
    \u767D\u533A\u5207\u308A\u3067\u8868\u793A\u3059\u308B\u3002\n        checkModulus(a)\n\
    \        for i in 0 ..< a.h:\n            if i != 0: result.add('\\n')\n     \
    \       result.add(a[i].join(\" \"))\n\n    proc matrixProductLegacy[M: object,\
    \ T](a, b: M, Element: typedesc[T]): M =\n        ## \u4E8C\u6B21\u5143\u914D\u5217\
    \u3092\u4FDD\u6301\u3059\u308B\u5F93\u6765\u306EMatrix\u306BAVX2\u306E\u7A4D\u3092\
    \u8FD4\u3059\u3002\n        # \u578B\u306Ftypedesc\u3067\u53D7\u3051\u53D6\u308A\
    \u3001Nim 1.6\u3067\u306Emodint\u306E\u578B\u5F15\u6570\u8AA4\u675F\u7E1B\u3092\
    \u907F\u3051\u308B\u3002\n        bind matrixProduct\n        mixin h, w, `[]`\n\
    \        when T isnot MontgomeryModint and T isnot BarrettModint:\n          \
    \  {.error: \"matrixProduct requires MontgomeryModint or BarrettModint\".}\n \
    \       let n = a.h\n        let m = a.w\n        let k = b.w\n        doAssert\
    \ m == b.h, \"matrix size mismatch\"\n        let modulus = T.umod.uint32\n  \
    \      doAssert modulus > 0 and modulus < (1u32 shl 30) and\n                (modulus\
    \ and 1u32) == 1, \"modulus must be odd and in [1, 2^30)\"\n        doAssert n\
    \ == 0 or m <= high(int) div n, \"matrix size overflow\"\n        doAssert m ==\
    \ 0 or k <= high(int) div m, \"matrix size overflow\"\n        var flatA = newSeq[uint32](n\
    \ * m)\n        var flatB = newSeq[uint32](m * k)\n        for i in 0 ..< n:\n\
    \            doAssert a[i].len == m, \"ragged matrix\"\n            for j in 0\
    \ ..< m:\n                flatA[i * m + j] = a[i, j].val.uint32\n        for i\
    \ in 0 ..< m:\n            doAssert b[i].len == k, \"ragged matrix\"\n       \
    \     for j in 0 ..< k:\n                flatB[i * k + j] = b[i, j].val.uint32\n\
    \        let flatC = matrixProduct(flatA, flatB, n, m, k, modulus)\n        #\
    \ \u65E7Matrix\u3092import\u305B\u305A\u3001\u63D0\u51FA\u7528\u306E\u30BD\u30FC\
    \u30B9\u5C55\u958B\u3067\u3082Matrix\u540D\u306E\u91CD\u8907\u3092\u9632\u3050\
    \u3002\n        for name, values in fieldPairs(result):\n            when name\
    \ == \"arr\" and values is seq[seq[T]]:\n                values = newSeq[seq[T]](n)\n\
    \                for i in 0 ..< n:\n                    values[i] = newSeq[T](k)\n\
    \                    for j in 0 ..< k:\n                        values[i][j] =\
    \ T.init(flatC[i * k + j].int)\n            else:\n                {.error: \"\
    unsupported matrix representation\".}\n\n    type LegacyMatrix[T] = concept x\n\
    \        x.h is int\n        x.w is int\n        x[0, 0] is T\n\n    proc matrixProduct*[T](a,\
    \ b: LegacyMatrix[T]): auto =\n        ## \u5F93\u6765\u306EMatrix\u578B\u3092\
    \u4FDD\u3063\u305F\u307E\u307EAVX2\u3067\u884C\u5217\u7A4D\u3092\u8A08\u7B97\u3059\
    \u308B\u3002\n        mixin `[]`\n        matrixProductLegacy(a, b, typeof(a[0,\
    \ 0]))\n"
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  isVerificationFile: false
  path: cplib/matrix/matrix_avx2.nim
  requiredBy: []
  timestamp: '2026-09-08 11:14:25+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/matrix/matrix_avx2_test.nim
  - verify/matrix/matrix_avx2_test.nim
  - verify/matrix/matrix_avx2_unit_test.nim
  - verify/matrix/matrix_avx2_unit_test.nim
documentation_of: cplib/matrix/matrix_avx2.nim
layout: document
redirect_from:
- /library/cplib/matrix/matrix_avx2.nim
- /library/cplib/matrix/matrix_avx2.nim.html
title: cplib/matrix/matrix_avx2.nim
---
