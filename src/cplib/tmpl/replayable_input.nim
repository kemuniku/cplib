when not declared CPLIB_TMPL_REPLAYABLE_INPUT:
    const CPLIB_TMPL_REPLAYABLE_INPUT* = 1
    import macros, tables, typetraits

    type
        ReplayInputRun = object
            kind: pointer
            start: int
        ReplayInputBufferBase = ref object of RootObj
        ReplayInputBuffer[T] = ref object of ReplayInputBufferBase
            values: seq[T]
        ReplayInputState = object
            entries: seq[int]
            runs: seq[ReplayInputRun]
            buffers: Table[pointer, ReplayInputBufferBase]
            position, runPosition, depth: int

    proc replayInputTypeId[T](): pointer {.inline.} =
        ## 型ごとに異なる識別子をO(1)で返します。型別名は同じ識別子になります。
        var token {.global.}: byte
        addr token

    proc replayInputBuffer[T](state: var ReplayInputState,
                             kind: pointer): ReplayInputBuffer[T] =
        ## 型ごとの連続バッファを取得し、未作成なら生成します。期待O(1)。
        let existing = state.buffers.getOrDefault(kind)
        if existing != nil:
            return ReplayInputBuffer[T](existing)
        result = ReplayInputBuffer[T]()
        state.buffers[kind] = result

    template replayInputRead(state: var ReplayInputState, T: typedesc,
                            source: untyped, onlyInts: static[bool]): untyped =
        ## 値を記録・再生します。小さな非管理型は直接格納し、ほかは型別バッファに保存します。
        block:
            var value: T
            when not onlyInts:
                let kind = replayInputTypeId[T]()
            when supportsCopyMem(T) and sizeof(T) <= sizeof(int):
                const inlineValue = true
            else:
                const inlineValue = false
            if state.position < state.entries.len:
                let entry = state.entries[state.position]
                when not onlyInts:
                    if state.runPosition + 1 < state.runs.len and
                            state.runs[state.runPosition + 1].start == state.position:
                        inc state.runPosition
                    if state.runs[state.runPosition].kind != kind:
                        raise newException(ValueError, "replayed input type mismatch")
                when inlineValue:
                    # 参照管理が不要な型だけを、保存時と同じバイト列から復元します。
                    copyMem(addr value, unsafeAddr entry, sizeof(T))
                else:
                    value = replayInputBuffer[T](state, kind).values[entry]
                inc state.position
            else:
                if state.depth == 0 and state.entries.len > 0:
                    state.entries.setLen(0)
                    when not onlyInts:
                        state.runs.setLen(0)
                        state.runPosition = 0
                        state.buffers.clear()
                    state.position = 0
                value = source
                if state.depth > 0:
                    when not onlyInts:
                        if state.runs.len == 0 or state.runs[^1].kind != kind:
                            state.runs.add(ReplayInputRun(kind: kind, start: state.entries.len))
                        state.runPosition = state.runs.len - 1
                    var entry: int
                    when inlineValue:
                        copyMem(addr entry, addr value, sizeof(T))
                    else:
                        let buffer = replayInputBuffer[T](state, kind)
                        entry = buffer.values.len
                        buffer.values.add(value)
                    state.entries.add(entry)
                    inc state.position
            value

    macro replayableInput*(body: untyped): untyped =
        ## ii・lii・si・inputを記録再生に対応させ、peekInput終了時に入力位置を戻す。
        ## 記録・再生は1要素あたり期待償却O(1)（入力や値のコピーを除く）、空間は記録量に比例する。
        ## 再生時は各要素の型を一致させ、先読みした入力はこのブロック内で消費すること。
        ## 外部の関数・テンプレート内の入力や修飾付き呼び出し、関数値経由の入力は対象外。
        let state = genSym(nskVar, "replayState")
        let readOne = genSym(nskTemplate, "replayReadOne")
        let readMany = genSym(nskTemplate, "replayReadMany")
        var onlyInts = true

        proc transform(node: NimNode): NimNode =
            ## 対象の入力呼び出しと先読みブロックを再帰的に変換する。
            if node.kind in {nnkCall, nnkCommand} and
                    node[0].kind in {nnkIdent, nnkSym}:
                if node[0].eqIdent("peekInput"):
                    if node.len != 2 or node[1].kind != nnkStmtList:
                        error("peekInput requires a block", node)
                    let checkpoint = genSym(nskLet, "checkpoint")
                    let runCheckpoint = genSym(nskLet, "runCheckpoint")
                    let inner = transform(node[1])
                    return quote do:
                        block:
                            let `checkpoint` = `state`.position
                            let `runCheckpoint` = `state`.runPosition
                            inc `state`.depth
                            try:
                                `inner`
                            finally:
                                `state`.position = `checkpoint`
                                `state`.runPosition = `runCheckpoint`
                                dec `state`.depth
                if node[0].eqIdent("ii") and node.len == 1:
                    return newCall(readOne, ident"int")
                if node[0].eqIdent("si") and node.len == 1:
                    onlyInts = false
                    return newCall(readOne, ident"string")
                if node[0].eqIdent("lii") and node.len == 2:
                    return newCall(readMany, transform(node[1]), ident"int")
                if node[0].eqIdent("input"):
                    onlyInts = false
                    if node.len == 2:
                        return newCall(readOne, node[1])
                    if node.len == 3:
                        return newCall(readMany, transform(node[1]), node[2])
                if node[0].eqIdent("replayableInput"):
                    error("replayableInput cannot be nested; nest peekInput instead", node)
            result = copyNimNode(node)
            for child in node:
                result.add(transform(child))

        let transformed = transform(body)
        let onlyIntsNode = newLit(onlyInts)
        result = quote do:
            block:
                var `state`: ReplayInputState
                template `readOne`(T: typedesc): untyped =
                    ## 1要素を入力または再生する。
                    replayInputRead(`state`, T, input(T), `onlyIntsNode`)
                template `readMany`(count: int, T: typedesc): untyped =
                    ## count要素を入力または再生する。O(count)。
                    block:
                        let length = count
                        var values = newSeq[T](length)
                        for i in 0 ..< length:
                            values[i] = `readOne`(T)
                        values
                `transformed`
