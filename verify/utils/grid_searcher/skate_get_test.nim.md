---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avlset.nim
    title: cplib/collections/avlset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avlset.nim
    title: cplib/collections/avlset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode.nim
    title: cplib/collections/avltreenode.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/avltreenode.nim
    title: cplib/collections/avltreenode.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/grid_searcher.nim
    title: cplib/utils/grid_searcher.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/grid_searcher.nim
    title: cplib/utils/grid_searcher.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc241/tasks/abc241_f
    links:
    - https://atcoder.jp/contests/abc241/tasks/abc241_f
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc241/tasks/abc241_f\n\
    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\n\nimport cplib/utils/grid_searcher\n\
    import options,tables,deques\n\nvar H,W,N = ii()\nvar sx,sy = ii()\nvar gx,gy\
    \ = ii()\nvar grid = initGridSearcher()\n\nfor i in 0..<N:\n    var X,Y = ii()\n\
    \    grid.incl(X,Y)\n\nvar alr = initTable[(int,int),int]()\nvar d = initDeque[(int,int)]()\n\
    d.addLast((sx,sy))\nalr[(sx,sy)] = 0\n\nwhile len(d) != 0:\n    var (x,y) = d.popFirst()\n\
    \    for (i,j) in grid.updownleftright_move_get(x,y):\n        if (i,j) notin\
    \ alr:\n            alr[(i,j)] = alr[(x,y)] + 1\n            d.addLast((i,j))\n\
    \nif (gx,gy) in alr:\n    echo alr[(gx,gy)]\nelse:\n    echo -1"
  dependsOn:
  - cplib/collections/avlset.nim
  - cplib/collections/avltreenode.nim
  - cplib/collections/avlset.nim
  - cplib/utils/grid_searcher.nim
  - cplib/collections/avltreenode.nim
  - cplib/utils/grid_searcher.nim
  isVerificationFile: true
  path: verify/utils/grid_searcher/skate_get_test.nim
  requiredBy: []
  timestamp: '2024-09-28 12:21:55+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/grid_searcher/skate_get_test.nim
layout: document
redirect_from:
- /verify/verify/utils/grid_searcher/skate_get_test.nim
- /verify/verify/utils/grid_searcher/skate_get_test.nim.html
title: verify/utils/grid_searcher/skate_get_test.nim
---
