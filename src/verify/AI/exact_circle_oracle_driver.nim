import strutils
import cplib/geometry/base
import cplib/geometry/circle
import cplib/geometry/exact_circle
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
var line: string
while stdin.readLine(line):
    tokens = line.splitWhitespace()
    index = 1
    case tokens[0]
    of "int": run[int]()
    of "uint": run[uint64]()
    of "int128": run[Int128]()
    of "bigint": run[BigInt]()
    of "fraction-int": run[Fraction[int]]()
    of "fraction-int128": run[Fraction[Int128]]()
    of "fraction-bigint": run[Fraction[BigInt]]()
    else: quit("unknown type")
