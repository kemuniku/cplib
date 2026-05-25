---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/euler_phi.nim
    title: cplib/math/euler_phi.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/euler_phi.nim
    title: cplib/math/euler_phi.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "import cplib/math/euler_phi\n\nwhen not declared CPLIB_MODINT_EXPMODINT:\n\
    \    const CPLIB_MODINT_EXPMODINT* = 1\n\n    proc getmod[P:static int](x:int):int=\n\
    \        if x < 2*P:\n            return x\n        else:\n            return\
    \ (x mod P) + P\n    proc mul[P:static int](x,y:int):int=\n        return getmod[P](x*y)\n\
    \    proc pow[P:static int](a,n:int):int=\n        var\n            rev = 1 mod\
    \ P\n            a = a\n            n = n\n        while n > 0:\n            if\
    \ n mod 2 != 0: rev = mul[P](rev, a)\n            if n > 1: a = mul[P](a, a)\n\
    \            n = n shr 1\n        return rev\n    type expmodint[P:static int]\
    \ = object\n        when P == 1:\n            x:int\n        else:\n         \
    \   x: int\n            p: expmodint[euler_phi(P)]\n\n    proc tomodint[P:static\
    \ int](x:int):expmodint[P] =\n        when P == 1:\n            return expmodint[P](x:0)\n\
    \        else:\n            return expmodint[P](x:getmod[P](x),p:tomodint[euler_phi(P)](x))\n\
    \n    proc val[P:static int](a:expmodint[P]):int=\n        if a.x < P:\n     \
    \       return a.x\n        else:\n            return a.x-P\n\n    proc pow[P,Q:static\
    \ int](a:expmodint[P],b:expmodint[Q]):expmodint[P]=\n        when P == 1:\n  \
    \          return expmodint[P](x:0)\n        else:\n            return expmodint[P](x:pow[P](a.x,b.p.x),p:pow(a.p,b.p))\n\
    \n    proc `$`[P:static int](a:expmodint[P]):string=\n        return $a.val()\n\
    \n    proc `+`[P:static int](a,b:expmodint[P]):expmodint[P]=\n        when P ==\
    \ 1:\n            return toModint[P](x:0)\n        else:\n            return tomodint[P](x:getmod[P](a.x+b.x),p:a.p+b.p)\n\
    \n    proc `*`[P:static int](a,b:expmodint[P]):expmodint[P]=\n        when P ==\
    \ 1:\n            return toModint[P](x:0)\n        else:\n            return tomodint[P](x:mul[P](a.x,b.x),p:a.p*b.p)\n"
  dependsOn:
  - cplib/math/euler_phi.nim
  - cplib/math/euler_phi.nim
  isVerificationFile: false
  path: cplib/modint/exp_modint.nim
  requiredBy: []
  timestamp: '2026-03-23 02:51:01+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/modint/exp_modint.nim
layout: document
redirect_from:
- /library/cplib/modint/exp_modint.nim
- /library/cplib/modint/exp_modint.nim.html
title: cplib/modint/exp_modint.nim
---
