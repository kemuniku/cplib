when not declared CPLIB_MATH_TWELVEFOLD_WAY:
    const CPLIB_MATH_TWELVEFOLD_WAY* = 1
    import cplib/math/combination
    import cplib/math/isprime

    type
        BallKind* = enum
            distinctBalls, identicalBalls
        BoxKind* = enum
            distinctBoxes, identicalBoxes
        MappingConstraint* = enum
            unrestricted, injective, surjective
        TwelvefoldCounts*[ModInt] = array[BallKind,
            array[BoxKind, array[MappingConstraint, ModInt]]]
        TwelvefoldWay*[ModInt] = object
            maxN, maxM: int
            modulus: uint64
            factorials, inverseFactorials: seq[ModInt]
            stirlingSums, partitions, powers: seq[seq[ModInt]]

    proc initTwelvefoldWay*[ModInt](maxN, maxM: int): TwelvefoldWay[ModInt] =
        ## 球数・箱数の上限まで前計算する。時間・領域 O((maxN+1)(maxM+1))。
        ## ModInt は32bit素数法の型で、maxN+maxM < 法が必要。巨大入力/FPS版は対象外。
        ## 不正な上限・法は ValueError。dynamic 型の法は使用中に変更しないこと。
        if maxN < 0 or maxM < 0 or maxN > high(int) - maxM:
            raise newException(ValueError, "球数・箱数の上限が不正です")
        let modulus = uint64(ModInt.umod())
        if modulus > uint64(high(uint32)) or not isprime(modulus):
            raise newException(ValueError, "32bit素数法が必要です")
        if uint64(maxN + maxM) >= modulus:
            raise newException(ValueError, "球数と箱数の上限の和は法未満が必要です")
        result.maxN = maxN
        result.maxM = maxM
        result.modulus = modulus
        let combinations = initCombination[ModInt](maxN + maxM)
        result.factorials = combinations.fact
        result.inverseFactorials = combinations.fact_inv
        result.stirlingSums = newSeq[seq[ModInt]](maxN + 1)
        result.partitions = newSeq[seq[ModInt]](maxN + 1)
        result.powers = newSeq[seq[ModInt]](maxN + 1)
        var stirling = newSeq[ModInt](maxM + 1)
        stirling[0] = 1
        for n in 0..maxN:
            result.stirlingSums[n] = newSeq[ModInt](maxM + 1)
            result.partitions[n] = newSeq[ModInt](maxM + 1)
            result.powers[n] = newSeq[ModInt](maxM + 1)
            if n > 0:
                for m in countdown(maxM, 1):
                    stirling[m] = stirling[m] * m + stirling[m - 1]
                stirling[0] = 0
            var total: ModInt = 0
            for m in 0..maxM:
                total += stirling[m]
                result.stirlingSums[n][m] = total
                if n == 0:
                    result.partitions[n][m] = 1
                    result.powers[n][m] = 1
                else:
                    result.powers[n][m] = result.powers[n - 1][m] * m
                    if m > 0:
                        result.partitions[n][m] = result.partitions[n][m - 1]
                        if n >= m:
                            result.partitions[n][m] += result.partitions[n - m][m]

    proc checkRange[ModInt](c: TwelvefoldWay[ModInt], n, m: int) =
        ## 前計算範囲と構築時の法を検査する。O(1)。
        if c.modulus == 0 or c.modulus != uint64(ModInt.umod()):
            raise newException(ValueError, "未初期化、または構築時から法が変化しています")
        if n < 0 or m < 0 or n > c.maxN or m > c.maxM:
            raise newException(ValueError, "球数・箱数が前計算範囲外です")

    proc stirlingSecond*[ModInt](c: TwelvefoldWay[ModInt], n, m: int): ModInt =
        ## 第二種Stirling数 S(n,m)（n要素をm個の非空集合に分割）を返す。O(1)。
        c.checkRange(n, m)
        result = c.stirlingSums[n][m]
        if m > 0:
            result -= c.stirlingSums[n][m - 1]

    proc partitionCount*[ModInt](c: TwelvefoldWay[ModInt], n, m: int): ModInt =
        ## nをちょうどm個の正整数に分割する数を返す。p(0,0)=1。O(1)。
        c.checkRange(n, m)
        if n < m:
            return 0
        return c.partitions[n - m][m]

    proc binomial[ModInt](c: TwelvefoldWay[ModInt], n, r: int): ModInt =
        ## 内部用の二項係数を返す。O(1)。
        if r < 0 or r > n:
            return 0
        return c.factorials[n] * c.inverseFactorials[r] * c.inverseFactorials[n - r]

    proc count*[ModInt](c: TwelvefoldWay[ModInt], n, m: int,
            balls: BallKind, boxes: BoxKind,
            restriction: MappingConstraint = unrestricted): ModInt =
        ## n球をm箱に入れる12相の一つを数える。O(1)、範囲外・法変更は ValueError。
        ## injective は各箱高々1球、surjective は全箱非空。空の配置は一通り。
        c.checkRange(n, m)
        if n == 0:
            if restriction == surjective and m > 0:
                return 0
            return 1
        if m == 0:
            return 0
        if balls == distinctBalls:
            if boxes == distinctBoxes:
                case restriction
                of unrestricted: return c.powers[n][m]
                of injective: return (if n <= m: c.factorials[m] * c.inverseFactorials[m - n] else: ModInt(0))
                of surjective: return c.stirlingSecond(n, m) * c.factorials[m]
            else:
                case restriction
                of unrestricted: return c.stirlingSums[n][m]
                of injective: return (if n <= m: ModInt(1) else: ModInt(0))
                of surjective: return c.stirlingSecond(n, m)
        else:
            if boxes == distinctBoxes:
                case restriction
                of unrestricted: return c.binomial(n + m - 1, n)
                of injective: return c.binomial(m, n)
                of surjective: return c.binomial(n - 1, m - 1)
            else:
                case restriction
                of unrestricted: return c.partitions[n][m]
                of injective: return (if n <= m: ModInt(1) else: ModInt(0))
                of surjective: return c.partitionCount(n, m)

    proc countAll*[ModInt](c: TwelvefoldWay[ModInt], n, m: int): TwelvefoldCounts[ModInt] =
        ## [球の区別][箱の区別][制限]で添字付けした12相すべてを返す。O(1)。
        for balls in BallKind:
            for boxes in BoxKind:
                for restriction in MappingConstraint:
                    result[balls][boxes][restriction] = c.count(n, m, balls, boxes, restriction)
