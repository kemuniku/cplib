---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/hashtable.nim
    title: cplib/collections/hashtable.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/hashtable.nim
    title: cplib/collections/hashtable.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/associative_array
    links:
    - https://judge.yosupo.jp/problem/associative_array
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/associative_array\n\
    import strutils\nimport cplib/collections/hashtable\nproc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr\
    \ result)\n\nvar q = ii()\nvar st = initHashTable[int, int]()\nvar ans = newSeqOfCap[int](q)\n\
    for _ in 0..<q:\n    var t = ii()\n    if t == 0:\n        var k, v = ii()\n \
    \       st[k] = v\n    else:\n        var k = ii()\n        if k in st: ans.add(st[k])\n\
    \        else: ans.add(0)\necho ans.join(\"\\n\")\n"
  dependsOn:
  - cplib/collections/hashtable.nim
  - cplib/collections/hashtable.nim
  isVerificationFile: true
  path: verify/collections/associative_array_test.nim
  requiredBy: []
  timestamp: '2024-03-21 23:52:09+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/associative_array_test.nim
layout: document
redirect_from:
- /verify/verify/collections/associative_array_test.nim
- /verify/verify/collections/associative_array_test.nim.html
title: verify/collections/associative_array_test.nim
---
