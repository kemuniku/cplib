---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitset.nim
    title: cplib/collections/bitset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitset.nim
    title: cplib/collections/bitset.nim
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
    echo \"Hello World\"\n\nimport cplib/collections/bitset\n\nvar a = initBitSet(@[true,\
    \ false, true, false, true], 71)\nvar b = initBitSet(71)\nb[1] = true\nb[2] =\
    \ true\nb[64] = true\nassert a.len == 71\nassert a[0]\nassert not a[1]\nassert\
    \ a.popcount() == 3\nassert b.popcount() == 3\nassert (a & b).popcount() == 1\n\
    assert (a | b).popcount() == 5\nassert (a ^ b).popcount() == 4\nassert a.andpopcount(b)\
    \ == 1\nassert a.orpopcount(b) == 5\nassert a.xorpopcount(b) == 4\na &= b\nassert\
    \ a.popcount() == 1\na |= b\nassert a.popcount() == 3\na ^= b\nassert a.popcount()\
    \ == 0\na[70] = true\nassert a[70]\na[70] = false\nassert not a[70]\n\nvar c =\
    \ initBitSetFromIndexes(@[0, 63, 64, 129], 130)\nassert c.popcount == 4\nvar cItems:\
    \ seq[int]\nfor i in c:\n    cItems.add(i)\nassert cItems == @[0, 63, 64, 129]\n\
    assert c.lowestBit == 0\nassert initBitSet(130).lowestBit == -1\nassert (c <<\
    \ 1).popcount == 3\nassert (c << 1)[1]\nassert (c << 1)[64]\nassert (c << 1)[65]\n\
    assert (c >> 1).popcount == 3\nassert (c >> 1)[62]\nassert (c >> 1)[63]\nassert\
    \ (c >> 1)[128]\nassert (c << 64)[64]\nassert (c << 64)[127]\nassert (c << 64)[128]\n\
    assert (c >> 64)[0]\nassert (c >> 64)[65]\nassert (c << 130).popcount == 0\nassert\
    \ (c >> 130).popcount == 0\nassert (~c).popcount == 126\n\nvar d = initBitSet(@[true,\
    \ false, true])\nassert d.len == 3\nassert $d == \"101\"\nd[0] = 0\nd[1] = 1\n\
    assert $d == \"110\"\nassert (~initBitSet(0)).popcount == 0\n\nvar caught = false\n\
    try:\n    discard initBitSet(1)[1]\nexcept IndexDefect:\n    caught = true\nassert\
    \ caught\n\ncaught = false\ntry:\n    discard initBitSet(1) | initBitSet(2)\n\
    except ValueError:\n    caught = true\nassert caught\n\ncaught = false\ntry:\n\
    \    discard c << -1\nexcept ValueError:\n    caught = true\nassert caught\n\n\
    for n in @[0, 1, 2, 63, 64, 65, 127, 128, 129, 191]:\n    var x = initBitSet(n)\n\
    \    var y = initBitSet(n)\n    for i in 0..<n:\n        x[i] = (i mod 3 == 0)\
    \ or (i mod 11 == 4)\n        y[i] = (i mod 5 == 1) or (i mod 7 == 2)\n    assert\
    \ (x & y).popcount == x.andpopcount(y)\n    assert (x | y).popcount == x.orpopcount(y)\n\
    \    assert (x ^ y).popcount == x.xorpopcount(y)\n    assert x.popcount + (~x).popcount\
    \ == n\n    for shift in 0..(n + 1):\n        let left = x << shift\n        let\
    \ right = x >> shift\n        assert left.len == n\n        assert right.len ==\
    \ n\n        for i in 0..<n:\n            assert left[i] == (i >= shift and x[i\
    \ - shift])\n            assert right[i] == (i + shift < n and x[i + shift])\n"
  dependsOn:
  - cplib/collections/bitset.nim
  - cplib/collections/bitset.nim
  isVerificationFile: true
  path: verify/AI/bitset_test.nim
  requiredBy: []
  timestamp: '2026-08-28 03:04:13+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/bitset_test.nim
layout: document
redirect_from:
- /verify/verify/AI/bitset_test.nim
- /verify/verify/AI/bitset_test.nim.html
title: verify/AI/bitset_test.nim
---
