---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/replayable_input.nim
    title: cplib/tmpl/replayable_input.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/replayable_input.nim
    title: cplib/tmpl/replayable_input.nim
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
    import strutils\nimport cplib/tmpl/replayable_input\n\nblock:\n    let tokens\
    \ = @[\"2\", \"10\", \"20\", \"hello\", \"18446744073709551615\", \"-7\", \"8\"\
    , \"9\"]\n    var cursor = 0\n\n    proc input(T: typedesc): T =\n        let\
    \ token = tokens[cursor]\n        inc cursor\n        when T is string:\n    \
    \        result = token\n        elif T is SomeUnsignedInt:\n            result\
    \ = T(parseBiggestUInt(token))\n        else:\n            result = T(parseBiggestInt(token))\n\
    \n    replayableInput:\n        let n = ii()\n        var collected: seq[int]\n\
    \        peekInput:\n            collected = lii(n)\n            peekInput:\n\
    \                doAssert si() == \"hello\"\n                doAssert input(uint64)\
    \ == high(uint64)\n            doAssert si() == \"hello\"\n        doAssert collected\
    \ == @[10, 20]\n        collected[0] = 999\n        doAssert ii() == 10\n    \
    \    doAssert input(int) == 20\n        doAssert input(string) == \"hello\"\n\
    \        doAssert input(uint64) == high(uint64)\n        doAssert cursor == 5\n\
    \        try:\n            peekInput:\n                doAssert ii() == -7\n \
    \               raise newException(ValueError, \"test\")\n        except ValueError:\n\
    \            discard\n        doAssert ii() == -7\n        peekInput:\n      \
    \      doAssert input(2, int) == @[8, 9]\n        try:\n            discard input(string)\n\
    \            doAssert false\n        except ValueError:\n            discard\n\
    \        doAssert lii(2) == @[8, 9]\n        doAssert cursor == tokens.len\n\n\
    block:\n    type\n        IntAlias = int\n        OtherInt = distinct int\n  \
    \      Small = tuple[a: int32, b: uint32]\n        Large = array[3, int]\n   \
    \     Managed = object\n            text: string\n            values: seq[int]\n\
    \    var reads = 0\n    proc input(T: typedesc): T =\n        inc reads\n    \
    \    when T is int: result = low(int)\n        elif T is OtherInt: result = OtherInt(42)\n\
    \        elif T is Small: result = (low(int32), high(uint32))\n        elif T\
    \ is Large: result = [1, 2, 3]\n        elif T is Managed: result = Managed(text:\
    \ \"hello\", values: @[4, 5])\n        elif T is float64: result = -1.25\n   \
    \     elif T is bool: result = true\n        elif T is char: result = 'z'\n  \
    \      elif T is string: result = \"world\"\n    replayableInput:\n        peekInput:\n\
    \            discard input(IntAlias)\n            discard input(OtherInt)\n  \
    \          discard input(Small)\n            discard input(Large)\n          \
    \  var first = input(Managed)\n            first.text[0] = 'H'\n            first.values[0]\
    \ = 99\n            discard input(float64)\n            discard input(bool)\n\
    \            discard input(char)\n            discard si()\n        doAssert input(int)\
    \ == low(int)\n        try:\n            discard ii()\n            doAssert false\n\
    \        except ValueError:\n            discard\n        doAssert int(input(OtherInt))\
    \ == 42\n        doAssert input(Small) == (low(int32), high(uint32))\n       \
    \ doAssert input(Large) == [1, 2, 3]\n        let first = input(Managed)\n   \
    \     doAssert first.text == \"hello\" and first.values == @[4, 5]\n        doAssert\
    \ input(float64) == -1.25\n        doAssert input(bool)\n        doAssert input(char)\
    \ == 'z'\n        doAssert si() == \"world\"\n        doAssert reads == 9\n  \
    \      # \u8A18\u9332\u306E\u7834\u68C4\u5F8C\u306B\u3001\u540C\u3058\u578B\u306E\
    \u30D0\u30C3\u30D5\u30A1\u3092\u518D\u5EA6\u4F7F\u7528\u3057\u307E\u3059\u3002\
    \n        discard input(Managed)\n        peekInput:\n            discard input(Managed)\n\
    \            discard si()\n        doAssert input(Managed).values == @[4, 5]\n\
    \        doAssert si() == \"world\"\n        doAssert reads == 12\n\nblock:\n\
    \    var reads = 0\n    proc input(T: typedesc): T =\n        inc reads\n    \
    \    T(reads)\n    replayableInput:\n        peekInput:\n            doAssert\
    \ ii() == 1\n            block stop:\n                peekInput:\n           \
    \         doAssert lii(2) == @[2, 3]\n                    break stop\n       \
    \     doAssert ii() == 2\n        peekInput:\n            doAssert lii(4) == @[1,\
    \ 2, 3, 4]\n        doAssert ii() == 1\n        peekInput:\n            doAssert\
    \ lii(4) == @[2, 3, 4, 5]\n        doAssert lii(4) == @[2, 3, 4, 5]\n        doAssert\
    \ reads == 5\n        doAssert ii() == 6\n        peekInput:\n            doAssert\
    \ ii() == 7\n        doAssert ii() == 7\n        doAssert reads == 7\n\nblock:\n\
    \    var reads = 0\n    proc input(T: typedesc): T =\n        inc reads\n    \
    \    when T is string: result = $reads\n        else: result = T(reads)\n    replayableInput:\n\
    \        peekInput:\n            for i in 1..10000:\n                if i mod\
    \ 3 == 0:\n                    doAssert si() == $i\n                else:\n  \
    \                  doAssert ii() == i\n        for i in 1..10000:\n          \
    \  if i mod 3 == 0:\n                doAssert si() == $i\n            else:\n\
    \                doAssert ii() == i\n        doAssert reads == 10000\n\necho \"\
    Hello World\"\n"
  dependsOn:
  - cplib/tmpl/replayable_input.nim
  - cplib/tmpl/replayable_input.nim
  isVerificationFile: true
  path: verify/AI/replayable_input_test.nim
  requiredBy: []
  timestamp: '2026-09-17 19:05:28+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/replayable_input_test.nim
layout: document
redirect_from:
- /verify/verify/AI/replayable_input_test.nim
- /verify/verify/AI/replayable_input_test.nim.html
title: verify/AI/replayable_input_test.nim
---
