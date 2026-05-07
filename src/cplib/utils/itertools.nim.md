---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/utils/itertools/accumulate_test.nim
    title: verify/utils/itertools/accumulate_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/itertools/accumulate_test.nim
    title: verify/utils/itertools/accumulate_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/itertools/accumulated_2_test.nim
    title: verify/utils/itertools/accumulated_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/itertools/accumulated_2_test.nim
    title: verify/utils/itertools/accumulated_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/itertools/accumulated_test.nim
    title: verify/utils/itertools/accumulated_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/itertools/accumulated_test.nim
    title: verify/utils/itertools/accumulated_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/itertools/accumulatedr_2_test.nim
    title: verify/utils/itertools/accumulatedr_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/itertools/accumulatedr_2_test.nim
    title: verify/utils/itertools/accumulatedr_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/itertools/accumulatedr_test.nim
    title: verify/utils/itertools/accumulatedr_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/itertools/accumulatedr_test.nim
    title: verify/utils/itertools/accumulatedr_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/itertools/accumulater_test.nim
    title: verify/utils/itertools/accumulater_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/itertools/accumulater_test.nim
    title: verify/utils/itertools/accumulater_test.nim
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
  code: "when not declared CPLIB_UTILS_ITERTOOLS:\n    const CPLIB_UTILS_ITERTOOLS*\
    \ = 1\n    import algorithm,sequtils\n\n    iterator permutations*[T](v : seq[T]):seq[T]=\n\
    \        ## python\u306Eitertools\u306Epermutations\u3068\u540C\u3058\u52D5\u4F5C\
    \u3092\u3057\u307E\u3059\u3002\n        var idxs = (0..<len(v)).toseq()\n    \
    \    while true:\n            yield idxs.mapit(v[it])\n            if not nextPermutation(idxs):\n\
    \                break\n\n    iterator distinct_permutations*[T](v : seq[T]):seq[T]=\n\
    \        ## next_permutaion\u3092\u3059\u308B\u306E\u3068\u540C\u3058\u52D5\u4F5C\
    \u3092\u3057\u307E\u3059\u3002\n        var tmp = v.sorted()\n        while true:\n\
    \            yield tmp\n            if not nextPermutation(tmp):\n           \
    \     break\n\n    template accumulated*[T](sequence:seq[T],operation:untyped,first:T):seq[T]=\n\
    \        let inner_seq = sequence\n        var result = newseq[T](len(inner_seq)+1)\n\
    \        result[0] = first\n        for i in 0..<len(inner_seq):\n           \
    \ let\n                a {.inject.} = result[i]\n                b {.inject.}\
    \ = inner_seq[i]\n            result[i+1] = operation\n        result\n\n    template\
    \ accumulated*[T](sequence:seq[T],operation:untyped):seq[T]=\n        let inner_seq\
    \ = sequence\n        var result = newseq[T](len(inner_seq))\n        if len(inner_seq)\
    \ >= 1:\n            result[0] = inner_seq[0]\n        for i in 1..<len(inner_seq):\n\
    \            let\n                a {.inject.} = result[i-1]\n               \
    \ b {.inject.} = inner_seq[i]\n            result[i] = operation\n        result\n\
    \n    template accumulate*[T](sequence:var seq[T],operation:untyped)=\n      \
    \  for i in 1..<len(sequence):\n            let\n                a {.inject.}\
    \ = sequence[i-1]\n                b {.inject.} = sequence[i]\n            sequence[i]\
    \ = operation\n\n    template accumulatedr*[T](sequence:seq[T],operation:untyped,first:T):seq[T]=\n\
    \        let inner_seq = sequence\n        var result = newseq[T](len(inner_seq)+1)\n\
    \        result[^1] = first\n        for i in countdown(len(inner_seq),1,1):\n\
    \            let\n                a {.inject.} = inner_seq[i-1]\n            \
    \    b {.inject.} = result[i]\n            result[i-1] = operation\n        result\n\
    \n    template accumulatedr*[T](sequence:seq[T],operation:untyped):seq[T]=\n \
    \       let inner_seq = sequence\n        var result = newseq[T](len(inner_seq))\n\
    \        if len(inner_seq) >= 1:\n            result[^1] = inner_seq[^1]\n   \
    \     for i in countdown(len(inner_seq)-2,0,1):\n            let\n           \
    \     a {.inject.} = inner_seq[i]\n                b {.inject.} = result[i+1]\n\
    \            result[i] = operation\n        result\n\n    template accumulater*[T](sequence:var\
    \ seq[T],operation:untyped)=\n        for i in countdown(len(sequence)-2,0,1):\n\
    \            let\n                a {.inject.} = sequence[i]\n               \
    \ b {.inject.} = sequence[i+1]\n            sequence[i] = operation\n\n    iterator\
    \ combinations*[T](v: seq[T], r: int): seq[T] =\n        let n = len(v)\n    \
    \    if r == 0:\n            yield @[]\n        elif 0 <= r and r <= n:\n    \
    \        var idx = newSeq[int](r)\n            for i in 0..<r:\n             \
    \   idx[i] = i\n\n            var x = newSeq[T](r)\n            while true:\n\
    \                for i in 0..<r:\n                    x[i] = v[idx[i]]\n     \
    \           yield x\n\n                var i = r - 1\n                while i\
    \ >= 0 and idx[i] == i + n - r:\n                    dec i\n                if\
    \ i < 0:\n                    break\n\n                inc idx[i]\n          \
    \      for j in (i + 1)..<r:\n                    idx[j] = idx[j - 1] + 1\n  \
    \  \n    iterator combinations_withf*[T](v: seq[T], r: int, f: proc(l, r: T):\
    \ T): T =\n        ## `combinations(v, r)` \u306E\u5404\u7D44\u5408\u305B\u3092\
    \ `f` \u3067\u5DE6\u7573\u307F\u8FBC\u307F\u3057\u305F\u5024\u3092 yield \u3059\
    \u308B\u3002\n        ## \u4F8B: `f = proc(a,b:int):int = a*b` \u306A\u3089 \u5404\
    \u7D44\u5408\u305B\u306E\u7DCF\u7A4D\u3002\n        ## \u63A5\u982D\u8F9E\u7573\
    \u307F\u8FBC\u307F\u3092\u4FDD\u6301\u3057\u3001\u5909\u5316\u306E\u3042\u3063\
    \u305F\u6DFB\u5B57\u4EE5\u964D\u306E\u307F\u518D\u8A08\u7B97\u3059\u308B\u5DEE\
    \u5206\u66F4\u65B0\u7248\u3002\n        let n = len(v)\n        if r == 0:\n \
    \           discard # 0 \u8981\u7D20\u306E\u7D44\u5408\u305B\u306F\u7573\u307F\
    \u8FBC\u307F\u5358\u4F4D\u5143\u304C\u4E0D\u660E\u306A\u306E\u3067\u4F55\u3082\
    \ yield \u3057\u306A\u3044\n        else:\n            if r <= n:\n          \
    \      var idx = newSeq[int](r)\n                var pref = newSeq[T](r)\n   \
    \             for i in 0..<r:\n                    idx[i] = i\n              \
    \  pref[0] = v[0]\n                for i in 1..<r:\n                    pref[i]\
    \ = f(pref[i - 1], v[i])\n                yield pref[r - 1]\n                while\
    \ true:\n                    var i = r - 1\n                    while i >= 0 and\
    \ idx[i] == i + n - r:\n                        dec i\n                    if\
    \ i < 0:\n                        break\n                    inc idx[i]\n    \
    \                if i == 0:\n                        pref[0] = v[idx[0]]\n   \
    \                 else:\n                        pref[i] = f(pref[i - 1], v[idx[i]])\n\
    \                    for j in (i + 1)..<r:\n                        idx[j] = idx[j\
    \ - 1] + 1\n                        pref[j] = f(pref[j - 1], v[idx[j]])\n    \
    \                yield pref[r - 1]\n\n    iterator combinations*[T](v: seq[T],\
    \ r: static[int]): array[r, T] =\n        let n = len(v)\n        when r == 0:\n\
    \            var x: array[r, T]\n            yield x\n        else:\n        \
    \    if r <= n:\n                var idx: array[r, int]\n                var x:\
    \ array[r, T]\n                for i in 0..<r:\n                    idx[i] = i\n\
    \                    x[i] = v[i]\n                yield x\n                while\
    \ true:\n                    var i = r - 1\n                    while i >= 0 and\
    \ idx[i] == i + n - r:\n                        dec i\n                    if\
    \ i < 0:\n                        break\n                    inc idx[i]\n    \
    \                x[i] = v[idx[i]]\n                    for j in (i + 1)..<r:\n\
    \                        idx[j] = idx[j - 1] + 1\n                        x[j]\
    \ = v[idx[j]]\n                    yield x\n\n    iterator product*[T](v: seq[T],repeat:int):seq[T]=\n\
    \        if repeat == 0:\n            yield @[]\n        else:\n            var\
    \ idxs = newseq[int](repeat)\n            var f = true\n            while f:\n\
    \                yield idxs.mapit(v[it])\n                for i in 0..<repeat:\n\
    \                    idxs[i] += 1\n                    if idxs[i] == len(v):\n\
    \                        idxs[i] = 0\n                        if i == repeat-1:\n\
    \                            f = false\n                        continue\n   \
    \                 else:\n                        break\n    iterator partitions*(n:\
    \ int): seq[int] =\n        ## \u5206\u5272\u6570\u5217\u6319\n        if n ==\
    \ 0:\n            yield @[]\n        else:\n            var a = newSeq[int](n\
    \ + 1)\n            var k = 1\n            a[1] = n\n            while k != 0:\n\
    \                var x = a[k - 1] + 1\n                var y = a[k] - 1\n    \
    \            dec k\n                while x <= y:\n                    a[k] =\
    \ x\n                    y -= x\n                    inc k\n                a[k]\
    \ = x + y\n                yield a[0 .. k]\n\n\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/itertools.nim
  requiredBy: []
  timestamp: '2026-05-07 18:27:55+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/itertools/accumulated_2_test.nim
  - verify/utils/itertools/accumulated_2_test.nim
  - verify/utils/itertools/accumulater_test.nim
  - verify/utils/itertools/accumulater_test.nim
  - verify/utils/itertools/accumulate_test.nim
  - verify/utils/itertools/accumulate_test.nim
  - verify/utils/itertools/accumulated_test.nim
  - verify/utils/itertools/accumulated_test.nim
  - verify/utils/itertools/accumulatedr_test.nim
  - verify/utils/itertools/accumulatedr_test.nim
  - verify/utils/itertools/accumulatedr_2_test.nim
  - verify/utils/itertools/accumulatedr_2_test.nim
documentation_of: cplib/utils/itertools.nim
layout: document
redirect_from:
- /library/cplib/utils/itertools.nim
- /library/cplib/utils/itertools.nim.html
title: cplib/utils/itertools.nim
---
