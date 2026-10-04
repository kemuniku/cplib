---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/run_enumerate.nim
    title: cplib/str/run_enumerate.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/run_enumerate.nim
    title: cplib/str/run_enumerate.nim
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
    echo \"Hello World\"\n\nimport algorithm, random, sequtils, strutils\nimport cplib/str/run_enumerate\n\
    \nproc brute[T](s: openArray[T]): seq[(int, int, int)] =\n    for l in 0..<s.len:\n\
    \        for r in l + 2..s.len:\n            var period = 1\n            while\
    \ period <= (r - l) div 2:\n                var valid = true\n               \
    \ for i in l + period..<r:\n                    if s[i] != s[i - period]:\n  \
    \                      valid = false\n                        break\n        \
    \        if valid:\n                    if (l == 0 or s[l - 1] != s[l + period\
    \ - 1]) and\n                            (r == s.len or s[r] != s[r - period]):\n\
    \                        result.add((period, l, r))\n                    break\n\
    \                inc period\n    result.sort()\n\nproc check(s: string) =\n  \
    \  let expected = brute(s.toSeq)\n    let actual = run_enumerate(s)\n    assert\
    \ actual == expected, repr(s) & \" actual=\" & $actual & \" expected=\" & $expected\n\
    \    assert RunEnumerate(s) == actual\n    assert run_enumerate(s.toSeq) == actual\n\
    \    assert RunEnumerate(s.toSeq) == actual\n    assert actual.sorted() == actual\n\
    \    assert actual.deduplicate().len == actual.len\n\nproc exhaustive(alphabet:\
    \ string, maxLen: int) =\n    for n in 0..maxLen:\n        var count = 1\n   \
    \     for i in 0..<n: count *= alphabet.len\n        for mask in 0..<count:\n\
    \            var x = mask\n            var s = newString(n)\n            for i\
    \ in 0..<n:\n                s[i] = alphabet[x mod alphabet.len]\n           \
    \     x = x div alphabet.len\n            check(s)\n\nexhaustive(\"ab\", 12)\n\
    exhaustive(\"abc\", 8)\nexhaustive(\"\\0\\1\\xff\", 6)\nrandomize(20261002)\n\
    for trial in 0..<5000:\n    let n = rand(80)\n    var s = newString(n)\n    let\
    \ alphabet = [\"ab\", \"abc\", \"abcdefghijklmnopqrstuvwxyz\", \"\\0\\1\\xff\"\
    ][trial mod 4]\n    for i in 0..<n: s[i] = sample(alphabet)\n    check(s)\nfor\
    \ n in 0..129:\n    check(repeat('a', n))\n    check(repeat(\"ab\", n)[0..<n])\n\
    \    check(repeat(\"abcde\", n)[0..<n])\n    var tm = newString(n)\n    for i\
    \ in 0..<n:\n        var x = i\n        var parity = 0\n        while x > 0:\n\
    \            parity = parity xor (x and 1)\n            x = x shr 1\n        tm[i]\
    \ = \"ab\"[parity]\n    check(tm)\n    var a = \"a\"\n    var b = \"ab\"\n   \
    \ while b.len < n:\n        (a, b) = (b, a & b)\n    check(b[0..<n])\n    for\
    \ pos in [0, n div 2, n - 1]:\n        if pos >= 0 and pos < n:\n            var\
    \ s = repeat('a', n)\n            s[pos] = 'b'\n            check(s)\n\ntype Token\
    \ = object\n    x: int\nproc `==`(a, b: Token): bool = a.x == b.x\nlet tokens\
    \ = @[Token(x: 8), Token(x: -3), Token(x: 8), Token(x: -3), Token(x: 8)]\nassert\
    \ run_enumerate(tokens) == brute(tokens)\nassert run_enumerate([7, -2, 7, -2,\
    \ 7, -2]) == @[(2, 0, 6)]\nassert run_enumerate(newSeq[int]()) == @[]\nassert\
    \ run_enumerate(@[\"a\", \"b\", \"a\", \"b\"]) == @[(2, 0, 4)]\nassert run_enumerate(@[1,\
    \ 2, 1, 2, 9, 1, 2].toOpenArray(0, 3)) == @[(2, 0, 4)]\n"
  dependsOn:
  - cplib/str/run_enumerate.nim
  - cplib/str/run_enumerate.nim
  isVerificationFile: true
  path: verify/AI/run_enumerate_test.nim
  requiredBy: []
  timestamp: '2026-10-02 14:49:24+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/run_enumerate_test.nim
layout: document
redirect_from:
- /verify/verify/AI/run_enumerate_test.nim
- /verify/verify/AI/run_enumerate_test.nim.html
title: verify/AI/run_enumerate_test.nim
---
