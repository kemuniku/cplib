---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/misc/binary_search_int_test.nim
    title: verify/misc/binary_search_int_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/misc/binary_search_int_test.nim
    title: verify/misc/binary_search_int_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MISC_BINARY_SEARCH:\n    const CPLIB_MISC_BINARY_SEARCH*\
    \ = 1\n    proc meguru_bisect*(mn, mx: int, is_ok: proc(x: int): bool): int =\n\
    \        var\n            ok = mn\n            ng = mx\n        while abs(ok -\
    \ ng) > 1:\n            var mid = (ok + ng) div 2\n            if is_ok(mid):\
    \ ok = mid\n            else: ng = mid\n        return ok\n\n    proc meguru_bisect*(mn,\
    \ mx: SomeFloat, is_ok: proc(x: SomeFloat): bool,\n            eps: SomeFloat\
    \ = 1e-10): SomeFloat =\n        var\n            ok = mn\n            ng = mx\n\
    \        while abs(ok - ng) > eps or abs(ok - ng) / max(ok, ng) > eps:\n     \
    \       var mid = (ok + ng) / 2\n            if is_ok(mid): ok = mid\n       \
    \     else: ng = mid\n        return ok\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/misc/binary_search.nim
  requiredBy: []
  timestamp: '2023-11-02 23:17:10+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/misc/binary_search_int_test.nim
  - verify/misc/binary_search_int_test.nim
documentation_of: cplib/misc/binary_search.nim
layout: document
redirect_from:
- /library/cplib/misc/binary_search.nim
- /library/cplib/misc/binary_search.nim.html
title: cplib/misc/binary_search.nim
---
