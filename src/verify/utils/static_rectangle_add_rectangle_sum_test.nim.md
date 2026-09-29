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
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/static_rectangle_add_rectangle_sum.nim
    title: cplib/utils/static_rectangle_add_rectangle_sum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/static_rectangle_add_rectangle_sum.nim
    title: cplib/utils/static_rectangle_add_rectangle_sum.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/static_rectangle_add_rectangle_sum
    links:
    - https://judge.yosupo.jp/problem/static_rectangle_add_rectangle_sum
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/static_rectangle_add_rectangle_sum\n\
    import cplib/utils/static_rectangle_add_rectangle_sum\nimport cplib/modint/modint\n\
    \ninclude cplib/tmpl/fastio\n\ntype mint = modint998244353_montgomery\nlet n =\
    \ ii()\nlet q = ii()\nvar rectangles = newSeq[(int, int, int, int, mint)](n)\n\
    var queries = newSeq[(int, int, int, int)](q)\nfor rectangle in rectangles.mitems:\n\
    \    let l = ii()\n    let d = ii()\n    let r = ii()\n    let u = ii()\n    let\
    \ w = ii()\n    rectangle = (l, d, r, u, mint.init(w))\nfor query in queries.mitems:\n\
    \    let l = ii()\n    let d = ii()\n    let r = ii()\n    let u = ii()\n    query\
    \ = (l, d, r, u)\nfor answer in static_rectangle_add_rectangle_sum(rectangles,\
    \ queries):\n    print answer.val\n"
  dependsOn:
  - cplib/utils/static_rectangle_add_rectangle_sum.nim
  - cplib/modint/barrett_impl.nim
  - cplib/utils/static_rectangle_add_rectangle_sum.nim
  - cplib/modint/modint.nim
  - cplib/tmpl/fastio.nim
  - cplib/tmpl/fastio.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  isVerificationFile: true
  path: verify/utils/static_rectangle_add_rectangle_sum_test.nim
  requiredBy: []
  timestamp: '2026-09-28 04:13:59+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/static_rectangle_add_rectangle_sum_test.nim
layout: document
redirect_from:
- /verify/verify/utils/static_rectangle_add_rectangle_sum_test.nim
- /verify/verify/utils/static_rectangle_add_rectangle_sum_test.nim.html
title: verify/utils/static_rectangle_add_rectangle_sum_test.nim
---
