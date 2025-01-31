---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/defaultdict.nim
    title: cplib/collections/defaultdict.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/defaultdict.nim
    title: cplib/collections/defaultdict.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc348/tasks/abc348_c
    links:
    - https://atcoder.jp/contests/abc348/tasks/abc348_c
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc348/tasks/abc348_c\n\
    import tables, sequtils\nimport cplib/collections/defaultdict\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\n\nvar n = ii()\nvar d = initDefaultDict[int, int](1000_000_000_000.int)\n\
    for _ in 0..<n:\n    var a, c = ii()\n    d[c] = min(d[c], a)\necho d.values.toseq.max\n"
  dependsOn:
  - cplib/collections/defaultdict.nim
  - cplib/collections/defaultdict.nim
  isVerificationFile: false
  path: verify/collections/defaultdict/defaultdict_abc348c_test_.nim
  requiredBy: []
  timestamp: '2024-04-08 07:44:23+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/collections/defaultdict/defaultdict_abc348c_test_.nim
layout: document
redirect_from:
- /library/verify/collections/defaultdict/defaultdict_abc348c_test_.nim
- /library/verify/collections/defaultdict/defaultdict_abc348c_test_.nim.html
title: verify/collections/defaultdict/defaultdict_abc348c_test_.nim
---
