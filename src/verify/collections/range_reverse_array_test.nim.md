---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/range_reverse_array.nim
    title: cplib/collections/range_reverse_array.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/range_reverse_array.nim
    title: cplib/collections/range_reverse_array.nim
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
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\nimport sequtils\nimport cplib/collections/range_reverse_array\n\
    \nvar empty = initRangeReverseArray(newSeq[int]())\nempty.reverse(0, 0)\nassert\
    \ empty.len == 0\nassert empty.toSeq == newSeq[int]()\n\nvar a = initRangeReverseArray((0..<10).toSeq)\n\
    assert a.len == 10\nassert a.toSeq == (0..<10).toSeq\n\na.reverse(2, 7)\nassert\
    \ a.toSeq == @[0, 1, 6, 5, 4, 3, 2, 7, 8, 9]\nassert a[0] == 0\nassert a[2] ==\
    \ 6\nassert a[^1] == 9\n\na.reverse(0..<0)\na.reverse(3, 3)\nassert a.toSeq ==\
    \ @[0, 1, 6, 5, 4, 3, 2, 7, 8, 9]\n\na.reverse(0..9)\nassert a.toSeq == @[9, 8,\
    \ 7, 2, 3, 4, 5, 6, 1, 0]\na.update(3, 100)\nassert a.toSeq == @[9, 8, 7, 100,\
    \ 3, 4, 5, 6, 1, 0]\na[^1] = -1\nassert a.toSeq == @[9, 8, 7, 100, 3, 4, 5, 6,\
    \ 1, -1]\n\nvar b = initRangeReverseArray([\"a\", \"b\", \"c\", \"d\"])\nb.reverse(1,\
    \ 4)\nassert b[1] == \"d\"\nb[2] = \"x\"\nassert b.toSeq == @[\"a\", \"d\", \"\
    x\", \"b\"]\nassert $b == \"a d x b\"\n\nvar c = initRangeReverseArray((0..<12).toSeq)\n\
    var expected = (0..<12).toSeq\nfor l in 0..12:\n    for r in l..12:\n        c.reverse(l,\
    \ r)\n        var i = l\n        var j = r - 1\n        while i < j:\n       \
    \     let tmp = expected[i]\n            expected[i] = expected[j]\n         \
    \   expected[j] = tmp\n            i += 1\n            j -= 1\n        for k in\
    \ 0..<12:\n            assert c[k] == expected[k]\n        assert c.toSeq == expected\n"
  dependsOn:
  - cplib/collections/range_reverse_array.nim
  - cplib/collections/range_reverse_array.nim
  isVerificationFile: true
  path: verify/collections/range_reverse_array_test.nim
  requiredBy: []
  timestamp: '2026-07-06 18:53:13+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/range_reverse_array_test.nim
layout: document
redirect_from:
- /verify/verify/collections/range_reverse_array_test.nim
- /verify/verify/collections/range_reverse_array_test.nim.html
title: verify/collections/range_reverse_array_test.nim
---
