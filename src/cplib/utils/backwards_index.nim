when not declared CPLIB_UTILS_BACKWARDS_INDEX:
    const CPLIB_UTILS_BACKWARDS_INDEX* = 1
    import macros, strutils

    macro backwardsIndex*(p: untyped): untyped =
        ## 整数添字の [] / []= に、len(self) - int(idx) を使う ^idx 版を追加する。
        ## len はこの宣言より前に定義する。追加の計算量は len の計算量 + O(1)。
        expectKind(p, {nnkProcDef, nnkFuncDef})
        var name = p[0]
        if name.kind == nnkPostfix:
            name = name[1]
        let op = name.repr.replace("`", "")
        if op != "[]" and op != "[]=":
            error("backwardsIndex は [] / []= に指定してください", p)
        var wrapper = copyNimTree(p)
        let params = wrapper[3]
        if params.len != (if op == "[]": 3 else: 4):
            error("引数は self, idx（代入ではさらに value）を個別に宣言してください", p)
        for i in 1..<params.len:
            if params[i].len != 3:
                error("各引数は個別に宣言してください", params[i])
        let indexType = params[2][1]
        if not (indexType.eqIdent("int") or indexType.eqIdent("Natural")):
            error("添字の型は int または Natural にしてください", indexType)
        params[2][1] = bindSym"BackwardsIndex"
        let self = params[1][0]
        let idx = params[2][0]
        let offset = newCall(indexType, newTree(nnkInfix, ident"-",
            newCall(ident"len", self), newCall(bindSym"int", idx)))
        var call = newCall(copyNimTree(name), self, offset)
        if op == "[]=":
            call.add(params[3][0])
        wrapper[6] = newStmtList(newCommentStmtNode(
            "末尾からの添字を整数添字に変換する。追加計算量は len + O(1)。"), call)
        result = newStmtList(p, wrapper)
