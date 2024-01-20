---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':warning:'
    path: verify/str/rolling_hash_yosupo_enumerate_palindromes.nim
    title: verify/str/rolling_hash_yosupo_enumerate_palindromes.nim
  - icon: ':warning:'
    path: verify/str/rolling_hash_yosupo_enumerate_palindromes.nim
    title: verify/str/rolling_hash_yosupo_enumerate_palindromes.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/str/rolling_hash_pun_test.nim
    title: verify/str/rolling_hash_pun_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/rolling_hash_pun_test.nim
    title: verify/str/rolling_hash_pun_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/rolling_hash_yosupo_zalgorithm_test.nim
    title: verify/str/rolling_hash_yosupo_zalgorithm_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/rolling_hash_yosupo_zalgorithm_test.nim
    title: verify/str/rolling_hash_yosupo_zalgorithm_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/binary_search_float_test.nim
    title: verify/utils/binary_search_float_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/binary_search_float_test.nim
    title: verify/utils/binary_search_float_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/binary_search_int_test.nim
    title: verify/utils/binary_search_int_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/binary_search_int_test.nim
    title: verify/utils/binary_search_int_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_UTILS_BINARY_SEARCH:\n    const CPLIB_UTILS_BINARY_SEARCH*\
    \ = 1\n    proc meguru_bisect*(ok, ng: int, is_ok: proc(x: int): bool): int =\n\
    \        var\n            ok = ok\n            ng = ng\n        while abs(ok -\
    \ ng) > 1:\n            var mid = (ok + ng) div 2\n            if is_ok(mid):\
    \ ok = mid\n            else: ng = mid\n        return ok\n\n    proc meguru_bisect*(ok,\
    \ ng: SomeFloat, is_ok: proc(x: SomeFloat): bool, eps: SomeFloat = 1e-10): SomeFloat\
    \ =\n        var\n            ok = ok\n            ng = ng\n        while abs(ok\
    \ - ng) > eps and abs(ok - ng) / max(ok, ng) > eps:\n            var mid = (ok\
    \ + ng) / 2\n            if is_ok(mid): ok = mid\n            else: ng = mid\n\
    \        return ok\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/binary_search.nim
  requiredBy:
  - verify/str/rolling_hash_yosupo_enumerate_palindromes.nim
  - verify/str/rolling_hash_yosupo_enumerate_palindromes.nim
  timestamp: '2023-12-25 07:39:58+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/binary_search_float_test.nim
  - verify/utils/binary_search_float_test.nim
  - verify/utils/binary_search_int_test.nim
  - verify/utils/binary_search_int_test.nim
  - verify/str/rolling_hash_yosupo_zalgorithm_test.nim
  - verify/str/rolling_hash_yosupo_zalgorithm_test.nim
  - verify/str/rolling_hash_pun_test.nim
  - verify/str/rolling_hash_pun_test.nim
documentation_of: cplib/utils/binary_search.nim
layout: document
redirect_from:
- /library/cplib/utils/binary_search.nim
- /library/cplib/utils/binary_search.nim.html
title: cplib/utils/binary_search.nim
---
