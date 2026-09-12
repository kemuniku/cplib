## よく使う区間更新・区間取得をstatic_op版の遅延セグ木で提供します。
## 操作にはcplib/collections/lazysegtree_static_opもimportしてください。
## 配列から初期化し、apply(l, r, f)で半開区間[l, r)を更新します。
## get(l, r)またはseg[l..<r]で取得でき、スライスでのapplyも使用できます。
## get_all()で全体の演算結果をO(1)で取得できます。
## Index版の極値は.valueと.index（同値なら最左、0始まり）、和は.sumで取得します。
## Index版の空区間の極値はindex = -1（valueは未定義扱い）、和はsum = 0, len = 0です。
## Index版の極値の.leftは区間左端で、区間変更時の位置復元に使用します。
## 一点代入はIndex版の極値ならseg[p] = (value, p, p)、和ならseg[p] = (value, 1)です。
## 極値の初期化関数は末尾Index付きが位置を保持し、末尾なしはTの値を直接返します。
## 位置なし版はT.high/T.lowを持つ数値型向けで、空区間は最小値ならT.high、最大値ならT.lowです。
## 位置なし版の一点代入はseg[p] = valueです。
## 一次関数作用の更新値は(a, b)で、各要素xをa*x+bに変更します。
## Tのデフォルト値を0として扱います。和の型はTで、オーバーフローに注意してください。
## 使用例:
##   var seg = initRangeAssignRangeMinIndex(@[3, 1, 4])
##   seg.apply(0, 3, 2)
##   assert seg.get(1, 3).index == 1
##   var sums = initRangeAffineRangeSum(@[1, 2, 3])
##   sums.apply(0, 3, (2, 1))
##   assert sums.get(0, 3).sum == 15
when not declared CPLIB_COLLECTIONS_LAZYSEGTREE_TEMPLATE:
    const CPLIB_COLLECTIONS_LAZYSEGTREE_TEMPLATE* = 1
    include cplib/collections/lazysegtree_static_op

    type
        RangeExtremum*[T] = tuple[value: T, index: int, left: int]
        RangeSum*[T] = tuple[sum: T, len: int]
        RangeAffine*[T] = tuple[a, b: T]

    proc initRangeExtremumTreeIndex[T; isMin, isAssign: static[bool]](v: openArray[T]): auto =
        ## 極値と最左位置を保持する遅延セグ木をO(N)で構築します。
        proc merge(l, r: RangeExtremum[T]): RangeExtremum[T] =
            ## 空区間を除外して極値と最左位置をマージします。O(1)。
            if l.index < 0: return r
            if r.index < 0: return l
            when isMin:
                result = if r.value < l.value: r else: l
            else:
                result = if l.value < r.value: r else: l
            result.left = l.left
        proc mapping(f: T, x: RangeExtremum[T]): RangeExtremum[T] =
            ## 区間加算または区間変更を作用させます。O(1)。
            result = x
            if x.index < 0: return
            when isAssign:
                result.value = f
                result.index = x.left
            else:
                result.value = x.value + f
        proc composition(f, g: T): T =
            ## gの後にfを作用させる更新を合成します。O(1)。
            when isAssign: f
            else: f + g
        var nodes = newSeq[RangeExtremum[T]](v.len)
        for i, value in v:
            nodes[i] = (value, i, i)
        initLazySegmentTree[RangeExtremum[T], T](
            nodes, merge, (default(T), -1, -1), mapping, composition, default(T))

    proc initRangeAddRangeMinIndex*[T](v: openArray[T]): auto =
        ## 区間加算・区間最小値と最左位置の取得用。構築O(N)、操作O(log N)。
        initRangeExtremumTreeIndex[T, true, false](v)

    proc initRangeAddRangeMaxIndex*[T](v: openArray[T]): auto =
        ## 区間加算・区間最大値と最左位置の取得用。構築O(N)、操作O(log N)。
        initRangeExtremumTreeIndex[T, false, false](v)

    proc initRangeAssignRangeMinIndex*[T](v: openArray[T]): auto =
        ## 区間変更・区間最小値と最左位置の取得用。構築O(N)、操作O(log N)。
        initRangeExtremumTreeIndex[T, true, true](v)

    proc initRangeAssignRangeMaxIndex*[T](v: openArray[T]): auto =
        ## 区間変更・区間最大値と最左位置の取得用。構築O(N)、操作O(log N)。
        initRangeExtremumTreeIndex[T, false, true](v)

    proc initRangeExtremumTree[T; isMin, isAssign: static[bool]](v: openArray[T]): auto =
        ## 位置を持たず極値のみを保持する遅延セグ木をO(N)で構築します。
        proc merge(l, r: T): T =
            ## 二つの区間の極値をマージします。O(1)。
            when isMin: min(l, r)
            else: max(l, r)
        proc mapping(f, x: T): T =
            ## 区間加算または区間変更を作用させます。O(1)。
            when isAssign: f
            else: x + f
        proc composition(f, g: T): T =
            ## gの後にfを作用させる更新を合成します。O(1)。
            when isAssign: f
            else: f + g
        var nodes = newSeq[T](v.len)
        for i, value in v:
            nodes[i] = value
        when isMin:
            let identity = T.high
        else:
            let identity = T.low
        initLazySegmentTree[T, T](
            nodes, merge, identity, mapping, composition, default(T))

    proc initRangeAddRangeMin*[T](v: openArray[T]): auto =
        ## 区間加算・区間最小値取得用（位置なし）。構築O(N)、操作O(log N)。
        initRangeExtremumTree[T, true, false](v)

    proc initRangeAddRangeMax*[T](v: openArray[T]): auto =
        ## 区間加算・区間最大値取得用（位置なし）。構築O(N)、操作O(log N)。
        initRangeExtremumTree[T, false, false](v)

    proc initRangeAssignRangeMin*[T](v: openArray[T]): auto =
        ## 区間変更・区間最小値取得用（位置なし）。構築O(N)、操作O(log N)。
        initRangeExtremumTree[T, true, true](v)

    proc initRangeAssignRangeMax*[T](v: openArray[T]): auto =
        ## 区間変更・区間最大値取得用（位置なし）。構築O(N)、操作O(log N)。
        initRangeExtremumTree[T, false, true](v)

    proc initRangeSumTree[T; mode: static[int]](v: openArray[T]): auto =
        ## 和と区間長を保持する遅延セグ木をO(N)で構築します。
        when mode == 2:
            type F = RangeAffine[T]
        else:
            type F = T
        proc merge(l, r: RangeSum[T]): RangeSum[T] =
            ## 和と区間長をマージします。O(1)。
            (l.sum + r.sum, l.len + r.len)
        proc mapping(f: F, x: RangeSum[T]): RangeSum[T] =
            ## 区間の各要素への更新を和に反映します。O(1)。
            template scale(value: T): T =
                ## 区間長を掛け、組み込み数値型とmodintの双方に対応します。O(1)。
                when T is SomeNumber: value * T(x.len)
                else: value * x.len
            if x.len == 0: return x
            when mode == 0: (x.sum + scale(f), x.len)
            elif mode == 1: (scale(f), x.len)
            else: (f.a * x.sum + scale(f.b), x.len)
        proc composition(f, g: F): F =
            ## gの後にfを作用させる更新を合成します。O(1)。
            when mode == 0: f + g
            elif mode == 1: f
            else: (f.a * g.a, f.a * g.b + f.b)
        var nodes = newSeq[RangeSum[T]](v.len)
        for i, value in v:
            nodes[i] = (value, 1)
        initLazySegmentTree[RangeSum[T], F](
            nodes, merge, (default(T), 0), mapping, composition, default(F))

    proc initRangeAddRangeSum*[T](v: openArray[T]): auto =
        ## 区間加算・区間和取得用。構築O(N)、操作O(log N)。
        initRangeSumTree[T, 0](v)

    proc initRangeAssignRangeSum*[T](v: openArray[T]): auto =
        ## 区間変更・区間和取得用。構築O(N)、操作O(log N)。
        initRangeSumTree[T, 1](v)

    proc initRangeAffineRangeSum*[T](v: openArray[T]): auto =
        ## 区間一次関数作用x→a*x+b・区間和取得用。構築O(N)、操作O(log N)。
        initRangeSumTree[T, 2](v)
