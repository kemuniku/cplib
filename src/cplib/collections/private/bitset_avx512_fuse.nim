## fuseマクロと動的ビットセット用の融合演算です。
include cplib/collections/private/bitset_avx512_fuse_shift

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

macro fuse*(body: untyped): untyped =
    ## ビットセットの代入式を融合します。各式O(式の大きさ * ビット数/64)。
    ## x = x or (y and z)、x = x | (x << k)などを記述できます。
    ## |=、&=、^=にも対応します。例: x |= y and z、dp |= dp << k。
    ## 論理式の葉と代入先が変数名なら一時集合なしでSIMD処理します。
    ## 入力3種類以下の論理式はAVX-512の真理値表命令にまとめます。
    ## 自身の左右シフトとのORも融合し、それ以外は通常の演算へ戻します。
    ## 代入先の長さが異なる場合も通常の代入へ戻します。文は記述順に実行します。
    proc unwrap(n: NimNode): NimNode =
        if n.kind == nnkPar and n.len == 1: unwrap(n[0]) else: n
    proc op(n: NimNode): string =
        if n.kind in {nnkInfix, nnkPrefix}: $n[0] else: ""
    proc normal(n: NimNode): NimNode =
        result = copyNimTree(n)
        if n.kind == nnkAsgn:
            result[1] = normal(n[1])
        elif n.kind == nnkPar and n.len == 1:
            result[0] = normal(n[0])
        elif n.kind in {nnkInfix, nnkPrefix} and op(n) in ["and", "or", "xor", "not", "shl", "shr", "&", "|", "^", "~", "<<", ">>"]:
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
        var statement = original
        var fallback: NimNode
        if original.kind == nnkInfix and op(original) in ["|=", "&=", "^="]:
            fallback = newTree(nnkInfix, original[0], original[1], normal(original[2]))
            # 添字などに副作用がある場合も代入先を一度だけ評価します。
            if original[1].kind notin {nnkIdent, nnkSym}:
                result.add(fallback)
                continue
            let binary = ident(op(original)[0..0])
            statement = newAssignment(original[1], newTree(nnkInfix, binary, original[1], original[2]))
        else:
            fallback = normal(statement)
        if statement.kind != nnkAsgn:
            error("fuse expects =, |=, &= or ^= assignments", statement)
        let dst = statement[0]
        let rhs = unwrap(statement[1])
        if dst.kind notin {nnkIdent, nnkSym}:
            result.add(fallback)
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
        proc collect(node: NimNode) =
            let n = unwrap(node)
            if n.kind in {nnkIdent, nnkSym}:
                for leaf in leaves:
                    if leaf == n: return
                leaves.add(n)
            elif n.kind == nnkInfix and op(n) in ["and", "or", "xor", "&", "|", "^"]:
                collect(n[1]); collect(n[2])
            elif n.kind == nnkPrefix and op(n) in ["not", "~"]:
                collect(n[1])
            else:
                supported = false
        collect(rhs)
        if not supported or leaves.len == 0:
            result.add(fallback)
            continue
        proc expression(node: NimNode, width: int): string =
            let n = unwrap(node)
            if n.kind in {nnkIdent, nnkSym}:
                for i, leaf in leaves:
                    if leaf == n: return "v" & $i
            let a = expression(n[1], width)
            if n.kind == nnkPrefix:
                if width == 0: return "(~" & a & ")"
                return "_mm" & $width & "_xor_si" & $width & "(" & a & ", _mm" & $width & "_set1_epi64" & (if width == 256: "x" else: "") & "(-1))"
            let b = expression(n[2], width)
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
            if n.kind in {nnkIdent, nnkSym}:
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
        var code = "#include <immintrin.h>\n#include <stdint.h>\n#include <stddef.h>\n"
        for width in [256, 512]:
            let suffix = $width
            let target = if width == 256: "avx2" else: "avx512f"
            let castType = if width == 256: "__m256i" else: "void"
            code.add("__attribute__((target(\"" & target & "\"))) static void " & name & suffix & "(uint64_t *dst, uint64_t **src, size_t n) {\nsize_t i=0;\n")
            code.add("for (; i+" & $(width div 64) & "<=n; i+=" & $(width div 64) & ") {\n")
            for j in 0..<leaves.len:
                code.add("__m" & suffix & "i v" & $j & " = _mm" & suffix & "_loadu_si" & suffix & "((const " & castType & " *)(src[" & $j & "]+i));\n")
            var value = expression(rhs, width)
            if width == 512 and leaves.len <= 3:
                var mask = 0
                for row in 0..7:
                    if truth(rhs, row): mask = mask or (1 shl row)
                value = "_mm512_ternarylogic_epi64(v0," & (if leaves.len >= 2: "v1" else: "v0") & "," & (if leaves.len >= 3: "v2" else: "v0") & "," & $mask & ")"
            code.add("_mm" & suffix & "_storeu_si" & suffix & "((" & castType & " *)(dst+i)," & value & ");\n}\nfor (;i<n;++i) {\n")
            for j in 0..<leaves.len:
                code.add("uint64_t v" & $j & " = src[" & $j & "][i];\n")
            code.add("dst[i]=" & expression(rhs, 0) & ";\n}\n}\n")
        code.add("static void " & name & "(uint64_t *dst, uint64_t **src, size_t n) {\nif (__builtin_cpu_supports(\"avx512f\")) " & name & "512(dst,src,n); else " & name & "256(dst,src,n);\n}\n")
        # 関数内からの呼び出しでもカーネルはファイルスコープに配置します。
        # 宣言・定義やジェネリックの実体化による重複はガードで防ぎます。
        let declaration = newLit("\n#ifndef " & name & "_DEFINED\n#define " & name & "_DEFINED\n" & code & "#endif\n$1 $2$3")
        let cname = newLit(name)
        let pointers = genSym(nskVar, "sources")
        var values = newNimNode(nnkBracket)
        for leaf in leaves: values.add(newCall(bindSym"fuseData", leaf))
        let first = leaves[0]
        var checks = newStmtList()
        for leaf in leaves:
            checks.add quote do:
                if len(`leaf`) != len(`first`):
                    raise newException(ValueError, "BitSet sizes must match")
        result.add quote do:
            block:
                `checks`
                if len(`dst`) != len(`first`):
                    `fallback`
                else:
                    proc `kernel`(dst: ptr uint64, src: ptr ptr uint64, n: csize_t) {.codegenDecl: `declaration`.} =
                        {.emit: [`cname`, "(", dst, ",", src, ",", n, ");"].}
                    var `pointers` = `values`
                    `kernel`(fuseData(`dst`), addr `pointers`[0], fuseWords(`dst`))
                    trim(`dst`)
