---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/tatyamset/ABC217_gele_test.nim
    title: verify/collections/tatyamset/ABC217_gele_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/tatyamset/ABC217_gele_test.nim
    title: verify/collections/tatyamset/ABC217_gele_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/tatyamset/ABC217_gtlt_test.nim
    title: verify/collections/tatyamset/ABC217_gtlt_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/tatyamset/ABC217_gtlt_test.nim
    title: verify/collections/tatyamset/ABC217_gtlt_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/tatyamset/ABC217_index_test.nim
    title: verify/collections/tatyamset/ABC217_index_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/tatyamset/ABC217_index_test.nim
    title: verify/collections/tatyamset/ABC217_index_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/tatyamset/ABC234D_access_test.nim
    title: verify/collections/tatyamset/ABC234D_access_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/tatyamset/ABC234D_access_test.nim
    title: verify/collections/tatyamset/ABC234D_access_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/tatyamset/ABC236_test.nim
    title: verify/collections/tatyamset/ABC236_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/tatyamset/ABC236_test.nim
    title: verify/collections/tatyamset/ABC236_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/tatyamset/ABC294_test.nim
    title: verify/collections/tatyamset/ABC294_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/tatyamset/ABC294_test.nim
    title: verify/collections/tatyamset/ABC294_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/tatyamset/ABC337_test.nim
    title: verify/collections/tatyamset/ABC337_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/tatyamset/ABC337_test.nim
    title: verify/collections/tatyamset/ABC337_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/tatyamset/index_right_test.nim
    title: verify/collections/tatyamset/index_right_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/tatyamset/index_right_test.nim
    title: verify/collections/tatyamset/index_right_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links:
    - https://github.com/tatyam-prime/SortedSet/blob/main/SortedMultiset.py
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# https://github.com/tatyam-prime/SortedSet/blob/main/SortedMultiset.py\n\
    when not declared CPLIB_COLLECTIONS_TATYAMSET:\n    import algorithm, math, sequtils,\
    \ sugar\n    import options\n    const CPLIB_COLLECTIONS_TATYAMSET* = 1\n\n  \
    \  const BUCKET_RATIO = 8\n    const SPLIT_RATIO = 12\n    type SortedMultiSet*[T]\
    \ = ref object\n        size: int\n        arr*: seq[seq[T]]\n    proc initSortedMultiset*[T](v:\
    \ seq[T] = @[]): SortedMultiSet[T] =\n        #Make a new SortedMultiset from\
    \ seq. / O(N) if sorted / O(N log N)\n        var v = v\n        if not isSorted(v):\n\
    \            v.sort()\n        var n = len(v)\n        var bucket_size = int(ceil(sqrt(n/BUCKET_RATIO)))\n\
    \        var arr = collect(newseq): (for i in 0..<bucket_size: v[(n*i div bucket_size)\
    \ ..< (n*(i+1) div bucket_size)])\n        result = SortedMultiSet[T](size: n,\
    \ arr: arr)\n\n    proc len*(self: SortedMultiSet): int =\n        return self.size\n\
    \n    proc position[T](self: SortedMultiSet[T], x: T): (int, int) =\n        #\"\
    return the bucket, index of the bucket and position in which x should be. self\
    \ must not be empty.\"\n        for i in 0..<self.arr.len:\n            if x <=\
    \ self.arr[i][^1]:\n                return (i, self.arr[i].lowerBound(x))\n  \
    \      return (len(self.arr)-1, self.arr[^1].lowerBound(x))\n\n    proc contains*[T](self:\
    \ SortedMultiSet[T], x: T): bool =\n        if self.size == 0: return false\n\
    \        var (i, j) = self.position(x)\n        return j != len(self.arr[i]) and\
    \ self.arr[i][j] == x\n\n    proc incl*[T](self: SortedMultiSet[T], x: T) =\n\
    \        #\"Add an element. / O(\u221AN)\"\n        if self.size == 0:\n     \
    \       self.arr = @[@[x]]\n            self.size = 1\n            return\n  \
    \      var (b, i) = self.position(x)\n        self.arr[b].insert(x, i)\n     \
    \   self.size += 1\n        if len(self.arr[b]) > len(self.arr) * SPLIT_RATIO:\n\
    \            var mid = len(self.arr[b]) shr 1\n            self.arr.insert(self.arr[b][mid..<len(self.arr[b])],\
    \ b+1)\n            self.arr[b] = self.arr[b][0..<mid]\n\n    proc innerpop[T](self:\
    \ SortedMultiSet[T], b: int, i: int): T{.discardable.} =\n        var b = b\n\
    \        if b < 0:\n            b = self.size + b\n        var ans = self.arr[b][i]\n\
    \        self.arr[b].delete(i)\n        self.size -= 1\n        if len(self.arr[b])\
    \ == 0: self.arr.delete(b)\n        return ans\n\n    proc excl*[T](self: SortedMultiSet[T],\
    \ x: T): bool{.discardable.} =\n        #\"Remove an element and return True if\
    \ removed. / O(\u221AN)\"\n        if self.size == 0: return false\n        var\
    \ (b, i) = self.position(x)\n        if i == len(self.arr[b]) or self.arr[b][i]\
    \ != x: return false\n        self.innerpop(b, i)\n        return true\n\n   \
    \ proc lt*[T](self: SortedMultiSet[T], x: T): Option[T] =\n        #\"Find the\
    \ largest element < x, or None if it doesn't exist.\"\n        for i in countdown(len(self.arr)-1,\
    \ 0, 1):\n            if self.arr[i][0] < x:\n                return some(self.arr[i][lowerBound(self.arr[i],\
    \ x) - 1])\n        return none(T)\n\n    proc le*[T](self: SortedMultiSet[T],\
    \ x: T): Option[T] =\n        #\"Find the largest element <= x, or None if it\
    \ doesn't exist.\"\n        for i in countdown(len(self.arr)-1, 0, 1):\n     \
    \       if self.arr[i][0] <= x:\n                return some(self.arr[i][upperBound(self.arr[i],\
    \ x) - 1])\n        return none(T)\n\n    proc gt*[T](self: SortedMultiSet[T],\
    \ x: T): Option[T] =\n        #\"Find the smallest element > x, or None if it\
    \ doesn't exist.\"\n        for i in 0..<len(self.arr):\n            if self.arr[i][^1]\
    \ > x:\n                return some(self.arr[i][upperBound(self.arr[i], x)])\n\
    \        return none(T)\n\n    proc ge*[T](self: SortedMultiSet[T], x: T): Option[T]\
    \ =\n        #\"Find the smallest element >= x, or None if it doesn't exist.\"\
    \n        for i in 0..<len(self.arr):\n            if self.arr[i][^1] >= x:\n\
    \                return some(self.arr[i][lowerBound(self.arr[i], x)])\n      \
    \  return none(T)\n\n    proc `[]`*[T](self: SortedMultiSet[T], i: int): T =\n\
    \        var i = i\n        #\"Return the i-th element.\"\n        if i < 0:\n\
    \            for j in countdown(len(self.arr)-1, 0, 1):\n                i +=\
    \ len(self.arr[j])\n                if i >= 0: return self.arr[j][i]\n       \
    \ else:\n            for j in 0..<len(self.arr):\n                if i < len(self.arr[j]):\
    \ return self.arr[j][i]\n                i -= len(self.arr[j])\n        raise\
    \ newException(IndexDefect, \"index \" & $i & \" not in 0 .. \" & $(self.size-1))\n\
    \n    proc pop*[T](self: SortedMultiSet[T], i: int = -1): T =\n        #\"Pop\
    \ and return the i-th element.\"\n        var i = i\n        if i < 0:\n     \
    \       for b in countdown(len(self.arr)-1, 0, 1):\n                i += len(self.arr[b])\n\
    \                if i >= 0: return self.innerpop(not b, i)\n        else:\n  \
    \          for b in 0..<len(self.arr):\n                if i < len(self.arr[b]):\
    \ return self.innerpop(b, i)\n                i -= len(self.arr[b])\n        raise\
    \ newException(IndexDefect, \"index \" & $i & \" not in 0 .. \" & $(self.size-1))\n\
    \n    proc index*[T](self: SortedMultiSet[T], x: T): int =\n        #\"Count the\
    \ number of elements < x.\"\n        for i in 0..<len(self.arr):\n           \
    \ if self.arr[i][^1] >= x:\n                return result + lowerBound(self.arr[i],\
    \ x)\n            result += len(self.arr[i])\n\n    proc index_right*[T](self:\
    \ SortedMultiSet[T], x: T): int =\n        #\"Count the number of elements <=\
    \ x.\"\n        for i in 0..<len(self.arr):\n            if self.arr[i][^1] >\
    \ x:\n                return result + upperBound(self.arr[i], x)\n           \
    \ result += len(self.arr[i])\n    proc count*[T](self: SortedMultiSet[T], x: T):\
    \ int =\n        #\"Count the number of x.\"\n        return self.index_right(x)\
    \ - self.index(x)\n\n    iterator items*[T](self: SortedMultiSet[T]): T =\n  \
    \      for i in 0..<len(self.arr):\n            for j in self.arr[i]:\n      \
    \          yield j\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/tatyamset.nim
  requiredBy: []
  timestamp: '2024-04-23 21:11:58+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/tatyamset/ABC217_index_test.nim
  - verify/collections/tatyamset/ABC217_index_test.nim
  - verify/collections/tatyamset/ABC294_test.nim
  - verify/collections/tatyamset/ABC294_test.nim
  - verify/collections/tatyamset/ABC217_gele_test.nim
  - verify/collections/tatyamset/ABC217_gele_test.nim
  - verify/collections/tatyamset/ABC234D_access_test.nim
  - verify/collections/tatyamset/ABC234D_access_test.nim
  - verify/collections/tatyamset/ABC217_gtlt_test.nim
  - verify/collections/tatyamset/ABC217_gtlt_test.nim
  - verify/collections/tatyamset/index_right_test.nim
  - verify/collections/tatyamset/index_right_test.nim
  - verify/collections/tatyamset/ABC236_test.nim
  - verify/collections/tatyamset/ABC236_test.nim
  - verify/collections/tatyamset/ABC337_test.nim
  - verify/collections/tatyamset/ABC337_test.nim
documentation_of: cplib/collections/tatyamset.nim
layout: document
redirect_from:
- /library/cplib/collections/tatyamset.nim
- /library/cplib/collections/tatyamset.nim.html
title: cplib/collections/tatyamset.nim
---
