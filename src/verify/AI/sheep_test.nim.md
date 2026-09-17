---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
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
    echo \"Hello World\"\n\nimport cplib/tmpl/sheep\nimport cplib/modint/modint\n\
    import sequtils\n\nassert (-3) % 5 == 2\nassert (-3) // 2 == -2\nassert @[1, 2,\
    \ 3].join(\",\") == \"1,2,3\"\nassert @[low(int), -1, 0, high(int)].join(\",\"\
    ) ==\n    \"-9223372036854775808,-1,0,9223372036854775807\"\nassert @[0u32, high(uint32)].join(\"\
    \ \") == \"0 4294967295\"\nassert @['a', 'b'].join(\"-\") == \"a-b\"\nlet values\
    \ = @[1, -2, 30]\nassert (*values) == \"1 -2 30\"\nlet fixedValues = [4, 5, 6]\n\
    assert (*fixedValues) == \"4 5 6\"\nlet words = @[\"foo\", \"bar\"]\nassert (*words)\
    \ == \"foo bar\"\nlet empty: seq[int] = @[]\nassert (*empty) == \"\"\nassert @[low(int32),\
    \ high(int32)].join(\" \") == \"-2147483648 2147483647\"\nassert @[0u64, high(uint64)].join(\"\
    \ \") == \"0 18446744073709551615\"\nlet barrett = @[modint998244353_barrett(1),\n\
    \    modint998244353_barrett(998244352)]\nlet montgomery = @[modint998244353_montgomery(1),\n\
    \    modint998244353_montgomery(998244352)]\nassert (*barrett) == \"1 998244352\"\
    \nassert (*montgomery) == \"1 998244352\"\n\ndoAssert compiles(print(1, 2, 3,\
    \ sep = \"\\n\"))\ndoAssert compiles(print(\"a\", \"b\"))\ndoAssert compiles(print(*values,\
    \ sep = \"\\n\"))\n\nblock:\n    doAssert (0..<5).mapIt(it * it) == @[0, 1, 4,\
    \ 9, 16]\n    doAssert (2..4).mapIt($it) == @[\"2\", \"3\", \"4\"]\n    doAssert\
    \ (0..<6).filterIt(it mod 2 == 0) == @[0, 2, 4]\n    doAssert (3..3).filterIt(it\
    \ == 3) == @[3]\n    doAssert (2..4).filterIt(false) == newSeq[int]()\n    doAssert\
    \ ('a'..'c').mapIt($it) == @[\"a\", \"b\", \"c\"]\n    doAssert ('a'..'c').filterIt(it\
    \ != 'b') == @['a', 'c']\n    doAssert (1'i64..3'i64).filterIt(it != 2) == @[1'i64,\
    \ 3'i64]\n    for bounds in [0..<0, 0..<(-3), 5..2]:\n        doAssert bounds.mapIt(it\
    \ * 2) == newSeq[int]()\n        doAssert bounds.filterIt(true) == newSeq[int]()\n\
    \    let closures = (2..4).mapIt(proc (x: int): int = it + x)\n    doAssert closures[0](10)\
    \ == 12\n    doAssert closures[1](10) == 13\n    doAssert closures[2](10) == 14\n\
    \    doAssert (0..<3).mapIt((0..it).mapIt(it)) == @[@[0], @[0, 1], @[0, 1, 2]]\n\
    \    var evaluations = 0\n    proc bounds(): Slice[int] =\n        inc evaluations\n\
    \        2..4\n    var visits: seq[int] = @[]\n    doAssert bounds().mapIt((visits.add(it);\
    \ it * 2)) == @[4, 6, 8]\n    doAssert evaluations == 1\n    doAssert visits ==\
    \ @[2, 3, 4]\n    visits.setLen(0)\n    doAssert bounds().filterIt((visits.add(it);\
    \ it != 3)) == @[2, 4]\n    doAssert evaluations == 2\n    doAssert visits ==\
    \ @[2, 3, 4]\n    doAssert @[1, 2, 3].mapIt(it * 2) == @[2, 4, 6]\n    doAssert\
    \ [1, 2, 3].filterIt(it != 2) == @[1, 3]\n    doAssert (0..<5).countIt(it mod\
    \ 2 == 0) == 3\n    doAssert (0..<5).allIt(it >= 0)\n    doAssert (0..<5).anyIt(it\
    \ == 3)\n"
  dependsOn:
  - cplib/modint/modint.nim
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/tmpl/sheep.nim
  - cplib/tmpl/sheep.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/tmpl/fastio.nim
  - cplib/tmpl/fastio.nim
  - cplib/modint/barrett_impl.nim
  isVerificationFile: true
  path: verify/AI/sheep_test.nim
  requiredBy: []
  timestamp: '2026-09-18 01:13:21+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/sheep_test.nim
layout: document
redirect_from:
- /verify/verify/AI/sheep_test.nim
- /verify/verify/AI/sheep_test.nim.html
title: verify/AI/sheep_test.nim
---
