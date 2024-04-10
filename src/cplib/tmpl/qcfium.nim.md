---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':x:'
    path: verify/tmpl/citrus_and_qcfium_test.nim
    title: verify/tmpl/citrus_and_qcfium_test.nim
  - icon: ':x:'
    path: verify/tmpl/citrus_and_qcfium_test.nim
    title: verify/tmpl/citrus_and_qcfium_test.nim
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_TMPL_QCFIUM:\n    const CPLIB_TMPL_QCFIUM* = 1\n\
    \    {.emit: \"\"\"\n    #pragma GCC target (\"avx2\")\n    #pragma GCC optimize(\"\
    O3\")\n    #pragma GCC optimize(\"unroll-loops\")\n    \"\"\".}\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/tmpl/qcfium.nim
  requiredBy: []
  timestamp: '2023-11-02 03:44:51+09:00'
  verificationStatus: LIBRARY_ALL_WA
  verifiedWith:
  - verify/tmpl/citrus_and_qcfium_test.nim
  - verify/tmpl/citrus_and_qcfium_test.nim
documentation_of: cplib/tmpl/qcfium.nim
layout: document
redirect_from:
- /library/cplib/tmpl/qcfium.nim
- /library/cplib/tmpl/qcfium.nim.html
title: cplib/tmpl/qcfium.nim
---
