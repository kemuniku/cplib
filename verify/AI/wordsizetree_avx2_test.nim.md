---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/wordsizetree_avx2.nim
    title: cplib/collections/wordsizetree_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/wordsizetree_avx2.nim
    title: cplib/collections/wordsizetree_avx2.nim
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
    # AVX2\u5BFE\u5FDC\u306ECPU\u304C\u5FC5\u8981\u3067\u3059\u3002\nimport cplib/collections/wordsizetree_avx2\n\
    import algorithm, random\nfor n in [0, 1, 31, 32, 33, 63, 64, 65, 95, 96, 97,\
    \ 127, 128, 129, 4095, 4096, 4097, 262143, 262144, 262145, 16777216]:\n    for\
    \ pattern in 0..2:\n        var v = newSeq[bool](n)\n        for i in 0..<n:\n\
    \            v[i] = pattern == 1 or (pattern == 2 and i mod 67 == 0)\n       \
    \ var tree = initWordsizeTree(v)\n        for i in 0..<n:\n            doAssert\
    \ tree[i] == v[i]\n        if n > 0:\n            tree.incl(n - 1)\n         \
    \   doAssert tree.ge(n - 1) == n - 1\n            doAssert tree.le(n - 1) == n\
    \ - 1\n            tree.excl(n - 1)\n            doAssert not tree[n - 1]\n\n\
    for n in 1..256:\n    var v = newSeq[bool](n)\n    for i in 0..<n: v[i] = (i *\
    \ 37 + n * 13) mod 101 < 49\n    var tree = initWordsizeTree(v)\n    for i in\
    \ 0..<n:\n        var lo = -1\n        var hi = -1\n        for j in 0..i:\n \
    \           if v[j]: lo = j\n        for j in countdown(n - 1, i):\n         \
    \   if v[j]: hi = j\n        doAssert tree.le(i) == lo\n        doAssert tree.ge(i)\
    \ == hi\n\nvar tree = initWordsizeTree()\nvar reference: seq[int]\nvar rng = initRand(12345)\n\
    for step in 0..<30000:\n    let x = rng.rand(WordsizeTreeAvx2Capacity - 1)\n \
    \   let pos = reference.lowerBound(x)\n    case step mod 4\n    of 0:\n      \
    \  tree.incl(x)\n        tree.incl(x)\n        if pos == reference.len or reference[pos]\
    \ != x: reference.insert(x, pos)\n    of 1:\n        tree.excl(x)\n        if\
    \ pos < reference.len and reference[pos] == x: reference.delete(pos)\n       \
    \ if reference.len > 0:\n            let index = rng.rand(reference.high)\n  \
    \          tree.excl(reference[index])\n            reference.delete(index)\n\
    \    else: discard\n    let hi = reference.lowerBound(x)\n    let lo = reference.upperBound(x)\
    \ - 1\n    doAssert tree.ge(x) == (if hi == reference.len: -1 else: reference[hi])\n\
    \    doAssert tree.le(x) == (if lo < 0: -1 else: reference[lo])\nfor x in reference:\
    \ tree.excl(x)\ndoAssert tree.ge(0) == -1\ndoAssert tree.le(WordsizeTreeAvx2Capacity\
    \ - 1) == -1\nfor x in [0, 63, 64, 255, 256, 65535, 65536, WordsizeTreeAvx2Capacity\
    \ - 1]:\n    tree.incl(x)\n    doAssert tree.ge(x) == x\n    doAssert tree.le(x)\
    \ == x\n    tree.excl(x)\n    doAssert tree.ge(0) == -1\ndoAssert tree.le(-1)\
    \ == -1\ndoAssert tree.ge(WordsizeTreeAvx2Capacity) == -1\necho \"Hello World\"\
    \n"
  dependsOn:
  - cplib/collections/wordsizetree_avx2.nim
  - cplib/collections/wordsizetree_avx2.nim
  isVerificationFile: true
  path: verify/AI/wordsizetree_avx2_test.nim
  requiredBy: []
  timestamp: '2026-09-08 05:12:42+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/wordsizetree_avx2_test.nim
layout: document
redirect_from:
- /verify/verify/AI/wordsizetree_avx2_test.nim
- /verify/verify/AI/wordsizetree_avx2_test.nim.html
title: verify/AI/wordsizetree_avx2_test.nim
---
