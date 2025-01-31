---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/hashset_abc336f_test.nim
    title: verify/collections/hashset_abc336f_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/hashset_abc336f_test.nim
    title: verify/collections/hashset_abc336f_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_HASHSET:\n    const CPLIB_COLLECTIONS_HASHSET*\
    \ = 1\n    import bitops, sequtils, hashes\n    type State = enum\n        empty,\
    \ active, inactive\n    type Node[T] = object\n        state: State\n        value:\
    \ T\n        # value: T or typeof(nil)\n    type HashSet*[T] = object\n      \
    \  values*: seq[Node[T]]\n        len: int\n        fill: int\n        mask: int\n\
    \    proc vlen(x: int): int = (if x == 0: 4 else: 1 shl (fastLog2(x) + 2))\n \
    \   proc initHashSet*[T](): HashSet[T] =\n        var vlen = 4\n        HashSet[T](values:\
    \ newSeqWith(vlen, Node[T](state: State.empty)), len: 0, fill: 0, mask: vlen -\
    \ 1)\n    iterator items*[T](self: HashSet[T]): T =\n        for item in self.values:\n\
    \            if item.state == State.active: yield item.value\n    proc find[T](self:\
    \ HashSet[T], x: T): int =\n        var sh: int = hash(x) and self.mask\n    \
    \    while self.values[sh].state != State.empty and self.values[sh].value != x:\n\
    \            sh = (sh + 1) and self.mask\n        return sh\n    proc add_item[T](self:\
    \ var HashSet[T], val: T) =\n        var pos = self.find(val)\n        if self.values[pos].state\
    \ == State.active: return\n        self.len += 1\n        self.fill += 1\n   \
    \     self.values[pos].value = val\n        self.values[pos].state = State.active\n\
    \    proc resize[T](self: var HashSet[T]) =\n        var vlen = self.len.vlen\n\
    \        var vi = newSeq[Node[T]](vlen)\n        self.mask = vlen - 1\n      \
    \  self.len = 0\n        self.fill = 0\n        swap(vi, self.values)\n      \
    \  for item in vi:\n            if item.state == State.empty: continue\n     \
    \       var val = item.value\n            self.add_item(val)\n    proc incl*[T](self:\
    \ var HashSet[T], val: T) =\n        self.add_item(val)\n        if self.fill.vlen\
    \ > self.values.len: self.resize\n        # if self.fill > self.values.len div\
    \ HASHSET_INCL_RESIZE_RATIO: self.resize\n    proc contains*[T](self: var HashSet[T],\
    \ val: T): bool = (self.values[self.find(val)].state == State.active)\n    proc\
    \ remove_item[T](self: var HashSet[T], val: T) =\n        var pos = self.find(val)\n\
    \        if self.values[pos].state != State.active: return\n        self.len -=\
    \ 1\n        self.values[pos].state = State.inactive\n    proc excl*[T](self:\
    \ var HashSet[T], val: T) =\n        self.remove_item(val)\n        # if self.fill\
    \ < self.values.len * HASHSET_INCL_RESIZE_RATIO: self.resize\n    proc toHashSet*[T](a:\
    \ openArray[T]): HashSet[T] =\n        result = initHashSet[T]()\n        for\
    \ item in a: result.incl(item)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/hashset.nim
  requiredBy: []
  timestamp: '2024-03-21 07:08:43+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/hashset_abc336f_test.nim
  - verify/collections/hashset_abc336f_test.nim
documentation_of: cplib/collections/hashset.nim
layout: document
redirect_from:
- /library/cplib/collections/hashset.nim
- /library/cplib/collections/hashset.nim.html
title: cplib/collections/hashset.nim
---
