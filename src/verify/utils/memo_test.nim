import cplib/utils/memo

block:
    var calls = 0
    proc fib(n: int): int {.memo.} =
        inc calls
        if n <= 1:
            return n
        fib(n - 1) + fib(n - 2)

    doAssert fib(10) == 55
    doAssert calls == 11
    doAssert fib(10) == 55
    doAssert calls == 11

block:
    var redCalls, blueCalls = 0
    proc red(n: int): int
    proc blue(n: int): int

    proc red(n: int): int {.memo.} =
        inc redCalls
        if n == 1:
            return 0
        return red(n - 1) + blue(n) * 2

    proc blue(n: int): int {.memo.} =
        inc blueCalls
        if n == 1:
            return 1
        return red(n - 1) + blue(n - 1) * 3

    doAssert red(4) == 198
    doAssert blue(4) == 81
    doAssert redCalls == 4 and blueCalls == 4
    doAssert red(4) == 198
    doAssert blue(4) == 81
    doAssert redCalls == 4 and blueCalls == 4

block:
    var calls = 0
    proc choose(n, k: int): int {.memo.} =
        inc calls
        if k == 0 or k == n:
            return 1
        choose(n - 1, k - 1) + choose(n - 1, k)

    doAssert choose(6, 3) == 20
    let cachedCalls = calls
    doAssert choose(6, 3) == 20
    doAssert calls == cachedCalls

block:
    var calls = 0
    proc retry(n: int): int {.memo.} =
        inc calls
        if calls == 1:
            raise newException(ValueError, "retry")
        result = n * 2

    var raised = false
    try:
        discard retry(3)
    except ValueError:
        raised = true
    doAssert raised
    doAssert retry(3) == 6
    doAssert retry(3) == 6
    doAssert calls == 2
