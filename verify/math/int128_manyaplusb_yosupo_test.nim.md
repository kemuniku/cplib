---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/many_aplusb_128bit
    links:
    - https://judge.yosupo.jp/problem/many_aplusb_128bit
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/many_aplusb_128bit\n\
    import cplib/math/int128\nimport strutils\nproc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\nproc getchar(): char {.importc: \"getchar_unlocked\"\
    , header: \"<stdio.h>\", discardable.}\nproc ii(): int {.inline.} = scanf(\"%lld\\\
    n\", addr result)\nproc si(): string {.inline.} =\n    result = \"\"\n    var\
    \ c: char\n    while true:\n        c = getchar()\n        if c == ' ' or c ==\
    \ '\\n':\n            break\n        result &= c\n\nvar t = ii()\nvar ans = newSeq[Int128](t)\n\
    for i in 0..<t:\n    var a, b = si().parseInt128\n    ans[i] = a + b\necho ans.join(\"\
    \\n\")\n"
  dependsOn:
  - cplib/math/int128.nim
  - cplib/math/int128.nim
  isVerificationFile: true
  path: verify/math/int128_manyaplusb_yosupo_test.nim
  requiredBy: []
  timestamp: '2024-11-05 10:19:37+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/int128_manyaplusb_yosupo_test.nim
layout: document
redirect_from:
- /verify/verify/math/int128_manyaplusb_yosupo_test.nim
- /verify/verify/math/int128_manyaplusb_yosupo_test.nim.html
title: verify/math/int128_manyaplusb_yosupo_test.nim
---
