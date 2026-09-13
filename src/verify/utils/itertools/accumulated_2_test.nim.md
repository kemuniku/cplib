---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  - icon: ':question:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  - icon: ':question:'
    path: cplib/utils/itertools.nim
    title: cplib/utils/itertools.nim
  - icon: ':question:'
    path: cplib/utils/itertools.nim
    title: cplib/utils/itertools.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/static_range_sum
    links:
    - https://judge.yosupo.jp/problem/static_range_sum
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/static_range_sum\n\
    \nimport cplib/utils/itertools\nimport sequtils\n\nproc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr\
    \ result)\n\nvar N,Q = ii()\nvar a = (@[0]&newseqwith(N,ii())).accumulated(a+b)\n\
    \nfor i in 0..<Q:\n    var l = ii()\n    var r = ii()\n    echo a[r]-a[l]"
  dependsOn:
  - cplib/tree/prufer.nim
  - cplib/tree/prufer.nim
  - cplib/utils/itertools.nim
  - cplib/utils/itertools.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/utils/itertools/accumulated_2_test.nim
  requiredBy: []
  timestamp: '2026-09-13 11:46:22+09:00'
  verificationStatus: TEST_WRONG_ANSWER
  verifiedWith: []
documentation_of: verify/utils/itertools/accumulated_2_test.nim
layout: document
redirect_from:
- /verify/verify/utils/itertools/accumulated_2_test.nim
- /verify/verify/utils/itertools/accumulated_2_test.nim.html
title: verify/utils/itertools/accumulated_2_test.nim
---
