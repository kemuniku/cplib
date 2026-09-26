---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitvector.nim
    title: cplib/collections/bitvector.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitvector.nim
    title: cplib/collections/bitvector.nim
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
    echo \"Hello World\"\n\nimport cplib/collections/bitvector\n\nvar bv = newBitVector(130)\n\
    bv.set(0)\nbv.set(64)\nbv.set(129)\nbv.build()\nassert bv.access(0)\nassert bv[64]\n\
    assert not bv[65]\nassert bv.rank(0) == 0\nassert bv.rank(65) == 2\nassert bv.rank(130)\
    \ == 3\n\nvar words = newBitVector(130)\nwords.setWord(0, 1'u64 or (1'u64 shl\
    \ 63))\nwords.setWord(1, 1'u64 or (1'u64 shl 63))\nwords.setWord(2, 2'u64)\nwords.build()\n\
    var expected = 0\nfor i in 0..130:\n    assert words.rank(i) == expected\n   \
    \ if i < 130:\n        let present = i in [0, 63, 64, 127, 129]\n        assert\
    \ words[i] == present\n        if present: inc expected\nwords.setWord(0, 0)\n\
    words.build()\nassert words.rank(64) == 0\nassert words.rank(130) == 3\n"
  dependsOn:
  - cplib/collections/bitvector.nim
  - cplib/collections/bitvector.nim
  isVerificationFile: true
  path: verify/AI/bitvector_test.nim
  requiredBy: []
  timestamp: '2026-09-27 01:00:48+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/bitvector_test.nim
layout: document
redirect_from:
- /verify/verify/AI/bitvector_test.nim
- /verify/verify/AI/bitvector_test.nim.html
title: verify/AI/bitvector_test.nim
---
