---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/auto_rollback.nim
    title: cplib/utils/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/auto_rollback.nim
    title: cplib/utils/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/auto_rollback.nim
    title: cplib/utils/private/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/auto_rollback.nim
    title: cplib/utils/private/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/temporary_rollback_log.nim
    title: cplib/utils/private/temporary_rollback_log.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/temporary_rollback_log.nim
    title: cplib/utils/private/temporary_rollback_log.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import cplib/utils/auto_rollback\nimport cplib/utils/private/temporary_rollback_log\n\
    \nblock:\n    var cache: TemporaryIndexCache\n    var values = newSeq[int](1000000)\n\
    \    for iteration in 0..<2000:\n        var history: TemporaryRollbackLog\n \
    \       let index = (iteration * 719) mod values.len\n        for repeat in 0..<10:\n\
    \            history.rememberIndexed(addr values[index], addr values[0], values.len,\
    \ cache)\n            inc values[index]\n        doAssert history.len == 1\n \
    \       doAssert cache.indexCapacity == values.len\n        history.restore(0)\n\
    \        doAssert values[index] == 0\n\nblock:\n    var values = newSeq[int](1000000)\n\
    \    for iteration in 0..<2000:\n        let value = Temporary:\n            values[iteration]\
    \ = iteration + 1\n            values[iteration]\n        doAssert value == iteration\
    \ + 1 and values[iteration] == 0\n\nblock:\n    var cache: TemporaryIndexCache\n\
    \    var history: TemporaryRollbackLog\n    var values = [1, 2]\n    var other\
    \ = [3, 4]\n    history.rememberIndexed(addr values[0], addr values[0], values.len,\
    \ cache)\n    values[0] = 10\n    let inner = history.beginTemporary()\n    history.rememberIndexed(addr\
    \ values[0], addr values[0], values.len, cache)\n    values[0] = 20\n    history.rememberIndexed(addr\
    \ values[0], addr values[0], values.len, cache)\n    values[0] = 30\n    history.rememberIndexed(addr\
    \ other[0], addr other[0], other.len, cache)\n    other[0] = 40\n    history.rememberIndexed(addr\
    \ other[0], addr other[0], other.len, cache)\n    other[0] = 50\n    doAssert\
    \ history.len == 3\n    var separate: TemporaryRollbackLog\n    separate.rememberIndexed(addr\
    \ values[0], addr values[0], values.len, cache)\n    values[0] = 100\n    separate.restore(0)\n\
    \    doAssert values[0] == 30\n    history.endTemporary(inner)\n    doAssert values\
    \ == [10, 2] and other == [3, 4]\n    history.rememberIndexed(addr values[0],\
    \ addr values[0], values.len, cache)\n    values[0] = 11\n    doAssert history.len\
    \ == 1\n    history.restore(0)\n    doAssert values == [1, 2]\n    history.rememberIndexed(addr\
    \ other[1], addr other[0], other.len, cache)\n    other[1] = 100\n    history.restore(0)\n\
    \    doAssert other == [3, 4]\n\nblock:\n    var cache: TemporaryIndexCache\n\
    \    for size in [1, 100, 3, 1000, 0, 7]:\n        var values = newSeq[int](size)\n\
    \        var history: TemporaryRollbackLog\n        for i in 0..<size:\n     \
    \       history.rememberIndexed(addr values[i], addr values[0], size, cache)\n\
    \            values[i] = i + 1\n        history.restore(0)\n        for value\
    \ in values: doAssert value == 0\n    doAssert cache.indexCapacity == 1000\n\n\
    block:\n    var values = @[1, 2, 3]\n    proc updateItems() =\n        Temporary:\n\
    \            for i in 0..<values.len:\n                values[i] += 10\n     \
    \           values[i] *= 2\n                Temporary:\n                    values[i]\
    \ = -1\n                doAssert values[i] >= 20\n    for iteration in 0..<100:\n\
    \        updateItems()\n        doAssert values == @[1, 2, 3]\n    values = @[7,\
    \ 8, 9, 10, 11]\n    updateItems()\n    doAssert values == @[7, 8, 9, 10, 11]\n\
    \    values = @[]\n    updateItems()\n    doAssert values.len == 0\n\nblock:\n\
    \    var lower: array[5..7, int]\n    var calls = 0\n    proc index(): int =\n\
    \        inc calls\n        6\n    let answer = Temporary:\n        lower[index()]\
    \ = 4\n        inc lower[index()]\n        (lower[6], calls)\n    doAssert answer\
    \ == (5, 2)\n    doAssert calls == 0 and lower[6] == 0\n\nblock:\n    var values\
    \ = [[1, 2], [3, 4]]\n    Temporary:\n        values[0] = [5, 6]\n        values[0][0]\
    \ = 7\n        values = [[8, 9], [10, 11]]\n        values[0] = [12, 13]\n   \
    \     Temporary:\n            values = [[14, 15], [16, 17]]\n            values[0]\
    \ = [18, 19]\n        doAssert values[0][0] == 12 and values[1][0] == 10\n   \
    \ doAssert values == [[1, 2], [3, 4]]\n\nblock:\n    var values = @[1, 2]\n  \
    \  proc change(value: var int) = inc value\n    let failure = newException(ValueError,\
    \ \"test\")\n    for iteration in 0..<10:\n        try:\n            Temporary:\n\
    \                values[0] = 10\n                change(values[0])\n         \
    \       values[0] = 20\n                raise failure\n        except ValueError:\n\
    \            doAssert values == @[1, 2]\n        let answer = Temporary:\n   \
    \         change(values[0])\n            values[0] = 30\n            change(values[0])\n\
    \            values[0]\n        doAssert answer == 31 and values == @[1, 2]\n\n\
    echo \"Hello World\"\n"
  dependsOn:
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/private/temporary_rollback_log.nim
  - cplib/utils/auto_rollback.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/private/temporary_rollback_log.nim
  - cplib/utils/auto_rollback.nim
  isVerificationFile: true
  path: verify/AI/temporary_index_cache_test.nim
  requiredBy: []
  timestamp: '2026-09-23 01:31:00+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/temporary_index_cache_test.nim
layout: document
redirect_from:
- /verify/verify/AI/temporary_index_cache_test.nim
- /verify/verify/AI/temporary_index_cache_test.nim.html
title: verify/AI/temporary_index_cache_test.nim
---
