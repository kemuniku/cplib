---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/tree/cartesiantree.nim
    title: cplib/tree/cartesiantree.nim
  - icon: ':question:'
    path: cplib/tree/cartesiantree.nim
    title: cplib/tree/cartesiantree.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/cartesian_tree
    links:
    - https://judge.yosupo.jp/problem/cartesian_tree
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://judge.yosupo.jp/problem/cartesian_tree

    include prelude

    proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}

    proc ii(): int {.inline.} = scanf("%lld\n", addr result)


    import cplib/tree/cartesiantree

    var N = ii()

    var A = newseqwith(N,ii())

    var car_tree = A.cartesian_tree_tuple()

    echo (0..<N).toseq().mapit(if car_tree[it].p != -1 : car_tree[it].p else : it).join("
    ")

    '
  dependsOn:
  - cplib/tree/cartesiantree.nim
  - cplib/tree/cartesiantree.nim
  isVerificationFile: true
  path: verify/tree/cartesiantree_test.nim
  requiredBy: []
  timestamp: '2026-07-06 04:42:52+09:00'
  verificationStatus: TEST_WRONG_ANSWER
  verifiedWith: []
documentation_of: verify/tree/cartesiantree_test.nim
layout: document
redirect_from:
- /verify/verify/tree/cartesiantree_test.nim
- /verify/verify/tree/cartesiantree_test.nim.html
title: verify/tree/cartesiantree_test.nim
---
