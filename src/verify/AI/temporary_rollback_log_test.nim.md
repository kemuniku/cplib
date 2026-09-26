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
    import random\nimport cplib/utils/private/temporary_rollback_log\nimport cplib/utils/auto_rollback\n\
    \nblock:\n    var history: TemporaryRollbackLog\n    var value = 7\n    for i\
    \ in 0..<100000:\n        history.remember(addr value)\n        value = i\n  \
    \  doAssert history.len == 1\n    history.restore(0)\n    doAssert value == 7\
    \ and history.len == 0\n    history.remember(addr value)\n    value = 15\n   \
    \ history.restore(0)\n    doAssert value == 7\n\nblock:\n    var history: TemporaryRollbackLog\n\
    \    var values = [1, 2]\n    history.remember(addr values[0])\n    values[0]\
    \ = 10\n    let inner = history.beginTemporary()\n    for i in 0..<1000:\n   \
    \     history.remember(addr values[0])\n        history.remember(addr values[1])\n\
    \        values[0] = i\n        values[1] = -i\n    doAssert history.len == 3\n\
    \    let deepest = history.beginTemporary()\n    history.remember(addr values[0])\n\
    \    values[0] = -100\n    doAssert history.len == 4\n    history.endTemporary(deepest)\n\
    \    doAssert values == [999, -999] and history.len == 3\n    history.endTemporary(inner)\n\
    \    doAssert values == [10, 2] and history.len == 1\n    history.remember(addr\
    \ values[0])\n    values[0] = 20\n    doAssert history.len == 1\n    history.remember(addr\
    \ values[1])\n    values[1] = 30\n    doAssert history.len == 2\n    history.restore(0)\n\
    \    doAssert values == [1, 2]\n\nblock:\n    var history: TemporaryRollbackLog\n\
    \    var value = 0\n    for i in 1..1000:\n        let inner = history.beginTemporary()\n\
    \        history.remember(addr value)\n        value = i\n        doAssert history.len\
    \ == 1\n        history.endTemporary(inner)\n        doAssert value == 0 and history.len\
    \ == 0\n\nblock:\n    var rng = initRand(639182)\n    for repeat in 0..<100:\n\
    \        var history: TemporaryRollbackLog\n        var values = [[1, 2], [3,\
    \ 4]]\n        for i in 0..<100:\n            let row = rng.rand(1)\n        \
    \    let col = rng.rand(1)\n            case rng.rand(2)\n            of 0:\n\
    \                history.remember(addr values)\n                values = [[i,\
    \ i + 1], [i + 2, i + 3]]\n            of 1:\n                history.remember(addr\
    \ values[row])\n                values[row] = [i, -i]\n            else:\n   \
    \             history.remember(addr values[row][col])\n                values[row][col]\
    \ = i\n            doAssert history.len <= 7\n        history.restore(0)\n   \
    \     doAssert values == [[1, 2], [3, 4]]\n\nblock:\n    var values = [1, 2]\n\
    \    proc setFirst(value: int) = values[0] = value\n    let answer = Temporary:\n\
    \        for i in 0..<1000:\n            setFirst(i)\n            values = [i\
    \ + 1, -i]\n            values[0] = i + 2\n        let inner = Temporary:\n  \
    \          values[0] = 77\n            values = [88, 99]\n            values[0]\
    \ = 66\n            values\n        doAssert inner[0] == 66 and inner[1] == 99\n\
    \        doAssert values[0] == 1001 and values[1] == -999\n        values\n  \
    \  doAssert answer == [1001, -999] and values == [1, 2]\n    proc leave(): int\
    \ =\n        Temporary:\n            values[0] = 10\n            Temporary:\n\
    \                values[0] = 20\n                return values[0]\n    doAssert\
    \ leave() == 20 and values == [1, 2]\n\nblock:\n    var history: TemporaryRollbackLog\n\
    \    var small = 7'u8\n    var wide = 0x123456789ABCDEF0'u64\n    var fraction\
    \ = -0.0\n    var empty: array[0, int]\n    var large: array[4096, int32]\n  \
    \  for i in 0..<large.len: large[i] = i.int32\n    history.remember(addr small)\n\
    \    small = 9\n    history.remember(addr wide)\n    wide = 0\n    history.remember(addr\
    \ fraction)\n    fraction = 5.0\n    history.remember(addr empty)\n    let inner\
    \ = history.beginTemporary()\n    history.remember(addr large)\n    for i in 0..<large.len:\
    \ large[i] = -1\n    history.remember(addr wide)\n    wide = 123\n    history.endTemporary(inner)\n\
    \    for i in 0..<large.len: doAssert large[i] == i.int32\n    doAssert wide ==\
    \ 0 and small == 9 and fraction == 5.0\n    for repeat in 0..<20:\n        let\
    \ inner = history.beginTemporary()\n        history.remember(addr large)\n   \
    \     large[0] = -1\n        history.endTemporary(inner)\n        doAssert large[0]\
    \ == 0\n    history.restore(0)\n    doAssert small == 7 and wide == 0x123456789ABCDEF0'u64\n\
    \    doAssert cast[uint64](fraction) == cast[uint64](-0.0)\n    doAssert history.len\
    \ == 0\n\nstatic:\n    doAssert not compiles(block:\n        var history: TemporaryRollbackLog\n\
    \        var value = @[1, 2]\n        history.remember(addr value)\n    )\n  \
    \  doAssert not compiles(block:\n        var history: TemporaryRollbackLog\n \
    \       var value = (1, \"text\")\n        history.remember(addr value)\n    )\n\
    \necho \"Hello World\"\n"
  dependsOn:
  - cplib/utils/private/temporary_rollback_log.nim
  - cplib/utils/auto_rollback.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/private/temporary_rollback_log.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/auto_rollback.nim
  isVerificationFile: true
  path: verify/AI/temporary_rollback_log_test.nim
  requiredBy: []
  timestamp: '2026-09-23 01:31:00+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/temporary_rollback_log_test.nim
layout: document
redirect_from:
- /verify/verify/AI/temporary_rollback_log_test.nim
- /verify/verify/AI/temporary_rollback_log_test.nim.html
title: verify/AI/temporary_rollback_log_test.nim
---
