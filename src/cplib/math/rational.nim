when not declared CPLIB_MATH_RATIONAL:
    const CPLIB_MATH_RATIONAL* = 1
    import strformat, std/math, hashes
    type Rational*[T] = object
        num*, den*: T
    var RATIONAL_REDUCE_LIMIT = 1000000000
    proc isNaN*(x: Rational): bool = x.den == 0 and x.num == 0
    proc reduce*[T](self: var Rational[T]) =
        if isNaN(self): return
        var g = gcd(abs(self.num), abs(self.den))
        self.num = self.num div g
        self.den = self.den div g
        if self.den < 0:
            self.den *= -1
            self.num *= -1
    proc check_and_reduce[T](self: var Rational[T]) =
        if self.den < 0 or self.num > RATIONAL_REDUCE_LIMIT or self.den > RATIONAL_REDUCE_LIMIT: self.reduce()
    proc initRational*[T](num, den: T, reduce: bool = true): Rational[T] =
        result = Rational[T](num: num, den: den)
        if reduce: result.reduce()
    proc initRational*[T](num: T): Rational[T] = Rational[T](num: num, den: T(1))
    proc `$`*[T](x: Rational[T]): string =
        var x = x
        x.reduce()
        return &"{x.num}/{x.den}"
    proc inv*[T](x: Rational[T]): Rational[T] = Rational[T](num: x.den, den: x.num)
    proc abs*[T](x: Rational[T]): Rational[T] = (if x.num < 0: Rational[T](num: -x.num, den: x.den) else: x)
    proc `-`*[T](x: Rational[T]): Rational[T] = Rational[T](num: -x.num, den: x.den)
    proc `+=`*[T](x: var Rational[T], y: Rational[T]) =
        if isNaN(x) or isNaN(y):
            x = initRational(0, 0)
            return
        if x.den == 0 and y.den == 0:
            if (x.num > 0) == (y.num > 0): return
            x = initRational(0, 0)
            return
        if x.den == 0 or y.den == 0:
            if x.den != 0: x = y
            return
        x.num = x.num * y.den + y.num * x.den
        x.den *= y.den
        x.check_and_reduce()
    proc `-=`*[T](x: var Rational[T], y: Rational[T]) = x += (-y)
    proc `*=`*[T](x: var Rational[T], y: Rational[T]) =
        if isNaN(x) or isNaN(y):
            x = initRational(0, 0)
            return
        x.den *= y.den
        x.num *= y.num
        x.check_and_reduce()
    proc `/=`*[T](x: var Rational[T], y: Rational[T]) =
        if isNaN(x) or isNaN(y):
            x = initRational(0, 0)
            return
        x.den *= y.num
        x.num *= y.den
        x.check_and_reduce()
    proc `>`*[T](x, y: Rational[T]): bool =
        if isNaN(x) or isNaN(y): return false
        if x.den == 0 and y.den == 0: return x.num > y.num
        x.num * y.den > y.num * x.den
    proc `<`*[T](x, y: Rational[T]): bool =
        if isNaN(x) or isNaN(y): return false
        if x.den == 0 and y.den == 0: return x.num < y.num
        x.num * y.den < y.num * x.den
    proc `==`*[T](x, y: Rational[T]): bool =
        if isNaN(x) or isNaN(y): return false
        if x.den == 0 and y.den == 0: return (x.num div abs(x.num)) * (y.num div abs(y.num)) > 0
        x.num * y.den == y.num * x.den
    proc cmp*[T](x, y: Rational[T]): int = (if x < y: -1 elif x == y: 0 else: 1)

    proc `+=`*[T](x: var Rational[T], y: T) = (x += initRational[T](y))
    proc `+`*[T](x, y: Rational[T]): Rational[T] = (result = x; result += y)
    proc `+`*[T](x: Rational[T], y: T): Rational[T] = (result = x; result += y)
    proc `+`*[T](x: T, y: Rational[T]): Rational[T] = (result = y; result += x)
    proc `-=`*[T](x: var Rational[T], y: T) = (x -= initRational[T](y))
    proc `-`*[T](x, y: Rational[T]): Rational[T] = (result = x; result -= y)
    proc `-`*[T](x: Rational[T], y: T): Rational[T] = (result = x; result -= y)
    proc `-`*[T](x: T, y: Rational[T]): Rational[T] = (result = -y; result += x)
    proc `*=`*[T](x: var Rational[T], y: T) = (x *= initRational[T](y))
    proc `*`*[T](x, y: Rational[T]): Rational[T] = (result = x; result *= y)
    proc `*`*[T](x: Rational[T], y: T): Rational[T] = (result = x; result *= y)
    proc `*`*[T](x: T, y: Rational[T]): Rational[T] = (result = y; result *= x)
    proc `/=`*[T](x: var Rational[T], y: T) = (x /= initRational[T](y))
    proc `/`*[T](x, y: Rational[T]): Rational[T] = (result = x; result /= y)
    proc `/`*[T](x: Rational[T], y: T): Rational[T] = (result = x; result /= y)
    proc `/`*[T](x: T, y: Rational[T]): Rational[T] = (result = y.inv(); result *= x)
    proc `>`*[T](x: Rational[T], y: T): bool = x > initRational[T](y)
    proc `>`*[T](x: T, y: Rational[T]): bool = initRational[T](x) > y
    proc `<=`*[T](x: Rational[T], y: Rational[T] or T): bool = not (x > y)
    proc `<=`*[T](x: T, y: Rational[T]): bool = not(x > y)
    proc `<`*[T](x: Rational[T], y: T): bool = x < initRational[T](y)
    proc `<`*[T](x: T, y: Rational[T]): bool = initRational[T](x) < y
    proc `>=`*[T](x: Rational[T], y: Rational[T] or T): bool = not (x < y)
    proc `>=`*[T](x: T, y: Rational[T]): bool = not(x < y)
    proc `==`*[T](x: Rational[T], y: T): bool = x == initRational[T](y)
    proc `==`*[T](x: T, y: Rational[T]): bool = initRational[T](x) == y
    proc cmp*[T](x: Rational[T], y: T): int = cmp(x, initRational[T](y))
    proc cmp*[T](x: T, y: Rational[T]): int = cmp(initRational[T](x), y)
    proc hash*[T](x: Rational[T]): Hash =
        var x = x
        x.reduce()
        result = result !& hash(x.num)
        result = result !& hash(x.den)
    proc toFloat*[T](x: Rational[T]): float =
        x.num / x.den
    proc pow*[T](x: Rational[T], n: int): Rational[T] =
        result = initRational[T](1)
        var x = x
        var n = n
        while n > 0:
            if (n and 1) == 1: result *= x
            x *= x
            n = n shr 1
