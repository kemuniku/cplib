# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import hashes, os, random, sequtils, sets, strutils, std/tempfiles
import cplib/matrix/matrix_avx2
import cplib/modint/modint

proc residue[T](x: T): uint64 =
    ## modintの内部表現によらず標準剰余を返す。
    x.val.uint64 mod T.umod.uint64

proc naiveProduct[T](a, b: Matrix[T]): seq[uint64] =
    ## 64ビット整数の剰余演算による独立した行列積を求める。
    result = newSeq[uint64](a.h * b.w)
    let p = T.umod.uint64
    for i in 0 ..< a.h:
        for j in 0 ..< b.w:
            for k in 0 ..< a.w:
                result[i * b.w + j] = (result[i * b.w + j] +
                    residue(a[i, k]) * residue(b[k, j])) mod p

proc checkEntries[T](a: Matrix[T], expected: openArray[uint64]) =
    ## すべての要素を独立計算した標準剰余と比較する。
    doAssert a.h * a.w == expected.len
    for i in 0 ..< a.h:
        for j in 0 ..< a.w:
            doAssert residue(a[i, j]) == expected[i * a.w + j]

proc checkProduct[T](a, b: Matrix[T]) =
    ## 積と複合代入を検証し、入力行列が変わらないことを確認する。
    let savedA = a
    let savedB = b
    let expected = naiveProduct(a, b)
    let c = a * b
    doAssert c.h == a.h and c.w == b.w
    checkEntries(c, expected)
    doAssert matrixProduct(a, b) == c
    var d = a
    d *= b
    doAssert d.h == a.h and d.w == b.w
    checkEntries(d, expected)
    doAssert a == savedA and b == savedB

proc checkRandom[T](seed: int64) =
    ## 小さい非正方行列と演算後の冗長表現を素朴な積と比較する。
    var rng = initRand(seed)
    let bound = T.umod.int - 1
    for trial in 0 ..< 45:
        let h = rng.rand(0 .. 17)
        let w = rng.rand(0 .. 17)
        let k = rng.rand(0 .. 17)
        var a = initMatrix[T](h, w, T.init(0))
        var b = initMatrix[T](w, k, T.init(0))
        for i in 0 ..< h:
            for j in 0 ..< w:
                a[i, j] = T.init(rng.rand(-bound .. bound))
                a[i, j] += T.init(rng.rand(0 .. bound))
                a[i, j] -= T.init(rng.rand(0 .. bound))
        for i in 0 ..< w:
            for j in 0 ..< k:
                b[i][j] = T.init(rng.rand(-bound .. bound))
                b[i][j] += T.init(rng.rand(0 .. bound))
                b[i][j] -= T.init(rng.rand(0 .. bound))
        checkProduct(a, b)

proc checkApi[T]() =
    ## 既存の行列APIとコピー、行ビューの所有権を検証する。
    let zero = T.init(0)
    let one = T.init(1)
    let two = T.init(2)
    let three = T.init(3)
    let source = @[@[one, two], @[three, T.init(4)]]
    let a = initMatrix(source)
    doAssert a.h == 2 and a.w == 2
    doAssert initMatrix[T](2, 3) == initMatrix[T](2, 3, zero)
    doAssert a == source.toMatrix
    doAssert $a == "1 2\n3 4"
    doAssert a[0].join(" ") == "1 2"
    doAssert residue(a.sum) == 10
    doAssert a[0].len == 2
    doAssert toSeq(a[1]).mapIt(residue(it)) == @[3u64, 4u64]
    var seen: seq[uint64]
    for x in a[0]: seen.add(residue(x))
    doAssert seen == @[1u64, 2u64]
    for i, x in a[1]: doAssert residue(x) == (i + 3).uint64

    var rowInput = @[one, two, three]
    let horizontal = initMatrix(rowInput)
    let vertical = initMatrix(rowInput, true)
    doAssert horizontal.h == 1 and horizontal.w == 3
    doAssert vertical.h == 3 and vertical.w == 1
    rowInput[0] = T.init(90)
    doAssert residue(horizontal[0, 0]) == 1
    doAssert residue(vertical[0, 0]) == 1
    var flatInput = @[one, two, three, T.init(4)]
    let flat = initMatrix[T](2, 2, flatInput)
    flatInput[0] = T.init(90)
    doAssert flat == a

    var b = a
    b[0, 0] = T.init(8)
    b[1][1] += one
    doAssert residue(a[0, 0]) == 1 and residue(a[1, 1]) == 4
    doAssert residue(b[0, 0]) == 8 and residue(b[1, 1]) == 5
    b[0] = @[three, two]
    doAssert residue(b[0, 0]) == 3 and residue(b[0, 1]) == 2
    b[0] = b[1]
    doAssert toSeq(b[0]).mapIt(residue(it)) == @[3u64, 5u64]

    var owner = a
    var mutableRow = owner[0]
    let copiedAfterView = owner.clone()
    var assignedAfterView = owner
    let letAfterView = owner
    mutableRow[0] = T.init(9)
    for x in mutableRow.mitems: x += one
    doAssert residue(owner[0, 0]) == 10 and residue(owner[0, 1]) == 3
    doAssert residue(copiedAfterView[0, 0]) == 1
    doAssert residue(assignedAfterView[0, 0]) == 1
    when defined(gcDestructors):
        doAssert residue(letAfterView[0, 0]) == 1
    else:
        doAssert residue(letAfterView[0, 0]) == 10
    var copiedRow = mutableRow
    copiedRow[1] = T.init(6)
    doAssert residue(owner[0, 1]) == 6
    var detached = toSeq(mutableRow)
    detached[0] = zero
    doAssert residue(owner[0, 0]) == 10
    owner = initMatrix[T](1, 1, zero)
    mutableRow[0] = T.init(7)
    doAssert residue(mutableRow[0]) == 7 and residue(owner[0, 0]) == 0
    let temporaryRow = (a * a)[0]
    doAssert toSeq(temporaryRow).mapIt(residue(it)) == @[7u64, 10u64]
    let scopedRow = block:
        let temporaryOwner = a * a
        temporaryOwner[1]
    doAssert toSeq(scopedRow).mapIt(residue(it)) == @[15u64, 22u64]

    checkEntries(a + a, [2u64, 4, 6, 8])
    checkEntries(a - a, [0u64, 0, 0, 0])
    checkEntries(a + three, [4u64, 5, 6, 7])
    checkEntries(three + a, [4u64, 5, 6, 7])
    checkEntries(a * three, [3u64, 6, 9, 12])
    checkEntries(three * a, [3u64, 6, 9, 12])
    checkEntries(5 - a, [4u64, 3, 2, 1])
    checkEntries(a + 3, [4u64, 5, 6, 7])
    checkEntries(3 + a, [4u64, 5, 6, 7])
    checkEntries(3 * a, [3u64, 6, 9, 12])
    doAssert (a - three) + three == a
    doAssert -(-a) == a
    b = a
    b += a
    doAssert b == a + a
    b -= a
    doAssert b == a
    b += three
    b -= three
    b *= three
    doAssert b == a * three
    doAssert a == source.toMatrix

    let p = T.umod.uint64
    var scalarMatrix = initMatrix[T](1, 1, high(uint64))
    doAssert residue(scalarMatrix[0, 0]) == high(uint64) mod p
    scalarMatrix[0][0] = low(int64)
    let signedResidue = ((low(int64) mod p.int64) + p.int64).uint64 mod p
    doAssert residue(scalarMatrix[0, 0]) == signedResidue
    scalarMatrix += high(uint64)
    doAssert residue(scalarMatrix[0, 0]) == (signedResidue + high(uint64) mod p) mod p
    scalarMatrix -= high(uint64)
    scalarMatrix *= high(uint64)
    doAssert residue(scalarMatrix[0, 0]) == signedResidue * (high(uint64) mod p) mod p

    let identity = identity_matrix[T](2)
    doAssert identity == identity_matrix[T](2, one, zero)
    doAssert identity.sum.residue == 2
    var expected = identity
    for exponent in 0 .. 7:
        if exponent in [0, 1, 2, 7]:
            doAssert a.pow(exponent) == expected
            doAssert (a ** exponent) == expected
        let values = naiveProduct(expected, a)
        for i in 0 ..< 2:
            for j in 0 ..< 2:
                expected[i, j] = T.init(values[i * 2 + j].int)
    b = a
    let square = naiveProduct(a, a)
    b *= b
    checkEntries(b, square)
    doAssert a == source.toMatrix

    var st = initHashSet[Matrix[T]]()
    st.incl(a)
    st.incl(source.toMatrix)
    st.incl(a + a)
    doAssert st.len == 2
    doAssert hash(a) == hash(source.toMatrix)
    let redundant = (a + T.init(T.umod.int - 1)) + one
    doAssert redundant == a and hash(redundant) == hash(a)
    checkProduct(-a, redundant)

proc checkBoundaries[T]() =
    ## ブロックとStrassen分割の境界を低ランク行列の閉形式で検証する。
    for size in [65, 129, 257]:
        let h = size
        let w = size + 2
        let k = size - 1
        var a = initMatrix[T](h, w, T.init(0))
        var b = initMatrix[T](w, k, T.init(0))
        var inner = 0u64
        for t in 0 ..< w:
            inner += ((t mod 7 + 1) * (t mod 5 + 1)).uint64
        for i in 0 ..< h:
            for t in 0 ..< w:
                a[i, t] = (T.init((i + 1) * (t mod 7 + 1)) -
                    T.init(T.umod.int - 1)) - T.init(1)
        for t in 0 ..< w:
            for j in 0 ..< k:
                b[t, j] = T.init((t mod 5 + 1) * (j + 1))
        let c = a * b
        doAssert c.h == h and c.w == k
        for i in 0 ..< h:
            for j in 0 ..< k:
                doAssert residue(c[i, j]) ==
                    ((i + 1).uint64 * (j + 1).uint64 * inner) mod T.umod.uint64

template expectAssertion(body: untyped) =
    block:
        var caught = false
        try:
            body
        except AssertionDefect:
            caught = true
        doAssert caught

proc checkRawAndJoin[T]() =
    ## 公開値の一括変換の所有権と各桁境界の行出力を検証する。
    let p = T.umod
    var boundaries: seq[uint32]
    for value in [0u32, 9, 10, 99, 100, 999, 1000, 9999, 10000,
            99999999, 100000000]:
        if value < p: boundaries.add(value)
    boundaries.add(p - 1)
    var raw = boundaries
    for i in countdown(boundaries.high, 0): raw.add(boundaries[i])
    let saved = raw.mapIt(it)
    let a = initMatrix[T](2, boundaries.len, raw)
    doAssert raw == saved
    checkEntries(a, saved.mapIt(it.uint64))
    raw[0] = p - 1
    doAssert residue(a[0, 0]) == saved[0].uint64
    var b = initMatrix[T](2, boundaries.len, raw)
    b[0, 0] = T.init(0)
    doAssert raw[0] == p - 1
    for row in 0 ..< a.h:
        var strings: seq[string]
        for column in 0 ..< a.w:
            strings.add(system.`$`(saved[row * a.w + column].uint64))
        for separator in ["", " ", " / ", "\0x"]:
            let expected = strutils.join(strings, separator)
            doAssert a[row].join(separator) == expected
            var mutable = a
            doAssert mutable[row].join(separator) == expected
            let redundant = (a + T.init(p.int - 1)) + T.init(1)
            doAssert redundant[row].join(separator) == expected

    for width in [0, 1, 3, 7, 8, 9, 15, 16, 17, 31, 32, 33, 63, 64, 65]:
        var values = newSeq[uint32](width + 2)
        for i in 0 ..< values.len: values[i] = boundaries[i mod boundaries.len]
        let savedValues = values.mapIt(it)
        let fromSlice = initMatrix[T](1, width, values.toOpenArray(1, width))
        doAssert values == savedValues
        for j in 0 ..< width:
            doAssert residue(fromSlice[0, j]) == savedValues[j + 1].uint64
        let zeros = initMatrix[T](1, width)
        let expected = newSeq[uint64](width)
        checkEntries(zeros, expected)
        doAssert zeros == initMatrix[T](1, width, T.init(0))
        if width == 0:
            for separator in ["", " ", " / ", "\0x"]:
                doAssert fromSlice[0].join(separator) == ""
    let empty = newSeq[uint32]()
    let zeroHeight = initMatrix[T](0, 7, empty)
    let zeroWidth = initMatrix[T](4, 0, empty)
    doAssert zeroHeight.h == 0 and zeroHeight.w == 7
    doAssert zeroWidth.h == 4 and zeroWidth.w == 0
    doAssert zeroWidth[3].join(" / ") == ""
    let fromArray = initMatrix[T](1, 3, [0u32, p - 1, 0u32])
    checkEntries(fromArray, [0u64, (p - 1).uint64, 0u64])
    let fromTemporary = initMatrix[T](1, 3, @[0u32, p - 1, 0u32])
    doAssert fromTemporary == fromArray
    let fromScope = block:
        let local = @[0u32, p - 1, 0u32]
        initMatrix[T](1, 3, local)
    doAssert fromScope == fromArray
    var moveInput = @[0u32, p - 1, 0u32]
    let keptInput = moveInput.mapIt(it)
    var fromMove = initMatrix[T](1, 3, move(moveInput))
    doAssert moveInput.len == 0
    doAssert fromMove == fromArray
    fromMove[0, 1] = T.init(0)
    doAssert keptInput == @[0u32, p - 1, 0u32]
    var moveEmpty = newSeq[uint32]()
    let fromMoveEmpty = initMatrix[T](3, 0, move(moveEmpty))
    doAssert moveEmpty.len == 0
    doAssert fromMoveEmpty.h == 3 and fromMoveEmpty.w == 0
    expectAssertion:
        discard initMatrix[T](1, 2, empty)
    expectAssertion:
        discard initMatrix[T](0, 7, @[0u32])
    expectAssertion:
        discard initMatrix[T](1, 2, @[0u32, 0u32, 0u32])

proc checkWriteRows[T]() =
    ## 行の直接出力を空行と固定バッファの境界で文字列出力と比較する。
    let (output, path) = createTempFile("matrix_avx2_write_row_", ".tmp")
    defer:
        close(output)
        removeFile(path)
    var expected = ""
    let p = T.umod
    let values = [0u32, 9, 10, 9999, 10000, 99999999, 100000000, p - 1]
    for width in [0, 1, 1023, 1024, 1025, 2049]:
        var raw = newSeq[uint32](2 * width)
        for i in 0 ..< raw.len: raw[i] = values[i mod values.len] mod p
        var a = initMatrix[T](2, width, raw)
        a[0].writeRow(output)
        expected.add(a[0].join(" ") & "\n")
        let immutable = (a + T.init(p.int - 1)) + T.init(1)
        immutable[1].writeRow(output)
        expected.add(immutable[1].join(" ") & "\n")
    flushFile(output)
    setFilePos(output, 0)
    doAssert readAll(output) == expected

proc checkShapes() =
    ## 空行列の形状保存と不正な次元の拒否を確認する。
    type T = modint998244353_montgomery
    let zero = T.init(0)
    for shape in [(0, 0, 0), (0, 3, 7), (4, 0, 5), (3, 2, 0)]:
        let (h, w, k) = shape
        let a = initMatrix[T](h, w, zero)
        let b = initMatrix[T](w, k, zero)
        checkProduct(a, b)
        doAssert a.h == h and a.w == w
    let empty = identity_matrix[T](0)
    doAssert empty.h == 0 and empty.w == 0
    doAssert empty.pow(0) == empty
    doAssert residue(empty.sum) == 0
    var zeroWidth = initMatrix[T](3, 0, zero)
    doAssert zeroWidth[0].len == 0
    zeroWidth[1] = newSeq[T]()
    expectAssertion:
        discard initMatrix[T](-1, 2, zero)
    expectAssertion:
        discard initMatrix[T](2, 3, @[zero])
    expectAssertion:
        discard initMatrix(@[@[zero], @[zero, zero]])
    expectAssertion:
        discard initMatrix[T](2, 3, zero) * initMatrix[T](2, 1, zero)
    expectAssertion:
        discard initMatrix[T](2, 3, zero) + initMatrix[T](2, 1, zero)
    expectAssertion:
        var a = initMatrix[T](2, 3, zero)
        a[0] = @[zero]
    expectAssertion:
        discard initMatrix[T](2, 3, zero).pow(2)
    expectAssertion:
        discard identity_matrix[T](2).pow(-1)

proc checkDynamicModulus() =
    ## 行列の作成後にmodを変えた場合は積で誤った値を計算しない。
    modint_montgomery.setMod(998244353)
    let montgomeryMatrix = identity_matrix[modint_montgomery](2)
    modint_montgomery.setMod(1000000007)
    expectAssertion:
        discard montgomeryMatrix * montgomeryMatrix
    modint_montgomery.setMod(998244353)
    doAssert montgomeryMatrix * montgomeryMatrix == montgomeryMatrix
    modint_barrett.setMod(1000000007)
    let barrettMatrix = identity_matrix[modint_barrett](2)
    modint_barrett.setMod(998244353)
    expectAssertion:
        discard barrettMatrix * barrettMatrix
    modint_barrett.setMod(1000000007)
    doAssert barrettMatrix * barrettMatrix == barrettMatrix

checkApi[modint998244353_montgomery]()
checkApi[modint1000000007_montgomery]()
checkApi[modint998244353_barrett]()
checkApi[modint1000000007_barrett]()
checkRawAndJoin[modint998244353_montgomery]()
checkRawAndJoin[modint1000000007_montgomery]()
checkRawAndJoin[modint998244353_barrett]()
checkRawAndJoin[modint1000000007_barrett]()
checkWriteRows[modint998244353_montgomery]()
checkWriteRows[modint1000000007_montgomery]()
checkWriteRows[modint998244353_barrett]()
checkWriteRows[modint1000000007_barrett]()
checkRandom[StaticMontgomeryModint[1u32]](0)
checkRandom[StaticMontgomeryModint[3u32]](1)
checkRandom[modint998244353_montgomery](2)
checkRandom[modint1000000007_montgomery](3)
checkRandom[StaticMontgomeryModint[1073741823u32]](4)
checkRandom[StaticBarrettModint[1u32]](5)
checkRandom[StaticBarrettModint[3u32]](6)
checkRandom[modint998244353_barrett](7)
checkRandom[modint1000000007_barrett](8)
checkRandom[StaticBarrettModint[1073741823u32]](9)
for modulus in [1, 3, 998244353, 1000000007, 1073741823]:
    modint_montgomery.setMod(modulus)
    modint_barrett.setMod(modulus)
    checkRandom[modint_montgomery](modulus.int64)
    checkRandom[modint_barrett](modulus.int64 + 1)
    checkRawAndJoin[modint_montgomery]()
    checkRawAndJoin[modint_barrett]()
    checkWriteRows[modint_montgomery]()
    checkWriteRows[modint_barrett]()
modint_montgomery.setMod(998244353)
modint_barrett.setMod(1000000007)
checkApi[modint_montgomery]()
checkApi[modint_barrett]()
checkBoundaries[modint998244353_montgomery]()
checkBoundaries[modint1000000007_barrett]()
checkShapes()
checkDynamicModulus()
echo "Hello World"
