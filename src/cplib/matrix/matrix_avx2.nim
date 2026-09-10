import hashes
import cplib/modint/modint

when not declared CPLIB_MATRIX_MATRIX_AVX2:
    const CPLIB_MATRIX_MATRIX_AVX2* = 1
    import cplib/matrix/matrix_avx2_kernel
    export matrixProductKernel, matrixProductMontgomeryKernel, matrixJoinValues, matrixConvertValues, matrixWriteRow

    proc matrixProduct*(a, b: openArray[uint32], n, m, k: int,
            modulus: uint32 = 998244353u32): seq[uint32] =
        ## 行優先の一次元配列の行列積をAVX2で計算する。
        doAssert modulus > 0 and modulus < (1u32 shl 30) and
            (modulus and 1u32) == 1, "modulus must be odd and in [1, 2^30)"
        doAssert n >= 0 and m >= 0 and k >= 0, "negative matrix dimension"
        doAssert n <= high(cint).int and m <= high(cint).int and
            k <= high(cint).int, "matrix dimension exceeds int32"
        doAssert n == 0 or m <= high(int) div n, "matrix size overflow"
        doAssert m == 0 or k <= high(int) div m, "matrix size overflow"
        doAssert n == 0 or k <= high(int) div n, "matrix size overflow"
        doAssert a.len == n * m and b.len == m * k, "matrix size mismatch"
        for value in a:
            assert value < modulus, "matrix entries must be less than modulus"
        for value in b:
            assert value < modulus, "matrix entries must be less than modulus"
        result = newSeq[uint32](n * k)
        if n == 0 or m == 0 or k == 0 or modulus == 1:
            return
        matrixProductKernel(unsafeAddr a[0], unsafeAddr b[0], addr result[0],
            n.cint, m.cint, k.cint, modulus)

    proc matrixProduct*(a, b: openArray[seq[uint32]],
            modulus: uint32 = 998244353u32): seq[seq[uint32]] =
        ## 二次元配列の行列積をAVX2で計算する。
        let n = a.len
        let m = if n == 0: 0 else: a[0].len
        let k = if b.len == 0: 0 else: b[0].len
        doAssert m == b.len, "matrix size mismatch"
        for row in a:
            doAssert row.len == m, "ragged matrix"
        for row in b:
            doAssert row.len == k, "ragged matrix"
        doAssert n == 0 or m <= high(int) div n, "matrix size overflow"
        doAssert m == 0 or k <= high(int) div m, "matrix size overflow"
        var flatA = newSeq[uint32](n * m)
        var flatB = newSeq[uint32](m * k)
        for i in 0 ..< n:
            if m > 0:
                copyMem(addr flatA[i * m], unsafeAddr a[i][0], m * sizeof(uint32))
        for i in 0 ..< m:
            if k > 0:
                copyMem(addr flatB[i * k], unsafeAddr b[i][0], k * sizeof(uint32))
        let flatC = matrixProduct(flatA, flatB, n, m, k, modulus)
        result = newSeq[seq[uint32]](n)
        for i in 0 ..< n:
            result[i] = newSeq[uint32](k)
            if k > 0:
                copyMem(addr result[i][0], unsafeAddr flatC[i * k], k * sizeof(uint32))


    type MatrixRowStorage[T] = ref object
        values: seq[T]

    when defined(gcDestructors):
        type MatrixStorage[T] = MatrixRowStorage[T]
    else:
        # refcでは標準のseqコピーを使い、独自=copyによるGCルート登録欠落を避ける。
        type MatrixStorage[T] = object
            values: seq[T]

    type
        Matrix*[T] = object
            ## refcの代入は標準seqと同じ。行ビューからも独立させる場合はcloneを使う。
            storage: MatrixStorage[T]
            height, width: int
            modulus: uint32
        MatrixRow*[T] = object
            storage: MatrixRowStorage[T]
            offset, length: int
        MutableMatrixRow*[T] = object
            storage: MatrixRowStorage[T]
            offset, length: int

    when defined(gcDestructors):
        proc `=copy`[T](destination: var Matrix[T], source: Matrix[T]) =
            ## 行ビューは記憶域を共有し、行列そのものの代入は値をコピーする。
            destination.height = source.height
            destination.width = source.width
            destination.modulus = source.modulus
            if destination.storage == source.storage:
                return
            if source.storage.isNil:
                destination.storage = nil
            else:
                var storage = MatrixStorage[T](values: newSeq[T](source.storage.values.len))
                for i, value in source.storage.values:
                    storage.values[i] = value
                destination.storage = storage

    proc rowStorage[T](a: Matrix[T]): MatrixRowStorage[T] {.inline.} =
        ## 行ビューの寿命中、元の連続配列を共有して保持する。O(1)。
        when defined(gcDestructors):
            result = a.storage
        else:
            new(result)
            shallowCopy(result.values, a.storage.values)

    proc matrixModulus[T](): uint32 {.inline.} =
        ## 利用可能なmodint型と法を検査する。
        when T isnot MontgomeryModint and T isnot BarrettModint:
            {.error: "matrix_avx2.Matrix requires MontgomeryModint or BarrettModint".}
        static:
            doAssert sizeof(T) == sizeof(uint32)
            doAssert alignof(T) == alignof(uint32)
        result = T.umod.uint32
        doAssert result > 0 and result < (1u32 shl 30) and (result and 1) == 1,
            "modulus must be odd and in [1, 2^30)"

    proc matrixSize(h, w: int): int {.inline.} =
        ## 寸法と連続配列の要素数を検査する。
        doAssert h >= 0 and w >= 0 and h <= high(cint).int and w <= high(cint).int,
            "invalid matrix dimensions"
        doAssert h == 0 or w <= (high(int) div sizeof(uint32)) div h,
            "matrix size overflow"
        h * w

    proc checkModulus[T](a: Matrix[T]) {.inline.} =
        ## dynamic modintの法が行列作成後に変更されていないことを確認する。
        let modulus = matrixModulus[T]()
        doAssert a.modulus == 0 or a.modulus == modulus, "matrix modulus has changed"

    proc scalar[T](value: T or SomeInteger): T {.inline.} =
        ## 整数を正規化してからmodintへ変換する。
        when value is T:
            value
        elif value is SomeUnsignedInt:
            T.init((value.uint64 mod T.umod.uint64).int)
        else:
            T.init((value.int64 mod T.umod.int64).int)

    proc initMatrix*[T](h, w: int, value: T): Matrix[T] =
        ## h行w列の連続配列を確保し、全要素を指定した値で初期化する。
        let modulus = matrixModulus[T]()
        let size = matrixSize(h, w)
        result = Matrix[T](height: h, width: w, modulus: modulus,
            storage: MatrixStorage[T](values: newSeq[T](size)))
        let v = scalar[T](value)
        for x in result.storage.values.mitems:
            x = v

    proc initMatrix*[T](h, w: int, value: SomeInteger): Matrix[T] =
        ## 整数を法で正規化して全要素を初期化する。
        bind initMatrix
        discard matrixModulus[T]()
        initMatrix[T](h, w, scalar[T](value))

    proc initMatrix*[T](h, w: int): Matrix[T] =
        ## h行w列の零行列を作る。
        let modulus = matrixModulus[T]()
        let size = matrixSize(h, w)
        Matrix[T](height: h, width: w, modulus: modulus,
            storage: MatrixStorage[T](values: newSeq[T](size)))

    proc initMatrix*[T](h, w: int, values: sink seq[T]): Matrix[T] =
        ## 行優先の配列を行列へ移し、不要な要素コピーを避ける。
        let modulus = matrixModulus[T]()
        doAssert values.len == matrixSize(h, w), "matrix size mismatch"
        result = Matrix[T](height: h, width: w, modulus: modulus,
            storage: MatrixStorage[T](values: values))

    proc initMatrix*[T](h, w: int, values: openArray[uint32]): Matrix[T] =
        ## 正規化済みの公開値からmodintの連続行列を作る。
        result = initMatrix[T](h, w)
        doAssert values.len == result.storage.values.len, "matrix size mismatch"
        for value in values:
            assert value < result.modulus, "matrix entries must be less than modulus"
        if values.len > 0:
            matrixConvertValues(unsafeAddr values[0],
                cast[ptr uint32](addr result.storage.values[0]), values.len,
                result.modulus, T is MontgomeryModint)

    proc initMatrixOwned[T](h, w: int, values: var seq[uint32]): Matrix[T] =
        ## 所有権を持つ公開値配列を消費し、同じ領域をmodint配列として使う。
        let modulus = matrixModulus[T]()
        doAssert values.len == matrixSize(h, w), "matrix size mismatch"
        for value in values:
            assert value < modulus, "matrix entries must be less than modulus"
        result = Matrix[T](height: h, width: w, modulus: modulus,
            storage: MatrixStorage[T]())
        # 両modintは参照を含まないuint32フィールド1個。型を合わせてからmoveする。
        result.storage.values = move(cast[ptr seq[T]](addr values)[])
        when T is MontgomeryModint:
            if result.storage.values.len > 0:
                let data = cast[ptr uint32](addr result.storage.values[0])
                matrixConvertValues(data, data, result.storage.values.len, modulus, true)

    template initMatrix*[T](h, w: int, values: seq[uint32]): untyped =
        ## 一時配列はコピーせず取り込み、再利用する配列は通常の値コピーで保護する。
        block:
            let rows = h
            let columns = w
            var owned: seq[uint32] = values
            initMatrixOwned[T](rows, columns, owned)

    proc initMatrix*[T](values: openArray[seq[T]]): Matrix[T] =
        ## 二次元配列を連続配置の行列へコピーする。
        let h = values.len
        let w = if h == 0: 0 else: values[0].len
        result = initMatrix[T](h, w)
        for i, row in values:
            doAssert row.len == w, "ragged matrix"
            for j, value in row:
                result.storage.values[i * w + j] = value

    proc clone*[T](a: Matrix[T]): Matrix[T] =
        ## 行ビューやlet代入の共有によらない独立した行列を作る。O(h*w)。
        checkModulus(a)
        result = initMatrix[T](a.height, a.width)
        for i in 0 ..< a.height * a.width:
            result.storage.values[i] = a.storage.values[i]

    proc toMatrix*[T](values: openArray[seq[T]]): Matrix[T] =
        ## 二次元配列を行列へ変換する。
        bind initMatrix
        initMatrix(values)

    proc initMatrix*[T](values: openArray[T], vertical: bool = false): Matrix[T] =
        ## 一次元配列を1行または1列の行列へ変換する。
        bind initMatrix
        let h = if vertical: values.len else: 1
        let w = if vertical: 1 else: values.len
        initMatrix[T](h, w, @values)

    proc h*[T](a: Matrix[T]): int {.inline.} =
        ## 行数を返す。
        a.height
    proc w*[T](a: Matrix[T]): int {.inline.} =
        ## 列数を返す。行数0の場合も列数を保持する。
        a.width

    template checkIndex(index, size: int) =
        ## 通常の配列と同じコンパイル設定で添字を検査する。
        when compileOption("boundChecks"):
            if index < 0 or index >= size:
                raise newException(IndexDefect, "matrix index out of bounds")

    proc `[]`*[T](a: Matrix[T], r, c: int): T {.inline.} =
        ## 指定した要素を読み取る。
        checkIndex(r, a.height)
        checkIndex(c, a.width)
        a.storage.values[r * a.width + c]
    proc `[]`*[T](a: var Matrix[T], r, c: int): var T {.inline.} =
        ## 指定した要素への変更可能な参照を返す。
        checkIndex(r, a.height)
        checkIndex(c, a.width)
        a.storage.values[r * a.width + c]
    proc `[]=`*[T](a: var Matrix[T], r, c: int, value: T or SomeInteger) {.inline.} =
        ## 指定した要素へ代入する。
        checkIndex(r, a.height)
        checkIndex(c, a.width)
        a.storage.values[r * a.width + c] = scalar[T](value)

    proc `[]`*[T](a: Matrix[T], r: int): MatrixRow[T] {.inline.} =
        ## 行をコピーせず読み取り専用ビューとして返す。
        checkIndex(r, a.height)
        MatrixRow[T](storage: rowStorage(a), offset: r * a.width, length: a.width)
    proc `[]`*[T](a: var Matrix[T], r: int): MutableMatrixRow[T] {.inline.} =
        ## 元の行列を書き換えられる行ビューを返す。
        checkIndex(r, a.height)
        MutableMatrixRow[T](storage: rowStorage(a), offset: r * a.width, length: a.width)
    proc `[]`*[T](row: MatrixRow[T], column: int): T {.inline.} =
        ## 行ビューの要素を読み取る。
        checkIndex(column, row.length)
        row.storage.values[row.offset + column]
    proc `[]`*[T](row: MutableMatrixRow[T], column: int): var T {.inline.} =
        ## 行ビューから元の要素への参照を返す。
        checkIndex(column, row.length)
        row.storage.values[row.offset + column]
    proc `[]=`*[T](row: MutableMatrixRow[T], column: int, value: T or SomeInteger) {.inline.} =
        ## 行ビューを通して元の行列へ代入する。
        checkIndex(column, row.length)
        row.storage.values[row.offset + column] = scalar[T](value)
    proc len*[T](row: MatrixRow[T] or MutableMatrixRow[T]): int {.inline.} =
        ## 行ビューの列数を返す。
        row.length
    iterator items*[T](row: MatrixRow[T] or MutableMatrixRow[T]): T =
        ## 行の要素を左から順に列挙する。
        for i in 0 ..< row.length:
            yield row.storage.values[row.offset + i]
    iterator pairs*[T](row: MatrixRow[T] or MutableMatrixRow[T]): (int, T) =
        ## 行の列番号と要素を列挙する。
        for i in 0 ..< row.length:
            yield (i, row.storage.values[row.offset + i])
    iterator mitems*[T](row: MutableMatrixRow[T]): var T =
        ## 行の各要素を変更可能な参照として列挙する。
        for i in 0 ..< row.length:
            yield row.storage.values[row.offset + i]
    proc toSeq*[T](row: MatrixRow[T] or MutableMatrixRow[T]): seq[T] =
        ## 行ビューを独立した配列へコピーする。
        result = newSeq[T](row.length)
        for i in 0 ..< row.length:
            result[i] = row.storage.values[row.offset + i]
    proc join*[T](row: MatrixRow[T] or MutableMatrixRow[T], sep: string = ""): string =
        ## 行の値を指定した区切り文字で連結する。
        if row.length == 0: return ""
        let modulus = matrixModulus[T]()
        let values = cast[ptr uint32](unsafeAddr row.storage.values[row.offset])
        matrixJoinValues(values, row.length, modulus, T is MontgomeryModint, sep)
    proc writeRow*[T](row: MatrixRow[T] or MutableMatrixRow[T], output: File = stdout) =
        ## 行を空白区切りと改行で出力し、一時文字列の確保を避ける。
        let modulus = matrixModulus[T]()
        let values = if row.length == 0: nil else:
            cast[ptr uint32](unsafeAddr row.storage.values[row.offset])
        matrixWriteRow(values, row.length, modulus, T is MontgomeryModint, output)
    proc `[]=`*[T](a: var Matrix[T], r: int, row: openArray[T]) =
        ## 列数を保ったまま行の全要素を置き換える。
        checkIndex(r, a.height)
        doAssert row.len == a.width, "matrix row size mismatch"
        for j, value in row:
            a.storage.values[r * a.width + j] = value
    proc `[]=`*[T](a: var Matrix[T], r: int, row: MatrixRow[T] or MutableMatrixRow[T]) =
        ## 別の行ビューの内容を指定した行へコピーする。
        checkIndex(r, a.height)
        doAssert row.len == a.width, "matrix row size mismatch"
        for j in 0 ..< row.len:
            a.storage.values[r * a.width + j] = row[j]

    proc `*`*[T](a, b: Matrix[T]): Matrix[T] =
        ## 連続配置されたmodintを直接AVX2カーネルへ渡して乗算する。
        checkModulus(a)
        checkModulus(b)
        doAssert a.width == b.height, "matrix size mismatch"
        result = initMatrix[T](a.height, b.width)
        if a.height == 0 or a.width == 0 or b.width == 0 or result.modulus == 1:
            return
        let ap = cast[ptr uint32](unsafeAddr a.storage.values[0])
        let bp = cast[ptr uint32](unsafeAddr b.storage.values[0])
        let cp = cast[ptr uint32](addr result.storage.values[0])
        when T is MontgomeryModint:
            matrixProductMontgomeryKernel(ap, bp, cp, a.height.cint,
                a.width.cint, b.width.cint, result.modulus)
        else:
            matrixProductKernel(ap, bp, cp, a.height.cint,
                a.width.cint, b.width.cint, result.modulus)
    proc `*=`*[T](a: var Matrix[T], b: Matrix[T]) =
        ## 余分な左行列のコピーを作らずに積で置き換える。
        var product = a * b
        swap(a, product)
    proc matrixProduct*[T](a, b: Matrix[T]): Matrix[T] =
        ## 関数形式で高速行列の積を求める。
        a * b

    template defineAssignment(assign, op: untyped) =
        ## 加減算と対応する代入演算子をまとめて定義する。
        proc assign*[T](a: var Matrix[T], b: Matrix[T]) =
            ## 同じ形状の行列どうしを成分ごとに演算する。
            checkModulus(a)
            checkModulus(b)
            doAssert a.h == b.h and a.w == b.w, "matrix size mismatch"
            for i in 0 ..< a.h * a.w:
                assign(a.storage.values[i], b.storage.values[i])
        proc assign*[T](a: var Matrix[T], value: T or SomeInteger) =
            ## 全要素とスカラーを成分ごとに演算する。
            checkModulus(a)
            let v = scalar[T](value)
            for i in 0 ..< a.h * a.w:
                assign(a.storage.values[i], v)
        proc op*[T](a, b: Matrix[T]): Matrix[T] =
            ## 同じ形状の行列の演算結果を新しい行列に返す。
            result = a
            assign(result, b)
        proc op*[T](a: Matrix[T], value: T or SomeInteger): Matrix[T] =
            ## 各要素とスカラーの演算結果を新しい行列に返す。
            result = a
            assign(result, value)
    defineAssignment(`+=`, `+`)
    defineAssignment(`-=`, `-`)

    proc `-`*[T](a: Matrix[T]): Matrix[T] =
        ## 各要素の加法逆元を求める。
        result = initMatrix[T](a.h, a.w)
        result -= a
    proc `+`*[T](value: T, a: Matrix[T]): Matrix[T] =
        ## スカラーと行列の各要素を加算する。
        a + value
    proc `-`*[T](value: T, a: Matrix[T]): Matrix[T] =
        ## スカラーから行列の各要素を引く。
        bind initMatrix
        result = initMatrix[T](a.h, a.w, value)
        result -= a
    proc `*=`*[T](a: var Matrix[T], value: T or SomeInteger) =
        ## 行列の全要素をスカラー倍する。
        checkModulus(a)
        let v = scalar[T](value)
        for i in 0 ..< a.h * a.w:
            a.storage.values[i] *= v
    proc `*`*[T](a: Matrix[T], value: T or SomeInteger): Matrix[T] =
        ## スカラー倍した行列を新しく返す。
        result = a
        result *= value
    proc `*`*[T](value: T, a: Matrix[T]): Matrix[T] =
        ## スカラー倍した行列を新しく返す。
        a * value

    proc `+`*[T](value: SomeInteger, a: Matrix[T]): Matrix[T] =
        ## 整数と行列の各要素を加算する。
        a + scalar[T](value)
    proc `-`*[T](value: SomeInteger, a: Matrix[T]): Matrix[T] =
        ## 整数から行列の各要素を引く。
        scalar[T](value) - a
    proc `*`*[T](value: SomeInteger, a: Matrix[T]): Matrix[T] =
        ## 整数で行列をスカラー倍する。
        a * scalar[T](value)

    proc identity_matrix*[T](n: int, one, zero: T): Matrix[T] =
        ## 指定した対角成分と非対角成分から正方行列を作る。
        bind initMatrix
        result = initMatrix[T](n, n, zero)
        for i in 0 ..< n:
            result[i, i] = one
    proc identity_matrix*[T](n: int): Matrix[T] =
        ## n行n列の単位行列を作る。
        bind identity_matrix
        identity_matrix[T](n, T.init(1), T.init(0))
    proc pow*[T](a: Matrix[T], exponent: int): Matrix[T] =
        ## 非負整数乗を繰り返し二乗法で求める。
        bind identity_matrix
        checkModulus(a)
        doAssert a.h == a.w and exponent >= 0, "invalid matrix power"
        if exponent == 0:
            return identity_matrix[T](a.h)
        if exponent == 1:
            return a
        var base = a
        var n = exponent
        var initialized = false
        while n > 0:
            if (n and 1) != 0:
                if initialized:
                    result *= base
                else:
                    result = base
                    initialized = true
            n = n shr 1
            if n != 0: base *= base
    proc `**`*[T](a: Matrix[T], exponent: int): Matrix[T] =
        ## 行列の非負整数乗を求める。
        a.pow(exponent)
    proc sum*[T](a: Matrix[T]): T =
        ## 全要素の和を求める。
        checkModulus(a)
        result = T.init(0)
        for i in 0 ..< a.h * a.w:
            result += a.storage.values[i]
    proc `==`*[T](a, b: Matrix[T]): bool =
        ## modintの冗長な内部表現によらず形状と値を比較する。
        checkModulus(a)
        checkModulus(b)
        if a.h != b.h or a.w != b.w: return false
        let modulus = T.umod.int
        for i in 0 ..< a.h * a.w:
            if a.storage.values[i].val mod modulus != b.storage.values[i].val mod modulus:
                return false
        true
    proc hash*[T](a: Matrix[T]): Hash =
        ## 形状と正規化した値からハッシュを求める。
        checkModulus(a)
        result = hash((a.h, a.w, T.umod.int))
        for i in 0 ..< a.h * a.w:
            result = result !& hash(a.storage.values[i].val mod T.umod.int)
        result = !$result
    proc `$`*[T](a: Matrix[T]): string =
        ## 各行を空白区切りで表示する。
        checkModulus(a)
        for i in 0 ..< a.h:
            if i != 0: result.add('\n')
            result.add(a[i].join(" "))

    proc matrixProductLegacy[M: object, T](a, b: M, Element: typedesc[T]): M =
        ## 二次元配列を保持する従来のMatrixにAVX2の積を返す。
        # 型はtypedescで受け取り、Nim 1.6でのmodintの型引数誤束縛を避ける。
        bind matrixProduct
        mixin h, w, `[]`
        when T isnot MontgomeryModint and T isnot BarrettModint:
            {.error: "matrixProduct requires MontgomeryModint or BarrettModint".}
        let n = a.h
        let m = a.w
        let k = b.w
        doAssert m == b.h, "matrix size mismatch"
        let modulus = T.umod.uint32
        doAssert modulus > 0 and modulus < (1u32 shl 30) and
                (modulus and 1u32) == 1, "modulus must be odd and in [1, 2^30)"
        doAssert n == 0 or m <= high(int) div n, "matrix size overflow"
        doAssert m == 0 or k <= high(int) div m, "matrix size overflow"
        var flatA = newSeq[uint32](n * m)
        var flatB = newSeq[uint32](m * k)
        for i in 0 ..< n:
            doAssert a[i].len == m, "ragged matrix"
            for j in 0 ..< m:
                flatA[i * m + j] = a[i, j].val.uint32
        for i in 0 ..< m:
            doAssert b[i].len == k, "ragged matrix"
            for j in 0 ..< k:
                flatB[i * k + j] = b[i, j].val.uint32
        let flatC = matrixProduct(flatA, flatB, n, m, k, modulus)
        # 旧Matrixをimportせず、提出用のソース展開でもMatrix名の重複を防ぐ。
        for name, values in fieldPairs(result):
            when name == "arr" and values is seq[seq[T]]:
                values = newSeq[seq[T]](n)
                for i in 0 ..< n:
                    values[i] = newSeq[T](k)
                    for j in 0 ..< k:
                        values[i][j] = T.init(flatC[i * k + j].int)
            elif name == "emptyWidth" and values is int:
                values = k
            else:
                {.error: "unsupported matrix representation".}

    type LegacyMatrix[T] = concept x
        x.h is int
        x.w is int
        x[0, 0] is T

    proc matrixProduct*[T](a, b: LegacyMatrix[T]): auto =
        ## 従来のMatrix型を保ったままAVX2で行列積を計算する。
        mixin `[]`
        matrixProductLegacy(a, b, typeof(a[0, 0]))

    import options
    import cplib/matrix/field_matrix_ops
    export LinearSystemSolution

    type FieldReduction = object
        values: seq[uint32]
        pivots: seq[cint]
        width, rank: int
        determinant: uint32

    proc fieldPointer[T](values: openArray[T]): ptr uint32 =
        ## 空配列を含むmodint内部値の連続領域を参照する。
        if values.len == 0: nil
        else: cast[ptr uint32](unsafeAddr values[0])

    proc fieldMatrixPointer[T](a: Matrix[T]): ptr uint32 =
        ## 空行列を含む行列の内部領域を読み取る。
        when defined(gcDestructors):
            if a.storage.isNil: return nil
        fieldPointer(a.storage.values)

    proc fieldPivotPointer(pivots: openArray[cint]): ptr cint =
        ## 空配列を含むピボット列の領域を参照する。
        if pivots.len == 0: nil
        else: cast[ptr cint](unsafeAddr pivots[0])

    proc reduceFieldMatrix[T](a: Matrix[T], extra: int, reduced: bool,
            rhs: ptr uint32 = nil, identity: bool = false): FieldReduction =
        ## 入力を保持したまま、拡大行列をAVX2で前進消去・掃き出しする。
        checkModulus(a)
        doAssert extra >= 0 and extra <= high(cint).int - a.w, "matrix size overflow"
        result.width = a.w + extra
        result.values = newSeq[uint32](matrixSize(a.h, result.width))
        result.pivots = newSeq[cint](min(a.h, a.w))
        let modulus = matrixModulus[T]()
        fieldPrepareKernel(fieldMatrixPointer(a), rhs, fieldPointer(result.values),
            a.h, a.w, extra, modulus, T is MontgomeryModint, identity)
        result.rank = fieldEliminateKernel(fieldPointer(result.values), a.h,
            result.width, a.w, fieldPivotPointer(result.pivots), result.determinant, modulus, reduced)

    proc rank*[T](a: Matrix[T]): int =
        ## AVX2の前進消去で階数を求める。O(h*w*min(h,w))。
        reduceFieldMatrix(a, 0, false).rank

    proc determinant*[T](a: Matrix[T]): T =
        ## AVX2の前進消去で行列式を求める。空行列は1。O(n^3)。
        assert a.h == a.w
        let reduced = reduceFieldMatrix(a, 0, false)
        if reduced.rank != a.h: return T.init(0)
        T.init(fieldCanonicalKernel(reduced.determinant, matrixModulus[T]()).int)

    proc hafnian*[T](a: Matrix[T]): T =
        ## 対称な偶数次行列のhafnianをAVX2の多項式積和で求める。O(n^2*2^(n/2))。
        checkModulus(a)
        assert a.h == a.w and a.h mod 2 == 0
        for i in 0..<a.h:
            for j in 0..<i: assert a[i,j].val == a[j,i].val, "matrix must be symmetric"
        T.init(fieldHafnianKernel(fieldMatrixPointer(a), a.h,
            matrixModulus[T](), T is MontgomeryModint).int)

    proc solveLinearSystem*[T](a: Matrix[T], b: openArray[T]): Option[LinearSystemSolution[T]] =
        ## AVX2でAx=bを掃き出し、特殊解と核の基底を返す。O(h*w*min(h,w)+w^2)。
        assert b.len == a.h
        var reduced = reduceFieldMatrix(a, 1, true, fieldPointer(b))
        for i in reduced.rank..<a.h:
            if reduced.values[i * reduced.width + a.w] != 0:
                return none(LinearSystemSolution[T])
        fieldRestoreKernel(fieldPointer(reduced.values), reduced.values.len,
            matrixModulus[T](), T is MontgomeryModint)
        var solution: LinearSystemSolution[T]
        solution.particular = newSeq[T](a.w)
        var isPivot = newSeq[bool](a.w)
        for i in 0..<reduced.rank:
            let col = reduced.pivots[i].int
            isPivot[col] = true
            solution.particular[col] = cast[T](reduced.values[i * reduced.width + a.w])
        let one = T.init(1)
        for free in 0..<a.w:
            if isPivot[free]: continue
            var vector = newSeq[T](a.w)
            vector[free] = one
            for i in 0..<reduced.rank:
                vector[reduced.pivots[i].int] = -cast[T](reduced.values[i * reduced.width + free])
            solution.basis.add(vector)
        some(solution)

    proc inverse*[T](a: Matrix[T]): Option[Matrix[T]] =
        ## AVX2の掃き出しで逆行列を返す。特異行列はnone。O(n^3)。
        assert a.h == a.w
        let reduced = reduceFieldMatrix(a, a.h, true, identity = true)
        if reduced.rank != a.h: return none(Matrix[T])
        var answer = initMatrix[T](a.h, a.h)
        fieldInverseAdjugateKernel(fieldPointer(reduced.values), fieldMatrixPointer(answer),
            a.h, reduced.rank, fieldPivotPointer(reduced.pivots), reduced.determinant,
            matrixModulus[T](), T is MontgomeryModint, false)
        some(answer)

    proc adjugate*[T](a: Matrix[T]): Matrix[T] =
        ## AVX2で特異行列を含む余因子行列を返す。O(n^3)。
        assert a.h == a.w
        let reduced = reduceFieldMatrix(a, a.h, true, identity = true)
        result = initMatrix[T](a.h, a.h)
        fieldInverseAdjugateKernel(fieldPointer(reduced.values), fieldMatrixPointer(result),
            a.h, reduced.rank, fieldPivotPointer(reduced.pivots), reduced.determinant,
            matrixModulus[T](), T is MontgomeryModint, true)
