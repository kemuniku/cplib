---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':question:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
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
    echo \"Hello World\"\n\ninclude cplib/tmpl/fastio\n\nconst compileTimeJoined =\
    \ [1, 2, 3].join(\",\")\nconst compileTimeSignedBounds = [low(int64), high(int64)].join(\"\
    ,\")\nconst compileTimeUnsignedBound = [high(uint64)].join\nstatic:\n    doAssert\
    \ compileTimeJoined == \"1,2,3\"\n    doAssert compileTimeSignedBounds ==\n  \
    \      \"-9223372036854775808,9223372036854775807\"\n    doAssert compileTimeUnsignedBound\
    \ == \"18446744073709551615\"\n\ndoAssert compiles(ii())\ndoAssert compiles(lii(3))\n\
    doAssert compiles(si())\ndoAssert typeof(input(string)) is string\ndoAssert typeof(input(3,\
    \ string)) is seq[string]\ndoAssert not compiles(input(seq[char]))\ntype FastioTestRange\
    \ = range[0 .. 10]\ndoAssert not compiles(input(FastioTestRange))\ndoAssert not\
    \ compiles(input(3, FastioTestRange))\ndoAssert typeof(input(int)) is int\ndoAssert\
    \ typeof(input(int8)) is int8\ndoAssert typeof(input(int16)) is int16\ndoAssert\
    \ typeof(input(int32)) is int32\ndoAssert typeof(input(int64)) is int64\ndoAssert\
    \ typeof(input(uint8)) is uint8\ndoAssert typeof(input(uint16)) is uint16\ndoAssert\
    \ typeof(input(uint32)) is uint32\ndoAssert typeof(input(uint)) is uint\ndoAssert\
    \ typeof(input(uint64)) is uint64\ndoAssert typeof(input(3, int)) is seq[int]\n\
    doAssert typeof(input(3, int8)) is seq[int8]\ndoAssert typeof(input(3, int16))\
    \ is seq[int16]\ndoAssert typeof(input(3, int32)) is seq[int32]\ndoAssert typeof(input(3,\
    \ int64)) is seq[int64]\ndoAssert typeof(input(3, uint8)) is seq[uint8]\ndoAssert\
    \ typeof(input(3, uint16)) is seq[uint16]\ndoAssert typeof(input(3, uint32)) is\
    \ seq[uint32]\ndoAssert typeof(input(3, uint)) is seq[uint]\ndoAssert typeof(input(3,\
    \ uint64)) is seq[uint64]\n\nassert @[low(int), -1, 0, high(int)].join(\",\")\
    \ ==\n    \"-9223372036854775808,-1,0,9223372036854775807\"\nassert @[0u32, high(uint32)].join(\"\
    \ \") == \"0 4294967295\"\nassert @[0u64, high(uint64)].join(\" \") == \"0 18446744073709551615\"\
    \nassert @['a', 'b'].join(\"-\") == \"a-b\"\n\ntype FastioNamedFields = object\n\
    \    umod: int\n    val: uint64\n\nproc `$`(value: FastioNamedFields): string\
    \ =\n    \"custom:\" & system.`$`(value.val)\n\nassert @[FastioNamedFields(umod:\
    \ 1, val: uint64(high(uint32)) + 1)].join ==\n    \"custom:4294967296\"\n\nlet\
    \ values = @[1, -2, 30]\nassert (*values) == \"1 -2 30\"\ndoAssert compiles(print(1,\
    \ 2, 3, sep = \"\\n\"))\ndoAssert compiles(print(*values, sep = \"\\n\"))\n"
  dependsOn:
  - cplib/tmpl/fastio.nim
  - cplib/tmpl/fastio.nim
  isVerificationFile: true
  path: verify/AI/fastio_test.nim
  requiredBy: []
  timestamp: '2026-09-05 05:19:50+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/fastio_test.nim
layout: document
redirect_from:
- /verify/verify/AI/fastio_test.nim
- /verify/verify/AI/fastio_test.nim.html
title: verify/AI/fastio_test.nim
---
