---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/run_length_encode.nim
    title: cplib/str/run_length_encode.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/run_length_encode.nim
    title: cplib/str/run_length_encode.nim
  _extendedRequiredBy:
  - icon: ':warning:'
    path: verify/math/osa_k_test_.nim
    title: verify/math/osa_k_test_.nim
  - icon: ':warning:'
    path: verify/math/osa_k_test_.nim
    title: verify/math/osa_k_test_.nim
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATH_OSAK:\n    import algorithm,tables\n    import\
    \ cplib/str/run_length_encode\n    const CPLIB_MATH_OSAK* = 1\n\n    type PrimeFactorTable\
    \ = ref object\n        table:seq[int]\n    \n    proc initPrimeFactorTable*(maxn:int):PrimeFactorTable\
    \ =\n        var table = newseq[int](maxn+1)\n        for i in 2..maxn:\n    \
    \        if table[i] == 0:\n                for j in countup(i,maxn,i):\n    \
    \                table[j] = i\n        return PrimeFactorTable(table:table)\n\n\
    \    proc primefactor*(table:PrimeFactorTable,x:int):seq[int]=\n        assert\
    \ len(table.table) > x\n        assert x >= 1\n        var x = x\n        while\
    \ x != 1:\n            result.add(table.table[x])\n            x = x div table.table[x]\n\
    \        result.reverse()\n    \n    proc primefactor_table*(table:PrimeFactorTable,x:int):Table[int,int]=\n\
    \        for p in primefactor(table,x):\n            if p in result:\n       \
    \         result[p] += 1\n            else:\n                result[p] = 1\n \
    \   \n    proc primefactor_tuple*(table:PrimeFactorTable,x:int):seq[(int,int)]=\n\
    \        result = primefactor(table,x).run_length_encode()\n\n\n"
  dependsOn:
  - cplib/str/run_length_encode.nim
  - cplib/str/run_length_encode.nim
  isVerificationFile: false
  path: cplib/math/osa_k.nim
  requiredBy:
  - verify/math/osa_k_test_.nim
  - verify/math/osa_k_test_.nim
  timestamp: '2024-12-08 16:30:25+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/math/osa_k.nim
layout: document
redirect_from:
- /library/cplib/math/osa_k.nim
- /library/cplib/math/osa_k.nim.html
title: cplib/math/osa_k.nim
---
