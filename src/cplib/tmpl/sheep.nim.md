---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy:
  - icon: ':warning:'
    path: verify/str/merged_static_string.nim
    title: verify/str/merged_static_string.nim
  - icon: ':warning:'
    path: verify/str/merged_static_string.nim
    title: verify/str/merged_static_string.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/sheep_test.nim
    title: verify/AI/sheep_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/sheep_test.nim
    title: verify/AI/sheep_test.nim
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
    path: verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
    title: verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
    title: verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/get_palindromes_test.nim
    title: verify/str/get_palindromes_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/get_palindromes_test.nim
    title: verify/str/get_palindromes_test.nim
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
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_TMPL_SHEEP:\n    const CPLIB_TMPL_SHEEP* = 1\n  \
    \  {.warning[UnusedImport]: off.}\n    {.hint[XDeclaredButNotUsed]: off.}\n  \
    \  import algorithm\n    import sequtils\n    import tables\n    import macros\n\
    \    import math\n    import sets\n    import strutils\n    import strformat\n\
    \    import sugar\n    import heapqueue\n    import streams\n    import deques\n\
    \    import bitops\n    import std/lenientops\n    import options\n    include\
    \ cplib/tmpl/fastio\n    macro getSymbolName(x: typed): string = x.toStrLit\n\
    \    macro debug*(args: varargs[untyped]): untyped =\n        when defined(debug):\n\
    \            result = newNimNode(nnkStmtList, args)\n            template prop(e:\
    \ string = \"\"): untyped = (f: stderr, sepc: \"\", endc: e, flush: true)\n  \
    \          for i, arg in args:\n                if arg.kind == nnkStrLit:\n  \
    \                  result.add(quote do: print(prop(), \"\\\"\", `arg`, \"\\\"\"\
    ))\n                else:\n                    result.add(quote do: print(prop(\"\
    : \"), getSymbolName(`arg`)))\n                    result.add(quote do: print(prop(),\
    \ `arg`))\n                if i != args.len - 1: result.add(quote do: print(prop(),\
    \ \", \"))\n                else: result.add(quote do: print(prop(), \"\\n\"))\n\
    \        else:\n            return (quote do: discard)\n    #chmin,chmax\n   \
    \ template `max=`(x, y) =\n        let yVal = y # y\u304C\u8A08\u7B97\u5F0F\u306E\
    \u5834\u5408\u306B\u8A55\u4FA1\u30921\u56DE\u306B\u3059\u308B\u305F\u3081\n  \
    \      if x < yVal:\n            x = yVal\n\n    template `min=`(x, y) =\n   \
    \     let yVal = y\n        if x > yVal:\n            x = yVal\n    proc chmin[T](x:\
    \ var T, y: T):bool=\n        if x > y:\n            x = y\n            return\
    \ true\n        return false\n    proc chmax[T](x: var T, y: T):bool=\n      \
    \  if x < y:\n            x = y\n            return true\n        return false\n\
    \    #bit\u6F14\u7B97\n    proc `%`*(x: int, y: int): int =\n        result =\
    \ x mod y\n        if y > 0 and result < 0: result += y\n        if y < 0 and\
    \ result > 0: result += y\n    proc `//`*(x: int, y: int): int{.inline.} =\n \
    \       result = x div y\n        if y > 0 and result * y > x: result -= 1\n \
    \       if y < 0 and result * y < x: result -= 1\n    proc `%=`(x: var int, y:\
    \ int): void = x = x%y\n    proc `//=`(x: var int, y: int): void = x = x//y\n\
    \    proc `**`(x: int, y: int): int = x^y\n    proc `**=`(x: var int, y: int):\
    \ void = x = x^y\n    proc `^`(x: int, y: int): int = x xor y\n    proc `|`(x:\
    \ int, y: int): int = x or y\n    proc `&`(x: int, y: int): int = x and y\n  \
    \  proc `>>`(x: int, y: int): int = x shr y\n    proc `<<`(x: int, y: int): int\
    \ = x shl y\n    proc `~`(x: int): int = not x\n    proc `^=`(x: var int, y: int):\
    \ void = x = x ^ y\n    proc `&=`(x: var int, y: int): void = x = x & y\n    proc\
    \ `|=`(x: var int, y: int): void = x = x | y\n    proc `>>=`(x: var int, y: int):\
    \ void = x = x >> y\n    proc `<<=`(x: var int, y: int): void = x = x << y\n \
    \   proc `[]`(x: int, n: int): bool = (x and (1 shl n)) != 0\n    #\u4FBF\u5229\
    \u306A\u5909\u63DB\n    proc `!`(x: char, a = '0'): int = int(x)-int(a)\n    #\u5B9A\
    \u6570\n    include cplib/utils/constants\n    const INF = INF64\n    #converter\n\
    \n    #range\n    iterator range(start: int, ends: int, step: int): int =\n  \
    \      var i = start\n        if step < 0:\n            while i > ends:\n    \
    \            yield i\n                i += step\n        elif step > 0:\n    \
    \        while i < ends:\n                yield i\n                i += step\n\
    \    iterator range(ends: int): int = (for i in 0..<ends: yield i)\n    iterator\
    \ range(start: int, ends: int): int = (for i in\n            start..<ends: yield\
    \ i)\n\n    proc dump[T](arr:seq[seq[T]])=\n        for i in 0..<len(arr):\n \
    \           echo arr[i]\n\n    proc sum(slice:HSlice[int,int]):int=\n        return\
    \ (slice.a+slice.b)*len(slice)//2\n    \n    proc `<`[T](l,r:seq[T]):bool=\n \
    \       for i in 0..<min(len(l),len(r)):\n            if l[i] > r[i]:\n      \
    \          return false\n            elif l[i] < r[i]:\n                return\
    \ true\n        return len(l) < len(r)\n    \n    # Yes/No\n    proc yes*(b: bool\
    \ = true): void = print(if b: \"Yes\" else: \"No\")\n\n    template dblock(body:\
    \ untyped) =\n        when defined(debug):\n            block:\n             \
    \   body\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  - cplib/tmpl/fastio.nim
  - cplib/tmpl/fastio.nim
  isVerificationFile: false
  path: cplib/tmpl/sheep.nim
  requiredBy:
  - verify/str/merged_static_string.nim
  - verify/str/merged_static_string.nim
  timestamp: '2026-09-05 05:19:50+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/isprime_yukicoder_test.nim
  - verify/math/isprime_yukicoder_test.nim
  - verify/math/isprime_yosupo_test.nim
  - verify/math/isprime_yosupo_test.nim
  - verify/str/get_palindromes_test.nim
  - verify/str/get_palindromes_test.nim
  - verify/str/hash_string/hash_string_mul_test.nim
  - verify/str/hash_string/hash_string_mul_test.nim
  - verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
  - verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
  - verify/graph/static/restore_dijkstra_static_test.nim
  - verify/graph/static/restore_dijkstra_static_test.nim
  - verify/graph/static/shortest_path_static_test.nim
  - verify/graph/static/shortest_path_static_test.nim
  - verify/graph/dynamic/restore_dijkstra_test.nim
  - verify/graph/dynamic/restore_dijkstra_test.nim
  - verify/graph/dynamic/shortest_path_test.nim
  - verify/graph/dynamic/shortest_path_test.nim
  - verify/AI/sheep_test.nim
  - verify/AI/sheep_test.nim
documentation_of: cplib/tmpl/sheep.nim
layout: document
redirect_from:
- /library/cplib/tmpl/sheep.nim
- /library/cplib/tmpl/sheep.nim.html
title: cplib/tmpl/sheep.nim
---
