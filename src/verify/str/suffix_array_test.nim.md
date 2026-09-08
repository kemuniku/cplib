---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/suffix_array.nim
    title: cplib/str/suffix_array.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/suffix_array.nim
    title: cplib/str/suffix_array.nim
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
    import algorithm, random\nimport cplib/str/suffix_array\n\nproc naiveSuffixArray(s:\
    \ openArray[int]): seq[int] =\n    let values = @s\n    result = newSeq[int](s.len)\n\
    \    for i in 0..<s.len:\n        result[i] = i\n    result.sort(proc(l, r: int):\
    \ int =\n        var i = 0\n        while l + i < values.len and r + i < values.len:\n\
    \            if values[l + i] != values[r + i]:\n                return system.cmp(values[l\
    \ + i], values[r + i])\n            inc i\n        return system.cmp(values.len\
    \ - l, values.len - r))\n\nproc naiveLcp(s: openArray[int], sa: openArray[int]):\
    \ seq[int] =\n    result = newSeq[int](max(sa.len - 1, 0))\n    for i in 0..<result.len:\n\
    \        while result[i] + sa[i] < s.len and result[i] + sa[i + 1] < s.len and\n\
    \                s[result[i] + sa[i]] == s[result[i] + sa[i + 1]]:\n         \
    \   inc result[i]\n\nproc checkAll(s: var seq[int], pos: int) =\n    if pos ==\
    \ s.len:\n        let sa = suffix_array(s, 2)\n        doAssert sa == naiveSuffixArray(s)\n\
    \        doAssert lcp_array(s, sa) == naiveLcp(s, sa)\n        var text = newString(s.len)\n\
    \        for i, value in s:\n            text[i] = char(value * 127)\n       \
    \ doAssert suffix_array(text) == sa\n        doAssert lcp_array(text, sa) == naiveLcp(s,\
    \ sa)\n        return\n    for value in 0..2:\n        s[pos] = value\n      \
    \  checkAll(s, pos + 1)\n\ndoAssert suffix_array(\"\") == @[]\ndoAssert suffix_array(\"\
    banana\") == @[5, 3, 1, 0, 4, 2]\ndoAssert lcp_array(\"\", @[]) == @[]\ndoAssert\
    \ lcp_array(\"banana\", suffix_array(\"banana\")) == @[1, 3, 0, 0, 2]\ndoAssert\
    \ suffix_array(@[0, 0, 0], 0) == @[2, 1, 0]\ndoAssert suffix_array(@[1, 1, 1],\
    \ 1) == @[2, 1, 0]\ndoAssert lcp_array(@[0, 0, 0], @[2, 1, 0]) == @[1, 2]\nfor\
    \ n in 0..8:\n    var s = newSeq[int](n)\n    checkAll(s, 0)\n\nfor n in [64,\
    \ 127, 256, 1024]:\n    var s = newSeq[int](n)\n    for i in 0..<n:\n        s[i]\
    \ = (i * 17 + i div 7) mod 5\n    let sa = suffix_array(s, 4)\n    doAssert sa\
    \ == naiveSuffixArray(s)\n    doAssert lcp_array(s, sa) == naiveLcp(s, sa)\n\n\
    proc checkBytes(values: seq[int]) =\n    var text = newString(values.len)\n  \
    \  for i, value in values:\n        text[i] = char(value)\n    let expected =\
    \ naiveSuffixArray(values)\n    doAssert suffix_array(text) == expected\n    doAssert\
    \ suffix_array(values, 255) == expected\n    doAssert suffix_array(values) ==\
    \ expected\n    doAssert lcp_array(text, expected) == naiveLcp(values, expected)\n\
    \nvar rng = initRand(20260908)\nfor trial in 0..<2000:\n    var values = newSeq[int](rng.rand(128))\n\
    \    let upper = [1, 2, 4, 25, 255][trial mod 5]\n    for value in values.mitems:\n\
    \        value = rng.rand(upper)\n    checkBytes(values)\n\nfor n in [1, 2, 3,\
    \ 31, 32, 33, 255, 256, 257, 1024]:\n    var values = newSeq[int](n)\n    for\
    \ i in 0..<n:\n        values[i] = i mod 256\n    checkBytes(values)\n    values.reverse()\n\
    \    checkBytes(values)\n    for i in 0..<n:\n        values[i] = 255\n    checkBytes(values)\n\
    \nlet sparse = @[int.high, int.low, 0, int.high, -1, int.low]\nlet sparseSa =\
    \ naiveSuffixArray(sparse)\ndoAssert suffix_array(sparse) == sparseSa\ndoAssert\
    \ lcp_array(sparse, sparseSa) == naiveLcp(sparse, sparseSa)\ndoAssert suffix_array(@[\"\
    b\", \"a\", \"b\", \"a\"]) == @[3, 1, 2, 0]\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/str/suffix_array.nim
  - cplib/str/suffix_array.nim
  isVerificationFile: true
  path: verify/str/suffix_array_test.nim
  requiredBy: []
  timestamp: '2026-09-08 14:01:24+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/suffix_array_test.nim
layout: document
redirect_from:
- /verify/verify/str/suffix_array_test.nim
- /verify/verify/str/suffix_array_test.nim.html
title: verify/str/suffix_array_test.nim
---
