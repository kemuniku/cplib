---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/hamming_distance.nim
    title: cplib/str/hamming_distance.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/hamming_distance.nim
    title: cplib/str/hamming_distance.nim
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
    import random\nimport cplib/str/hamming_distance\n\nproc naive(s, t: openArray[char]):\
    \ int =\n    for i in 0..<s.len:\n        result += int(s[i] != t[i])\n\ndoAssert\
    \ hammingDistance(\"\", \"\") == 0\ndoAssert hammingDistance(\"kitten\", \"sitten\"\
    ) == 1\ndoAssert hammingDistance(\"\\x00\\xff\", \"\\xff\\x00\") == 2\ndoAssert\
    \ hammingDistance(@['a', 'b'], @['a', 'c']) == 1\nfor pair in [(\"\", \"a\"),\
    \ (\"abc\", \"ab\"), (newString(64), newString(65))]:\n    var raised = false\n\
    \    try:\n        discard hammingDistance(pair[0], pair[1])\n    except ValueError:\n\
    \        raised = true\n    doAssert raised\n\nrandomize(9127)\nfor n in 0..260:\n\
    \    var s = newString(n)\n    var t = newString(n)\n    doAssert hammingDistance(s,\
    \ t) == 0\n    for i in 0..<n: t[i] = '\\xff'\n    doAssert hammingDistance(s,\
    \ t) == n\n    t = newString(n)\n    for i in 0..<n:\n        t[i] = '\\x01'\n\
    \        doAssert hammingDistance(s, t) == 1\n        t[i] = '\\x00'\n    for\
    \ trial in 0..<8:\n        for i in 0..<n:\n            s[i] = char(rand(255))\n\
    \            t[i] = if rand(1) == 0: s[i] else: char(rand(255))\n        doAssert\
    \ hammingDistance(s, t) == naive(s, t)\n        doAssert hammingDistance(t, s)\
    \ == naive(s, t)\n\nfor n in [31, 32, 33, 63, 64, 65, 127, 128, 129, 1023, 1024,\
    \ 1025, 65537]:\n    var s = newString(n + 64)\n    var t = newString(n + 64)\n\
    \    for i in 0..<s.len:\n        s[i] = char(rand(255))\n        t[i] = if rand(3)\
    \ == 0: char(rand(255)) else: s[i]\n    for a in 0..<32:\n        for b in 0..<32:\n\
    \            doAssert hammingDistance(s.toOpenArray(a, a + n - 1), t.toOpenArray(b,\
    \ b + n - 1)) ==\n                naive(s.toOpenArray(a, a + n - 1), t.toOpenArray(b,\
    \ b + n - 1))\necho \"Hello World\"\n"
  dependsOn:
  - cplib/str/hamming_distance.nim
  - cplib/str/hamming_distance.nim
  isVerificationFile: true
  path: verify/str/hamming_distance_test.nim
  requiredBy: []
  timestamp: '2026-10-19 01:28:08+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/hamming_distance_test.nim
layout: document
redirect_from:
- /verify/verify/str/hamming_distance_test.nim
- /verify/verify/str/hamming_distance_test.nim.html
title: verify/str/hamming_distance_test.nim
---
