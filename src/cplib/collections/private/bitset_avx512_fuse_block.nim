## 複数代入をSSA形式に直し、繰り越しを持つ一つの走査に融合します。
type
    FuseBlockKind = enum
        fbInput, fbAnd, fbOr, fbXor, fbNot, fbAdd, fbShl, fbLow
    FuseBlockNode = object
        kind: FuseBlockKind
        a, b, input, shift: int
        seed: bool

proc fuseBlock(body: NimNode): NimNode =
    ## 同一長の論理式・加算・定数左シフトのブロックを融合し、未対応時はnilを返します。
    let statements = if body.kind == nnkStmtList: body else: newStmtList(body)
    if statements.len < 2: return nil
    var nodes: seq[FuseBlockNode]
    var names, external, outputNames, captureNames: seq[NimNode]
    var versions, outputIds, captures: seq[int]
    var local: seq[bool]
    var supported = true
    var writesLowBit = false
    proc unwrap(n: NimNode): NimNode =
        if n.kind == nnkPar and n.len == 1: unwrap(n[0]) else: n
    proc lookup(xs: seq[NimNode], n: NimNode): int =
        for i, x in xs:
            if x == n: return i
        -1
    proc addNode(kind: FuseBlockKind, a = -1, b = -1, input = -1, shift = 0, seed = false): int =
        nodes.add(FuseBlockNode(kind: kind, a: a, b: b, input: input, shift: shift, seed: seed))
        nodes.high
    proc externalId(n: NimNode): int =
        result = lookup(external, n)
        if result < 0:
            result = external.len
            external.add(n)
    proc read(n: NimNode): int =
        let idx = lookup(names, n)
        if idx >= 0: return versions[idx]
        result = addNode(fbInput, input = externalId(n))
        names.add(n); versions.add(result); local.add(false)
    proc expression(node: NimNode): int =
        let n = unwrap(node)
        if n.kind in {nnkIdent, nnkSym}: return read(n)
        if n.kind == nnkPrefix and $n[0] in ["not", "~"]:
            return addNode(fbNot, expression(n[1]))
        if n.kind == nnkInfix:
            let op = $n[0]
            if op in ["shl", "<<"]:
                let amount = unwrap(n[2])
                if amount.kind in {nnkIntLit..nnkUInt64Lit} and amount.intVal >= 0 and amount.intVal < 64:
                    let a = expression(n[1])
                    if amount.intVal == 0: return a
                    return addNode(fbShl, a, shift = amount.intVal.int)
            elif op in ["and", "&", "or", "|", "xor", "^", "+"]:
                let a = expression(n[1])
                let b = expression(n[2])
                let kind = case op
                    of "and", "&": fbAnd
                    of "or", "|": fbOr
                    of "xor", "^": fbXor
                    else: fbAdd
                return addNode(kind, a, b)
        supported = false
        -1
    proc assign(name: NimNode, id: int, declaration = false) =
        var idx = lookup(names, name)
        if idx < 0:
            idx = names.len
            names.add(name); versions.add(id); local.add(declaration)
        else:
            if declaration: supported = false
            versions[idx] = id
        if not local[idx]:
            discard externalId(name)
            let outIdx = lookup(outputNames, name)
            if outIdx < 0:
                outputNames.add(name); outputIds.add(id)
            else: outputIds[outIdx] = id
    for statement in statements:
        if not supported: return nil
        if statement.kind in {nnkLetSection, nnkVarSection}:
            if statement.len != 1 or statement[0].len != 3 or statement[0][1].kind != nnkEmpty:
                return nil
            let name = statement[0][0]
            if name.kind notin {nnkIdent, nnkSym}: return nil
            assign(name, expression(statement[0][2]), true)
            continue
        var lhs, rhs: NimNode
        if statement.kind == nnkAsgn:
            lhs = statement[0]; rhs = unwrap(statement[1])
        elif statement.kind == nnkInfix and $statement[0] in ["|=", "&=", "^=", "+=", "<<="]:
            lhs = statement[1]
            rhs = newTree(nnkInfix, ident(($statement[0])[0..^2]), lhs, statement[2])
        else: return nil
        if lhs.kind == nnkBracketExpr and lhs.len == 2 and lhs[0].kind in {nnkIdent, nnkSym}:
            if lhs[1].kind notin {nnkIntLit..nnkUInt64Lit} or lhs[1].intVal != 0 or rhs.kind notin {nnkIdent, nnkSym} or $rhs notin ["true", "false"]:
                return nil
            writesLowBit = true
            let a = read(lhs[0])
            let value = $rhs == "true"
            if nodes[a].kind == fbShl:
                assign(lhs[0], addNode(fbShl, nodes[a].a, shift = nodes[a].shift, seed = value))
            else:
                assign(lhs[0], addNode(fbLow, a, seed = value))
        elif lhs.kind in {nnkIdent, nnkSym}:
            if rhs.kind == nnkCall and rhs.len == 2 and rhs[0].kind in {nnkIdent, nnkSym} and $rhs[0] == "lastBit":
                captureNames.add(lhs); captures.add(expression(rhs[1]))
            else:
                assign(lhs, expression(rhs))
        else: return nil
    if not supported or external.len == 0 or (outputIds.len == 0 and captures.len == 0): return nil
    # 最終出力から必要な節点だけを残し、共有する中間値は一度だけ計算します。
    var needed = newSeq[bool](nodes.len)
    var uses = newSeq[int](nodes.len)
    proc visit(id: int) =
        inc uses[id]
        if needed[id]: return
        needed[id] = true
        let node = nodes[id]
        if node.a >= 0: visit(node.a)
        if node.b >= 0: visit(node.b)
    for id in outputIds: visit(id)
    for id in captures: visit(id)
    let kernel = genSym(nskProc, "bitsetFuseBlockKernel")
    let name = "cplib_" & kernel.repr.replace("`", "")
    var code = fuseArithmeticHelpers
    for width in [0, 512]:
        let typ = if width == 0: "uint64_t" else: "__m512i"
        let zero = if width == 0: "0" else: "_mm512_setzero_si512()"
        code.add((if width == 512: "__attribute__((target(\"avx512f\"))) " else: "") &
            "static void " & name & $width & "(uint64_t **data,size_t n,size_t bits,uint64_t *last) {\n")
        for j in 0..<captures.len: code.add("last[" & $j & "]=0;\n")
        code.add("if (!n) return;\n")
        for j in 0..<external.len: code.add("uint64_t *__restrict d" & $j & "=data[" & $j & "];\n")
        for id, node in nodes:
            if not needed[id]: continue
            if node.kind == fbAdd: code.add("unsigned carry" & $id & "=0;\n")
            if node.kind == fbShl:
                let init = if node.seed: "(UINT64_C(1)<<" & $(64-node.shift) & ")" else: "0"
                let value = if width == 0: init else: "_mm512_set_epi64(" & init & ",0,0,0,0,0,0,0)"
                code.add(typ & " prev" & $id & "=" & value & ";\n")
        for j in 0..<captures.len: code.add(typ & " cap" & $j & "=" & zero & ";\n")
        code.add("size_t i=0;\n")
        proc blockCode(masked: bool): string =
            var lines = ""
            var emitted = newSeq[bool](nodes.len)
            for id, node in nodes:
                if needed[id] and node.kind == fbInput:
                    let ptrExpr = "d" & $node.input & "+i"
                    let value = if width == 0: "d" & $node.input & "[i]"
                        elif masked: "_mm512_maskz_loadu_epi64(valid," & ptrExpr & ")"
                        else: "_mm512_loadu_si512((const void *)(" & ptrExpr & "))"
                    lines.add(typ & " v" & $id & "=" & value & ";\n")
                    emitted[id] = true
            proc render(id: int): string =
                result = "v" & $id
                if emitted[id]: return
                let node = nodes[id]
                var value: string
                if width == 512 and node.kind in {fbAnd, fbOr, fbXor, fbNot}:
                    var atoms: seq[int]
                    proc collect(j: int) =
                        let child = nodes[j]
                        if j != id and (uses[j] > 1 or child.kind notin {fbAnd, fbOr, fbXor, fbNot}):
                            if j notin atoms: atoms.add(j)
                        else:
                            collect(child.a)
                            if child.b >= 0: collect(child.b)
                    collect(id)
                    if atoms.len <= 3:
                        proc truth(j, row: int): bool =
                            let idx = atoms.find(j)
                            if idx >= 0: return (row and (1 shl (2-idx))) != 0
                            let a = truth(nodes[j].a, row)
                            if nodes[j].kind == fbNot: return not a
                            let b = truth(nodes[j].b, row)
                            case nodes[j].kind
                            of fbAnd: a and b
                            of fbOr: a or b
                            else: a xor b
                        var mask = 0
                        for row in 0..7:
                            if truth(id, row): mask = mask or (1 shl row)
                        var args: seq[string]
                        for atom in atoms: args.add(render(atom))
                        while args.len < 3: args.add(args[0])
                        value = "_mm512_ternarylogic_epi64(" & args.join(",") & "," & $mask & ")"
                if value.len == 0:
                    let a = render(node.a)
                    case node.kind
                    of fbNot:
                        value = if width == 0: "(~" & a & ")" else: "_mm512_xor_si512(" & a & ",_mm512_set1_epi64(-1))"
                    of fbShl:
                        let prev = "prev" & $id
                        if width == 0:
                            value = "((" & a & "<<" & $node.shift & ")|(" & prev & ">>" & $(64-node.shift) & "))"
                        else:
                            value = "_mm512_or_si512(_mm512_slli_epi64(" & a & "," & $node.shift & "),_mm512_srli_epi64(_mm512_alignr_epi64(" & a & "," & prev & ",7)," & $(64-node.shift) & "))"
                    of fbLow:
                        let op = if node.seed: "|" else: "&~"
                        if width == 0: value = "(" & a & op & "(uint64_t)(i==0))"
                        else:
                            let fn = if node.seed: "_mm512_mask_or_epi64" else: "_mm512_mask_andnot_epi64"
                            if node.seed: value = fn & "(" & a & ",i==0?1:0," & a & ",_mm512_set1_epi64(1))"
                            else: value = fn & "(" & a & ",i==0?1:0,_mm512_set1_epi64(1)," & a & ")"
                    else:
                        let b = render(node.b)
                        if node.kind == fbAdd:
                            value = (if width == 0: "cplib_fuse_add64" else: "cplib_fuse_add512") & "(" & a & "," & b & ",&carry" & $id & ")"
                        else:
                            let op = case node.kind
                                of fbAnd: "and"
                                of fbOr: "or"
                                else: "xor"
                            if width == 0:
                                value = "(" & a & (if op == "and": "&" elif op == "or": "|" else: "^") & b & ")"
                            else: value = "_mm512_" & op & "_si512(" & a & "," & b & ")"
                lines.add(typ & " " & result & "=" & value & ";\n")
                if node.kind == fbShl: lines.add("prev" & $id & "=v" & $node.a & ";\n")
                emitted[id] = true
            # 全入力と中間値を読むまで出力を上書きしません。
            for id in outputIds: discard render(id)
            for id in captures: discard render(id)
            for j, id in outputIds:
                let outIdx = lookup(external, outputNames[j])
                if width == 0: lines.add("d" & $outIdx & "[i]=v" & $id & ";\n")
                elif masked: lines.add("_mm512_mask_storeu_epi64(d" & $outIdx & "+i,valid,v" & $id & ");\n")
                else: lines.add("_mm512_storeu_si512((void *)(d" & $outIdx & "+i),v" & $id & ");\n")
            for j, id in captures: lines.add("cap" & $j & "=v" & $id & ";\n")
            lines
        if width == 512:
            code.add("for (;i+8<=n;i+=8) {\n" & blockCode(false) & "}\n")
            code.add("if (i<n) { __mmask8 valid=(__mmask8)((1u<<(n-i))-1);\n" & blockCode(true) & "}\n")
            if captures.len > 0:
                code.add("uint64_t maskWords[8]={0}; maskWords[((bits-1)/64)&7]=UINT64_C(1)<<((bits-1)&63);\n")
                code.add("__m512i mask=_mm512_loadu_si512((const void *)maskWords);\n")
            for j in 0..<captures.len:
                code.add("last[" & $j & "]=_mm512_test_epi64_mask(cap" & $j & ",mask)!=0;\n")
        else:
            code.add("for (;i<n;++i) {\n" & blockCode(false) & "}\n")
            for j in 0..<captures.len:
                code.add("last[" & $j & "]=(cap" & $j & ">>((bits-1)&63))&1;\n")
        code.add("}\n")
    code.add("static void " & name & "(uint64_t **data,size_t n,size_t bits,uint64_t *last) {\n")
    code.add("if (__builtin_cpu_supports(\"avx512f\")) " & name & "512(data,n,bits,last); else " & name & "0(data,n,bits,last);\n}\n")
    let declaration = newLit("\n#ifndef " & name & "_DEFINED\n#define " & name & "_DEFINED\n" & code & "#endif\n$1 $2$3")
    let cname = newLit(name)
    let pointers = genSym(nskVar, "pointers")
    let last = genSym(nskVar, "last")
    var values = newNimNode(nnkBracket)
    let first = external[0]
    var conditions: NimNode = newLit(true)
    for j, leaf in external:
        values.add(newCall(bindSym"fuseData", leaf))
        let same = quote do: len(`leaf`) == len(`first`)
        conditions = newTree(nnkInfix, ident"and", conditions, same)
        for i in 0..<j:
            let a = newLit(i); let b = newLit(j)
            let independent = quote do: len(`first`) == 0 or `pointers`[`a`] != `pointers`[`b`]
            conditions = newTree(nnkInfix, ident"and", conditions, independent)
    if writesLowBit:
        let nonempty = quote do: len(`first`) > 0
        conditions = newTree(nnkInfix, ident"and", conditions, nonempty)
    var finish = newStmtList()
    for leaf in outputNames:
        finish.add(newCall(bindSym"trim", leaf))
    for j, leaf in captureNames:
        let idx = newLit(j)
        finish.add quote do: `leaf` = `last`[`idx`] != 0
    let captureCount = newLit(max(1, captures.len))
    let fallback = newCall(bindSym"fuseSingleStatements", body)
    result = quote do:
        block:
            var `pointers` = `values`
            if `conditions`:
                proc `kernel`(data: ptr ptr uint64, n, bits: csize_t, last: ptr uint64) {.codegenDecl: `declaration`.} =
                    {.emit: [`cname`, "(", data, ",", n, ",", bits, ",", last, ");"].}
                var `last`: array[`captureCount`, uint64]
                `kernel`(addr `pointers`[0], fuseWords(`first`), csize_t(len(`first`)), addr `last`[0])
                `finish`
            else:
                `fallback`
