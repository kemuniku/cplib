---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATH_FLOAT128:\n    const CPLIB_MATH_FLOAT128* =\
    \ 1\n\n    type float128* {.importcpp: \"__float128\", nodecl.} = object\n   \
    \ converter to_float128*(x: SomeInteger):float128  {.importcpp: \"(__float128)((#))\"\
    , nodecl.}\n    converter to_float128*(x: SomeFloat):float128  {.importcpp: \"\
    (__float128)((#))\", nodecl.}\n    proc to_float*(x:float128):float {.importcpp:\
    \ \"(double)((#))\", nodecl.}\n    proc `-`*(x: float128): float128 {.importcpp:\
    \ \"-((#))\", nodecl.}\n    proc `+=`*(x: var float128, y: float128) {.importcpp:\
    \ \"((#) += (#))\", nodecl.}\n    proc `-=`*(x: var float128, y: float128) {.importcpp:\
    \ \"((#) -= (#))\", nodecl.}\n    proc `*=`*(x: var float128, y: float128) {.importcpp:\
    \ \"((#) *= (#))\", nodecl.}\n    proc `/=`*(x: var float128, y: float128) {.importcpp:\
    \ \"((#) /= (#))\", nodecl.}\n    proc `mod=`*(x: var float128, y: float128) {.importcpp:\
    \ \"((#) %= (#))\", nodecl.}\n    proc `&=`*(x: var float128, y: float128) {.importcpp:\
    \ \"((#) &= (#))\", nodecl.}\n    proc `|=`*(x: var float128, y: float128) {.importcpp:\
    \ \"((#) |= (#))\", nodecl.}\n    proc `^=`*(x: var float128, y: float128) {.importcpp:\
    \ \"((#) ^= (#))\", nodecl.}\n    proc `<<=`*(x: var float128, y: float128) {.importcpp:\
    \ \"((#) <<= (#))\", nodecl.}\n    proc `>>=`*(x: var float128, y: float128) {.importcpp:\
    \ \"((#) >>= (#))\", nodecl.}\n\n    proc `+`*(x, y: float128): float128 = (result\
    \ = x; result += y)\n    proc `-`*(x, y: float128): float128 = (result = x; result\
    \ -= y)\n    proc `*`*(x, y: float128): float128 = (result = x; result *= y)\n\
    \    proc `/`*(x, y: float128): float128 = (result = x; result /= y)\n    proc\
    \ `mod`*(x, y: float128): float128 = (result = x; result.mod= y)\n    proc `&`*(x,\
    \ y: float128): float128 = (result = x; result &= y)\n    proc `|`*(x, y: float128):\
    \ float128 = (result = x; result |= y)\n    proc `^`*(x, y: float128): float128\
    \ = (result = x; result ^= y)\n    proc `<<`*(x, y: float128): float128 = (result\
    \ = x; result <<= y)\n    proc `>>`*(x, y: float128): float128 = (result = x;\
    \ result >>= y)\n\n    proc `>`*(x, y: float128): bool {.importcpp: \"((#) > (#))\"\
    , nodecl.}\n    proc `>=`*(x, y: float128): bool {.importcpp: \"((#) >= (#))\"\
    , nodecl.}\n    proc `<`*(x, y: float128): bool {.importcpp: \"((#) < (#))\",\
    \ nodecl.}\n    proc `<=`*(x, y: float128): bool {.importcpp: \"((#) <= (#))\"\
    , nodecl.}\n    proc `==`*(x, y: float128): bool {.importcpp: \"((#) == (#))\"\
    , nodecl.}\n    proc abs*(x: float128): float128 = (if x >= 0:x else: -x)\n  \
    \  proc cmp*(x, y: float128): int = (if x < y: -1 elif x == y: 0 else: 1)"
  dependsOn: []
  isVerificationFile: false
  path: cplib/math/float128.nim
  requiredBy: []
  timestamp: '2025-02-07 19:42:28+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/math/float128.nim
layout: document
redirect_from:
- /library/cplib/math/float128.nim
- /library/cplib/math/float128.nim.html
title: cplib/math/float128.nim
---
