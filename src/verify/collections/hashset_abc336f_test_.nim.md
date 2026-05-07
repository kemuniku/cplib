---
data:
  _extendedDependsOn:
  - icon: ':warning:'
    path: cplib/collections/hashset.nim
    title: cplib/collections/hashset.nim
  - icon: ':warning:'
    path: cplib/collections/hashset.nim
    title: cplib/collections/hashset.nim
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
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc336/tasks/abc336_f
    links:
    - https://atcoder.jp/contests/abc336/tasks/abc336_f
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc336/tasks/abc336_f\n\
    import cplib/collections/hashset\nimport cplib/matrix/matops\nimport sequtils,\
    \ strutils, hashes, sugar, deques\n\nvar h, w: int\n(h, w) = stdin.readLine.split.map(parseInt)\n\
    var s = newSeq[seq[int]](h)\nfor i in 0..<h: s[i] = stdin.readLine.split.map(parseInt)\n\
    var t = collect(newSeq): (for i in 0..<h: (i*w+1..i*w+w).toseq)\nproc bfs(s: seq[seq[int]]):\
    \ seq[seq[Hash]] =\n    result = newSeqWith(11, newSeq[Hash](0))\n    result[0].add(hash(s))\n\
    \    var q = @[(0, s)].toDeque\n    var seen = @[hash(s)].toHashSet\n    while\
    \ q.len > 0:\n        var (d, s) = q.popFirst\n        for sx in 0..1:\n     \
    \       for sy in 0..1:\n                var si = s[sx..<sx+h-1].mapIt(it[sy..<sy+w-1]).rotated(2)\n\
    \                var sn = s\n                for i in 0..<h-1:\n             \
    \       for j in 0..<w-1:\n                        sn[sx+i][sy+j] = si[i][j]\n\
    \                var sh = hash(sn)\n                if sh notin seen:\n      \
    \              seen.incl(sh)\n                    result[d+1].add(sh)\n      \
    \              if d+1 != 10:\n                        q.addLast((d+1, sn))\n \
    \   return result\nvar tb1 = bfs(s)\nvar tb2 = bfs(t).mapIt(it.toHashSet)\nvar\
    \ ans = 30\nfor k, v in tb1:\n    for si in v:\n        for i in 0..10:\n    \
    \        if si in tb2[i]:\n                ans = min(ans, i + k)\n           \
    \     break\necho if ans == 30: -1 else: ans\n"
  dependsOn:
  - cplib/matrix/matops.nim
  - cplib/collections/hashset.nim
  - cplib/matrix/matops.nim
  - cplib/collections/hashset.nim
  isVerificationFile: false
  path: verify/collections/hashset_abc336f_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:22:34+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/collections/hashset_abc336f_test_.nim
layout: document
redirect_from:
- /library/verify/collections/hashset_abc336f_test_.nim
- /library/verify/collections/hashset_abc336f_test_.nim.html
title: verify/collections/hashset_abc336f_test_.nim
---
