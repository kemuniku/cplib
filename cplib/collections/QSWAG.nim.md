---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/QSWAG_test.nim
    title: verify/collections/QSWAG_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/QSWAG_test.nim
    title: verify/collections/QSWAG_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_SWAG:\n    const CPLIB_COLLECTIONS_SWAG*\
    \ = 1\n\n    import algorithm\n    type QSWAG*[T] = ref object\n        op: proc(x,\
    \ y: T): T\n        e: T\n        top: seq[T]\n        bottom: seq[T]\n      \
    \  topfold: seq[T]\n        bottomfold: seq[T]\n    proc initSWAG*[T](op: proc(x,\
    \ y: T): T, e: T): QSWAG[T] =\n        result = QSWAG[T](op: op, e: e, top: @[],\
    \ bottom: @[], topfold: @[e], bottomfold: @[e])\n    proc pushbottom[T](self:\
    \ QSWAG[T], x: T) =\n        self.bottom.add(x)\n        self.bottomfold.add(self.op(self.bottomfold[^1],\
    \ x))\n    proc popbottom[T](self: QSWAG[T]): T =\n        discard self.bottomfold.pop()\n\
    \        self.bottom.pop()\n    proc pushtop[T](self: QSWAG[T], x: T) =\n    \
    \    self.top.add(x)\n        self.topfold.add(self.op(x, self.topfold[^1]))\n\
    \    proc poptop[T](self: QSWAG[T]): T =\n        discard self.topfold.pop()\n\
    \        self.top.pop()\n    proc push*[T](self: QSWAG[T], x: T) =\n        self.pushbottom(x)\n\
    \    proc pop*[T](self: QSWAG[T]): T =\n        if len(self.top) != 0:\n     \
    \       return self.poptop()\n        else:\n            if len(self.bottom) ==\
    \ 0:\n                raise newException(IndexDefect, \"index out of bounds, the\
    \ container is empty \")\n            for _ in 0..<len(self.bottom):\n       \
    \         self.pushtop(self.popbottom)\n            return self.poptop()\n   \
    \ proc fold*[T](self: QSWAG[T]): T =\n        return self.op(self.topfold[^1],\
    \ self.bottomfold[^1])\n    proc `$`*[T](self: QSWAG[T]): string =\n        return\
    \ $reversed(self.top) & $self.bottom\n    proc len*[T](self: QSWAG[T]): int =\n\
    \        return len(self.bottom)+len(self.top)\n    proc `[]`*[T](self: QSWAG[T],\
    \ index: int): T =\n        if index >= len(self):\n            raise newException(IndexDefect,\
    \ \"index \" & $index & \" not in 0 .. \" & len(self))\n        if index < len(self.top):\n\
    \            return self.top[len(self.top)-1-index]\n        return self.bottom[index-len(self.top)]\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/QSWAG.nim
  requiredBy: []
  timestamp: '2023-11-21 23:57:46+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/QSWAG_test.nim
  - verify/collections/QSWAG_test.nim
documentation_of: cplib/collections/QSWAG.nim
layout: document
redirect_from:
- /library/cplib/collections/QSWAG.nim
- /library/cplib/collections/QSWAG.nim.html
title: cplib/collections/QSWAG.nim
---
