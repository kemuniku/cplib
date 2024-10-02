---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/tmpl/citrus_and_qcfium_test.nim
    title: verify/tmpl/citrus_and_qcfium_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tmpl/citrus_and_qcfium_test.nim
    title: verify/tmpl/citrus_and_qcfium_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_TMPL_CITRUS:\n    const CPLIB_TMPL_CITRUS* = 1\n\
    \    {.warning[UnusedImport]: off.}\n    {.hint[XDeclaredButNotUsed]: off.}\n\
    \    import os\n    import algorithm\n    import sequtils\n    import tables\n\
    \    import macros\n    import std/math\n    import sets\n    import strutils\n\
    \    import strformat\n    import sugar\n    import streams\n    import deques\n\
    \    import bitops\n    import heapqueue\n    import options\n    import hashes\n\
    \    const MODINT998244353* = 998244353\n    const MODINT1000000007* = 1000000007\n\
    \    include cplib/utils/constants\n    const INFL = INF64\n    type double* =\
    \ float64\n    let readNext = iterator(getsChar: bool = false): string {.closure.}\
    \ =\n        while true:\n            var si: string\n            try: si = stdin.readLine\n\
    \            except EOFError: yield \"\"\n            for s in si.split:\n   \
    \             if getsChar:\n                    for i in 0..<s.len():\n      \
    \                  yield s[i..i]\n                else:\n                    if\
    \ s.isEmptyOrWhitespace: continue\n                    yield s\n    proc input*(t:\
    \ typedesc[string]): string = readNext()\n    proc input*(t: typedesc[char]):\
    \ char = readNext(true)[0]\n    proc input*(t: typedesc[int]): int = readNext().parseInt\n\
    \    proc input*(t: typedesc[float]): float = readNext().parseFloat\n    macro\
    \ input*(t: typedesc, n: varargs[int]): untyped =\n        var repStr = \"\"\n\
    \        for arg in n:\n            repStr &= &\"({arg.repr}).newSeqWith \"\n\
    \        parseExpr(&\"{repStr}input({t})\")\n    macro input*(ts: varargs[auto]):\
    \ untyped =\n        var tupStr = \"\"\n        for t in ts:\n            tupStr\
    \ &= &\"input({t.repr}),\"\n        parseExpr(&\"({tupStr})\")\n    macro input*(n:\
    \ int, ts: varargs[auto]): untyped =\n        for typ in ts:\n            if typ.typeKind\
    \ != ntyAnything:\n                error(\"Expected typedesc, got \" & typ.repr,\
    \ typ)\n        parseExpr(&\"({n.repr}).newSeqWith input({ts.repr})\")\n    proc\
    \ `fmtprint`*(x: int or string or char or bool): string = return $x\n    proc\
    \ `fmtprint`*(x: float or float32 or float64): string = return &\"{x:.16f}\"\n\
    \    proc `fmtprint`*[T](x: seq[T] or Deque[T] or HashSet[T] or set[T]): string\
    \ = return x.toSeq.join(\" \")\n    proc `fmtprint`*[T, N](x: array[T, N]): string\
    \ = return x.toSeq.join(\" \")\n    proc `fmtprint`*[T](x: HeapQueue[T]): string\
    \ =\n        var q = x\n        while q.len != 0:\n            result &= &\"{q.pop()}\"\
    \n            if q.len != 0: result &= \" \"\n    proc `fmtprint`*[T](x: CountTable[T]):\
    \ string =\n        result = x.pairs.toSeq.mapIt(&\"{it[0]}: {it[1]}\").join(\"\
    \ \")\n    proc `fmtprint`*[K, V](x: Table[K, V]): string =\n        result =\
    \ x.pairs.toSeq.mapIt(&\"{it[0]}: {it[1]}\").join(\" \")\n    proc print*(prop:\
    \ tuple[f: File, sepc: string, endc: string, flush: bool], args: varargs[string,\
    \ `fmtprint`]) =\n        for i in 0..<len(args):\n            prop.f.write(&\"\
    {args[i]}\")\n            if i != len(args) - 1: prop.f.write(prop.sepc) else:\
    \ prop.f.write(prop.endc)\n        if prop.flush: prop.f.flushFile()\n    proc\
    \ print*(args: varargs[string, `fmtprint`]) = print((f: stdout, sepc: \" \", endc:\
    \ \"\\n\", flush: false), args)\n    const LOCAL_DEBUG{.booldefine.} = false\n\
    \    macro getSymbolName(x: typed): string = x.toStrLit\n    macro debug*(args:\
    \ varargs[untyped]): untyped =\n        when LOCAL_DEBUG:\n            result\
    \ = newNimNode(nnkStmtList, args)\n            template prop(e: string = \"\"\
    ): untyped = (f: stderr, sepc: \"\", endc: e, flush: true)\n            for i,\
    \ arg in args:\n                if arg.kind == nnkStrLit:\n                  \
    \  result.add(quote do: print(prop(), \"\\\"\", `arg`, \"\\\"\"))\n          \
    \      else:\n                    result.add(quote do: print(prop(\": \"), getSymbolName(`arg`)))\n\
    \                    result.add(quote do: print(prop(), `arg`))\n            \
    \    if i != args.len - 1: result.add(quote do: print(prop(), \", \"))\n     \
    \           else: result.add(quote do: print(prop(), \"\\n\"))\n        else:\n\
    \            return (quote do: discard)\n    proc `%`*(x: SomeInteger, y: SomeInteger):\
    \ int =\n        result = x mod y\n        if y > 0 and result < 0: result +=\
    \ y\n        if y < 0 and result > 0: result += y\n    proc `//`*(x: SomeInteger,\
    \ y: SomeInteger): int =\n        result = x div y\n        if y > 0 and result\
    \ * y > x: result -= 1\n        if y < 0 and result * y < x: result -= 1\n   \
    \ proc `^`*(x: SomeInteger, y: SomeInteger): int = x xor y\n    proc `&`*(x: SomeInteger,\
    \ y: SomeInteger): int = x and y\n    proc `|`*(x: SomeInteger, y: SomeInteger):\
    \ int = x or y\n    proc `>>`*(x: SomeInteger, y: SomeInteger): int = x shr y\n\
    \    proc `<<`*(x: SomeInteger, y: SomeInteger): int = x shl y\n    proc `%=`*(x:\
    \ var SomeInteger, y: SomeInteger): void = x = x % y\n    proc `//=`*(x: var SomeInteger,\
    \ y: SomeInteger): void = x = x // y\n    proc `^=`*(x: var SomeInteger, y: SomeInteger):\
    \ void = x = x ^ y\n    proc `&=`*(x: var SomeInteger, y: SomeInteger): void =\
    \ x = x & y\n    proc `|=`*(x: var SomeInteger, y: SomeInteger): void = x = x\
    \ | y\n    proc `>>=`*(x: var SomeInteger, y: SomeInteger): void = x = x >> y\n\
    \    proc `<<=`*(x: var SomeInteger, y: SomeInteger): void = x = x << y\n    proc\
    \ `[]`*(x, n: int): bool = (x and (1 shl n)) != 0\n    proc `[]=`*(x: var int,\
    \ n: int, i: bool) =\n        if i: x = x or (1 << n)\n        else: (if x[n]:\
    \ x = x xor (1 << n))\n    proc pow*(a, n: int, m = INF64): int =\n        var\n\
    \            rev = 1\n            a = a\n            n = n\n        while n >\
    \ 0:\n            if n % 2 != 0: rev = (rev * a) mod m\n            if n > 1:\
    \ a = (a * a) mod m\n            n >>= 1\n        return rev\n    include cplib/math/isqrt\n\
    \    proc chmax*[T](x: var T, y: T): bool {.discardable.} = (if x < y: (x = y;\
    \ return true; ) return false)\n    proc chmin*[T](x: var T, y: T): bool {.discardable.}\
    \ = (if x > y: (x = y; return true; ) return false)\n    proc `max=`*[T](x: var\
    \ T, y: T) = x = max(x, y)\n    proc `min=`*[T](x: var T, y: T) = x = min(x, y)\n\
    \    proc at*(x: char, a = '0'): int = int(x) - int(a)\n    proc Yes*(b: bool\
    \ = true): void = print(if b: \"Yes\" else: \"No\")\n    proc No*(b: bool = true):\
    \ void = Yes(not b)\n    proc YES_upper*(b: bool = true): void = print(if b: \"\
    YES\" else: \"NO\")\n    proc NO_upper*(b: bool = true): void = Yes_upper(not\
    \ b)\n    const DXY* = [(0, -1), (0, 1), (-1, 0), (1, 0)]\n    const DDXY* = [(1,\
    \ -1), (1, 0), (1, 1), (0, -1), (0, 1), (-1, -1), (-1, 0), (-1, 1)]\n    macro\
    \ exit*(statement: untyped): untyped = (quote do: (`statement`; quit()))\n   \
    \ proc initHashSet[T](): Hashset[T] = initHashSet[T](0)\n"
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/utils/constants.nim
  - cplib/math/isqrt.nim
  - cplib/utils/constants.nim
  isVerificationFile: false
  path: cplib/tmpl/citrus.nim
  requiredBy: []
  timestamp: '2024-06-25 03:55:23+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/tmpl/citrus_and_qcfium_test.nim
  - verify/tmpl/citrus_and_qcfium_test.nim
documentation_of: cplib/tmpl/citrus.nim
layout: document
redirect_from:
- /library/cplib/tmpl/citrus.nim
- /library/cplib/tmpl/citrus.nim.html
title: cplib/tmpl/citrus.nim
---
