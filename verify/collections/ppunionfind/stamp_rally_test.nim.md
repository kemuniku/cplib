---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/ppunionfind.nim
    title: cplib/collections/ppunionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/ppunionfind.nim
    title: cplib/collections/ppunionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/binary_search.nim
    title: cplib/utils/binary_search.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/binary_search.nim
    title: cplib/utils/binary_search.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/agc002/tasks/agc002_d
    links:
    - https://atcoder.jp/contests/agc002/tasks/agc002_d
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/agc002/tasks/agc002_d\n\
    import cplib/collections/ppunionfind\nimport cplib/utils/binary_search\n\nproc\
    \ scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\n\nvar N,M = ii()\nvar UF = initPartialPersistentUnionFind(N)\n\
    for i in 0..<(M):\n    var a,b = ii()-1\n    UF.unite(a,b,i+1)\nvar Q = ii()\n\
    for i in 0..<(Q):\n    var x,y,z = ii()\n    x -= 1\n    y -= 1\n    proc is_ok(arg:int):bool=\n\
    \        if UF.issame(x,y,arg):\n            return UF.size(x,arg) >= z\n    \
    \    else:\n            return UF.size(x,arg)+UF.size(y,arg) >= z\n    echo meguru_bisect(M,0,is_ok)\n\
    \n"
  dependsOn:
  - cplib/collections/ppunionfind.nim
  - cplib/utils/binary_search.nim
  - cplib/collections/ppunionfind.nim
  - cplib/utils/binary_search.nim
  isVerificationFile: true
  path: verify/collections/ppunionfind/stamp_rally_test.nim
  requiredBy: []
  timestamp: '2024-09-19 01:13:36+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/ppunionfind/stamp_rally_test.nim
layout: document
redirect_from:
- /verify/verify/collections/ppunionfind/stamp_rally_test.nim
- /verify/verify/collections/ppunionfind/stamp_rally_test.nim.html
title: verify/collections/ppunionfind/stamp_rally_test.nim
---