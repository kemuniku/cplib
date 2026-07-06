---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/manacher.nim
    title: cplib/str/manacher.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/manacher.nim
    title: cplib/str/manacher.nim
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

    import cplib/str/manacher


    assert manacher("ababa".toSeq)[2] == 3

    assert manacher(@[1, 2, 2, 1])[1] == 1

    let pals = get_palindromes("abba".toSeq, ''$'')

    assert pals[0] == (0, 1)

    assert pals[3] == (0, 4)

    assert pals[5] == (-1, -1)

    '
  dependsOn:
  - cplib/str/manacher.nim
  - cplib/str/manacher.nim
  isVerificationFile: true
  path: verify/AI/manacher_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/manacher_test.nim
layout: document
redirect_from:
- /verify/verify/AI/manacher_test.nim
- /verify/verify/AI/manacher_test.nim.html
title: verify/AI/manacher_test.nim
---
