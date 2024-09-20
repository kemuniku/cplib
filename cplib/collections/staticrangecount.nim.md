---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':x:'
    path: verify/graph/merge_tree_test.nim
    title: verify/graph/merge_tree_test.nim
  - icon: ':x:'
    path: verify/graph/merge_tree_test.nim
    title: verify/graph/merge_tree_test.nim
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_STATIC_RANGE_COUNT:\n    const CPLIB_COLLECTIONS_STATIC_RANGE_COUNT*\
    \ = 1\n    import tables,algorithm\n    type StaticRangeCount[T] = object\n  \
    \      t : Table[T,seq[int]]\n\n    proc initStaticRangeCount*[T](v:seq[T]):StaticRangeCount[T]=\n\
    \        for i in 0..<len(v):\n            if v[i] in result.t:\n            \
    \    result.t[v[i]].add(i)\n            else:\n                result.t[v[i]]\
    \ = @[i]\n\n    proc count*[T](self:var StaticRangeCount[T],l,r:int,x:T):int=\n\
    \        if x notin self.t:\n            return 0\n        return self.t[x].lowerBound(r)-self.t[x].lowerBound(l)\n\
    \n    proc count*[T](self:var StaticRangeCount[T],R:HSlice[int,int],x:T):int=\n\
    \        if x notin self.t:\n            return 0\n        return self.t[x].upperBound(R.b)\
    \ - self.t[x].lowerBound(R.a)"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/staticrangecount.nim
  requiredBy: []
  timestamp: '2024-09-16 03:24:25+09:00'
  verificationStatus: LIBRARY_ALL_WA
  verifiedWith:
  - verify/graph/merge_tree_test.nim
  - verify/graph/merge_tree_test.nim
documentation_of: cplib/collections/staticrangecount.nim
layout: document
redirect_from:
- /library/cplib/collections/staticrangecount.nim
- /library/cplib/collections/staticrangecount.nim.html
title: cplib/collections/staticrangecount.nim
---
