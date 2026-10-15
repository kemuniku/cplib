---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
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
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/fastio_interactive_test.nim
    title: verify/AI/fastio_interactive_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/fastio_interactive_test.nim
    title: verify/AI/fastio_interactive_test.nim
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
  code: '{.define: fastioInteractive.}

    include cplib/tmpl/sheep

    '
  dependsOn:
  - cplib/tmpl/fastio.nim
  - cplib/tmpl/sheep.nim
  - cplib/tmpl/fastio.nim
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  - cplib/tmpl/sheep.nim
  isVerificationFile: false
  path: cplib/tmpl/sheep_interactive.nim
  requiredBy: []
  timestamp: '2026-10-14 21:33:40+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/fastio_interactive_test.nim
  - verify/AI/fastio_interactive_test.nim
documentation_of: cplib/tmpl/sheep_interactive.nim
layout: document
redirect_from:
- /library/cplib/tmpl/sheep_interactive.nim
- /library/cplib/tmpl/sheep_interactive.nim.html
title: cplib/tmpl/sheep_interactive.nim
---
