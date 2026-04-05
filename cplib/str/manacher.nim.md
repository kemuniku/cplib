---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/str/manacher_test.nim
    title: verify/str/manacher_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/manacher_test.nim
    title: verify/str/manacher_test.nim
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
  code: "when not declared CPLIB_STR_MANACHER:\n    const CPLIB_STR_MANACHER* = 1\n\
    \    import sequtils\n    proc manacher*[T](s: seq[T]): seq[int] =\n        result\
    \ = newSeq[int](s.len)\n        result[0] = 0\n        var c = 0\n        for\
    \ i in 0..<s.len:\n            var l = 2*c - i\n            if l in 0..<s.len\
    \ and i + result[l] < c + result[c]:\n                result[i] = result[l]\n\
    \            else:\n                var j = c + result[c] - i\n              \
    \  while i-j >= 0 and i+j < s.len and s[i-j] == s[i+j]: j += 1\n             \
    \   result[i] = j\n                c = i\n    proc manacher*(s: string): seq[int]\
    \ = manacher(s.toSeq)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/str/manacher.nim
  requiredBy: []
  timestamp: '2026-04-05 16:11:43+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/str/manacher_test.nim
  - verify/str/manacher_test.nim
documentation_of: cplib/str/manacher.nim
layout: document
redirect_from:
- /library/cplib/str/manacher.nim
- /library/cplib/str/manacher.nim.html
title: cplib/str/manacher.nim
---
