---
data:
  _extendedDependsOn: []
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
    \    import bitops\n    import heapqueue\n    const MODINT998244353* = 998244353\n\
    \    const MODINT1000000007* = 1000000007\n    const INF* = 100100111\n    const\
    \ INFL* = int(3300300300300300491)\n    type double* = float64\n    let readNext\
    \ = iterator(getsChar: bool = false): string {.closure.} =\n        while true:\n\
    \            var si: string\n            try: si = stdin.readLine\n          \
    \  except EOFError: yield \"\"\n            for s in si.split:\n             \
    \   if getsChar:\n                    for i in 0..<s.len(): yield s[i..i]\n  \
    \              else:\n                    yield s\n    proc input*(t: typedesc[string]):\
    \ string = readNext()\n    proc input*(t: typedesc[char]): char = readNext(true)[0]\n\
    \    proc input*(t: typedesc[int]): int = readNext().parseInt\n    proc input*(t:\
    \ typedesc[float]): float = readNext().parseFloat\n    macro input*(t: typedesc,\
    \ n: varargs[int]): untyped =\n        var repStr = \"\"\n        for arg in n:\n\
    \            repStr &= &\"({arg.repr}).newSeqWith \"\n        parseExpr(&\"{repStr}input({t})\"\
    )\n    macro input*(ts: varargs[auto]): untyped =\n        var tupStr = \"\"\n\
    \        for t in ts:\n            tupStr &= &\"input({t.repr}),\"\n        parseExpr(&\"\
    ({tupStr})\")\n    macro input*(n: int, ts: varargs[auto]): untyped =\n      \
    \  for typ in ts:\n            if typ.typeKind != ntyAnything:\n             \
    \   error(\"Expected typedesc, got \" & typ.repr, typ)\n        parseExpr(&\"\
    ({n.repr}).newSeqWith input({ts.repr})\")\n    proc `fmtprint`*(x: int or string\
    \ or char): string = return $x\n    proc `fmtprint`*(x: float or float32 or\n\
    \            float64): string = return &\"{x:.16f}\"\n    proc `fmtprint`*[T](x:\
    \ seq[T] or Deque[T] or HashSet[T] or set[\n            T]): string = return x.toSeq.join(\"\
    \ \")\n    proc `fmtprint`*[T, N](x: array[T, N]): string = return x.toSeq.join(\"\
    \ \")\n    proc `fmtprint`*[T](x: HeapQueue[T]): string =\n        var q = x\n\
    \        while q.len != 0:\n            result &= &\"{q.pop()}\"\n           \
    \ if q.len != 0: result &= \" \"\n    proc `fmtprint`*[T](x: CountTable[T]): string\
    \ =\n        result = x.pairs.toSeq.mapIt(&\"{it[0]}: {it[1]}\").join(\" \")\n\
    \    proc `fmtprint`*[K, V](x: Table[K, V]): string =\n        result = x.pairs.toSeq.mapIt(&\"\
    {it[0]}: {it[1]}\").join(\" \")\n    proc print*(prop: tuple[f: File, sepc: string,\
    \ endc: string, flush: bool],\n            args: varargs[string, `fmtprint`])\
    \ =\n        for i in 0..<len(args):\n            prop.f.write(&\"{args[i]}\"\
    )\n            if i != len(args) - 1: prop.f.write(prop.sepc) else: prop.f.write(prop.endc)\n\
    \        if prop.flush: prop.f.flushFile()\n    proc print*(args: varargs[string,\
    \ `fmtprint`]) = print((f: stdout,\n            sepc: \" \", endc: \"\\n\", flush:\
    \ false), args)\n    proc inner_debug*(x: auto) = print((f: stderr, sepc: \"\"\
    , endc: \"\",\n            flush: true), x)\n    const LOCAL_DEBUG{.booldefine.}\
    \ = false\n    macro debug*(n: varargs[typed]): untyped =\n        when LOCAL_DEBUG:\n\
    \            result = newNimNode(nnkStmtList, n)\n            for i in 0..n.len-1:\n\
    \                if n[i].kind == nnkStrLit:\n                    result.add(newCall(\"\
    inner_debug\", n[i]))\n                    result.add(newCall(\"inner_debug\"\
    , newStrLitNode(\": \")))\n                    result.add(newCall(\"inner_debug\"\
    , n[i]))\n                else:\n                    result.add(newCall(\"inner_debug\"\
    , toStrLit(n[i])))\n                    result.add(newCall(\"inner_debug\", newStrLitNode(\"\
    : \")))\n                    result.add(newCall(\"inner_debug\", n[i]))\n    \
    \            if i != n.len-1:\n                    result.add(newCall(\"inner_debug\"\
    , newStrLitNode(\", \")))\n                else:\n                    result.add(newCall(\"\
    inner_debug\", newStrLitNode(\"\\n\")))\n        else:\n            return quote\
    \ do:\n                discard\n    proc `%`*(x: SomeInteger, y: SomeInteger):\
    \ int = (((x mod y) + y) mod y)\n    proc `//`*(x: int, y: int): int = ((x - (x%y))\
    \ div y)\n    proc `^`*(x: int, y: int): int = x xor y\n    proc `&`*(x: int,\
    \ y: int): int = x and y\n    proc `|`*(x: int, y: int): int = x or y\n    proc\
    \ `>>`*(x: int, y: int): int = x shr y\n    proc `<<`*(x: int, y: int): int =\
    \ x shl y\n    proc `%=`*(x: var SomeInteger or int64, y: SomeInteger or\n   \
    \         int64): void = x = x % y\n    proc `//=`*(x: var int, y: int): void\
    \ = x = x // y\n    proc `^=`*(x: var int, y: int): void = x = x ^ y\n    proc\
    \ `&=`*(x: var int, y: int): void = x = x & y\n    proc `|=`*(x: var int, y: int):\
    \ void = x = x | y\n    proc `>>=`*(x: var int, y: int): void = x = x >> y\n \
    \   proc `<<=`*(x: var int, y: int): void = x = x << y\n    proc `[]`*(x: int,\
    \ n: int): bool = (x and (1 shl n)) != 0\n\n    proc pow*(a, n: int, m = INFL):\
    \ int =\n        var\n            rev = 1\n            a = a\n            n =\
    \ n\n        while n > 0:\n            if n % 2 != 0: rev = (rev * a) mod m\n\
    \            if n > 1: a = (a * a) mod m\n            n >>= 1\n        return\
    \ rev\n    proc sqrt*(x: int): int =\n        assert(x >= 0)\n        result =\
    \ int(sqrt(float64(x)))\n        while result * result > x: result -= 1\n    \
    \    while (result+1) * (result+1) <= x: result += 1\n    proc chmax*[T](x: var\
    \ T, y: T): bool = (if x < y: (x = y; return true;\n        ) return false)\n\
    \    proc chmin*[T](x: var T, y: T): bool = (if x > y: (x = y; return true;\n\
    \        ) return false)\n    proc `max=`*[T](x: var T, y: T) = x = max(x, y)\n\
    \    proc `min=`*[T](x: var T, y: T) = x = min(x, y)\n    proc at*(x: char, a\
    \ = '0'): int = int(x) - int(a)\n    converter tofloat*(n: int): float = float(n)\n\
    \    iterator rangeiter*(start: int, ends: int, step: int): int =\n        var\
    \ i = start\n        if step < 0:\n            while i > ends:\n             \
    \   yield i\n                i += step\n        elif step > 0:\n            while\
    \ i < ends:\n                yield i\n                i += step\n    iterator\
    \ rangeiter*(ends: int): int = (for i in 0..<ends: yield i)\n    iterator rangeiter*(start:\
    \ int, ends: int): int = (for i in\n            start..<ends: yield i)\n    proc\
    \ Yes*(b: bool = true): void = print(if b: \"Yes\" else: \"No\")\n    proc No*(b:\
    \ bool = true): void = Yes(not b)\n    proc YES_upper*(b: bool = true): void =\
    \ print(if b: \"YES\" else: \"NO\")\n    proc NO_upper*(b: bool = true): void\
    \ = Yes_upper(not b)\n    const DXY* = [(0, -1), (0, 1), (-1, 0), (1, 0)]\n  \
    \  const DDXY* = [(1, -1), (1, 0), (1, 1), (0, -1), (0, 1), (-1, -1), (-1, 0),\n\
    \            (-1, 1)]\n    macro exit*(statement: untyped): untyped =\n      \
    \  quote do:\n            `statement`\n            quit()\n    proc vector*[T](d1,\
    \ : int, default: T = T(0)): seq[T] = newSeqWith(d1, default)\n    proc vv*[T](d1,\
    \ d2: int, default: T = T(0)): seq[seq[T]] = newSeqWith(d1,\n            newSeqWith(d2,\
    \ default))\n    proc vvv*[T](d1, d2, d3: int, default: T = T(0)): seq[seq[seq[\n\
    \            T]]] = newSeqWith(d1, newSeqWith(d2, newSeqWith(d3, default)))\n\
    \    proc vvvv*[T](d1, d2, d3, d4: int, default: T = T(0)): seq[seq[seq[seq[\n\
    \            T]]]] = newSeqWith(d1, newSeqWith(d2, newSeqWith(d3, newSeqWith(d4,\
    \ default))))\n    proc vvvvv*[T](d1, d2, d3, d4, d5: int, default: T = T(0)):\
    \ seq[seq[seq[seq[\n            seq[T]]]]] = newSeqWith(d1, newSeqWith(d2, newSeqWith(d3,\n\
    \            newSeqWith(d4, newSeqWith(d5, default)))))\n    proc vvvvvv*[T](d1,\
    \ d2, d3, d4, d5, d6: int, default: T = T(0)): seq[seq[\n            seq[seq[seq[seq[T]]]]]]\
    \ = newSeqWith(d1, newSeqWith(d2, newSeqWith(\n            d3, newSeqWith(d4,\
    \ newSeqWith(d5, newSeqWith(d6, default))))))\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/tmpl/citrus.nim
  requiredBy: []
  timestamp: '2023-11-02 03:54:12+09:00'
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
