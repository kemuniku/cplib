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
## 等差数列版はapply(l, r, arithmeticTag(l, a, d))で、添字iにa+d*(i-l)を加算/代入します。
## 等差数列版の和は.sum、長さは.len、絶対添字の和は.indexSumです。
## 等差数列版の極値は.valueと.index（同値なら最左）、.left/.rightは半開区間の端です。
## 等差数列版の一点代入は和ならseg[p] = (value, 1, p)、極値なら(value, p, p, p+1)です。
## 等差数列タグは(slope, intercept)で、絶対添字iでの値をslope*i+interceptとします。
## 等差数列代入の極値は大小比較のできる型向けです。和はmodintにも対応します。
## 空区間の和はsum = 0, len = 0, indexSum = 0、極値はindex = -1（valueは未定義扱い）です。
## 機械整数では添字の和・d*l・タグ合成・mappingの中間値も型の範囲内に収めてください。
## 負の初項/公差には符号付きの型を使い、dynamic modintの法は構築後に変更しないでください。
## Tのデフォルト値を0として扱います。和の型はTで、オーバーフローに注意してください。
## 使用例:
##   var seg = initRangeAssignRangeMinIndex(@[3, 1, 4])
##   seg.apply(0, 3, 2)
##   assert seg.get(1, 3).index == 1, "最小値の位置が期待値と一致しません"
##   var sums = initRangeAffineRangeSum(@[1, 2, 3])
##   sums.apply(0, 3, (2, 1))
##   assert sums.get(0, 3).sum == 15, "区間和が期待値と一致しません"
##   var arithmetic = initRangeArithmeticAddRangeSum(@[1, 2, 3, 4])
##   arithmetic.apply(1..<4, arithmeticTag(1, 10, 2))
##   assert arithmetic.get(0, 4).sum == 46, "区間和が期待値と一致しません"
##   var assigned = initRangeArithmeticAssignRangeMin(@[1, 2, 3, 4])
##   assigned.apply(1..<4, arithmeticTag(1, 10, -2))
##   assert assigned.get(1, 4).value == 6, "区間最小値が期待値と一致しません"
when not declared CPLIB_COLLECTIONS_LAZYSEGTREE_TEMPLATE:
    const CPLIB_COLLECTIONS_LAZYSEGTREE_TEMPLATE* = 1
    include cplib/collections/lazysegtree_static_op

    type
        RangeExtremum*[T] = tuple[value: T, index: int, left: int]
        RangeSum*[T] = tuple[sum: T, len: int]
        RangeAffine*[T] = tuple[a, b: T]
        RangeArithmeticSum*[T] = tuple[sum: T, len, indexSum: int]
        RangeArithmetic*[T] = tuple[slope, intercept: T]
        RangeArithmeticExtremum*[T] = tuple[value: T, index, left, right: int]

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

    proc scaleArithmetic[T](value: T, count: int): T =
        ## 整数倍を求め、組み込み数値型とmodintの双方に対応します。O(1)。
        when T is SomeNumber: value * T(count)
        else: value * count

    proc arithmeticTag*[T](left: int, first, difference: T): RangeArithmetic[T] =
        ## 左端leftで初項first、公差differenceの等差数列を絶対添字のタグに変換します。O(1)。
        (difference, first - scaleArithmetic(difference, left))

    proc initRangeArithmeticSumTree[T; isAssign: static[bool]](v: openArray[T]): auto =
        ## 等差数列加算/代入と和・添字の和を保持する遅延セグ木をO(N)で構築します。
        proc merge(l, r: RangeArithmeticSum[T]): RangeArithmeticSum[T] =
            ## 和・区間長・絶対添字の和をマージします。O(1)。
            (l.sum + r.sum, l.len + r.len, l.indexSum + r.indexSum)
        proc mapping(f: RangeArithmetic[T], x: RangeArithmeticSum[T]): RangeArithmeticSum[T] =
            ## 各添字iへのslope*i+interceptの加算/代入を区間和に反映します。O(1)。
            if x.len == 0: return x
            let sum = scaleArithmetic(f.slope, x.indexSum) + scaleArithmetic(f.intercept, x.len)
            when isAssign: (sum, x.len, x.indexSum)
            else: (x.sum + sum, x.len, x.indexSum)
        proc composition(f, g: RangeArithmetic[T]): RangeArithmetic[T] =
            ## gの後にfを作用させるタグを合成します。O(1)。
            when isAssign: f
            else: (f.slope + g.slope, f.intercept + g.intercept)
        var nodes = newSeq[RangeArithmeticSum[T]](v.len)
        for i, value in v:
            nodes[i] = (value, 1, i)
        initLazySegmentTree[RangeArithmeticSum[T], RangeArithmetic[T]](
            nodes, merge, (default(T), 0, 0), mapping, composition, default(RangeArithmetic[T]))

    proc initRangeArithmeticAddRangeSum*[T](v: openArray[T]): auto =
        ## 区間等差数列加算・区間和取得用。構築O(N)、操作O(log N)、空間O(N)。
        initRangeArithmeticSumTree[T, false](v)

    proc initRangeArithmeticAssignRangeSum*[T](v: openArray[T]): auto =
        ## 区間等差数列代入・区間和取得用。構築O(N)、操作O(log N)、空間O(N)。
        initRangeArithmeticSumTree[T, true](v)

    proc initRangeArithmeticExtremumTree[T; isMin: static[bool]](v: openArray[T]): auto =
        ## 等差数列代入と極値・最左位置を保持する遅延セグ木をO(N)で構築します。
        proc merge(l, r: RangeArithmeticExtremum[T]): RangeArithmeticExtremum[T] =
            ## 空区間を除外して極値・最左位置・区間の両端をマージします。O(1)。
            if l.index < 0: return r
            if r.index < 0: return l
            when isMin:
                result = if r.value < l.value: r else: l
            else:
                result = if l.value < r.value: r else: l
            result.left = l.left
            result.right = r.right
        proc mapping(f: RangeArithmetic[T], x: RangeArithmeticExtremum[T]): RangeArithmeticExtremum[T] =
            ## 等差数列の両端を比較して代入後の極値と最左位置を求めます。O(1)。
            if x.index < 0: return x
            let first = scaleArithmetic(f.slope, x.left) + f.intercept
            let last = scaleArithmetic(f.slope, x.right - 1) + f.intercept
            result = (first, x.left, x.left, x.right)
            when isMin:
                if last < first: result = (last, x.right - 1, x.left, x.right)
            else:
                if first < last: result = (last, x.right - 1, x.left, x.right)
        proc composition(f, g: RangeArithmetic[T]): RangeArithmetic[T] =
            ## 後から作用させるfで先行する代入gを置き換えます。O(1)。
            f
        var nodes = newSeq[RangeArithmeticExtremum[T]](v.len)
        for i, value in v:
            nodes[i] = (value, i, i, i + 1)
        initLazySegmentTree[RangeArithmeticExtremum[T], RangeArithmetic[T]](
            nodes, merge, (default(T), -1, -1, -1), mapping, composition, default(RangeArithmetic[T]))

    proc initRangeArithmeticAssignRangeMin*[T](v: openArray[T]): auto =
        ## 区間等差数列代入・区間最小値と最左位置の取得用。構築O(N)、操作O(log N)。
        initRangeArithmeticExtremumTree[T, true](v)

    proc initRangeArithmeticAssignRangeMax*[T](v: openArray[T]): auto =
        ## 区間等差数列代入・区間最大値と最左位置の取得用。構築O(N)、操作O(log N)。
        initRangeArithmeticExtremumTree[T, false](v)
