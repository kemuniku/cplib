---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/collections/SWAG.nim
    title: cplib/collections/SWAG.nim
  - icon: ':question:'
    path: cplib/collections/SWAG.nim
    title: cplib/collections/SWAG.nim
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


    import cplib/collections/SWAG


    let op = proc(x, y: int): int = x + y

    var swag = initSWAG(op, 0)

    assert swag.len == 0

    swag.addLast(1)

    swag.addLast(2)

    swag.addFirst(0)

    assert swag.len == 3

    assert swag.fold() == 3

    assert swag[0] == 0

    assert swag[1] == 1

    assert swag[2] == 2

    assert $swag == "swag@[0, 1, 2]"

    assert swag.popFirst() == 0

    assert swag.popLast() == 2

    assert swag.fold() == 1

    swag.addLast(3)

    swag.addLast(4)

    assert swag.popFirst() == 1

    assert swag.fold() == 7

    swag.addFirst(10)

    assert swag.popLast() == 4

    assert swag.fold() == 13

    '
  dependsOn:
  - cplib/collections/SWAG.nim
  - cplib/collections/SWAG.nim
  isVerificationFile: true
  path: verify/AI/SWAG_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/SWAG_test.nim
layout: document
redirect_from:
- /verify/verify/AI/SWAG_test.nim
- /verify/verify/AI/SWAG_test.nim.html
title: verify/AI/SWAG_test.nim
---
