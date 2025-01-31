---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/associative_array_test.nim
    title: verify/collections/associative_array_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/associative_array_test.nim
    title: verify/collections/associative_array_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/hashtable_abc340c_test.nim
    title: verify/collections/hashtable_abc340c_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/hashtable_abc340c_test.nim
    title: verify/collections/hashtable_abc340c_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/hashtable_yuki2686_test.nim
    title: verify/collections/hashtable_yuki2686_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/hashtable_yuki2686_test.nim
    title: verify/collections/hashtable_yuki2686_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_HASHTABLE:\n    const CPLIB_COLLECTIONS_HASHTABLE*\
    \ = 1\n    import bitops, sequtils, hashes\n    type State = enum\n        empty,\
    \ active, inactive\n    type Node[K, V] = object\n        state: State\n     \
    \   value: (K, V)\n    type HashTable*[K, V] = object\n        values*: seq[Node[K,\
    \ V]]\n        len: int\n        fill: int\n        mask: int\n    proc vlen(x:\
    \ int): int = (if x == 0: 4 else: 1 shl (fastLog2(x) + 2))\n    proc len*[K, V](self:\
    \ HashTable[K, V]): int = self.len\n    proc initHashTable*[K, V](): HashTable[K,\
    \ V] =\n        var vlen = 4\n        return HashTable[K, V](values: newSeqWith(vlen,\
    \ Node[K, V](state: State.empty)), len: 0, fill: 0, mask: vlen - 1)\n    proc\
    \ initHashTable*[K, V](capacity: int): HashTable[K, V] =\n        var vlen = capacity.vlen\n\
    \        return HashTable[K, V](values: newSeqWith(vlen, Node[K, V](state: State.empty)),\
    \ len: 0, fill: 0, mask: vlen - 1)\n    iterator pairs*[K, V](self: HashTable[K,\
    \ V]): (K, V) =\n        for item in self.values:\n            if item.state ==\
    \ State.active: yield item.value\n    iterator keys*[K, V](self: HashTable[K,\
    \ V]): K =\n        for item in self.values:\n            if item.state == State.active:\
    \ yield item.value[0]\n    iterator values*[K, V](self: HashTable[K, V]): V =\n\
    \        for item in self.values:\n            if item.state == State.active:\
    \ yield item.value[1]\n    proc find[K, V](self: HashTable[K, V], x: K): int =\n\
    \        var sh: int = hash(x) and self.mask\n        while self.values[sh].state\
    \ != State.empty and self.values[sh].value[0] != x:\n            sh = (sh + 1)\
    \ and self.mask\n        return sh\n    proc add_item[K, V](self: var HashTable[K,\
    \ V], key: K, val: V) =\n        var pos = self.find(key)\n        if self.values[pos].state\
    \ == State.active:\n            self.values[pos].value[1] = val\n            return\n\
    \        self.len += 1\n        self.fill += 1\n        self.values[pos].value\
    \ = (key, val)\n        self.values[pos].state = State.active\n    proc resize[K,\
    \ V](self: var HashTable[K, V]) =\n        var vlen = self.len.vlen\n        var\
    \ vi = newSeq[Node[K, V]](vlen)\n        self.mask = vlen - 1\n        self.len\
    \ = 0\n        self.fill = 0\n        swap(vi, self.values)\n        for item\
    \ in vi:\n            if item.state == State.empty: continue\n            var\
    \ (key, val) = item.value\n            self.add_item(key, val)\n    proc incl*[K,\
    \ V](self: var HashTable[K, V], val: (K, V)) =\n        self.add_item(val)\n \
    \       if self.fill.vlen > self.values.len: self.resize\n        # if self.fill\
    \ > self.values.len div HASHSET_INCL_RESIZE_RATIO: self.resize\n    proc contains*[K,\
    \ V](self: var HashTable[K, V], key: K): bool = (self.values[self.find(key)].state\
    \ == State.active)\n    proc hasKey*[K, V](self: var HashTable[K, V], key: K):\
    \ bool = self.contains(key)\n    proc `[]`*[K, V](self: HashTable[K, V], key:\
    \ K): V =\n        var pos = self.find(key)\n        assert self.values[pos].state\
    \ == State.active, \"Key \\\"\" & $key & \"\\\" not found\"\n        return self.values[pos].value[1]\n\
    \    proc `[]`*[K, V](self: var HashTable[K, V], key: K): var V =\n        var\
    \ pos = self.find(key)\n        assert self.values[pos].state == State.active,\
    \ \"Key \\\"\" & $key & \"\\\" not found\"\n        return self.values[pos].value[1]\n\
    \    proc `[]=`*[K, V](self: var HashTable[K, V], key: K, val: V) =\n        var\
    \ pos = self.find(key)\n        self.values[pos].value = (key, val)\n        self.values[pos].state\
    \ = State.active\n        self.len += 1\n        self.fill += 1\n        if self.fill.vlen\
    \ > self.values.len: self.resize\n    proc clear*[K, V](self: var HashTable[K,\
    \ V]) = self = initHashTable[K, V]()\n    proc del*[K, V](self: var HashTable[K,\
    \ V], key: K) =\n        var pos = self.find(key)\n        if self.values[pos].state\
    \ != State.active: return\n        self.len -= 1\n        self.values[pos].state\
    \ = State.inactive\n    proc excl*[K, V](self: var HashTable[K, V], key: K) =\
    \ self.del(key)\n    proc hash*[K, V](self: HashTable[K, V]): Hash =\n       \
    \ for item in self.pairs:\n            result = result !& hash(item)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/hashtable.nim
  requiredBy: []
  timestamp: '2024-03-21 10:21:36+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/hashtable_abc340c_test.nim
  - verify/collections/hashtable_abc340c_test.nim
  - verify/collections/hashtable_yuki2686_test.nim
  - verify/collections/hashtable_yuki2686_test.nim
  - verify/collections/associative_array_test.nim
  - verify/collections/associative_array_test.nim
documentation_of: cplib/collections/hashtable.nim
layout: document
redirect_from:
- /library/cplib/collections/hashtable.nim
- /library/cplib/collections/hashtable.nim.html
title: cplib/collections/hashtable.nim
---
