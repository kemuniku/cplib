---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/root_rangesum_test.nim
    title: verify/AI/root_rangesum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/root_rangesum_test.nim
    title: verify/AI/root_rangesum_test.nim
  - icon: ':x:'
    path: verify/collections/range_kth_smallest_test.nim
    title: verify/collections/range_kth_smallest_test.nim
  - icon: ':x:'
    path: verify/collections/range_kth_smallest_test.nim
    title: verify/collections/range_kth_smallest_test.nim
  - icon: ':x:'
    path: verify/collections/root_rangesum_test.nim
    title: verify/collections/root_rangesum_test.nim
  - icon: ':x:'
    path: verify/collections/root_rangesum_test.nim
    title: verify/collections/root_rangesum_test.nim
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':question:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_ROOTRANGESUM:\n    const CPLIB_COLLECTIONS_ROOTRANGESUM*\
    \ = 1\n    import algorithm, strutils,sequtils,math\n    type RootRangeSum*[T]\
    \ = ref object\n        blocksize : int\n        length : int\n        arr : seq[T]\n\
    \        blockvalue : seq[T]\n        e : T\n    proc initrangesum*[T](v:openArray[T],bsize:int\
    \ = 0,e:T=0):RootRangeSum[T]=\n        let actualBlockSize = if bsize > 0: bsize\
    \ else: max(v.len.float.sqrt.int(), 1)\n        var b = newseqwith((len(v)+actualBlockSize-1)\
    \ div actualBlockSize,e)\n        result = RootRangeSum[T](blocksize:actualBlockSize,length:len(v),arr:\
    \ @v,blockvalue:b,e:e)\n        for i in 0..<(len(v)):\n            result.blockvalue[i\
    \ div actualBlockSize] = result.blockvalue[i div actualBlockSize] + v[i]\n\n \
    \   proc update*[T](self: RootRangeSum[T], idx: Natural, val: T) =\n        ##\
    \ idx\u306E\u8981\u7D20\u3092val\u306B\u5909\u66F4\u3057\u307E\u3059\u3002\n \
    \       assert idx < self.length, \"\u6307\u5B9A\u3057\u305F\u5024\u304C\u6709\
    \u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059: idx < self.length\"\n        self.blockvalue[idx div self.blocksize]\
    \ = self.blockvalue[idx div self.blocksize] + val - self.arr[idx]\n        self.arr[idx]\
    \ = val\n    proc get*[T](self: RootRangeSum[T], q_left: Natural, q_right: Natural):\
    \ T =\n        ## \u534A\u89E3\u533A\u9593[q_left,q_right)\u306B\u3064\u3044\u3066\
    \u306E\u6F14\u7B97\u7D50\u679C\u3092\u8FD4\u3057\u307E\u3059\u3002\n        result\
    \ = self.e\n        let bidx_left = (q_left div self.blocksize)\n        let bidx_right\
    \ = (q_right div self.blocksize)\n        assert q_left <= q_right and 0 <= q_left\
    \ and q_right <= self.length, \"\u6307\u5B9A\u3057\u305F\u533A\u9593\u304C\u6709\
    \u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059: q_left <= q_right and 0 <= q_left and q_right <= self.length\"\n\
    \        if  bidx_left == bidx_right:\n            for i in q_left..<q_right:\n\
    \                result = result + self.arr[i]\n            return result\n\n\
    \        for i in q_left..<(bidx_left+1)*self.blocksize:\n            result =\
    \ result + self.arr[i]\n        for bidx in (bidx_left+1)..<(bidx_right):\n  \
    \          result = result + self.blockvalue[bidx]\n        for i in (bidx_right*self.blocksize)..<q_right:\n\
    \            result = result + self.arr[i]\n    proc get*[T](self: RootRangeSum[T],\
    \ segment: HSlice[int, int]): T =\n        assert segment.a <= segment.b + 1 and\
    \ 0 <= segment.a and segment.b+1 <= self.length, \"\u6307\u5B9A\u3057\u305F\u533A\
    \u9593\u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\
    \u304C\u3042\u308A\u307E\u3059: segment.a <= segment.b + 1 and 0 <= segment.a\
    \ and segment.b + 1 <= self.length\"\n        return self.get(segment.a, segment.b+1)\n\
    \    proc `[]`*[T](self: RootRangeSum[T], segment: HSlice[int, int]): T = self.get(segment)\n\
    \    proc `[]`*[T](self: RootRangeSum[T], index: Natural): T =\n        assert\
    \ index < self.length, \"\u6307\u5B9A\u3057\u305F\u5024\u304C\u6709\u52B9\u306A\
    \u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\
    : index < self.length\"\n        return self.arr[index]\n    proc `[]=`*[T](self:\
    \ RootRangeSum[T], index: Natural, val: T) =\n        assert index < self.length,\
    \ \"\u6307\u5B9A\u3057\u305F\u5024\u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\
    \u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059: index < self.length\"\n\
    \        self.update(index, val)\n    proc len*[T](self: RootRangeSum[T]): int\
    \ =\n        return self.length\n    proc `$`*[T](self: RootRangeSum[T]): string\
    \ =\n        var s = self.arr.len div 2\n        return $self.arr\n    proc max_right*[T](self:\
    \ RootRangeSum[T], l: int, f: proc(l: T): bool): int =\n        assert 0 <= l\
    \ and l <= self.len, \"\u6307\u5B9A\u3057\u305F\u5024\u304C\u6709\u52B9\u306A\u7BC4\
    \u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059: 0 <=\
    \ l and l <= self.len\"\n        assert f(self.e), \"\u5224\u5B9A\u95A2\u6570\u306F\
    \u5358\u4F4D\u5143\u306B\u5BFE\u3057\u3066true\u3092\u8FD4\u3059\u5FC5\u8981\u304C\
    \u3042\u308A\u307E\u3059\"\n        if l == self.len: return self.len\n      \
    \  var sm = self.e\n        let bidx_left = (l div self.blocksize)\n        for\
    \ i in l..<min((bidx_left+1)*self.blocksize, self.len):\n            if not f(sm\
    \ + self.arr[i]):\n                return i\n            else:\n             \
    \   sm = sm + self.arr[i]\n        for bi in (bidx_left+1)..<len(self.blockvalue):\n\
    \            if not f(sm + self.blockvalue[bi]):\n                for i in bi*self.blocksize..<(bi+1)*self.blocksize:\n\
    \                    if i notin 0..<len(self.arr):\n                        return\
    \ i\n                    if not f(sm + self.arr[i]):\n                       \
    \ return i\n                    else:\n                        sm = sm + self.arr[i]\n\
    \            else:\n                sm = sm + self.blockvalue[bi]\n        return\
    \ len(self.arr)\n    proc min_left*[T](self: RootRangeSum[T], r: int, f: proc(l:\
    \ T): bool): int =\n        assert 0 <= r and r <= self.len, \"\u6307\u5B9A\u3057\
    \u305F\u5024\u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\
    \u8981\u304C\u3042\u308A\u307E\u3059: 0 <= r and r <= self.len\"\n        assert\
    \ f(self.e), \"\u5224\u5B9A\u95A2\u6570\u306F\u5358\u4F4D\u5143\u306B\u5BFE\u3057\
    \u3066true\u3092\u8FD4\u3059\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n   \
    \     if r == 0: return 0\n        var sm = self.e\n        let bidx_right = ((r-1)\
    \ div self.blocksize)\n        for i in countdown(r-1, bidx_right*self.blocksize):\n\
    \            if not f(sm + self.arr[i]):\n                return i+1\n       \
    \     else:\n                sm = sm + self.arr[i]\n        for bi in countdown(bidx_right-1,\
    \ 0):\n            if not f(sm + self.blockvalue[bi]):\n                for i\
    \ in countdown(min((bi+1)*self.blocksize, self.len)-1, bi*self.blocksize):\n \
    \                   if i notin 0..<len(self.arr):\n                        return\
    \ i+1\n                    if not f(sm + self.arr[i]):\n                     \
    \   return i+1\n                    else:\n                        sm = sm + self.arr[i]\n\
    \            else:\n                sm = sm + self.blockvalue[bi]\n        return\
    \ 0\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/root_rangesum.nim
  requiredBy: []
  timestamp: '2026-09-13 17:15:27+09:00'
  verificationStatus: LIBRARY_SOME_WA
  verifiedWith:
  - verify/collections/range_kth_smallest_test.nim
  - verify/collections/range_kth_smallest_test.nim
  - verify/collections/root_rangesum_test.nim
  - verify/collections/root_rangesum_test.nim
  - verify/AI/root_rangesum_test.nim
  - verify/AI/root_rangesum_test.nim
documentation_of: cplib/collections/root_rangesum.nim
layout: document
redirect_from:
- /library/cplib/collections/root_rangesum.nim
- /library/cplib/collections/root_rangesum.nim.html
title: cplib/collections/root_rangesum.nim
---
