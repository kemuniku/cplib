---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree_beats.nim
    title: cplib/collections/segtree_beats.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree_beats.nim
    title: cplib/collections/segtree_beats.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/range_chmin_chmax_add_range_sum_test.nim
    title: verify/collections/range_chmin_chmax_add_range_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/range_chmin_chmax_add_range_sum_test.nim
    title: verify/collections/range_chmin_chmax_add_range_sum_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_SEGTREE_BEATS_TEMPLATE:\n    const CPLIB_COLLECTIONS_SEGTREE_BEATS_TEMPLATE*\
    \ = 1\n    import sequtils\n    import cplib/collections/segtree_beats\n    import\
    \ cplib/utils/constants\n\n    type S_rch*[T] = object\n        max*: T\n    \
    \    max2*: T\n        min*: T\n        min2*: T\n        sum*: T\n        sz*:\
    \ int\n        n_min*: int\n        n_max*: int\n        fail*: bool\n    type\
    \ F_rch*[T] = object\n        lb*: T\n        ub*: T\n        add*: T\n\n    type\
    \ RangeChminChmaxRangeSumMaxMin*[T] = object\n        seg*: SegmentTreeBeats[S_rch[T],\
    \ F_rch[T]]\n        inf*, zero*: T\n    proc init_S[T](val: T, inf: T, sz: int\
    \ = 1): S_rch[T] = S_rch[T](max: val, max2: -inf, min: val, min2: inf, sum: val\
    \ * T(sz), sz: sz, n_min: sz, n_max: sz, fail: false)\n\n    proc initRangeChminChmaxRangeSumMaxMin*[T](v:\
    \ seq[T], inf: T, zero: T): auto =\n        proc op(l, r: S_rch[T]): S_rch[T]\
    \ =\n            proc second_lowest(a, b, c, d: T): T {.inline.} =\n         \
    \       if a == c: return min(b, d)\n                if b <= c: return b\n   \
    \             if d <= a: return d\n                return max(a, c)\n        \
    \    proc second_highest(a, b, c, d: T): T {.inline.} = -second_lowest(-a, -b,\
    \ -c, -d)\n            result.min = min(l.min, r.min)\n            result.max\
    \ = max(l.max, r.max)\n            result.min2 = second_lowest(l.min, l.min2,\
    \ r.min, r.min2)\n            result.max2 = second_highest(l.max, l.max2, r.max,\
    \ r.max2)\n            result.sum = l.sum + r.sum\n            result.sz = l.sz\
    \ + r.sz\n            result.n_min = l.n_min * int(l.min <= r.min) + r.n_min *\
    \ int(r.min <= l.min)\n            result.n_max = l.n_max * int(l.max >= r.max)\
    \ + r.n_max * int(r.max >= l.max)\n            result.fail = true\n        proc\
    \ e(): S_rch[T] = S_rch[T](max: -inf, max2: -inf, min: inf, min2: inf, sum: zero,\
    \ sz: 0, n_min: 0, n_max: 0, fail: false)\n        proc composition(f, g: F_rch[T]):\
    \ F_rch[T] =\n            result.lb = max(min(g.lb + g.add, f.ub), f.lb) - g.add\n\
    \            result.ub = min(max(g.ub + g.add, f.lb), f.ub) - g.add\n        \
    \    result.add = f.add + g.add\n        proc mapping(f: F_rch[T], x: S_rch[T]):\
    \ S_rch[T] =\n            var x = x\n            x.fail = false\n            if\
    \ x.sz == 0: return e()\n            if x.min == x.max or f.lb == f.ub or f.lb\
    \ >= x.max or f.ub <= x.min:\n                var x = init_S(min(max(x.min, f.lb),\
    \ f.ub) + f.add, inf, x.sz)\n                return x\n            if x.min2 ==\
    \ x.max:\n                x.max2 = max(x.min, f.lb) + f.add\n                x.min\
    \ = max(x.min, f.lb) + f.add\n                x.min2 = min(x.max, f.ub) + f.add\n\
    \                x.max = min(x.max, f.ub) + f.add\n                x.sum = x.min\
    \ * T(x.n_min) + x.max * T(x.n_max)\n                return x\n            if\
    \ f.lb < x.min2 and f.ub > x.max2:\n                var nxt_min = max(x.min, f.lb)\n\
    \                var nxt_max = min(x.max, f.ub)\n                x.sum += (nxt_min\
    \ - x.min) * T(x.n_min) - (x.max - nxt_max) * T(x.n_max) + f.add * T(x.sz)\n \
    \               x.min = nxt_min + f.add\n                x.max = nxt_max + f.add\n\
    \                x.min2 += f.add\n                x.max2 += f.add\n          \
    \      return x\n            x.fail = true\n            return x\n        proc\
    \ id(): F_rch[T] = F_rch[T](lb: -inf, ub: inf, add: zero)\n        var vn = v.mapIt(init_S(it,\
    \ inf))\n        var seg = initSegmentTreeBeats(vn, op, e(), mapping, composition,\
    \ id())\n        return RangeChminChmaxRangeSumMaxMin[T](seg: seg, inf: inf, zero:\
    \ zero)\n    proc initRangeChminChmaxRangeSumMaxMin*(v: seq[int]): RangeChminChmaxRangeSumMaxMin[int]\
    \ = initRangeChminChmaxRangeSumMaxMin(v, INF64, 0)\n    proc initRangeChminChmaxRangeSumMaxMin*(v:\
    \ seq[int32]): RangeChminChmaxRangeSumMaxMin[int32] = initRangeChminChmaxRangeSumMaxMin(v,\
    \ INF32, 0.int32)\n    proc initRangeChminChmaxRangeSumMaxMin*(v: seq[float]):\
    \ RangeChminChmaxRangeSumMaxMin[float] = initRangeChminChmaxRangeSumMaxMin(v,\
    \ 1e100, 0.0)\n\n    proc update*[T](self: var RangeChminChmaxRangeSumMaxMin[T],\
    \ p: Natural, val: T) = self.seg.update(p, init_S(val, self.inf))\n    proc `[]`*[T](self:\
    \ var RangeChminChmaxRangeSumMaxMin[T], p: Natural or HSlice[int, int]): S_rch[T]\
    \ = self.seg[p]\n    proc `[]=`*[T](self: var RangeChminChmaxRangeSumMaxMin[T],\
    \ p: Natural, val: T): S_rch[T] = self.update(p, val)\n    proc len*[T](self:\
    \ var RangeChminChmaxRangeSumMaxMin[T]): int = self.seg.len\n    proc `$`*[T](self:\
    \ var RangeChminChmaxRangeSumMaxMin[T]): string = $(self.seg)\n    proc chmin*[T](self:\
    \ var RangeChminChmaxRangeSumMaxMin[T], segment: HSlice[int, int], val: T) = self.seg.apply(segment,\
    \ F_rch[T](lb: -self.inf, ub: val, add: self.zero))\n    proc chmax*[T](self:\
    \ var RangeChminChmaxRangeSumMaxMin[T], segment: HSlice[int, int], val: T) = self.seg.apply(segment,\
    \ F_rch[T](lb: val, ub: self.inf, add: self.zero))\n    proc add*[T](self: var\
    \ RangeChminChmaxRangeSumMaxMin[T], segment: HSlice[int, int], val: T) = self.seg.apply(segment,\
    \ F_rch[T](lb: -self.inf, ub: self.inf, add: val))\n\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/collections/segtree_beats.nim
  - cplib/collections/segtree_beats.nim
  - cplib/utils/constants.nim
  isVerificationFile: false
  path: cplib/collections/segtree_beats_template.nim
  requiredBy: []
  timestamp: '2024-09-23 17:09:04+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/range_chmin_chmax_add_range_sum_test.nim
  - verify/collections/range_chmin_chmax_add_range_sum_test.nim
documentation_of: cplib/collections/segtree_beats_template.nim
layout: document
redirect_from:
- /library/cplib/collections/segtree_beats_template.nim
- /library/cplib/collections/segtree_beats_template.nim.html
title: cplib/collections/segtree_beats_template.nim
---
