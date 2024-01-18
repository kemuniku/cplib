when not declared CPLIB_MATH_RATIONAL:
    const CPLIB_MATH_RATIONAL* = 1
    import strformat, std/math, hashes
    type Rational* = object
        num, den: int
    var RATIONAL_REDUCE_LIMIT = 1000000000
    proc reduce(self: var Rational) =
        var g = gcd(abs(self.num), abs(self.den))
        self.num = self.num div g
        self.den = self.den div g
        if self.den < 0:
            self.den *= -1
            self.num *= -1
    proc check_and_reduce(self: var Rational) =
        if self.den < 0 or self.num > RATIONAL_REDUCE_LIMIT or self.den > RATIONAL_REDUCE_LIMIT: self.reduce()
    proc initRational*(num, den: int, reduce: bool = true): Rational =
        assert num != 0 or den != 0
        result = Rational(num: num, den: den)
        if reduce: result.reduce()
    proc initRational*(num: int): Rational = Rational(num: num, den: 1)
    proc `$`*(x: Rational): string =
        var x = x
        x.reduce()
        return &"{x.num}/{x.den}"
    proc inv*(x: Rational): Rational = Rational(num: x.den, den: x.num)
    proc abs*(x: Rational): Rational = (if x.num < 0: Rational(num: -x.num, den: x.den) else: x)
    proc `-`*(x: Rational): Rational = Rational(num: -x.num, den: x.den)
    proc `+=`*(x: var Rational, y: Rational) =
        x.den *= y.den
        x.num = x.num * y.den + y.num * x.den
        x.check_and_reduce()
    proc `-=`*(x: var Rational, y: Rational) =
        x.den *= y.den
        x.num = x.num * y.den - y.num * x.den
        x.check_and_reduce()
    proc `*=`*(x: var Rational, y: Rational) =
        x.den *= y.den
        x.num *= y.num
        x.check_and_reduce()
    proc `/=`*(x: var Rational, y: Rational) =
        x.den *= y.num
        x.num *= y.den
        x.check_and_reduce()
    proc `>`*(x, y: Rational): bool = x.num * y.den > y.num * x.den
    proc `<`*(x, y: Rational): bool = x.num * y.den < y.num * x.den
    proc `==`*(x, y: Rational): bool = x.num * y.den == y.num * x.den
    proc `!=`*(x, y: Rational): bool = not (x == y)
    proc cmp*(x, y: Rational): int = (if x < y: -1 elif x == y: 0 else: 1)

    proc `+=`*(x: var Rational, y: int) = (x += initRational(y))
    proc `+`*(x, y: Rational): Rational = (result = x; result += y)
    proc `+`*(x: Rational, y: int): Rational = (result = x; result += y)
    proc `+`*(x: int, y: Rational): Rational = (result = y; result += x)
    proc `-=`*(x: var Rational, y: int) = (x -= initRational(y))
    proc `-`*(x, y: Rational): Rational = (result = x; result -= y)
    proc `-`*(x: Rational, y: int): Rational = (result = x; result -= y)
    proc `-`*(x: int, y: Rational): Rational = (result = -y; result += x)
    proc `*=`*(x: var Rational, y: int) = (x *= initRational(y))
    proc `*`*(x, y: Rational): Rational = (result = x; result *= y)
    proc `*`*(x: Rational, y: int): Rational = (result = x; result *= y)
    proc `*`*(x: int, y: Rational): Rational = (result = y; result *= x)
    proc `/=`*(x: var Rational, y: int) = (x /= initRational(y))
    proc `/`*(x, y: Rational): Rational = (result = x; result /= y)
    proc `/`*(x: Rational, y: int): Rational = (result = x; result /= y)
    proc `/`*(x: int, y: Rational): Rational = (result = y.inv(); result *= x)
    proc `>`*(x: Rational, y: int): bool = x > initRational(y)
    proc `>`*(x: int, y: Rational): bool = initRational(x) > y
    proc `<`*(x: Rational, y: int): bool = x < initRational(y)
    proc `<`*(x: int, y: Rational): bool = initRational(x) < y
    proc `==`*(x: Rational, y: int): bool = x == initRational(y)
    proc `==`*(x: int, y: Rational): bool = initRational(x) == y
    proc `!=`*(x: Rational, y: int): bool = x != initRational(y)
    proc `!=`*(x: int, y: Rational): bool = initRational(x) != y
    proc cmp*(x: Rational, y: int): int = cmp(x, initRational(y))
    proc cmp*(x: int, y: Rational): int = cmp(initRational(x), y)
    proc hash*(x: Rational): Hash =
        var x = x
        x.reduce()
        result = result !& hash(x.num)
        result = result !& hash(x.den)
    proc toFloat*(x: Rational): float = x.num / x.den
    proc pow*(x: Rational, n: int): Rational =
        result = initRational(1)
        var x = x
        var n = n
        while n > 0:
            if (n and 1) == 1: result *= x
            x *= x
            n = n shr 1
