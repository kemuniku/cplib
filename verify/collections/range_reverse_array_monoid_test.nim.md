---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/range_reverse_array_monoid.nim
    title: cplib/collections/range_reverse_array_monoid.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/range_reverse_array_monoid.nim
    title: cplib/collections/range_reverse_array_monoid.nim
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

    import cplib/collections/range_reverse_array_monoid


    proc addInt(a, b: int): int = a + b


    var emptyMonoid = initRangeReverseArrayMonoid(newSeq[int](), addInt, 0)

    emptyMonoid.reverse(0, 0)

    assert emptyMonoid.len == 0

    assert emptyMonoid.get_all == 0

    assert emptyMonoid.get(0, 0) == 0


    var d = initRangeReverseArrayMonoid((0..<8).toSeq, addInt, 0)

    assert d.len == 8

    assert d.get_all == 28

    assert d.get(2, 6) == 14

    assert d[2..5] == 14

    d.reverse(1, 7)

    assert d.toSeq == @[0, 6, 5, 4, 3, 2, 1, 7]

    assert d.get_all == 28

    assert d.get(1, 4) == 15

    d[3] = 100

    assert d.toSeq == @[0, 6, 5, 100, 3, 2, 1, 7]

    assert d.get(2, 6) == 110

    assert d[^1] == 7


    var e = newRangeReverseArrayMonoidWith((1..5).toSeq, l + r, 0)

    assert e.fold == 15

    e.reverse(1..<4)

    assert e.toSeq == @[1, 4, 3, 2, 5]

    assert e.fold(1, 4) == 9


    proc concat(a, b: string): string = a & b


    var f = initRangeReverseArrayMonoid(["a", "b", "c", "d", "e"], concat, "")

    assert f.get_all == "abcde"

    assert f.get(1, 4) == "bcd"

    f.reverse(1, 5)

    assert f.toSeq == @["a", "e", "d", "c", "b"]

    assert f.get_all == "aedcb"

    assert f[1..3] == "edc"

    f[2] = "X"

    assert f.toSeq == @["a", "e", "X", "c", "b"]

    assert f.fold == "aeXcb"

    assert $f == "a e X c b"

    '
  dependsOn:
  - cplib/collections/range_reverse_array_monoid.nim
  - cplib/collections/range_reverse_array_monoid.nim
  isVerificationFile: true
  path: verify/collections/range_reverse_array_monoid_test.nim
  requiredBy: []
  timestamp: '2026-07-06 18:53:13+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/range_reverse_array_monoid_test.nim
layout: document
redirect_from:
- /verify/verify/collections/range_reverse_array_monoid_test.nim
- /verify/verify/collections/range_reverse_array_monoid_test.nim.html
title: verify/collections/range_reverse_array_monoid_test.nim
---
