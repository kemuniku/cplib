---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/seqidx.nim
    title: cplib/utils/seqidx.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/seqidx.nim
    title: cplib/utils/seqidx.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

    echo "Hello World"


    import cplib/utils/seqidx


    let xs = @[3, 1, 4, 1, 5]

    assert xs.allItidx(idx >= 0 and it > 0)

    assert xs.anyItIdx(idx == 2 and it == 4)

    assert xs.findItIdx(it == 1 and idx > 0) == 1

    assert xs.mapItIdx(it + idx) == @[3, 2, 6, 4, 9]

    assert newSeqWithIdx(4, idx * idx) == @[0, 1, 4, 9]

    '
  dependsOn:
  - cplib/utils/seqidx.nim
  - cplib/utils/seqidx.nim
  isVerificationFile: true
  path: verify/AI/seqidx_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/seqidx_test.nim
layout: document
redirect_from:
- /verify/verify/AI/seqidx_test.nim
- /verify/verify/AI/seqidx_test.nim.html
title: verify/AI/seqidx_test.nim
---
