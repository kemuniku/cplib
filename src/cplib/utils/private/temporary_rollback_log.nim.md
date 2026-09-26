---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/auto_rollback.nim
    title: cplib/utils/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/auto_rollback.nim
    title: cplib/utils/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/offline_dynamic_queries.nim
    title: cplib/utils/offline_dynamic_queries.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/offline_dynamic_queries.nim
    title: cplib/utils/offline_dynamic_queries.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/auto_rollback.nim
    title: cplib/utils/private/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/auto_rollback.nim
    title: cplib/utils/private/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/rollback_mo.nim
    title: cplib/utils/rollback_mo.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/rollback_mo.nim
    title: cplib/utils/rollback_mo.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/auto_rollback_scope_test.nim
    title: verify/AI/auto_rollback_scope_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/auto_rollback_scope_test.nim
    title: verify/AI/auto_rollback_scope_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/auto_rollback_test.nim
    title: verify/AI/auto_rollback_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/auto_rollback_test.nim
    title: verify/AI/auto_rollback_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/auto_rollback_values_test.nim
    title: verify/AI/auto_rollback_values_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/auto_rollback_values_test.nim
    title: verify/AI/auto_rollback_values_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/offline_dynamic_queries_test.nim
    title: verify/AI/offline_dynamic_queries_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/offline_dynamic_queries_test.nim
    title: verify/AI/offline_dynamic_queries_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/rollback_mo_test.nim
    title: verify/AI/rollback_mo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/rollback_mo_test.nim
    title: verify/AI/rollback_mo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/temporary_index_cache_test.nim
    title: verify/AI/temporary_index_cache_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/temporary_index_cache_test.nim
    title: verify/AI/temporary_index_cache_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/temporary_rollback_log_test.nim
    title: verify/AI/temporary_rollback_log_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/temporary_rollback_log_test.nim
    title: verify/AI/temporary_rollback_log_test.nim
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
  code: "when not declared CPLIB_UTILS_PRIVATE_TEMPORARY_ROLLBACK_LOG:\n    const\
    \ CPLIB_UTILS_PRIVATE_TEMPORARY_ROLLBACK_LOG* = 1\n    import tables, typetraits\n\
    \n    type\n        TemporaryLocation = tuple[address: pointer, size: int]\n \
    \       TemporaryIndexCache* = object\n            stamps: seq[int]\n        \
    \    owner: pointer\n            base: pointer\n            size, length: int\n\
    \        TemporaryEntry = object\n            location: TemporaryLocation\n  \
    \          previous: int\n            offset: int\n            stamp: ptr int\n\
    \        TemporaryRollbackLog* = object\n            entries: seq[TemporaryEntry]\n\
    \            latest: Table[TemporaryLocation, int]\n            scopeStart: int\n\
    \            saved: seq[byte]\n            used: int\n            caches: seq[ptr\
    \ TemporaryIndexCache]\n        TemporaryCheckpoint* = tuple[position, parentStart:\
    \ int]\n\n    proc len*(history: TemporaryRollbackLog): int =\n        ## \u73FE\
    \u5728\u4FDD\u5B58\u3057\u3066\u3044\u308B\u5FA9\u5143\u51E6\u7406\u306E\u6570\
    \u3092\u8FD4\u3059\u3002O(1)\u3002\n        history.entries.len\n\n    proc indexCapacity*(cache:\
    \ TemporaryIndexCache): int =\n        ## \u518D\u5229\u7528\u3059\u308B\u6DFB\
    \u5B57\u5224\u5B9A\u9818\u57DF\u306E\u9577\u3055\u3092\u8FD4\u3059\u3002O(1)\u3002\
    \n        cache.stamps.len\n\n    proc saveValue[T](history: var TemporaryRollbackLog,\
    \ location: ptr T,\n            previous: int, stamp: ptr int = nil) =\n     \
    \   ## \u521D\u56DE\u306E\u5024\u3092\u9023\u7D9A\u30D0\u30C3\u30D5\u30A1\u3078\
    \u4FDD\u5B58\u3059\u308B\u3002\u6642\u9593\u30FB\u9818\u57DF\u306F\u5024\u306E\
    \u30B5\u30A4\u30BA\u306B\u6BD4\u4F8B\u3059\u308B\u3002\n        when not supportsCopyMem(T):\n\
    \            {.error: \"Temporary\u306E\u5C65\u6B74\u306B\u306F\u53C2\u7167\u7BA1\
    \u7406\u3084\u72EC\u81EA\u306E\u30B3\u30D4\u30FC\u30FB\u7834\u68C4\u51E6\u7406\
    \u3092\u5FC5\u8981\u3068\u3057\u306A\u3044\u578B\u3060\u3051\u4FDD\u5B58\u3067\
    \u304D\u307E\u3059\".}\n        let key: TemporaryLocation = (cast[pointer](location),\
    \ sizeof(T))\n        let offset = history.used\n        let required = offset\
    \ + sizeof(T)\n        when sizeof(T) > 0:\n            if required > history.saved.len:\n\
    \                let capacity = max(required, max(64, history.saved.len * 2))\n\
    \                when declared(newSeqUninit):\n                    var grown =\
    \ newSeqUninit[byte](capacity)\n                else:\n                    var\
    \ grown = newSeqUninitialized[byte](capacity)\n                if offset > 0:\n\
    \                    copyMem(addr grown[0], addr history.saved[0], offset)\n \
    \               history.saved = move(grown)\n            copyMem(addr history.saved[offset],\
    \ location, sizeof(T))\n        history.entries.add(TemporaryEntry(location: key,\
    \ previous: previous, offset: offset, stamp: stamp))\n        history.used = required\n\
    \n    proc remember*[T](history: var TemporaryRollbackLog, location: ptr T) =\n\
    \        ## \u540C\u3058\u30B9\u30B3\u30FC\u30D7\u3067\u306F\u540C\u3058\u30A2\
    \u30C9\u30EC\u30B9\u30FB\u30B5\u30A4\u30BA\u306E\u6700\u521D\u306E\u5024\u3060\
    \u3051\u3092\u4FDD\u5B58\u3059\u308B\u3002\u91CD\u8907\u5224\u5B9A\u306F\u671F\
    \u5F85O(1)\u3002\n        let key: TemporaryLocation = (cast[pointer](location),\
    \ sizeof(T))\n        let latest = addr history.latest.mgetOrPut(key, -1)\n  \
    \      let previous = latest[]\n        if previous >= history.scopeStart: return\n\
    \        let index = history.entries.len\n        history.saveValue(location,\
    \ previous)\n        latest[] = index\n\n    proc rememberIndexed*[T](history:\
    \ var TemporaryRollbackLog, location, base: ptr T,\n            length: int, cache:\
    \ var TemporaryIndexCache) =\n        ## \u914D\u5217\u8981\u7D20\u3092\u6DFB\u5B57\
    \u3067\u5224\u5B9A\u3059\u308B\u3002\u9818\u57DF\u62E1\u5F35\u306F\u511F\u5374\
    O(\u5897\u52A0\u5206)\u3001\u901A\u5E38\u306E\u5224\u5B9A\u306FO(1)\u3002\n  \
    \      ## \u914D\u5217\u306E\u6DF7\u5728\u3084\u518D\u5165\u6642\u306F\u30CF\u30C3\
    \u30B7\u30E5\u5224\u5B9A\u3078\u623B\u3057\u3001\u4F7F\u7528\u4E2D\u306E\u5224\
    \u5B9A\u9818\u57DF\u3092\u5909\u66F4\u3057\u306A\u3044\u3002\n        when sizeof(T)\
    \ == 0:\n            history.remember(location)\n        else:\n            let\
    \ owner = cast[pointer](addr history)\n            if cache.owner == nil:\n  \
    \              if length > cache.stamps.len: cache.stamps.setLen(length)\n   \
    \             cache.owner = owner\n                cache.base = cast[pointer](base)\n\
    \                cache.size = sizeof(T)\n                cache.length = length\n\
    \                history.caches.add(addr cache)\n            if cache.owner !=\
    \ owner or cache.base != cast[pointer](base) or\n                    cache.size\
    \ != sizeof(T) or cache.length != length:\n                history.remember(location)\n\
    \                return\n            let offset = cast[uint](location) - cast[uint](base)\n\
    \            let index = offset div uint(sizeof(T))\n            if index >= uint(length)\
    \ or offset mod uint(sizeof(T)) != 0:\n                history.remember(location)\n\
    \                return\n            let stamp = addr cache.stamps[int(index)]\n\
    \            let previous = stamp[] - 1\n            if previous >= history.scopeStart:\
    \ return\n            let entry = history.entries.len\n            history.saveValue(location,\
    \ previous, stamp)\n            stamp[] = entry + 1\n\n    proc restore*(history:\
    \ var TemporaryRollbackLog, position: int) =\n        ## \u4FDD\u5B58\u9806\u306E\
    \u9006\u9806\u3067\u5FA9\u5143\u3059\u308B\u3002\u7BC4\u56F2\u304C\u91CD\u306A\
    \u308B\u5024\u3082\u6700\u521D\u306E\u72B6\u614B\u3078\u623B\u308B\u3002\n   \
    \     ## \u4FDD\u5B58\u30D0\u30C3\u30D5\u30A1\u306F\u7E2E\u3081\u305A\u3001\u540C\
    \u3058\u5C65\u6B74\u3067\u6B21\u306B\u4FDD\u5B58\u3059\u308B\u969B\u306B\u518D\
    \u5229\u7528\u3059\u308B\u3002\n        while history.entries.len > position:\n\
    \            let entry = history.entries.pop()\n            if entry.location.size\
    \ > 0:\n                copyMem(entry.location.address, addr history.saved[entry.offset],\
    \ entry.location.size)\n            history.used = entry.offset\n            if\
    \ entry.stamp != nil:\n                # \u8A2A\u554F\u3057\u305F\u6DFB\u5B57\u3060\
    \u3051\u3092\u623B\u3059\u305F\u3081\u3001\u7E70\u308A\u8FD4\u3057\u5B9F\u884C\
    \u6642\u306E\u5168\u521D\u671F\u5316\u306F\u4E0D\u8981\u3002\n               \
    \ entry.stamp[] = entry.previous + 1\n            elif entry.previous < 0:\n \
    \               history.latest.del(entry.location)\n            else:\n      \
    \          history.latest[entry.location] = entry.previous\n        if history.entries.len\
    \ == 0:\n            for cache in history.caches: cache.owner = nil\n        \
    \    history.caches.setLen(0)\n\n    proc beginTemporary*(history: var TemporaryRollbackLog):\
    \ TemporaryCheckpoint =\n        ## \u5165\u308C\u5B50\u306E\u958B\u59CB\u4F4D\
    \u7F6E\u3092\u4FDD\u5B58\u3057\u3001\u65B0\u3057\u3044\u30B9\u30B3\u30FC\u30D7\
    \u3067\u91CD\u8907\u3092\u5224\u5B9A\u3059\u308B\u3002O(1)\u3002\n        result\
    \ = (history.entries.len, history.scopeStart)\n        history.scopeStart = history.entries.len\n\
    \n    proc endTemporary*(history: var TemporaryRollbackLog, checkpoint: TemporaryCheckpoint)\
    \ =\n        ## \u5165\u308C\u5B50\u306E\u5909\u66F4\u3092\u5FA9\u5143\u3057\u3001\
    \u89AA\u30B9\u30B3\u30FC\u30D7\u306E\u91CD\u8907\u5224\u5B9A\u306B\u623B\u3059\
    \u3002\n        history.restore(checkpoint.position)\n        history.scopeStart\
    \ = checkpoint.parentStart\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/private/temporary_rollback_log.nim
  requiredBy:
  - cplib/utils/auto_rollback.nim
  - cplib/utils/auto_rollback.nim
  - cplib/utils/rollback_mo.nim
  - cplib/utils/rollback_mo.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/offline_dynamic_queries.nim
  - cplib/utils/offline_dynamic_queries.nim
  timestamp: '2026-09-23 01:31:00+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/auto_rollback_scope_test.nim
  - verify/AI/auto_rollback_scope_test.nim
  - verify/AI/temporary_rollback_log_test.nim
  - verify/AI/temporary_rollback_log_test.nim
  - verify/AI/offline_dynamic_queries_test.nim
  - verify/AI/offline_dynamic_queries_test.nim
  - verify/AI/temporary_index_cache_test.nim
  - verify/AI/temporary_index_cache_test.nim
  - verify/AI/rollback_mo_test.nim
  - verify/AI/rollback_mo_test.nim
  - verify/AI/auto_rollback_test.nim
  - verify/AI/auto_rollback_test.nim
  - verify/AI/auto_rollback_values_test.nim
  - verify/AI/auto_rollback_values_test.nim
documentation_of: cplib/utils/private/temporary_rollback_log.nim
layout: document
redirect_from:
- /library/cplib/utils/private/temporary_rollback_log.nim
- /library/cplib/utils/private/temporary_rollback_log.nim.html
title: cplib/utils/private/temporary_rollback_log.nim
---
