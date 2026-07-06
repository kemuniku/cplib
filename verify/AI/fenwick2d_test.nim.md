---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/fenwick2d.nim
    title: cplib/collections/fenwick2d.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/fenwick2d.nim
    title: cplib/collections/fenwick2d.nim
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


    import cplib/collections/fenwick2d


    let fw = initFenwick2D(@[@[1, 4], @[2], @[1, 3]])

    fw.add(0, 1, 5)

    fw.add(0, 4, 2)

    fw.add(1, 2, 7)

    fw.add(2, 3, 11)

    assert fw.prefix(3, 10) == 25

    assert fw.getLess(0, 2, 3) == 12

    assert fw.get(0, 3, 2, 4) == 18

    assert fw.get(2, 3, 0, 2) == 0

    '
  dependsOn:
  - cplib/collections/fenwick2d.nim
  - cplib/collections/fenwick2d.nim
  isVerificationFile: true
  path: verify/AI/fenwick2d_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/fenwick2d_test.nim
layout: document
redirect_from:
- /verify/verify/AI/fenwick2d_test.nim
- /verify/verify/AI/fenwick2d_test.nim.html
title: verify/AI/fenwick2d_test.nim
---
