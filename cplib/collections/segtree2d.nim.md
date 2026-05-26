---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
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
  code: "when not declared CPLIB_COLLECTIONS_SEGTREE2D:\n    const CPLIB_COLLECTIONS_SEGTREE2D*\
    \ = 1\n    import cplib/collections/segtree\n\n    type SegmentTree2D*[T] = ref\
    \ object\n        default: T\n        merge: proc(x: T, y: T): T\n        arr*:\
    \ seq[SegmentTree[T]]\n        lastnode: int\n        H: int\n        W: int\n\
    \n    proc initSegmentTree2D*[T](v: seq[seq[T]], merge: proc(x: T, y: T): T, default:\
    \ T): SegmentTree2D[T] =\n        var H = len(v)\n        var W = 0\n        if\
    \ H != 0:\n            W = len(v[0])\n        var lastnode = 1\n        while\
    \ lastnode < len(v):\n            lastnode*=2\n        var arr = newSeq[SegmentTree[T]](2*lastnode)\n\
    \        for i in 0..<len(v):\n            arr[i+lastnode] = initSegmentTree(v[i],merge,default)\n\
    \        for i in len(v)..<lastnode:\n            arr[i+lastnode] = initSegmentTree(W,merge,default)\n\
    \        \n        for i in countdown(lastnode-1, 1):\n            var tmp = newseq[T](W)\n\
    \            for j in 0..<W:\n                tmp[j] = merge(arr[2*i][j],arr[2*i+1][j])\n\
    \            arr[i] = initSegmentTree(tmp,merge,default)\n        var self = SegmentTree2D[T](default:\
    \ default, merge: merge, arr: arr, lastnode: lastnode, H:H,W:W)\n        return\
    \ self\n\n    proc get*[T](self: SegmentTree2D[T], il: Natural, ir: Natural,jl:\
    \ Natural, jr: Natural): T =\n        ## \u9577\u65B9\u5F62\u9818\u57DF i\u2208\
    [il,ir), j\u2208[jl,jr) \u306B\u3064\u3044\u3066\u306E\u6F14\u7B97\u7D50\u679C\
    \u3092\u8FD4\u3057\u307E\u3059\u3002\n        assert il <= ir and 0 <= il and\
    \ ir <= self.H\n        assert jl <= jr and 0 <= jl and jr <= self.W\n       \
    \ var il = il\n        var ir = ir\n        il += self.lastnode\n        ir +=\
    \ self.lastnode\n        var (lres, rres) = (self.default, self.default)\n   \
    \     while il < ir:\n            if (il and 1) > 0:\n                lres = self.merge(lres,\
    \ self.arr[il].get(jl,jr))\n                il += 1\n            if (ir and 1)\
    \ > 0:\n                ir -= 1\n                rres = self.merge(self.arr[ir].get(jl,jr),\
    \ rres)\n            il = il shr 1\n            ir = ir shr 1\n        return\
    \ self.merge(lres, rres)\n\n    proc update*[T](self: SegmentTree2D[T], i,j: Natural,\
    \ val: T) =\n        ## (i, j)\u306E\u8981\u7D20\u3092val\u306B\u5909\u66F4\u3057\
    \u307E\u3059\u3002\n        assert i < self.H\n        assert j < self.W\n   \
    \     var i = i\n        i += self.lastnode\n        self.arr[i][j] = val\n  \
    \      while i > 1:\n            i = i shr 1\n            self.arr[i][j] = self.merge(self.arr[2*i][j],\
    \ self.arr[2*i+1][j])"
  dependsOn:
  - cplib/collections/segtree.nim
  - cplib/collections/segtree.nim
  isVerificationFile: false
  path: cplib/collections/segtree2d.nim
  requiredBy: []
  timestamp: '2026-05-26 12:11:14+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/collections/segtree2d.nim
layout: document
redirect_from:
- /library/cplib/collections/segtree2d.nim
- /library/cplib/collections/segtree2d.nim.html
title: cplib/collections/segtree2d.nim
---
