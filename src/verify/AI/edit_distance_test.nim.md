---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/edit_distance.nim
    title: cplib/str/edit_distance.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/edit_distance.nim
    title: cplib/str/edit_distance.nim
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
    \nimport random, strutils\nimport cplib/str/edit_distance\n\nproc naive(s, t:\
    \ string): int =\n    var dp = newSeq[int](t.len + 1)\n    for j in 0..t.len:\n\
    \        dp[j] = j\n    for i in 0..<s.len:\n        var diagonal = dp[0]\n  \
    \      dp[0] = i + 1\n        for j in 0..<t.len:\n            let old = dp[j\
    \ + 1]\n            dp[j + 1] = min(min(dp[j] + 1, old + 1), diagonal + ord(s[i]\
    \ != t[j]))\n            diagonal = old\n    return dp[t.len]\n\nproc check(s,\
    \ t: string) =\n    let distance = naive(s, t)\n    for k in 0..max(s.len, t.len)\
    \ + 1:\n        let expected = if distance <= k: distance else: -1\n        doAssert\
    \ editDistance(s, t, k) == expected, $(@[s, t]) & \" k=\" & $k\n\nvar words =\
    \ @[\"\"]\nfor length in 1..5:\n    for bits in 0..<(1 shl length):\n        var\
    \ s = newString(length)\n        for i in 0..<length:\n            s[i] = char(ord('a')\
    \ + ((bits shr i) and 1))\n        words.add(s)\nfor s in words:\n    for t in\
    \ words:\n        check(s, t)\n\ncheck(\"kitten\", \"sitting\")\ncheck(\"ab\"\
    , \"ba\")\ncheck(\"\\0\\xff$\\0\", \"\\xff\\0$\\0\")\ndoAssert editDistance(\"\
    a\", \"b\", high(int)) == 1\n\nvar rng = initRand(20260908)\nfor trial in 0..<600:\n\
    \    var s = newString(rng.rand(100))\n    var t = newString(rng.rand(100))\n\
    \    let alphabet = if trial mod 2 == 0: 3 else: 255\n    for c in s.mitems:\n\
    \        c = char(rng.rand(alphabet))\n    for c in t.mitems:\n        c = char(rng.rand(alphabet))\n\
    \    let distance = naive(s, t)\n    for k in [0, max(0, distance - 1), distance,\
    \ distance + 1]:\n        doAssert editDistance(s, t, k) == (if distance <= k:\
    \ distance else: -1)\n\nlet longString = repeat(\"ab\\0\\xff\", 25000)\ndoAssert\
    \ editDistance(longString, longString, 2) == 0\nvar changed = longString\nchanged[50000]\
    \ = 'c'\nchanged[99999] = 'd'\ndoAssert editDistance(longString, changed, 1) ==\
    \ -1\ndoAssert editDistance(longString, changed, 2) == 2\ndoAssert editDistance(longString,\
    \ \"z\" & longString, 1) == 1\ndoAssert editDistance(\"z\" & longString, longString,\
    \ 1) == 1\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/str/suffix_array.nim
  - cplib/str/edit_distance.nim
  - cplib/str/edit_distance.nim
  - cplib/str/suffix_array.nim
  isVerificationFile: true
  path: verify/AI/edit_distance_test.nim
  requiredBy: []
  timestamp: '2026-09-08 16:17:28+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/edit_distance_test.nim
layout: document
redirect_from:
- /verify/verify/AI/edit_distance_test.nim
- /verify/verify/AI/edit_distance_test.nim.html
title: verify/AI/edit_distance_test.nim
---
