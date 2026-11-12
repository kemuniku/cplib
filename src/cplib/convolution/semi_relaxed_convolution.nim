when not declared CPLIB_CONVOLUTION_SEMI_RELAXED_CONVOLUTION:
    const CPLIB_CONVOLUTION_SEMI_RELAXED_CONVOLUTION* = 1

    import cplib/convolution/convolution
    import cplib/modint/modint

    proc semiFixedCreate(data: ptr uint32, length, size: csize_t,
            modulus, root: uint32): pointer {.importc: "cplib_fixed_convolution_create".}
        ## 固定側のNTTと変換計画を構築する。

    proc semiFixedRun(context: pointer, output, data: ptr uint32,
            length: csize_t) {.importc: "cplib_fixed_convolution_run".}
        ## 固定側のNTTを再利用して畳み込みを求める。

    proc semiFixedDestroy(context: pointer) {.importc: "cplib_fixed_convolution_destroy".}
        ## 固定側のNTTと変換計画を解放する。

    type
        SemiRelaxedFixedPlanObj = object
            context: pointer
            modulus: uint32
        SemiRelaxedFixedPlan = ref SemiRelaxedFixedPlanObj

    when defined(gcDestructors):
        proc `=destroy`(plan: var SemiRelaxedFixedPlanObj) =
            ## 最後の所有者がなくなった変換計画を解放する。
            if plan.context != nil:
                semiFixedDestroy(plan.context)
                plan.context = nil
    else:
        proc finalizeSemiFixedPlan(plan: SemiRelaxedFixedPlan) =
            ## refcで到達不能となった変換計画を解放する。
            if plan.context != nil:
                semiFixedDestroy(plan.context)
                plan.context = nil

    proc newSemiFixedPlan(): SemiRelaxedFixedPlan =
        ## コピー先とも寿命を共有する変換計画の所有者を作る。
        when defined(gcDestructors):
            new(result)
        else:
            new(result, finalizeSemiFixedPlan)

    type SemiRelaxedConvolution*[T] = object
        fixed: seq[T]
        online, product: seq[T]
        # 計画だけはコピー先と共有し、逐次係数と作業配列は通常のseqとして保持する。
        plans: seq[SemiRelaxedFixedPlan]
        work, input: seq[uint32]

    proc initSemiRelaxedConvolution*[T: BarrettModint or MontgomeryModint](
            fixed: seq[T]): SemiRelaxedConvolution[T] =
        ## 左側をfixedに固定した逐次畳み込みを初期化する。
        ## NTTが利用できる場合、N項追加する計算量はO(N log^2 N)となる。
        ## 固定側の変換と計画を段ごとに再利用し、キャッシュの領域はO(min(fixed.len, N))。
        result.fixed = fixed

    proc len*[T](self: SemiRelaxedConvolution[T]): int = self.online.len

    proc coefficients*[T](self: SemiRelaxedConvolution[T]): seq[T] =
        ## 現在までに確定した積の係数を返す。
        result = newSeq[T](self.online.len)
        for i in 0..<min(result.len, self.product.len):
            result[i] = self.product[i]

    proc add*[T](
            self: var SemiRelaxedConvolution[T], value: T): T =
        ## オンライン側へ次の係数を追加し、その次数の積の係数を返す。
        self.online.add(value)
        let count = self.online.len
        var blockSize = 1
        var level = 0
        while true:
            let fixedLeft = blockSize - 1
            let fixedRight = min(fixedLeft + blockSize, self.fixed.len)
            if fixedLeft < fixedRight:
                let onlineLeft = count - blockSize
                let first = fixedLeft + onlineLeft
                let fixedCount = fixedRight - fixedLeft
                if blockSize <= 16:
                    let requiredLength = fixedRight + count - 1
                    if self.product.len < requiredLength:
                        self.product.setLen(requiredLength)
                    for i in fixedLeft..<fixedRight:
                        for j in onlineLeft..<count:
                            self.product[i + j] += self.fixed[i] * self.online[j]
                elif fixedCount > 60 and
                        canUseMultipointTreeNtt(T.umod, blockSize * 2):
                    if self.plans.len <= level:
                        self.plans.setLen(level + 1)
                    if self.plans[level] == nil or
                            self.plans[level].modulus != T.umod:
                        let plan = newSemiFixedPlan()
                        plan.modulus = T.umod
                        when T is BarrettModint:
                            plan.context = semiFixedCreate(
                                cast[ptr uint32](unsafeAddr self.fixed[fixedLeft]),
                                fixedCount.csize_t, (blockSize * 2).csize_t,
                                T.umod, 0u32)
                        else:
                            if self.input.len < fixedCount:
                                self.input.setLen(fixedCount)
                            for i in 0..<fixedCount:
                                self.input[i] = self.fixed[fixedLeft + i].val.uint32
                            plan.context = semiFixedCreate(addr self.input[0],
                                fixedCount.csize_t, (blockSize * 2).csize_t,
                                T.umod, 0u32)
                        self.plans[level] = plan
                    if self.work.len < blockSize * 2:
                        self.work.setLen(blockSize * 2)
                    when T is BarrettModint:
                        semiFixedRun(self.plans[level].context, addr self.work[0],
                            cast[ptr uint32](unsafeAddr self.online[onlineLeft]),
                            blockSize.csize_t)
                    else:
                        if self.input.len < blockSize:
                            self.input.setLen(blockSize)
                        for i in 0..<blockSize:
                            self.input[i] = self.online[onlineLeft + i].val.uint32
                        semiFixedRun(self.plans[level].context, addr self.work[0],
                            addr self.input[0], blockSize.csize_t)
                    let length = fixedCount + blockSize - 1
                    if self.product.len < first + length:
                        self.product.setLen(first + length)
                    when T is BarrettModint:
                        let values = cast[ptr UncheckedArray[T]](addr self.work[0])
                        for i in 0..<length:
                            self.product[first + i] += values[i]
                    else:
                        for i in 0..<length:
                            self.product[first + i] += init(T, self.work[i].int)
                else:
                    let values = convolution(self.fixed[fixedLeft..<fixedRight],
                        self.online[onlineLeft..<count])
                    if self.product.len < first + values.len:
                        self.product.setLen(first + values.len)
                    for i in 0..<values.len:
                        self.product[first + i] += values[i]
            if blockSize == (count and -count): break
            blockSize *= 2
            inc level
        if count - 1 < self.product.len:
            return self.product[count - 1]

    proc append*[T](
            self: var SemiRelaxedConvolution[T], value: T): T =
        self.add(value)

    proc get*[T](
            self: var SemiRelaxedConvolution[T], value: T): T =
        self.add(value)
