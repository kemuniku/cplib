when not declared CPLIB_FPS_PRODUCT_TREE:
    const CPLIB_FPS_PRODUCT_TREE* = 1

    import cplib/fps/formal_power_series
    import cplib/modint/modint

    type PolynomialProductTree*[T] = object
        pointCount*: int
        leafCount*: int
        nodes*: seq[seq[T]]

    proc initPolynomialProductTree*[T: BarrettModint or MontgomeryModint](
            xs: seq[T]): PolynomialProductTree[T] =
        result.pointCount = xs.len
        result.leafCount = 1
        while result.leafCount < xs.len: result.leafCount *= 2
        result.nodes = newSeq[seq[T]](result.leafCount * 2)
        for i in 0..<result.leafCount:
            if i < xs.len: result.nodes[result.leafCount + i] = @[-xs[i], init(T, 1)]
            else: result.nodes[result.leafCount + i] = @[init(T, 1)]
        for i in countdown(result.leafCount - 1, 1):
            result.nodes[i] = result.nodes[i * 2] * result.nodes[i * 2 + 1]

    proc evaluate*[T: BarrettModint or MontgomeryModint](
            tree: PolynomialProductTree[T], f: seq[T]): seq[T] =
        ## 木の構築に使ったすべての点でfを評価する。
        result = newSeq[T](tree.pointCount)
        if tree.pointCount == 0: return
        var remainders = newSeq[seq[T]](tree.nodes.len)
        remainders[1] = f mod tree.nodes[1]
        for i in 1..<tree.leafCount:
            remainders[i * 2] = remainders[i] mod tree.nodes[i * 2]
            remainders[i * 2 + 1] = remainders[i] mod tree.nodes[i * 2 + 1]
        for i in 0..<tree.pointCount:
            let rem = remainders[tree.leafCount + i]
            if rem.len > 0: result[i] = rem[0]

    proc multipointEvaluation*[T: BarrettModint or MontgomeryModint](
            f, xs: seq[T]): seq[T] =
        let tree: PolynomialProductTree[T] = initPolynomialProductTree[T](xs)
        evaluate[T](tree, f)
