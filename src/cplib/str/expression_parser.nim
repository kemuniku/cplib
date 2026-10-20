when not declared CPLIB_STR_EXPRESSION_PARSER:
    const CPLIB_STR_EXPRESSION_PARSER* = 1

    type
        ExpressionAssociativity* = enum
            eaLeft, eaRight
        ExpressionNodeKind* = enum
            enLeaf, enUnary, enBinary
        ExpressionNode*[T] = object
            kind*: ExpressionNodeKind
            value*: T
            op*: char
            left*, right*: int
            first*, last*: int
        ExpressionTree*[T] = object
            nodes*: seq[ExpressionNode[T]]
            root*: int
        ExpressionParseError* = object of ValueError
            position*: int
        ExpressionReader*[T] = proc(text: string, position: var int): T {.closure.}
        ExpressionUnary[T] = proc(value: T): T {.closure.}
        ExpressionBinary[T] = proc(left, right: T): T {.closure.}
        ExpressionOperator[T] = object
            unary, binary: bool
            unaryPriority, binaryPriority: int
            associativity: ExpressionAssociativity
            unaryEval: ExpressionUnary[T]
            binaryEval: ExpressionBinary[T]
        ExpressionParser*[T] = object
            operators: array[char, ExpressionOperator[T]]
        ExpressionPending = object
            op: char
            position: int
            unary: bool
        ExpressionValue[V] = object
            value: V
            first, last: int

    proc initExpressionParser*[T](): ExpressionParser[T] =
        ## 空の演算子表を作る。優先順位は大きいほど強く、負の値も指定可能。
        discard

    proc checkExpressionOperator(op: char) =
        ## 括弧とASCII空白は演算子に登録できない。
        if op in {'(', ')', ' ', '\t', '\r', '\n', '\v', '\f'}:
            raise newException(ValueError, "reserved expression character")

    proc addBinary*[T](parser: var ExpressionParser[T], op: char, priority: int,
            associativity = eaLeft, evaluate: ExpressionBinary[T] = nil) =
        ## 二項演算子を登録する。同順位の結合方向の混在と重複登録は拒否する。O(256)。
        checkExpressionOperator(op)
        if parser.operators[op].binary:
            raise newException(ValueError, "duplicate binary operator")
        for entry in parser.operators:
            if entry.binary and entry.binaryPriority == priority and entry.associativity != associativity:
                raise newException(ValueError, "mixed associativity at the same priority")
        parser.operators[op].binary = true
        parser.operators[op].binaryPriority = priority
        parser.operators[op].associativity = associativity
        parser.operators[op].binaryEval = evaluate

    proc addPrefix*[T](parser: var ExpressionParser[T], op: char, priority: int,
            evaluate: ExpressionUnary[T] = nil) =
        ## 前置演算子を登録する。同順位の二項演算子より強く結合する。重複は拒否する。O(1)。
        ## 連続する前置演算子は優先順位によらず右から作用する。
        checkExpressionOperator(op)
        if parser.operators[op].unary:
            raise newException(ValueError, "duplicate prefix operator")
        parser.operators[op].unary = true
        parser.operators[op].unaryPriority = priority
        parser.operators[op].unaryEval = evaluate

    proc expressionError(position: int, message: string) {.noreturn.} =
        ## 入力のバイト位置を付けて構文エラーを通知する。
        var error = newException(ExpressionParseError, message & " at " & $position)
        error.position = position
        raise error

    proc expressionRun[T, V](parser: ExpressionParser[T], text: string,
            read: ExpressionReader[T],
            leaf: proc(value: T, first, last: int): V {.closure.},
            reduce: proc(op: char, unary: bool, left, right: V, first, last: int): V {.closure.}): V =
        ## 明示スタックで解析する。callbackの総コストを除き時間・領域O(入力長)。
        if read == nil:
            raise newException(ValueError, "missing expression reader")
        var values: seq[ExpressionValue[V]]
        var pending: seq[ExpressionPending]
        var position = 0
        var needValue = true
        template reduceTop() =
            block:
                let top = pending.pop()
                let right = values.pop()
                let left = if top.unary: right else: values.pop()
                let first = if top.unary: top.position else: left.first
                values.add(ExpressionValue[V](value: reduce(top.op, top.unary,
                    left.value, right.value, first, right.last), first: first, last: right.last))
        while position < text.len:
            let ch = text[position]
            if ch in {' ', '\t', '\r', '\n', '\v', '\f'}:
                inc position
                continue
            if needValue:
                if ch == '(':
                    pending.add(ExpressionPending(op: ch, position: position))
                    inc position
                elif parser.operators[ch].unary:
                    pending.add(ExpressionPending(op: ch, position: position, unary: true))
                    inc position
                else:
                    if ch == ')' or parser.operators[ch].binary:
                        expressionError(position, "expected operand")
                    let first = position
                    let value = read(text, position)
                    if position <= first or position > text.len:
                        raise newException(ValueError, "expression reader must advance within input")
                    values.add(ExpressionValue[V](value: leaf(value, first, position), first: first, last: position))
                    needValue = false
            elif ch == ')':
                while pending.len > 0 and pending[^1].op != '(':
                    reduceTop()
                if pending.len == 0:
                    expressionError(position, "unmatched closing parenthesis")
                let opening = pending.pop()
                values[^1].first = opening.position
                values[^1].last = position + 1
                inc position
            else:
                let entry = parser.operators[ch]
                if not entry.binary:
                    expressionError(position, "expected binary operator")
                while pending.len > 0 and pending[^1].op != '(':
                    let top = pending[^1]
                    let previous = parser.operators[top.op]
                    let priority = if top.unary: previous.unaryPriority else: previous.binaryPriority
                    if priority < entry.binaryPriority or
                            (priority == entry.binaryPriority and not top.unary and entry.associativity == eaRight):
                        break
                    reduceTop()
                pending.add(ExpressionPending(op: ch, position: position))
                inc position
                needValue = true
        if needValue:
            expressionError(position, "expected operand")
        while pending.len > 0:
            if pending[^1].op == '(':
                expressionError(pending[^1].position, "unclosed parenthesis")
            reduceTop()
        result = values[0].value

    proc eval*[T](parser: ExpressionParser[T], text: string, read: ExpressionReader[T]): T =
        ## 直接評価する。使用する演算に計算関数がなければValueError。callbackの例外はそのまま伝播する。
        ## readは空白を除いた葉の先頭から読み、positionを入力内で必ず進める。
        ## 進行しない・範囲外に進むreadはValueError。演算子・括弧の手前で読み終えるのはreadの責任。
        ## 短絡評価は行わず、不正入力でも検出前にcallbackが呼ばれる場合がある。
        proc leaf(value: T, first, last: int): T = value
        proc reduce(op: char, unary: bool, left, right: T, first, last: int): T =
            if unary:
                if parser.operators[op].unaryEval == nil:
                    raise newException(ValueError, "missing prefix evaluator")
                return parser.operators[op].unaryEval(right)
            if parser.operators[op].binaryEval == nil:
                raise newException(ValueError, "missing binary evaluator")
            return parser.operators[op].binaryEval(left, right)
        result = expressionRun[T, T](parser, text, read, leaf, reduce)

    proc parse*[T](parser: ExpressionParser[T], text: string, read: ExpressionReader[T]): ExpressionTree[T] =
        ## 計算関数を使わずflat ASTを作る。子IDは必ず親IDより小さく、未使用の子IDは-1。
        ## first..<lastはバイト範囲。直接包む括弧と外側の空白は含まず、部分式内部の括弧・空白は含む。
        ## 例: ((1)+2) の根は (1)+2、葉1は 1 を指す。括弧ノードは作らない。
        ## readの契約・例外と計算量はevalと共通。Tのコピーとcallbackが定数時間なら全体でO(入力長)。
        var nodes: seq[ExpressionNode[T]]
        proc leaf(value: T, first, last: int): int =
            result = nodes.len
            nodes.add(ExpressionNode[T](kind: enLeaf, value: value, left: -1, right: -1, first: first, last: last))
        proc reduce(op: char, unary: bool, left, right: int, first, last: int): int =
            result = nodes.len
            nodes.add(ExpressionNode[T](kind: (if unary: enUnary else: enBinary), op: op,
                left: (if unary: -1 else: left), right: right, first: first, last: last))
        let root = expressionRun[T, int](parser, text, read, leaf, reduce)
        result = ExpressionTree[T](nodes: nodes, root: root)

    runnableExamples:
        proc number(text: string, position: var int): int =
            let first = position
            while position < text.len and text[position] in {'0'..'9'}:
                result = result * 10 + ord(text[position]) - ord('0')
                inc position
            if first == position:
                raise newException(ValueError, "expected number")
        var parser = initExpressionParser[int]()
        parser.addBinary('+', 10, eaLeft, proc(a, b: int): int = a + b)
        parser.addBinary('*', 20, eaLeft, proc(a, b: int): int = a * b)
        parser.addPrefix('-', 30, proc(a: int): int = -a)
        assert parser.eval("-(2 + 3) * 4", number) == -20
        let tree = parser.parse("-(2 + 3) * 4", number)
        assert tree.nodes[tree.root].kind == enBinary
        var syntax = initExpressionParser[int]()
        syntax.addBinary('+', 10)
        assert syntax.parse("1+2", number).nodes.len == 3
