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
    path: cplib/matrix/matrix_avx2.nim
    title: cplib/matrix/matrix_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_avx2.nim
    title: cplib/matrix/matrix_avx2.nim
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
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/matrix_product
    links:
    - https://judge.yosupo.jp/problem/matrix_product
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/matrix_product\n\
    include cplib/tmpl/fastio\nimport cplib/modint/modint\nimport cplib/matrix/matrix_avx2\n\
    \nwhen defined(matrixProductBenchmark):\n    import std/monotimes, times\n\ntype\
    \ Mint = modint998244353_barrett\nlet n = input(int)\nlet m = input(int)\nlet\
    \ k = input(int)\nlet a = initMatrix[Mint](n, m, input(n * m, uint32))\nlet b\
    \ = initMatrix[Mint](m, k, input(m * k, uint32))\nwhen defined(matrixProductBenchmark):\n\
    \    let start = getMonoTime()\nlet c = a * b\nwhen defined(matrixProductBenchmark):\n\
    \    stderr.writeLine(\"matrix_product_ms=\", (getMonoTime() - start).inNanoseconds.float\
    \ / 1e6)\nfor i in 0 ..< n:\n    c[i].writeRow()\n"
  dependsOn:
  - cplib/matrix/matrix_avx2.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/tmpl/fastio.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/matrix/matrix_avx2.nim
  - cplib/modint/modint.nim
  - cplib/tmpl/fastio.nim
  - cplib/modint/barrett_impl.nim
  isVerificationFile: true
  path: verify/matrix/matrix_avx2_test.nim
  requiredBy: []
  timestamp: '2026-09-08 11:14:25+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/matrix_avx2_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/matrix_avx2_test.nim
- /verify/verify/matrix/matrix_avx2_test.nim.html
title: verify/matrix/matrix_avx2_test.nim
---
