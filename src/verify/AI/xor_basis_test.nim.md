---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/xor_basis.nim
    title: cplib/math/xor_basis.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/xor_basis.nim
    title: cplib/math/xor_basis.nim
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
    echo \"Hello World\"\n\nimport cplib/math/xor_basis\n\nvar xb = initXorBasis(@[1,\
    \ 2, 3])\nassert xb.len_basis == 2\nassert xb.can_make(3)\nassert not xb.can_make(4)\n\
    xb.incl(4)\nassert xb.len_basis == 3\nassert xb.kth_smallest(0) == 0\nassert xb.kth_smallest(5)\
    \ == 5\nassert xb.kth_smallest(8) == -1\nassert xb.lt(4) == 3\nassert xb.le(4)\
    \ == 4\nassert xb.index(6) == 6\nassert xb.xor_min(5) == 5\nassert xb.xor_kth(2,\
    \ 0) == 2\nassert xb.xor_kth(2, 3) == 1\nassert xb.xor_kth(2, 8) == -1\n\nimport\
    \ algorithm\n\nfor a in 0..7:\n    for b in 0..7:\n        for c in 0..7:\n  \
    \          let inputs = [a, b, c]\n            let basis = initXorBasis(inputs)\n\
    \            let incremental = initXorBasis()\n            for value in inputs:\n\
    \                incremental.incl(value)\n            var seen: array[8, bool]\n\
    \            for mask in 0..<8:\n                var value = 0\n             \
    \   for i in 0..<3:\n                    if (mask and (1 shl i)) != 0:\n     \
    \                   value = value xor inputs[i]\n                seen[value] =\
    \ true\n            var values: seq[int]\n            for value in 0..7:\n   \
    \             if seen[value]:\n                    values.add(value)\n       \
    \     for candidate in [basis, incremental]:\n                for k, value in\
    \ values:\n                    doAssert candidate.kth_smallest(k) == value\n \
    \               for k in [-1, low(int), values.len, high(int)]:\n            \
    \        doAssert candidate.kth_smallest(k) == -1\n                for x in 0..15:\n\
    \                    var ordered: seq[int]\n                    for value in values:\n\
    \                        ordered.add(value xor x)\n                    ordered.sort()\n\
    \                    for k, value in ordered:\n                        doAssert\
    \ candidate.xor_kth(x, k) == (value xor x)\n                    for k in [-1,\
    \ low(int), values.len, high(int)]:\n                        doAssert candidate.xor_kth(x,\
    \ k) == -1\n\nblock:\n    let empty = initXorBasis()\n    doAssert empty.kth_smallest(0)\
    \ == 0\n    doAssert empty.kth_smallest(1) == -1\n    doAssert empty.kth_smallest(-1)\
    \ == -1\n    doAssert empty.xor_kth(high(int), 0) == 0\n    doAssert empty.xor_kth(high(int),\
    \ 1) == -1\n    doAssert empty.xor_kth(high(int), -1) == -1\n\nblock:\n    let\
    \ singleton = initXorBasis([high(int)])\n    doAssert singleton.kth_smallest(0)\
    \ == 0\n    doAssert singleton.kth_smallest(1) == high(int)\n    doAssert singleton.kth_smallest(2)\
    \ == -1\n    doAssert singleton.xor_kth(high(int), 0) == high(int)\n    doAssert\
    \ singleton.xor_kth(high(int), 1) == 0\n\nblock:\n    const rank = sizeof(int)\
    \ * 8 - 1\n    var powers: seq[int]\n    let incremental = initXorBasis()\n  \
    \  for bit in 0..<rank:\n        powers.add(1 shl bit)\n        incremental.incl(1\
    \ shl bit)\n    let full = initXorBasis(powers)\n    for basis in [full, incremental]:\n\
    \        doAssert basis.len_basis == rank\n        for k in [0, 1, 2, high(int)\
    \ div 2, high(int) - 1, high(int)]:\n            doAssert basis.kth_smallest(k)\
    \ == k\n            for x in [0, 1, high(int) div 2, high(int)]:\n           \
    \     doAssert basis.xor_kth(x, k) == (x xor k)\n        for k in [-1, low(int)]:\n\
    \            doAssert basis.kth_smallest(k) == -1\n            doAssert basis.xor_kth(0,\
    \ k) == -1\n\n    let smaller = initXorBasis(powers[0..<rank - 1])\n    let count\
    \ = 1 shl (rank - 1)\n    doAssert smaller.kth_smallest(count - 1) == count -\
    \ 1\n    doAssert smaller.kth_smallest(count) == -1\n    doAssert smaller.xor_kth(0,\
    \ count - 1) == count - 1\n    doAssert smaller.xor_kth(0, count) == -1\n"
  dependsOn:
  - cplib/math/xor_basis.nim
  - cplib/math/xor_basis.nim
  isVerificationFile: true
  path: verify/AI/xor_basis_test.nim
  requiredBy: []
  timestamp: '2026-09-30 20:34:41+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/xor_basis_test.nim
layout: document
redirect_from:
- /verify/verify/AI/xor_basis_test.nim
- /verify/verify/AI/xor_basis_test.nim.html
title: verify/AI/xor_basis_test.nim
---
