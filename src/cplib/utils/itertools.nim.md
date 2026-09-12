---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/itertools_enumeration_test.nim
    title: verify/AI/itertools_enumeration_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/itertools_enumeration_test.nim
    title: verify/AI/itertools_enumeration_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/itertools_test.nim
    title: verify/AI/itertools_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/itertools_test.nim
    title: verify/AI/itertools_test.nim
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
    \ = 1\n    import algorithm, sequtils, options\n    import cplib/graph/graph\n\
    \    import cplib/tree/prufer\n\n    iterator permutations*[T](v : seq[T]):seq[T]=\n\
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
    \  \n    iterator combinations_withf*[T](v: openArray[T], r: int, f: proc(l, r:\
    \ T): T): T =\n        ## `combinations(v, r)` \u306E\u5404\u7D44\u5408\u305B\u3092\
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
    \                yield pref[r - 1]\n\n    iterator combinations*[T](v: openArray[T],\
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
    \        if repeat == 0:\n            yield @[]\n        elif v.len > 0:\n   \
    \         var idxs = newseq[int](repeat)\n            var f = true\n         \
    \   while f:\n                yield idxs.mapit(v[it])\n                for i in\
    \ 0..<repeat:\n                    idxs[i] += 1\n                    if idxs[i]\
    \ == len(v):\n                        idxs[i] = 0\n                        if\
    \ i == repeat-1:\n                            f = false\n                    \
    \    continue\n                    else:\n                        break\n    iterator\
    \ partitions*(n: int): seq[int] =\n        ## \u5206\u5272\u6570\u5217\u6319\n\
    \        if n == 0:\n            yield @[]\n        else:\n            var a =\
    \ newSeq[int](n + 1)\n            var k = 1\n            a[1] = n\n          \
    \  while k != 0:\n                var x = a[k - 1] + 1\n                var y\
    \ = a[k] - 1\n                dec k\n                while x <= y:\n         \
    \           a[k] = x\n                    y -= x\n                    inc k\n\
    \                a[k] = x + y\n                yield a[0 .. k]\n\n    iterator\
    \ bounded_sequences*(a: openArray[int]): seq[int] =\n        ## \u975E\u8CA0\u6574\
    \u6570\u5217 a \u306B\u5BFE\u3057\u30010 <= b[i] <= a[i] \u3092\u6E80\u305F\u3059\
    \u5217\u3092\u8F9E\u66F8\u9806\u306B\u5217\u6319\u3002\n        ## \u7A7A\u5165\
    \u529B\u3067\u306F\u7A7A\u5217\u30921\u4EF6\u8FD4\u3059\u30021\u4EF6\u3042\u305F\
    \u308A O(a.len)\u3001\u8FFD\u52A0\u9818\u57DF O(a.len)\u3002\n        for upper\
    \ in a: assert upper >= 0\n        var b = newSeq[int](a.len)\n        while true:\n\
    \            yield b\n            var i = a.len - 1\n            while i >= 0\
    \ and b[i] == a[i]:\n                b[i] = 0\n                dec i\n       \
    \     if i < 0: break\n            inc b[i]\n\n    iterator bounded_sum_sequences*(s:\
    \ int, bounds: openArray[tuple[l, r: int]]): seq[int] =\n        ## \u7DCF\u548C\
    \ s\u3001bounds[i].l <= a[i] < bounds[i].r \u306E\u6570\u5217\u3092\u8F9E\u66F8\
    \u9806\u306B\u5217\u6319\u3002\n        ## \u7A7A\u306E bounds \u306F s == 0 \u306E\
    \u3068\u304D\u3060\u3051\u7A7A\u5217\u3092\u8FD4\u3059\u3002\u7A7A\u306E\u7BC4\
    \u56F2\u306F\u89E3\u306A\u3057\u3002\n        ## \u5404\u7BC4\u56F2\u306E\u7AEF\
    \u70B9\u30FB\u7D2F\u7A4D\u548C\u30FB\u5DEE\u306E\u8A08\u7B97\u306F int \u306B\u53CE\
    \u307E\u308B\u3053\u3068\u3002\n        let n = bounds.len\n        var lo = newSeq[int](n\
    \ + 1)\n        var hi = newSeq[int](n + 1)\n        var valid = true\n      \
    \  for i in countdown(n - 1, 0):\n            if bounds[i].l >= bounds[i].r:\n\
    \                valid = false\n                break\n            lo[i] = lo[i\
    \ + 1] + bounds[i].l\n            hi[i] = hi[i + 1] + bounds[i].r - 1\n      \
    \  if valid and lo[0] <= s and s <= hi[0]:\n            if n == 0:\n         \
    \       yield @[]\n            else:\n                var a = newSeq[int](n)\n\
    \                var remaining = newSeq[int](n + 1)\n                var upper\
    \ = newSeq[int](n)\n                remaining[0] = s\n                var depth\
    \ = 0\n                a[0] = max(bounds[0].l, s - hi[1])\n                upper[0]\
    \ = min(bounds[0].r - 1, s - lo[1])\n                while depth >= 0:\n     \
    \               if a[depth] > upper[depth]:\n                        dec depth\n\
    \                        if depth >= 0: inc a[depth]\n                    elif\
    \ depth == n - 1:\n                        yield a\n                        inc\
    \ a[depth]\n                    else:\n                        remaining[depth\
    \ + 1] = remaining[depth] - a[depth]\n                        inc depth\n    \
    \                    a[depth] = max(bounds[depth].l, remaining[depth] - hi[depth\
    \ + 1])\n                        upper[depth] = min(bounds[depth].r - 1, remaining[depth]\
    \ - lo[depth + 1])\n\n    iterator bounded_sum_sequences*(n, s, l, r: int): seq[int]\
    \ =\n        ## \u9577\u3055 n\u3001\u7DCF\u548C s\u3001\u5404\u8981\u7D20\u304C\
    \ [l, r) \u306E\u6570\u5217\u3092\u8F9E\u66F8\u9806\u306B\u5217\u6319\u3002\n\
    \        assert n >= 0\n        for a in bounded_sum_sequences(s, newSeqWith(n,\
    \ (l: l, r: r))):\n            yield a\n\n    iterator monotone_sequences_impl(n,\
    \ l, r, step: int, target: Option[int]): seq[int] =\n        assert n >= 0\n \
    \       if n == 0:\n            if target.isNone or target.get == 0: yield @[]\n\
    \        elif l < r and (step == 0 or n <= r - l):\n            var a = newSeq[int](n)\n\
    \            var prefix = newSeq[int](n + 1)\n            var depth = 0\n    \
    \        a[0] = l\n            while depth >= 0:\n                let count =\
    \ n - depth\n                let upper = r - 1 - step * (count - 1)\n        \
    \        var exhausted = a[depth] > upper\n                if not exhausted and\
    \ target.isSome:\n                    let minimum = prefix[depth] + count * a[depth]\
    \ + step * (count * (count - 1) div 2)\n                    let maximum = prefix[depth]\
    \ + a[depth] + (count - 1) * (r - 1) - step * ((count - 1) * (count - 2) div 2)\n\
    \                    if minimum > target.get:\n                        exhausted\
    \ = true\n                    elif maximum < target.get:\n                   \
    \     # \u3053\u306E\u63A5\u982D\u8F9E\u3067\u306F\u7DCF\u548C\u304C\u8DB3\u308A\
    \u306A\u3044\u306E\u3067\u3001\u5019\u88DC\u3092\u76F4\u63A5\u9032\u3081\u308B\
    \u3002\n                        a[depth] += target.get - maximum\n           \
    \             continue\n                if exhausted:\n                    dec\
    \ depth\n                    if depth >= 0: inc a[depth]\n                elif\
    \ depth == n - 1:\n                    yield a\n                    inc a[depth]\n\
    \                else:\n                    prefix[depth + 1] = prefix[depth]\
    \ + a[depth]\n                    a[depth + 1] = a[depth] + step\n           \
    \         inc depth\n\n    iterator nondecreasing_sequences*(n, l, r: int): seq[int]\
    \ =\n        ## \u9577\u3055 n\u3001\u5404\u8981\u7D20\u304C [l, r) \u306E\u5E83\
    \u7FA9\u5358\u8ABF\u5897\u52A0\u5217\u3092\u8F9E\u66F8\u9806\u306B\u5217\u6319\
    \u3002\n        for a in monotone_sequences_impl(n, l, r, 0, none(int)): yield\
    \ a\n\n    iterator nondecreasing_sequences*(n, s, l, r: int): seq[int] =\n  \
    \      ## \u7DCF\u548C s \u3092\u6307\u5B9A\u3059\u308B\u7248\u3002\u7AEF\u70B9\
    \u30FB\u7DCF\u548C\u306E\u4E2D\u9593\u8A08\u7B97\u306F int \u306B\u53CE\u307E\u308B\
    \u3053\u3068\u3002\n        for a in monotone_sequences_impl(n, l, r, 0, some(s)):\
    \ yield a\n\n    iterator strictly_increasing_sequences*(n, l, r: int): seq[int]\
    \ =\n        ## \u9577\u3055 n\u3001\u5404\u8981\u7D20\u304C [l, r) \u306E\u72ED\
    \u7FA9\u5358\u8ABF\u5897\u52A0\u5217\u3092\u8F9E\u66F8\u9806\u306B\u5217\u6319\
    \u3002\n        for a in monotone_sequences_impl(n, l, r, 1, none(int)): yield\
    \ a\n\n    iterator strictly_increasing_sequences*(n, s, l, r: int): seq[int]\
    \ =\n        ## \u7DCF\u548C s \u3092\u6307\u5B9A\u3059\u308B\u7248\u3002\u7AEF\
    \u70B9\u30FB\u7DCF\u548C\u306E\u4E2D\u9593\u8A08\u7B97\u306F int \u306B\u53CE\u307E\
    \u308B\u3053\u3068\u3002\n        for a in monotone_sequences_impl(n, l, r, 1,\
    \ some(s)): yield a\n\n    iterator cartesian_product*[T](choices: openArray[seq[T]]):\
    \ seq[T] =\n        ## \u5404\u4F4D\u7F6E\u306E\u5019\u88DC\u304B\u30891\u3064\
    \u305A\u3064\u9078\u3076\u3002\u53F3\u7AEF\u304B\u3089\u5019\u88DC\u306E\u6DFB\
    \u5B57\u3092\u9032\u3081\u308B\u3002\n        ## \u4F4D\u7F6E\u304C0\u500B\u306A\
    \u3089\u7A7A\u5217\u30921\u4EF6\u3001\u7A7A\u306E\u5019\u88DC\u304C\u3042\u308C\
    \u30700\u4EF6\u3002\u5019\u88DC\u5185\u306E\u91CD\u8907\u306F\u4FDD\u6301\u3002\
    \n        let n = choices.len\n        var valid = true\n        for choice in\
    \ choices:\n            if choice.len == 0: valid = false\n        if valid:\n\
    \            var indices = newSeq[int](n)\n            var a = newSeq[T](n)\n\
    \            while true:\n                for i in 0..<n: a[i] = choices[i][indices[i]]\n\
    \                yield a\n                var i = n - 1\n                while\
    \ i >= 0 and indices[i] == choices[i].len - 1:\n                    indices[i]\
    \ = 0\n                    dec i\n                if i < 0: break\n          \
    \      inc indices[i]\n\n    iterator set_partitions_id*(n: int, k: int = -1):\
    \ seq[int] =\n        ## 0..<n \u306E\u96C6\u5408\u5206\u5272\u3092\u6240\u5C5E\
    \u30B0\u30EB\u30FC\u30D7\u756A\u53F7\u306E\u5217\u3067\u8FD4\u3059\u3002k == -1\
    \ \u306F\u500B\u6570\u6307\u5B9A\u306A\u3057\u3002\n        ## \u30B0\u30EB\u30FC\
    \u30D7\u756A\u53F7\u306F\u521D\u51FA\u9806\u306B 0, 1, ... \u3068\u3057\u3001\u756A\
    \u53F7\u306E\u4ED8\u3051\u66FF\u3048\u306B\u3088\u308B\u91CD\u8907\u3092\u9664\
    \u304F\u3002\n        assert n >= 0 and k >= -1\n        if n == 0:\n        \
    \    if k == -1 or k == 0: yield @[]\n        elif k != 0 and k <= n:\n      \
    \      var a = newSeq[int](n)\n            var groups = newSeq[int](n + 1)\n \
    \           var depth = 0\n            while depth >= 0:\n                var\
    \ upper = groups[depth]\n                if k >= 0: upper = min(upper, k - 1)\n\
    \                if a[depth] > upper:\n                    dec depth\n       \
    \             if depth >= 0: inc a[depth]\n                else:\n           \
    \         groups[depth + 1] = max(groups[depth], a[depth] + 1)\n             \
    \       if k >= 0 and groups[depth + 1] + n - depth - 1 < k:\n               \
    \         inc a[depth]\n                    elif depth == n - 1:\n           \
    \             yield a\n                        inc a[depth]\n                \
    \    else:\n                        inc depth\n                        a[depth]\
    \ = 0\n\n    iterator set_partitions*(n: int, k: int = -1): seq[seq[int]] =\n\
    \        ## 0..<n \u306E\u96C6\u5408\u5206\u5272\u3092\u3001\u5404\u30B0\u30EB\
    \u30FC\u30D7\u306E\u8981\u7D20\u306E\u5217\u3067\u8FD4\u3059\u3002k == -1 \u306F\
    \u500B\u6570\u6307\u5B9A\u306A\u3057\u3002\n        ## \u5404\u30B0\u30EB\u30FC\
    \u30D7\u5185\u306F\u6607\u9806\u3001\u30B0\u30EB\u30FC\u30D7\u9593\u306F\u6700\
    \u5C0F\u8981\u7D20\u306E\u6607\u9806\u3002\u5217\u6319\u9806\u306F set_partitions_id\
    \ \u3068\u540C\u3058\u3002\n        ## n == 0 \u306F k == -1 \u307E\u305F\u306F\
    \ k == 0 \u306E\u3068\u304D\u3060\u3051\u7A7A\u5217\u30921\u4EF6\u8FD4\u3059\u3002\
    \n        assert n >= 0 and k >= -1\n        if n == 0:\n            if k == -1\
    \ or k == 0: yield newSeq[seq[int]]()\n        elif k != 0 and k <= n:\n     \
    \       var groups = newSeqOfCap[seq[int]](n)\n            var spare = newSeq[seq[int]](n)\n\
    \            var choice = newSeq[int](n)\n            var depth = 0\n        \
    \    while depth >= 0:\n                var upper = groups.len\n             \
    \   if k >= 0: upper = min(upper, k - 1)\n                if choice[depth] > upper:\n\
    \                    if depth == 0: break\n                    dec depth\n   \
    \             else:\n                    let count = max(groups.len, choice[depth]\
    \ + 1)\n                    if k >= 0 and count + n - depth - 1 < k:\n       \
    \                 inc choice[depth]\n                        continue\n      \
    \              if choice[depth] == groups.len:\n                        groups.setLen(groups.len\
    \ + 1)\n                        swap(groups[^1], spare[depth])\n             \
    \       groups[choice[depth]].add(depth)\n                    if depth == n -\
    \ 1:\n                        yield groups\n                    else:\n      \
    \                  inc depth\n                        choice[depth] = 0\n    \
    \                    continue\n                let id = choice[depth]\n      \
    \          groups[id].setLen(groups[id].len - 1)\n                if groups[id].len\
    \ == 0:\n                    # \u7A7A\u306B\u306A\u3063\u305F\u30B0\u30EB\u30FC\
    \u30D7\u306E\u5BB9\u91CF\u3082\u6B21\u306E\u63A2\u7D22\u3067\u518D\u5229\u7528\
    \u3059\u308B\u3002\n                    spare[depth] = move(groups[id])\n    \
    \                groups.setLen(groups.len - 1)\n                inc choice[depth]\n\
    \n    iterator pairings*(n: int): seq[tuple[u, v: int]] =\n        ## 0..<n \u3092\
    \u30DA\u30A2\u306B\u5206\u3051\u308B\u5168\u901A\u308A\u3002\u30DA\u30A2\u5185\
    \u30FB\u30DA\u30A2\u9593\u306E\u9806\u5E8F\u306B\u3088\u308B\u91CD\u8907\u306A\
    \u3057\u3002\n        ## n == 0 \u306F\u7A7A\u5217\u30921\u4EF6\u3001\u5947\u6570\
    \u306A\u30890\u4EF6\u3002\n        assert n >= 0\n        if n == 0:\n       \
    \     yield @[]\n        elif n mod 2 == 0:\n            var used = newSeq[bool](n)\n\
    \            var pairs = newSeq[tuple[u, v: int]](n div 2)\n            var depth\
    \ = 0\n            pairs[0] = (0, 0)\n            used[0] = true\n           \
    \ while depth >= 0:\n                inc pairs[depth].v\n                while\
    \ pairs[depth].v < n and used[pairs[depth].v]:\n                    inc pairs[depth].v\n\
    \                if pairs[depth].v == n:\n                    used[pairs[depth].u]\
    \ = false\n                    dec depth\n                    if depth >= 0: used[pairs[depth].v]\
    \ = false\n                elif depth == pairs.len - 1:\n                    yield\
    \ pairs\n                else:\n                    used[pairs[depth].v] = true\n\
    \                    var u = 0\n                    while used[u]: inc u\n   \
    \                 inc depth\n                    pairs[depth] = (u, u)\n     \
    \               used[u] = true\n\n    iterator contiguous_partitions*(n: int,\
    \ k: int = -1): seq[int] =\n        ## \u9577\u3055 n \u306E\u5217\u3092 k \u500B\
    \u306E\u975E\u7A7A\u9023\u7D9A\u533A\u9593\u306B\u5206\u3051\u308B\u5883\u754C\
    \ [0, ..., n] \u3092\u8FD4\u3059\u3002\n        ## \u533A\u9593 i \u306F [b[i],\
    \ b[i+1])\u3002k == -1 \u306F\u533A\u9593\u6570\u6307\u5B9A\u306A\u3057\u3002\u7A7A\
    \u5217\u306E\u5883\u754C\u306F @[0]\u3002\n        assert n >= 0 and k >= -1\n\
    \        if n == 0:\n            if k == -1 or k == 0: yield @[0]\n        elif\
    \ k != 0 and k <= n:\n            let first = if k == -1: 1 else: k\n        \
    \    let last = if k == -1: n else: k\n            for count in first..last:\n\
    \                for cuts in strictly_increasing_sequences(count - 1, 1, n):\n\
    \                    yield @[0] & cuts & @[n]\n\n    iterator parenthesis_sequences*(n:\
    \ int): string =\n        ## n \u7D44\uFF08\u9577\u3055 2*n\uFF09\u306E\u6B63\u3057\
    \u3044\u62EC\u5F27\u5217\u3092\u8F9E\u66F8\u9806\u306B\u5217\u6319\u3002n == 0\
    \ \u306F\u7A7A\u6587\u5B57\u5217\u3002\n        assert n >= 0\n        if n ==\
    \ 0:\n            yield \"\"\n        else:\n            var a = newString(2 *\
    \ n)\n            var balance = newSeq[int](2 * n + 1)\n            var choice\
    \ = newSeq[int](2 * n)\n            var depth = 0\n            while depth >=\
    \ 0:\n                if choice[depth] >= 2:\n                    dec depth\n\
    \                else:\n                    let opening = choice[depth] == 0\n\
    \                    inc choice[depth]\n                    if opening and (depth\
    \ + balance[depth]) div 2 == n: continue\n                    if not opening and\
    \ balance[depth] == 0: continue\n                    a[depth] = if opening: '('\
    \ else: ')'\n                    balance[depth + 1] = balance[depth] + (if opening:\
    \ 1 else: -1)\n                    if depth == a.len - 1:\n                  \
    \      yield a\n                    else:\n                        inc depth\n\
    \                        choice[depth] = 0\n\n    iterator labeled_trees*(n: int):\
    \ UnWeightedUnDirectedGraph =\n        ## \u9802\u70B9\u756A\u53F7 0..<n \u306E\
    \u6728\u3092\u91CD\u8907\u306A\u304F\u5217\u6319\u3002n >= 1\u3002\n        ##\
    \ Pr\xFCfer \u5217\u3092\u4F7F\u7528\u3057\u3001n >= 2 \u3067\u306F n^(n-2) \u4EF6\
    \u3002\n        assert n >= 1\n        if n == 1:\n            yield initUnWeightedUnDirectedGraph(1)\n\
    \        else:\n            for code in product(toSeq(0..<n), n - 2):\n      \
    \          yield prufer_decode(code)\n\n    iterator simple_graphs*(n: int, m:\
    \ int = -1): UnWeightedUnDirectedGraph =\n        ## \u9802\u70B9\u756A\u53F7\
    \ 0..<n\u3001\u8FBA\u6570 m \u306E\u5358\u7D14\u7121\u5411\u30B0\u30E9\u30D5\u3002\
    m == -1 \u306F\u8FBA\u6570\u6307\u5B9A\u306A\u3057\u3002\n        ## \u540C\u578B\
    \u3067\u3082\u9802\u70B9\u756A\u53F7\u304C\u7570\u306A\u308B\u30B0\u30E9\u30D5\
    \u306F\u533A\u5225\u3059\u308B\u3002\n        assert n >= 0 and m >= -1\n    \
    \    var edges: seq[tuple[u, v: int]]\n        for u in 0..<n:\n            for\
    \ v in u + 1..<n: edges.add((u, v))\n        let first = if m == -1: 0 else: m\n\
    \        let last = if m == -1: edges.len else: min(m, edges.len)\n        for\
    \ count in first..last:\n            for selected in combinations(edges, count):\n\
    \                var g = initUnWeightedUnDirectedGraph(n)\n                for\
    \ (u, v) in selected: g.add_edge(u, v)\n                yield g\n\n    iterator\
    \ topological_orders*(adj: seq[seq[int]]): seq[int] =\n        ## \u96A3\u63A5\
    \u30EA\u30B9\u30C8\u306E\u30C8\u30DD\u30ED\u30B8\u30AB\u30EB\u9806\u5E8F\u3092\
    \u8F9E\u66F8\u9806\u306B\u5217\u6319\u3002\u6709\u5411\u9589\u8DEF\u304C\u3042\
    \u308B\u5834\u5408\u306F0\u4EF6\u3002\n        let n = adj.len\n        var indegree\
    \ = newSeq[int](n)\n        for edges in adj:\n            for v in edges:\n \
    \               assert v >= 0 and v < n\n                inc indegree[v]\n   \
    \     if n == 0:\n            yield @[]\n        else:\n            var used =\
    \ newSeq[bool](n)\n            var order = newSeq[int](n)\n            var next\
    \ = newSeq[int](n)\n            var depth = 0\n            while depth >= 0:\n\
    \                var u = next[depth]\n                while u < n and (used[u]\
    \ or indegree[u] != 0): inc u\n                if u == n:\n                  \
    \  dec depth\n                    if depth >= 0:\n                        let\
    \ previous = order[depth]\n                        used[previous] = false\n  \
    \                      for v in adj[previous]: inc indegree[v]\n             \
    \   else:\n                    next[depth] = u + 1\n                    order[depth]\
    \ = u\n                    if depth == n - 1:\n                        yield order\n\
    \                    else:\n                        used[u] = true\n         \
    \               for v in adj[u]: dec indegree[v]\n                        inc\
    \ depth\n                        next[depth] = 0\n\n    iterator topological_orders*(g:\
    \ DirectedGraph): seq[int] =\n        ## cplib \u306E\u6709\u5411\u30B0\u30E9\u30D5\
    \u7248\u3002\u91CD\u307F\u306F\u7121\u8996\u3002\u9759\u7684\u30B0\u30E9\u30D5\
    \u306F build \u6E08\u307F\u3067\u3042\u308B\u3053\u3068\u3002\n        var adj\
    \ = newSeq[seq[int]](g.len)\n        for u in 0..<g.len:\n            for (v,\
    \ _) in g.to_and_cost(u): adj[u].add(v)\n        for order in topological_orders(adj):\
    \ yield order\n\n    iterator integer_vectors_l1*(n, s: int): seq[int] =\n   \
    \     ## \u9577\u3055 n\u3001sum(abs(a[i])) <= s \u306E\u6574\u6570\u5217\u3092\
    \u8F9E\u66F8\u9806\u306B\u5217\u6319\u3002\n        ## s < 0 \u306F0\u4EF6\u3002\
    s < high(int) \u3067\u3042\u308B\u3053\u3068\u3002\n        assert n >= 0 and\
    \ s < high(int)\n        if s >= 0:\n            if n == 0:\n                yield\
    \ @[]\n            else:\n                var a = newSeq[int](n)\n           \
    \     var remaining = newSeq[int](n + 1)\n                remaining[0] = s\n \
    \               a[0] = -s\n                var depth = 0\n                while\
    \ depth >= 0:\n                    if a[depth] > remaining[depth]:\n         \
    \               dec depth\n                        if depth >= 0: inc a[depth]\n\
    \                    elif depth == n - 1:\n                        yield a\n \
    \                       inc a[depth]\n                    else:\n            \
    \            remaining[depth + 1] = remaining[depth] - abs(a[depth])\n       \
    \                 inc depth\n                        a[depth] = -remaining[depth]\n\
    \n    proc find_counterexample*[T, U](cases: openArray[T], solve, naive: proc(input:\
    \ T): U): Option[tuple[input: T, actual, expected: U]] =\n        ## \u6700\u521D\
    \u306B solve \u3068 naive \u306E\u623B\u308A\u5024\u304C != \u3068\u306A\u308B\
    \u5165\u529B\u3068\u4E21\u51FA\u529B\u3092\u8FD4\u3059\u3002\n        ## \u5168\
    \u4EF6\u4E00\u81F4\u306A\u3089 none\u3002\u30B3\u30FC\u30EB\u30D0\u30C3\u30AF\u306F\
    \u5165\u529B\u3092\u5909\u66F4\u3057\u306A\u3044\u3053\u3068\u3002\n        for\
    \ input in cases:\n            let actual = solve(input)\n            let expected\
    \ = naive(input)\n            if actual != expected:\n                return some((input:\
    \ input, actual: actual, expected: expected))\n\n    proc find_counterexample*[T,\
    \ U](cases: iterator(): T {.closure.}, solve, naive: proc(input: T): U): Option[tuple[input:\
    \ T, actual, expected: U]] =\n        ## closure iterator \u7248\u3002\u5165\u529B\
    \u30921\u4EF6\u305A\u3064\u751F\u6210\u3057\u3001\u6700\u521D\u306E\u4E0D\u4E00\
    \u81F4\u3067\u4E2D\u65AD\u3059\u308B\u3002\n        for input in cases():\n  \
    \          let actual = solve(input)\n            let expected = naive(input)\n\
    \            if actual != expected:\n                return some((input: input,\
    \ actual: actual, expected: expected))\n\n    proc shrink_counterexample*(input:\
    \ seq[int], fails: proc(input: seq[int]): bool): seq[int] =\n        ## fails\
    \ \u304C\u771F\u306E\u6574\u6570\u5217\u3092\u3001\u8981\u7D20\u524A\u9664\u30FB\
    0\u3078\u306E\u7F6E\u63DB\u30FB0\u65B9\u5411\u3078\u306E\u79FB\u52D5\u3067\u7E2E\
    \u5C0F\u3002\n        ## \u79FB\u52D5\u5E45\u306F\u7D76\u5BFE\u5024\u306E\u534A\
    \u5206\u304B\u30891\u307E\u3067\u534A\u6E1B\u3055\u305B\u3066\u8A66\u3059\u3002\
    \n        ## \u5909\u5316\u3059\u308B\u305F\u3073\u306B\u5148\u982D\u304B\u3089\
    \u518D\u8A66\u884C\u3059\u308B\u8CAA\u6B32\u6CD5\u3067\u3001\u6700\u5C0F\u306E\
    \u53CD\u4F8B\u3068\u306F\u9650\u3089\u306A\u3044\u3002\n        ## fails \u306F\
    \u6C7A\u5B9A\u7684\u3067\u5165\u529B\u3092\u5909\u66F4\u3057\u306A\u3044\u3053\
    \u3068\u3002\u521D\u671F\u5165\u529B\u3067\u3082\u771F\u3067\u3042\u308B\u3053\
    \u3068\u3002\n        assert fails(input)\n        result = input\n        while\
    \ true:\n            var changed = false\n            for i in 0..<result.len:\n\
    \                let candidate = result[0..<i] & result[i + 1..<result.len]\n\
    \                if fails(candidate):\n                    result = candidate\n\
    \                    changed = true\n                    break\n            if\
    \ changed: continue\n            for i in 0..<result.len:\n                let\
    \ value = result[i]\n                if value == 0: continue\n               \
    \ var delta = value\n                while delta != 0:\n                    var\
    \ candidate = result\n                    candidate[i] = value - delta\n     \
    \               if fails(candidate):\n                        result = candidate\n\
    \                        changed = true\n                        break\n     \
    \               delta = delta div 2\n                if changed: break\n     \
    \       if not changed: break\n"
  dependsOn:
  - cplib/tree/prufer.nim
  - cplib/graph/graph.nim
  - cplib/tree/prufer.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/utils/itertools.nim
  requiredBy: []
  timestamp: '2026-09-09 16:56:05+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/itertools/accumulated_test.nim
  - verify/utils/itertools/accumulated_test.nim
  - verify/utils/itertools/accumulated_2_test.nim
  - verify/utils/itertools/accumulated_2_test.nim
  - verify/utils/itertools/accumulatedr_test.nim
  - verify/utils/itertools/accumulatedr_test.nim
  - verify/utils/itertools/accumulatedr_2_test.nim
  - verify/utils/itertools/accumulatedr_2_test.nim
  - verify/utils/itertools/accumulate_test.nim
  - verify/utils/itertools/accumulate_test.nim
  - verify/utils/itertools/accumulater_test.nim
  - verify/utils/itertools/accumulater_test.nim
  - verify/AI/itertools_test.nim
  - verify/AI/itertools_test.nim
  - verify/AI/itertools_enumeration_test.nim
  - verify/AI/itertools_enumeration_test.nim
documentation_of: cplib/utils/itertools.nim
layout: document
redirect_from:
- /library/cplib/utils/itertools.nim
- /library/cplib/utils/itertools.nim.html
title: cplib/utils/itertools.nim
---
