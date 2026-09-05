---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/deletable_heapqueue.nim
    title: cplib/collections/deletable_heapqueue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/deletable_heapqueue.nim
    title: cplib/collections/deletable_heapqueue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/topk_sum_heapq.nim
    title: cplib/collections/topk_sum_heapq.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/topk_sum_heapq.nim
    title: cplib/collections/topk_sum_heapq.nim
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


    import cplib/collections/topk_sum_heapq


    let top = initTopKHeapq(@[5, 1, 3, 7], 2)

    assert top.sm == 16

    assert top.topk == 12

    assert top.k == 2

    top.incl(6)

    assert top.sm == 22

    assert top.topk == 13

    top.excl(7)

    assert top.sm == 15

    assert top.topk == 11

    top.addK()

    assert top.k == 3

    assert top.topk == 14

    top.minusK()

    assert top.k == 2

    assert top.topk == 11

    top.setK(1)

    assert top.k == 1

    assert top.topk == 6

    '
  dependsOn:
  - cplib/collections/deletable_heapqueue.nim
  - cplib/collections/topk_sum_heapq.nim
  - cplib/collections/topk_sum_heapq.nim
  - cplib/collections/deletable_heapqueue.nim
  isVerificationFile: true
  path: verify/AI/topk_sum_heapq_test.nim
  requiredBy: []
  timestamp: '2026-07-07 07:12:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/topk_sum_heapq_test.nim
layout: document
redirect_from:
- /verify/verify/AI/topk_sum_heapq_test.nim
- /verify/verify/AI/topk_sum_heapq_test.nim.html
title: verify/AI/topk_sum_heapq_test.nim
---
