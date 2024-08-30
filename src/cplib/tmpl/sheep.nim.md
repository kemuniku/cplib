---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/restore_dijkstra_test.nim
    title: verify/graph/dynamic/restore_dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/restore_dijkstra_test.nim
    title: verify/graph/dynamic/restore_dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/shortest_path_test.nim
    title: verify/graph/dynamic/shortest_path_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/shortest_path_test.nim
    title: verify/graph/dynamic/shortest_path_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/restore_dijkstra_static_test.nim
    title: verify/graph/static/restore_dijkstra_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/restore_dijkstra_static_test.nim
    title: verify/graph/static/restore_dijkstra_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/shortest_path_static_test.nim
    title: verify/graph/static/shortest_path_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/shortest_path_static_test.nim
    title: verify/graph/static/shortest_path_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/isprime_yosupo_test.nim
    title: verify/math/isprime_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/isprime_yosupo_test.nim
    title: verify/math/isprime_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/isprime_yukicoder_test.nim
    title: verify/math/isprime_yukicoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/isprime_yukicoder_test.nim
    title: verify/math/isprime_yukicoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/hash_string/hash_string_mul_test.nim
    title: verify/str/hash_string/hash_string_mul_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/hash_string/hash_string_mul_test.nim
    title: verify/str/hash_string/hash_string_mul_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_TMPL_SHEEP:\n    const CPLIB_TMPL_SHEEP* = 1\n  \
    \  {.warning[UnusedImport]: off.}\n    {.hint[XDeclaredButNotUsed]: off.}\n  \
    \  import algorithm\n    import sequtils\n    import tables\n    import macros\n\
    \    import math\n    import sets\n    import strutils\n    import strformat\n\
    \    import sugar\n    import heapqueue\n    import streams\n    import deques\n\
    \    import bitops\n    import std/lenientops\n    import options\n    #\u5165\
    \u529B\u7CFB\n    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\n\
    \    proc getchar(): char {.importc: \"getchar_unlocked\", header: \"<stdio.h>\"\
    , discardable.}\n    proc ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\n\
    \    proc lii(N: int): seq[int] {.inline.} = newSeqWith(N, ii())\n    proc si():\
    \ string {.inline.} =\n        result = \"\"\n        var c: char\n        while\
    \ true:\n            c = getchar()\n            if c == ' ' or c == '\\n':\n \
    \               break\n            result &= c\n    #chmin,chmax\n    template\
    \ `max=`(x, y) = x = max(x, y)\n    template `min=`(x, y) = x = min(x, y)\n  \
    \  #bit\u6F14\u7B97\n    proc `%`*(x: int, y: int): int =\n        result = x\
    \ mod y\n        if y > 0 and result < 0: result += y\n        if y < 0 and result\
    \ > 0: result += y\n    proc `//`*(x: int, y: int): int{.inline.} =\n        result\
    \ = x div y\n        if y > 0 and result * y > x: result -= 1\n        if y <\
    \ 0 and result * y < x: result -= 1\n    proc `%=`(x: var int, y: int): void =\
    \ x = x%y\n    proc `//=`(x: var int, y: int): void = x = x//y\n    proc `**`(x:\
    \ int, y: int): int = x^y\n    proc `**=`(x: var int, y: int): void = x = x^y\n\
    \    proc `^`(x: int, y: int): int = x xor y\n    proc `|`(x: int, y: int): int\
    \ = x or y\n    proc `&`(x: int, y: int): int = x and y\n    proc `>>`(x: int,\
    \ y: int): int = x shr y\n    proc `<<`(x: int, y: int): int = x shl y\n    proc\
    \ `~`(x: int): int = not x\n    proc `^=`(x: var int, y: int): void = x = x ^\
    \ y\n    proc `&=`(x: var int, y: int): void = x = x & y\n    proc `|=`(x: var\
    \ int, y: int): void = x = x | y\n    proc `>>=`(x: var int, y: int): void = x\
    \ = x >> y\n    proc `<<=`(x: var int, y: int): void = x = x << y\n    proc `[]`(x:\
    \ int, n: int): bool = (x and (1 shl n)) != 0\n    #\u4FBF\u5229\u306A\u5909\u63DB\
    \n    proc `!`(x: char, a = '0'): int = int(x)-int(a)\n    #\u5B9A\u6570\n   \
    \ include cplib/utils/constants\n    const INF = INF64\n    #converter\n\n   \
    \ #range\n    iterator range(start: int, ends: int, step: int): int =\n      \
    \  var i = start\n        if step < 0:\n            while i > ends:\n        \
    \        yield i\n                i += step\n        elif step > 0:\n        \
    \    while i < ends:\n                yield i\n                i += step\n   \
    \ iterator range(ends: int): int = (for i in 0..<ends: yield i)\n    iterator\
    \ range(start: int, ends: int): int = (for i in\n            start..<ends: yield\
    \ i)\n\n    #join\u304C\u975Estring\u3067\u3081\u3061\u3083\u304F\u3061\u3083\u9045\
    \u3044\u3084\u3064\u306E\u30D1\u30C3\u30C1\n    proc join*[T: not string](a: openArray[T],\
    \ sep: string = \"\"): string = a.mapit($it).join(sep)\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  isVerificationFile: false
  path: cplib/tmpl/sheep.nim
  requiredBy: []
  timestamp: '2024-06-25 04:52:11+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/static/restore_dijkstra_static_test.nim
  - verify/graph/static/restore_dijkstra_static_test.nim
  - verify/graph/static/shortest_path_static_test.nim
  - verify/graph/static/shortest_path_static_test.nim
  - verify/graph/dynamic/shortest_path_test.nim
  - verify/graph/dynamic/shortest_path_test.nim
  - verify/graph/dynamic/restore_dijkstra_test.nim
  - verify/graph/dynamic/restore_dijkstra_test.nim
  - verify/math/isprime_yukicoder_test.nim
  - verify/math/isprime_yukicoder_test.nim
  - verify/math/isprime_yosupo_test.nim
  - verify/math/isprime_yosupo_test.nim
  - verify/str/hash_string/hash_string_mul_test.nim
  - verify/str/hash_string/hash_string_mul_test.nim
documentation_of: cplib/tmpl/sheep.nim
layout: document
redirect_from:
- /library/cplib/tmpl/sheep.nim
- /library/cplib/tmpl/sheep.nim.html
title: cplib/tmpl/sheep.nim
---
