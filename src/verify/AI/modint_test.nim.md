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
    echo \"Hello World\"\n\nimport cplib/modint/modint\n\ntype MintM = modint998244353_montgomery\n\
    var a = init(MintM, 10)\nvar b = init(MintM, 3)\nassert (a + b).val == 13\nassert\
    \ (a - b).val == 7\nassert (a * b).val == 30\nassert (a / b * b).val == 10\nassert\
    \ (a + 998244353).val == 10\nassert (2 + b).val == 5\nassert (20 - b).val == 17\n\
    assert (4 * b).val == 12\nassert (MintM.init(2).pow(10)).val == 1024\nassert $MintM.init(-1)\
    \ == \"998244352\"\nassert (MintM.init(2) / 2).val == 1\nassert MintM.init(3).estimate_rational()\
    \ == \"3/1\"\nvar rejectedEmptySearch = false\ntry:\n    discard MintM.init(3).estimate_rational(0)\n\
    except AssertionDefect:\n    rejectedEmptySearch = true\nassert rejectedEmptySearch\n\
    \ntype MintB = modint1000000007_barrett\nassert (MintB.init(1_000_000_008) + MintB.init(2)).val\
    \ == 3\nassert (MintB.init(2).pow(5)).val == 32\n\ntype DynM = modint_montgomery\n\
    DynM.setMod(101)\nassert (DynM.init(100) + 2).val == 1\nassert (DynM.init(3) *\
    \ 4).val == 12\n\ntype DynB = modint_barrett\nDynB.setMod(97)\nassert (DynB.init(-1)\
    \ + 2).val == 1\nassert (DynB.init(5) / 5).val == 1\n"
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/barrett_impl.nim
  isVerificationFile: true
  path: verify/AI/modint_test.nim
  requiredBy: []
  timestamp: '2026-09-04 10:21:15+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/modint_test.nim
layout: document
redirect_from:
- /verify/verify/AI/modint_test.nim
- /verify/verify/AI/modint_test.nim.html
title: verify/AI/modint_test.nim
---
