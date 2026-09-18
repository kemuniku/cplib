---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/QSWAG_test.nim
    title: verify/AI/QSWAG_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/QSWAG_test.nim
    title: verify/AI/QSWAG_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/QSWAG_test.nim
    title: verify/collections/QSWAG_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/QSWAG_test.nim
    title: verify/collections/QSWAG_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/backwards_index_collections_test.nim
    title: verify/utils/backwards_index_collections_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/backwards_index_collections_test.nim
    title: verify/utils/backwards_index_collections_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_QSWAG:\n    const CPLIB_COLLECTIONS_QSWAG*\
    \ = 1\n    import cplib/utils/backwards_index\n\n    import algorithm\n    type\
    \ QSWAG*[T] = ref object\n        op: proc(x, y: T): T\n        e: T\n       \
    \ top: seq[T]\n        bottom: seq[T]\n        topfold: seq[T]\n        bottomfold:\
    \ seq[T]\n    proc initSWAG*[T](op: proc(x, y: T): T, e: T): QSWAG[T] =\n    \
    \    result = QSWAG[T](op: op, e: e, top: @[], bottom: @[], topfold: @[e], bottomfold:\
    \ @[e])\n    proc pushbottom[T](self: QSWAG[T], x: T) =\n        self.bottom.add(x)\n\
    \        self.bottomfold.add(self.op(self.bottomfold[^1], x))\n    proc popbottom[T](self:\
    \ QSWAG[T]): T =\n        discard self.bottomfold.pop()\n        self.bottom.pop()\n\
    \    proc pushtop[T](self: QSWAG[T], x: T) =\n        self.top.add(x)\n      \
    \  self.topfold.add(self.op(x, self.topfold[^1]))\n    proc poptop[T](self: QSWAG[T]):\
    \ T =\n        discard self.topfold.pop()\n        self.top.pop()\n    proc push*[T](self:\
    \ QSWAG[T], x: T) =\n        self.pushbottom(x)\n    proc pop*[T](self: QSWAG[T]):\
    \ T =\n        if len(self.top) != 0:\n            return self.poptop()\n    \
    \    else:\n            if len(self.bottom) == 0:\n                raise newException(IndexDefect,\
    \ \"index out of bounds, the container is empty \")\n            for _ in 0..<len(self.bottom):\n\
    \                self.pushtop(self.popbottom)\n            return self.poptop()\n\
    \    proc fold*[T](self: QSWAG[T]): T =\n        return self.op(self.topfold[^1],\
    \ self.bottomfold[^1])\n    proc `$`*[T](self: QSWAG[T]): string =\n        return\
    \ $reversed(self.top) & $self.bottom\n    proc len*[T](self: QSWAG[T]): int =\n\
    \        return len(self.bottom)+len(self.top)\n    proc `[]`*[T](self: QSWAG[T],\
    \ index: int): T {.backwardsIndex.} =\n        if index >= len(self):\n      \
    \      raise newException(IndexDefect, \"index \" & $index & \" not in 0 .. \"\
    \ & $len(self))\n        if index < len(self.top):\n            return self.top[len(self.top)-1-index]\n\
    \        return self.bottom[index-len(self.top)]\n    proc get_maxrights*[T](v:seq[T],op:proc(l,r:T):T,e:T,f:proc(x:T):bool):seq[int]=\n\
    \        assert f(e), \"\u5224\u5B9A\u95A2\u6570\u306F\u5358\u4F4D\u5143\u306B\
    \u5BFE\u3057\u3066true\u3092\u8FD4\u3059\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\
    \"\n        var swag = initSWAG(op,e)\n        var r = 0\n        for l in 0..<(len(v)):\n\
    \            if l > r:\n                r = l\n            while r != len(v) and\
    \ swag.fold().f():\n                swag.push(v[r])\n                r += 1\n\
    \            if swag.fold().f():\n                result.add(len(v))\n       \
    \     else:\n                result.add(r-1)\n            if len(swag) > 0:\n\
    \                discard swag.pop()\n"
  dependsOn:
  - cplib/utils/backwards_index.nim
  - cplib/utils/backwards_index.nim
  isVerificationFile: false
  path: cplib/collections/QSWAG.nim
  requiredBy: []
  timestamp: '2026-09-18 12:10:16+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/backwards_index_collections_test.nim
  - verify/utils/backwards_index_collections_test.nim
  - verify/collections/QSWAG_test.nim
  - verify/collections/QSWAG_test.nim
  - verify/AI/QSWAG_test.nim
  - verify/AI/QSWAG_test.nim
documentation_of: cplib/collections/QSWAG.nim
layout: document
redirect_from:
- /library/cplib/collections/QSWAG.nim
- /library/cplib/collections/QSWAG.nim.html
title: cplib/collections/QSWAG.nim
---
