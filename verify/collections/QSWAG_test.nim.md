---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/QSWAG.nim
    title: cplib/collections/QSWAG.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/QSWAG.nim
    title: cplib/collections/QSWAG.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/queue_operate_all_composite
    links:
    - https://judge.yosupo.jp/problem/queue_operate_all_composite
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/queue_operate_all_composite\n\
    import cplib/collections/QSWAG\nproc scanf(formatstr: cstring){.header: \"<stdio.h>\"\
    , varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\nconst\
    \ MOD = 998244353\nproc op(a, b: (int, int)): (int, int) =\n    return ((a[0]*b[0])\
    \ mod MOD, ((a[1]*b[0] mod MOD) + b[1]) mod MOD)\n\nvar Q = ii()\nvar swag = initSWAG(op,\
    \ (1, 0))\nfor i in 0..<Q:\n    var q = ii()\n    if q == 0:\n        var a, b\
    \ = ii()\n        swag.push((a, b))\n    elif q == 1:\n        discard swag.pop()\n\
    \    else:\n        var x = ii()\n        var (a, b) = swag.fold()\n        echo\
    \ (a*x mod MOD + b) mod MOD\n"
  dependsOn:
  - cplib/collections/QSWAG.nim
  - cplib/collections/QSWAG.nim
  isVerificationFile: true
  path: verify/collections/QSWAG_test.nim
  requiredBy: []
  timestamp: '2023-11-21 23:57:46+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/QSWAG_test.nim
layout: document
redirect_from:
- /verify/verify/collections/QSWAG_test.nim
- /verify/verify/collections/QSWAG_test.nim.html
title: verify/collections/QSWAG_test.nim
---
