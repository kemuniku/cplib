---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/string/string_utils.nim
    title: cplib/string/string_utils.nim
  - icon: ':heavy_check_mark:'
    path: cplib/string/string_utils.nim
    title: cplib/string/string_utils.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/citrus.nim
    title: cplib/tmpl/citrus.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/citrus.nim
    title: cplib/tmpl/citrus.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://yukicoder.me/problems/no/1469
    links:
    - https://yukicoder.me/problems/no/1469
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://yukicoder.me/problems/no/1469

    include cplib/tmpl/citrus

    import cplib/string/string_utils


    var s = input(string)

    print(s.run_length_encode.mapIt(it[0]).join(""))

    '
  dependsOn:
  - cplib/tmpl/citrus.nim
  - cplib/tmpl/citrus.nim
  - cplib/string/string_utils.nim
  - cplib/string/string_utils.nim
  isVerificationFile: true
  path: verify/string/run_length_encoding_test.nim
  requiredBy: []
  timestamp: '2023-11-03 12:47:02+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/string/run_length_encoding_test.nim
layout: document
redirect_from:
- /verify/verify/string/run_length_encoding_test.nim
- /verify/verify/string/run_length_encoding_test.nim.html
title: verify/string/run_length_encoding_test.nim
---
