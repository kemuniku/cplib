when not declared CPLIB_FPS_PRODUCT_TREE:
    const CPLIB_FPS_PRODUCT_TREE* = 1

    import algorithm
    import cplib/convolution/convolution
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

        const directEvaluationSize = 64
        var directLevel = tree.leafCount
        var pointsPerNode = 1
        while pointsPerNode < directEvaluationSize and directLevel > 1:
            directLevel = directLevel div 2
            pointsPerNode *= 2

        var remainders = newSeq[seq[T]](tree.nodes.len)
        if f.len < tree.nodes[1].len:
            remainders[1] = f
        else:
            remainders[1] = f mod tree.nodes[1]
        for i in 1..<directLevel:
            remainders[i * 2] = remainders[i] mod tree.nodes[i * 2]
            remainders[i * 2 + 1] = remainders[i] mod tree.nodes[i * 2 + 1]
        for node in directLevel..<(directLevel * 2):
            let firstPoint = (node - directLevel) * pointsPerNode
            let lastPoint = min(firstPoint + pointsPerNode, tree.pointCount)
            let remainder = remainders[node]
            for i in firstPoint..<lastPoint:
                let x = -tree.nodes[tree.leafCount + i][0]
                result[i] = remainder.eval(x)

    proc multipointEvaluation*[T: BarrettModint or MontgomeryModint](
            f, xs: seq[T]): seq[T] =
        ## 反転積木と中間積を用いてfをすべての点で評価する。
        if xs.len == 0: return @[]

        const multipointDirectEvaluationSize = 16
        var leafCount = 1
        while leafCount < xs.len: leafCount *= 2
        let blockSize = min(multipointDirectEvaluationSize, leafCount)
        let blockCount = leafCount div blockSize

        var reversedProducts = newSeq[seq[T]](blockCount * 2)
        for blockIndex in 0..<blockCount:
            var product = @[init(T, 1)]
            for offset in 0..<blockSize:
                let pointIndex = blockIndex * blockSize + offset
                let x = if pointIndex < xs.len: xs[pointIndex] else: init(T, 0)
                product.add(init(T, 0))
                for i in countdown(product.high, 1):
                    product[i] -= x * product[i - 1]
            reversedProducts[blockCount + blockIndex] = product
        for node in countdown(blockCount - 1, 1):
            reversedProducts[node] = reversedProducts[node * 2] *
                reversedProducts[node * 2 + 1]

        var polynomial = f
        if polynomial.len > leafCount:
            var root = reversedProducts[1]
            root.reverse
            polynomial = polynomial mod root

        var reversedPolynomial = newSeq[T](leafCount)
        for i in 0..<polynomial.len:
            reversedPolynomial[leafCount - 1 - i] = polynomial[i]
        var transformed = newSeq[seq[T]](blockCount * 2)
        transformed[1] = prefix(
            reversedPolynomial * reversedProducts[1].inv(leafCount), leafCount)

        for node in 1..<blockCount:
            let childSize = transformed[node].len div 2
            let leftProduct = convolutionCyclicPowerOfTwo(
                transformed[node], reversedProducts[node * 2 + 1],
                transformed[node].len)
            let rightProduct = convolutionCyclicPowerOfTwo(
                transformed[node], reversedProducts[node * 2],
                transformed[node].len)
            transformed[node * 2] = leftProduct[childSize..<childSize * 2]
            transformed[node * 2 + 1] = rightProduct[childSize..<childSize * 2]

        result = newSeq[T](xs.len)
        for blockIndex in 0..<blockCount:
            let transformedBlock = transformed[blockCount + blockIndex]
            let reversedBlock = reversedProducts[blockCount + blockIndex]
            var reversedRemainder = newSeq[T](blockSize)
            for i in 0..<blockSize:
                for j in 0..i:
                    reversedRemainder[i] += transformedBlock[j] * reversedBlock[i - j]
            var remainder = reversedRemainder
            remainder.reverse
            let firstPoint = blockIndex * blockSize
            let lastPoint = min(firstPoint + blockSize, xs.len)
            for i in firstPoint..<lastPoint:
                result[i] = remainder.eval(xs[i])
