when not declared CPLIB_UTILS_MEMO:
    const CPLIB_UTILS_MEMO* = 1
    import macros
    import tables
    macro memo*(p: untyped): untyped =
        expectKind(p, nnkProcDef)

        let name = p[0]
        let params = p[3]
        let retType = params[0]

        if retType.kind == nnkEmpty:
            error("memo proc must have an explicit return type", p)

        var argNames: seq[NimNode] = @[]
        var argTypes: seq[NimNode] = @[]

        for i in 1 ..< params.len:
            let identDefs = params[i]
            let typ = identDefs[^2]

            for j in 0 ..< identDefs.len - 2:
                argNames.add identDefs[j]
                argTypes.add typ

        if argNames.len == 0:
            error("memo proc must have at least one argument", p)

        let keyType =
            if argNames.len == 1:
                argTypes[0]
            else:
                var t = nnkTupleTy.newTree()
                for i in 0 ..< argNames.len:
                    t.add nnkIdentDefs.newTree(
                        argNames[i],
                        argTypes[i],
                        newEmptyNode()
                    )
                t

        let keyExpr =
            if argNames.len == 1:
                argNames[0]
            else:
                var t = nnkTupleConstr.newTree()
                for i in 0 ..< argNames.len:
                    t.add nnkExprColonExpr.newTree(argNames[i], argNames[i])
                t

        let cacheName = genSym(nskVar, $name & "Cache")
        let implName = genSym(nskProc, $name & "Impl")
        let keyName = genSym(nskLet, "key")

        # 元の名前の前方宣言
        var forwardProc = copyNimTree(p)
        forwardProc[4] = newEmptyNode()
        forwardProc[6] = newEmptyNode()

        # 元の本体を持つ実装関数
        var implProc = copyNimTree(p)
        implProc[0] = implName
        implProc[4] = newEmptyNode()

        # impl(args...) の呼び出し式
        var callImpl = newCall(implName)
        for a in argNames:
            callImpl.add(a)

        # キャッシュ付きラッパー
        var wrapperProc = copyNimTree(p)
        wrapperProc[4] = newEmptyNode()
        wrapperProc[6] = quote do:
            let `keyName` = `keyExpr`

            if `keyName` in `cacheName`:
                return `cacheName`[`keyName`]

            result = `callImpl`
            `cacheName`[`keyName`] = result

        result = quote do:
            `forwardProc`
            var `cacheName` = initTable[`keyType`, `retType`]()
            `implProc`
            `wrapperProc`