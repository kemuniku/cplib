---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/combination.nim
    title: cplib/math/combination.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/combination.nim
    title: cplib/math/combination.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\nimport atcoder/modint\nimport cplib/math/combination\n\n\
    proc naive_npr(n, r, m: int): int =\n    result = 1\n    for i in n-r+1..n:\n\
    \        result *= i\n        result = result mod m\n\nproc check_npr[ModInt]()\
    \ =\n    var c = initCombination[ModInt](20)\n    for n in 0..20:\n        for\
    \ r in 0..n:\n            doAssert naive_npr(n, r, int(ModInt.umod())) == c.npr(n,\
    \ r).val\n\ncheck_npr[modint998244353]()\ncheck_npr[modint1000000007]()\ntype\
    \ modint104717 = modint\nmodint104717.setMod(104717)\ncheck_npr[modint104717]()\n"
  dependsOn:
  - cplib/math/combination.nim
  - cplib/math/combination.nim
  isVerificationFile: true
  path: verify/math/combination_npr_test.nim
  requiredBy: []
  timestamp: '2024-06-14 11:21:14+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/combination_npr_test.nim
layout: document
redirect_from:
- /verify/verify/math/combination_npr_test.nim
- /verify/verify/math/combination_npr_test.nim.html
title: verify/math/combination_npr_test.nim
---
