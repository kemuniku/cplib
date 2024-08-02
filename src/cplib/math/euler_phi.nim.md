---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/math/euler_phi_aoj_test.nim
    title: verify/math/euler_phi_aoj_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/euler_phi_aoj_test.nim
    title: verify/math/euler_phi_aoj_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/euler_phi_list_yukicoder_test.nim
    title: verify/math/euler_phi_list_yukicoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/euler_phi_list_yukicoder_test.nim
    title: verify/math/euler_phi_list_yukicoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/euler_phi_yukicoder_test.nim
    title: verify/math/euler_phi_yukicoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/euler_phi_yukicoder_test.nim
    title: verify/math/euler_phi_yukicoder_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATH_EULER_PHI:\n    const CPLIB_MATH_EULER_PHI*\
    \ = 1\n    import sequtils\n    proc euler_phi*(n: int): int =\n        result\
    \ = n\n        var n = n\n        for i in 2..<n:\n            if i*i > n:\n \
    \               break\n            if n mod i == 0:\n                result -=\
    \ result div i\n                while n mod i == 0:\n                    n = n\
    \ div i\n        if n > 1:\n            result -= result div n\n\n    proc euler_phi_list*(n:\
    \ int): seq[int] =\n        result = (0..n).toSeq\n        for i in 2..n:\n  \
    \          if result[i] == i:\n                for j in countup(i, n, i):\n  \
    \                  result[j] = result[j] div i\n                    result[j]\
    \ *= (i - 1)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/math/euler_phi.nim
  requiredBy: []
  timestamp: '2024-01-07 17:44:35+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/euler_phi_yukicoder_test.nim
  - verify/math/euler_phi_yukicoder_test.nim
  - verify/math/euler_phi_aoj_test.nim
  - verify/math/euler_phi_aoj_test.nim
  - verify/math/euler_phi_list_yukicoder_test.nim
  - verify/math/euler_phi_list_yukicoder_test.nim
documentation_of: cplib/math/euler_phi.nim
layout: document
redirect_from:
- /library/cplib/math/euler_phi.nim
- /library/cplib/math/euler_phi.nim.html
title: cplib/math/euler_phi.nim
---
