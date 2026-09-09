import hashes
import cplib/modint/modint

when not declared CPLIB_MATRIX_MATRIX_AVX2:
    const CPLIB_MATRIX_MATRIX_AVX2* = 1
    when not defined(cpp):
        {.error: "matrix_avx2 requires the C++ backend (nim cpp)".}
    when not (defined(amd64) or defined(i386)):
        {.error: "matrix_avx2 requires an x86 CPU with AVX2".}
    {.passC: "-mavx2".}


    {.emit: """
#ifndef CPLIB_MATRIX_KERNEL_HPP
#define CPLIB_MATRIX_KERNEL_HPP
#include <immintrin.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
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
template<bool Montgomery>
static void cplib_matrix_product_impl(const uint32_t*a,const uint32_t*b,uint32_t*c,int n,int m,int k,uint32_t p){
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
  for(size_t i=0;i<rows;i++)for(size_t j=0;j<inner;j++)aa[i*mm+j]=Montgomery ? (a[i*inner+j]>=p?a[i*inner+j]-p:a[i*inner+j]) : q.red(uint64_t(a[i*inner+j])*q.r2);
  for(size_t i=0;i<inner;i++)for(size_t j=0;j<cols;j++)bb[i*kk+j]=Montgomery ? (b[i*cols+j]>=p?b[i*cols+j]-p:b[i*cols+j]) : q.red(uint64_t(b[i*cols+j])*q.r2);
  cplib_mat_detail::rec(aa,bb,cc,nn,mm,kk,mm,kk,kk,q);
  for(size_t i=0;i<rows;i++)for(size_t j=0;j<cols;j++)c[i*cols+j]=Montgomery ? cc[i*kk+j] : q.red(cc[i*kk+j]);
}
static void cplib_matrix_product(const uint32_t*a,const uint32_t*b,uint32_t*c,int n,int m,int k,uint32_t p){
  // 公開値の行列を乗算して公開値へ戻す。
  cplib_matrix_product_impl<false>(a,b,c,n,m,k,p);
}
static void cplib_matrix_product_montgomery(const uint32_t*a,const uint32_t*b,uint32_t*c,int n,int m,int k,uint32_t p){
  // Montgomery内部値のまま行列を乗算する。
  cplib_matrix_product_impl<true>(a,b,c,n,m,k,p);
}
struct CplibMatrixDigits {
  char data[10000][4];
  constexpr CplibMatrixDigits():data{} {
    // 4桁の文字列表をコンパイル時に準備する。
    for(unsigned i=0;i<10000;i++){
      data[i][0]=char('0'+i/1000);
      data[i][1]=char('0'+i/100%10);
      data[i][2]=char('0'+i/10%10);
      data[i][3]=char('0'+i%10);
    }
  }
};
static constexpr CplibMatrixDigits cplib_matrix_digits{};
static inline char* cplib_matrix_write_small(char* output,uint32_t value){
  // 4桁以下の整数を先頭の0を省いて書き出す。
  if(value>=1000){memcpy(output,cplib_matrix_digits.data[value],4);return output+4;}
  if(value>=100){memcpy(output,cplib_matrix_digits.data[value]+1,3);return output+3;}
  if(value>=10){memcpy(output,cplib_matrix_digits.data[value]+2,2);return output+2;}
  *output=char('0'+value);return output+1;
}
template<bool Montgomery>
static size_t cplib_matrix_join_impl(const uint32_t* values,size_t count,uint32_t p,char* output,const char* separator,size_t separator_length){
  // 要素ごとの文字列確保を避け、4桁の表で行全体を直接書き出す。
  cplib_mat_detail::Mod q(p);
  char* cursor=output;
  for(size_t i=0;i<count;i++){
    uint32_t value=Montgomery?q.red(values[i]):(values[i]>=p?values[i]-p:values[i]);
    if(value<10000){cursor=cplib_matrix_write_small(cursor,value);}
    else {
      const uint32_t quotient=value/10000,low=value-quotient*10000;
      if(quotient<10000){cursor=cplib_matrix_write_small(cursor,quotient);}
      else {
        const uint32_t high=quotient/10000,middle=quotient-high*10000;
        cursor=cplib_matrix_write_small(cursor,high);
        memcpy(cursor,cplib_matrix_digits.data[middle],4);cursor+=4;
      }
      memcpy(cursor,cplib_matrix_digits.data[low],4);cursor+=4;
    }
    if(i+1<count){
      if(separator_length==1){*cursor++=separator[0];}
      else if(separator_length!=0){memcpy(cursor,separator,separator_length);cursor+=separator_length;}
    }
  }
  return size_t(cursor-output);
}
static size_t cplib_matrix_join(const uint32_t* values,size_t count,uint32_t p,bool montgomery,char* output,const char* separator,size_t separator_length){
  // modintの内部形式に合った行の文字列化を選択する。
  if(montgomery)return cplib_matrix_join_impl<true>(values,count,p,output,separator,separator_length);
  return cplib_matrix_join_impl<false>(values,count,p,output,separator,separator_length);
}
static void cplib_matrix_convert(const uint32_t* values,uint32_t* output,size_t count,uint32_t p,bool montgomery){
  // 公開値の配列を一括してmodintの内部形式へ変換する。
  if(!montgomery){memcpy(output,values,count*sizeof(uint32_t));return;}
  cplib_mat_detail::Mod q(p);
  for(size_t i=0;i<count;i++)output[i]=q.red(uint64_t(values[i])*q.r2);
}
template<bool Montgomery>
static void cplib_matrix_write_row_impl(const uint32_t* values,size_t count,uint32_t p,FILE* output){
  // 文字列オブジェクトを確保せず、固定バッファから行を出力する。
  if(count==0){fwrite("\n",1,1,output);return;}
  char buffer[16384];
  for(size_t begin=0;begin<count;begin+=1024){
    const size_t length=std::min(size_t(1024),count-begin);
    const size_t written=cplib_matrix_join_impl<Montgomery>(values+begin,length,p,buffer," ",1);
    buffer[written]=begin+length==count?'\n':' ';
    fwrite(buffer,1,written+1,output);
  }
}
static void cplib_matrix_write_row(const uint32_t* values,size_t count,uint32_t p,bool montgomery,FILE* output){
  // modintの内部形式に合わせて空白区切りの行を出力する。
  if(montgomery)cplib_matrix_write_row_impl<true>(values,count,p,output);
  else cplib_matrix_write_row_impl<false>(values,count,p,output);
}
#endif
""".}

    proc canonicalKernel(a, b, c: ptr uint32, n, m, k: cint,
            modulus: uint32) {.importcpp: "cplib_matrix_product(@)", nodecl.}

    proc montgomeryKernel(a, b, c: ptr uint32, n, m, k: cint,
            modulus: uint32) {.importcpp: "cplib_matrix_product_montgomery(@)", nodecl.}

    proc joinKernel(values: ptr uint32, count: csize_t, modulus: uint32,
            montgomery: bool, output: ptr char, separator: cstring,
            separatorLen: csize_t): csize_t {.importcpp: "cplib_matrix_join(@)", nodecl.}

    proc convertKernel(values, output: ptr uint32, count: csize_t,
            modulus: uint32, montgomery: bool) {.importcpp: "cplib_matrix_convert(@)", nodecl.}

    proc writeRowKernel(values: ptr uint32, count: csize_t, modulus: uint32,
            montgomery: bool, output: File) {.importcpp: "cplib_matrix_write_row(@)", nodecl.}

    proc matrixProductKernel*(a, b, c: ptr uint32, n, m, k: cint,
            modulus: uint32) =
        ## 検証済みの形状と公開値バッファを内部カーネルへ渡す。
        canonicalKernel(a, b, c, n, m, k, modulus)

    proc matrixProductMontgomeryKernel*(a, b, c: ptr uint32, n, m, k: cint,
            modulus: uint32) =
        ## 検証済みの形状と[0,2*modulus)のMontgomery内部値を直接乗算する。
        montgomeryKernel(a, b, c, n, m, k, modulus)

    proc matrixJoinValues*(values: ptr uint32, count: int, modulus: uint32,
            montgomery: bool, separator: string): string =
        ## 連続したmodint内部値を余分な配列変換なしで文字列にする。
        if count == 0: return ""
        doAssert count <= high(int) div 10, "matrix string size overflow"
        doAssert count == 1 or separator.len <= (high(int) - count * 10) div (count - 1),
            "matrix string size overflow"
        result = newString(count * 10 + (count - 1) * separator.len)
        let written = joinKernel(values, count.csize_t, modulus, montgomery,
            addr result[0], separator.cstring, separator.len.csize_t)
        result.setLen(written.int)

    proc matrixConvertValues*(values, output: ptr uint32, count: int,
            modulus: uint32, montgomery: bool) =
        ## 正規化済み公開値をmodintの内部形式へ一括変換する。
        if count > 0:
            convertKernel(values, output, count.csize_t, modulus, montgomery)

    proc matrixWriteRow*(values: ptr uint32, count: int, modulus: uint32,
            montgomery: bool, output: File) =
        ## modint内部値を一時配列や文字列を作らず空白区切りで出力する。
        writeRowKernel(values, count.csize_t, modulus, montgomery, output)

    proc matrixProduct*(a, b: openArray[uint32], n, m, k: int,
            modulus: uint32 = 998244353u32): seq[uint32] =
        ## 行優先の一次元配列の行列積をAVX2で計算する。
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
        ## 二次元配列の行列積をAVX2で計算する。
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


    type
        MatrixStorage[T] = ref object
            values: seq[T]
        Matrix*[T] = object
            storage: MatrixStorage[T]
            height, width: int
            modulus: uint32
        MatrixRow*[T] = object
            storage: MatrixStorage[T]
            offset, length: int
        MutableMatrixRow*[T] = object
            storage: MatrixStorage[T]
            offset, length: int

    proc `=copy`[T](destination: var Matrix[T], source: Matrix[T]) =
        ## 行ビューは記憶域を共有し、行列そのものの代入は値をコピーする。
        destination.height = source.height
        destination.width = source.width
        destination.modulus = source.modulus
        if destination.storage == source.storage:
            return
        if source.storage.isNil:
            destination.storage = nil
        else:
            var storage = MatrixStorage[T](values: newSeq[T](source.storage.values.len))
            for i, value in source.storage.values:
                storage.values[i] = value
            destination.storage = storage

    proc matrixModulus[T](): uint32 {.inline.} =
        ## 利用可能なmodint型と法を検査する。
        when T isnot MontgomeryModint and T isnot BarrettModint:
            {.error: "matrix_avx2.Matrix requires MontgomeryModint or BarrettModint".}
        static:
            doAssert sizeof(T) == sizeof(uint32)
            doAssert alignof(T) == alignof(uint32)
        result = T.umod.uint32
        doAssert result > 0 and result < (1u32 shl 30) and (result and 1) == 1,
            "modulus must be odd and in [1, 2^30)"

    proc matrixSize(h, w: int): int {.inline.} =
        ## 寸法と連続配列の要素数を検査する。
        doAssert h >= 0 and w >= 0 and h <= high(cint).int and w <= high(cint).int,
            "invalid matrix dimensions"
        doAssert h == 0 or w <= (high(int) div sizeof(uint32)) div h,
            "matrix size overflow"
        h * w

    proc checkModulus[T](a: Matrix[T]) {.inline.} =
        ## dynamic modintの法が行列作成後に変更されていないことを確認する。
        let modulus = matrixModulus[T]()
        doAssert a.modulus == 0 or a.modulus == modulus, "matrix modulus has changed"

    proc scalar[T](value: T or SomeInteger): T {.inline.} =
        ## 整数を正規化してからmodintへ変換する。
        when value is T:
            value
        elif value is SomeUnsignedInt:
            T.init((value.uint64 mod T.umod.uint64).int)
        else:
            T.init((value.int64 mod T.umod.int64).int)

    proc initMatrix*[T](h, w: int, value: T): Matrix[T] =
        ## h行w列の連続配列を確保し、全要素を指定した値で初期化する。
        let modulus = matrixModulus[T]()
        let size = matrixSize(h, w)
        result = Matrix[T](height: h, width: w, modulus: modulus,
            storage: MatrixStorage[T](values: newSeq[T](size)))
        let v = scalar[T](value)
        for x in result.storage.values.mitems:
            x = v

    proc initMatrix*[T](h, w: int, value: SomeInteger): Matrix[T] =
        ## 整数を法で正規化して全要素を初期化する。
        bind initMatrix
        discard matrixModulus[T]()
        initMatrix[T](h, w, scalar[T](value))

    proc initMatrix*[T](h, w: int): Matrix[T] =
        ## h行w列の零行列を作る。
        let modulus = matrixModulus[T]()
        let size = matrixSize(h, w)
        Matrix[T](height: h, width: w, modulus: modulus,
            storage: MatrixStorage[T](values: newSeq[T](size)))

    proc initMatrix*[T](h, w: int, values: sink seq[T]): Matrix[T] =
        ## 行優先の配列を行列へ移し、不要な要素コピーを避ける。
        let modulus = matrixModulus[T]()
        doAssert values.len == matrixSize(h, w), "matrix size mismatch"
        result = Matrix[T](height: h, width: w, modulus: modulus,
            storage: MatrixStorage[T](values: values))

    proc initMatrix*[T](h, w: int, values: openArray[uint32]): Matrix[T] =
        ## 正規化済みの公開値からmodintの連続行列を作る。
        result = initMatrix[T](h, w)
        doAssert values.len == result.storage.values.len, "matrix size mismatch"
        for value in values:
            assert value < result.modulus, "matrix entries must be less than modulus"
        if values.len > 0:
            matrixConvertValues(unsafeAddr values[0],
                cast[ptr uint32](addr result.storage.values[0]), values.len,
                result.modulus, T is MontgomeryModint)

    proc initMatrixOwned[T](h, w: int, values: var seq[uint32]): Matrix[T] =
        ## 所有権を持つ公開値配列を消費し、同じ領域をmodint配列として使う。
        let modulus = matrixModulus[T]()
        doAssert values.len == matrixSize(h, w), "matrix size mismatch"
        for value in values:
            assert value < modulus, "matrix entries must be less than modulus"
        result = Matrix[T](height: h, width: w, modulus: modulus,
            storage: MatrixStorage[T]())
        # 両modintは参照を含まないuint32フィールド1個。型を合わせてからmoveする。
        result.storage.values = move(cast[ptr seq[T]](addr values)[])
        when T is MontgomeryModint:
            if result.storage.values.len > 0:
                let data = cast[ptr uint32](addr result.storage.values[0])
                matrixConvertValues(data, data, result.storage.values.len, modulus, true)

    template initMatrix*[T](h, w: int, values: seq[uint32]): untyped =
        ## 一時配列はコピーせず取り込み、再利用する配列は通常の値コピーで保護する。
        block:
            let rows = h
            let columns = w
            var owned: seq[uint32] = values
            initMatrixOwned[T](rows, columns, owned)

    proc initMatrix*[T](values: openArray[seq[T]]): Matrix[T] =
        ## 二次元配列を連続配置の行列へコピーする。
        let h = values.len
        let w = if h == 0: 0 else: values[0].len
        result = initMatrix[T](h, w)
        for i, row in values:
            doAssert row.len == w, "ragged matrix"
            for j, value in row:
                result.storage.values[i * w + j] = value

    proc toMatrix*[T](values: openArray[seq[T]]): Matrix[T] =
        ## 二次元配列を行列へ変換する。
        bind initMatrix
        initMatrix(values)

    proc initMatrix*[T](values: openArray[T], vertical: bool = false): Matrix[T] =
        ## 一次元配列を1行または1列の行列へ変換する。
        bind initMatrix
        let h = if vertical: values.len else: 1
        let w = if vertical: 1 else: values.len
        initMatrix[T](h, w, @values)

    proc h*[T](a: Matrix[T]): int {.inline.} =
        ## 行数を返す。
        a.height
    proc w*[T](a: Matrix[T]): int {.inline.} =
        ## 列数を返す。行数0の場合も列数を保持する。
        a.width

    template checkIndex(index, size: int) =
        ## 通常の配列と同じコンパイル設定で添字を検査する。
        when compileOption("boundChecks"):
            if index < 0 or index >= size:
                raise newException(IndexDefect, "matrix index out of bounds")

    proc `[]`*[T](a: Matrix[T], r, c: int): T {.inline.} =
        ## 指定した要素を読み取る。
        checkIndex(r, a.height)
        checkIndex(c, a.width)
        a.storage.values[r * a.width + c]
    proc `[]`*[T](a: var Matrix[T], r, c: int): var T {.inline.} =
        ## 指定した要素への変更可能な参照を返す。
        checkIndex(r, a.height)
        checkIndex(c, a.width)
        a.storage.values[r * a.width + c]
    proc `[]=`*[T](a: var Matrix[T], r, c: int, value: T or SomeInteger) {.inline.} =
        ## 指定した要素へ代入する。
        checkIndex(r, a.height)
        checkIndex(c, a.width)
        a.storage.values[r * a.width + c] = scalar[T](value)

    proc `[]`*[T](a: Matrix[T], r: int): MatrixRow[T] {.inline.} =
        ## 行をコピーせず読み取り専用ビューとして返す。
        checkIndex(r, a.height)
        MatrixRow[T](storage: a.storage, offset: r * a.width, length: a.width)
    proc `[]`*[T](a: var Matrix[T], r: int): MutableMatrixRow[T] {.inline.} =
        ## 元の行列を書き換えられる行ビューを返す。
        checkIndex(r, a.height)
        MutableMatrixRow[T](storage: a.storage, offset: r * a.width, length: a.width)
    proc `[]`*[T](row: MatrixRow[T], column: int): T {.inline.} =
        ## 行ビューの要素を読み取る。
        checkIndex(column, row.length)
        row.storage.values[row.offset + column]
    proc `[]`*[T](row: MutableMatrixRow[T], column: int): var T {.inline.} =
        ## 行ビューから元の要素への参照を返す。
        checkIndex(column, row.length)
        row.storage.values[row.offset + column]
    proc `[]=`*[T](row: MutableMatrixRow[T], column: int, value: T or SomeInteger) {.inline.} =
        ## 行ビューを通して元の行列へ代入する。
        checkIndex(column, row.length)
        row.storage.values[row.offset + column] = scalar[T](value)
    proc len*[T](row: MatrixRow[T] or MutableMatrixRow[T]): int {.inline.} =
        ## 行ビューの列数を返す。
        row.length
    iterator items*[T](row: MatrixRow[T] or MutableMatrixRow[T]): T =
        ## 行の要素を左から順に列挙する。
        for i in 0 ..< row.length:
            yield row.storage.values[row.offset + i]
    iterator pairs*[T](row: MatrixRow[T] or MutableMatrixRow[T]): (int, T) =
        ## 行の列番号と要素を列挙する。
        for i in 0 ..< row.length:
            yield (i, row.storage.values[row.offset + i])
    iterator mitems*[T](row: MutableMatrixRow[T]): var T =
        ## 行の各要素を変更可能な参照として列挙する。
        for i in 0 ..< row.length:
            yield row.storage.values[row.offset + i]
    proc toSeq*[T](row: MatrixRow[T] or MutableMatrixRow[T]): seq[T] =
        ## 行ビューを独立した配列へコピーする。
        result = newSeq[T](row.length)
        for i in 0 ..< row.length:
            result[i] = row.storage.values[row.offset + i]
    proc join*[T](row: MatrixRow[T] or MutableMatrixRow[T], sep: string = ""): string =
        ## 行の値を指定した区切り文字で連結する。
        if row.length == 0: return ""
        let modulus = matrixModulus[T]()
        let values = cast[ptr uint32](unsafeAddr row.storage.values[row.offset])
        matrixJoinValues(values, row.length, modulus, T is MontgomeryModint, sep)
    proc writeRow*[T](row: MatrixRow[T] or MutableMatrixRow[T], output: File = stdout) =
        ## 行を空白区切りと改行で出力し、一時文字列の確保を避ける。
        let modulus = matrixModulus[T]()
        let values = if row.length == 0: nil else:
            cast[ptr uint32](unsafeAddr row.storage.values[row.offset])
        matrixWriteRow(values, row.length, modulus, T is MontgomeryModint, output)
    proc `[]=`*[T](a: var Matrix[T], r: int, row: openArray[T]) =
        ## 列数を保ったまま行の全要素を置き換える。
        checkIndex(r, a.height)
        doAssert row.len == a.width, "matrix row size mismatch"
        for j, value in row:
            a.storage.values[r * a.width + j] = value
    proc `[]=`*[T](a: var Matrix[T], r: int, row: MatrixRow[T] or MutableMatrixRow[T]) =
        ## 別の行ビューの内容を指定した行へコピーする。
        checkIndex(r, a.height)
        doAssert row.len == a.width, "matrix row size mismatch"
        for j in 0 ..< row.len:
            a.storage.values[r * a.width + j] = row[j]

    proc `*`*[T](a, b: Matrix[T]): Matrix[T] =
        ## 連続配置されたmodintを直接AVX2カーネルへ渡して乗算する。
        checkModulus(a)
        checkModulus(b)
        doAssert a.width == b.height, "matrix size mismatch"
        result = initMatrix[T](a.height, b.width)
        if a.height == 0 or a.width == 0 or b.width == 0 or result.modulus == 1:
            return
        let ap = cast[ptr uint32](unsafeAddr a.storage.values[0])
        let bp = cast[ptr uint32](unsafeAddr b.storage.values[0])
        let cp = cast[ptr uint32](addr result.storage.values[0])
        when T is MontgomeryModint:
            matrixProductMontgomeryKernel(ap, bp, cp, a.height.cint,
                a.width.cint, b.width.cint, result.modulus)
        else:
            matrixProductKernel(ap, bp, cp, a.height.cint,
                a.width.cint, b.width.cint, result.modulus)
    proc `*=`*[T](a: var Matrix[T], b: Matrix[T]) =
        ## 余分な左行列のコピーを作らずに積で置き換える。
        var product = a * b
        swap(a, product)
    proc matrixProduct*[T](a, b: Matrix[T]): Matrix[T] =
        ## 関数形式で高速行列の積を求める。
        a * b

    template defineAssignment(assign, op: untyped) =
        ## 加減算と対応する代入演算子をまとめて定義する。
        proc assign*[T](a: var Matrix[T], b: Matrix[T]) =
            ## 同じ形状の行列どうしを成分ごとに演算する。
            checkModulus(a)
            checkModulus(b)
            doAssert a.h == b.h and a.w == b.w, "matrix size mismatch"
            for i in 0 ..< a.h * a.w:
                assign(a.storage.values[i], b.storage.values[i])
        proc assign*[T](a: var Matrix[T], value: T or SomeInteger) =
            ## 全要素とスカラーを成分ごとに演算する。
            checkModulus(a)
            let v = scalar[T](value)
            for i in 0 ..< a.h * a.w:
                assign(a.storage.values[i], v)
        proc op*[T](a, b: Matrix[T]): Matrix[T] =
            ## 同じ形状の行列の演算結果を新しい行列に返す。
            result = a
            assign(result, b)
        proc op*[T](a: Matrix[T], value: T or SomeInteger): Matrix[T] =
            ## 各要素とスカラーの演算結果を新しい行列に返す。
            result = a
            assign(result, value)
    defineAssignment(`+=`, `+`)
    defineAssignment(`-=`, `-`)

    proc `-`*[T](a: Matrix[T]): Matrix[T] =
        ## 各要素の加法逆元を求める。
        result = initMatrix[T](a.h, a.w)
        result -= a
    proc `+`*[T](value: T, a: Matrix[T]): Matrix[T] =
        ## スカラーと行列の各要素を加算する。
        a + value
    proc `-`*[T](value: T, a: Matrix[T]): Matrix[T] =
        ## スカラーから行列の各要素を引く。
        bind initMatrix
        result = initMatrix[T](a.h, a.w, value)
        result -= a
    proc `*=`*[T](a: var Matrix[T], value: T or SomeInteger) =
        ## 行列の全要素をスカラー倍する。
        checkModulus(a)
        let v = scalar[T](value)
        for i in 0 ..< a.h * a.w:
            a.storage.values[i] *= v
    proc `*`*[T](a: Matrix[T], value: T or SomeInteger): Matrix[T] =
        ## スカラー倍した行列を新しく返す。
        result = a
        result *= value
    proc `*`*[T](value: T, a: Matrix[T]): Matrix[T] =
        ## スカラー倍した行列を新しく返す。
        a * value

    proc `+`*[T](value: SomeInteger, a: Matrix[T]): Matrix[T] =
        ## 整数と行列の各要素を加算する。
        a + scalar[T](value)
    proc `-`*[T](value: SomeInteger, a: Matrix[T]): Matrix[T] =
        ## 整数から行列の各要素を引く。
        scalar[T](value) - a
    proc `*`*[T](value: SomeInteger, a: Matrix[T]): Matrix[T] =
        ## 整数で行列をスカラー倍する。
        a * scalar[T](value)

    proc identity_matrix*[T](n: int, one, zero: T): Matrix[T] =
        ## 指定した対角成分と非対角成分から正方行列を作る。
        bind initMatrix
        result = initMatrix[T](n, n, zero)
        for i in 0 ..< n:
            result[i, i] = one
    proc identity_matrix*[T](n: int): Matrix[T] =
        ## n行n列の単位行列を作る。
        bind identity_matrix
        identity_matrix[T](n, T.init(1), T.init(0))
    proc pow*[T](a: Matrix[T], exponent: int): Matrix[T] =
        ## 非負整数乗を繰り返し二乗法で求める。
        bind identity_matrix
        checkModulus(a)
        doAssert a.h == a.w and exponent >= 0, "invalid matrix power"
        if exponent == 0:
            return identity_matrix[T](a.h)
        if exponent == 1:
            return a
        var base = a
        var n = exponent
        var initialized = false
        while n > 0:
            if (n and 1) != 0:
                if initialized:
                    result *= base
                else:
                    result = base
                    initialized = true
            n = n shr 1
            if n != 0: base *= base
    proc `**`*[T](a: Matrix[T], exponent: int): Matrix[T] =
        ## 行列の非負整数乗を求める。
        a.pow(exponent)
    proc sum*[T](a: Matrix[T]): T =
        ## 全要素の和を求める。
        checkModulus(a)
        result = T.init(0)
        for i in 0 ..< a.h * a.w:
            result += a.storage.values[i]
    proc `==`*[T](a, b: Matrix[T]): bool =
        ## modintの冗長な内部表現によらず形状と値を比較する。
        checkModulus(a)
        checkModulus(b)
        if a.h != b.h or a.w != b.w: return false
        let modulus = T.umod.int
        for i in 0 ..< a.h * a.w:
            if a.storage.values[i].val mod modulus != b.storage.values[i].val mod modulus:
                return false
        true
    proc hash*[T](a: Matrix[T]): Hash =
        ## 形状と正規化した値からハッシュを求める。
        checkModulus(a)
        result = hash((a.h, a.w, T.umod.int))
        for i in 0 ..< a.h * a.w:
            result = result !& hash(a.storage.values[i].val mod T.umod.int)
        result = !$result
    proc `$`*[T](a: Matrix[T]): string =
        ## 各行を空白区切りで表示する。
        checkModulus(a)
        for i in 0 ..< a.h:
            if i != 0: result.add('\n')
            result.add(a[i].join(" "))

    proc matrixProductLegacy[M: object, T](a, b: M, Element: typedesc[T]): M =
        ## 二次元配列を保持する従来のMatrixにAVX2の積を返す。
        # 型はtypedescで受け取り、Nim 1.6でのmodintの型引数誤束縛を避ける。
        bind matrixProduct
        mixin h, w, `[]`
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
        # 旧Matrixをimportせず、提出用のソース展開でもMatrix名の重複を防ぐ。
        for name, values in fieldPairs(result):
            when name == "arr" and values is seq[seq[T]]:
                values = newSeq[seq[T]](n)
                for i in 0 ..< n:
                    values[i] = newSeq[T](k)
                    for j in 0 ..< k:
                        values[i][j] = T.init(flatC[i * k + j].int)
            elif name == "emptyWidth" and values is int:
                values = k
            else:
                {.error: "unsupported matrix representation".}

    type LegacyMatrix[T] = concept x
        x.h is int
        x.w is int
        x[0, 0] is T

    proc matrixProduct*[T](a, b: LegacyMatrix[T]): auto =
        ## 従来のMatrix型を保ったままAVX2で行列積を計算する。
        mixin `[]`
        matrixProductLegacy(a, b, typeof(a[0, 0]))

    import options
    import cplib/matrix/field_matrix_ops
    export LinearSystemSolution
    include cplib/matrix/matrix_avx2_field_impl

    type FieldReduction = object
        values: seq[uint32]
        pivots: seq[cint]
        width, rank: int
        determinant: uint32

    proc fieldPointer[T](values: openArray[T]): ptr uint32 =
        ## 空配列を含むmodint内部値の連続領域を参照する。
        if values.len == 0: nil
        else: cast[ptr uint32](unsafeAddr values[0])

    proc fieldMatrixPointer[T](a: Matrix[T]): ptr uint32 =
        ## 空行列を含む行列の内部領域を読み取る。
        if a.storage.isNil: nil
        else: fieldPointer(a.storage.values)

    proc fieldPivotPointer(pivots: openArray[cint]): ptr cint =
        ## 空配列を含むピボット列の領域を参照する。
        if pivots.len == 0: nil
        else: cast[ptr cint](unsafeAddr pivots[0])

    proc reduceFieldMatrix[T](a: Matrix[T], extra: int, reduced: bool,
            rhs: ptr uint32 = nil, identity: bool = false): FieldReduction =
        ## 入力を保持したまま、拡大行列をAVX2で前進消去・掃き出しする。
        checkModulus(a)
        doAssert extra >= 0 and extra <= high(cint).int - a.w, "matrix size overflow"
        result.width = a.w + extra
        result.values = newSeq[uint32](matrixSize(a.h, result.width))
        result.pivots = newSeq[cint](min(a.h, a.w))
        let modulus = matrixModulus[T]()
        fieldPrepareKernel(fieldMatrixPointer(a), rhs, fieldPointer(result.values),
            a.h, a.w, extra, modulus, T is MontgomeryModint, identity)
        result.rank = fieldEliminateKernel(fieldPointer(result.values), a.h,
            result.width, a.w, fieldPivotPointer(result.pivots), result.determinant, modulus, reduced)

    proc rank*[T](a: Matrix[T]): int =
        ## AVX2の前進消去で階数を求める。O(h*w*min(h,w))。
        reduceFieldMatrix(a, 0, false).rank

    proc determinant*[T](a: Matrix[T]): T =
        ## AVX2の前進消去で行列式を求める。空行列は1。O(n^3)。
        assert a.h == a.w
        let reduced = reduceFieldMatrix(a, 0, false)
        if reduced.rank != a.h: return T.init(0)
        T.init(fieldCanonicalKernel(reduced.determinant, matrixModulus[T]()).int)

    proc hafnian*[T](a: Matrix[T]): T =
        ## 対称な偶数次行列のhafnianをAVX2の多項式積和で求める。O(n^2*2^(n/2))。
        checkModulus(a)
        assert a.h == a.w and a.h mod 2 == 0
        for i in 0..<a.h:
            for j in 0..<i: assert a[i,j].val == a[j,i].val, "matrix must be symmetric"
        T.init(fieldHafnianKernel(fieldMatrixPointer(a), a.h,
            matrixModulus[T](), T is MontgomeryModint).int)

    proc solveLinearSystem*[T](a: Matrix[T], b: openArray[T]): Option[LinearSystemSolution[T]] =
        ## AVX2でAx=bを掃き出し、特殊解と核の基底を返す。O(h*w*min(h,w)+w^2)。
        assert b.len == a.h
        var reduced = reduceFieldMatrix(a, 1, true, fieldPointer(b))
        for i in reduced.rank..<a.h:
            if reduced.values[i * reduced.width + a.w] != 0:
                return none(LinearSystemSolution[T])
        fieldRestoreKernel(fieldPointer(reduced.values), reduced.values.len,
            matrixModulus[T](), T is MontgomeryModint)
        var solution: LinearSystemSolution[T]
        solution.particular = newSeq[T](a.w)
        var isPivot = newSeq[bool](a.w)
        for i in 0..<reduced.rank:
            let col = reduced.pivots[i].int
            isPivot[col] = true
            solution.particular[col] = cast[T](reduced.values[i * reduced.width + a.w])
        let one = T.init(1)
        for free in 0..<a.w:
            if isPivot[free]: continue
            var vector = newSeq[T](a.w)
            vector[free] = one
            for i in 0..<reduced.rank:
                vector[reduced.pivots[i].int] = -cast[T](reduced.values[i * reduced.width + free])
            solution.basis.add(vector)
        some(solution)

    proc inverse*[T](a: Matrix[T]): Option[Matrix[T]] =
        ## AVX2の掃き出しで逆行列を返す。特異行列はnone。O(n^3)。
        assert a.h == a.w
        let reduced = reduceFieldMatrix(a, a.h, true, identity = true)
        if reduced.rank != a.h: return none(Matrix[T])
        var answer = initMatrix[T](a.h, a.h)
        fieldInverseAdjugateKernel(fieldPointer(reduced.values), fieldMatrixPointer(answer),
            a.h, reduced.rank, fieldPivotPointer(reduced.pivots), reduced.determinant,
            matrixModulus[T](), T is MontgomeryModint, false)
        some(answer)

    proc adjugate*[T](a: Matrix[T]): Matrix[T] =
        ## AVX2で特異行列を含む余因子行列を返す。O(n^3)。
        assert a.h == a.w
        let reduced = reduceFieldMatrix(a, a.h, true, identity = true)
        result = initMatrix[T](a.h, a.h)
        fieldInverseAdjugateKernel(fieldPointer(reduced.values), fieldMatrixPointer(result),
            a.h, reduced.rank, fieldPivotPointer(reduced.pivots), reduced.determinant,
            matrixModulus[T](), T is MontgomeryModint, true)
