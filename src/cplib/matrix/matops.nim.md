---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':warning:'
    path: verify/collections/hashset_abc336f_test_.nim
    title: verify/collections/hashset_abc336f_test_.nim
  - icon: ':warning:'
    path: verify/collections/hashset_abc336f_test_.nim
    title: verify/collections/hashset_abc336f_test_.nim
  - icon: ':warning:'
    path: verify/matrix/matops_polyomino_test_.nim
    title: verify/matrix/matops_polyomino_test_.nim
  - icon: ':warning:'
    path: verify/matrix/matops_polyomino_test_.nim
    title: verify/matrix/matops_polyomino_test_.nim
  - icon: ':warning:'
    path: verify/matrix/rotate_abc298b_test_.nim
    title: verify/matrix/rotate_abc298b_test_.nim
  - icon: ':warning:'
    path: verify/matrix/rotate_abc298b_test_.nim
    title: verify/matrix/rotate_abc298b_test_.nim
  - icon: ':warning:'
    path: verify/matrix/rotate_abc336f_test_.nim
    title: verify/matrix/rotate_abc336f_test_.nim
  - icon: ':warning:'
    path: verify/matrix/rotate_abc336f_test_.nim
    title: verify/matrix/rotate_abc336f_test_.nim
  - icon: ':warning:'
    path: verify/matrix/transpose_abc237b_test_.nim
    title: verify/matrix/transpose_abc237b_test_.nim
  - icon: ':warning:'
    path: verify/matrix/transpose_abc237b_test_.nim
    title: verify/matrix/transpose_abc237b_test_.nim
  - icon: ':warning:'
    path: verify/matrix/transposed_abc237b_test_.nim
    title: verify/matrix/transposed_abc237b_test_.nim
  - icon: ':warning:'
    path: verify/matrix/transposed_abc237b_test_.nim
    title: verify/matrix/transposed_abc237b_test_.nim
  - icon: ':warning:'
    path: verify/matrix/trimmed_seq_abc307c_test_.nim
    title: verify/matrix/trimmed_seq_abc307c_test_.nim
  - icon: ':warning:'
    path: verify/matrix/trimmed_seq_abc307c_test_.nim
    title: verify/matrix/trimmed_seq_abc307c_test_.nim
  - icon: ':warning:'
    path: verify/matrix/trimmed_string_abc307c_test_.nim
    title: verify/matrix/trimmed_string_abc307c_test_.nim
  - icon: ':warning:'
    path: verify/matrix/trimmed_string_abc307c_test_.nim
    title: verify/matrix/trimmed_string_abc307c_test_.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_unit_test.nim
    title: verify/matrix/matrix_unit_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/matrix/matrix_unit_test.nim
    title: verify/matrix/matrix_unit_test.nim
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
  code: "when not declared CPLIB_MATRIX_MATOPS:\n    const CPLIB_MATRIX_MATOPS* =\
    \ 1\n    import sequtils, strutils\n    proc rotated*[T](a: seq[seq[T]], num:\
    \ int = 1): seq[seq[T]] =\n        if a.len == 0: return a\n        proc smod(n,\
    \ m: int): int = (result = n mod m; if result < 0: result += m)\n        var h\
    \ = a.len\n        var w = a[0].len\n        var num = smod(num, 4)\n        if\
    \ num == 0: return a\n        if num == 1 or num == 3:\n            result = newSeqWith(w,\
    \ newSeq[T](h))\n            for i in 0..<w:\n                for j in 0..<h:\n\
    \                    if num == 1: result[i][j] = a[h-1-j][i]\n               \
    \     else: result[i][j] = a[j][w-1-i]\n        else:\n            result = newSeqWith(h,\
    \ newSeq[T](w))\n            for i in 0..<h:\n                for j in 0..<w:\n\
    \                    result[i][j] = a[h-1-i][w-1-j]\n    proc transposed*[T](a:\
    \ seq[seq[T]]): seq[seq[T]] =\n        if a.len == 0: return a\n        var h\
    \ = a.len\n        var w = a[0].len\n        result = newSeqWith(w, newSeq[T](h))\n\
    \        for i in 0..<w:\n            for j in 0..<h:\n                result[i][j]\
    \ = a[j][i]\n    proc trimmed*[T](a: seq[seq[T]], zero: T): seq[seq[T]] =\n  \
    \      result = a\n        for i in 0..<4:\n            result = result.rotated\n\
    \            while result.len > 0 and result[^1].allIt(it == zero): discard result.pop\n\
    \    proc rotated*(a: seq[string], num: int = 1): seq[string] = a.mapIt(it.toSeq).rotated(num).mapIt(it.join(\"\
    \"))\n    proc rotate*[T](a: var seq[seq[T]], num: int = 1) = (a = rotated(a,\
    \ num))\n    proc rotate*(a: var seq[string], num: int = 1) = (a = rotated(a,\
    \ num))\n    proc transposed*(a: seq[string]): seq[string] = a.mapIt(it.toSeq).transposed.mapIt(it.join(\"\
    \"))\n    proc transpose*[T](a: var seq[seq[T]]) = (a = a.transposed)\n    proc\
    \ transpose*(a: var seq[string]) = (a = a.transposed)\n    proc trimmed*(a: seq[string],\
    \ zero: char = '0'): seq[string] = a.mapIt(it.toSeq).trimmed(zero).mapIt(it.join(\"\
    \"))\n    proc trim*[T](a: var seq[seq[T]], zero: T) = (a = trimmed(a, zero))\n\
    \    proc trim*(a: var seq[string], zero: char = '0') = (a = trimmed(a, zero))\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/matrix/matops.nim
  requiredBy:
  - verify/matrix/trimmed_seq_abc307c_test_.nim
  - verify/matrix/trimmed_seq_abc307c_test_.nim
  - verify/matrix/rotate_abc336f_test_.nim
  - verify/matrix/rotate_abc336f_test_.nim
  - verify/matrix/matops_polyomino_test_.nim
  - verify/matrix/matops_polyomino_test_.nim
  - verify/matrix/transpose_abc237b_test_.nim
  - verify/matrix/transpose_abc237b_test_.nim
  - verify/matrix/transposed_abc237b_test_.nim
  - verify/matrix/transposed_abc237b_test_.nim
  - verify/matrix/trimmed_string_abc307c_test_.nim
  - verify/matrix/trimmed_string_abc307c_test_.nim
  - verify/matrix/rotate_abc298b_test_.nim
  - verify/matrix/rotate_abc298b_test_.nim
  - verify/collections/hashset_abc336f_test_.nim
  - verify/collections/hashset_abc336f_test_.nim
  timestamp: '2024-01-31 11:34:09+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/matrix/matrix_unit_test.nim
  - verify/matrix/matrix_unit_test.nim
documentation_of: cplib/matrix/matops.nim
layout: document
redirect_from:
- /library/cplib/matrix/matops.nim
- /library/cplib/matrix/matops.nim.html
title: cplib/matrix/matops.nim
---
