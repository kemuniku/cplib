---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matops.nim
    title: cplib/matrix/matops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matops.nim
    title: cplib/matrix/matops.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc322/tasks/abc322_d
    links:
    - https://atcoder.jp/contests/abc322/tasks/abc322_d
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc322/tasks/abc322_d\n\
    import sequtils\nimport cplib/matrix/matops\n\nproc load(): seq[seq[int]] =\n\
    \    result = newSeqWith(4, stdin.readLine.mapIt(if it == '.': 0 else: 1))\n \
    \   result = result.trimmed(0)\nvar a = newSeqWith(3, load())\nvar s = newSeqWith(4,\
    \ newSeqWith(4, 0))\nproc dfs(d: int, s: seq[seq[int]]): bool =\n    if d == 3:\
    \ return s.mapIt(it.min).min == 1\n    var a = a[d]\n    var h = a.len\n    var\
    \ w = a[0].len\n    for sx in 0..4-h:\n        for sy in 0..4-w:\n           \
    \ var sn = s\n            proc place(): bool =\n                for i in 0..<h:\n\
    \                    for j in 0..<w:\n                        if s[sx+i][sy+j]\
    \ == 1 and a[i][j] == 1: return false\n                        sn[sx+i][sy+j]\
    \ = sn[sx+i][sy+j] or a[i][j]\n                return true\n            if place():\n\
    \                if dfs(d+1, sn): return true\n    return false\nfor i in 0..<4:\n\
    \    for j in 0..<4:\n        for k in 0..<4:\n            if dfs(0, s):\n   \
    \             echo \"Yes\"\n                quit()\n            a[2].rotate(-1)\n\
    \        a[1].rotate(-1)\n    a[0].rotate(-1)\necho \"No\"\n"
  dependsOn:
  - cplib/matrix/matops.nim
  - cplib/matrix/matops.nim
  isVerificationFile: true
  path: verify/matrix/matops_polyomino_test.nim
  requiredBy: []
  timestamp: '2024-01-31 11:34:09+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/matops_polyomino_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/matops_polyomino_test.nim
- /verify/verify/matrix/matops_polyomino_test.nim.html
title: verify/matrix/matops_polyomino_test.nim
---
