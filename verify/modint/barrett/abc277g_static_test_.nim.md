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
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc227/tasks/abc227_g
    links:
    - https://atcoder.jp/contests/abc227/tasks/abc227_g
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc227/tasks/abc227_g\n\
    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\nimport sequtils, algorithm, tables\n\
    import cplib/math/isqrt\nimport cplib/modint/modint\ntype mint = modint998244353_barrett\n\
    \nvar n, k = ii()\nif k == 0:\n    echo 1\n    quit()\nvar mf = newSeqWith(k+1,\
    \ -1)\nfor i in 2..k:\n    if mf[i] == -1:\n        mf[i] = i\n        for j in\
    \ countup(i*2, k, i):\n            if mf[j] == -1: mf[j] = i\n\nvar small = newSeqWith(max(k+1,\
    \ isqrt(n)+1), -1)\nvar sp = newSeq[int]()\nfor i in 2..<small.len:\n    if small[i]\
    \ == -1:\n        small[i] = i\n        sp.add(i)\n        for j in countup(i*2,\
    \ small.len-1, i):\n            if small[j] == -1: small[j] = i\n\nvar upper =\
    \ ((n - k + 1)..(n)).toSeq\n\nvar count = newSeqWith(sp.len, 0)\nvar pos = 0\n\
    for p in sp:\n    var s = if (n - k + 1) mod p == 0: 0 else: p - (n - k + 1) mod\
    \ p\n    for i in countup(s, upper.len-1, p):\n        while upper[i] mod p ==\
    \ 0:\n            upper[i] = upper[i] div p\n            count[pos] += 1\n   \
    \ pos += 1\n\nfor i in 2..k:\n    var pos = i\n    while mf[pos] != -1:\n    \
    \    var nx = mf[pos]\n        count[sp.lowerbound(nx)] -= 1\n        pos = pos\
    \ div nx\n\nvar uc = initCountTable[int]()\nfor i in upper:\n    if i != 1: uc.inc(i)\n\
    var ans = mint(1)\nfor i in count:\n    ans *= mint(i + 1)\nfor k, v in uc:\n\
    \    ans *= mint(v + 1)\necho ans\n"
  dependsOn:
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  isVerificationFile: false
  path: verify/modint/barrett/abc277g_static_test_.nim
  requiredBy: []
  timestamp: '2025-04-27 18:34:28+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/modint/barrett/abc277g_static_test_.nim
layout: document
redirect_from:
- /library/verify/modint/barrett/abc277g_static_test_.nim
- /library/verify/modint/barrett/abc277g_static_test_.nim.html
title: verify/modint/barrett/abc277g_static_test_.nim
---
