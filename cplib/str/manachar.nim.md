---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/str/manachar_test.nim
    title: verify/str/manachar_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/manachar_test.nim
    title: verify/str/manachar_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_STR_MANACHAR:\n    const CPLIB_STR_MANACHAR* = 1\n\
    \    import sequtils\n    proc manachar*[T](s: seq[T]): seq[int] =\n        result\
    \ = newSeq[int](s.len)\n        result[0] = 0\n        var c = 0\n        for\
    \ i in 0..<s.len:\n            var l = 2*c - i\n            if l in 0..<s.len\
    \ and i + result[l] < c + result[c]:\n                result[i] = result[l]\n\
    \            else:\n                var j = c + result[c] - i\n              \
    \  while i-j >= 0 and i+j < s.len and s[i-j] == s[i+j]: j += 1\n             \
    \   result[i] = j\n                c = i\n    proc manachar*(s: string): seq[int]\
    \ = manachar(s.toSeq)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/str/manachar.nim
  requiredBy: []
  timestamp: '2023-12-04 22:34:31+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/str/manachar_test.nim
  - verify/str/manachar_test.nim
documentation_of: cplib/str/manachar.nim
layout: document
redirect_from:
- /library/cplib/str/manachar.nim
- /library/cplib/str/manachar.nim.html
title: cplib/str/manachar.nim
---
