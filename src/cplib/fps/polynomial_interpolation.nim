when not declared CPLIB_FPS_POLYNOMIAL_INTERPOLATION:
    const CPLIB_FPS_POLYNOMIAL_INTERPOLATION* = 1

    import cplib/fps/formal_power_series
    import cplib/fps/product_tree
    import cplib/modint/modint

    proc polynomialInterpolation*[T: BarrettModint or MontgomeryModint](
            xs, ys: seq[T]): seq[T] =
        ## すべての点 (xs[i], ys[i]) を通る、次数がxs.len未満の一意な多項式を返す。
        doAssert xs.len == ys.len, "補間ではx座標とy座標の個数が一致する必要がある"
        if xs.len == 0: return @[]
        let tree: PolynomialProductTree[T] = initPolynomialProductTree[T](xs)
        let denominators = evaluate[T](tree, tree.nodes[1].derivative)
        var partial = newSeq[seq[T]](tree.nodes.len)
        for i in 0..<tree.leafCount:
            if i < xs.len:
                doAssert denominators[i].val != 0, "補間に使う点のx座標は互いに異なる必要がある"
                partial[tree.leafCount + i] = @[ys[i] / denominators[i]]
            else:
                partial[tree.leafCount + i] = @[]
        for i in countdown(tree.leafCount - 1, 1):
            partial[i] = partial[i * 2] * tree.nodes[i * 2 + 1] +
                partial[i * 2 + 1] * tree.nodes[i * 2]
        partial[1].prefix(xs.len).normalized
