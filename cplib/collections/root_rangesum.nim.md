---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/root_rangesum_test.nim
    title: verify/collections/root_rangesum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/root_rangesum_test.nim
    title: verify/collections/root_rangesum_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_ROOTRANGESUM:\n    const CPLIB_COLLECTIONS_ROOTRANGESUM*\
    \ = 1\n    import algorithm, strutils,sequtils,math\n    type RootRangeSum*[T]\
    \ = ref object\n        blocksize : int\n        length : int\n        arr : seq[T]\n\
    \        blockvalue : seq[T]\n        e : T\n    proc initrangesum*[T](v:seq[T],bsize:int\
    \ = v.len.float.sqrt.int(),e:T=0):RootRangeSum[T]=\n        var b = newseqwith((len(v)+bsize-1)\
    \ div bsize,e)\n        result = RootRangeSum[T](blocksize:bsize,length:len(v),arr:v,blockvalue:b,e:e)\n\
    \        for i in 0..<(len(v)):\n            result.blockvalue[i div bsize] =\
    \ result.blockvalue[i div bsize] + v[i]\n\n    proc update*[T](self: RootRangeSum[T],\
    \ idx: Natural, val: T) =\n        ## idx\u306E\u8981\u7D20\u3092val\u306B\u5909\
    \u66F4\u3057\u307E\u3059\u3002\n        assert idx < self.length\n        self.blockvalue[idx\
    \ div self.blocksize] = self.blockvalue[idx div self.blocksize] + val - self.arr[idx]\n\
    \        self.arr[idx] = val\n    proc get*[T](self: RootRangeSum[T], q_left:\
    \ Natural, q_right: Natural): T =\n        ## \u534A\u89E3\u533A\u9593[q_left,q_right)\u306B\
    \u3064\u3044\u3066\u306E\u6F14\u7B97\u7D50\u679C\u3092\u8FD4\u3057\u307E\u3059\
    \u3002\n        result = self.e\n        let bidx_left = (q_left div self.blocksize)\n\
    \        let bidx_right = (q_right div self.blocksize)\n        assert q_left\
    \ <= q_right and 0 <= q_left and q_right <= self.length\n        if  bidx_left\
    \ == bidx_right:\n            for i in q_left..<q_right:\n                result\
    \ = result + self.arr[i]\n            return result\n\n        for i in q_left..<(bidx_left+1)*self.blocksize:\n\
    \            result = result + self.arr[i]\n        for bidx in (bidx_left+1)..<(bidx_right):\n\
    \            result = result + self.blockvalue[bidx]\n        for i in (bidx_right*self.blocksize)..<q_right:\n\
    \            result = result + self.arr[i]\n    proc get*[T](self: RootRangeSum[T],\
    \ segment: HSlice[int, int]): T =\n        assert segment.a <= segment.b + 1 and\
    \ 0 <= segment.a and segment.b+1 <= self.length\n        return self.get(segment.a,\
    \ segment.b+1)\n    proc `[]`*[T](self: RootRangeSum[T], segment: HSlice[int,\
    \ int]): T = self.get(segment)\n    proc `[]`*[T](self: RootRangeSum[T], index:\
    \ Natural): T =\n        assert index < self.length\n        return self.arr[index]\n\
    \    proc `[]=`*[T](self: RootRangeSum[T], index: Natural, val: T) =\n       \
    \ assert index < self.length\n        self.update(index, val)\n    proc len*[T](self:\
    \ RootRangeSum[T]): int =\n        return self.length\n    proc `$`*[T](self:\
    \ RootRangeSum[T]): string =\n        var s = self.arr.len div 2\n        return\
    \ $self.arr\n    proc max_right*[T](self: RootRangeSum[T], l: int, f: proc(l:\
    \ T): bool): int =\n        assert 0 <= l and l <= self.len\n        assert f(self.e)\n\
    \        if l == self.len: return self.len\n        var sm = self.e\n        let\
    \ bidx_left = (l div self.blocksize)\n        for i in l..<(bidx_left+1)*self.blocksize:\n\
    \            if not f(sm + self.arr[i]):\n                return i\n         \
    \   else:\n                sm = sm + self.arr[i]\n        for bi in (bidx_left+1)..<len(self.blockvalue):\n\
    \            if not f(sm + self.blockvalue[bi]):\n                for i in bi*self.blocksize..<(bi+1)*self.blocksize:\n\
    \                    if i notin 0..<len(self.arr):\n                        return\
    \ i\n                    if not f(sm + self.arr[i]):\n                       \
    \ return i\n                    else:\n                        sm = sm + self.arr[i]\n\
    \            else:\n                sm = sm + self.blockvalue[bi]\n        return\
    \ len(self.arr)\n    proc min_left*[T](self: RootRangeSum[T], r: int, f: proc(l:\
    \ T): bool): int =\n        assert 0 <= r and r <= self.len\n        assert f(self.default)\n\
    \        if r == 0: return 0\n        var sm = self.e\n        let bidx_right\
    \ = (r div self.blocksize)\n        for i in countdown(r,(bidx_right)*self.blocksize):\n\
    \            if not f(sm + self.arr[i]):\n                return i+1\n       \
    \     else:\n                sm = sm + self.arr[i]\n        for bi in countdown((bidx_right-1),0):\n\
    \            if not f(sm + self.blockvalue[bi]):\n                for i in countdown((bi)*self.blocksize+1,bi*self.blocksize):\n\
    \                    if i notin 0..<len(self.arr):\n                        return\
    \ i+1\n                    if not f(sm + self.arr[i]):\n                     \
    \   return i+1\n                    else:\n                        sm = sm + self.arr[i]\n\
    \            else:\n                sm = sm + self.blockvalue[bi]\n        return\
    \ 0"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/root_rangesum.nim
  requiredBy: []
  timestamp: '2024-08-17 04:11:20+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/root_rangesum_test.nim
  - verify/collections/root_rangesum_test.nim
documentation_of: cplib/collections/root_rangesum.nim
layout: document
redirect_from:
- /library/cplib/collections/root_rangesum.nim
- /library/cplib/collections/root_rangesum.nim.html
title: cplib/collections/root_rangesum.nim
---
