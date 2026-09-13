---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/str/manacher.nim
    title: cplib/str/manacher.nim
  - icon: ':question:'
    path: cplib/str/manacher.nim
    title: cplib/str/manacher.nim
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
    echo \"Hello World\"\n\nimport sequtils\nimport cplib/str/manacher\n\nassert manacher(newSeq[int]())\
    \ == @[]\nassert manacher(\"\") == @[]\nassert manacher(\"ababa\".toSeq)[2] ==\
    \ 3\nassert manacher(@[1, 2, 2, 1])[1] == 1\nassert manacher([1, 2, 2, 1])[2]\
    \ == 1\nassert manacher(newSeq[int]()) == @[]\nlet pals = get_palindromes(\"abba\"\
    .toSeq, '$')\nassert pals[0] == (0, 1)\nassert pals[3] == (0, 4)\nassert pals[5]\
    \ == (-1, -1)\nlet arrayPals = get_palindromes(['a', 'b', 'b', 'a'], '$')\nassert\
    \ arrayPals == pals\nassert get_palindromes(newSeq[int](), -1) == @[]\n\nproc\
    \ checkOpenArray(s: openArray[int]) =\n    assert manacher(s)[1] == 1\n    assert\
    \ get_palindromes(s, -1)[3] == (0, 4)\n\ncheckOpenArray([1, 2, 2, 1])\n"
  dependsOn:
  - cplib/str/manacher.nim
  - cplib/str/manacher.nim
  isVerificationFile: true
  path: verify/AI/manacher_test.nim
  requiredBy: []
  timestamp: '2026-09-08 05:46:27+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/manacher_test.nim
layout: document
redirect_from:
- /verify/verify/AI/manacher_test.nim
- /verify/verify/AI/manacher_test.nim.html
title: verify/AI/manacher_test.nim
---
