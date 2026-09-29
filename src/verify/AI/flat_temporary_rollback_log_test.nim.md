---
data:
  _extendedDependsOn:
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
    import random\nimport cplib/utils/private/temporary_rollback_log\n\nblock:\n \
    \   var cache: TemporaryIndexCache\n    for size in [1, 2, 63, 64, 65, 1000, 3]:\n\
    \        var values = newSeq[int](size)\n        for i in 0..<size: values[i]\
    \ = if i mod 3 == 0: 7 else: i\n        let original = values\n        for repeat\
    \ in 0..<3:\n            var history: FlatTemporaryRollbackLog\n            for\
    \ iteration in 0..<5:\n                for i in 0..<size:\n                  \
    \  history.rememberIndexed(addr values[i], addr values[0], size, cache)\n    \
    \                values[i] = iteration\n            history.restore(0)\n     \
    \       doAssert values == original and history.len == 0\n\nblock:\n    var values:\
    \ array[130, int]\n    var first, second: TemporaryIndexCache\n    var outer:\
    \ FlatTemporaryRollbackLog\n    outer.rememberIndexed(addr values[63], addr values[0],\
    \ values.len, first)\n    values[63] = 9\n    var inner: FlatTemporaryRollbackLog\n\
    \    inner.rememberIndexed(addr values[63], addr values[0], values.len, first)\n\
    \    values[63] = 10\n    inner.rememberIndexed(addr values[64], addr values[0],\
    \ values.len, first)\n    values[64] = 10\n    inner.restore(0)\n    doAssert\
    \ values[63] == 9 and values[64] == 0\n    outer.rememberIndexed(addr values[63],\
    \ addr values[0], values.len, second)\n    values[63] = 11\n    outer.rememberIndexed(addr\
    \ values[64], addr values[0], values.len, second)\n    values[64] = 12\n    outer.remember(addr\
    \ values)\n    values = default(array[130, int])\n    outer.restore(0)\n    doAssert\
    \ values == default(array[130, int])\n\nblock:\n    var cache: TemporaryIndexCache\n\
    \    var first = [7, 7, 7]\n    var second = [8, 8, 8]\n    var history: FlatTemporaryRollbackLog\n\
    \    history.rememberIndexed(addr first[0], addr first[0], first.len, cache)\n\
    \    first[0] = 1\n    history.rememberIndexed(addr second[1], addr second[0],\
    \ second.len, cache)\n    second[1] = 2\n    history.rememberIndexed(addr first[2],\
    \ addr first[0], first.len, cache)\n    first[2] = 3\n    history.restore(0)\n\
    \    doAssert first == [7, 7, 7] and second == [8, 8, 8]\n    var general: TemporaryRollbackLog\n\
    \    general.rememberIndexed(addr first[1], addr first[0], first.len, cache)\n\
    \    first[1] = 9\n    general.restore(0)\n    doAssert first == [7, 7, 7]\n \
    \   history.rememberIndexed(addr second[2], addr second[0], second.len, cache)\n\
    \    second[2] = 10\n    history.restore(0)\n    doAssert second == [8, 8, 8]\n\
    \nproc testValues[T](initial, changed: T) =\n    var cache: TemporaryIndexCache\n\
    \    var values = [initial, initial, initial]\n    var history: FlatTemporaryRollbackLog\n\
    \    for i in 0..<values.len:\n        history.rememberIndexed(addr values[i],\
    \ addr values[0], values.len, cache)\n        values[i] = changed\n    history.restore(0)\n\
    \    for i in 0..<values.len:\n        doAssert equalMem(addr values[i], unsafeAddr\
    \ initial, sizeof(T))\n\ntestValues(0xFE'u8, 1'u8)\ntestValues(0xFFEE'u16, 2'u16)\n\
    testValues(0xFFEEDDCC'u32, 3'u32)\ntestValues(0xFFEEDDCCBBAA9988'u64, 4'u64)\n\
    testValues(-1, low(int))\ntestValues(-0.0, 1.0)\ntestValues(false, true)\ntestValues([1'u8,\
    \ 2'u8, 3'u8], [4'u8, 5'u8, 6'u8])\ntestValues([1, 2, 3], [4, 5, 6])\ntestValues(default(array[0,\
    \ int]), default(array[0, int]))\n\nblock:\n    var first = [7, 8, 9]\n    var\
    \ second = [10, 11, 12]\n    var firstCache, secondCache: TemporaryIndexCache\n\
    \    var history: FlatTemporaryRollbackLog\n    for iteration in 0..<1000:\n \
    \       let index = iteration mod 3\n        history.rememberIndexed(addr first[index],\
    \ addr first[0], first.len, firstCache)\n        first[index] = iteration\n  \
    \      history.rememberIndexed(addr second[index], addr second[0], second.len,\
    \ secondCache)\n        second[index] = -iteration\n        history.clearFlat()\n\
    \        doAssert first == [7, 8, 9] and second == [10, 11, 12]\n        doAssert\
    \ history.len == 0\n    history.restore(0)\n    var general: TemporaryRollbackLog\n\
    \    general.rememberIndexed(addr first[0], addr first[0], first.len, firstCache)\n\
    \    first[0] = 100\n    general.restore(0)\n    doAssert first == [7, 8, 9]\n\
    \nvar rng = initRand(667812)\nfor trial in 0..<300:\n    var values: array[4,\
    \ array[4, int]]\n    for row in 0..<4:\n        for col in 0..<4: values[row][col]\
    \ = rng.rand(3)\n    let original = values\n    var history: FlatTemporaryRollbackLog\n\
    \    var cache, alias, rowCache: TemporaryIndexCache\n    for operation in 0..<100:\n\
    \        let row = rng.rand(3)\n        let col = rng.rand(3)\n        let value\
    \ = rng.rand(3)\n        case rng.rand(4)\n        of 0:\n            history.rememberIndexed(addr\
    \ values[row][col], addr values[0][0], 16, cache)\n            values[row][col]\
    \ = value\n        of 1:\n            history.rememberIndexed(addr values[row][col],\
    \ addr values[0][0], 16, alias)\n            values[row][col] = value\n      \
    \  of 2:\n            history.remember(addr values[row][col])\n            values[row][col]\
    \ = value\n        of 3:\n            history.rememberIndexed(addr values[row],\
    \ addr values[0], 4, rowCache)\n            values[row] = [value, value, value,\
    \ value]\n        else:\n            history.remember(addr values)\n         \
    \   for r in 0..<4:\n                for c in 0..<4: values[r][c] = value\n  \
    \  history.restore(0)\n    doAssert values == original\n\necho \"Hello World\"\
    \n"
  dependsOn:
  - cplib/utils/private/temporary_rollback_log.nim
  - cplib/utils/private/temporary_rollback_log.nim
  isVerificationFile: true
  path: verify/AI/flat_temporary_rollback_log_test.nim
  requiredBy: []
  timestamp: '2026-09-30 05:10:11+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/flat_temporary_rollback_log_test.nim
layout: document
redirect_from:
- /verify/verify/AI/flat_temporary_rollback_log_test.nim
- /verify/verify/AI/flat_temporary_rollback_log_test.nim.html
title: verify/AI/flat_temporary_rollback_log_test.nim
---
