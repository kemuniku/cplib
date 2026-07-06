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


    import cplib/collections/QSWAG


    let op = proc(x, y: int): int = x + y

    var q = initSWAG(op, 0)

    assert q.len == 0

    q.push(1)

    q.push(2)

    q.push(3)

    assert q.len == 3

    assert q.fold() == 6

    assert q[0] == 1

    assert q[2] == 3

    assert q.pop() == 1

    assert q.fold() == 5

    q.push(4)

    assert q.pop() == 2

    assert q.fold() == 7

    assert $q == "@[3]@[4]"

    '
  dependsOn:
  - cplib/collections/QSWAG.nim
  - cplib/collections/QSWAG.nim
  isVerificationFile: true
  path: verify/AI/QSWAG_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/QSWAG_test.nim
layout: document
redirect_from:
- /verify/verify/AI/QSWAG_test.nim
- /verify/verify/AI/QSWAG_test.nim.html
title: verify/AI/QSWAG_test.nim
---
