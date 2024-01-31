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
    PROBLEM: https://atcoder.jp/contests/abc307/tasks/abc307_c
    links:
    - https://atcoder.jp/contests/abc307/tasks/abc307_c
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc307/tasks/abc307_c\n\
    import strutils, sequtils\nimport cplib/matrix/matops\nproc load(): (int, int,\
    \ seq[seq[bool]]) =\n    var h, w: int\n    (h, w) = stdin.readLine.split.map(parseInt)\n\
    \    var s = newSeqWith(h, stdin.readLine).mapIt(it.mapIt(if it == '.': false\
    \ else: true))\n    s = s.trimmed(false)\n    return (s.len, s[0].len, s)\nvar\
    \ (ha, wa, a) = load()\nvar (hb, wb, b) = load()\nvar (hx, wx, x) = load()\nfor\
    \ ia in 0..hx-ha:\n    for ja in 0..wx-wa:\n        for ib in 0..hx-hb:\n    \
    \        for jb in 0..wx-wb:\n                var ans = newSeqWith(hx, newSeqWith(wx,\
    \ false))\n                for i in 0..<ha:\n                    for j in 0..<wa:\n\
    \                        ans[ia+i][ja+j] = ans[ia+i][ja+j] or a[i][j]\n      \
    \          for i in 0..<hb:\n                    for j in 0..<wb:\n          \
    \              ans[ib+i][jb+j] = ans[ib+i][jb+j] or b[i][j]\n                if\
    \ ans == x:\n                    echo \"Yes\"\n                    quit()\necho\
    \ \"No\"\n"
  dependsOn:
  - cplib/matrix/matops.nim
  - cplib/matrix/matops.nim
  isVerificationFile: true
  path: verify/matrix/trimmed_seq_abc307c_test.nim
  requiredBy: []
  timestamp: '2024-01-31 11:34:09+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/trimmed_seq_abc307c_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/trimmed_seq_abc307c_test.nim
- /verify/verify/matrix/trimmed_seq_abc307c_test.nim.html
title: verify/matrix/trimmed_seq_abc307c_test.nim
---
