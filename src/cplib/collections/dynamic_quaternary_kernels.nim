when not declared CPLIB_COLLECTIONS_DYNAMIC_QUATERNARY_KERNELS:
    const CPLIB_COLLECTIONS_DYNAMIC_QUATERNARY_KERNELS* = 1
    when defined(dynamicWmPortable):
        {.passC: "-DDQV_PORTABLE".}
    {.emit: """
#include <stdint.h>
#if !defined(DQV_PORTABLE) && (defined(__x86_64__) || defined(__i386__)) && (defined(__GNUC__) || defined(__clang__))
#include <immintrin.h>
#define DQV_X86 1
#define DQV_TARGET(x) __attribute__((target(x)))
#else
#define DQV_X86 0
#define DQV_TARGET(x)
#endif
static int dqv_support(int mode) {
#if DQV_X86
  __builtin_cpu_init();
  if(mode==2) return __builtin_cpu_supports("avx2") != 0;
  if(mode==3) return __builtin_cpu_supports("avx512f") && __builtin_cpu_supports("avx512bw");
#endif
  return mode<=1;
}
static int dqv_pop_base(uint64_t x) {
  x -= (x >> 1) & UINT64_C(0x5555555555555555);
  x = (x & UINT64_C(0x3333333333333333)) + ((x >> 2) & UINT64_C(0x3333333333333333));
  return (int)((((x + (x >> 4)) & UINT64_C(0x0f0f0f0f0f0f0f0f)) * UINT64_C(0x0101010101010101)) >> 56);
}
#if DQV_X86
DQV_TARGET("popcnt") static int dqv_pop_hw(uint64_t x) { return __builtin_popcountll(x); }
#endif
static int dqv_pop(uint64_t x) {
#if DQV_X86
  if (__builtin_cpu_supports("popcnt")) return dqv_pop_hw(x);
#endif
  return dqv_pop_base(x);
}
static uint64_t dqv_matches(uint64_t x,int d) {
  x ^= UINT64_C(0x5555555555555555)*(uint64_t)d;
  return ~(x | (x>>1)) & UINT64_C(0x5555555555555555);
}
static int dqv_count_scalar(const uint64_t *a, int n, int d) {
  int s=0; for(int i=0;i<n;++i) s+=dqv_pop(dqv_matches(a[i],d)); return s;
}
#if DQV_X86
DQV_TARGET("avx2") static int dqv_count_avx2(const uint64_t *a, int n, int d) {
  const __m256i lut=_mm256_setr_epi8(0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4);
  const __m256i mask=_mm256_set1_epi8(15);
  __m256i sum=_mm256_setzero_si256();
  int i=0;
  for(;i+4<=n;i+=4) {
    __m256i x=_mm256_loadu_si256((const __m256i*)(a+i));
    x=_mm256_xor_si256(x,_mm256_set1_epi64x((long long)(UINT64_C(0x5555555555555555)*(uint64_t)d)));
    x=_mm256_andnot_si256(_mm256_or_si256(x,_mm256_srli_epi64(x,1)),_mm256_set1_epi64x(UINT64_C(0x5555555555555555)));
    __m256i lo=_mm256_and_si256(x,mask);
    __m256i hi=_mm256_and_si256(_mm256_srli_epi16(x,4),mask);
    __m256i cnt=_mm256_add_epi8(_mm256_shuffle_epi8(lut,lo),_mm256_shuffle_epi8(lut,hi));
    sum=_mm256_add_epi64(sum,_mm256_sad_epu8(cnt,_mm256_setzero_si256()));
  }
  __m128i halves=_mm_add_epi64(_mm256_castsi256_si128(sum),_mm256_extracti128_si256(sum,1));
  int r=(int)_mm_cvtsi128_si64(halves)+(int)_mm_extract_epi64(halves,1);
  return r+dqv_count_scalar(a+i,n-i,d);
}
DQV_TARGET("avx2") static void dqv_left_avx2(uint64_t *a,int first,int last) {
  int i=last;
  for(;i-first+1>=4;i-=4) {
    __m256i x=_mm256_loadu_si256((const __m256i*)(a+i-3));
    __m256i y=_mm256_loadu_si256((const __m256i*)(a+i-4));
    _mm256_storeu_si256((__m256i*)(a+i-3),_mm256_or_si256(_mm256_slli_epi64(x,2),_mm256_srli_epi64(y,62)));
  }
  for(;i>=first;--i) a[i]=(a[i]<<2)|(a[i-1]>>62);
}
DQV_TARGET("avx2") static void dqv_right_avx2(uint64_t *a,int first,int last) {
  int i=first;
  for(;i+3<=last;i+=4) {
    __m256i x=_mm256_loadu_si256((const __m256i*)(a+i));
    __m256i y=_mm256_loadu_si256((const __m256i*)(a+i+1));
    _mm256_storeu_si256((__m256i*)(a+i),_mm256_or_si256(_mm256_srli_epi64(x,2),_mm256_slli_epi64(y,62)));
  }
  for(;i<=last;++i) a[i]=(a[i]>>2)|(a[i+1]<<62);
}
#endif
#if DQV_X86
DQV_TARGET("avx512f,avx512bw") static int dqv_count_avx512(const uint64_t *a, int n, int d) {
  const __m512i lut=_mm512_broadcast_i32x4(_mm_setr_epi8(0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4));
  const __m512i mask=_mm512_set1_epi8(15);
  __m512i sum=_mm512_setzero_si512();
  int i=0;
  for(;i+8<=n;i+=8) {
    __m512i x=_mm512_loadu_si512((const void*)(a+i));
    x=_mm512_xor_si512(x,_mm512_set1_epi64((long long)(UINT64_C(0x5555555555555555)*(uint64_t)d)));
    x=_mm512_andnot_si512(_mm512_or_si512(x,_mm512_srli_epi64(x,1)),_mm512_set1_epi64(UINT64_C(0x5555555555555555)));
    __m512i lo=_mm512_and_si512(x,mask);
    __m512i hi=_mm512_and_si512(_mm512_srli_epi16(x,4),mask);
    __m512i cnt=_mm512_add_epi8(_mm512_shuffle_epi8(lut,lo),_mm512_shuffle_epi8(lut,hi));
    sum=_mm512_add_epi64(sum,_mm512_sad_epu8(cnt,_mm512_setzero_si512()));
  }
  int r=(int)_mm512_reduce_add_epi64(sum);
  return r+dqv_count_scalar(a+i,n-i,d);
}
DQV_TARGET("avx512f,avx512bw") static void dqv_left_avx512(uint64_t *a,int first,int last) {
  int i=last;
  for(;i-first+1>=8;i-=8) {
    __m512i x=_mm512_loadu_si512((const void*)(a+i-7));
    __m512i y=_mm512_loadu_si512((const void*)(a+i-8));
    _mm512_storeu_si512((void*)(a+i-7),_mm512_or_si512(_mm512_slli_epi64(x,2),_mm512_srli_epi64(y,62)));
  }
  for(;i>=first;--i) a[i]=(a[i]<<2)|(a[i-1]>>62);
}
DQV_TARGET("avx512f,avx512bw") static void dqv_right_avx512(uint64_t *a,int first,int last) {
  int i=first;
  for(;i+7<=last;i+=8) {
    __m512i x=_mm512_loadu_si512((const void*)(a+i));
    __m512i y=_mm512_loadu_si512((const void*)(a+i+1));
    _mm512_storeu_si512((void*)(a+i),_mm512_or_si512(_mm512_srli_epi64(x,2),_mm512_slli_epi64(y,62)));
  }
  for(;i<=last;++i) a[i]=(a[i]>>2)|(a[i+1]<<62);
}
#endif
#ifdef __cplusplus
extern "C" {
#endif
int dqv_rank(uint64_t *a,int p,int d,int mode) {
  int n=p>>5, s;
#if DQV_X86
  if(mode==3) s=dqv_count_avx512(a,n,d);
  else if(mode==2) s=dqv_count_avx2(a,n,d);
  else
#endif
  s=dqv_count_scalar(a,n,d);
  return s+dqv_pop(dqv_matches(a[n],d) & ((UINT64_C(1)<<(2*(p&31)))-1));
}
void dqv_insert(uint64_t *a,int n,int p,int d,int mode) {
  int w=p>>5, k=2*(p&31), last=n>>5;
  uint64_t mask=(UINT64_C(1)<<k)-1;
#if DQV_X86
  if(mode==3) dqv_left_avx512(a,w+1,last);
  else if(mode==2) dqv_left_avx2(a,w+1,last);
  else
#endif
  for(int i=last;i>w;--i) a[i]=(a[i]<<2)|(a[i-1]>>62);
  a[w]=(a[w]&mask)|((a[w]&~mask)<<2)|((uint64_t)d<<k);
}
void dqv_erase(uint64_t *a,int n,int p,int mode) {
  int w=p>>5, k=2*(p&31), last=(n-1)>>5;
  uint64_t mask=(UINT64_C(1)<<k)-1;
  a[w]=(a[w]&mask)|(((a[w]>>2)|(a[w+1]<<62))&~mask);
#if DQV_X86
  if(mode==3) dqv_right_avx512(a,w+1,last);
  else if(mode==2) dqv_right_avx2(a,w+1,last);
  else
#endif
  for(int i=w+1;i<=last;++i) a[i]=(a[i]>>2)|(a[i+1]<<62);
}
static void dqv_all_base(uint64_t *a,int p,int *out) {
    int lo=0,hi=0,both=0,n=p>>5;
    for(int i=0;i<=n;++i) {
        uint64_t x=a[i];
        if(i==n) x &= (UINT64_C(1)<<(2*(p&31)))-1;
        uint64_t l=x & UINT64_C(0x5555555555555555), h=(x>>1) & UINT64_C(0x5555555555555555);
        lo+=dqv_pop_base(l); hi+=dqv_pop_base(h); both+=dqv_pop_base(l&h);
    }
    out[0]=p-lo-hi+both;out[1]=lo-both;out[2]=hi-both;out[3]=both;
}
static void dqv_all_pair_base(uint64_t *a,int l,int r,int *left,int *right) {
    /* 両端の4桁rankを、共通prefixを一度だけ走査して求める。 */
    int lo=0,hi=0,both=0,i=0;
    for(;i<(l>>5);++i) {
        uint64_t x=a[i];
        uint64_t low=x & UINT64_C(0x5555555555555555), high=(x>>1) & UINT64_C(0x5555555555555555);
        lo+=dqv_pop_base(low);hi+=dqv_pop_base(high);both+=dqv_pop_base(low&high);
    }
    int ll=lo,lh=hi,lb=both;
    if(l&31) {
        uint64_t x=a[i] & ((UINT64_C(1)<<(2*(l&31)))-1);
        uint64_t low=x & UINT64_C(0x5555555555555555), high=(x>>1) & UINT64_C(0x5555555555555555);
        ll+=dqv_pop_base(low);lh+=dqv_pop_base(high);lb+=dqv_pop_base(low&high);
    }
    left[0]=l-ll-lh+lb;left[1]=ll-lb;left[2]=lh-lb;left[3]=lb;
    for(;i<(r>>5);++i) {
        uint64_t x=a[i];
        uint64_t low=x & UINT64_C(0x5555555555555555), high=(x>>1) & UINT64_C(0x5555555555555555);
        lo+=dqv_pop_base(low);hi+=dqv_pop_base(high);both+=dqv_pop_base(low&high);
    }
    if(r&31) {
        uint64_t x=a[i] & ((UINT64_C(1)<<(2*(r&31)))-1);
        uint64_t low=x & UINT64_C(0x5555555555555555), high=(x>>1) & UINT64_C(0x5555555555555555);
        lo+=dqv_pop_base(low);hi+=dqv_pop_base(high);both+=dqv_pop_base(low&high);
    }
    right[0]=r-lo-hi+both;right[1]=lo-both;right[2]=hi-both;right[3]=both;
}
#if DQV_X86
DQV_TARGET("popcnt") static void dqv_all_hw(uint64_t *a,int p,int *out) {
    int lo=0,hi=0,both=0,n=p>>5;
    for(int i=0;i<=n;++i) {
        uint64_t x=a[i];
        if(i==n) x &= (UINT64_C(1)<<(2*(p&31)))-1;
        uint64_t l=x & UINT64_C(0x5555555555555555), h=(x>>1) & UINT64_C(0x5555555555555555);
        lo+=__builtin_popcountll(l); hi+=__builtin_popcountll(h); both+=__builtin_popcountll(l&h);
    }
    out[0]=p-lo-hi+both;out[1]=lo-both;out[2]=hi-both;out[3]=both;
}
DQV_TARGET("popcnt") static void dqv_all_pair_hw(uint64_t *a,int l,int r,int *left,int *right) {
    /* POPCNTで両端rankの共通prefixを一度だけ走査する。 */
    int lo=0,hi=0,both=0,i=0;
    for(;i<(l>>5);++i) {
        uint64_t x=a[i];
        uint64_t low=x & UINT64_C(0x5555555555555555), high=(x>>1) & UINT64_C(0x5555555555555555);
        lo+=__builtin_popcountll(low);hi+=__builtin_popcountll(high);both+=__builtin_popcountll(low&high);
    }
    int ll=lo,lh=hi,lb=both;
    if(l&31) {
        uint64_t x=a[i] & ((UINT64_C(1)<<(2*(l&31)))-1);
        uint64_t low=x & UINT64_C(0x5555555555555555), high=(x>>1) & UINT64_C(0x5555555555555555);
        ll+=__builtin_popcountll(low);lh+=__builtin_popcountll(high);lb+=__builtin_popcountll(low&high);
    }
    left[0]=l-ll-lh+lb;left[1]=ll-lb;left[2]=lh-lb;left[3]=lb;
    for(;i<(r>>5);++i) {
        uint64_t x=a[i];
        uint64_t low=x & UINT64_C(0x5555555555555555), high=(x>>1) & UINT64_C(0x5555555555555555);
        lo+=__builtin_popcountll(low);hi+=__builtin_popcountll(high);both+=__builtin_popcountll(low&high);
    }
    if(r&31) {
        uint64_t x=a[i] & ((UINT64_C(1)<<(2*(r&31)))-1);
        uint64_t low=x & UINT64_C(0x5555555555555555), high=(x>>1) & UINT64_C(0x5555555555555555);
        lo+=__builtin_popcountll(low);hi+=__builtin_popcountll(high);both+=__builtin_popcountll(low&high);
    }
    right[0]=r-lo-hi+both;right[1]=lo-both;right[2]=hi-both;right[3]=both;
}
#endif
void dqv_all(uint64_t *a,int p,int *out) {
#if DQV_X86
    if(__builtin_cpu_supports("popcnt")){dqv_all_hw(a,p,out);return;}
#endif
    dqv_all_base(a,p,out);
}
void dqv_all_pair(uint64_t *a,int l,int r,int *left,int *right) {
    /* 実行可能な命令で両端の4桁rankをまとめて計算する。 */
#if DQV_X86
    if(__builtin_cpu_supports("popcnt")){dqv_all_pair_hw(a,l,r,left,right);return;}
#endif
    dqv_all_pair_base(a,l,r,left,right);
}
#ifdef __cplusplus
}
#endif
""".}
    proc quadRankRaw*(a: ptr uint64, p, d, mode: cint): cint {.importc: "dqv_rank".}
        ## 解決済みISAでpacked 2bit列のprefix rankを計算する。O(p/32)。
    proc quadInsertRaw*(a: ptr uint64, n, p, d, mode: cint) {.importc: "dqv_insert".}
        ## 容量に余裕のあるpacked列を2bitずらして挿入する。O(n/32)。
    proc quadEraseRaw*(a: ptr uint64, n, p, mode: cint) {.importc: "dqv_erase".}
        ## packed列を2bitずらして削除する。O(n/32)。
    proc quadRanksRaw*(a: ptr uint64, p: cint, counts: ptr cint) {.importc: "dqv_all".}
        ## 全4桁のprefix個数を3個のbit-plane popcountから求める。O(p/32)。
    proc quadRanksPairRaw*(a: ptr uint64, l, r: cint, left, right: ptr cint) {.importc: "dqv_all_pair".}
        ## 全4桁の両端rankを共通prefixを共有して求める。0<=l<=r、O(r/32+1)。
