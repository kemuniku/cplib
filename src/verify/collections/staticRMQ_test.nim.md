---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/staticrmq
    links:
    - https://judge.yosupo.jp/problem/staticrmq
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/staticrmq\n\
    import sequtils\nimport cplib/collections/staticRMQ\n\nproc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr\
    \ result)\nvar N,Q = ii()\nvar A = newseqwith(N,ii())\nvar RMQ = initRMQ(A)\n\
    for i in 0..<Q:\n    var l,r = ii()\n    stdout.writeLine(RMQ.query(l,r))"
  dependsOn:
  - cplib/collections/staticRMQ.nim
  - cplib/collections/staticRMQ.nim
  isVerificationFile: true
  path: verify/collections/staticRMQ_test.nim
  requiredBy: []
  timestamp: '2024-07-19 08:04:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/staticRMQ_test.nim
layout: document
redirect_from:
- /verify/verify/collections/staticRMQ_test.nim
- /verify/verify/collections/staticRMQ_test.nim.html
title: verify/collections/staticRMQ_test.nim
---
