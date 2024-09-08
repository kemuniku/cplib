---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/can_reverse_hash_string.nim
    title: cplib/str/can_reverse_hash_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/can_reverse_hash_string.nim
    title: cplib/str/can_reverse_hash_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://yukicoder.me/problems/no/2858
    links:
    - https://yukicoder.me/problems/no/2858
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://yukicoder.me/problems/no/2858\ninclude\
    \ cplib/tmpl/sheep\nimport cplib/str/can_reverse_hash_string\nvar T = ii()\n\n\
    for _ in range(T):\n    var N,M = ii()\n    var S = si()\n    #S\u3092\u7121\u9650\
    \u500B\u9023\u7D50\u3057\u305F\u6587\u5B57\u5217\u306B\u3064\u3044\u3066\u3001\
    \n    #1.\u3042\u308Bi\u304B\u3089M\u6587\u5B57\u9023\u7D9A\u306E\u3082\u306E\u304C\
    \u56DE\u6587\u304B\u3092\u5224\u5B9A\u3059\u308B\u3002\n    #2.\u3042\u308Bi\u304B\
    \u3089M+1\u6587\u5B57\u9023\u7D9A\u306E\u3082\u306E\u304C\u56DE\u6587\u304B\u3092\
    \u306F\u3093\u3066\u3044\u3059\u308B\u3002\n    var ans = INF\n    var HS = S.initRollingHash()\n\
    \n    proc solve(i,x:int):bool=\n        if (i+x) < N:\n            return HS[i..<(i+x)].isPalindrome()\n\
    \        var tmp = HS[i..<N].toHashString()\n        tmp = tmp & (HS * ((x-len(i..<N))\
    \ // N))\n        var nokori = x-(((x-len(i..<N)) // N)*N + len(i..<N))\n    \
    \    tmp = tmp & HS[0..<nokori]\n        return tmp.isPalindrome()\n\n\n    for\
    \ i in range(N):\n        if solve(i,M):\n            ans.min = (M-(N-i)+(N-1))//N\
    \ + 1\n        if solve(i,M+1):\n            ans.min = (M+1-(N-i)+(N-1))//N +\
    \ 1\n\n    if ans == INF:\n        echo -1\n    else:\n        echo ans"
  dependsOn:
  - cplib/tmpl/sheep.nim
  - cplib/utils/constants.nim
  - cplib/str/can_reverse_hash_string.nim
  - cplib/utils/constants.nim
  - cplib/tmpl/sheep.nim
  - cplib/str/can_reverse_hash_string.nim
  isVerificationFile: true
  path: verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
  requiredBy: []
  timestamp: '2024-08-31 11:41:07+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
layout: document
redirect_from:
- /verify/verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
- /verify/verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim.html
title: verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
---
