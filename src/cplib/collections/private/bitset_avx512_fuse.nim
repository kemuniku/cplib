## fuseマクロと動的ビットセット用の融合演算です。
include cplib/collections/private/bitset_avx512_fuse_shift
include cplib/collections/private/bitset_avx512_fuse_arithmetic

proc orShiftLeftAssign*(x: var BitSetAvx512, shift: int) =
    ## x |= x << shiftを一時領域なしで計算します。O(len(x)/64)。
    if shift < 0:
        raise newException(ValueError, "shift count must be non-negative")
    if shift > 0 and shift < x.size:
        fusedShiftLeft(addr x.bits[0], x.bits.len.csize_t, shift.csize_t)
        x.trim()

proc orShiftRightAssign*(x: var BitSetAvx512, shift: int) =
    ## x |= x >> shiftを一時領域なしで計算します。O(len(x)/64)。
    if shift < 0:
        raise newException(ValueError, "shift count must be non-negative")
    if shift > 0 and shift < x.size:
        fusedShiftRight(addr x.bits[0], x.bits.len.csize_t, shift.csize_t)

proc fuseData(x: BitSetAvx512): ptr uint64 {.inline.} =
    ## 融合カーネルへ渡す先頭ポインタを返します。
    if x.bits.len > 0: unsafeAddr x.bits[0] else: nil

proc fuseWords(x: BitSetAvx512): csize_t {.inline.} =
    ## 融合カーネルが処理するワード数を返します。
    x.bits.len.csize_t

proc lastBit*(x: BitSetAvx512): bool =
    ## 最上位の有効ビットを返します。空集合はfalse。O(1)。
    x.size > 0 and x[x.size - 1]

macro fuseSingleStatements(body: untyped): untyped =
    ## ビットセットの代入式を融合します。各式O(式の大きさ * ビット数/64)。
    ## x = x or (y and z)、x = x | (x << k)などを記述できます。
    ## |=、&=、^=、+=、<<=、>>=にも対応します。例: x |= y and z、dp |= dp << k。
    ## 論理式の葉と代入先が変数名なら一時集合なしでSIMD処理します。
    ## 入力3種類以下の論理式はAVX-512の真理値表命令にまとめます。
    ## +による多倍長加算と、変数の左右シフトを論理式内で融合できます。
    ## 加算はAVX-512F、非対応時はスカラー処理。シフト元が代入先なら退避領域を使います。
    ## 式全体のシフトや関数呼び出しを含むシフト量など、未対応の構文は通常の演算へ戻します。
    ## 代入先の長さが異なる場合も通常の代入へ戻します。文は記述順に実行します。
    proc unwrap(n: NimNode): NimNode =
        if n.kind == nnkPar and n.len == 1: unwrap(n[0]) else: n
    proc op(n: NimNode): string =
        if n.kind in {nnkInfix, nnkPrefix}: $n[0] else: ""
    proc normal(n: NimNode): NimNode =
        result = copyNimTree(n)
        if n.kind in {nnkLetSection, nnkVarSection}:
            for item in result:
                item[^1] = normal(item[^1])
        elif n.kind == nnkAsgn:
            result[1] = normal(n[1])
        elif n.kind == nnkPar and n.len == 1:
            result[0] = normal(n[0])
        elif n.kind in {nnkInfix, nnkPrefix} and op(n) in ["and", "or", "xor", "not", "shl", "shr", "&", "|", "^", "~", "<<", ">>", "+"]:
            let s = case op(n)
                of "and": "&"
                of "or": "|"
                of "xor": "^"
                of "not": "~"
                of "shl": "<<"
                of "shr": ">>"
                else: op(n)
            result[0] = ident(s)
            result[1] = normal(n[1])
            if n.kind == nnkInfix and s notin ["<<", ">>"]:
                result[2] = normal(n[2])
    result = newStmtList()
    let statements = if body.kind == nnkStmtList: body else: newStmtList(body)
    for original in statements:
        if original.kind in {nnkLetSection, nnkVarSection}:
            result.add(normal(original))
            continue
        if original.kind == nnkAsgn and original[0].kind == nnkBracketExpr:
            result.add(normal(original))
            continue
        if original.kind == nnkAsgn and original[1].kind == nnkCall and original[1].len == 2 and original[1][0].kind in {nnkIdent, nnkSym} and $original[1][0] == "lastBit":
            result.add(newAssignment(original[0], newCall(bindSym"lastBit", normal(original[1][1]))))
            continue
        var statement = original
        var fallback: NimNode
        if original.kind == nnkInfix and op(original) in ["|=", "&=", "^=", "+=", "<<=", ">>="]:
            fallback = newTree(nnkInfix, original[0], original[1],
                (if op(original) in ["<<=", ">>="]: original[2] else: normal(original[2])))
            # 添字などに副作用がある場合も代入先を一度だけ評価します。
            if original[1].kind notin {nnkIdent, nnkSym}:
                result.add(fallback)
                continue
            let binary = ident(op(original)[0..^2])
            statement = newAssignment(original[1], newTree(nnkInfix, binary, original[1], original[2]))
        else:
            fallback = normal(statement)
        if statement.kind != nnkAsgn:
            error("fuse expects =, |=, &=, ^=, +=, <<= or >>= assignments", statement)
        let dst = statement[0]
        let rhs = unwrap(statement[1])
        if dst.kind notin {nnkIdent, nnkSym}:
            result.add(fallback)
            continue
        if rhs.kind == nnkInfix and op(rhs) in ["shl", "shr", "<<", ">>"] and unwrap(rhs[1]) == dst:
            let fn = if op(rhs) in ["shl", "<<"]: bindSym"<<=" else: bindSym">>="
            result.add(newCall(fn, dst, rhs[2]))
            continue
        var shifted: NimNode
        if rhs.kind == nnkInfix and op(rhs) in ["or", "|"]:
            for side in 1..2:
                let a = unwrap(rhs[side])
                let b = unwrap(rhs[3-side])
                if a == dst and b.kind == nnkInfix and op(b) in ["shl", "shr", "<<", ">>"] and unwrap(b[1]) == dst:
                    shifted = b
        if shifted != nil:
            let fn = if op(shifted) in ["shl", "<<"]: bindSym"orShiftLeftAssign" else: bindSym"orShiftRightAssign"
            result.add(newCall(fn, dst, shifted[2]))
            continue
        var leaves: seq[NimNode]
        var supported = true
        var additions = 0
        proc simpleShiftAmount(n: NimNode): bool =
            # 評価回数を変えないよう、関数呼び出しなどを含む式は融合しません。
            if n.kind in {nnkIdent, nnkSym, nnkIntLit..nnkUInt64Lit}: return true
            if n.kind == nnkPar and n.len == 1: return simpleShiftAmount(n[0])
            if n.kind == nnkPrefix: return simpleShiftAmount(n[1])
            if n.kind == nnkInfix: return simpleShiftAmount(n[1]) and simpleShiftAmount(n[2])
            false
        proc collect(node: NimNode) =
            let n = unwrap(node)
            if n.kind in {nnkIdent, nnkSym}:
                for leaf in leaves:
                    if leaf == n: return
                leaves.add(n)
            elif n.kind == nnkInfix and op(n) in ["shl", "shr", "<<", ">>"] and unwrap(n[1]).kind in {nnkIdent, nnkSym} and simpleShiftAmount(n[2]):
                for leaf in leaves:
                    if leaf == n: return
                leaves.add(n)
            elif n.kind == nnkInfix and op(n) in ["and", "or", "xor", "&", "|", "^", "+"]:
                if op(n) == "+": inc additions
                collect(n[1]); collect(n[2])
            elif n.kind == nnkPrefix and op(n) in ["not", "~"]:
                collect(n[1])
            else:
                supported = false
        collect(rhs)
        if not supported or leaves.len == 0:
            result.add(fallback)
            continue
        var expressionCode = ""
        var additionIndex = 0
        proc expression(node: NimNode, width: int): string =
            let n = unwrap(node)
            for i, leaf in leaves:
                if leaf == n: return "v" & $i
            let a = expression(n[1], width)
            if n.kind == nnkPrefix:
                if width == 0: return "(~" & a & ")"
                return "_mm" & $width & "_xor_si" & $width & "(" & a & ", _mm" & $width & "_set1_epi64" & (if width == 256: "x" else: "") & "(-1))"
            let b = expression(n[2], width)
            if op(n) == "+":
                let idx = $additionIndex
                inc additionIndex
                let typ = if width == 512: "__m512i" else: "uint64_t"
                let helper = if width == 512: "cplib_fuse_add512" else: "cplib_fuse_add64"
                expressionCode.add(typ & " sum" & idx & "=" & helper & "(" & a & "," & b & ",&carry" & idx & ");\n")
                return "sum" & idx
            let operation = case op(n)
                of "and", "&": "and"
                of "or", "|": "or"
                else: "xor"
            if width == 0:
                let symbol = case operation
                    of "and": "&"
                    of "or": "|"
                    else: "^"
                return "(" & a & symbol & b & ")"
            "_mm" & $width & "_" & operation & "_si" & $width & "(" & a & "," & b & ")"
        proc truth(node: NimNode, row: int): bool =
            let n = unwrap(node)
            for i, leaf in leaves:
                if leaf == n: return (row and (1 shl (2-i))) != 0
            let a = truth(n[1], row)
            if n.kind == nnkPrefix: return not a
            let b = truth(n[2], row)
            case op(n)
            of "and", "&": a and b
            of "or", "|": a or b
            else: a xor b
        let kernel = genSym(nskProc, "bitsetFuseKernel")
        let name = "cplib_" & kernel.repr.replace("`", "")
        var code = fuseArithmeticHelpers
        proc loads(width: int): string =
            for j, leaf in leaves:
                let idx = $j
                let source = "src[" & idx & "]"
                let typ = if width == 0: "uint64_t" else: "__m" & $width & "i"
                var value: string
                if leaf.kind == nnkInfix:
                    let left = if op(leaf) in ["shl", "<<"]: "1" else: "0"
                    value = "cplib_fuse_shift" & $width & "(" & source & ",n,i,shifts[" & idx & "]," & left & ")"
                elif width == 0:
                    value = source & "[i]"
                else:
                    let castType = if width == 256: "__m256i" else: "void"
                    value = "_mm" & $width & "_loadu_si" & $width & "((const " & castType & " *)(" & source & "+i))"
                result.add(typ & " v" & idx & "=" & value & ";\n")
        for width in [0, 256, 512]:
            if width == 256 and additions > 0: continue
            let suffix = $width
            let target = if width == 512: "avx512f" else: "avx2"
            let castType = if width == 256: "__m256i" else: "void"
            code.add("__attribute__((target(\"" & target & "\"))) static void " & name & suffix & "(uint64_t *dst, uint64_t **src, size_t n, size_t *shifts) {\nsize_t i=0;\n")
            for j in 0..<additions: code.add("unsigned carry" & $j & "=0;\n")
            if width != 0:
                code.add("for (; i+" & $(width div 64) & "<=n; i+=" & $(width div 64) & ") {\n")
                code.add(loads(width))
                expressionCode = ""
                additionIndex = 0
                var value = expression(rhs, width)
                if width == 512 and leaves.len <= 3 and additions == 0:
                    var mask = 0
                    for row in 0..7:
                        if truth(rhs, row): mask = mask or (1 shl row)
                    value = "_mm512_ternarylogic_epi64(v0," & (if leaves.len >= 2: "v1" else: "v0") & "," & (if leaves.len >= 3: "v2" else: "v0") & "," & $mask & ")"
                code.add(expressionCode)
                code.add("_mm" & suffix & "_storeu_si" & suffix & "((" & castType & " *)(dst+i)," & value & ");\n}\n")
            code.add("for (;i<n;++i) {\n" & loads(0))
            expressionCode = ""
            additionIndex = 0
            let value = expression(rhs, 0)
            code.add(expressionCode & "dst[i]=" & value & ";\n}\n}\n")
        code.add("static void " & name & "(uint64_t *dst, uint64_t **src, size_t n, size_t *shifts) {\nif (__builtin_cpu_supports(\"avx512f\")) " & name & "512(dst,src,n,shifts); else " & name & (if additions > 0: "0" else: "256") & "(dst,src,n,shifts);\n}\n")
        # 関数内からの呼び出しでもカーネルはファイルスコープに配置します。
        # 宣言・定義やジェネリックの実体化による重複はガードで防ぎます。
        let declaration = newLit("\n#ifndef " & name & "_DEFINED\n#define " & name & "_DEFINED\n" & code & "#endif\n$1 $2$3")
        let cname = newLit(name)
        let pointers = genSym(nskVar, "sources")
        var values = newNimNode(nnkBracket)
        var shiftValues = newNimNode(nnkBracket)
        var checks = newStmtList()
        var aliasChecks = newStmtList()
        let snapshot = genSym(nskVar, "snapshot")
        let shifts = genSym(nskVar, "shifts")
        let first = if leaves[0].kind == nnkInfix: unwrap(leaves[0][1]) else: leaves[0]
        for j, node in leaves:
            let leaf = if node.kind == nnkInfix: unwrap(node[1]) else: node
            values.add(newCall(bindSym"fuseData", leaf))
            checks.add quote do:
                if len(`leaf`) != len(`first`):
                    raise newException(ValueError, "BitSet sizes must match")
            if node.kind == nnkInfix:
                let shift = genSym(nskLet, "shift")
                let amount = node[2]
                checks.add quote do:
                    let `shift` = int(`amount`)
                    if `shift` < 0:
                        raise newException(ValueError, "shift count must be non-negative")
                shiftValues.add(newCall(bindSym"csize_t", newCall(bindSym"min", shift, newCall(bindSym"len", first))))
                let idx = newLit(j)
                aliasChecks.add quote do:
                    if `pointers`[`idx`] == fuseData(`dst`) and len(`dst`) > 0:
                        if len(`snapshot`) == 0:
                            `snapshot` = initBitSet(len(`dst`))
                            copyMem(fuseData(`snapshot`), fuseData(`dst`), int(fuseWords(`dst`)) * sizeof(uint64))
                        `pointers`[`idx`] = fuseData(`snapshot`)
            else:
                shiftValues.add(newCall(bindSym"csize_t", newLit(0)))
        result.add quote do:
            block:
                `checks`
                if len(`dst`) != len(`first`):
                    `fallback`
                else:
                    proc `kernel`(dst: ptr uint64, src: ptr ptr uint64, n: csize_t, shifts: ptr csize_t) {.codegenDecl: `declaration`.} =
                        {.emit: [`cname`, "(", dst, ",", src, ",", n, ",", shifts, ");"].}
                    var `pointers` = `values`
                    var `shifts` = `shiftValues`
                    var `snapshot`: BitSetAvx512
                    `aliasChecks`
                    `kernel`(fuseData(`dst`), addr `pointers`[0], fuseWords(`dst`), addr `shifts`[0])
                    trim(`dst`)

include cplib/collections/private/bitset_avx512_fuse_block

macro fuse*(body: untyped): untyped =
    ## 論理演算・加算・シフトを融合します。走査はO(式の大きさ * ceil(ビット数/64))。
    ## 複数文の別名チェックは変数数vに対してO(v^2)、繰り越しの追加空間はO(式の大きさ)。
    ## 複数文の論理演算・加算・0..63の定数左シフトは一つの走査にまとめます。
    ## 内部のlet/varは中間集合を作らず、lastBitによるboolへの代入も融合できます。
    ## [0]へのtrue/falseの代入に対応します。内部のlet/varのスコープはfuse内です。
    ## 同じ長さの独立した変数が必要で、別名参照や長さの不一致は文ごとの処理へ戻します。
    ## 右シフト・可変シフトなども文ごとの処理へ戻し、対応する式はその中で融合します。
    ## 加算・複数文の非AVX-512経路は64ビット単位です。
    result = fuseBlock(body)
    if result == nil:
        result = newBlockStmt(newCall(bindSym"fuseSingleStatements", body))
