---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/graph/restore_dijkstra_test.nim
    title: verify/graph/restore_dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/restore_dijkstra_test.nim
    title: verify/graph/restore_dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/shortest_path_test.nim
    title: verify/graph/shortest_path_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/shortest_path_test.nim
    title: verify/graph/shortest_path_test.nim
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
    \    import bitops\n    #\u5165\u529B\u7CFB\n    proc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\n    proc getchar(): char {.importc: \"getchar_unlocked\"\
    , header: \"<stdio.h>\", discardable.}\n    proc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n    proc si(): string {.inline.} =\n        result =\
    \ \"\"\n        var c: char\n        while true:\n            c = getchar()\n\
    \            if c == ' ' or c == '\\n':\n                break\n            result\
    \ &= c\n    proc lii(long: int): seq[int] = newSeqWith(long, ii())\n    #chmin,chmax\n\
    \    template `max=`(x, y) = x = max(x, y)\n    template `min=`(x, y) = x = min(x,\
    \ y)\n    #bit\u6F14\u7B97\n    proc `%`(x: int, y: int): int = (((x mod y)+y)\
    \ mod y)\n    proc `//`(x: int, y: int): int = (((x) - (x%y)) div (y))\n    proc\
    \ `%=`(x: var int, y: int): void = x = x%y\n    proc `//=`(x: var int, y: int):\
    \ void = x = x//y\n    proc `**`(x: int, y: int): int = x^y\n    proc `^`(x: int,\
    \ y: int): int = x xor y\n    proc `|`(x: int, y: int): int = x or y\n    proc\
    \ `&`(x: int, y: int): int = x and y\n    proc `>>`(x: int, y: int): int = x shr\
    \ y\n    proc `<<`(x: int, y: int): int = x shl y\n    proc `^=`(x: var int, y:\
    \ int): void = x = x ^ y\n    proc `&=`(x: var int, y: int): void = x = x & y\n\
    \    proc `|=`(x: var int, y: int): void = x = x | y\n    proc `>>=`(x: var int,\
    \ y: int): void = x = x >> y\n    proc `<<=`(x: var int, y: int): void = x = x\
    \ << y\n    proc `[]`(x: int, n: int): bool = (x and (1 shl n)) != 0\n    proc\
    \ `@`(x: int): seq[int] =\n        for i in 0..<64:\n            if x[i]:\n  \
    \              result.add(i)\n    #\u4FBF\u5229\u306A\u5909\u63DB\n    proc `!`(x:\
    \ char, a = '0'): int = int(x)-int(a)\n    #\u5B9A\u6570\n    const INF = int(3300300300300300491)\n\
    \    #converter\n\n    #range\n    iterator range(start: int, ends: int, step:\
    \ int): int =\n        var i = start\n        if step < 0:\n            while\
    \ i > ends:\n                yield i\n                i += step\n        elif\
    \ step > 0:\n            while i < ends:\n                yield i\n          \
    \      i += step\n    iterator range(ends: int): int = (for i in 0..<ends: yield\
    \ i)\n    iterator range(start: int, ends: int): int = (for i in\n           \
    \ start..<ends: yield i)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/tmpl/sheep.nim
  requiredBy: []
  timestamp: '2023-11-09 20:55:35+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/shortest_path_test.nim
  - verify/graph/shortest_path_test.nim
  - verify/graph/restore_dijkstra_test.nim
  - verify/graph/restore_dijkstra_test.nim
  - verify/math/isprime_yosupo_test.nim
  - verify/math/isprime_yosupo_test.nim
  - verify/math/isprime_yukicoder_test.nim
  - verify/math/isprime_yukicoder_test.nim
documentation_of: cplib/tmpl/sheep.nim
layout: document
redirect_from:
- /library/cplib/tmpl/sheep.nim
- /library/cplib/tmpl/sheep.nim.html
title: cplib/tmpl/sheep.nim
---
