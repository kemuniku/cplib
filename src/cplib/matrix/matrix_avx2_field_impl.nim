when not declared CPLIB_MATRIX_MATRIX_AVX2_FIELD_IMPL:
    const CPLIB_MATRIX_MATRIX_AVX2_FIELD_IMPL = 1

    {.emit: """
#ifndef CPLIB_MATRIX_FIELD_KERNEL_HPP
#define CPLIB_MATRIX_FIELD_KERNEL_HPP
#include <vector>
#include <stdexcept>
namespace cplib_mat_field_detail {
struct Field : cplib_mat_detail::Mod {
  explicit Field(uint32_t p):Mod(p) {
    // 既存の積カーネルと同じMontgomery表現を使う。
  }
  uint32_t one() const {
    // 正規化したMontgomery表現の1を返す。
    return red(r2);
  }
  uint32_t neg(uint32_t a) const {
    // 正規化した要素の符号を反転する。
    return a ? p-a : 0;
  }
  uint32_t mul(uint32_t a,uint32_t b) const {
    // 正規化した2要素の積を求める。
    return red(uint64_t(a)*b);
  }
  __m256i mul8(__m256i a,__m256i b) const {
    // 偶数・奇数レーンの積を分けて8要素を同時にMontgomery還元する。
    return red8(_mm256_mul_epu32(a,b),
      _mm256_mul_epu32(_mm256_srli_epi64(a,32),_mm256_srli_epi64(b,32)));
  }
  uint32_t inverse(uint32_t value) const {
    // ピボットの逆元を拡張Euclid法で求める。
    int64_t a=red(value),b=p,u=1,v=0;
    while(b){int64_t q=a/b,t=a-q*b;a=b;b=t;t=u-q*v;u=v;v=t;}
    if(a!=1)throw std::domain_error("matrix pivot is not invertible");
    u%=p;if(u<0)u+=p;
    return red(uint64_t(u)*r2);
  }
  void read(const uint32_t *src,uint32_t *dst,size_t count,bool montgomery) const {
    // modint内部値を8個ずつ正規化したMontgomery表現に変換する。
    size_t i=0;__m256i r=_mm256_set1_epi32(r2);
    for(;i+8<=count;i+=8){
      __m256i x=_mm256_loadu_si256((const __m256i*)(src+i));
      x=montgomery?_mm256_min_epu32(x,_mm256_sub_epi32(x,vp)):mul8(x,r);
      _mm256_storeu_si256((__m256i*)(dst+i),x);
    }
    for(;i<count;i++)dst[i]=montgomery?(src[i]>=p?src[i]-p:src[i]):red(uint64_t(src[i])*r2);
  }
  void write(const uint32_t *src,uint32_t *dst,size_t count,bool montgomery) const {
    // 計算結果を8個ずつ呼び出し元のmodint表現へ戻す。
    size_t i=0;__m256i v1=_mm256_set1_epi32(1);
    for(;i+8<=count;i+=8){
      __m256i x=_mm256_loadu_si256((const __m256i*)(src+i));
      _mm256_storeu_si256((__m256i*)(dst+i),montgomery?x:mul8(x,v1));
    }
    for(;i<count;i++)dst[i]=montgomery?src[i]:red(src[i]);
  }
  void scale(const uint32_t *src,uint32_t *dst,size_t count,uint32_t factor) const {
    // 行または多項式の係数を8個ずつ定数倍する。
    size_t i=0;__m256i f=_mm256_set1_epi32(factor);
    for(;i+8<=count;i+=8)_mm256_storeu_si256((__m256i*)(dst+i),mul8(_mm256_loadu_si256((const __m256i*)(src+i)),f));
    for(;i<count;i++)dst[i]=mul(src[i],factor);
  }
  template<bool subtract>
  void addScaled(uint32_t *dst,const uint32_t *src,size_t count,uint32_t factor) const {
    // dstにfactor*srcを8要素ずつ加減算する。端数は領域外を読まず処理する。
    size_t i=0;__m256i f=_mm256_set1_epi32(factor);
    for(;i+8<=count;i+=8){
      __m256i x=_mm256_loadu_si256((const __m256i*)(dst+i));
      __m256i y=mul8(_mm256_loadu_si256((const __m256i*)(src+i)),f);
      _mm256_storeu_si256((__m256i*)(dst+i),subtract?sub(x,y):add(x,y));
    }
    for(;i<count;i++){
      uint32_t y=mul(src[i],factor);
      if(subtract)dst[i]=dst[i]>=y?dst[i]-y:dst[i]+p-y;
      else {uint32_t x=dst[i]+y;dst[i]=x>=p?x-p:x;}
    }
  }
};
static void prepare(const uint32_t *src,const uint32_t *rhs,uint32_t *dst,int h,int w,int extra,uint32_t modulus,bool montgomery,bool identity){
  // 行列と右辺・単位行列を連続した作業領域にコピーする。
  const Field f(modulus);size_t stride=size_t(w)+extra;
  for(int i=0;i<h;i++){
    if(w)f.read(src+size_t(i)*w,dst+size_t(i)*stride,w,montgomery);
    if(rhs)f.read(rhs+i,dst+size_t(i)*stride+w,1,montgomery);
    if(identity)dst[size_t(i)*stride+w+i]=f.one();
  }
}
static int eliminate(uint32_t *a,int h,int stride,int columns,int *pivots,uint32_t *det,uint32_t modulus,bool reduced){
  // 前進消去と必要に応じた後退消去をAVX2の行更新で行う。
  const Field f(modulus);int rank=0;*det=f.one();
  for(int col=0;col<columns && rank<h;col++){
    int pivot=rank;
    while(pivot<h && !a[size_t(pivot)*stride+col])pivot++;
    if(pivot==h)continue;
    uint32_t *row=a+size_t(rank)*stride;
    if(pivot!=rank){
      std::swap_ranges(row+col,row+stride,a+size_t(pivot)*stride+col);
      *det=f.neg(*det);
    }
    uint32_t value=row[col];*det=f.mul(*det,value);
    f.scale(row+col+1,row+col+1,stride-col-1,f.inverse(value));row[col]=f.one();
    for(int i=rank+1;i<h;i++){
      uint32_t *dst=a+size_t(i)*stride;uint32_t factor=dst[col];
      if(factor){dst[col]=0;f.addScaled<true>(dst+col+1,row+col+1,stride-col-1,factor);}
    }
    pivots[rank++]=col;
  }
  if(reduced)for(int r=rank-1;r>=0;r--){
    int col=pivots[r];const uint32_t *row=a+size_t(r)*stride;
    for(int i=0;i<r;i++){
      uint32_t *dst=a+size_t(i)*stride;uint32_t factor=dst[col];
      if(factor){dst[col]=0;f.addScaled<true>(dst+col+1,row+col+1,stride-col-1,factor);}
    }
  }
  return rank;
}
static void restore(uint32_t *values,size_t count,uint32_t modulus,bool montgomery){
  // 作業用のMontgomery表現をmodint内部値へ一括変換する。
  Field(modulus).write(values,values,count,montgomery);
}
static uint32_t canonical(uint32_t value,uint32_t modulus){
  // スカラーのMontgomery表現を公開値へ戻す。
  return Field(modulus).red(value);
}
static void inverseAdjugate(const uint32_t *a,uint32_t *out,int n,int rank,const int *pivots,uint32_t det,uint32_t modulus,bool montgomery,bool adjugate){
  // 掃き出した拡大行列から逆行列・余因子行列をAVX2で復元する。
  const Field f(modulus);const size_t stride=size_t(n)*2;
  if(rank<n-1)return;
  if(rank==n){
    for(int i=0;i<n;i++){
      const uint32_t *src=a+size_t(i)*stride+n;uint32_t *dst=out+size_t(i)*n;
      if(adjugate){f.scale(src,dst,n,det);f.write(dst,dst,n,montgomery);}
      else f.write(src,dst,n,montgomery);
    }
  }else{
    int free=0;for(int i=0;i<rank;i++)if(pivots[i]==free)free++;
    uint32_t scale=((n-1-free)&1)?f.neg(det):det;
    uint32_t *freeRow=out+size_t(free)*n;
    f.scale(a+size_t(n-1)*stride+n,freeRow,n,scale);
    for(int i=0;i<rank;i++)f.scale(freeRow,out+size_t(pivots[i])*n,n,f.neg(a[size_t(i)*stride+free]));
    f.write(out,out,size_t(n)*n,montgomery);
  }
}
struct Hafnian {
  Field f;size_t degree,stride;
  Hafnian(uint32_t modulus,size_t n):f(modulus),degree(n/2),stride(degree+1){
    // 最後に必要となる係数の次数を保持する。
  }
  void addProduct(uint32_t *dst,const uint32_t *a,const uint32_t *b) const {
    // x倍した多項式積を次数で打ち切り、係数をAVX2で加算する。
    for(size_t i=0;i<degree;i++)if(a[i])f.addScaled<false>(dst+i+1,b,degree-i,a[i]);
  }
  std::vector<uint32_t> solve(const std::vector<uint32_t>& a,size_t size) const {
    // 最後の2頂点を使う項を包除して、多項式を返す。
    std::vector<uint32_t> answer(stride);
    if(!size){answer[0]=f.one();return answer;}
    if(size==2){std::copy_n(a.data(),degree,answer.data()+1);return answer;}
    size_t m=size-2,u=m*(m-1)/2*stride,v=m*(m+1)/2*stride;
    std::vector<uint32_t> reduced(a.begin(),a.begin()+u);
    auto without=solve(reduced,m);
    for(size_t i=0;i<m;i++)for(size_t j=0;j<i;j++){
      uint32_t *dst=reduced.data()+(i*(i-1)/2+j)*stride;
      addProduct(dst,a.data()+u+i*stride,a.data()+v+j*stride);
      addProduct(dst,a.data()+v+i*stride,a.data()+u+j*stride);
    }
    auto with=solve(reduced,m);
    size_t i=0;
    for(;i+8<=stride;i+=8)_mm256_storeu_si256((__m256i*)(answer.data()+i),
      f.sub(_mm256_loadu_si256((const __m256i*)(with.data()+i)),_mm256_loadu_si256((const __m256i*)(without.data()+i))));
    for(;i<stride;i++)answer[i]=with[i]>=without[i]?with[i]-without[i]:with[i]+f.p-without[i];
    addProduct(answer.data(),with.data(),a.data()+v+m*stride);
    return answer;
  }
};
static uint32_t hafnian(const uint32_t *src,int n,uint32_t modulus,bool montgomery){
  // 下三角成分を多項式に変換し、hafnianの公開値を返す。
  Hafnian h(modulus,n);std::vector<uint32_t> a(size_t(n)*(n?size_t(n)-1:0)/2*h.stride);
  for(int i=0;i<n;i++)for(int j=0;j<i;j++)h.f.read(src+size_t(i)*n+j,a.data()+(size_t(i)*(i-1)/2+j)*h.stride,1,montgomery);
  return h.f.red(h.solve(a,n)[h.degree]);
}
}
#endif
""".}

    proc fieldPrepareNative(src, rhs, dst: ptr uint32, h, w, extra: cint, modulus: uint32, montgomery, identity: bool) {.importcpp: "cplib_mat_field_detail::prepare(@)", nodecl.}
    proc fieldEliminateNative(a: ptr uint32, h, stride, columns: cint, pivots: ptr cint, det: ptr uint32, modulus: uint32, reduced: bool): cint {.importcpp: "cplib_mat_field_detail::eliminate(@)", nodecl.}
    proc fieldRestoreNative(values: ptr uint32, count: csize_t, modulus: uint32, montgomery: bool) {.importcpp: "cplib_mat_field_detail::restore(@)", nodecl.}
    proc fieldCanonicalNative(value, modulus: uint32): uint32 {.importcpp: "cplib_mat_field_detail::canonical(@)", nodecl.}
    proc fieldInverseAdjugateNative(a, output: ptr uint32, n, rank: cint, pivots: ptr cint, det, modulus: uint32, montgomery, adjugate: bool) {.importcpp: "cplib_mat_field_detail::inverseAdjugate(@)", nodecl.}
    proc fieldHafnianNative(a: ptr uint32, n: cint, modulus: uint32, montgomery: bool): uint32 {.importcpp: "cplib_mat_field_detail::hafnian(@)", nodecl.}

    proc fieldPrepareKernel(src, rhs, dst: ptr uint32, h, w, extra: int, modulus: uint32, montgomery, identity: bool) =
        ## 検証済みの形状と内部値を作業領域へ渡す。
        fieldPrepareNative(src, rhs, dst, h.cint, w.cint, extra.cint, modulus, montgomery, identity)
    proc fieldEliminateKernel(a: ptr uint32, h, stride, columns: int, pivots: ptr cint, det: var uint32, modulus: uint32, reduced: bool): int =
        ## 検証済みの作業領域をAVX2で消去する。
        fieldEliminateNative(a, h.cint, stride.cint, columns.cint, pivots, addr det, modulus, reduced).int
    proc fieldRestoreKernel(values: ptr uint32, count: int, modulus: uint32, montgomery: bool) =
        ## 作業領域をmodint内部値へ一括変換する。
        fieldRestoreNative(values, count.csize_t, modulus, montgomery)
    proc fieldCanonicalKernel(value, modulus: uint32): uint32 =
        ## スカラーのMontgomery表現を公開値へ戻す。
        fieldCanonicalNative(value, modulus)
    proc fieldInverseAdjugateKernel(a, output: ptr uint32, n, rank: int, pivots: ptr cint, det, modulus: uint32, montgomery, adjugate: bool) =
        ## 逆行列・余因子行列の復元をAVX2カーネルに渡す。
        fieldInverseAdjugateNative(a, output, n.cint, rank.cint, pivots, det, modulus, montgomery, adjugate)
    proc fieldHafnianKernel(a: ptr uint32, n: int, modulus: uint32, montgomery: bool): uint32 =
        ## 対称行列のhafnianをAVX2カーネルで求める。
        fieldHafnianNative(a, n.cint, modulus, montgomery)
