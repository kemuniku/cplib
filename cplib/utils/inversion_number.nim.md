---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/utils/inversion_number_test.nim
    title: verify/utils/inversion_number_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/inversion_number_test.nim
    title: verify/utils/inversion_number_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_UTILS_INVERSION_NUMBER:\n    const CPLIB_UTILS_INVERSION_NUMBER*\
    \ = 1\n    import algorithm, sequtils\n    import cplib/collections/segtree\n\
    \    proc inversion_number*(a: seq[int]): int =\n        ## Calculate the inversion\
    \ number of sequence a\n        runnableExamples:\n            var a = @[2, 1,\
    \ 5, 3, 4]\n            assert inversion_number(a) == 3\n        let c = a.sorted.deduplicate(true)\n\
    \        var seg = initSegmentTree(newSeqWith(c.len, 0), proc(l, r: int): int\
    \ = l+r, 0)\n        var ans = 0\n        for i in 0..<a.len:\n            let\
    \ pos = c.lowerbound(a[i])\n            if pos + 1 < c.len:\n                ans\
    \ += seg.get(pos+1..<c.len)\n            seg[pos] = seg[pos] + 1\n        return\
    \ ans\n"
  dependsOn:
  - cplib/collections/segtree.nim
  - cplib/collections/segtree.nim
  isVerificationFile: false
  path: cplib/utils/inversion_number.nim
  requiredBy: []
  timestamp: '2024-09-16 02:10:51+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/inversion_number_test.nim
  - verify/utils/inversion_number_test.nim
documentation_of: cplib/utils/inversion_number.nim
layout: document
redirect_from:
- /library/cplib/utils/inversion_number.nim
- /library/cplib/utils/inversion_number.nim.html
title: cplib/utils/inversion_number.nim
---
