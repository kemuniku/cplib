---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/zalgorithm.nim
    title: cplib/str/zalgorithm.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/zalgorithm.nim
    title: cplib/str/zalgorithm.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/run_enumerate_test.nim
    title: verify/AI/run_enumerate_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/run_enumerate_test.nim
    title: verify/AI/run_enumerate_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/run_enumerate_yosupo_test.nim
    title: verify/str/run_enumerate_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/run_enumerate_yosupo_test.nim
    title: verify/str/run_enumerate_yosupo_test.nim
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
  code: "when not declared CPLIB_STR_RUN_ENUMERATE:\n    const CPLIB_STR_RUN_ENUMERATE*\
    \ = 1\n    import std/algorithm\n    import std/sequtils\n    import cplib/str/zalgorithm\n\
    \n    proc run_cmp(a, b: (int, int, int)): int =\n        if a[0] != b[0]:\n \
    \           return cmp(a[0], b[0])\n        if a[1] != b[1]:\n            return\
    \ cmp(a[1], b[1])\n        return cmp(a[2], b[2])\n\n    proc run_enumerate_impl[T](a:\
    \ seq[T]): seq[(int, int, int)] =\n        let n = a.len\n        var raw = newSeq[(int,\
    \ int, int)]()\n\n        proc dfs(l, r: int) =\n            if r - l <= 1:\n\
    \                return\n            let m = (l + r) shr 1\n            dfs(l,\
    \ m)\n            dfs(m, r)\n\n            var sl = newSeq[T]()\n            for\
    \ i in countdown(m - 1, l):\n                sl.add(a[i])\n            for i in\
    \ countdown(r - 1, l):\n                sl.add(a[i])\n\n            var sr = newSeq[T]()\n\
    \            for i in m..<r:\n                sr.add(a[i])\n            for i\
    \ in l..<r:\n                sr.add(a[i])\n\n            let zsl = zalgorithm(sl)\n\
    \            let zsr = zalgorithm(sr)\n\n            for p in 1..(m - l):\n  \
    \              let\n                    ml = max(l, m - p - zsl[p])\n        \
    \            mr = min(r, m + zsr[r - l - p])\n                if mr - ml >= 2\
    \ * p and\n                        (ml == 0 or a[ml - 1] != a[ml + p - 1]) and\n\
    \                        (mr == n or a[mr] != a[mr - p]):\n                  \
    \  raw.add((ml, mr, p))\n\n            for p in 1..(r - m):\n                let\n\
    \                    ml = max(l, m - zsl[r - l - p])\n                    mr =\
    \ min(r, m + p + zsr[p])\n                if mr - ml >= 2 * p and\n          \
    \              (ml == 0 or a[ml - 1] != a[ml + p - 1]) and\n                 \
    \       (mr == n or a[mr] != a[mr - p]):\n                    raw.add((ml, mr,\
    \ p))\n\n        dfs(0, n)\n\n        raw.sort(run_cmp)\n        var prev_l =\
    \ -1\n        var prev_r = -1\n        for (l, r, p) in raw:\n            if l\
    \ == prev_l and r == prev_r:\n                continue\n            result.add((p,\
    \ l, r))\n            prev_l = l\n            prev_r = r\n        result.sort(run_cmp)\n\
    \n    proc run_enumerate*[T](s: openArray[T]): seq[(int, int, int)] =\n      \
    \  ## Enumerates runs as (period, l, r), where the interval is [l, r).\n     \
    \   return run_enumerate_impl(s.toSeq)\n\n    proc run_enumerate*(s: string):\
    \ seq[(int, int, int)] =\n        ## Enumerates runs as (period, l, r), where\
    \ the interval is [l, r).\n        return run_enumerate_impl(s.toSeq)\n\n    proc\
    \ RunEnumerate*[T](s: openArray[T]): seq[(int, int, int)] =\n        return run_enumerate(s)\n\
    \n    proc RunEnumerate*(s: string): seq[(int, int, int)] =\n        return run_enumerate(s)\n"
  dependsOn:
  - cplib/str/zalgorithm.nim
  - cplib/str/zalgorithm.nim
  isVerificationFile: false
  path: cplib/str/run_enumerate.nim
  requiredBy: []
  timestamp: '2026-07-09 09:03:36+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/str/run_enumerate_yosupo_test.nim
  - verify/str/run_enumerate_yosupo_test.nim
  - verify/AI/run_enumerate_test.nim
  - verify/AI/run_enumerate_test.nim
documentation_of: cplib/str/run_enumerate.nim
layout: document
redirect_from:
- /library/cplib/str/run_enumerate.nim
- /library/cplib/str/run_enumerate.nim.html
title: cplib/str/run_enumerate.nim
---
