---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
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
    import cplib/utils/backwards_index\n\ntype Buffer[T] = object\n    data: seq[T]\n\
    \nproc len[T](self: Buffer[T]): int = self.data.len\nproc `[]`[T](self: Buffer[T],\
    \ idx: int): T {.backwardsIndex.} =\n    self.data[idx]\nproc `[]`[T](self: var\
    \ Buffer[T], idx: int): var T {.backwardsIndex.} =\n    self.data[idx]\nproc `[]=`[T](self:\
    \ var Buffer[T], idx: Natural, value: T) {.backwardsIndex.} =\n    self.data[idx]\
    \ = value\n\nlet immutable = Buffer[int](data: @[10, 20, 30])\ndoAssert immutable[^1]\
    \ == 30\ndoAssert immutable[^immutable.len] == 10\nvar mutable = immutable\nmutable[^1]\
    \ = 40\nmutable[^2] += 5\ndoAssert mutable.data == @[10, 25, 40]\n\nvar receiverCalls,\
    \ indexCalls, valueCalls: int\nproc receiver(): var Buffer[int] =\n    inc receiverCalls\n\
    \    mutable\nproc index(): BackwardsIndex =\n    inc indexCalls\n    ^1\nproc\
    \ value(): int =\n    inc valueCalls\n    99\nreceiver()[index()] = value()\n\
    doAssert (receiverCalls, indexCalls, valueCalls) == (1, 1, 1)\nreceiver()[index()]\
    \ += 1\ndoAssert (receiverCalls, indexCalls) == (2, 2)\ndoAssert mutable[^1] ==\
    \ 100\n\ntype FixedBuffer[N: static int, T] = object\n    data: array[N, T]\n\
    func len[N: static int, T](self: FixedBuffer[N, T]): int = N\nfunc `[]`[N: static\
    \ int, T](self: FixedBuffer[N, T], idx: Natural): T {.inline, backwardsIndex.}\
    \ =\n    self.data[idx]\nlet fixed = FixedBuffer[3, int](data: [1, 2, 3])\ndoAssert\
    \ fixed[^1] == 3\ndoAssert fixed[^3] == 1\n\nfor idx in [^0, ^4]:\n    var raised\
    \ = false\n    try:\n        discard immutable[idx]\n    except IndexDefect:\n\
    \        raised = true\n    doAssert raised\n\nlet empty = Buffer[int]()\nvar\
    \ raised = false\ntry:\n    discard empty[^1]\nexcept IndexDefect:\n    raised\
    \ = true\ndoAssert raised\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/utils/backwards_index.nim
  - cplib/utils/backwards_index.nim
  isVerificationFile: true
  path: verify/utils/backwards_index_test.nim
  requiredBy: []
  timestamp: '2026-09-18 12:10:16+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/backwards_index_test.nim
layout: document
redirect_from:
- /verify/verify/utils/backwards_index_test.nim
- /verify/verify/utils/backwards_index_test.nim.html
title: verify/utils/backwards_index_test.nim
---
