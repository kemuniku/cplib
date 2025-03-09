---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':warning:'
    path: verify/utils/mo_test_.nim
    title: verify/utils/mo_test_.nim
  - icon: ':warning:'
    path: verify/utils/mo_test_.nim
    title: verify/utils/mo_test_.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/range_kth_smallest_test.nim
    title: verify/collections/range_kth_smallest_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/range_kth_smallest_test.nim
    title: verify/collections/range_kth_smallest_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_UTILS_MO:\n    #{.checks: off.}\n    const CPLIB_UTILS_MO*\
    \ = 1\n    import std/math, std/algorithm\n    type Mo* = object\n        width*:\
    \ int\n        N, Q: int\n        qli: seq[seq[int]]\n        size: int\n\n  \
    \  proc initMo*(N, Q: int, width = max(1, int(1.0 * float(N) / max(1.0, sqrt(float(Q)\
    \ * 2.0 / 3.0))))): Mo =\n        result.width = width\n        result.N = N\n\
    \        result.Q = Q\n        let qlisize = N div width + 1\n        result.qli\
    \ = newSeq[seq[int]](qlisize)\n\n    proc insert*(self: var Mo, l, r: int) =\n\
    \        self.qli[l div self.width].add((r shl 40) or ((l) shl 20) or self.size)\n\
    \        self.size += 1\n\n    proc run*[AL, AR, DL, DR, REM](self: var Mo, add_left:\
    \ AL, add_right: AR, delete_left: DL, delete_right: DR, rem: REM) =\n        var\
    \ nl = 0\n        var nr = 0\n        const mask2 = ((1 shl 20)-1) shl 20\n  \
    \      const mask3 = ((1 shl 20)-1)\n        for i in 0..<len(self.qli):\n   \
    \         if len(self.qli[i]) == 0:\n                continue\n            sort(self.qli[i])\n\
    \            if (i and 1) == 1:\n                reverse(self.qli[i])\n      \
    \      for x in self.qli[i]:\n                let ri = x shr 40\n            \
    \    let li = (x and mask2) shr 20\n                let idx = x and mask3\n  \
    \              while nl > li: nl.dec; add_left(nl)\n                while nr <\
    \ ri: add_right(nr); nr.inc\n                while nl < li: delete_left(nl); nl.inc\n\
    \                while nr > ri: nr.dec; delete_right(nr)\n                rem(idx)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/mo.nim
  requiredBy:
  - verify/utils/mo_test_.nim
  - verify/utils/mo_test_.nim
  timestamp: '2024-03-16 18:25:22+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/range_kth_smallest_test.nim
  - verify/collections/range_kth_smallest_test.nim
documentation_of: cplib/utils/mo.nim
layout: document
redirect_from:
- /library/cplib/utils/mo.nim
- /library/cplib/utils/mo.nim.html
title: cplib/utils/mo.nim
---
