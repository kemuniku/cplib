---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_array.nim
    title: cplib/collections/persistent_array.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/persistent_array.nim
    title: cplib/collections/persistent_array.nim
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
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

    echo "Hello World"


    import cplib/collections/persistent_array


    let pa = initPersistentArray(@[10, 20, 30, 40], 2)

    assert pa[0] == 10

    assert pa[3] == 40

    assert pa.toseq == @[10, 20, 30, 40]

    let pb = pa.change_value(1, 99)

    assert pa.toseq == @[10, 20, 30, 40]

    assert pb.toseq == @[10, 99, 30, 40]

    '
  dependsOn:
  - cplib/collections/persistent_array.nim
  - cplib/collections/persistent_array.nim
  isVerificationFile: true
  path: verify/AI/persistent_array_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/persistent_array_test.nim
layout: document
redirect_from:
- /verify/verify/AI/persistent_array_test.nim
- /verify/verify/AI/persistent_array_test.nim.html
title: verify/AI/persistent_array_test.nim
---
