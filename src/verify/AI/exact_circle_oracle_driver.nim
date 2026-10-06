import strutils
import cplib/geometry/base
import cplib/geometry/circle
import cplib/geometry/exact_circle
import cplib/geometry/minimum_enclosing_circle_exact
import cplib/math/bigint
import cplib/math/int128
import cplib/math/fractions

var tokens: seq[string]
var index: int
proc read(): string =
    result = tokens[index]
    inc index
proc scalar[T](): T =
    let n = read()
    let d = read()
    when T is Fraction[int]:
        Fraction[int](num: parseInt(n), den: parseInt(d))
    elif T is Fraction[Int128]:
        Fraction[Int128](num: parseInt128(n), den: parseInt128(d))
    elif T is Fraction[BigInt]:
        Fraction[BigInt](num: parseBigInt(n), den: parseBigInt(d))
    elif T is Int128: parseInt128(n)
    elif T is BigInt: parseBigInt(n)
    elif T is uint64: uint64(parseBiggestUInt(n))
    else: parseInt(n)
proc point[T](): Point[T] = initPoint(scalar[T](), scalar[T]())
proc run[T]() =
    let methodId = parseInt(read())
    let a = point[T]()
    let b = point[T]()
    let c = point[T]()
    let query = point[T]()
    let line = Line[T](s: point[T](), t: point[T]())
    let segment = Segment[T](s: point[T](), t: point[T]())
    let centerB = point[T]()
    let ra = parseInt(read())
    let rb = parseInt(read())
    proc check[S](circle: ExactCircle[S]) =
        let center = circle.center_exact
        let radiusSquared = circle.radius_squared_exact
        let other = initExactCircle(centerB, rb)
        echo $center.x & " " & $center.y & " " & $radiusSquared & " " &
            $ord(circle.classify(query)) & " " & $intersection_count(circle, line) & " " &
            $intersection_count(circle, segment) & " " & $intersection_count(circle, other) & " " &
            $tangent_count(circle, query) & " " & $common_tangent_count(circle, other)
    try:
        case methodId
        of 0: check(initExactCircle(a, b, c))
        of 1: check(initExactCircle(a, ra))
        else: check(initExactCircle(a, b))
    except ValueError:
        echo "INVALID"
proc runMec[T]() =
    let seed = parseBiggestInt(read())
    let n = parseInt(read())
    var points: seq[Point[T]]
    for _ in 0..<n: points.add(point[T]())
    if n == 0:
        try:
            discard minimum_enclosing_circle_exact(points, seed)
            quit("empty MEC was accepted")
        except ValueError:
            echo "EMPTY"
            return
    let circle = minimum_enclosing_circle_exact(points, seed)
    for p in points:
        if not circle.contains(p): quit("MEC does not contain input")
    let center = circle.center_exact
    echo $center.x & " " & $center.y & " " & $circle.radius_squared_exact

var line: string
while stdin.readLine(line):
    tokens = line.splitWhitespace()
    index = 1
    if tokens[0].startsWith("mec-"):
        case tokens[0][4..^1]
        of "int": runMec[int]()
        of "uint": runMec[uint64]()
        of "int128": runMec[Int128]()
        of "bigint": runMec[BigInt]()
        of "fraction-int": runMec[Fraction[int]]()
        of "fraction-int128": runMec[Fraction[Int128]]()
        of "fraction-bigint": runMec[Fraction[BigInt]]()
        else: quit("unknown MEC type")
        continue
    case tokens[0]
    of "int": run[int]()
    of "uint": run[uint64]()
    of "int128": run[Int128]()
    of "bigint": run[BigInt]()
    of "fraction-int": run[Fraction[int]]()
    of "fraction-int128": run[Fraction[Int128]]()
    of "fraction-bigint": run[Fraction[BigInt]]()
    else: quit("unknown type")
