---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/utils/itertools.nim
    title: cplib/utils/itertools.nim
  - icon: ':question:'
    path: cplib/utils/itertools.nim
    title: cplib/utils/itertools.nim
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


    import sequtils

    import cplib/utils/itertools


    assert toSeq(permutations(@[1, 2, 3])).len == 6

    assert toSeq(distinct_permutations(@[1, 1, 2])) == @[@[1, 1, 2], @[1, 2, 1], @[2,
    1, 1]]

    assert accumulated(@[1, 2, 3], a + b, 0) == @[0, 1, 3, 6]

    assert accumulated(@[1, 2, 3], a + b) == @[1, 3, 6]

    var xs = @[1, 2, 3]

    accumulate(xs, a + b)

    assert xs == @[1, 3, 6]

    assert accumulatedr(@[1, 2, 3], a + b, 0) == @[6, 5, 3, 0]

    assert accumulatedr(@[1, 2, 3], a + b) == @[6, 5, 3]

    var ys = @[1, 2, 3]

    accumulater(ys, a + b)

    assert ys == @[6, 5, 3]

    let r = 2

    assert toSeq(combinations(@[1, 2, 3], r)) == @[@[1, 2], @[1, 3], @[2, 3]]

    let r0 = 0

    assert toSeq(combinations(@[1, 2, 3], r0)) == @[newSeq[int]()]

    assert toSeq(combinations_withf(@[2, 3, 5], 2, proc(l, r: int): int = l * r))
    == @[6, 10, 15]

    assert toSeq(combinations(@[1, 2, 3], 2)).mapIt(@[it[0], it[1]]) == @[@[1, 2],
    @[1, 3], @[2, 3]]

    assert toSeq(product(@[0, 1], 2)) == @[@[0, 0], @[1, 0], @[0, 1], @[1, 1]]

    assert toSeq(product(@[7], 0)) == @[newSeq[int]()]

    assert toSeq(partitions(4)) == @[@[1, 1, 1, 1], @[1, 1, 2], @[1, 3], @[2, 2],
    @[4]]

    '
  dependsOn:
  - cplib/utils/itertools.nim
  - cplib/utils/itertools.nim
  isVerificationFile: true
  path: verify/AI/itertools_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/itertools_test.nim
layout: document
redirect_from:
- /verify/verify/AI/itertools_test.nim
- /verify/verify/AI/itertools_test.nim.html
title: verify/AI/itertools_test.nim
---
