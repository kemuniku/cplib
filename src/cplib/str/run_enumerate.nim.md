---
data:
  _extendedDependsOn: []
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
    \ = 1\n    import algorithm\n    import sequtils\n\n    proc run_zalgorithm[T](s:\
    \ openArray[T], prefixLen, count: int, z: var seq[int]) =\n        ## \u5148\u982D\
    prefixLen\u8981\u7D20\u3068\u306ELCP\u3092\u3001\u5FC5\u8981\u306Acount\u8981\u7D20\
    \u5206\u3060\u3051\u8A08\u7B97\u3059\u308B\u3002\n        z.setLen(count)\n  \
    \      z[0] = prefixLen\n        var i = 1\n        var j = 0\n        while i\
    \ < count:\n            while j < prefixLen and i + j < s.len and s[j] == s[i\
    \ + j]:\n                inc j\n            z[i] = j\n            if j == 0:\n\
    \                inc i\n                continue\n            var k = 1\n    \
    \        while i + k < count and k + z[k] < j:\n                z[i + k] = z[k]\n\
    \                inc k\n            i += k\n            j -= k\n\n    proc run_cmp(a,\
    \ b: (int, int, int)): int =\n        ## \u4E09\u3064\u7D44\u3092\u8F9E\u66F8\u9806\
    \u3067\u6BD4\u8F03\u3059\u308B\u3002\n        if a[0] != b[0]:\n            return\
    \ cmp(a[0], b[0])\n        if a[1] != b[1]:\n            return cmp(a[1], b[1])\n\
    \        return cmp(a[2], b[2])\n\n    proc run_enumerate_impl[T](a: seq[T]):\
    \ seq[(int, int, int)] =\n        ## \u5206\u5272\u7D71\u6CBB\u3067\u6975\u5927\
    \u306A\u7E70\u308A\u8FD4\u3057\u533A\u9593\u3092\u5217\u6319\u3059\u308B\u3002\
    \n        let n = a.len\n        if n <= 1:\n            return\n        var raw\
    \ = newSeq[(int, int, int)]()\n\n        # \u5B50\u306E\u51E6\u7406\u5F8C\u306B\
    \u4F7F\u3046\u305F\u3081\u3001\u5168\u30CE\u30FC\u30C9\u3067\u4F5C\u696D\u9818\
    \u57DF\u3092\u5171\u6709\u3067\u304D\u308B\u3002\n        var sl = newSeqOfCap[T](n\
    \ + (n + 1) div 2)\n        var zsl = newSeqOfCap[int](n)\n        var zsr = newSeqOfCap[int](n)\n\
    \n        proc add_run(l, r, p: int) =\n            ## \u540C\u4E00\u533A\u9593\
    \u306E\u9023\u7D9A\u5019\u88DC\u306F\u6700\u5C0F\u5468\u671F\u3060\u3051\u3092\
    \u6B8B\u3059\u3002\n            if raw.len > 0 and raw[^1][0] == l and raw[^1][1]\
    \ == r:\n                raw[^1][2] = min(raw[^1][2], p)\n            else:\n\
    \                raw.add((l, r, p))\n\n        proc dfs(l, r: int) =\n       \
    \     ## \u4E2D\u70B9\u3092\u307E\u305F\u3050\u5019\u88DC\u3092\u5DE6\u53F3\u306E\
    LCP\u304B\u3089\u6C42\u3081\u308B\u3002\n            if r - l <= 1:\n        \
    \        return\n            if r - l == 2:\n                if a[l] == a[l +\
    \ 1] and\n                        (l == 0 or a[l - 1] != a[l]) and\n         \
    \               (r == n or a[r] != a[l]):\n                    add_run(l, r, 1)\n\
    \                return\n            let m = (l + r) shr 1\n            dfs(l,\
    \ m)\n            dfs(m, r)\n\n            sl.setLen(0)\n            for i in\
    \ countdown(m - 1, l):\n                sl.add(a[i])\n            for i in countdown(r\
    \ - 1, l):\n                sl.add(a[i])\n\n            # LCP\u306F\u5DE6\u53F3\
    \u306E\u533A\u9593\u9577\u3067\u5207\u308A\u8A70\u3081\u3089\u308C\u3001\u53C2\
    \u7167\u3059\u308B\u6DFB\u5B57\u306Fr-l\u672A\u6E80\u3002\n            run_zalgorithm(sl,\
    \ m - l, r - l, zsl)\n            sl.setLen(0)\n            for i in m..<r:\n\
    \                sl.add(a[i])\n            for i in l..<r:\n                sl.add(a[i])\n\
    \            run_zalgorithm(sl, r - m, r - l, zsr)\n\n            for p in 1..(m\
    \ - l):\n                let\n                    ml = max(l, m - p - zsl[p])\n\
    \                    mr = min(r, m + zsr[r - l - p])\n                if mr -\
    \ ml >= 2 * p and\n                        (ml == 0 or a[ml - 1] != a[ml + p -\
    \ 1]) and\n                        (mr == n or a[mr] != a[mr - p]):\n        \
    \            add_run(ml, mr, p)\n\n            for p in 1..(r - m):\n        \
    \        let\n                    ml = max(l, m - zsl[r - l - p])\n          \
    \          mr = min(r, m + p + zsr[p])\n                if mr - ml >= 2 * p and\n\
    \                        (ml == 0 or a[ml - 1] != a[ml + p - 1]) and\n       \
    \                 (mr == n or a[mr] != a[mr - p]):\n                    add_run(ml,\
    \ mr, p)\n\n        dfs(0, n)\n\n        raw.sort(run_cmp)\n        var prev_l\
    \ = -1\n        var prev_r = -1\n        for (l, r, p) in raw:\n            if\
    \ l == prev_l and r == prev_r:\n                continue\n            result.add((p,\
    \ l, r))\n            prev_l = l\n            prev_r = r\n        result.sort(run_cmp)\n\
    \n    proc run_enumerate*[T](s: openArray[T]): seq[(int, int, int)] =\n      \
    \  ## run\u3092(\u6700\u5C0F\u5468\u671F, l, r)\u306E\u8F9E\u66F8\u9806\u3067\u5217\
    \u6319\u3059\u308B\u3002\u533A\u9593\u306F[l, r)\u3002O(n log^2 n)\u3002\n   \
    \     return run_enumerate_impl(s.toSeq)\n\n    proc run_enumerate*(s: string):\
    \ seq[(int, int, int)] =\n        ## run\u3092(\u6700\u5C0F\u5468\u671F, l, r)\u306E\
    \u8F9E\u66F8\u9806\u3067\u5217\u6319\u3059\u308B\u3002\u533A\u9593\u306F[l, r)\u3002\
    O(n log^2 n)\u3002\n        return run_enumerate_impl(s.toSeq)\n\n    proc RunEnumerate*[T](s:\
    \ openArray[T]): seq[(int, int, int)] =\n        ## run_enumerate\u3068\u540C\u3058\
    \u7D50\u679C\u3092\u8FD4\u3059\u3002\n        return run_enumerate(s)\n\n    proc\
    \ RunEnumerate*(s: string): seq[(int, int, int)] =\n        ## run_enumerate\u3068\
    \u540C\u3058\u7D50\u679C\u3092\u8FD4\u3059\u3002\n        return run_enumerate(s)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/str/run_enumerate.nim
  requiredBy: []
  timestamp: '2026-10-02 14:49:24+00:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/run_enumerate_test.nim
  - verify/AI/run_enumerate_test.nim
  - verify/str/run_enumerate_yosupo_test.nim
  - verify/str/run_enumerate_yosupo_test.nim
documentation_of: cplib/str/run_enumerate.nim
layout: document
redirect_from:
- /library/cplib/str/run_enumerate.nim
- /library/cplib/str/run_enumerate.nim.html
title: cplib/str/run_enumerate.nim
---
