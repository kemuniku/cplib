---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/sqrt_heuristic_for_floor_sum_test.nim
    title: verify/AI/sqrt_heuristic_for_floor_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/sqrt_heuristic_for_floor_sum_test.nim
    title: verify/AI/sqrt_heuristic_for_floor_sum_test.nim
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
  code: "when not declared CPLIB_MATH_SQRT_FLOOR:\n    const CPLIB_MATH_SQRT_FLOOR*\
    \ = 1\n    import math\n    proc sqrt_heuristic_for_floor_sum*(A,B,N,M:int):seq[tuple[x:int,y:int,dx:int,dy:int,n:int]]=\n\
    \        ## Ak + B mod M (0 <= k < N) \u3092O(\u221AN)\u500B\u306E\u7B49\u5DEE\
    \u6570\u5217\u306B\u5206\u89E3\u3059\u308B\n        var A = A mod M\n        var\
    \ B = B mod M\n        var D = int(sqrt(float(N)))\n\n        var bidx = -1\n\
    \        var bval = M\n        for i in 1..D:\n            # min(A*i mod M , -A\
    \ * i mod M)\u304C\u6700\u5C0F\u3068\u306A\u308B\u3088\u3046\u306Ai\u3092\u63A2\
    \u3059\u3002\n            # \u305D\u306E\u3088\u3046\u306A\u5024\u306FM/D\u4EE5\
    \u4E0B\u306B\u306A\u308B\u3002\n            var val = A*i mod M\n            val\
    \ = min(val,M-val)\n            if bval > val:\n                bval = val\n \
    \               bidx = i\n        \n        if (bidx * A mod M) > M - (bidx *\
    \ A mod M):\n            # -A,M-1-B\u306B\u5E30\u7740\n            for (x,y,dx,dy,n)\
    \ in sqrt_heuristic_for_floor_sum((M-A) mod M,M-1-B,N,M):\n                result.add((x,M-1-y,dx,-dy,n))\n\
    \            return result\n        \n        # \u5143\u306E\u6570\u5217\u3092\
    \ k mod bidx\u3067\u5206\u3051\u3066bidx\u500B\u306E\u30B0\u30EB\u30FC\u30D7\u306B\
    \u5206\u3051\u308B\n        # \u5404\u30B0\u30EB\u30FC\u30D7\u3092\u898B\u308B\
    \u3068\u3001delta\u304CA*i\u306B\u306A\u3063\u3066\u3044\u308B(\u3064\u307E\u308A\
    \u3001delta\u304CM/D\u4EE5\u4E0B\u3068\u306A\u308B\u3002)\n\n        for g in\
    \ 0..<bidx:\n            var a = A * bidx mod M\n            var b = (A * g +\
    \ B) mod M\n            var n = (N - g + bidx - 1) div bidx\n            var x\
    \ = ((a * (n-1) + b) div M) + 1\n            var l = 0\n            for k in 0..<x:\n\
    \                var r : int\n                if k+1 == x:\n                 \
    \   r = n\n                else:\n                    r = (M * (k+1) - b + a -\
    \ 1) div a\n                result.add((bidx * l + g, (a * l + b) mod M,bidx,(bidx\
    \ * A mod M),r-l))\n                l = r\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/math/sqrt_heuristic_for_floor_sum.nim
  requiredBy: []
  timestamp: '2026-04-05 16:18:20+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/sqrt_heuristic_for_floor_sum_test.nim
  - verify/AI/sqrt_heuristic_for_floor_sum_test.nim
documentation_of: cplib/math/sqrt_heuristic_for_floor_sum.nim
layout: document
redirect_from:
- /library/cplib/math/sqrt_heuristic_for_floor_sum.nim
- /library/cplib/math/sqrt_heuristic_for_floor_sum.nim.html
title: cplib/math/sqrt_heuristic_for_floor_sum.nim
---
