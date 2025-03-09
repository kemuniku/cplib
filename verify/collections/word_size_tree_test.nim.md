---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/wordsizetree.nim
    title: cplib/collections/wordsizetree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/wordsizetree.nim
    title: cplib/collections/wordsizetree.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/predecessor_problem
    links:
    - https://judge.yosupo.jp/problem/predecessor_problem
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/predecessor_problem\n\
    import cplib/collections/wordsizetree\nimport sequtils\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n{.checks:off.}\n\nvar N,Q = ii()\nvar T = stdin.readline().mapit(it\
    \ == '1')\nvar st = initWordsizeTree(T)\nfor i in 0..<Q:\n    var c,k = ii()\n\
    \    #echo \"task;\",c\n    if c == 0:\n        st.incl(k)\n    elif c == 1:\n\
    \        st.excl(k)\n    elif c == 2:\n        if st[k]:\n            stdout.writeLine\
    \ \"1\"\n        else:\n            stdout.writeLine \"0\"\n    elif c == 3:\n\
    \        stdout.writeLine st.ge(k)\n    else:\n        stdout.writeLine st.le(k)"
  dependsOn:
  - cplib/collections/wordsizetree.nim
  - cplib/collections/wordsizetree.nim
  isVerificationFile: true
  path: verify/collections/word_size_tree_test.nim
  requiredBy: []
  timestamp: '2024-09-15 02:32:00+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/word_size_tree_test.nim
layout: document
redirect_from:
- /verify/verify/collections/word_size_tree_test.nim
- /verify/verify/collections/word_size_tree_test.nim.html
title: verify/collections/word_size_tree_test.nim
---
