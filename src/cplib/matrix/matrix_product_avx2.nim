when not declared CPLIB_MATRIX_MATRIX_PRODUCT_AVX2:
    const CPLIB_MATRIX_MATRIX_PRODUCT_AVX2* = 1

    when not defined(cpp):
        {.error: "matrix_product_avx2 requires the C++ backend (nim cpp)".}
    when not (defined(amd64) or defined(i386)):
        {.error: "matrix_product_avx2 requires an x86 CPU with AVX2".}
    {.passC: "-mavx2".}

    import cplib/matrix/matrix
    import cplib/modint/modint

    {.emit: """
#ifndef CPLIB_MATRIX_KERNEL_HPP
#define CPLIB_MATRIX_KERNEL_HPP
#include <immintrin.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <algorithm>
#include <memory>
#include <new>
#include <limits>
namespace cplib_mat_detail {
static size_t elements(size_t n,size_t m){
  // 要素数とバイト数のオーバーフローを検査する。
  if(n && m>(std::numeric_limits<size_t>::max()/sizeof(uint32_t))/n)throw std::bad_alloc();
  return n*m;
}
static uint32_t* allocate(size_t n,size_t m,size_t k,bool clear){
  // 作業用の3行列をサイズ検査付きでまとめて確保する。
  size_t x=elements(n,m),y=elements(m,k),z=elements(n,k);
  size_t limit=std::numeric_limits<size_t>::max()/sizeof(uint32_t);
  if(x>limit-y || x+y>limit-z)throw std::bad_alloc();
  size_t count=x+y+z;
  uint32_t *result=(uint32_t*)(clear?calloc(count,sizeof(uint32_t)):malloc(count*sizeof(uint32_t)));
  if(!result)throw std::bad_alloc();
  return result;
}
struct Mod {
  uint32_t p, ni, r2;
  __m256i vp, vi;
  explicit Mod(uint32_t q):p(q) {
    // Montgomery変換に必要な法と定数を準備する。
    uint32_t inv=q;
    for(int i=0;i<5;i++) inv*=2-q*inv;
    ni=-inv; r2=(uint64_t(0)-uint64_t(q))%q;
    vp=_mm256_set1_epi32(q); vi=_mm256_set1_epi32(ni);
  }
  uint32_t red(uint64_t t) const {
    // 64bitの積をMontgomery還元して正規化する。
    uint32_t z=(t+uint64_t(uint32_t(t)*ni)*p)>>32;
    return z>=p?z-p:z;
  }
  __m256i add(__m256i a,__m256i b) const {
    // 正規化された8要素を法の下で加算する。
    __m256i x=_mm256_add_epi32(a,b);
    return _mm256_min_epu32(x,_mm256_sub_epi32(x,vp));
  }
  __m256i sub(__m256i a,__m256i b) const {
    // 正規化された8要素を法の下で減算する。
    __m256i x=_mm256_sub_epi32(a,b);
    return _mm256_min_epu32(x,_mm256_add_epi32(x,vp));
  }
  __m256i red8(__m256i e,__m256i o) const {
    // 8項の積と前回の和をまとめてMontgomery還元する。
    // R=2^32、各値<pなら補正込みで2*p*R+8*p*p<2^64、還元後は4*p未満。
    __m256i me=_mm256_mul_epu32(_mm256_mul_epu32(e,vi),vp);
    __m256i mo=_mm256_mul_epu32(_mm256_mul_epu32(o,vi),vp);
    e=_mm256_srli_epi64(_mm256_add_epi64(e,me),32);
    o=_mm256_add_epi64(o,mo);
    __m256i r=_mm256_blend_epi32(e,o,0xaa);
    r=_mm256_min_epu32(r,_mm256_sub_epi32(r,_mm256_add_epi32(vp,vp)));
    return _mm256_min_epu32(r,_mm256_sub_epi32(r,vp));
  }
};
static void base(const uint32_t *a,const uint32_t *b,uint32_t *c,size_t n,size_t m,size_t k,size_t sa,size_t sb,size_t sc,const Mod &q){
  // 4行8列を同時に計算し、8項ごとに剰余を取る。
  for(size_t i=0;i<n;i+=4) for(size_t j=0;j<k;j+=8){
    __m256i c0=_mm256_setzero_si256(),c1=c0,c2=c0,c3=c0;
    for(size_t h=0;h<m;h+=8){
      // 前回の和をR倍して累積器に入れ、レジスタ不足による退避を避ける。
      __m256i e0=_mm256_slli_epi64(c0,32),o0=_mm256_blend_epi32(_mm256_setzero_si256(),c0,0xaa);
      __m256i e1=_mm256_slli_epi64(c1,32),o1=_mm256_blend_epi32(_mm256_setzero_si256(),c1,0xaa);
      __m256i e2=_mm256_slli_epi64(c2,32),o2=_mm256_blend_epi32(_mm256_setzero_si256(),c2,0xaa);
      __m256i e3=_mm256_slli_epi64(c3,32),o3=_mm256_blend_epi32(_mm256_setzero_si256(),c3,0xaa);
      for(size_t z=h;z<h+8;z++){
        __m256i v=_mm256_loadu_si256((const __m256i*)(b+z*sb+j));
        __m256i w=_mm256_srli_epi64(v,32);
        __m256i x=_mm256_set1_epi32(a[i*sa+z]);
        e0=_mm256_add_epi64(e0,_mm256_mul_epu32(x,v)); o0=_mm256_add_epi64(o0,_mm256_mul_epu32(x,w));
        x=_mm256_set1_epi32(a[(i+1)*sa+z]);
        e1=_mm256_add_epi64(e1,_mm256_mul_epu32(x,v)); o1=_mm256_add_epi64(o1,_mm256_mul_epu32(x,w));
        x=_mm256_set1_epi32(a[(i+2)*sa+z]);
        e2=_mm256_add_epi64(e2,_mm256_mul_epu32(x,v)); o2=_mm256_add_epi64(o2,_mm256_mul_epu32(x,w));
        x=_mm256_set1_epi32(a[(i+3)*sa+z]);
        e3=_mm256_add_epi64(e3,_mm256_mul_epu32(x,v)); o3=_mm256_add_epi64(o3,_mm256_mul_epu32(x,w));
      }
      c0=q.red8(e0,o0); c1=q.red8(e1,o1);
      c2=q.red8(e2,o2); c3=q.red8(e3,o3);
    }
    _mm256_storeu_si256((__m256i*)(c+i*sc+j),c0); _mm256_storeu_si256((__m256i*)(c+(i+1)*sc+j),c1);
    _mm256_storeu_si256((__m256i*)(c+(i+2)*sc+j),c2); _mm256_storeu_si256((__m256i*)(c+(i+3)*sc+j),c3);
  }
}
static void combine(const uint32_t *a,const uint32_t *b,uint32_t *c,size_t n,size_t m,size_t sa,size_t sb,size_t sc,bool minus,const Mod&q){
  // 指定された部分行列どうしの和または差を求める。
  for(size_t i=0;i<n;i++)for(size_t j=0;j<m;j+=8){
    __m256i x=_mm256_loadu_si256((const __m256i*)(a+i*sa+j));
    __m256i y=_mm256_loadu_si256((const __m256i*)(b+i*sb+j));
    _mm256_storeu_si256((__m256i*)(c+i*sc+j),minus?q.sub(x,y):q.add(x,y));
  }
}
static void rec(const uint32_t*a,const uint32_t*b,uint32_t*c,size_t n,size_t m,size_t k,size_t sa,size_t sb,size_t sc,const Mod&q){
  // 長方形の部分行列をStrassen法で再帰的に乗算する。
  if(std::min(n,std::min(m,k))<=64 || (n%8) ||(m%16)||(k%16)){base(a,b,c,n,m,k,sa,sb,sc,q);return;}
  size_t nn=n/2,mm=m/2,kk=k/2;
  std::unique_ptr<uint32_t, decltype(&free)> storage(allocate(nn,mm,kk,false),&free);
  uint32_t *buf=storage.get();
  uint32_t *x=buf,*y=x+nn*mm,*t=y+mm*kk;
  const uint32_t *a11=a,*a12=a+mm,*a21=a+nn*sa,*a22=a21+mm;
  const uint32_t *b11=b,*b12=b+kk,*b21=b+mm*sb,*b22=b21+kk;
  uint32_t *c11=c,*c12=c+kk,*c21=c+nn*sc,*c22=c21+kk;
  for(size_t i=0;i<n;i++)memset(c+i*sc,0,k*4);
  combine(a11,a22,x,nn,mm,sa,sa,mm,false,q);combine(b11,b22,y,mm,kk,sb,sb,kk,false,q);
  rec(x,y,t,nn,mm,kk,mm,kk,kk,q);
  combine(c11,t,c11,nn,kk,sc,kk,sc,false,q);combine(c22,t,c22,nn,kk,sc,kk,sc,false,q);
  combine(a21,a22,x,nn,mm,sa,sa,mm,false,q);rec(x,b11,t,nn,mm,kk,mm,sb,kk,q);
  combine(c21,t,c21,nn,kk,sc,kk,sc,false,q);combine(c22,t,c22,nn,kk,sc,kk,sc,true,q);
  combine(b12,b22,y,mm,kk,sb,sb,kk,true,q);rec(a11,y,t,nn,mm,kk,sa,kk,kk,q);
  combine(c12,t,c12,nn,kk,sc,kk,sc,false,q);combine(c22,t,c22,nn,kk,sc,kk,sc,false,q);
  combine(b21,b11,y,mm,kk,sb,sb,kk,true,q);rec(a22,y,t,nn,mm,kk,sa,kk,kk,q);
  combine(c11,t,c11,nn,kk,sc,kk,sc,false,q);combine(c21,t,c21,nn,kk,sc,kk,sc,false,q);
  combine(a11,a12,x,nn,mm,sa,sa,mm,false,q);rec(x,b22,t,nn,mm,kk,mm,sb,kk,q);
  combine(c11,t,c11,nn,kk,sc,kk,sc,true,q);combine(c12,t,c12,nn,kk,sc,kk,sc,false,q);
  combine(a21,a11,x,nn,mm,sa,sa,mm,true,q);combine(b11,b12,y,mm,kk,sb,sb,kk,false,q);
  rec(x,y,t,nn,mm,kk,mm,kk,kk,q);combine(c22,t,c22,nn,kk,sc,kk,sc,false,q);
  combine(a12,a22,x,nn,mm,sa,sa,mm,true,q);combine(b21,b22,y,mm,kk,sb,sb,kk,false,q);
  rec(x,y,t,nn,mm,kk,mm,kk,kk,q);combine(c11,t,c11,nn,kk,sc,kk,sc,false,q);
}
}
static void cplib_matrix_product(const uint32_t*a,const uint32_t*b,uint32_t*c,int n,int m,int k,uint32_t p){
  // 正規化された行優先配列の行列積をAVX2で計算する。
  if(!n||!k)return;
  size_t rows=size_t(n),inner=size_t(m),cols=size_t(k);
  if(!m||p==1){memset(c,0,cplib_mat_detail::elements(rows,cols)*sizeof(uint32_t));return;}
  cplib_mat_detail::Mod q(p);
  size_t unit=16;
  while(unit<128 && unit*8<std::min(rows,std::min(inner,cols)))unit*=2;
  size_t nn=(rows+unit-1)/unit*unit,mm=(inner+unit-1)/unit*unit,kk=(cols+unit-1)/unit*unit;
  std::unique_ptr<uint32_t, decltype(&free)> storage(cplib_mat_detail::allocate(nn,mm,kk,true),&free);
  uint32_t*aa=storage.get(),*bb=aa+nn*mm,*cc=bb+mm*kk;
  for(size_t i=0;i<rows;i++)for(size_t j=0;j<inner;j++)aa[i*mm+j]=q.red(uint64_t(a[i*inner+j])*q.r2);
  for(size_t i=0;i<inner;i++)for(size_t j=0;j<cols;j++)bb[i*kk+j]=q.red(uint64_t(b[i*cols+j])*q.r2);
  cplib_mat_detail::rec(aa,bb,cc,nn,mm,kk,mm,kk,kk,q);
  for(size_t i=0;i<rows;i++)for(size_t j=0;j<cols;j++)c[i*cols+j]=q.red(cc[i*kk+j]);
}
#endif
""".}

    proc matrixProductKernel(a, b, c: ptr uint32, n, m, k: cint,
            modulus: uint32) {.importcpp: "cplib_matrix_product(@)", nodecl.}

    proc matrixProduct*(a, b: openArray[uint32], n, m, k: int,
            modulus: uint32 = 998244353u32): seq[uint32] =
        ## 行優先の n×m 行列と m×k 行列の積を、奇数 modulus < 2^30 で求める。
        ## 入力要素は 0 以上 modulus 未満。AVX2対応CPUとC++バックエンドが必要。
        doAssert modulus > 0 and modulus < (1u32 shl 30) and
            (modulus and 1u32) == 1, "modulus must be odd and in [1, 2^30)"
        doAssert n >= 0 and m >= 0 and k >= 0, "negative matrix dimension"
        doAssert n <= high(cint).int and m <= high(cint).int and
            k <= high(cint).int, "matrix dimension exceeds int32"
        doAssert n == 0 or m <= high(int) div n, "matrix size overflow"
        doAssert m == 0 or k <= high(int) div m, "matrix size overflow"
        doAssert n == 0 or k <= high(int) div n, "matrix size overflow"
        doAssert a.len == n * m and b.len == m * k, "matrix size mismatch"
        for value in a:
            assert value < modulus, "matrix entries must be less than modulus"
        for value in b:
            assert value < modulus, "matrix entries must be less than modulus"
        result = newSeq[uint32](n * k)
        if n == 0 or m == 0 or k == 0 or modulus == 1:
            return
        matrixProductKernel(unsafeAddr a[0], unsafeAddr b[0], addr result[0],
            n.cint, m.cint, k.cint, modulus)

    proc matrixProduct*(a, b: openArray[seq[uint32]],
            modulus: uint32 = 998244353u32): seq[seq[uint32]] =
        ## 二次元配列の行列積を求める。空配列の列数は0とみなす。
        let n = a.len
        let m = if n == 0: 0 else: a[0].len
        let k = if b.len == 0: 0 else: b[0].len
        doAssert m == b.len, "matrix size mismatch"
        for row in a:
            doAssert row.len == m, "ragged matrix"
        for row in b:
            doAssert row.len == k, "ragged matrix"
        doAssert n == 0 or m <= high(int) div n, "matrix size overflow"
        doAssert m == 0 or k <= high(int) div m, "matrix size overflow"
        var flatA = newSeq[uint32](n * m)
        var flatB = newSeq[uint32](m * k)
        for i in 0 ..< n:
            if m > 0:
                copyMem(addr flatA[i * m], unsafeAddr a[i][0], m * sizeof(uint32))
        for i in 0 ..< m:
            if k > 0:
                copyMem(addr flatB[i * k], unsafeAddr b[i][0], k * sizeof(uint32))
        let flatC = matrixProduct(flatA, flatB, n, m, k, modulus)
        result = newSeq[seq[uint32]](n)
        for i in 0 ..< n:
            result[i] = newSeq[uint32](k)
            if k > 0:
                copyMem(addr result[i][0], unsafeAddr flatC[i * k], k * sizeof(uint32))

    proc matrixProduct*[T](a, b: Matrix[T]): Matrix[T] =
        ## 既存のmodint行列を公開値へ変換し、AVX2で積を求める。
        when T isnot MontgomeryModint and T isnot BarrettModint:
            {.error: "matrixProduct requires MontgomeryModint or BarrettModint".}
        let n = a.h
        let m = a.w
        let k = b.w
        doAssert m == b.h, "matrix size mismatch"
        let modulus = T.umod.uint32
        doAssert modulus > 0 and modulus < (1u32 shl 30) and
            (modulus and 1u32) == 1, "modulus must be odd and in [1, 2^30)"
        doAssert n == 0 or m <= high(int) div n, "matrix size overflow"
        doAssert m == 0 or k <= high(int) div m, "matrix size overflow"
        var flatA = newSeq[uint32](n * m)
        var flatB = newSeq[uint32](m * k)
        for i in 0 ..< n:
            doAssert a[i].len == m, "ragged matrix"
            for j in 0 ..< m:
                flatA[i * m + j] = a[i, j].val.uint32
        for i in 0 ..< m:
            doAssert b[i].len == k, "ragged matrix"
            for j in 0 ..< k:
                flatB[i * k + j] = b[i, j].val.uint32
        let flatC = matrixProduct(flatA, flatB, n, m, k, modulus)
        result = initMatrix(n, k, T.init(0))
        for i in 0 ..< n:
            for j in 0 ..< k:
                result[i, j] = T.init(flatC[i * k + j].int)
