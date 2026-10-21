when not declared CPLIB_COLLECTIONS_DYNAMIC_BITVECTOR_KERNELS:
    const CPLIB_COLLECTIONS_DYNAMIC_BITVECTOR_KERNELS* = 1
    type BitKernel* = enum
        bkAuto, bkScalar, bkAvx2, bkAvx512

    when defined(dynamicWmPortable):
        {.passC: "-DDWM_PORTABLE".}

    {.emit: """
#include <stdint.h>
#if !defined(DWM_PORTABLE) && (defined(__x86_64__) || defined(__i386__)) && (defined(__GNUC__) || defined(__clang__))
#include <immintrin.h>
#define DWM_X86 1
#define DWM_TARGET(x) __attribute__((target(x)))
#else
#define DWM_X86 0
#define DWM_TARGET(x)
#endif
static int dwm_support(int mode) {
#if DWM_X86
  __builtin_cpu_init();
  if(mode==2) return __builtin_cpu_supports("avx2") != 0;
  if(mode==3) return __builtin_cpu_supports("avx512f") && __builtin_cpu_supports("avx512bw");
#endif
  return mode<=1;
}
static int dwm_pop_base(uint64_t x) {
  x -= (x >> 1) & UINT64_C(0x5555555555555555);
  x = (x & UINT64_C(0x3333333333333333)) + ((x >> 2) & UINT64_C(0x3333333333333333));
  return (int)((((x + (x >> 4)) & UINT64_C(0x0f0f0f0f0f0f0f0f)) * UINT64_C(0x0101010101010101)) >> 56);
}
#if DWM_X86
DWM_TARGET("popcnt") static int dwm_pop_hw(uint64_t x) { return __builtin_popcountll(x); }
#endif
static int dwm_pop(uint64_t x) {
#if DWM_X86
  if (__builtin_cpu_supports("popcnt")) return dwm_pop_hw(x);
#endif
  return dwm_pop_base(x);
}
static int dwm_count_scalar(const uint64_t *a, int n) {
  int s=0; for(int i=0;i<n;++i) s+=dwm_pop(a[i]); return s;
}
#if DWM_X86
DWM_TARGET("avx2") static int dwm_count_avx2(const uint64_t *a, int n) {
  const __m256i lut=_mm256_setr_epi8(0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4);
  const __m256i mask=_mm256_set1_epi8(15);
  __m256i sum=_mm256_setzero_si256();
  int i=0;
  for(;i+4<=n;i+=4) {
    __m256i x=_mm256_loadu_si256((const __m256i*)(a+i));
    __m256i lo=_mm256_and_si256(x,mask);
    __m256i hi=_mm256_and_si256(_mm256_srli_epi16(x,4),mask);
    __m256i cnt=_mm256_add_epi8(_mm256_shuffle_epi8(lut,lo),_mm256_shuffle_epi8(lut,hi));
    sum=_mm256_add_epi64(sum,_mm256_sad_epu8(cnt,_mm256_setzero_si256()));
  }
  __m128i halves=_mm_add_epi64(_mm256_castsi256_si128(sum),_mm256_extracti128_si256(sum,1));
  int r=(int)_mm_cvtsi128_si64(halves)+(int)_mm_extract_epi64(halves,1);
  return r+dwm_count_scalar(a+i,n-i);
}
DWM_TARGET("avx2") static void dwm_left_avx2(uint64_t *a,int first,int last) {
  int i=last;
  for(;i-first+1>=4;i-=4) {
    __m256i x=_mm256_loadu_si256((const __m256i*)(a+i-3));
    __m256i y=_mm256_loadu_si256((const __m256i*)(a+i-4));
    _mm256_storeu_si256((__m256i*)(a+i-3),_mm256_or_si256(_mm256_slli_epi64(x,1),_mm256_srli_epi64(y,63)));
  }
  for(;i>=first;--i) a[i]=(a[i]<<1)|(a[i-1]>>63);
}
DWM_TARGET("avx2") static void dwm_right_avx2(uint64_t *a,int first,int last) {
  int i=first;
  for(;i+3<=last;i+=4) {
    __m256i x=_mm256_loadu_si256((const __m256i*)(a+i));
    __m256i y=_mm256_loadu_si256((const __m256i*)(a+i+1));
    _mm256_storeu_si256((__m256i*)(a+i),_mm256_or_si256(_mm256_srli_epi64(x,1),_mm256_slli_epi64(y,63)));
  }
  for(;i<=last;++i) a[i]=(a[i]>>1)|(a[i+1]<<63);
}
#endif
#if DWM_X86
DWM_TARGET("avx512f,avx512bw") static int dwm_count_avx512(const uint64_t *a, int n) {
  const __m512i lut=_mm512_broadcast_i32x4(_mm_setr_epi8(0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4));
  const __m512i mask=_mm512_set1_epi8(15);
  __m512i sum=_mm512_setzero_si512();
  int i=0;
  for(;i+8<=n;i+=8) {
    __m512i x=_mm512_loadu_si512((const void*)(a+i));
    __m512i lo=_mm512_and_si512(x,mask);
    __m512i hi=_mm512_and_si512(_mm512_srli_epi16(x,4),mask);
    __m512i cnt=_mm512_add_epi8(_mm512_shuffle_epi8(lut,lo),_mm512_shuffle_epi8(lut,hi));
    sum=_mm512_add_epi64(sum,_mm512_sad_epu8(cnt,_mm512_setzero_si512()));
  }
  int r=(int)_mm512_reduce_add_epi64(sum);
  return r+dwm_count_scalar(a+i,n-i);
}
DWM_TARGET("avx512f,avx512bw") static void dwm_left_avx512(uint64_t *a,int first,int last) {
  int i=last;
  for(;i-first+1>=8;i-=8) {
    __m512i x=_mm512_loadu_si512((const void*)(a+i-7));
    __m512i y=_mm512_loadu_si512((const void*)(a+i-8));
    _mm512_storeu_si512((void*)(a+i-7),_mm512_or_si512(_mm512_slli_epi64(x,1),_mm512_srli_epi64(y,63)));
  }
  for(;i>=first;--i) a[i]=(a[i]<<1)|(a[i-1]>>63);
}
DWM_TARGET("avx512f,avx512bw") static void dwm_right_avx512(uint64_t *a,int first,int last) {
  int i=first;
  for(;i+7<=last;i+=8) {
    __m512i x=_mm512_loadu_si512((const void*)(a+i));
    __m512i y=_mm512_loadu_si512((const void*)(a+i+1));
    _mm512_storeu_si512((void*)(a+i),_mm512_or_si512(_mm512_srli_epi64(x,1),_mm512_slli_epi64(y,63)));
  }
  for(;i<=last;++i) a[i]=(a[i]>>1)|(a[i+1]<<63);
}
#endif
#ifdef __cplusplus
extern "C" {
#endif
int dwm_rank(uint64_t *a,int p,int mode) {
  int n=p>>6, s;
#if DWM_X86
  if(mode==3) s=dwm_count_avx512(a,n);
  else if(mode==2) s=dwm_count_avx2(a,n);
  else
#endif
  s=dwm_count_scalar(a,n);
  return s+dwm_pop(a[n] & ((UINT64_C(1)<<(p&63))-1));
}
void dwm_insert(uint64_t *a,int n,int p,int b,int mode) {
  int w=p>>6, k=p&63, last=n>>6;
  uint64_t mask=(UINT64_C(1)<<k)-1;
#if DWM_X86
  if(mode==3) dwm_left_avx512(a,w+1,last);
  else if(mode==2) dwm_left_avx2(a,w+1,last);
  else
#endif
  for(int i=last;i>w;--i) a[i]=(a[i]<<1)|(a[i-1]>>63);
  a[w]=(a[w]&mask)|((a[w]&~mask)<<1)|((uint64_t)b<<k);
}
void dwm_erase(uint64_t *a,int n,int p,int mode) {
  int w=p>>6, k=p&63, last=(n-1)>>6;
  uint64_t mask=(UINT64_C(1)<<k)-1;
  a[w]=(a[w]&mask)|(((a[w]>>1)|(a[w+1]<<63))&~mask);
#if DWM_X86
  if(mode==3) dwm_right_avx512(a,w+1,last);
  else if(mode==2) dwm_right_avx2(a,w+1,last);
  else
#endif
  for(int i=w+1;i<=last;++i) a[i]=(a[i]>>1)|(a[i+1]<<63);
}
#ifdef __cplusplus
}
#endif
""".}
    proc kernelSupportedRaw(mode: cint): cint {.importc: "dwm_support", nodecl.}
    proc packedRank*(a: ptr uint64, p, mode: cint): cint {.importc: "dwm_rank".}
    proc packedInsert*(a: ptr uint64, n, p, b, mode: cint) {.importc: "dwm_insert".}
    proc packedErase*(a: ptr uint64, n, p, mode: cint) {.importc: "dwm_erase".}

    proc kernelSupported*(mode: BitKernel): bool =
        ## OS の拡張状態保存を含め、実行可能な ISA を判定する。
        kernelSupportedRaw(cint(mode)) != 0

    proc resolveKernel*(mode: BitKernel, leafBits = 4096): BitKernel =
        ## 自動選択は2048bit以上の葉で利用可能ならAVX2、それ以外はscalar。
        if mode == bkAuto:
            return if leafBits >= 2048 and kernelSupported(bkAvx2): bkAvx2 else: bkScalar
        if not kernelSupported(mode):
            raise newException(ValueError, "指定した SIMD ISA は利用できません")
        mode
