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
    path: cplib/utils/mo.nim
    title: cplib/utils/mo.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/mo.nim
    title: cplib/utils/mo.nim
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
    echo \"Hello World\"\n\nimport cplib/utils/mo\n\nlet a = @[1, 2, 3, 4, 5]\nvar\
    \ solver = initMo(a.len, 3, 2)\nsolver.insert(0, 3)\nsolver.insert(1, 5)\nsolver.insert(2,\
    \ 4)\n\nvar cur = 0\nvar ans = newSeq[int](3)\nsolver.run(\n  proc(i: int) = cur\
    \ += a[i],\n  proc(i: int) = cur += a[i],\n  proc(i: int) = cur -= a[i],\n  proc(i:\
    \ int) = cur -= a[i],\n  proc(idx: int) = ans[idx] = cur\n)\n\nassert ans == @[6,\
    \ 14, 7]\n\nimport cplib/modint/modint\n\nblock:\n  type Mint = modint998244353_barrett\n\
    \  var mo = initMo(5, 3)\n  mo.insert(0, 5)\n  mo.insert(1, 4)\n  mo.insert(2,\
    \ 2)\n  var total = init(Mint, 0)\n  var answers = newSeq[int](3)\n  proc addValue(i:\
    \ int) = total += i + 1\n  proc deleteValue(i: int) = total -= i + 1\n  proc recordAnswer(i:\
    \ int) = answers[i] = total.val\n  mo.run(addValue, addValue, deleteValue, deleteValue,\
    \ remember = recordAnswer)\n  doAssert answers == @[15, 9, 0]\n\nproc checkClosureCallbacks()\
    \ =\n  var mo = initMo(3, 1)\n  mo.insert(1, 3)\n  var total, factories, answer:\
    \ int\n  proc makeCallback(sign: int): proc(i: int) {.closure.} =\n    inc factories\n\
    \    result = proc(i: int) = total += sign * (i + 1)\n  proc recordAnswer(i: int)\
    \ = answer = total\n  mo.run(makeCallback(1), makeCallback(1),\n         makeCallback(-1),\
    \ makeCallback(-1), recordAnswer)\n  doAssert factories == 4\n  doAssert answer\
    \ == 5\n\ncheckClosureCallbacks()\n\nblock:\n  let queries = @[(5, 0), (3, -1),\
    \ (0, 5), (0, -1), (5, 5), (2, 1)]\n  var solver = initMo(5, queries.len, 2)\n\
    \  for (l, r) in queries:\n    solver.insert(l, r)\n  var l = 0\n  var r = 0\n\
    \  var visited = newSeq[int](queries.len)\n  solver.run(\n    proc(i: int) =\n\
    \      doAssert i == l - 1\n      l = i,\n    proc(i: int) =\n      doAssert i\
    \ == r\n      r = i + 1,\n    proc(i: int) =\n      doAssert i == l\n      l =\
    \ i + 1,\n    proc(i: int) =\n      doAssert i == r - 1\n      r = i,\n    proc(idx:\
    \ int) =\n      doAssert (l, r) == queries[idx]\n      inc visited[idx]\n  )\n\
    \  doAssert visited == @[1, 1, 1, 1, 1, 1]\n"
  dependsOn:
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/utils/mo.nim
  - cplib/utils/mo.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  isVerificationFile: true
  path: verify/AI/mo_test.nim
  requiredBy: []
  timestamp: '2026-09-18 01:13:21+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/mo_test.nim
layout: document
redirect_from:
- /verify/verify/AI/mo_test.nim
- /verify/verify/AI/mo_test.nim.html
title: verify/AI/mo_test.nim
---
