when not declared CPLIB_UTILS_GOLDEN_SECTION_SEARCH:
    const CPLIB_UTILS_GOLDEN_SECTION_SEARCH* = 1

    import std/math

    proc goldenSectionSearch*[F](left, right: int, f: F): int =
        ## Finds the leftmost minimum of a discrete unimodal function on
        ## the inclusive interval `[left, right]`.
        ##
        ## `f` must first be non-increasing and then non-decreasing.
        ## The number of calls to `f` is O(log(right - left)).
        doAssert left <= right
        const ratio = (3.0 - sqrt(5.0)) / 2.0
        var
            left = left
            right = right
        while right - left > 3:
            let width = right - left
            let x1 = left + max(1, int(float64(width) * ratio))
            let x2 = right - max(1, int(float64(width) * ratio))
            if f(x1) <= f(x2):
                right = x2
            else:
                left = x1

        result = left
        var best = f(left)
        for x in left + 1..right:
            let value = f(x)
            if value < best:
                result = x
                best = value

    proc goldenSectionSearch*[T: SomeFloat, F](left, right: T, f: F,
            eps: T = T(1e-10)): T =
        ## Approximates a minimum of a unimodal function on `[left, right]`.
        ##
        ## Search stops when the interval width is at most `eps` times the
        ## larger of 1 and the absolute values of its endpoints.
        doAssert left <= right
        doAssert eps > T(0)
        let ratio = T((sqrt(5.0) - 1.0) / 2.0)
        var
            left = left
            right = right
            x1 = right - ratio * (right - left)
            x2 = left + ratio * (right - left)
            value1 = f(x1)
            value2 = f(x2)
        while right - left > eps * max(T(1), max(abs(left), abs(right))):
            if value1 <= value2:
                right = x2
                x2 = x1
                value2 = value1
                x1 = right - ratio * (right - left)
                value1 = f(x1)
            else:
                left = x1
                x1 = x2
                value1 = value2
                x2 = left + ratio * (right - left)
                value2 = f(x2)
        return (left + right) / T(2)
