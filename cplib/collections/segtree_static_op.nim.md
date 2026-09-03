---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree/segtree_static_op_test.nim
    title: verify/collections/segtree/segtree_static_op_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree/segtree_static_op_test.nim
    title: verify/collections/segtree/segtree_static_op_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_SEGTREE_STATIC_OP:\n    const CPLIB_COLLECTIONS_SEGTREE_STATIC_OP*\
    \ = 1\n    import algorithm, strutils\n\n    type SegmentTree*[T; p: static[tuple]]\
    \ = ref object\n        default: T\n        arr*: seq[T]\n        lastnode: int\n\
    \        length: int\n\n    template mergeOp[ST: SegmentTree](self: ST or typedesc[ST],\
    \ x, y: ST.T): auto =\n        block:\n            let value = ST.p.op(x, y)\n\
    \            value\n\n    template SegmentTreeType[T](op0: untyped): typedesc[SegmentTree]\
    \ =\n        proc staticMerge(x, y: T): T {.gensym, inline.} = op0(x, y)\n   \
    \     SegmentTree[T, (op: staticMerge)]\n\n    proc initSegmentTreeImpl[ST: SegmentTree](\n\
    \        self: typedesc[ST], v: openArray[ST.T], default: ST.T\n    ): ST =\n\
    \        ## \u9759\u7684\u306A\u30DE\u30FC\u30B8\u95A2\u6570\u3092\u6301\u3064\
    \u30BB\u30B0\u30E1\u30F3\u30C8\u30C4\u30EA\u30FC\u3092\u751F\u6210\u3057\u307E\
    \u3059\u3002\n        var lastnode = 1\n        while lastnode < len(v):\n   \
    \         lastnode *= 2\n        var arr = newSeq[ST.T](2 * lastnode)\n      \
    \  arr.fill(default)\n        result = ST(\n            default: default,\n  \
    \          arr: arr,\n            lastnode: lastnode,\n            length: len(v)\n\
    \        )\n        # 1-indexed\u3067\u4F5C\u6210\u3059\u308B\n        for i in\
    \ 0..<len(v):\n            result.arr[result.lastnode + i] = v[i]\n        for\
    \ i in countdown(lastnode - 1, 1):\n            result.arr[i] = result.mergeOp(result.arr[2\
    \ * i], result.arr[2 * i + 1])\n\n    proc initSegmentTreeImpl[ST: SegmentTree](\n\
    \        self: typedesc[ST], n: int, default: ST.T\n    ): ST =\n        ## \u5168\
    \u8981\u7D20\u3092\u5358\u4F4D\u5143\u3067\u521D\u671F\u5316\u3057\u305F\u3001\
    \u9759\u7684\u306A\u30DE\u30FC\u30B8\u95A2\u6570\u3092\u6301\u3064\u30BB\u30B0\
    \u30E1\u30F3\u30C8\u30C4\u30EA\u30FC\u3092\u751F\u6210\u3057\u307E\u3059\u3002\
    \n        var lastnode = 1\n        while lastnode < n:\n            lastnode\
    \ *= 2\n        var arr = newSeq[ST.T](2 * lastnode)\n        arr.fill(default)\n\
    \        result = ST(\n            default: default,\n            arr: arr,\n\
    \            lastnode: lastnode,\n            length: n\n        )\n        for\
    \ i in countdown(lastnode - 1, 1):\n            result.arr[i] = result.mergeOp(result.arr[2\
    \ * i], result.arr[2 * i + 1])\n\n    template initSegmentTree*[T](\n        v:\
    \ openArray[T], merge: untyped, default: T\n    ): untyped =\n        SegmentTreeType[T](merge).initSegmentTreeImpl(v,\
    \ default)\n\n    template initSegmentTree*[T](n: int, merge: untyped, default:\
    \ T): untyped =\n        SegmentTreeType[T](merge).initSegmentTreeImpl(n, default)\n\
    \n    proc update*[ST: SegmentTree](self: ST, x: Natural, val: ST.T) =\n     \
    \   ## x\u306E\u8981\u7D20\u3092val\u306B\u5909\u66F4\u3057\u307E\u3059\u3002\n\
    \        assert x < self.length\n        var x = x\n        x += self.lastnode\n\
    \        self.arr[x] = val\n        while x > 1:\n            x = x shr 1\n  \
    \          self.arr[x] = self.mergeOp(self.arr[2 * x], self.arr[2 * x + 1])\n\n\
    \    proc get*[ST: SegmentTree](self: ST, q_left: Natural, q_right: Natural):\
    \ ST.T =\n        ## \u534A\u958B\u533A\u9593[q_left,q_right)\u306B\u3064\u3044\
    \u3066\u306E\u6F14\u7B97\u7D50\u679C\u3092\u8FD4\u3057\u307E\u3059\u3002\n   \
    \     assert q_left <= q_right and q_right <= self.length\n        var q_left\
    \ = q_left\n        var q_right = q_right\n        q_left += self.lastnode\n \
    \       q_right += self.lastnode\n        var (lres, rres) = (self.default, self.default)\n\
    \        while q_left < q_right:\n            if (q_left and 1) > 0:\n       \
    \         lres = self.mergeOp(lres, self.arr[q_left])\n                q_left\
    \ += 1\n            if (q_right and 1) > 0:\n                q_right -= 1\n  \
    \              rres = self.mergeOp(self.arr[q_right], rres)\n            q_left\
    \ = q_left shr 1\n            q_right = q_right shr 1\n        return self.mergeOp(lres,\
    \ rres)\n\n    proc get*[ST: SegmentTree](self: ST, segment: HSlice[int, int]):\
    \ ST.T =\n        assert segment.a <= segment.b + 1 and\n            0 <= segment.a\
    \ and segment.b + 1 <= self.length\n        return self.get(segment.a, segment.b\
    \ + 1)\n\n    proc `[]`*[ST: SegmentTree](self: ST, segment: HSlice[int, int]):\
    \ ST.T =\n        self.get(segment)\n\n    proc `[]`*[ST: SegmentTree](self: ST,\
    \ index: Natural): ST.T =\n        assert index < self.length\n        return\
    \ self.arr[index + self.lastnode]\n\n    proc `[]=`*[ST: SegmentTree](self: ST,\
    \ index: Natural, val: ST.T) =\n        assert index < self.length\n        self.update(index,\
    \ val)\n\n    proc get_all*[ST: SegmentTree](self: ST): ST.T =\n        ## [0,len(self))\u533A\
    \u9593\u306E\u6F14\u7B97\u7D50\u679C\u3092O(1)\u3067\u8FD4\u3059\n        return\
    \ self.arr[1]\n\n    proc len*[ST: SegmentTree](self: ST): int =\n        return\
    \ self.length\n\n    proc `$`*[ST: SegmentTree](self: ST): string =\n        let\
    \ s = self.arr.len div 2\n        return self.arr[s..<s + self.len].join(\" \"\
    )\n\n    template newSegWith*(V, merge, default: untyped): untyped =\n       \
    \ block:\n            type T = typeof(default)\n            proc staticMerge(\n\
    \                l {.inject.}, r {.inject.}: T\n            ): T {.gensym, inline.}\
    \ = merge\n            SegmentTree[T, (op: staticMerge)].initSegmentTreeImpl(V,\
    \ default)\n\n    proc max_right*[ST: SegmentTree](\n        self: ST, l: int,\
    \ f: proc(value: ST.T): bool\n    ): int =\n        assert 0 <= l and l <= self.len\n\
    \        assert f(self.default)\n        if l == self.len:\n            return\
    \ self.len\n        var l = l + self.lastnode\n        var sm = self.default\n\
    \        while true:\n            while l mod 2 == 0:\n                l = l shr\
    \ 1\n            if not f(self.mergeOp(sm, self.arr[l])):\n                while\
    \ l < self.lastnode:\n                    l *= 2\n                    if f(self.mergeOp(sm,\
    \ self.arr[l])):\n                        sm = self.mergeOp(sm, self.arr[l])\n\
    \                        l += 1\n                return l - self.lastnode\n  \
    \          sm = self.mergeOp(sm, self.arr[l])\n            l += 1\n          \
    \  if (l and -l) == l:\n                break\n        return self.len\n\n   \
    \ proc min_left*[ST: SegmentTree](\n        self: ST, r: int, f: proc(value: ST.T):\
    \ bool\n    ): int =\n        assert 0 <= r and r <= self.len\n        assert\
    \ f(self.default)\n        if r == 0:\n            return 0\n        var r = r\
    \ + self.lastnode\n        var sm = self.default\n        while true:\n      \
    \      r -= 1\n            while r > 1 and r mod 2 != 0:\n                r =\
    \ r shr 1\n            if not f(self.mergeOp(self.arr[r], sm)):\n            \
    \    while r < self.lastnode:\n                    r = 2 * r + 1\n           \
    \         if f(self.mergeOp(self.arr[r], sm)):\n                        sm = self.mergeOp(self.arr[r],\
    \ sm)\n                        r -= 1\n                return r + 1 - self.lastnode\n\
    \            sm = self.mergeOp(self.arr[r], sm)\n            if (r and -r) ==\
    \ r:\n                break\n        return 0\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/segtree_static_op.nim
  requiredBy: []
  timestamp: '2026-09-02 04:31:06+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/segtree/segtree_static_op_test.nim
  - verify/collections/segtree/segtree_static_op_test.nim
documentation_of: cplib/collections/segtree_static_op.nim
layout: document
redirect_from:
- /library/cplib/collections/segtree_static_op.nim
- /library/cplib/collections/segtree_static_op.nim.html
title: cplib/collections/segtree_static_op.nim
---
