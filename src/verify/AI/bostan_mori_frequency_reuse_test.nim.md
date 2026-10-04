---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/bostan_mori.nim
    title: cplib/fps/bostan_mori.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/bostan_mori.nim
    title: cplib/fps/bostan_mori.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/formal_power_series.nim
    title: cplib/fps/formal_power_series.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/formal_power_series.nim
    title: cplib/fps/formal_power_series.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
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
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import random\nimport cplib/modint/modint\nimport cplib/fps/bostan_mori\n\nvar\
    \ checks = 0\nvar rng = initRand(9382026)\nproc mul(a,b,m: int): int = int((a.int64*b.int64)\
    \ mod m.int64)\nproc power(a,e,m: int): int =\n  result = 1\n  var b=a\n  var\
    \ n=e\n  while n>0:\n    if (n and 1)!=0: result=mul(result,b,m)\n    b=mul(b,b,m)\n\
    \    n=n shr 1\nproc series(p,q: seq[int], k,m: int): int =\n  var a=newSeq[int](k+1)\n\
    \  let iq=(m+1) div 2\n  for i in 0..k:\n    var v=if i<p.len: p[i] else: 0\n\
    \    for j in 1..min(i,q.high):\n      v=(v-mul(q[j],a[i-j],m)+m) mod m\n    a[i]=mul(v,iq,m)\n\
    \  a[k]\nproc check[T](p,q: seq[int], k,want:int, label:string) =\n  var pp=newSeq[T](p.len)\n\
    \  var qq=newSeq[T](q.len)\n  for i,v in p: pp[i]=init(T,v)\n  for i,v in q: qq[i]=init(T,v)\n\
    \  let savedP = pp\n  let savedQ = qq\n  let got=bostanMori(pp,qq,k).val\n  doAssert\
    \ pp == savedP and qq == savedQ\n  doAssert got==want, label & \" k=\" & $k &\
    \ \" p=\" & $p.len & \" q=\" & $q.len & \" got=\" & $got & \" want=\" & $want\n\
    \  inc checks\nproc suite[T](label:string) =\n  let m=T.umod.int\n  for n in [1,2,31,32,63,64,65,127,128,129,255,256,257]:\n\
    \    var p=newSeq[int](n+7)\n    var q=newSeq[int](n)\n    q[0]=2\n    for i in\
    \ 0..<p.len: p[i]=rng.rand(m-1)\n    for i in 1..<q.len: q[i]=rng.rand(m-1)\n\
    \    for k in [0,1,30,31,32,62,63,64,65,126,127,128,129,254,255,256,257,349]:\n\
    \      check[T](p,q,k,series(p,q,k,m),label & \" dense\")\n    for i in 0..<min(p.len,65):\
    \ p[i]=0\n    q.add(0);q.add(0);p.add(0)\n    for k in [0,64,128,350]:\n     \
    \ check[T](p,q,k,series(p,q,k,m),label & \" zero edges\")\n    var sparse=newSeq[int](n+1)\n\
    \    sparse[0]=2\n    sparse[n]=m-6 mod m\n    for k in [high(int),high(int)-1,int(1_000_000_000_000_000_000)]:\n\
    \      var want=0\n      for j,v in p:\n        if j<=k and (k-j) mod n==0:\n\
    \          want=(want+mul(v,power(3,(k-j) div n,m),m)) mod m\n      want=mul(want,(m+1)\
    \ div 2,m)\n      check[T](p,sparse,k,want,label & \" sparse high\")\n    var\
    \ qq = @[2]\n    for k in [0,31,64,257,high(int)]:\n      let want=if k<p.len:mul(p[k],(m+1)\
    \ div 2,m) else:0\n      check[T](p,qq,k,want,label & \" constant\")\n    check[T](@[],q,high(int),0,label\
    \ & \" empty\")\n    check[T](@[0,0,0],q,high(int),0,label & \" zero\")\n    var\
    \ initial=newSeq[T](n)\n    var coefficient=newSeq[T](n)\n    var seqOracle=newSeq[int](n+80)\n\
    \    for i in 0..<n:\n      seqOracle[i]=rng.rand(m-1)\n      initial[i]=init(T,seqOracle[i])\n\
    \      coefficient[i]=init(T,rng.rand(m-1))\n    for i in n..<seqOracle.len:\n\
    \      for j in 0..<n:\n        seqOracle[i]=(seqOracle[i]+mul(coefficient[j].val,seqOracle[i-j-1],m))\
    \ mod m\n    for k in [0,n-1,n,n+1,n+79]:\n      doAssert linearRecurrenceKth(initial,coefficient,k).val==seqOracle[k],\
    \ label & \" recurrence \" & $n & \" \" & $k\n      inc checks\n  for degree in\
    \ [64,128,256]:\n    for plen in [degree-1,degree,degree+1]:\n      var p=newSeq[int](plen)\n\
    \      var q=newSeq[int](degree+1)\n      q[0]=2\n      for i in 0..<p.len: p[i]=rng.rand(m-1)\n\
    \      for i in 1..<q.len: q[i]=rng.rand(m-1)\n      for k in [degree-1,degree,degree+1,degree*2-2,degree*2-1,degree*2,degree*2+1,degree*3+17]:\n\
    \        check[T](p,q,k,series(p,q,k,m),label & \" alias dense\")\n      for i\
    \ in 1..<degree: q[i]=0\n      q[degree]=(m-6 mod m) mod m\n      for k in [high(int),high(int)-1,int(1_000_000_000_000_000_000)]:\n\
    \        var want=0\n        for j,v in p:\n          if j<=k and (k-j) mod degree==0:\n\
    \            want=(want+mul(v,power(3,(k-j) div degree,m),m)) mod m\n        want=mul(want,(m+1)\
    \ div 2,m)\n        check[T](p,q,k,want,label & \" alias sparse high\")\nsuite[modint998244353_barrett](\"\
    static Barrett 998\")\nsuite[modint998244353_montgomery](\"static Montgomery 998\"\
    )\nsuite[modint1000000007_barrett](\"static Barrett 1e9+7\")\nfor m in [998244353,1000000007,15,998244353]:\n\
    \  modint_barrett.setMod(m)\n  suite[modint_barrett](\"dynamic Barrett \" & $m)\n\
    for m in [998244353,15,998244353]:\n  modint_montgomery.setMod(m)\n  suite[modint_montgomery](\"\
    dynamic Montgomery \" & $m)\ndoAssert checks == 5800\necho \"Hello World\"\n"
  dependsOn:
  - cplib/fps/bostan_mori.nim
  - cplib/math/inv_gcd.nim
  - cplib/convolution/convolution.nim
  - cplib/math/isprime.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/convolution/convolution.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/fps/formal_power_series.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/modint.nim
  - cplib/math/isprime.nim
  - cplib/fps/bostan_mori.nim
  - cplib/math/isqrt.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/modint.nim
  - cplib/fps/formal_power_series.nim
  isVerificationFile: true
  path: verify/AI/bostan_mori_frequency_reuse_test.nim
  requiredBy: []
  timestamp: '2026-10-02 14:56:06+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/bostan_mori_frequency_reuse_test.nim
layout: document
redirect_from:
- /verify/verify/AI/bostan_mori_frequency_reuse_test.nim
- /verify/verify/AI/bostan_mori_frequency_reuse_test.nim.html
title: verify/AI/bostan_mori_frequency_reuse_test.nim
---
