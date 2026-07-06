---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/hash_string.nim
    title: cplib/str/hash_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/hash_string.nim
    title: cplib/str/hash_string.nim
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


    import cplib/str/hash_string


    let a = "ab".tohash

    let b = ''c''.tohash

    let abc = "abc".tohash

    assert len(a) == 2

    assert a & b == abc

    assert get_emptystring_hash() & abc == abc

    assert "xy".tohash * 3 == "xyxyxy".tohash

    assert "abc".tohash.removePrefix("ab".tohash) == "c".tohash

    assert 65.tohash == ''A''.tohash


    let rh = initRollingHash("banana")

    assert $rh[1..3] == "ana"

    assert rh[1..3] == rh[3..5]

    assert rh[0] == ''b''

    assert rh[1..5].LCP(rh[3..5]) == 3

    assert cmp(rh[1..3], rh[1..3]) == 0

    assert rh[1..3] < rh[0..2]

    let hs: HashString = rh[1..3]

    assert hs == "ana".tohash

    '
  dependsOn:
  - cplib/str/hash_string.nim
  - cplib/str/hash_string.nim
  isVerificationFile: true
  path: verify/AI/hash_string_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/hash_string_test.nim
layout: document
redirect_from:
- /verify/verify/AI/hash_string_test.nim
- /verify/verify/AI/hash_string_test.nim.html
title: verify/AI/hash_string_test.nim
---
