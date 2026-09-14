---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/run_enumerate.nim
    title: cplib/str/run_enumerate.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/run_enumerate.nim
    title: cplib/str/run_enumerate.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/zalgorithm.nim
    title: cplib/str/zalgorithm.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/zalgorithm.nim
    title: cplib/str/zalgorithm.nim
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
    echo \"Hello World\"\n\nimport std/algorithm\nimport cplib/str/run_enumerate\n\
    \nproc min_period(s: string, l, r: int): int =\n    for p in 1..(r - l):\n   \
    \     var ok = true\n        for i in (l + p)..<r:\n            if s[i] != s[i\
    \ - p]:\n                ok = false\n                break\n        if ok:\n \
    \           return p\n\nproc brute_runs(s: string): seq[(int, int, int)] =\n \
    \   let n = s.len\n    for l in 0..<n:\n        for r in (l + 1)..n:\n       \
    \     let p = min_period(s, l, r)\n            if r - l >= 2 * p and\n       \
    \             (l == 0 or s[l - 1] != s[l + p - 1]) and\n                    (r\
    \ == n or s[r] != s[r - p]):\n                result.add((p, l, r))\n    result.sort()\n\
    \nproc check_all(alphabet: string, max_len: int) =\n    for n in 0..max_len:\n\
    \        var total = 1\n        for _ in 0..<n:\n            total *= alphabet.len\n\
    \        for mask in 0..<total:\n            var\n                s = newString(n)\n\
    \                x = mask\n            for i in 0..<n:\n                s[i] =\
    \ alphabet[x mod alphabet.len]\n                x = x div alphabet.len\n     \
    \       assert run_enumerate(s) == brute_runs(s)\n\ncheck_all(\"ab\", 8)\ncheck_all(\"\
    abc\", 7)\n\nassert run_enumerate(\"aaaa\") == @[(1, 0, 4)]\nassert RunEnumerate(\"\
    aaaa\") == @[(1, 0, 4)]\nassert run_enumerate(\"ababab\") == @[(2, 0, 6)]\nassert\
    \ run_enumerate(\"abc\") == @[]\nassert run_enumerate(@[1, 2, 1, 2, 1, 2]) ==\
    \ @[(2, 0, 6)]\n"
  dependsOn:
  - cplib/str/run_enumerate.nim
  - cplib/str/zalgorithm.nim
  - cplib/str/run_enumerate.nim
  - cplib/str/zalgorithm.nim
  isVerificationFile: true
  path: verify/AI/run_enumerate_test.nim
  requiredBy: []
  timestamp: '2026-07-09 09:03:36+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/run_enumerate_test.nim
layout: document
redirect_from:
- /verify/verify/AI/run_enumerate_test.nim
- /verify/verify/AI/run_enumerate_test.nim.html
title: verify/AI/run_enumerate_test.nim
---
