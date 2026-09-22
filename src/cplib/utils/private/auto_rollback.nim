when not declared CPLIB_UTILS_PRIVATE_AUTO_ROLLBACK:
    const CPLIB_UTILS_PRIVATE_AUTO_ROLLBACK* = 1
    import macros, bitops
    import cplib/utils/private/temporary_rollback_log

    type AutoRollbackLog = seq[proc() {.closure.}]

    proc remember[T](history: var AutoRollbackLog, location: ptr T) =
        ## 安定したアドレスにある値の復元処理を記録する。時間・領域は値のサイズに比例する。
        let previous = location[]
        history.add(proc() = location[] = previous)

    proc restore(history: var AutoRollbackLog, position: int) =
        ## 指定位置以降の変更を逆順に復元する。復元する値の合計サイズに比例する時間。
        while history.len > position:
            let undo = history.pop()
            undo()

    proc swapLocations[T](left, right: ptr T) =
        ## アドレスを一度ずつ評価した値を交換する。固定長配列にも対応する。
        let previous = left[]
        left[] = right[]
        right[] = previous

    macro discardRollbackResult(body: typed): untyped =
        ## スコープ末尾の戻り値だけを捨て、returnやbreakの後に文を挿入しない。
        if body.getTypeInst.typeKind in {ntyVoid, ntyNone}:
            body
        else:
            newTree(nnkDiscardStmt, body)

    template autoRollbackOriginal(target: untyped) {.pragma.}

    proc originalUpdate(symbol: NimNode): NimNode {.compileTime.} =
        ## 既に自動変換された同名の関数から元の更新関数を取得する。
        if symbol.kind in {nnkClosedSymChoice, nnkOpenSymChoice}:
            for candidate in symbol:
                let original = originalUpdate(candidate)
                if result.isNil: result = original
                elif result != original:
                    error("自動rollbackの対象関数を一意に特定できません。別名の関数で包んで指定してください", symbol)
            return
        result = symbol
        while result.kind == nnkSym and result.symKind in {nskProc, nskFunc}:
            let impl = result.getImpl
            var original = result
            for pragma in impl[4]:
                if pragma.kind in {nnkExprColonExpr, nnkCall} and
                        pragma[0] == bindSym"autoRollbackOriginal":
                    original = pragma[1]
            if original == result: break
            result = original

    proc temporaryBegin() =
        ## 型検査時に一時実行ブロックの開始位置を残す。変換後のコードには残らない。
        discard

    proc temporaryBoundary(n: NimNode): bool {.compileTime.} =
        ## 入れ子のTemporaryを型検査用の目印から識別する。
        n.kind in {nnkBlockStmt, nnkBlockExpr} and
            n[1].kind in {nnkStmtList, nnkStmtListExpr} and n[1].len >= 2 and
            n[1][0].kind == nnkCall and n[1][0][0] == bindSym"temporaryBegin"

    proc prepareTemporary*(body: NimNode): NimNode {.compileTime.} =
        ## 入れ子のTemporaryを目印付きのブロックへ置換し、型検査後にまとめて変換できるようにする。
        if body.kind in {nnkCall, nnkCommand} and body.len == 2 and body[0].eqIdent("Temporary"):
            return newTree(nnkBlockStmt, newEmptyNode(), newStmtList(
                newCall(bindSym"temporaryBegin"), prepareTemporary(body[1])))
        result = body.copyNimNode
        for child in body: result.add(prepareTemporary(child))

    type AutoRollbackCode* = tuple[declarations, transformed: NimNode]

    proc buildAutoRollback*(target, history: NimNode, diagnosticName: string,
            blockMode: bool = false): AutoRollbackCode {.compileTime.} =
        ## 更新関数またはブロックを変換し、必要な関数定義と変換結果を返す。
        type Replacement = tuple[source, target: NimNode]
        type FunctionVersion = tuple[source, target: NimNode, readOnly, localArgs: seq[bool]]
        var functions: seq[FunctionVersion]
        var callPath: seq[tuple[symbol, origin: NimNode]]
        var forwards = newStmtList()
        var definitions = newStmtList()
        var indexDeclarations = newStmtList()
        var indexCaches: seq[tuple[container, name: NimNode, selector: string]]
        let historyType = if blockMode: bindSym"TemporaryRollbackLog" else: bindSym"AutoRollbackLog"

        proc sourcePosition(n: NimNode): string =
            ## 元のソース位置をファイル名と1始まりの行・列で表す。
            let position = n.lineInfoObj
            position.filename & ":" & $position.line & ":" & $(position.column + 1)

        proc unsupported(n: NimNode, detail: string) =
            ## 原因・対象の式・定義位置・呼び出し経路をまとめて報告する。
            var message = diagnosticName & ": " & detail
            message.add("\n  対象: " & n.repr)
            message.add("\n  対象の位置: " & sourcePosition(n))
            if callPath.len > 0:
                message.add("\n  変換中の関数: " & callPath[^1].symbol.strVal)
                message.add("\n  関数の定義: " & sourcePosition(callPath[^1].symbol.getImpl))
                message.add("\n  呼び出し経路:")
                for i, frame in callPath:
                    if i == 0:
                        message.add("\n    " & frame.symbol.strVal & " (" & sourcePosition(frame.symbol.getImpl) & ")")
                    else:
                        message.add("\n    -> " & frame.symbol.strVal & " (" & sourcePosition(frame.origin) & ")")
                        message.add("\n       " & frame.origin.repr)
            let origin = if callPath.len > 1: callPath[1].origin else: n
            error(message, origin)

        proc isScalar(t: NimNode): bool =
            ## 履歴に安全に値を保持できる組み込みの型か判定する。
            t.typeKind in {ntyBool, ntyChar, ntyEnum, ntyInt, ntyInt8, ntyInt16,
                ntyInt32, ntyInt64, ntyUInt, ntyUInt8, ntyUInt16, ntyUInt32,
                ntyUInt64, ntyFloat, ntyFloat32, ntyFloat64, ntyRange}

        proc concreteKind(t: NimNode): NimTypeKind =
            ## ジェネリック型も実体の型種別で判定する。
            if t.typeKind != ntyGenericInst: return t.typeKind
            let impl = t.getTypeImpl
            case impl.kind
            of nnkObjectTy: ntyObject
            of nnkRefTy: ntyRef
            of nnkTupleTy, nnkTupleConstr: ntyTuple
            else: impl.typeKind

        proc isValue(t: NimNode): bool =
            ## 参照を含まないタプル・固定長配列は要素も値型なら保存できる。
            if isScalar(t): return true
            let impl = t.getTypeImpl
            case impl.kind
            of nnkTupleTy:
                for field in impl:
                    if field.kind != nnkIdentDefs or not isValue(field[^2]): return false
                return true
            of nnkTupleConstr:
                for field in impl:
                    if not isValue(field): return false
                return true
            of nnkBracketExpr:
                return impl[0].eqIdent("array") and isValue(impl[^1])
            else:
                return false

        proc lookup(n: NimNode, replacements: seq[Replacement]): NimNode =
            ## 元のシンボルに対応する新しいシンボルを返す。
            for item in replacements:
                if n == item.source: return item.target
            n

        proc magicOf(symbol: NimNode): string =
            ## コンパイラ組み込み操作の識別名を取得する。
            let impl = symbol.getImpl
            if impl.kind notin {nnkProcDef, nnkFuncDef}: return ""
            for pragma in impl[4]:
                if pragma.kind == nnkExprColonExpr and pragma[0].eqIdent("magic"):
                    return pragma[1].strVal

        proc staticCallee(n: NimNode): NimNode =
            ## 関数のタプルリテラルを定数添字で選ぶ呼び出しを静的に解決する。
            if n.kind == nnkBracketExpr and n.len == 2 and n[1].kind in {nnkIntLit..nnkUInt64Lit}:
                let values = staticCallee(n[0])
                let index = n[1].intVal
                if values.kind in {nnkTupleConstr, nnkPar, nnkBracket} and
                        index >= 0 and index < values.len:
                    for value in values:
                        if value.kind != nnkSym or value.symKind notin {nskProc, nskFunc}: return n
                    return staticCallee(values[index.int])
            n

        proc containsVariant(n: NimNode): bool =
            ## フィールドの生存期間が切り替わるvariant objectか判定する。
            if n.kind == nnkRecCase: return true
            if n.kind == nnkIdentDefs: return false
            if n.kind == nnkBracketExpr and n.typeKind == ntyGenericInst:
                return containsVariant(n.getTypeImpl)
            if n.kind in {nnkSym, nnkRefTy, nnkVarTy}:
                let t = if n.kind == nnkSym: n.getTypeImpl else: n[0].getTypeImpl
                if t == n: return false
                return containsVariant(t)
            for child in n:
                if containsVariant(child): return true

        proc convertFunction(symbol: NimNode, readOnly: seq[bool], origin: NimNode,
            localArgs: seq[bool] = @[]): NimNode
        proc rewriteBody(input: NimNode, logParam: NimNode,
                initialReplacements: seq[Replacement], initialLocals, readOnlyParams: seq[NimNode],
                functionBody: bool): NimNode

        proc convertFunction(symbol: NimNode, readOnly: seq[bool], origin: NimNode,
            localArgs: seq[bool] = @[]): NimNode =
            ## 関数と呼び出し先を履歴引数付きの関数に複製する。再帰呼び出しにも対応する。
            let symbol = originalUpdate(symbol)
            if symbol.kind != nnkSym or symbol.symKind notin {nskProc, nskFunc}:
                unsupported(symbol, "静的に特定できるprocまたはfuncが必要です")
            for item in functions:
                if item.source == symbol and item.readOnly == readOnly and
                        item.localArgs == localArgs: return item.target
            callPath.add((symbol, origin))
            let impl = symbol.getImpl
            if impl.kind notin {nnkProcDef, nnkFuncDef} or impl[6].kind == nnkEmpty:
                unsupported(symbol, "本体を取得できない関数は変換できません")
            for pragma in impl[4]:
                if not pragma.eqIdent("inline") and not pragma.eqIdent("noinline") and not pragma.eqIdent("discardable") and
                        not pragma.eqIdent("noSideEffect") and not pragma.eqIdent("gensym") and
                        not pragma.eqIdent("systemRaisesDefect"):
                    unsupported(pragma, "未対応の関数pragmaです")
            let signature = symbol.getTypeInst[0]
            if signature[0].kind != nnkEmpty and not isValue(signature[0]):
                unsupported(symbol, "関数「" & symbol.strVal & "」の戻り値型「" &
                    signature[0].repr & "」は未対応です。戻り値は数値・それらのタプル・固定長配列に限ります")
            let generated = genSym(nskProc, symbol.strVal & "WithRollback")
            functions.add((symbol, generated, readOnly, localArgs))
            let logParam = genSym(nskParam, "history")
            var replacements: seq[Replacement]
            var locals: seq[NimNode]
            var readOnlyParams: seq[NimNode]
            var params = newTree(nnkFormalParams, signature[0].copyNimTree)
            params.add(newIdentDefs(logParam, newTree(nnkVarTy, historyType)))
            var originalParams: seq[NimNode]
            for i in 1..<impl[3].len:
                for j in 0..<impl[3][i].len - 2: originalParams.add(impl[3][i][j])
            var parameterIndex = 0
            for i in 1..<signature.len:
                let formal = signature[i]
                let parameterType = formal[^2]
                if parameterType.kind != nnkVarTy and not isScalar(parameterType) and
                        concreteKind(parameterType) notin {ntyRef, ntySequence, ntyString,
                            ntyObject, ntyTuple, ntyArray}:
                    let parameter = originalParams[parameterIndex]
                    unsupported(parameter, "関数「" & symbol.strVal & "」の第" &
                        $(parameterIndex + 1) & "引数「" & parameter.strVal & "」の型「" &
                        parameterType.repr & "」は未対応です")
                for j in 0..<formal.len - 2:
                    let old = originalParams[parameterIndex]
                    if readOnly[parameterIndex] or (parameterType.kind != nnkVarTy and
                            concreteKind(parameterType) in {ntyObject, ntyTuple, ntyArray}):
                        readOnlyParams.add(old)
                        readOnlyParams.add(formal[j])
                    let localArg = parameterIndex < localArgs.len and localArgs[parameterIndex]
                    inc parameterIndex
                    let fresh = genSym(nskParam, old.strVal)
                    replacements.add((old, fresh))
                    replacements.add((formal[j], fresh))
                    params.add(newIdentDefs(fresh, formal[^2].copyNimTree))
                    if formal[^2].kind != nnkVarTy or localArg:
                        locals.add(old)
                        locals.add(formal[j])

            let body = rewriteBody(impl[6], logParam, replacements, locals, readOnlyParams, true)
            var pragmas = newNimNode(nnkPragma)
            for pragma in impl[4]:
                if pragma.eqIdent("discardable"): pragmas.add(ident"discardable")
            let definition = newProc(generated, [newEmptyNode()], body, pragmas = pragmas)
            definition[3] = params
            var forward = definition.copyNimTree
            forward[6] = newEmptyNode()
            forwards.add(forward)
            definitions.add(definition)
            discard callPath.pop()
            result = generated

        proc rewriteBody(input: NimNode, logParam: NimNode,
                initialReplacements: seq[Replacement], initialLocals, readOnlyParams: seq[NimNode],
                functionBody: bool): NimNode =
            ## 関数または一時実行ブロックの本体を検査し、変更履歴を記録する形へ変換する。
            var replacements = initialReplacements
            var locals = initialLocals
            proc collect(n: NimNode) =
                ## ローカル変数を識別して、複製先の名前を割り当てる。
                if temporaryBoundary(n) or n.kind == nnkConstSection: return
                if n.kind in {nnkProcDef, nnkFuncDef, nnkIteratorDef, nnkLambda,
                        nnkTemplateDef, nnkMacroDef, nnkDefer, nnkTryStmt}:
                    unsupported(n, "関数内の関数定義・defer・例外処理は未対応です")
                if functionBody and n.kind == nnkSym and n.symKind == nskResult:
                    replacements.add((n, ident"result"))
                    locals.add(n)
                if n.kind in {nnkVarSection, nnkLetSection}:
                    for declaration in n:
                        if declaration.kind notin {nnkIdentDefs, nnkVarTuple}:
                            unsupported(declaration, "未対応の変数宣言です")
                        for i in 0..<declaration.len - 2:
                            let old = declaration[i]
                            if not isValue(old.getTypeInst):
                                unsupported(old, "ローカル変数「" & old.strVal & "」の型「" &
                                    old.getTypeInst.repr & "」は未対応です。数値・それらのタプル・固定長配列に限ります")
                            let kind = if n.kind == nnkVarSection: nskVar else: nskLet
                            replacements.add((old, genSym(kind, old.strVal)))
                            locals.add(old)
                if n.kind == nnkForStmt:
                    if n.len != 3 or n[0].kind != nnkSym:
                        unsupported(n, "forは単一の変数による整数区間の走査に限ります")
                    replacements.add((n[0], genSym(nskForVar, n[0].strVal)))
                    locals.add(n[0])
                for child in n: collect(child)
            collect(input)

            proc fromReadOnly(n: NimNode): bool =
                ## 値渡しの複合型を起点とする参照か判定する。添字の計算に使う値は含めない。
                if n.kind == nnkSym:
                    for parameter in readOnlyParams:
                        if n == parameter: return true
                    return false
                if n.kind in {nnkDotExpr, nnkBracketExpr, nnkCheckedFieldExpr,
                        nnkHiddenAddr, nnkHiddenDeref}:
                    return fromReadOnly(n[0])
                if n.kind in {nnkHiddenStdConv, nnkHiddenSubConv, nnkConv}:
                    return fromReadOnly(n[^1])
                for child in n:
                    if fromReadOnly(child): return true

            proc external(location: NimNode): bool =
                ## 書き込み先が変換対象関数の呼び出し後も生存するか判定する。
                if fromReadOnly(location):
                    unsupported(location, "値渡しの複合型とその参照先は読み取り専用です")
                if location.kind in {nnkHiddenAddr, nnkHiddenDeref}:
                    if location.kind == nnkHiddenDeref and concreteKind(location[0].getTypeInst) == ntyPtr:
                        unsupported(location, "ポインタ経由の書き込みは未対応です")
                    if location.kind == nnkHiddenDeref and concreteKind(location[0].getTypeInst) == ntyRef:
                        return true
                    return external(location[0])
                if location.kind == nnkCheckedFieldExpr:
                    unsupported(location, "variant objectへの書き込みは未対応です")
                if location.kind == nnkDotExpr:
                    if containsVariant(location[0].getTypeInst):
                        unsupported(location, "variant objectへの書き込みは未対応です")
                    return external(location[0])
                if location.kind == nnkBracketExpr:
                    if concreteKind(location[0].getTypeInst) notin {ntyArray, ntySequence, ntyTuple}:
                        unsupported(location, "要素への書き込みはarray・seq・tupleに限ります")
                    return external(location[0])
                if location.kind == nnkSym:
                    for local in locals:
                        if location == local:
                            return concreteKind(location.getTypeInst) == ntyRef
                    return true
                unsupported(location, "書き込み先の寿命を確認できません")

            proc rewrite(n: NimNode): NimNode

            proc stableContainer(n: NimNode): bool =
                ## 添字以外を再参照しても副作用のない配列の場所か判定する。
                case n.kind
                of nnkSym: true
                of nnkDotExpr, nnkHiddenDeref, nnkHiddenAddr: stableContainer(n[0])
                else: false

            proc recordChange(location, address: NimNode): NimNode =
                ## 静的に識別できる配列要素には、呼び出し間で再利用する添字判定領域を用意する。
                var target = location
                while target.kind in {nnkHiddenAddr, nnkHiddenDeref}: target = target[0]
                if not blockMode or target.kind != nnkBracketExpr or target.len != 2 or
                        concreteKind(target[0].getTypeInst) notin {ntyArray, ntySequence} or
                        not stableContainer(target[0]):
                    return newCall(bindSym"remember", logParam, address)
                var source = target[0]
                while source.kind in {nnkHiddenAddr, nnkHiddenDeref}: source = source[0]
                let selector = if source.kind == nnkDotExpr: "." & source[1].strVal
                    elif source.kind == nnkSym and source.symKind != nskParam: source.repr
                    else: ""
                var cache: NimNode
                for item in indexCaches:
                    if sameType(item.container, target[0]) and item.selector == selector:
                        cache = item.name
                        break
                if cache.isNil:
                    cache = genSym(nskProc, "temporaryIndexCache")
                    let storage = genSym(nskVar, "indexCacheStorage")
                    indexCaches.add((target[0], cache, selector))
                    # モジュール直下のループ内でも再初期化されないよう、保持領域を関数内に置く。
                    indexDeclarations.add quote do:
                        proc `cache`(): ptr TemporaryIndexCache {.inline.} =
                            var `storage` {.global, threadvar.}: TemporaryIndexCache
                            addr `storage`
                let container = rewrite(target[0])
                let count = genSym(nskLet, "temporaryArrayLength")
                let cacheValue = newTree(nnkDerefExpr, newCall(cache))
                result = quote do:
                    block:
                        let `count` = len(`container`)
                        if `count` > 0:
                            rememberIndexed(`logParam`, `address`,
                                unsafeAddr `container`[low(`container`)], `count`, `cacheValue`)
                        else:
                            remember(`logParam`, `address`)

            proc mutate(n: NimNode, positions: seq[int]): NimNode =
                ## 変更先を一度だけ評価し、外部の値のみ変更前に記録する。
                result = newStmtList()
                var operation = newCall(n[0])
                let swapping = magicOf(n[0]) == "Swap"
                if swapping: operation = newCall(bindSym"swapLocations")
                for i in 1..<n.len:
                    if i in positions:
                        let location = n[i]
                        if not isValue(location.getTypeInst):
                            unsupported(location, "書き込み先は数値・それらのタプル・固定長配列に限ります")
                        let address = genSym(nskLet, "location")
                        result.add(newLetStmt(address, newTree(nnkAddr, rewrite(location))))
                        if external(location):
                            result.add(recordChange(location, address))
                        operation.add(if swapping: address else: newTree(nnkDerefExpr, address))
                    else:
                        operation.add(rewrite(n[i]))
                result.add(operation)
                result = newTree(nnkBlockStmt, newEmptyNode(), result)

            proc rewrite(n: NimNode): NimNode =
                ## 構文を検査しながら、代入と関数呼び出しを変換する。
                if n.kind in {nnkCall, nnkCommand, nnkInfix, nnkPrefix}:
                    let callee = staticCallee(n[0])
                    if callee != n[0]:
                        let call = n.copyNimTree
                        call[0] = callee
                        return rewrite(call)
                if temporaryBoundary(n):
                    if n.kind == nnkBlockExpr and not isValue(n.getTypeInst):
                        unsupported(n, "Temporaryの結果は数値・それらのタプル・固定長配列に限ります")
                    var inner = newStmtList()
                    for i in 1..<n[1].len: inner.add(n[1][i])
                    let position = genSym(nskLet, "temporaryPosition")
                    let converted = rewriteBody(inner, logParam, replacements, @[], readOnlyParams, false)
                    return quote do:
                        let `position` = beginTemporary(`logParam`)
                        try:
                            `converted`
                        finally:
                            endTemporary(`logParam`, `position`)
                case n.kind
                of nnkObjConstr:
                    if concreteKind(n.getTypeInst) != ntyObject:
                        unsupported(n, "参照の生成は変更先の寿命を保証できないため未対応です")
                    result = newNimNode(n.kind, n)
                    for child in n: result.add(rewrite(child))
                    return
                of nnkConstSection, nnkBindStmt, nnkMixinStmt:
                    return newEmptyNode()
                of nnkPragmaBlock:
                    for pragma in n[0]:
                        if pragma.kind != nnkExprColonExpr or not pragma[0].eqIdent("line"):
                            unsupported(pragma, "未対応のブロックpragmaです")
                    return newTree(nnkPragmaBlock, n[0].copyNimTree, rewrite(n[1]))
                of nnkSym:
                    return lookup(n, replacements)
                of nnkHiddenAddr, nnkHiddenDeref:
                    return rewrite(n[0])
                of nnkHiddenStdConv, nnkHiddenSubConv:
                    if n.getTypeInst.typeKind in {ntyOpenArray, ntyVarargs}:
                        unsupported(n, "openArray・varargsへの変換は未対応です")
                    return rewrite(n[^1])
                of nnkReturnStmt:
                    if n.len == 1 and n[0].kind in {nnkAsgn, nnkFastAsgn}:
                        if not functionBody:
                            let value = genSym(nskLet, "returnValue")
                            let expression = rewrite(n[0][1])
                            return quote do:
                                block:
                                    let `value` = `expression`
                                    restore(`logParam`, 0)
                                    return `value`
                        return newTree(nnkReturnStmt, rewrite(n[0][1]))
                    if not functionBody:
                        let returnValue = genSym(nskLet, "returnValue")
                        let currentResult = ident"result"
                        return quote do:
                            when declared(`currentResult`):
                                let `returnValue` = `currentResult`
                                restore(`logParam`, 0)
                                return `returnValue`
                            else:
                                restore(`logParam`, 0)
                                return
                    result = newNimNode(n.kind, n)
                    for child in n: result.add(rewrite(child))
                    return
                of nnkAsgn, nnkFastAsgn:
                    if not isValue(n[0].getTypeInst):
                        unsupported(n, "参照・コンテナ・object全体の代入は未対応です")
                    let left = rewrite(n[0])
                    let right = rewrite(n[1])
                    if not external(n[0]): return newAssignment(left, right)
                    let address = genSym(nskLet, "location")
                    let value = genSym(nskLet, "value")
                    let record = recordChange(n[0], address)
                    return quote do:
                        block:
                            let `address` = addr `left`
                            let `value` = `right`
                            `record`
                            `address`[] = `value`
                of nnkCall, nnkCommand, nnkInfix, nnkPrefix:
                    if n[0].kind != nnkSym or n[0].symKind notin {nskProc, nskFunc}:
                        unsupported(n, "動的な関数呼び出しは未対応です")
                    if n[0] == bindSym"failedAssertImpl" or
                            (n[0].owner == (bindSym"countTrailingZeroBits").owner and
                            n[0].eqIdent("countTrailingZeroBits")):
                        result = newCall(n[0])
                        for i in 1..<n.len: result.add(rewrite(n[i]))
                        return
                    let magic = magicOf(n[0])
                    if magic in ["Inc", "Dec"]: return mutate(n, @[1])
                    if magic == "Swap": return mutate(n, @[1, 2])
                    if magic.len > 0:
                        if magic notin ["AddI", "SubI", "MulI", "DivI", "ModI", "AddU", "SubU",
                                "MulU", "DivU", "ModU", "AddF64", "SubF64", "MulF64", "DivF64",
                                "EqI", "LeI", "LtI", "EqF64", "LeF64", "LtF64", "LeU", "LtU",
                                "EqEnum", "LeEnum", "LtEnum", "EqCh", "LeCh", "LtCh", "EqB", "LeB", "LtB",
                                "Not", "And", "Or", "Xor", "BitandI", "BitorI", "BitxorI", "BitnotI",
                                "ShlI", "ShrI", "AshrI", "UnaryMinusI", "UnaryMinusI64", "UnaryMinusF64",
                                "UnaryPlusI", "AbsI", "AbsF64", "MinI", "MaxI", "MinF64", "MaxF64",
                                "DotDot", "LengthSeq", "LengthArray", "LengthStr", "Ord", "Chr", "Succ", "Pred"]:
                            unsupported(n, "未対応の組み込み操作です: " & magic)
                        result = newNimNode(n.kind, n)
                        result.add(n[0])
                        for i in 1..<n.len: result.add(rewrite(n[i]))
                        return
                    let formalParams = n[0].getTypeInst[0]
                    var argumentReadOnly: seq[bool]
                    var localArgs: seq[bool]
                    for i in 1..<n.len:
                        let localArg = formalParams[i][^2].kind == nnkVarTy and not external(n[i])
                        if localArg and not isValue(formalParams[i][^2][0]):
                            unsupported(n[i], "ローカル変数のvar引数は数値・それらのタプル・固定長配列に限ります")
                        localArgs.add(localArg)
                        argumentReadOnly.add(not isScalar(formalParams[i][^2]) and fromReadOnly(n[i]))
                    result = newCall(convertFunction(n[0], argumentReadOnly, n, localArgs), logParam)
                    for i in 1..<n.len: result.add(rewrite(n[i]))
                    return
                of nnkForStmt:
                    let iter = n[^2]
                    if iter.kind notin {nnkInfix, nnkCall} or iter[0].kind != nnkSym or
                            iter[0].owner.strVal != "system" or
                            iter[0].strVal notin ["..<", "..", "countup", "countdown"]:
                        unsupported(iter, "forはsystemの整数区間イテレータに限ります")
                    var convertedIter = newNimNode(iter.kind, iter)
                    convertedIter.add(iter[0])
                    for i in 1..<iter.len: convertedIter.add(rewrite(iter[i]))
                    return newTree(nnkForStmt, lookup(n[0], replacements), convertedIter, rewrite(n[^1]))
                of nnkVarSection, nnkLetSection:
                    result = newNimNode(n.kind, n)
                    for declaration in n:
                        var converted = newNimNode(declaration.kind)
                        for i in 0..<declaration.len - 2:
                            converted.add(lookup(declaration[i], replacements))
                        converted.add(if declaration.kind == nnkVarTuple: newEmptyNode()
                            else: declaration[0].getTypeInst)
                        converted.add(rewrite(declaration[^1]))
                        result.add(converted)
                    return
                of nnkConv:
                    if not isScalar(n.getTypeInst): unsupported(n, "値以外への型変換は未対応です")
                    return newCall(n.getTypeInst, rewrite(n[^1]))
                of nnkEmpty, nnkIdent, nnkCommentStmt, nnkCharLit..nnkNilLit,
                        nnkStmtList, nnkStmtListExpr, nnkIfStmt, nnkIfExpr, nnkElifBranch,
                        nnkElifExpr, nnkElse, nnkElseExpr, nnkWhileStmt, nnkBlockStmt,
                        nnkBlockExpr, nnkBreakStmt, nnkContinueStmt,
                        nnkDiscardStmt, nnkRaiseStmt, nnkCaseStmt, nnkOfBranch, nnkPar, nnkDotExpr,
                        nnkBracketExpr, nnkCheckedFieldExpr, nnkTupleConstr, nnkBracket, nnkExprColonExpr:
                    discard
                else:
                    unsupported(n, "未対応の構文です: " & $n.kind)
                if n.len == 0: return n.copyNimTree
                result = newNimNode(n.kind, n)
                for child in n: result.add(rewrite(child))

            result = rewrite(input)

        if blockMode:
            if target.getTypeInst.typeKind notin {ntyVoid, ntyNone, ntyStmt} and not isValue(target.getTypeInst):
                unsupported(target, "Temporaryの結果は数値・それらのタプル・固定長配列に限ります")
            result.transformed = rewriteBody(target, history, @[], @[], @[], false)
        else:
            let signature = target.getTypeInst[0]
            result.transformed = convertFunction(target, newSeq[bool](signature.len - 1), target)
        result.declarations = newStmtList(indexDeclarations, forwards, definitions)

    macro runAutoRollbackImpl*(solver, apply, answer: typed, runner: untyped): untyped =
        ## 共通の自動変換を用い、各applyを1回ずつ取り消せる実行処理を生成する。
        let history = genSym(nskVar, "history")
        let checkpoints = genSym(nskVar, "checkpoints")
        let code = buildAutoRollback(apply, history, "runAutoRollback")
        let declarations = code.declarations
        let signature = apply.getTypeInst[0]
        let transformed = code.transformed
        var wrapper = newProc(genSym(nskProc, "applyWithRollback"), [newEmptyNode()])
        var call = newCall(transformed, history)
        for i in 1..<signature.len:
            let argument = genSym(nskParam, "argument" & $i)
            wrapper[3].add(newIdentDefs(argument, signature[i][^2]))
            call.add(argument)
        wrapper[6] = quote do:
            `checkpoints`.add(`history`.len)
            `call`
        let callback = wrapper[0]
        let undo = genSym(nskProc, "rollback")
        let execute = newCall(runner, solver, callback, undo, answer)
        result = quote do:
            block:
                var `history`: AutoRollbackLog
                var `checkpoints`: seq[int]
                `declarations`
                `wrapper`
                proc `undo`() =
                    restore(`history`, `checkpoints`.pop())
                try:
                    `execute`
                finally:
                    restore(`history`, 0)

    macro withAutoRollbackImpl*(update: typed, body: untyped): untyped =
        ## 更新関数を同名で利用できるスコープとsnapshot・rollbackを生成する。
        let original = originalUpdate(update)
        let history = genSym(nskVar, "history")
        let code = buildAutoRollback(original, history, "withAutoRollback")
        let declarations = code.declarations
        let signature = original.getTypeInst[0]
        let name = ident(original.strVal)
        var wrapper = newProc(name, [signature[0].copyNimTree])
        var call = newCall(code.transformed, history)
        var defaults: seq[NimNode]
        for i in 1..<original.getImpl[3].len:
            let formal = original.getImpl[3][i]
            for j in 0..<formal.len - 2: defaults.add(formal[^1])
        var parameterIndex = 0
        for i in 1..<signature.len:
            let formal = signature[i]
            for j in 0..<formal.len - 2:
                let argument = genSym(nskParam, formal[j].strVal)
                wrapper[3].add(newIdentDefs(argument, formal[^2].copyNimTree, defaults[parameterIndex].copyNimTree))
                inc parameterIndex
                call.add(argument)
        wrapper[6] = newStmtList(call)
        wrapper[4] = newTree(nnkPragma, newTree(nnkExprColonExpr, bindSym"autoRollbackOriginal", original))
        for pragma in original.getImpl[4]:
            if pragma.eqIdent("discardable"): wrapper[4].add(ident"discardable")
        let snapshot = ident"snapshot"
        let rollback = ident"rollback"
        result = quote do:
            try:
                var `history`: AutoRollbackLog
                `declarations`
                `wrapper`
                proc `snapshot`(): int {.used.} =
                    ## 現在の履歴位置を取得する。O(1)。
                    `history`.len
                proc `rollback`(position: int) {.used.} =
                    ## 同じスコープ内の有効な履歴位置へ戻す。復元する値の合計サイズに比例する時間。
                    if position < 0 or position > `history`.len:
                        raise newException(ValueError, "rollback先が現在の履歴範囲外です")
                    restore(`history`, position)
                try:
                    discardRollbackResult:
                        `body`
                finally:
                    restore(`history`, 0)
            finally:
                discard

    macro temporaryImpl*(body: typed): untyped =
        ## 型検査済みのブロック内の変更を記録し、脱出時に必ず復元する。
        let history = genSym(nskVar, "history")
        let code = buildAutoRollback(body, history, "Temporary", true)
        let declarations = code.declarations
        let converted = code.transformed
        result = quote do:
            var `history`: TemporaryRollbackLog
            `declarations`
            try:
                `converted`
            finally:
                restore(`history`, 0)
