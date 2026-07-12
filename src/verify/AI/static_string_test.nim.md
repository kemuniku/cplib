---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
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

    import cplib/str/static_string


    let s = toStaticString("banana")

    assert $s == "banana"

    assert s.len == 6

    assert s[1] == ''a''

    assert $s[1..3] == "ana"

    assert lcp(s[1..5], s[3..5]) == 3

    assert cmp(s[1..3], s[3..5]) == 0

    assert s[1..3] == s[3..5]

    assert s[0..2] > s[1..3]

    let sa1 = initSuffixArray(s.base).mapIt($it)

    assert sa1[0] == "a"

    let sa2 = initSuffixArray(s).mapIt($it)

    assert sa2[0] == "a"

    let ss = toStaticStrings(@["aba", "abc"])

    assert ss[0].startsWith(ss[0][0..1])

    assert ss[0].base.count("ab") == 2

    assert ss[0].base.suffix_lowerbound("ab") < ss[0].base.suffix_upperbound("ab")

    '
  dependsOn:
  - cplib/str/static_string.nim
  - cplib/collections/staticRMQ.nim
  - cplib/collections/staticRMQ.nim
  - cplib/str/static_string.nim
  isVerificationFile: true
  path: verify/AI/static_string_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/static_string_test.nim
layout: document
redirect_from:
- /verify/verify/AI/static_string_test.nim
- /verify/verify/AI/static_string_test.nim.html
title: verify/AI/static_string_test.nim
---
