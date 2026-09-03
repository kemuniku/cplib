---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
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
    echo \"Hello World\"\n\nimport cplib/tmpl/sheep\nimport cplib/modint/modint\n\n\
    assert (-3) % 5 == 2\nassert (-3) // 2 == -2\nassert @[1, 2, 3].join(\",\") ==\
    \ \"1,2,3\"\nassert @[low(int), -1, 0, high(int)].join(\",\") ==\n    \"-9223372036854775808,-1,0,9223372036854775807\"\
    \nassert @[0u32, high(uint32)].join(\" \") == \"0 4294967295\"\nassert @['a',\
    \ 'b'].join(\"-\") == \"a-b\"\nlet values = @[1, -2, 30]\nassert (*values) ==\
    \ \"1 -2 30\"\nlet fixedValues = [4, 5, 6]\nassert (*fixedValues) == \"4 5 6\"\
    \nlet words = @[\"foo\", \"bar\"]\nassert (*words) == \"foo bar\"\nlet empty:\
    \ seq[int] = @[]\nassert (*empty) == \"\"\nassert @[low(int32), high(int32)].join(\"\
    \ \") == \"-2147483648 2147483647\"\nassert @[0u64, high(uint64)].join(\" \")\
    \ == \"0 18446744073709551615\"\nlet barrett = @[modint998244353_barrett(1),\n\
    \    modint998244353_barrett(998244352)]\nlet montgomery = @[modint998244353_montgomery(1),\n\
    \    modint998244353_montgomery(998244352)]\nassert (*barrett) == \"1 998244352\"\
    \nassert (*montgomery) == \"1 998244352\"\n\ndoAssert compiles(print(1, 2, 3,\
    \ sep = \"\\n\"))\ndoAssert compiles(print(\"a\", \"b\"))\ndoAssert compiles(print(*values,\
    \ sep = \"\\n\"))\n"
  dependsOn:
  - cplib/modint/barrett_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/utils/constants.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/tmpl/sheep.nim
  - cplib/math/isqrt.nim
  - cplib/tmpl/sheep.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/utils/constants.nim
  - cplib/modint/modint.nim
  isVerificationFile: true
  path: verify/AI/sheep_test.nim
  requiredBy: []
  timestamp: '2026-09-03 22:19:58+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/sheep_test.nim
layout: document
redirect_from:
- /verify/verify/AI/sheep_test.nim
- /verify/verify/AI/sheep_test.nim.html
title: verify/AI/sheep_test.nim
---
