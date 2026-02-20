---
data:
  _extendedDependsOn:
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
    \    import bitops\n    import std/lenientops\n    import options\n    #\u5165\
    \u529B\u7CFB\n    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\n\
    \    proc getchar(): char {.importc: \"getchar_unlocked\", header: \"<stdio.h>\"\
    , discardable.}\n    proc ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\n\
    \    proc lii(N: int): seq[int] {.inline.} = newSeqWith(N, ii())\n    proc si():\
    \ string {.inline.} =\n        result = \"\"\n        var c: char\n        while\
    \ true:\n            c = getchar()\n            if c == ' ' or c == '\\n' or c\
    \ == '\\255':\n                break\n            result &= c\n    \n    # \u51FA\
    \u529B\u7CFB\n    # 1. \u5B9F\u969B\u306E\u51E6\u7406\u3092\u884C\u3046 proc (openArray\
    \ \u3092\u53D7\u3051\u53D6\u308B)\n    proc print_internal(prop: tuple[f: File,\
    \ sepc: string, endc: string, flush: bool], args: openArray[string]) =\n     \
    \   for i in 0 ..< args.len:\n            prop.f.write(args[i])\n            if\
    \ i != args.len - 1:\n                prop.f.write(prop.sepc)\n            else:\n\
    \                prop.f.write(prop.endc)\n        if prop.flush:\n           \
    \ prop.f.flushFile()\n\n    # 2. \u30E6\u30FC\u30B6\u30FC\u304C\u547C\u3073\u51FA\
    \u3059\u305F\u3081\u306E\u30A4\u30F3\u30BF\u30FC\u30D5\u30A7\u30FC\u30B9 (varargs\
    \ \u3092\u53D7\u3051\u53D6\u308B)\n    proc print*(prop: tuple[f: File, sepc:\
    \ string, endc: string, flush: bool], args: varargs[string, `$`]) =\n        #\
    \ varargs \u306F\u5185\u90E8\u3067\u306F openArray \u3068\u3057\u3066\u6271\u3048\
    \u308B\u306E\u3067\u3001\u305D\u306E\u307E\u307E\u6E21\u305B\u308B\n        print_internal(prop,\
    \ args)\n\n    proc print*(args: varargs[string, `$`]) =\n        # \u3053\u3061\
    \u3089\u3082\u5185\u90E8\u7528\u306E proc \u3092\u547C\u3076\n        print_internal((f:\
    \ stdout, sepc: \" \", endc: \"\\n\", flush: false), args)\n    macro getSymbolName(x:\
    \ typed): string = x.toStrLit\n    macro debug*(args: varargs[untyped]): untyped\
    \ =\n        when defined(debug):\n            result = newNimNode(nnkStmtList,\
    \ args)\n            template prop(e: string = \"\"): untyped = (f: stderr, sepc:\
    \ \"\", endc: e, flush: true)\n            for i, arg in args:\n             \
    \   if arg.kind == nnkStrLit:\n                    result.add(quote do: print(prop(),\
    \ \"\\\"\", `arg`, \"\\\"\"))\n                else:\n                    result.add(quote\
    \ do: print(prop(\": \"), getSymbolName(`arg`)))\n                    result.add(quote\
    \ do: print(prop(), `arg`))\n                if i != args.len - 1: result.add(quote\
    \ do: print(prop(), \", \"))\n                else: result.add(quote do: print(prop(),\
    \ \"\\n\"))\n        else:\n            return (quote do: discard)\n    #chmin,chmax\n\
    \    template `max=`(x, y) = x = max(x, y)\n    template `min=`(x, y) = x = min(x,\
    \ y)\n    proc chmin[T](x: var T, y: T):bool=\n        if x > y:\n           \
    \ x = y\n            return true\n        return false\n    proc chmax[T](x: var\
    \ T, y: T):bool=\n        if x < y:\n            x = y\n            return true\n\
    \        return false\n    #bit\u6F14\u7B97\n    proc `%`*(x: int, y: int): int\
    \ =\n        result = x mod y\n        if y > 0 and result < 0: result += y\n\
    \        if y < 0 and result > 0: result += y\n    proc `//`*(x: int, y: int):\
    \ int{.inline.} =\n        result = x div y\n        if y > 0 and result * y >\
    \ x: result -= 1\n        if y < 0 and result * y < x: result -= 1\n    proc `%=`(x:\
    \ var int, y: int): void = x = x%y\n    proc `//=`(x: var int, y: int): void =\
    \ x = x//y\n    proc `**`(x: int, y: int): int = x^y\n    proc `**=`(x: var int,\
    \ y: int): void = x = x^y\n    proc `^`(x: int, y: int): int = x xor y\n    proc\
    \ `|`(x: int, y: int): int = x or y\n    proc `&`(x: int, y: int): int = x and\
    \ y\n    proc `>>`(x: int, y: int): int = x shr y\n    proc `<<`(x: int, y: int):\
    \ int = x shl y\n    proc `~`(x: int): int = not x\n    proc `^=`(x: var int,\
    \ y: int): void = x = x ^ y\n    proc `&=`(x: var int, y: int): void = x = x &\
    \ y\n    proc `|=`(x: var int, y: int): void = x = x | y\n    proc `>>=`(x: var\
    \ int, y: int): void = x = x >> y\n    proc `<<=`(x: var int, y: int): void =\
    \ x = x << y\n    proc `[]`(x: int, n: int): bool = (x and (1 shl n)) != 0\n \
    \   #\u4FBF\u5229\u306A\u5909\u63DB\n    proc `!`(x: char, a = '0'): int = int(x)-int(a)\n\
    \    #\u5B9A\u6570\n    include cplib/utils/constants\n    const INF = INF64\n\
    \    #converter\n\n    #range\n    iterator range(start: int, ends: int, step:\
    \ int): int =\n        var i = start\n        if step < 0:\n            while\
    \ i > ends:\n                yield i\n                i += step\n        elif\
    \ step > 0:\n            while i < ends:\n                yield i\n          \
    \      i += step\n    iterator range(ends: int): int = (for i in 0..<ends: yield\
    \ i)\n    iterator range(start: int, ends: int): int = (for i in\n           \
    \ start..<ends: yield i)\n\n    #join\u304C\u975Estring\u3067\u3081\u3061\u3083\
    \u304F\u3061\u3083\u9045\u3044\u3084\u3064\u306E\u30D1\u30C3\u30C1\n    proc join*[T:\
    \ not string](a: openArray[T], sep: string = \"\"): string = a.mapit($it).join(sep)\n\
    \n    proc dump[T](arr:seq[seq[T]])=\n        for i in 0..<len(arr):\n       \
    \     echo arr[i]\n\n    proc sum(slice:HSlice[int,int]):int=\n        return\
    \ (slice.a+slice.b)*len(slice)//2\n    \n    proc `<`[T](l,r:seq[T]):bool=\n \
    \       for i in 0..<min(len(l),len(r)):\n            if l[i] > r[i]:\n      \
    \          return false\n            elif l[i] < r[i]:\n                return\
    \ true\n        return len(l) < len(r)\n    \n    # Yes/No\n    proc yes*(b: bool\
    \ = true): void = print(if b: \"Yes\" else: \"No\")\n    proc oo*(b: bool = true):\
    \ void = yes(not b)\n\n    proc takahashi(b:bool = true) : void = print(if b:\
    \ \"Takahashi\" else: \"Aoki\")\n    proc aoki(b:bool = true) : void = takahashi(not\
    \ b)\n\n    template dblock(body: untyped) =\n        when defined(debug):\n \
    \           body\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  isVerificationFile: false
  path: cplib/tmpl/sheep.nim
  requiredBy:
  - verify/str/merged_static_string.nim
  - verify/str/merged_static_string.nim
  timestamp: '2026-02-20 17:27:16+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/isprime_yosupo_test.nim
  - verify/math/isprime_yosupo_test.nim
  - verify/math/isprime_yukicoder_test.nim
  - verify/math/isprime_yukicoder_test.nim
  - verify/graph/static/restore_dijkstra_static_test.nim
  - verify/graph/static/restore_dijkstra_static_test.nim
  - verify/graph/static/shortest_path_static_test.nim
  - verify/graph/static/shortest_path_static_test.nim
  - verify/graph/dynamic/shortest_path_test.nim
  - verify/graph/dynamic/shortest_path_test.nim
  - verify/graph/dynamic/restore_dijkstra_test.nim
  - verify/graph/dynamic/restore_dijkstra_test.nim
  - verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
  - verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
  - verify/str/hash_string/hash_string_mul_test.nim
  - verify/str/hash_string/hash_string_mul_test.nim
documentation_of: cplib/tmpl/sheep.nim
layout: document
redirect_from:
- /library/cplib/tmpl/sheep.nim
- /library/cplib/tmpl/sheep.nim.html
title: cplib/tmpl/sheep.nim
---
