---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_avx2.nim
    title: cplib/matrix/matrix_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_avx2.nim
    title: cplib/matrix/matrix_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_avx2_kernel.nim
    title: cplib/matrix/matrix_avx2_kernel.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_avx2_kernel.nim
    title: cplib/matrix/matrix_avx2_kernel.nim
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
  code: "when not declared CPLIB_MATRIX_MATRIX_AVX2_FIELD_IMPL:\n    const CPLIB_MATRIX_MATRIX_AVX2_FIELD_IMPL\
    \ = 1\n\n    {.emit: \"\"\"\n#ifndef CPLIB_MATRIX_FIELD_KERNEL_HPP\n#define CPLIB_MATRIX_FIELD_KERNEL_HPP\n\
    #include <vector>\n#include <stdexcept>\nnamespace cplib_mat_field_detail {\n\
    struct Field : cplib_mat_detail::Mod {\n  explicit Field(uint32_t p):Mod(p) {\n\
    \    // \u65E2\u5B58\u306E\u7A4D\u30AB\u30FC\u30CD\u30EB\u3068\u540C\u3058Montgomery\u8868\
    \u73FE\u3092\u4F7F\u3046\u3002\n  }\n  uint32_t one() const {\n    // \u6B63\u898F\
    \u5316\u3057\u305FMontgomery\u8868\u73FE\u306E1\u3092\u8FD4\u3059\u3002\n    return\
    \ red(r2);\n  }\n  uint32_t neg(uint32_t a) const {\n    // \u6B63\u898F\u5316\
    \u3057\u305F\u8981\u7D20\u306E\u7B26\u53F7\u3092\u53CD\u8EE2\u3059\u308B\u3002\
    \n    return a ? p-a : 0;\n  }\n  uint32_t mul(uint32_t a,uint32_t b) const {\n\
    \    // \u6B63\u898F\u5316\u3057\u305F2\u8981\u7D20\u306E\u7A4D\u3092\u6C42\u3081\
    \u308B\u3002\n    return red(uint64_t(a)*b);\n  }\n  __m256i mul8(__m256i a,__m256i\
    \ b) const {\n    // \u5076\u6570\u30FB\u5947\u6570\u30EC\u30FC\u30F3\u306E\u7A4D\
    \u3092\u5206\u3051\u30668\u8981\u7D20\u3092\u540C\u6642\u306BMontgomery\u9084\u5143\
    \u3059\u308B\u3002\n    return red8(_mm256_mul_epu32(a,b),\n      _mm256_mul_epu32(_mm256_srli_epi64(a,32),_mm256_srli_epi64(b,32)));\n\
    \  }\n  uint32_t inverse(uint32_t value) const {\n    // \u30D4\u30DC\u30C3\u30C8\
    \u306E\u9006\u5143\u3092\u62E1\u5F35Euclid\u6CD5\u3067\u6C42\u3081\u308B\u3002\
    \n    int64_t a=red(value),b=p,u=1,v=0;\n    while(b){int64_t q=a/b,t=a-q*b;a=b;b=t;t=u-q*v;u=v;v=t;}\n\
    \    if(a!=1)throw std::domain_error(\"matrix pivot is not invertible\");\n  \
    \  u%=p;if(u<0)u+=p;\n    return red(uint64_t(u)*r2);\n  }\n  void read(const\
    \ uint32_t *src,uint32_t *dst,size_t count,bool montgomery) const {\n    // modint\u5185\
    \u90E8\u5024\u30928\u500B\u305A\u3064\u6B63\u898F\u5316\u3057\u305FMontgomery\u8868\
    \u73FE\u306B\u5909\u63DB\u3059\u308B\u3002\n    size_t i=0;__m256i r=_mm256_set1_epi32(r2);\n\
    \    for(;i+8<=count;i+=8){\n      __m256i x=_mm256_loadu_si256((const __m256i*)(src+i));\n\
    \      x=montgomery?_mm256_min_epu32(x,_mm256_sub_epi32(x,vp)):mul8(x,r);\n  \
    \    _mm256_storeu_si256((__m256i*)(dst+i),x);\n    }\n    for(;i<count;i++)dst[i]=montgomery?(src[i]>=p?src[i]-p:src[i]):red(uint64_t(src[i])*r2);\n\
    \  }\n  void write(const uint32_t *src,uint32_t *dst,size_t count,bool montgomery)\
    \ const {\n    // \u8A08\u7B97\u7D50\u679C\u30928\u500B\u305A\u3064\u547C\u3073\
    \u51FA\u3057\u5143\u306Emodint\u8868\u73FE\u3078\u623B\u3059\u3002\n    size_t\
    \ i=0;__m256i v1=_mm256_set1_epi32(1);\n    for(;i+8<=count;i+=8){\n      __m256i\
    \ x=_mm256_loadu_si256((const __m256i*)(src+i));\n      _mm256_storeu_si256((__m256i*)(dst+i),montgomery?x:mul8(x,v1));\n\
    \    }\n    for(;i<count;i++)dst[i]=montgomery?src[i]:red(src[i]);\n  }\n  void\
    \ scale(const uint32_t *src,uint32_t *dst,size_t count,uint32_t factor) const\
    \ {\n    // \u884C\u307E\u305F\u306F\u591A\u9805\u5F0F\u306E\u4FC2\u6570\u3092\
    8\u500B\u305A\u3064\u5B9A\u6570\u500D\u3059\u308B\u3002\n    size_t i=0;__m256i\
    \ f=_mm256_set1_epi32(factor);\n    for(;i+8<=count;i+=8)_mm256_storeu_si256((__m256i*)(dst+i),mul8(_mm256_loadu_si256((const\
    \ __m256i*)(src+i)),f));\n    for(;i<count;i++)dst[i]=mul(src[i],factor);\n  }\n\
    \  template<bool subtract>\n  void addScaled(uint32_t *dst,const uint32_t *src,size_t\
    \ count,uint32_t factor) const {\n    // dst\u306Bfactor*src\u30928\u8981\u7D20\
    \u305A\u3064\u52A0\u6E1B\u7B97\u3059\u308B\u3002\u7AEF\u6570\u306F\u9818\u57DF\
    \u5916\u3092\u8AAD\u307E\u305A\u51E6\u7406\u3059\u308B\u3002\n    size_t i=0;__m256i\
    \ f=_mm256_set1_epi32(factor);\n    for(;i+8<=count;i+=8){\n      __m256i x=_mm256_loadu_si256((const\
    \ __m256i*)(dst+i));\n      __m256i y=mul8(_mm256_loadu_si256((const __m256i*)(src+i)),f);\n\
    \      _mm256_storeu_si256((__m256i*)(dst+i),subtract?sub(x,y):add(x,y));\n  \
    \  }\n    for(;i<count;i++){\n      uint32_t y=mul(src[i],factor);\n      if(subtract)dst[i]=dst[i]>=y?dst[i]-y:dst[i]+p-y;\n\
    \      else {uint32_t x=dst[i]+y;dst[i]=x>=p?x-p:x;}\n    }\n  }\n};\nstatic void\
    \ prepare(const uint32_t *src,const uint32_t *rhs,uint32_t *dst,int h,int w,int\
    \ extra,uint32_t modulus,bool montgomery,bool identity,int sourceStride){\n  //\
    \ \u884C\u5217\u3068\u53F3\u8FBA\u30FB\u5358\u4F4D\u884C\u5217\u3092\u9023\u7D9A\
    \u3057\u305F\u4F5C\u696D\u9818\u57DF\u306B\u30B3\u30D4\u30FC\u3059\u308B\u3002\
    \n  const Field f(modulus);size_t stride=size_t(w)+extra;\n  for(int i=0;i<h;i++){\n\
    \    if(w)f.read(src+size_t(i)*sourceStride,dst+size_t(i)*stride,w,montgomery);\n\
    \    if(rhs)f.read(rhs+i,dst+size_t(i)*stride+w,1,montgomery);\n    if(identity)dst[size_t(i)*stride+w+i]=f.one();\n\
    \  }\n}\nstatic int eliminate(uint32_t *a,int h,int stride,int columns,int *pivots,uint32_t\
    \ *det,uint32_t modulus,bool reduced){\n  // \u524D\u9032\u6D88\u53BB\u3068\u5FC5\
    \u8981\u306B\u5FDC\u3058\u305F\u5F8C\u9000\u6D88\u53BB\u3092AVX2\u306E\u884C\u66F4\
    \u65B0\u3067\u884C\u3046\u3002\n  const Field f(modulus);int rank=0;*det=f.one();\n\
    \  for(int col=0;col<columns && rank<h;col++){\n    int pivot=rank;\n    while(pivot<h\
    \ && !a[size_t(pivot)*stride+col])pivot++;\n    if(pivot==h)continue;\n    uint32_t\
    \ *row=a+size_t(rank)*stride;\n    if(pivot!=rank){\n      std::swap_ranges(row+col,row+stride,a+size_t(pivot)*stride+col);\n\
    \      *det=f.neg(*det);\n    }\n    uint32_t value=row[col];*det=f.mul(*det,value);\n\
    \    f.scale(row+col+1,row+col+1,stride-col-1,f.inverse(value));row[col]=f.one();\n\
    \    for(int i=rank+1;i<h;i++){\n      uint32_t *dst=a+size_t(i)*stride;uint32_t\
    \ factor=dst[col];\n      if(factor){dst[col]=0;f.addScaled<true>(dst+col+1,row+col+1,stride-col-1,factor);}\n\
    \    }\n    pivots[rank++]=col;\n  }\n  if(reduced)for(int r=rank-1;r>=0;r--){\n\
    \    int col=pivots[r];const uint32_t *row=a+size_t(r)*stride;\n    for(int i=0;i<r;i++){\n\
    \      uint32_t *dst=a+size_t(i)*stride;uint32_t factor=dst[col];\n      if(factor){dst[col]=0;f.addScaled<true>(dst+col+1,row+col+1,stride-col-1,factor);}\n\
    \    }\n  }\n  return rank;\n}\nstatic void restore(uint32_t *values,size_t count,uint32_t\
    \ modulus,bool montgomery){\n  // \u4F5C\u696D\u7528\u306EMontgomery\u8868\u73FE\
    \u3092modint\u5185\u90E8\u5024\u3078\u4E00\u62EC\u5909\u63DB\u3059\u308B\u3002\
    \n  Field(modulus).write(values,values,count,montgomery);\n}\nstatic uint32_t\
    \ canonical(uint32_t value,uint32_t modulus){\n  // \u30B9\u30AB\u30E9\u30FC\u306E\
    Montgomery\u8868\u73FE\u3092\u516C\u958B\u5024\u3078\u623B\u3059\u3002\n  return\
    \ Field(modulus).red(value);\n}\nstatic void inverseAdjugate(const uint32_t *a,uint32_t\
    \ *out,int n,int rank,const int *pivots,uint32_t det,uint32_t modulus,bool montgomery,bool\
    \ adjugate,int outputStride){\n  // \u6383\u304D\u51FA\u3057\u305F\u62E1\u5927\
    \u884C\u5217\u304B\u3089\u9006\u884C\u5217\u30FB\u4F59\u56E0\u5B50\u884C\u5217\
    \u3092AVX2\u3067\u5FA9\u5143\u3059\u308B\u3002\n  const Field f(modulus);const\
    \ size_t stride=size_t(n)*2;\n  if(rank<n-1)return;\n  if(rank==n){\n    for(int\
    \ i=0;i<n;i++){\n      const uint32_t *src=a+size_t(i)*stride+n;uint32_t *dst=out+size_t(i)*outputStride;\n\
    \      if(adjugate){f.scale(src,dst,n,det);f.write(dst,dst,n,montgomery);}\n \
    \     else f.write(src,dst,n,montgomery);\n    }\n  }else{\n    int free=0;for(int\
    \ i=0;i<rank;i++)if(pivots[i]==free)free++;\n    uint32_t scale=((n-1-free)&1)?f.neg(det):det;\n\
    \    uint32_t *freeRow=out+size_t(free)*outputStride;\n    f.scale(a+size_t(n-1)*stride+n,freeRow,n,scale);\n\
    \    for(int i=0;i<rank;i++)f.scale(freeRow,out+size_t(pivots[i])*outputStride,n,f.neg(a[size_t(i)*stride+free]));\n\
    \    for(int i=0;i<n;i++)f.write(out+size_t(i)*outputStride,out+size_t(i)*outputStride,n,montgomery);\n\
    \  }\n}\nstruct Hafnian {\n  Field f;size_t degree,stride;\n  Hafnian(uint32_t\
    \ modulus,size_t n):f(modulus),degree(n/2),stride(degree+1){\n    // \u6700\u5F8C\
    \u306B\u5FC5\u8981\u3068\u306A\u308B\u4FC2\u6570\u306E\u6B21\u6570\u3092\u4FDD\
    \u6301\u3059\u308B\u3002\n  }\n  void addProduct(uint32_t *dst,const uint32_t\
    \ *a,const uint32_t *b) const {\n    // x\u500D\u3057\u305F\u591A\u9805\u5F0F\u7A4D\
    \u3092\u6B21\u6570\u3067\u6253\u3061\u5207\u308A\u3001\u4FC2\u6570\u3092AVX2\u3067\
    \u52A0\u7B97\u3059\u308B\u3002\n    for(size_t i=0;i<degree;i++)if(a[i])f.addScaled<false>(dst+i+1,b,degree-i,a[i]);\n\
    \  }\n  std::vector<uint32_t> solve(const std::vector<uint32_t>& a,size_t size)\
    \ const {\n    // \u6700\u5F8C\u306E2\u9802\u70B9\u3092\u4F7F\u3046\u9805\u3092\
    \u5305\u9664\u3057\u3066\u3001\u591A\u9805\u5F0F\u3092\u8FD4\u3059\u3002\n   \
    \ std::vector<uint32_t> answer(stride);\n    if(!size){answer[0]=f.one();return\
    \ answer;}\n    if(size==2){std::copy_n(a.data(),degree,answer.data()+1);return\
    \ answer;}\n    size_t m=size-2,u=m*(m-1)/2*stride,v=m*(m+1)/2*stride;\n    std::vector<uint32_t>\
    \ reduced(a.begin(),a.begin()+u);\n    auto without=solve(reduced,m);\n    for(size_t\
    \ i=0;i<m;i++)for(size_t j=0;j<i;j++){\n      uint32_t *dst=reduced.data()+(i*(i-1)/2+j)*stride;\n\
    \      addProduct(dst,a.data()+u+i*stride,a.data()+v+j*stride);\n      addProduct(dst,a.data()+v+i*stride,a.data()+u+j*stride);\n\
    \    }\n    auto with=solve(reduced,m);\n    size_t i=0;\n    for(;i+8<=stride;i+=8)_mm256_storeu_si256((__m256i*)(answer.data()+i),\n\
    \      f.sub(_mm256_loadu_si256((const __m256i*)(with.data()+i)),_mm256_loadu_si256((const\
    \ __m256i*)(without.data()+i))));\n    for(;i<stride;i++)answer[i]=with[i]>=without[i]?with[i]-without[i]:with[i]+f.p-without[i];\n\
    \    addProduct(answer.data(),with.data(),a.data()+v+m*stride);\n    return answer;\n\
    \  }\n};\nstatic uint32_t hafnian(const uint32_t *src,int n,uint32_t modulus,bool\
    \ montgomery,int sourceStride){\n  // \u4E0B\u4E09\u89D2\u6210\u5206\u3092\u591A\
    \u9805\u5F0F\u306B\u5909\u63DB\u3057\u3001hafnian\u306E\u516C\u958B\u5024\u3092\
    \u8FD4\u3059\u3002\n  Hafnian h(modulus,n);std::vector<uint32_t> a(size_t(n)*(n?size_t(n)-1:0)/2*h.stride);\n\
    \  for(int i=0;i<n;i++)for(int j=0;j<i;j++)h.f.read(src+size_t(i)*sourceStride+j,a.data()+(size_t(i)*(i-1)/2+j)*h.stride,1,montgomery);\n\
    \  return h.f.red(h.solve(a,n)[h.degree]);\n}\n}\n#endif\n\"\"\".}\n\n    proc\
    \ fieldPrepareNative(src, rhs, dst: ptr uint32, h, w, extra: cint, modulus: uint32,\
    \ montgomery, identity: bool, sourceStride: cint) {.importcpp: \"cplib_mat_field_detail::prepare(@)\"\
    , nodecl.}\n    proc fieldEliminateNative(a: ptr uint32, h, stride, columns: cint,\
    \ pivots: ptr cint, det: ptr uint32, modulus: uint32, reduced: bool): cint {.importcpp:\
    \ \"cplib_mat_field_detail::eliminate(@)\", nodecl.}\n    proc fieldRestoreNative(values:\
    \ ptr uint32, count: csize_t, modulus: uint32, montgomery: bool) {.importcpp:\
    \ \"cplib_mat_field_detail::restore(@)\", nodecl.}\n    proc fieldCanonicalNative(value,\
    \ modulus: uint32): uint32 {.importcpp: \"cplib_mat_field_detail::canonical(@)\"\
    , nodecl.}\n    proc fieldInverseAdjugateNative(a, output: ptr uint32, n, rank:\
    \ cint, pivots: ptr cint, det, modulus: uint32, montgomery, adjugate: bool, outputStride:\
    \ cint) {.importcpp: \"cplib_mat_field_detail::inverseAdjugate(@)\", nodecl.}\n\
    \    proc fieldHafnianNative(a: ptr uint32, n: cint, modulus: uint32, montgomery:\
    \ bool, sourceStride: cint): uint32 {.importcpp: \"cplib_mat_field_detail::hafnian(@)\"\
    , nodecl.}\n\n    proc fieldPrepareKernel*(src, rhs, dst: ptr uint32, h, w, extra:\
    \ int, modulus: uint32, montgomery, identity: bool, sourceStride: int = -1) =\n\
    \        ## \u691C\u8A3C\u6E08\u307F\u306E\u5F62\u72B6\u3068\u5185\u90E8\u5024\
    \u3092\u4F5C\u696D\u9818\u57DF\u3078\u6E21\u3059\u3002\n        fieldPrepareNative(src,\
    \ rhs, dst, h.cint, w.cint, extra.cint, modulus, montgomery, identity, (if sourceStride\
    \ < 0: w else: sourceStride).cint)\n    proc fieldEliminateKernel*(a: ptr uint32,\
    \ h, stride, columns: int, pivots: ptr cint, det: var uint32, modulus: uint32,\
    \ reduced: bool): int =\n        ## \u691C\u8A3C\u6E08\u307F\u306E\u4F5C\u696D\
    \u9818\u57DF\u3092AVX2\u3067\u6D88\u53BB\u3059\u308B\u3002\n        fieldEliminateNative(a,\
    \ h.cint, stride.cint, columns.cint, pivots, addr det, modulus, reduced).int\n\
    \    proc fieldRestoreKernel*(values: ptr uint32, count: int, modulus: uint32,\
    \ montgomery: bool) =\n        ## \u4F5C\u696D\u9818\u57DF\u3092modint\u5185\u90E8\
    \u5024\u3078\u4E00\u62EC\u5909\u63DB\u3059\u308B\u3002\n        fieldRestoreNative(values,\
    \ count.csize_t, modulus, montgomery)\n    proc fieldCanonicalKernel*(value, modulus:\
    \ uint32): uint32 =\n        ## \u30B9\u30AB\u30E9\u30FC\u306EMontgomery\u8868\
    \u73FE\u3092\u516C\u958B\u5024\u3078\u623B\u3059\u3002\n        fieldCanonicalNative(value,\
    \ modulus)\n    proc fieldInverseAdjugateKernel*(a, output: ptr uint32, n, rank:\
    \ int, pivots: ptr cint, det, modulus: uint32, montgomery, adjugate: bool, outputStride:\
    \ int = -1) =\n        ## \u9006\u884C\u5217\u30FB\u4F59\u56E0\u5B50\u884C\u5217\
    \u306E\u5FA9\u5143\u3092AVX2\u30AB\u30FC\u30CD\u30EB\u306B\u6E21\u3059\u3002\n\
    \        fieldInverseAdjugateNative(a, output, n.cint, rank.cint, pivots, det,\
    \ modulus, montgomery, adjugate, (if outputStride < 0: n else: outputStride).cint)\n\
    \    proc fieldHafnianKernel*(a: ptr uint32, n: int, modulus: uint32, montgomery:\
    \ bool, sourceStride: int = -1): uint32 =\n        ## \u5BFE\u79F0\u884C\u5217\
    \u306Ehafnian\u3092AVX2\u30AB\u30FC\u30CD\u30EB\u3067\u6C42\u3081\u308B\u3002\n\
    \        fieldHafnianNative(a, n.cint, modulus, montgomery, (if sourceStride <\
    \ 0: n else: sourceStride).cint)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/matrix/matrix_avx2_field_impl.nim
  requiredBy:
  - verify/matrix/linear_algebra/field_algorithms_unit.nim
  - verify/matrix/linear_algebra/field_algorithms_unit.nim
  - verify/matrix/linear_algebra/judge_driver.nim
  - verify/matrix/linear_algebra/judge_driver.nim
  - cplib/matrix/matrix_avx2_kernel.nim
  - cplib/matrix/matrix_avx2_kernel.nim
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
documentation_of: cplib/matrix/matrix_avx2_field_impl.nim
layout: document
redirect_from:
- /library/cplib/matrix/matrix_avx2_field_impl.nim
- /library/cplib/matrix/matrix_avx2_field_impl.nim.html
title: cplib/matrix/matrix_avx2_field_impl.nim
---
