when not declared CPLIB_MATH_MANY_FACTORIALS:
    const CPLIB_MATH_MANY_FACTORIALS* = 1

    import algorithm
    import cplib/fps/formal_power_series
    import cplib/fps/product_tree
    import cplib/fps/shift_of_sampling_points
    import cplib/fps/taylor_shift
    import cplib/modint/modint

    type LargeFactorial*[T] = object
        modulus: uint32
        maxN, blockSize: int
        blocks: seq[T]

    proc factorialBlocks[T: BarrettModint or MontgomeryModint](
            blockSize, blockCount: int): seq[T] =
        ## B が 2 の冪のとき、(iB)! の表を O(M(B+blockCount)) で作る。
        var samples = @[init(T, 1)]
        var width = 1
        while width < blockSize:
            # samples[j] は (j*width+1) から (j*width+width-1) までの積。
            let extended = samples & shiftOfSamplingPoints(
                samples, init(T, width), 3 * width)
            var next = newSeq[T](2 * width)
            for i in 0..<next.len:
                next[i] = extended[2 * i] * extended[2 * i + 1] *
                    init(T, (2 * i + 1) * width)
            samples = move(next)
            width *= 2
        if blockCount > blockSize:
            let extended = shiftOfSamplingPoints(
                samples, init(T, blockSize), blockCount - blockSize)
            samples.add(extended)
        result = newSeq[T](blockCount + 1)
        result[0] = init(T, 1)
        for i in 0..<blockCount:
            result[i + 1] = result[i] * samples[i] * init(T, (i + 1) * blockSize)

    proc initLargeFactorial*[T: BarrettModint or MontgomeryModint](
            maxN: int = -1, blockSize: int = 1024): LargeFactorial[T] =
        ## 素数法 p で上限 N までの階乗表を O(M(B+N/B)) で前計算し、O(1+N/B) 要素を保存する。
        ## maxN=-1 は p-1、それ以外は min(maxN,p-1) まで対応する。
        ## B=blockSize は正の 2 の冪で、上限が小さい場合は縮小する。
        doAssert maxN >= -1, "階乗の上限は -1 または非負である必要がある"
        doAssert blockSize > 0 and (blockSize and (blockSize - 1)) == 0,
            "ブロック間隔は正の 2 の冪である必要がある"
        let modulus = T.umod.int
        doAssert modulus >= 2, "法は 2 以上の素数である必要がある"
        result.modulus = T.umod
        result.maxN = if maxN == -1: modulus - 1 else: min(maxN, modulus - 1)
        result.blockSize = blockSize
        while result.blockSize > max(1, result.maxN): result.blockSize = result.blockSize div 2
        result.blocks = factorialBlocks[T](result.blockSize, result.maxN div result.blockSize)

    proc fact*[T](table: LargeFactorial[T], n: int): T =
        ## n! を前計算した表から O(B) で求める。n >= p には 0 を返し、負数・上限超過・構築時と異なる法は不可。
        doAssert table.blocks.len > 0, "階乗表は初期化する必要がある"
        doAssert table.modulus == T.umod, "階乗表は構築時と同じ法で使用する必要がある"
        doAssert n >= 0, "階乗の引数は非負である必要がある"
        if n >= table.modulus.int: return init(T, 0)
        doAssert n <= table.maxN, "階乗の引数が前計算した上限を超えている"
        let blockIndex = n div table.blockSize
        result = table.blocks[blockIndex]
        for i in blockIndex * table.blockSize + 1..n: result *= i

    proc manyFactorials*[T: BarrettModint or MontgomeryModint](
            ns: openArray[int]): seq[T] =
        ## 素数 p を法とする ns[i]! を入力順に返す。負数は不可、ns[i] >= p には 0 を返す。
        ## NTT 使用時 O(sqrt(p) log p + Q log Q + Q log^3 p)、Q = ns.len。
        result = newSeq[T](ns.len)
        let modulus = T.umod.int
        var maxN = -1
        for n in ns:
            doAssert n >= 0, "階乗の引数は非負である必要がある"
            if n < modulus: maxN = max(maxN, n)
        if maxN < 0: return

        const directFactorialLimit = 1024
        if maxN <= directFactorialLimit:
            var fact = newSeq[T](maxN + 1)
            fact[0] = init(T, 1)
            for i in 1..maxN: fact[i] = fact[i - 1] * i
            for i, n in ns:
                if n < modulus: result[i] = fact[n]
            return

        var blockSize = 1
        while blockSize * blockSize <= maxN: blockSize *= 2
        let blocks = factorialBlocks[T](blockSize, maxN div blockSize)
        type Query = tuple[n, index: int]
        var queries = newSeqOfCap[Query](ns.len)
        for i, n in ns:
            if n < modulus:
                result[i] = blocks[n div blockSize]
                queries.add((n, i))
        queries.sort(proc(a, b: Query): int = cmp(a.n, b.n))

        var polynomial = @[init(T, 1), init(T, 1)]
        var width = 1
        while width < blockSize:
            # polynomial は (x+1)...(x+width)、各区間の始点は 2*width の倍数。
            const directProductLimit = 32
            if width <= directProductLimit:
                for query in queries:
                    if (query.n and width) == 0: continue
                    let start = query.n - query.n mod (2 * width)
                    var product = init(T, 1)
                    for i in 1..width: product *= start + i
                    result[query.index] *= product
            else:
                var points: seq[T]
                var previous = -1
                for query in queries:
                    if (query.n and width) == 0: continue
                    let start = query.n - query.n mod (2 * width)
                    if start != previous:
                        points.add(init(T, start))
                        previous = start
                var values = newSeq[T](points.len)
                var first = 0
                while first < points.len:
                    let last = min(first + width, points.len)
                    let evaluated = multipointEvaluation(polynomial, points[first..<last])
                    for i in 0..<evaluated.len: values[first + i] = evaluated[i]
                    first = last
                var pointIndex = -1
                previous = -1
                for query in queries:
                    if (query.n and width) == 0: continue
                    let start = query.n - query.n mod (2 * width)
                    if start != previous:
                        inc pointIndex
                        previous = start
                    result[query.index] *= values[pointIndex]
            if 2 * width < blockSize:
                polynomial = polynomial * taylorShift(polynomial, init(T, width))
            width *= 2
