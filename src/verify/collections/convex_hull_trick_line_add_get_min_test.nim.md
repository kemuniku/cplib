---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode.nim
    title: cplib/collections/avltreenode.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode.nim
    title: cplib/collections/avltreenode.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/convex_hull_trick.nim
    title: cplib/collections/convex_hull_trick.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/convex_hull_trick.nim
    title: cplib/collections/convex_hull_trick.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/convex_hull_trick_impl.nim
    title: cplib/collections/private/convex_hull_trick_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/convex_hull_trick_impl.nim
    title: cplib/collections/private/convex_hull_trick_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/line_add_get_min
    links:
    - https://judge.yosupo.jp/problem/line_add_get_min
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/line_add_get_min\n\
    import cplib/collections/convex_hull_trick\n\nproc scanf(formatstr: cstring) {.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int = scanf(\"%lld\", addr result)\n\n\
    let n = ii()\nlet q = ii()\nvar hull = initConvexHullTrick()\nfor i in 0..<n:\n\
    \    let a = ii()\n    let b = ii()\n    hull.add_line(a, b)\nfor i in 0..<q:\n\
    \    let t = ii()\n    if t == 0:\n        let a = ii()\n        let b = ii()\n\
    \        hull.add_line(a, b)\n    else:\n        echo hull.get_min(ii())\n"
  dependsOn:
  - cplib/collections/private/convex_hull_trick_impl.nim
  - cplib/collections/convex_hull_trick.nim
  - cplib/collections/private/convex_hull_trick_impl.nim
  - cplib/collections/convex_hull_trick.nim
  - cplib/math/int128.nim
  - cplib/math/int128.nim
  - cplib/collections/avltreenode.nim
  - cplib/collections/avltreenode.nim
  isVerificationFile: true
  path: verify/collections/convex_hull_trick_line_add_get_min_test.nim
  requiredBy: []
  timestamp: '2026-09-12 10:51:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/convex_hull_trick_line_add_get_min_test.nim
layout: document
redirect_from:
- /verify/verify/collections/convex_hull_trick_line_add_get_min_test.nim
- /verify/verify/collections/convex_hull_trick_line_add_get_min_test.nim.html
title: verify/collections/convex_hull_trick_line_add_get_min_test.nim
---
