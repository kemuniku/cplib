---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/can_reverse_hash_string.nim
    title: cplib/str/can_reverse_hash_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/can_reverse_hash_string.nim
    title: cplib/str/can_reverse_hash_string.nim
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


    import cplib/str/can_reverse_hash_string


    let aba = "aba".tohash

    let ab = "ab".tohash

    assert aba.isPalindrome

    assert not ab.isPalindrome

    assert ab.reversed == "ba".tohash

    assert "ab".tohash & "c".tohash == "abc".tohash

    assert "ab".tohash * 3 == "ababab".tohash

    assert get_emptystring_hash() & aba == aba

    assert 65.tohash == ''A''.tohash


    let rh = initRollingHash("abacaba")

    assert $rh[0..2] == "aba"

    assert rh[0..2].isPalindrome

    assert rh[0..2].reversed == rh[0..2]

    assert rh[0..2] == rh[4..6]

    assert rh[0] == ''a''

    assert rh[0..6].LCP(rh[4..6]) == 3

    assert cmp(rh[0..2], rh[1..3]) < 0

    let hs: HashString = rh[0..2]

    assert hs == aba

    '
  dependsOn:
  - cplib/str/can_reverse_hash_string.nim
  - cplib/str/can_reverse_hash_string.nim
  isVerificationFile: true
  path: verify/AI/can_reverse_hash_string_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/can_reverse_hash_string_test.nim
layout: document
redirect_from:
- /verify/verify/AI/can_reverse_hash_string_test.nim
- /verify/verify/AI/can_reverse_hash_string_test.nim.html
title: verify/AI/can_reverse_hash_string_test.nim
---
