when not declared CPLIB_MATH_GENERALIZED_FLOOR_SUM:
    const CPLIB_MATH_GENERALIZED_FLOOR_SUM* = 1

    type GeneralizedFloorSum* = tuple
        ## Sums for y_i = floor((a * i + b) / m), 0 <= i < n.
        floorSum: int             ## sum y_i
        weightedFloorSum: int     ## sum i * y_i
        squaredFloorSum: int      ## sum y_i^2

    proc floorDiv(a, b: int): int {.inline.} =
        ## Mathematical floor division (Nim's `div` truncates towards zero).
        result = a div b
        if a mod b < 0: dec result

    proc generalizedFloorSum*(n, m, a, b: int): GeneralizedFloorSum =
        ## Computes, in O(log m),
        ##
        ## * `sum floor((a*i+b)/m)`
        ## * `sum i*floor((a*i+b)/m)`
        ## * `sum floor((a*i+b)/m)^2`
        ##
        ## over `0 <= i < n`. `n >= 0` and `m > 0` are required. Both `a`
        ## and `b` may be negative. As with the usual floor-sum routine, the
        ## caller is responsible for avoiding overflow of `int`.
        assert n >= 0
        assert m > 0
        if n == 0:
            return (0, 0, 0)

        let qa = floorDiv(a, m)
        let qb = floorDiv(b, m)
        let ra = a - qa * m
        let rb = b - qb * m
        let s1 = n * (n - 1) div 2
        let s2 = n * (n - 1) * (2 * n - 1) div 6

        var reduced: GeneralizedFloorSum
        if ra == 0:
            reduced = (0, 0, 0)
        else:
            let k = (ra * (n - 1) + rb) div m
            if k == 0:
                reduced = (0, 0, 0)
            else:
                let dual = generalizedFloorSum(k, ra, m, m - rb + ra - 1)
                reduced.floorSum = n * k - dual.floorSum
                reduced.weightedFloorSum =
                    s1 * k + (dual.floorSum - dual.squaredFloorSum) div 2
                reduced.squaredFloorSum =
                    n * k * k - dual.floorSum - 2 * dual.weightedFloorSum

        # floor((a*i+b)/m) = qa*i + qb + floor((ra*i+rb)/m).
        result.floorSum = qa * s1 + qb * n + reduced.floorSum
        result.weightedFloorSum =
            qa * s2 + qb * s1 + reduced.weightedFloorSum
        result.squaredFloorSum =
            qa * qa * s2 + 2 * qa * qb * s1 + qb * qb * n +
            2 * qa * reduced.weightedFloorSum +
            2 * qb * reduced.floorSum + reduced.squaredFloorSum

    proc floorSum*(n, m, a, b: int): int {.inline.} =
        ## Convenience wrapper for the ordinary floor sum.
        generalizedFloorSum(n, m, a, b).floorSum
