when not declared CPLIB_MATRIX_MATRIX_AVX2_KERNEL:
    const CPLIB_MATRIX_MATRIX_AVX2_KERNEL* = 1
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

    include cplib/matrix/matrix_avx2_field_impl
