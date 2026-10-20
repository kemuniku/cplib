# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import strutils, random
import cplib/str/expression_parser

proc number(text: string, position: var int): int =
    let first = position
    while position < text.len and text[position] in {'0'..'9'}:
        inc position
    if first == position:
        var error = newException(ExpressionParseError, "expected number")
        error.position = position
        raise error
    result = parseInt(text[first..<position])

proc power(a, b: int): int =
    result = 1
    for _ in 0..<b: result *= a

var parser = initExpressionParser[int]()
parser.addBinary('+', 10, eaLeft, proc(a, b: int): int = a + b)
parser.addBinary('-', 10, eaLeft, proc(a, b: int): int = a - b)
parser.addBinary('*', 20, eaLeft, proc(a, b: int): int = a * b)
parser.addBinary('^', 40, eaRight, power)
parser.addPrefix('-', 30, proc(a: int): int = -a)
parser.addPrefix('+', 30, proc(a: int): int = a)
parser.addPrefix('~', 30, proc(a: int): int = a + 1)

proc treeEval(tree: ExpressionTree[int]): int =
    var values = newSeq[int](tree.nodes.len)
    for id, node in tree.nodes:
        doAssert node.first >= 0 and node.last > node.first
        case node.kind
        of enLeaf:
            doAssert node.left == -1 and node.right == -1
            values[id] = node.value
        of enUnary:
            doAssert node.left == -1 and node.right >= 0 and node.right < id
            case node.op
            of '-': values[id] = -values[node.right]
            of '+': values[id] = values[node.right]
            of '~': values[id] = values[node.right] + 1
            else: doAssert false
        of enBinary:
            doAssert node.left >= 0 and node.left < id and node.right >= 0 and node.right < id
            let a = values[node.left]
            let b = values[node.right]
            case node.op
            of '+': values[id] = a + b
            of '-': values[id] = a - b
            of '*': values[id] = a * b
            of '^': values[id] = power(a, b)
            else: doAssert false
    doAssert tree.root == tree.nodes.high
    result = values[tree.root]

for (text, expected) in [
        ("1+2*3", 7), ("8-3-2", 3), ("2^3^2", 512), ("-2^2", -4),
        ("(-2)^2", 4), ("2^-1", 1), ("--+-2", -2), ("-~2", -3),
        ("~-2", -1), ("1-(2-3)", 2), ("(1+2)*3", 9),
        (" \t\n1 +\r (2* 3)\v\f ", 7), ("((1))", 1), ("2^-(1+1)", 1)]:
    doAssert parser.eval(text, number) == expected, text
    doAssert treeEval(parser.parse(text, number)) == expected, text

for text in ["", " ", "()", "1+", "-", "(1", "1)", "1 2", "2(3)",
        "1**2", "1+)", "(1+)2", "1+()", "((1)", "1+2?", "1\x00", "1~2", "(1)2", ")1("]:
    doAssertRaises(ExpressionParseError): discard parser.eval(text, number)
    doAssertRaises(ExpressionParseError): discard parser.parse(text, number)
try:
    discard parser.eval("1+2?", number)
    doAssert false
except ExpressionParseError as error:
    doAssert error.position == 3

block:
    var syntax = initExpressionParser[int]()
    syntax.addBinary('+', 0)
    syntax.addPrefix('-', 1)
    doAssert syntax.parse("-1+2", number).nodes.len == 4
    doAssertRaises(ValueError): discard syntax.eval("1+2", number)
    doAssertRaises(ValueError): discard syntax.eval("-1", number)
    doAssertRaises(ValueError): syntax.addBinary('*', 0, eaRight)
    doAssertRaises(ValueError): syntax.addBinary('+', 1)
    doAssertRaises(ValueError): syntax.addPrefix('-', 2)
    doAssertRaises(ValueError): syntax.addBinary('(', 1)
    doAssertRaises(ValueError): syntax.addPrefix(' ', 1)
    doAssert syntax.parse("1+2", number).nodes.len == 3

block:
    var ties = initExpressionParser[int]()
    ties.addBinary('^', low(int), eaRight, power)
    ties.addPrefix('-', low(int), proc(a: int): int = -a)
    doAssert ties.eval("-2^2", number) == 4
    var extremes = initExpressionParser[int]()
    extremes.addPrefix('-', high(int), proc(a: int): int = -a)
    extremes.addBinary('+', low(int), eaLeft, proc(a, b: int): int = a + b)
    doAssert extremes.eval("-2+3", number) == 1

block:
    var right = initExpressionParser[int]()
    right.addBinary('-', 0, eaRight, proc(a, b: int): int = a - b)
    right.addBinary('+', 0, eaRight, proc(a, b: int): int = a + b)
    doAssert right.eval("8-3-2", number) == 7
    doAssert right.eval("8-3+2", number) == 3
    var loose = initExpressionParser[int]()
    loose.addBinary('+', 10, eaLeft, proc(a, b: int): int = a + b)
    loose.addPrefix('-', 0, proc(a: int): int = -a)
    doAssert loose.eval("-1+2", number) == -3
    doAssert loose.eval("(-1)+2", number) == 1
    doAssert loose.eval("1+(-2)+3", number) == 2
    doAssert loose.eval("-(1)+2", number) == -3

block:
    let text = " ((1)+2) "
    let tree = parser.parse(text, number)
    doAssert text[tree.nodes[tree.root].first..<tree.nodes[tree.root].last] == "(1)+2"
    doAssert text[tree.nodes[0].first..<tree.nodes[0].last] == "1"
    let grouped = parser.parse("((1))", number)
    doAssert grouped.nodes[0].first == 2 and grouped.nodes[0].last == 3

block:
    type Scalar = object
        x: float
    var genericParser = initExpressionParser[Scalar]()
    genericParser.addBinary('+', 10, eaLeft, proc(a, b: Scalar): Scalar = Scalar(x: a.x + b.x))
    genericParser.addPrefix('-', 20, proc(a: Scalar): Scalar = Scalar(x: -a.x))
    proc variable(text: string, position: var int): Scalar =
        let ch = text[position]
        inc position
        case ch
        of 'x': result.x = 1.25
        of 'y': result.x = 2.5
        else: raise newException(ValueError, "unknown variable")
    doAssert genericParser.eval("x+-y", variable).x == -1.25
    doAssert genericParser.parse("x+-y", variable).nodes[0].value.x == 1.25

block:
    type CallbackError = object of CatchableError
    let sentinel = newException(CallbackError, "reader failure")
    proc failingReader(text: string, position: var int): int = raise sentinel
    for ast in [false, true]:
        try:
            if ast: discard parser.parse("1", failingReader)
            else: discard parser.eval("1", failingReader)
            doAssert false
        except CallbackError as error: doAssert error == sentinel
    var throwing = initExpressionParser[int]()
    throwing.addPrefix('!', 0, proc(a: int): int = raise sentinel)
    throwing.addBinary('+', 0, eaLeft, proc(a, b: int): int = raise sentinel)
    doAssert throwing.parse("!1+2", number).nodes.len == 4
    for text in ["!1", "1+2"]:
        try:
            discard throwing.eval(text, number)
            doAssert false
        except CallbackError as error: doAssert error == sentinel
    for change in [-1, 0, 100]:
        let step = change
        proc badReader(text: string, position: var int): int =
            position += step
            result = 1
        for ast in [false, true]:
            try:
                if ast: discard parser.parse("1", badReader)
                else: discard parser.eval("1", badReader)
                doAssert false
            except ExpressionParseError: doAssert false
            except ValueError: discard
    doAssertRaises(ValueError): discard parser.eval("1", nil)

block:
    var rng = initRand(20261020)
    for _ in 0..<1000:
        var text = $rng.rand(9)
        var expected = parseInt(text)
        for _ in 0..<20:
            let b = rng.rand(9)
            if rng.rand(1) == 0:
                text = "(" & text & "+" & $b & ")"
                expected += b
            else:
                text = "-(" & text & "-" & $b & ")"
                expected = -(expected - b)
        doAssert parser.eval(text, number) == expected
        doAssert treeEval(parser.parse(text, number)) == expected

block:
    const depth = 200000
    for text in [repeat('(', depth) & "1" & repeat(')', depth), repeat('-', depth) & "1"]:
        doAssert parser.eval(text, number) == 1
        doAssert treeEval(parser.parse(text, number)) == 1
    let chain = repeat("1+", depth) & "1"
    doAssert parser.eval(chain, number) == depth + 1
    doAssert treeEval(parser.parse(chain, number)) == depth + 1
    let rightChain = repeat("1^", depth) & "1"
    doAssert parser.eval(rightChain, number) == 1
    doAssert treeEval(parser.parse(rightChain, number)) == 1
    doAssertRaises(ExpressionParseError): discard parser.parse(repeat('(', depth) & "1", number)
    doAssertRaises(ExpressionParseError): discard parser.eval(repeat('-', depth), number)

echo "Hello World"
