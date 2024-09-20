---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/collections/SWAG.nim
    title: cplib/collections/SWAG.nim
  - icon: ':question:'
    path: cplib/collections/SWAG.nim
    title: cplib/collections/SWAG.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/deque_operate_all_composite
    links:
    - https://judge.yosupo.jp/problem/deque_operate_all_composite
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/deque_operate_all_composite\n\
    import cplib/collections/SWAG\nproc scanf(formatstr: cstring){.header: \"<stdio.h>\"\
    , varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\nconst\
    \ MOD = 998244353\nproc op(a, b: (int, int)): (int, int) =\n    return ((a[0]*b[0])\
    \ mod MOD, ((a[1]*b[0] mod MOD) + b[1]) mod MOD)\n\nvar Q = ii()\nvar swag = initSWAG(op,\
    \ (1, 0))\nfor i in 0..<Q:\n    var q = ii()\n    if q == 0:\n        var a, b\
    \ = ii()\n        swag.addFirst((a, b))\n    elif q == 1:\n        var a, b =\
    \ ii()\n        swag.addLast((a, b))\n    elif q == 2:\n        discard swag.popFirst()\n\
    \    elif q == 3:\n        discard swag.popLast()\n    else:\n        var x =\
    \ ii()\n        var (a, b) = swag.fold()\n        echo (a*x mod MOD + b) mod MOD\n"
  dependsOn:
  - cplib/collections/SWAG.nim
  - cplib/collections/SWAG.nim
  isVerificationFile: true
  path: verify/collections/SWAG_test.nim
  requiredBy: []
  timestamp: '2024-01-28 11:14:45+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/SWAG_test.nim
layout: document
redirect_from:
- /verify/verify/collections/SWAG_test.nim
- /verify/verify/collections/SWAG_test.nim.html
title: verify/collections/SWAG_test.nim
---
