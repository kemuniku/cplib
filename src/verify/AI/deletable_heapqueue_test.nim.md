---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/deletable_heapqueue.nim
    title: cplib/collections/deletable_heapqueue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/deletable_heapqueue.nim
    title: cplib/collections/deletable_heapqueue.nim
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


    import cplib/collections/deletable_heapqueue


    var hq = initDeletableHeapQueue[int]()

    assert hq.len == 0

    hq.push(5)

    hq.push(1)

    hq.push(3)

    assert hq[0] == 1

    assert hq.len == 3

    hq.delete(3)

    assert hq.len == 2

    assert hq.pop() == 1

    assert hq[0] == 5

    hq.push(2)

    assert hq.pop() == 2

    assert hq.pop() == 5


    var hq2 = toDeletableHeapQueue(@[4, 2, 6])

    assert hq2[0] == 2

    hq2.delete(2)

    assert hq2[0] == 4

    '
  dependsOn:
  - cplib/collections/deletable_heapqueue.nim
  - cplib/collections/deletable_heapqueue.nim
  isVerificationFile: true
  path: verify/AI/deletable_heapqueue_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/deletable_heapqueue_test.nim
layout: document
redirect_from:
- /verify/verify/AI/deletable_heapqueue_test.nim
- /verify/verify/AI/deletable_heapqueue_test.nim.html
title: verify/AI/deletable_heapqueue_test.nim
---
