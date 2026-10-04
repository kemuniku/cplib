---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/suffix_automaton_table.nim
    title: cplib/str/suffix_automaton_table.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/suffix_automaton_table.nim
    title: cplib/str/suffix_automaton_table.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/number_of_substrings
    links:
    - https://judge.yosupo.jp/problem/number_of_substrings
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://judge.yosupo.jp/problem/number_of_substrings

    import cplib/str/suffix_automaton_table


    let s = stdin.readLine()

    let sam = initSuffixAutomatonTable(s)

    echo sam.countDistinctSubstrings()

    '
  dependsOn:
  - cplib/str/suffix_automaton_table.nim
  - cplib/str/suffix_automaton_table.nim
  isVerificationFile: true
  path: verify/str/suffix_automaton_table_number_of_substrings_test.nim
  requiredBy: []
  timestamp: '2026-10-04 16:38:19+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/suffix_automaton_table_number_of_substrings_test.nim
layout: document
redirect_from:
- /verify/verify/str/suffix_automaton_table_number_of_substrings_test.nim
- /verify/verify/str/suffix_automaton_table_number_of_substrings_test.nim.html
title: verify/str/suffix_automaton_table_number_of_substrings_test.nim
---
