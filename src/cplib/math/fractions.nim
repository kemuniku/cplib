when not declared CPLIB_MATH_FRACTIONS:
    const CPLIB_MATH_FRACTIONS* = 1
    import strformat, std/math, hashes
    type Fraction*[T] = object
        num*, den*: T
    var FRACTION_REDUCE_LIMIT = 1000000000
    proc isNaN*(x: Fraction): bool = x.den == 0 and x.num == 0
    proc reduce*[T](self: var Fraction[T]) =
        if isNaN(self): return
        var g = gcd(abs(self.num), abs(self.den))
        self.num = self.num div g
        self.den = self.den div g
        if self.den < 0:
            self.den *= -1
            self.num *= -1
    proc check_and_reduce[T](self: var Fraction[T]) =
        if self.den < 0 or self.num > FRACTION_REDUCE_LIMIT or self.den > FRACTION_REDUCE_LIMIT: self.reduce()
    proc initFraction*[T](num, den: T, reduce: bool = true): Fraction[T] =
        result = Fraction[T](num: num, den: den)
        if reduce: result.reduce()
    proc initFraction*[T](num: T): Fraction[T] = Fraction[T](num: num, den: T(1))
    proc `$`*[T](x: Fraction[T]): string =
        var x = x
        x.reduce()
        return &"{x.num}/{x.den}"
    proc inv*[T](x: Fraction[T]): Fraction[T] = Fraction[T](num: x.den, den: x.num)
    proc abs*[T](x: Fraction[T]): Fraction[T] = (if x.num < 0: Fraction[T](num: -x.num, den: x.den) else: x)
    proc `-`*[T](x: Fraction[T]): Fraction[T] = Fraction[T](num: -x.num, den: x.den)
    proc `+=`*[T](x: var Fraction[T], y: Fraction[T]) =
        if isNaN(x) or isNaN(y):
            x = initFraction(0, 0)
            return
        if x.den == 0 and y.den == 0:
            if (x.num > 0) == (y.num > 0): return
            x = initFraction(0, 0)
            return
        if x.den == 0 or y.den == 0:
            if x.den != 0: x = y
            return
        x.num = x.num * y.den + y.num * x.den
        x.den *= y.den
        x.check_and_reduce()
    proc `-=`*[T](x: var Fraction[T], y: Fraction[T]) = x += (-y)
    proc `*=`*[T](x: var Fraction[T], y: Fraction[T]) =
        if isNaN(x) or isNaN(y):
            x = initFraction(0, 0)
            return
        x.den *= y.den
        x.num *= y.num
        x.check_and_reduce()
    proc `/=`*[T](x: var Fraction[T], y: Fraction[T]) =
        if isNaN(x) or isNaN(y):
            x = initFraction(0, 0)
            return
        x.den *= y.num
        x.num *= y.den
        x.check_and_reduce()
    proc `>`*[T](x, y: Fraction[T]): bool =
        if isNaN(x) or isNaN(y): return false
        if x.den == 0 and y.den == 0: return x.num > y.num
        x.num * y.den > y.num * x.den
    proc `<`*[T](x, y: Fraction[T]): bool =
        if isNaN(x) or isNaN(y): return false
        if x.den == 0 and y.den == 0: return x.num < y.num
        x.num * y.den < y.num * x.den
    proc `==`*[T](x, y: Fraction[T]): bool =
        if isNaN(x) or isNaN(y): return false
        if x.den == 0 and y.den == 0: return (x.num div abs(x.num)) * (y.num div abs(y.num)) > 0
        x.num * y.den == y.num * x.den
    proc cmp*[T](x, y: Fraction[T]): int = (if x < y: -1 elif x == y: 0 else: 1)

    proc `+=`*[T](x: var Fraction[T], y: T) = (x += initFraction[T](y))
    proc `+`*[T](x, y: Fraction[T]): Fraction[T] = (result = x; result += y)
    proc `+`*[T](x: Fraction[T], y: T): Fraction[T] = (result = x; result += y)
    proc `+`*[T](x: T, y: Fraction[T]): Fraction[T] = (result = y; result += x)
    proc `-=`*[T](x: var Fraction[T], y: T) = (x -= initFraction[T](y))
    proc `-`*[T](x, y: Fraction[T]): Fraction[T] = (result = x; result -= y)
    proc `-`*[T](x: Fraction[T], y: T): Fraction[T] = (result = x; result -= y)
    proc `-`*[T](x: T, y: Fraction[T]): Fraction[T] = (result = -y; result += x)
    proc `*=`*[T](x: var Fraction[T], y: T) = (x *= initFraction[T](y))
    proc `*`*[T](x, y: Fraction[T]): Fraction[T] = (result = x; result *= y)
    proc `*`*[T](x: Fraction[T], y: T): Fraction[T] = (result = x; result *= y)
    proc `*`*[T](x: T, y: Fraction[T]): Fraction[T] = (result = y; result *= x)
    proc `/=`*[T](x: var Fraction[T], y: T) = (x /= initFraction[T](y))
    proc `/`*[T](x, y: Fraction[T]): Fraction[T] = (result = x; result /= y)
    proc `/`*[T](x: Fraction[T], y: T): Fraction[T] = (result = x; result /= y)
    proc `/`*[T](x: T, y: Fraction[T]): Fraction[T] = (result = y.inv(); result *= x)
    proc `>`*[T](x: Fraction[T], y: T): bool = x > initFraction[T](y)
    proc `>`*[T](x: T, y: Fraction[T]): bool = initFraction[T](x) > y
    proc `<=`*[T](x: Fraction[T], y: Fraction[T] or T): bool = not (x > y)
    proc `<=`*[T](x: T, y: Fraction[T]): bool = not(x > y)
    proc `<`*[T](x: Fraction[T], y: T): bool = x < initFraction[T](y)
    proc `<`*[T](x: T, y: Fraction[T]): bool = initFraction[T](x) < y
    proc `>=`*[T](x: Fraction[T], y: Fraction[T] or T): bool = not (x < y)
    proc `>=`*[T](x: T, y: Fraction[T]): bool = not(x < y)
    proc `==`*[T](x: Fraction[T], y: T): bool = x == initFraction[T](y)
    proc `==`*[T](x: T, y: Fraction[T]): bool = initFraction[T](x) == y
    proc cmp*[T](x: Fraction[T], y: T): int = cmp(x, initFraction[T](y))
    proc cmp*[T](x: T, y: Fraction[T]): int = cmp(initFraction[T](x), y)
    proc hash*[T](x: Fraction[T]): Hash =
        var x = x
        x.reduce()
        result = result !& hash(x.num)
        result = result !& hash(x.den)
    proc toFloat*[T](x: Fraction[T]): float =
        x.num / x.den
    proc pow*[T](x: Fraction[T], n: int): Fraction[T] =
        result = initFraction[T](1)
        var x = x
        var n = n
        while n > 0:
            if (n and 1) == 1: result *= x
            x *= x
            n = n shr 1
