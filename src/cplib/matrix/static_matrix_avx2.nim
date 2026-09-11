when not declared CPLIB_MATRIX_STATIC_MATRIX_AVX2:
    const CPLIB_MATRIX_STATIC_MATRIX_AVX2* = 1
    import cplib/modint/modint
    import cplib/matrix/matrix_avx2_kernel
    import cplib/matrix/field_matrix_ops
    import options
    export LinearSystemSolution

    type StaticMatrix*[H: static int, W: static int, T] = object
        values: array[H*W,T]
        modulus: uint32

    proc fieldModulus[T](): uint32 =
        ## AVX2で扱えるmodint型と法を検査する。
        when T isnot MontgomeryModint and T isnot BarrettModint:
            {.error: "static_matrix_avx2 requires MontgomeryModint or BarrettModint".}
        static: doAssert sizeof(T) == sizeof(uint32) and alignof(T) == alignof(uint32)
        result = T.umod
        doAssert result > 0 and result < (1u32 shl 30) and (result and 1) == 1

    proc checkMatrix[H: static int, W: static int, T](a: StaticMatrix[H,W,T]) =
        ## 固定長の寸法と作成時の法を検査する。
        static:
            doAssert H >= 0 and W >= 0 and H <= high(cint).int and W <= high(cint).int
            doAssert H == 0 or W <= (high(int) div sizeof(T)) div H
        let modulus = fieldModulus[T]()
        doAssert a.modulus == 0 or a.modulus == modulus, "matrix modulus has changed"

    proc buffer[T](a: openArray[T]): ptr uint32 =
        ## 空配列を含む連続領域の先頭を返す。
        if a.len == 0: nil
        else: cast[ptr uint32](unsafeAddr a[0])

    proc initMatrix*[H: static int, W: static int, T](value: T = T.init(0)): StaticMatrix[H,W,T] =
        ## H行W列の固定長行列を指定値で初期化する。O(H*W)。
        checkMatrix(result)
        result.modulus = fieldModulus[T]()
        for i in 0..<H*W: result.values[i] = value

    proc toMatrix*[H: static int, W: static int, T](rows: array[H,array[W,T]]): StaticMatrix[H,W,T] =
        ## 二次元固定長配列を行列にする。O(H*W)。
        checkMatrix(result)
        result.modulus = fieldModulus[T]()
        for i in 0..<H:
            for j in 0..<W: result.values[i*W+j] = rows[i][j]

    proc h*[H: static int, W: static int, T](a: StaticMatrix[H,W,T]): int =
        ## 行数を返す。
        H
    proc w*[H: static int, W: static int, T](a: StaticMatrix[H,W,T]): int =
        ## 列数を返す。
        W
    proc `[]`*[H: static int, W: static int, T](a: StaticMatrix[H,W,T], i,j: int): T =
        ## 指定位置の要素を返す。
        assert i in 0..<H and j in 0..<W
        a.values[i*W+j]
    proc `[]`*[H: static int, W: static int, T](a: var StaticMatrix[H,W,T], i,j: int): var T =
        ## 指定位置の要素を変更可能な参照で返す。
        assert i in 0..<H and j in 0..<W
        a.values[i*W+j]
    proc `[]=`*[H: static int, W: static int, T](a: var StaticMatrix[H,W,T], i,j: int, value: T) =
        ## 指定位置の要素を更新する。
        assert i in 0..<H and j in 0..<W
        a.values[i*W+j] = value
    proc `[]`*[H: static int, W: static int, T](a: StaticMatrix[H,W,T], i: int): array[W,T] =
        ## 指定行をコピーする。O(W)。
        assert i in 0..<H
        for j in 0..<W: result[j] = a.values[i*W+j]
    proc `[]=`*[H: static int, W: static int, T](a: var StaticMatrix[H,W,T], i: int, row: array[W,T]) =
        ## 指定行を置き換える。O(W)。
        assert i in 0..<H
        for j in 0..<W: a.values[i*W+j] = row[j]
    proc `==`*[H: static int, W: static int, T](a,b: StaticMatrix[H,W,T]): bool =
        ## 公開値で全要素を比較する。O(H*W)。
        checkMatrix(a)
        checkMatrix(b)
        for i in 0..<H*W:
            if a.values[i].val != b.values[i].val: return false
        true
    proc `$`*[H: static int, W: static int, T](a: StaticMatrix[H,W,T]): string =
        ## 行を改行で区切った文字列にする。O(H*W)。
        checkMatrix(a)
        for i in 0..<H:
            if i > 0: result.add('\n')
            when W > 0:
                result.add(matrixJoinValues(cast[ptr uint32](unsafeAddr a.values[i*W]), W, fieldModulus[T](), T is MontgomeryModint, " "))

    proc `*`*[H: static int, W: static int, K: static int, T](a: StaticMatrix[H,W,T], b: StaticMatrix[W,K,T]): StaticMatrix[H,K,T] =
        ## 各寸法が4以下なら直接乗算し、それ以外はAVX2で行列積を求める。
        bind initMatrix
        checkMatrix(a)
        checkMatrix(b)
        result = initMatrix[H,K,T]()
        when H <= 4 and W <= 4 and K <= 4:
            # 極小行列では16単位のパディングと作業領域の確保を避ける。
            for i in 0..<H:
                for j in 0..<K:
                    for k in 0..<W:
                        result.values[i*K+j] += a.values[i*W+k] * b.values[k*K+j]
        elif H > 0 and W > 0 and K > 0:
            when T is MontgomeryModint:
                matrixProductMontgomeryKernel(buffer(a.values), buffer(b.values), buffer(result.values), H.cint, W.cint, K.cint, fieldModulus[T]())
            else:
                matrixProductKernel(buffer(a.values), buffer(b.values), buffer(result.values), H.cint, W.cint, K.cint, fieldModulus[T]())
    proc `*=`*[H: static int, W: static int, T](a: var StaticMatrix[H,W,T], b: StaticMatrix[W,W,T]) =
        ## 行列積で置き換える。
        a = a * b
    proc matrixProduct*[H: static int, W: static int, K: static int, T](a: StaticMatrix[H,W,T], b: StaticMatrix[W,K,T]): StaticMatrix[H,K,T] =
        ## 関数形式でAVX2行列積を求める。
        a * b

    template defineElementwise(assign, op: untyped) =
        ## 成分ごとの加減算と代入を定義する。
        proc assign*[H: static int, W: static int, T](a: var StaticMatrix[H,W,T], b: StaticMatrix[H,W,T]) =
            ## 成分ごとに加減算する。O(H*W)。
            checkMatrix(a)
            checkMatrix(b)
            for i in 0..<H*W: assign(a.values[i], b.values[i])
        proc op*[H: static int, W: static int, T](a,b: StaticMatrix[H,W,T]): StaticMatrix[H,W,T] =
            ## 成分ごとの加減算の結果を返す。O(H*W)。
            result = a
            assign(result,b)
        proc assign*[H: static int, W: static int, T](a: var StaticMatrix[H,W,T], value: T) =
            ## 全成分に定数を加減算する。O(H*W)。
            checkMatrix(a)
            for i in 0..<H*W: assign(a.values[i],value)
        proc op*[H: static int, W: static int, T](a: StaticMatrix[H,W,T], value: T): StaticMatrix[H,W,T] =
            ## 全成分に定数を加減算した行列を返す。O(H*W)。
            result = a
            assign(result,value)
    defineElementwise(`+=`, `+`)
    defineElementwise(`-=`, `-`)
    proc `*=`*[H: static int, W: static int, T](a: var StaticMatrix[H,W,T], value: T) =
        ## 全成分を定数倍する。O(H*W)。
        checkMatrix(a)
        for i in 0..<H*W: a.values[i] *= value
    proc `*`*[H: static int, W: static int, T](a: StaticMatrix[H,W,T], value: T): StaticMatrix[H,W,T] =
        ## 定数倍した行列を返す。O(H*W)。
        result = a
        result *= value
    proc `*`*[H: static int, W: static int, T](value: T, a: StaticMatrix[H,W,T]): StaticMatrix[H,W,T] =
        ## 定数倍した行列を返す。O(H*W)。
        a * value
    proc `-`*[H: static int, W: static int, T](a: StaticMatrix[H,W,T]): StaticMatrix[H,W,T] =
        ## 全成分の符号を反転する。O(H*W)。
        a * (-T.init(1))
    proc identity_matrix*[H: static int, W: static int, T](n: int = H): StaticMatrix[H,W,T] =
        ## H×H単位行列を返す。O(H^2)。
        bind initMatrix
        static: doAssert H == W
        assert n == H
        checkMatrix(result)
        result.modulus = fieldModulus[T]()
        for i in 0..<H: result.values[i*W+i] = T.init(1)
    proc pow*[H: static int, W: static int, T](a: StaticMatrix[H,W,T], exponent: int): StaticMatrix[H,W,T] =
        ## 二分累乗法で非負整数乗を求める。
        bind identity_matrix
        static: doAssert H == W
        doAssert exponent >= 0
        checkMatrix(a)
        result = identity_matrix[H,W,T]()
        var base = a
        var e = exponent
        while e > 0:
            if (e and 1) != 0: result *= base
            e = e shr 1
            if e > 0: base *= base
    proc `**`*[H: static int, W: static int, T](a: StaticMatrix[H,W,T], exponent: int): StaticMatrix[H,W,T] =
        ## 非負整数乗を求める。
        a.pow(exponent)

    proc sum*[H: static int, W: static int, T](a: StaticMatrix[H,W,T]): T =
        ## 全成分の和を返す。O(H*W)。
        checkMatrix(a)
        for i in 0..<H*W: result += a.values[i]

    type Reduction[H: static int, W: static int, E: static int] = object
        values: array[H*(W+E),uint32]
        pivots: array[min(H,W),cint]
        width, rank: int
        determinant: uint32

    proc reduce[H: static int, W: static int, T](a: StaticMatrix[H,W,T], height, width: int, extra: static int, reduced: bool, rhs: ptr uint32 = nil, identity: bool = false): ref Reduction[H,W,extra] =
        ## 固定容量の作業領域をヒープに確保してAVX2で消去する。
        checkMatrix(a)
        doAssert height in 0..H and width in 0..W
        static: doAssert extra >= 0 and W <= high(cint).int-extra
        new result
        let actualExtra = if identity: height else: extra
        result.width = width + actualExtra
        fieldPrepareKernel(buffer(a.values), rhs, buffer(result.values), height, width, actualExtra, fieldModulus[T](), T is MontgomeryModint, identity, W)
        result.rank = fieldEliminateKernel(buffer(result.values), height, result.width, width, cast[ptr cint](buffer(result.pivots)), result.determinant, fieldModulus[T](), reduced)

    proc rank*[H: static int, W: static int, T](a: StaticMatrix[H,W,T], height: int = H, width: int = W): int =
        ## 左上height×widthの階数をAVX2で求める。O(H*W+h*w*min(h,w))。
        reduce(a,height,width,0,false).rank
    proc determinant*[H: static int, W: static int, T](a: StaticMatrix[H,W,T], n: int = H): T =
        ## 左上n×nの行列式をAVX2で求める。空行列は1。O(H*W+n^3)。
        let r = reduce(a,n,n,0,false)
        if r.rank != n: return T.init(0)
        T.init(fieldCanonicalKernel(r.determinant,fieldModulus[T]()).int)
    proc hafnian*[H: static int, W: static int, T](a: StaticMatrix[H,W,T], n: int = H): T =
        ## 対称な左上n×nのhafnianをAVX2で求める。O(n^2*2^(n/2))。
        checkMatrix(a)
        doAssert n in 0..min(H,W) and n mod 2 == 0
        for i in 0..<n:
            for j in 0..<i: assert a[i,j].val == a[j,i].val
        T.init(fieldHafnianKernel(buffer(a.values),n,fieldModulus[T](),T is MontgomeryModint,W).int)
    proc solveLinearSystem*[H: static int, W: static int, T](a: StaticMatrix[H,W,T], b: openArray[T], height: int = H, width: int = W): Option[LinearSystemSolution[T]] =
        ## 左上height×widthでAx=bの特殊解と核の基底を求める。O(H*W+h*w*min(h,w)+w^2)。
        doAssert b.len == height
        let r = reduce(a,height,width,1,true,buffer(b))
        for i in r.rank..<height:
            if r.values[i*r.width+width] != 0: return none(LinearSystemSolution[T])
        fieldRestoreKernel(buffer(r.values),height*r.width,fieldModulus[T](),T is MontgomeryModint)
        var solution: LinearSystemSolution[T]
        solution.particular = newSeq[T](width)
        var isPivot = newSeq[bool](width)
        for i in 0..<r.rank:
            let col = r.pivots[i].int
            isPivot[col] = true
            solution.particular[col] = cast[T](r.values[i*r.width+width])
        for free in 0..<width:
            if isPivot[free]: continue
            var vector = newSeq[T](width)
            vector[free] = T.init(1)
            for i in 0..<r.rank: vector[r.pivots[i].int] = -cast[T](r.values[i*r.width+free])
            solution.basis.add(vector)
        some(solution)
    proc inverse*[H: static int, W: static int, T](a: StaticMatrix[H,W,T], n: int = H): Option[StaticMatrix[H,W,T]] =
        ## 左上n×nの逆行列をAVX2で求める。範囲外は零、特異行列はnone。O(H*W+n^3)。
        bind initMatrix
        let r = reduce(a,n,n,min(H,W),true,identity=true)
        if r.rank != n: return none(StaticMatrix[H,W,T])
        var answer = initMatrix[H,W,T]()
        fieldInverseAdjugateKernel(buffer(r.values),buffer(answer.values),n,r.rank,cast[ptr cint](buffer(r.pivots)),r.determinant,fieldModulus[T](),T is MontgomeryModint,false,W)
        some(answer)
    proc adjugate*[H: static int, W: static int, T](a: StaticMatrix[H,W,T], n: int = H): StaticMatrix[H,W,T] =
        ## 左上n×nの余因子行列をAVX2で求める。範囲外は零。O(H*W+n^3)。
        bind initMatrix
        let r = reduce(a,n,n,min(H,W),true,identity=true)
        checkMatrix(result)
        result.modulus = fieldModulus[T]()
        fieldInverseAdjugateKernel(buffer(r.values),buffer(result.values),n,r.rank,cast[ptr cint](buffer(r.pivots)),r.determinant,fieldModulus[T](),T is MontgomeryModint,true,W)
