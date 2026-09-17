---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/rollback_unionfind.nim
    title: cplib/collections/rollback_unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/rollback_unionfind.nim
    title: cplib/collections/rollback_unionfind.nim
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
    echo \"Hello World\"\n\nimport random, sets\nimport cplib/collections/rollback_unionfind\n\
    \nvar uf = initRollbackUnionFind(5)\nassert uf.count == 5\nassert uf.unite(0,\
    \ 1)\nassert uf.count == 4\nassert not uf.unite(1, 0)\nassert uf.count == 4\n\
    uf.undo()\nassert uf.count == 4\nlet state = uf.get_state\nuf.snapshot()\nassert\
    \ uf.unite(2, 3)\nassert uf.unite(4, 2)\nassert uf.count == 2\nassert not uf.unite(2,\
    \ 2)\nuf.rollback()\nassert uf.count == 4\nassert uf.get_state == state\nuf.rollback(0)\n\
    assert uf.count == 5\nassert uf.get_state == 0\nassert initRollbackUnionFind(0).count\
    \ == 0\n\nvar rng = initRand(3100)\nfor trial in 0..<500:\n    if uf.get_state\
    \ > 0 and rng.rand(0..3) == 0:\n        uf.undo()\n    else:\n        discard\
    \ uf.unite(rng.rand(0..4), rng.rand(0..4))\n    var roots = initHashSet[int]()\n\
    \    for v in 0..<5:\n        roots.incl(uf.root(v))\n    assert uf.count == roots.len\n\
    uf.rollback(0)\nassert uf.count == 5\n"
  dependsOn:
  - cplib/collections/rollback_unionfind.nim
  - cplib/collections/rollback_unionfind.nim
  isVerificationFile: true
  path: verify/collections/rollback_unionfind_count_test.nim
  requiredBy: []
  timestamp: '2026-09-18 01:13:21+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/rollback_unionfind_count_test.nim
layout: document
redirect_from:
- /verify/verify/collections/rollback_unionfind_count_test.nim
- /verify/verify/collections/rollback_unionfind_count_test.nim.html
title: verify/collections/rollback_unionfind_count_test.nim
---
