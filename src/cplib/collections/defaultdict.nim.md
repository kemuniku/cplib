---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/defaultdict/defaultdict_abc235c_test.nim
    title: verify/collections/defaultdict/defaultdict_abc235c_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/defaultdict/defaultdict_abc235c_test.nim
    title: verify/collections/defaultdict/defaultdict_abc235c_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/defaultdict/defaultdict_abc278c_test.nim
    title: verify/collections/defaultdict/defaultdict_abc278c_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/defaultdict/defaultdict_abc278c_test.nim
    title: verify/collections/defaultdict/defaultdict_abc278c_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/defaultdict/defaultdict_abc278d_test.nim
    title: verify/collections/defaultdict/defaultdict_abc278d_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/defaultdict/defaultdict_abc278d_test.nim
    title: verify/collections/defaultdict/defaultdict_abc278d_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/defaultdict/defaultdict_unit_test.nim
    title: verify/collections/defaultdict/defaultdict_unit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/defaultdict/defaultdict_unit_test.nim
    title: verify/collections/defaultdict/defaultdict_unit_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_DEFAULTDICT:\n    const CPLIB_COLLECTIONS_DEFAULTDICT*\
    \ = 1\n    import tables, hashes\n    type DefaultDict*[K, V] = object\n     \
    \   table: Table[K, V]\n        default: V\n    proc initDefaultDict*[K, V](default:\
    \ V): DefaultDict[K, V] = DefaultDict[K, V](table: initTable[K, V](), default:\
    \ default)\n    proc `==`*[K, V](src, dst: DefaultDict[K, V]): bool = src.table\
    \ == dst.table\n    proc `[]=`*[K, V](d: var DefaultDict[K, V], key: K, val: V)\
    \ = d.table[key] = val\n    proc `[]`*[K, V](d: DefaultDict[K, V], key: K): V\
    \ =\n        if key notin d.table: return d.default()\n        return d.table[key]\n\
    \    proc `[]`*[K, V](d: var DefaultDict[K, V], key: K): var V =\n        if key\
    \ notin d.table: d.table[key] = d.default\n        return d.table[key]\n    proc\
    \ clear*[K, V](d: var DefaultDict[K, V]) = d.table = initTable[int, int](0)\n\
    \    proc contains*[K, V](d: var DefaultDict[K, V], key: K): bool = d.table.contains(key)\n\
    \    proc del*[K, V](d: var DefaultDict[K, V], key: K) = d.table.del(key)\n  \
    \  proc hash*[K, V](d: DefaultDict[K, V]): Hash = d.table.hash\n    proc hasKey*[K,\
    \ V](d: DefaultDict[K, V], key: K): bool = d.table.hasKey(key)\n    proc len*[K,\
    \ V](d: DefaultDict[K, V]): int = d.table.len\n    proc pop*[K, V](d: var DefaultDict,\
    \ key: K, val: var V): bool = d.table.pop(key, val)\n    proc take*[K, V](d: var\
    \ DefaultDict, key: K, val: var V): bool = d.table.pop(key, val)\n    proc toDefaultDict*[K,\
    \ V](pairs: openArray[(K, V)], default: V): DefaultDict[K, V] =\n        result\
    \ = initDefaultDict[K, V](default)\n        result.table = pairs.toTable\n   \
    \ proc toDefaultDict*[K, V](table: Table[K, V], default: V): DefaultDict[K, V]\
    \ =\n        result = initDefaultDict[K, V](default)\n        result.table = table\n\
    \    iterator pairs*[K, V](d: DefaultDict[K, V]): (K, V) =\n        for k, v in\
    \ d.table: yield (k, v)\n    proc `$`*[K, V](d: DefaultDict[K, V]): string = $(d.table)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/defaultdict.nim
  requiredBy: []
  timestamp: '2024-02-07 11:08:04+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/defaultdict/defaultdict_abc278d_test.nim
  - verify/collections/defaultdict/defaultdict_abc278d_test.nim
  - verify/collections/defaultdict/defaultdict_abc235c_test.nim
  - verify/collections/defaultdict/defaultdict_abc235c_test.nim
  - verify/collections/defaultdict/defaultdict_unit_test.nim
  - verify/collections/defaultdict/defaultdict_unit_test.nim
  - verify/collections/defaultdict/defaultdict_abc278c_test.nim
  - verify/collections/defaultdict/defaultdict_abc278c_test.nim
documentation_of: cplib/collections/defaultdict.nim
layout: document
redirect_from:
- /library/cplib/collections/defaultdict.nim
- /library/cplib/collections/defaultdict.nim.html
title: cplib/collections/defaultdict.nim
---
