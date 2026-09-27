---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/golden_section_search_test.nim
    title: verify/AI/golden_section_search_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/golden_section_search_test.nim
    title: verify/AI/golden_section_search_test.nim
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
  code: "when not declared CPLIB_UTILS_GOLDEN_SECTION_SEARCH:\n    const CPLIB_UTILS_GOLDEN_SECTION_SEARCH*\
    \ = 1\n\n    proc golden_section_search*[T: SomeFloat](l, r: T, f: proc(x: T):\
    \ T,\n            iterations: int = 100, maximize: bool = false): tuple[x, fx:\
    \ T] =\n        ## \u9589\u533A\u9593 [l, r] \u306E\u5358\u5CF0\u95A2\u6570\u306E\
    \u6700\u9069\u70B9\u3068\u95A2\u6570\u5024\u3092\u3001O(iterations + 1) \u56DE\
    \u306E\u8A55\u4FA1\u3067\u8FD1\u4F3C\u3059\u308B\u3002\n        ## \u6700\u5C0F\
    \u5316\u3067\u306F\u6700\u5C0F\u533A\u9593\u306E\u524D\u5F8C\u3067\u72ED\u7FA9\
    \u6E1B\u5C11\u30FB\u72ED\u7FA9\u5897\u52A0\u3092\u4EEE\u5B9A\u3059\u308B\u3002\
    \u6700\u5927\u5316\u3067\u306F\u9006\u3002\n        ## \u6709\u9650\u306E l <=\
    \ r \u3068\u975E\u8CA0\u306E iterations \u3092\u6307\u5B9A\u3059\u308B\u3002\u7AEF\
    \u70B9\u3082\u5019\u88DC\u306B\u542B\u3080\u3002\n        ## \u521D\u671F\u8A55\
    \u4FA1\u5F8C\u306B\u6700\u5927 iterations \u56DE\u66F4\u65B0\u3057\u3001\u4E38\
    \u3081\u3067\u5206\u5272\u3067\u304D\u306A\u304F\u306A\u308C\u3070\u7D42\u4E86\
    \u3059\u308B\u3002\n        ## f \u306E\u6BD4\u8F03\u7D50\u679C\u306B NaN \u3092\
    \u542B\u3081\u306A\u3044\u3053\u3068\u3002\u53CD\u5FA9\u56DE\u6570\u306F\u8AA4\
    \u5DEE\u3092\u4FDD\u8A3C\u3057\u306A\u3044\u3002\n        assert l <= r, \"\u63A2\
    \u7D22\u533A\u9593\u306B\u306F l <= r \u304C\u5FC5\u8981\u3067\u3059\"\n     \
    \   assert iterations >= 0, \"\u53CD\u5FA9\u56DE\u6570\u306F\u975E\u8CA0\u3067\
    \u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n\n        template better(a,\
    \ b: untyped): bool =\n            (if maximize: b < a else: a < b)\n\n      \
    \  proc interpolate(a, b, t: T): T =\n            ## \u533A\u9593\u304C 0 \u3092\
    \u307E\u305F\u3050\u5834\u5408\u306B\u3082\u5DEE\u306E\u30AA\u30FC\u30D0\u30FC\
    \u30D5\u30ED\u30FC\u3092\u907F\u3051\u3066\u5185\u5206\u3059\u308B\u3002\n   \
    \         if a <= T(0) and T(0) <= b:\n                a * (T(1) - t) + b * t\n\
    \            else:\n                a + (b - a) * t\n\n        let fl = f(l)\n\
    \        result = (l, fl)\n        if l == r: return\n        let fr = f(r)\n\
    \        if better(fr, result.fx): result = (r, fr)\n\n        template evaluate(position:\
    \ T): T =\n            block:\n                let x = position\n            \
    \    let fx = if x == l: fl elif x == r: fr else: f(x)\n                if better(fx,\
    \ result.fx): result = (x, fx)\n                fx\n\n        const ratio = 0.6180339887498948482\n\
    \        var\n            left = l\n            right = r\n            x1 = interpolate(left,\
    \ right, T(1) - T(ratio))\n            x2 = interpolate(left, right, T(ratio))\n\
    \            f1 = evaluate(x1)\n            f2 = f1\n        if x1 != x2: f2 =\
    \ evaluate(x2)\n        for _ in 0..<iterations:\n            if not (left < x1\
    \ and x1 < x2 and x2 < right): break\n            if better(f2, f1):\n       \
    \         left = x1\n                x1 = x2\n                f1 = f2\n      \
    \          let next = interpolate(left, right, T(ratio))\n                if not\
    \ (x1 < next and next < right): break\n                x2 = next\n           \
    \     f2 = evaluate(x2)\n            else:\n                right = x2\n     \
    \           x2 = x1\n                f2 = f1\n                let next = interpolate(left,\
    \ right, T(1) - T(ratio))\n                if not (left < next and next < x2):\
    \ break\n                x1 = next\n                f1 = evaluate(x1)\n\n    proc\
    \ golden_section_search*[V](l, r: int, f: proc(x: int): V,\n            maximize:\
    \ bool = false): tuple[x: int, fx: V] =\n        ## \u9589\u533A\u9593 [l, r]\
    \ \u306E\u5358\u5CF0\u95A2\u6570\u306E\u6700\u9069\u70B9\u3068\u95A2\u6570\u5024\
    \u3092\u3001O(log(r - l + 2)) \u56DE\u306E\u8A55\u4FA1\u3067\u6C42\u3081\u308B\
    \u3002\n        ## \u6574\u6570\u7248\u306F\u30D5\u30A3\u30DC\u30CA\u30C3\u30C1\
    \u63A2\u7D22\u3092\u4F7F\u3044\u3001\u540C\u3058\u70B9\u3092\u518D\u8A55\u4FA1\
    \u3057\u306A\u3044\u3002V \u306B\u306F < \u306E\u307F\u5FC5\u8981\u3002\n    \
    \    ## \u6700\u5C0F\u5316\u3067\u306F\u6700\u5C0F\u533A\u9593\u306E\u524D\u5F8C\
    \u3067\u72ED\u7FA9\u6E1B\u5C11\u30FB\u72ED\u7FA9\u5897\u52A0\u3092\u4EEE\u5B9A\
    \u3059\u308B\u3002\u6700\u5927\u5316\u3067\u306F\u9006\u3002\n        ## l <=\
    \ r \u3068\u3057\u3001\u8907\u6570\u306E\u6700\u9069\u70B9\u304C\u3042\u308B\u5834\
    \u5408\u306F\u305D\u306E\u3046\u3061 1 \u70B9\u3092\u8FD4\u3059\u3002\n      \
    \  assert l <= r, \"\u63A2\u7D22\u533A\u9593\u306B\u306F l <= r \u304C\u5FC5\u8981\
    \u3067\u3059\"\n\n        mixin `<`\n\n        proc position(offset: uint): int\
    \ =\n            ## \u7B26\u53F7\u4ED8\u304D\u6574\u6570\u306E\u5168\u7BC4\u56F2\
    \u3067\u3001\u5DE6\u7AEF\u304B\u3089\u306E\u8DDD\u96E2\u3092\u5EA7\u6A19\u3078\
    \u623B\u3059\u3002\n            cast[int](cast[uint](l) + offset)\n\n        let\
    \ width = cast[uint](r) - cast[uint](l)\n        var\n            a = 1'u\n  \
    \          b = 1'u\n        # \u4EEE\u60F3\u533A\u9593\u306E\u70B9\u6570 a + b\
    \ - 1 \u304C\u5B9F\u533A\u9593\u3092\u8986\u3046\u307E\u3067\u62E1\u5F35\u3059\
    \u308B\u3002\n        while a - 1 < width - (b - 1):\n            (a, b) = (b,\
    \ a + b)\n\n        var\n            offset = 0'u\n            f1 = f(position(a\
    \ - 1))\n            f2: V\n            valid2 = true\n        if a == b: return\
    \ (l, f1)\n        f2 = f(position(b - 1))\n        while a != b:\n          \
    \  let takeRight = valid2 and (if maximize: f1 < f2 else: f2 < f1)\n         \
    \   if not takeRight:\n                (a, b) = (b - a, a)\n                f2\
    \ = f1\n                valid2 = true\n                if a != b: f1 = f(position(offset\
    \ + a - 1))\n            else:\n                offset += a\n                (a,\
    \ b) = (b - a, a)\n                f1 = f2\n                # \u53F3\u7AEF\u3092\
    \u8D8A\u3048\u308B\u4EEE\u60F3\u70B9\u306F\u8A55\u4FA1\u305B\u305A\u3001\u5E38\
    \u306B\u5B9F\u533A\u9593\u306E\u70B9\u3092\u512A\u5148\u3059\u308B\u3002\n   \
    \             valid2 = b - 1 <= width - offset\n                if a != b and\
    \ valid2: f2 = f(position(offset + b - 1))\n        return (position(offset),\
    \ f1)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/golden_section_search.nim
  requiredBy: []
  timestamp: '2026-09-27 01:47:52+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/golden_section_search_test.nim
  - verify/AI/golden_section_search_test.nim
documentation_of: cplib/utils/golden_section_search.nim
layout: document
redirect_from:
- /library/cplib/utils/golden_section_search.nim
- /library/cplib/utils/golden_section_search.nim.html
title: cplib/utils/golden_section_search.nim
---
