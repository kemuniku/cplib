---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':question:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links:
    - https://ei1333.github.io/library/structure/others/slope-trick.hpp
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_SLOPETRICK:\n    const CPLIB_COLLECTIONS_SLOPETRICK*\
    \ = 1\n    import heapqueue\n    import cplib/utils/constants\n\n    # https://ei1333.github.io/library/structure/others/slope-trick.hpp\n\
    \n    type SlopeTrick = ref object\n        L : HeapQueue[int]\n        R : HeapQueue[int]\n\
    \        min_f : int\n        l_add : int\n        r_add : int\n\n    proc pushL(f:SlopeTrick,\
    \ x:int)=\n        f.L.push(-x+f.l_add)\n\n    proc pushR(f:SlopeTrick, x:int)=\n\
    \        f.R.push(x-f.r_add)\n\n    proc L0(f:SlopeTrick):int=\n        return\
    \ -f.L[0]+f.l_add\n\n    proc R0(f:SlopeTrick):int=\n        return f.R[0]+f.r_add\n\
    \n    proc popL(f:SlopeTrick):int=\n        return -f.L.pop()+f.l_add\n\n    proc\
    \ popR(f:SlopeTrick):int=\n        return f.R.pop()+f.r_add\n\n    proc pushpopL(f:SlopeTrick,\
    \ x:int):int=\n        return -f.L.pushpop(-x+f.l_add)+f.l_add\n\n    proc pushpopR(f:SlopeTrick,\
    \ x:int):int=\n        return f.R.pushpop(x-f.r_add)+f.r_add\n\n    proc clearL*(f:SlopeTrick)=\n\
    \        f.L.clear()\n        f.pushL(-INF64)\n\n    proc clearR*(f:SlopeTrick)=\n\
    \        f.R.clear()\n        f.pushR(INF64)\n\n    proc min*(f:SlopeTrick):int=\n\
    \        return f.min_f\n\n    proc add_all*(f:SlopeTrick, a:int)=\n        f.min_f\
    \ += a\n\n    proc add_x_minus_a*(f:SlopeTrick, a:int)=\n        ## f(x)\u306B\
    max(x-a,0)\u3092\u52A0\u7B97\n        ## \uFF3F\uFF0F\n        f.min_f += max(f.L0-a,0)\n\
    \        var x = f.pushpopL(a)\n        f.pushR(x)\n\n\n    proc add_a_minus_x*(f:SlopeTrick,\
    \ a:int)=\n        ## f(x)\u306Bmax(a-x,0)\u3092\u52A0\u7B97\n        ## \uFF3C\
    \uFF3F\n        f.min_f += max(a-f.R0,0)\n        var x = f.pushpopR(a)\n    \
    \    f.pushL(x)\n\n    proc add_abs*(f:SlopeTrick, a:int)=\n        add_x_minus_a(f,a)\n\
    \        add_a_minus_x(f,a)\n\n    proc min_index*(f:SlopeTrick):int=\n      \
    \  return f.L0\n\n    proc shift*(f:SlopeTrick, a:int)=\n        f.l_add += a\n\
    \        f.r_add += a\n\n    proc initSlopeTrick*(a:int):SlopeTrick=\n       \
    \ result = SlopeTrick(L: initHeapQueue[int](), R: initHeapQueue[int](), min_f:\
    \ a, l_add: 0, r_add: 0)\n        result.pushL(-INF64)\n        result.pushR(INF64)\n\
    \n\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  isVerificationFile: false
  path: cplib/collections/slopetrick.nim
  requiredBy: []
  timestamp: '2025-02-07 19:01:28+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/collections/slopetrick.nim
layout: document
redirect_from:
- /library/cplib/collections/slopetrick.nim
- /library/cplib/collections/slopetrick.nim.html
title: cplib/collections/slopetrick.nim
---
