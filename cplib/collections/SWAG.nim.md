---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/SWAG_test.nim
    title: verify/collections/SWAG_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/SWAG_test.nim
    title: verify/collections/SWAG_test.nim
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
    \ = 1\n\n    import algorithm\n    type SWAG*[T,S] = ref object\n        op:proc(x,y:T):S\n\
    \        e:S\n        top:seq[T]\n        bottom:seq[T]\n        topfold:seq[S]\n\
    \        bottomfold:seq[S]\n    proc initSWAG*[T,S](op:proc(x,y:T):S,e:S):SWAG[T,S]=\n\
    \        result = SWAG[T,S](op:op,e: e,top: @[],bottom: @[],topfold: @[e],bottomfold:\
    \ @[e])\n    proc pushbottom[T,S](self:SWAG[T,S],x:S)=\n        self.bottom.add(x)\n\
    \        self.bottomfold.add(self.op(self.bottomfold[^1],x))\n    proc popbottom[T,S](self:SWAG[T,S]):T=\n\
    \        discard self.bottomfold.pop()\n        self.bottom.pop()\n    proc pushtop[T,S](self:SWAG[T,S],x:S)=\n\
    \        self.top.add(x)\n        self.topfold.add(self.op(x,self.topfold[^1]))\n\
    \    proc poptop[T,S](self:SWAG[T,S]):T=\n        discard self.topfold.pop()\n\
    \        self.top.pop()\n    proc addFirst*[T,S](self:SWAG[T,S],x:T)=\n      \
    \  self.pushtop(x)\n    proc addLast*[T,S](self:SWAG[T,S],x:T)=\n        self.pushbottom(x)\n\
    \    proc popFirst*[T,S](self:SWAG[T,S]):T=\n        if len(self.top) != 0:\n\
    \            return self.poptop()\n        else:\n            if len(self.bottom)==0:\n\
    \                raise newException(IndexDefect, \"index out of bounds, the container\
    \ is empty \")\n            var stack:seq[T]\n            for _ in 0..<len(self.bottom)\
    \ div 2:\n                stack.add(self.popbottom())\n            for _ in 0..<len(self.bottom):\n\
    \                self.pushtop(self.popbottom())\n            for _ in 0..<len(stack):\n\
    \                self.pushbottom(stack.pop())\n            return self.poptop()\n\
    \    proc popLast*[T,S](self:SWAG[T,S]):T=\n        if len(self.bottom) != 0:\n\
    \            return self.popbottom()\n        else:\n            if len(self.top)==0:\n\
    \                raise newException(IndexDefect, \"index out of bounds, the container\
    \ is empty \")\n            var stack1:seq[T]\n            var stack2:seq[T]\n\
    \            for _ in 0..<len(self.top) div 2:\n                stack1.add(self.poptop())\n\
    \            for _ in 0..<len(self.top):\n                stack2.add(self.poptop())\n\
    \            stack2.reverse()\n            for _ in 0..<len(stack1):\n       \
    \         self.pushtop(stack1.pop())\n            for _ in 0..<len(stack2):\n\
    \                self.pushbottom(stack2.pop())\n            return self.popbottom()\n\
    \    proc fold*[T,S](self:SWAG[T,S]):S=\n        return self.op(self.topfold[^1],self.bottomfold[^1])"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/SWAG.nim
  requiredBy: []
  timestamp: '2023-11-21 16:26:49+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/SWAG_test.nim
  - verify/collections/SWAG_test.nim
documentation_of: cplib/collections/SWAG.nim
layout: document
redirect_from:
- /library/cplib/collections/SWAG.nim
- /library/cplib/collections/SWAG.nim.html
title: cplib/collections/SWAG.nim
---