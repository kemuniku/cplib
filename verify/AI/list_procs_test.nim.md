---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/list_procs.nim
    title: cplib/utils/list_procs.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/list_procs.nim
    title: cplib/utils/list_procs.nim
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


    import lists, sequtils

    import cplib/utils/list_procs


    var l = initDoublyLinkedList[int]()

    let n1 = newDoublyLinkedNode(1)

    let n3 = newDoublyLinkedNode(3)

    let n0 = newDoublyLinkedNode(0)

    let n2 = newDoublyLinkedNode(2)

    l.append(n1)

    l.append(n3)

    l.insertPrev(n1, n0)

    l.insert(n1, n2)

    assert l.toSeq == @[0, 1, 2, 3]

    assert l.head == n0

    assert l.tail == n3

    assert n2.prev == n1

    assert n2.next == n3

    '
  dependsOn:
  - cplib/utils/list_procs.nim
  - cplib/utils/list_procs.nim
  isVerificationFile: true
  path: verify/AI/list_procs_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/list_procs_test.nim
layout: document
redirect_from:
- /verify/verify/AI/list_procs_test.nim
- /verify/verify/AI/list_procs_test.nim.html
title: verify/AI/list_procs_test.nim
---
