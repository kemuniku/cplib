---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/lcs.nim
    title: cplib/str/lcs.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/lcs.nim
    title: cplib/str/lcs.nim
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


    import cplib/str/lcs


    assert LCS(@[1, 3, 4, 1], @[3, 4, 1, 2]) == 3

    assert LCS("abcbdab", "bdcaba") == 4

    assert LCS("", "abc") == 0

    assert LCS("abc", "") == 0

    assert LCS("", "") == 0

    assert restoreLCS(@[''a'', ''b'', ''c'', ''b'', ''d'', ''a'', ''b''], @[''b'',
    ''d'', ''c'', ''a'', ''b'', ''a'']) == @[''b'', ''c'', ''b'', ''a'']

    assert restoreLCS("", "abc") == newSeq[char](0)

    assert restoreLCS("abc", "") == newSeq[char](0)

    assert restoreLCS("", "") == newSeq[char](0)

    '
  dependsOn:
  - cplib/str/lcs.nim
  - cplib/str/lcs.nim
  isVerificationFile: true
  path: verify/AI/lcs_test.nim
  requiredBy: []
  timestamp: '2026-07-07 07:45:03+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/lcs_test.nim
layout: document
redirect_from:
- /verify/verify/AI/lcs_test.nim
- /verify/verify/AI/lcs_test.nim.html
title: verify/AI/lcs_test.nim
---
