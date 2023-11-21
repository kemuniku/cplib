when not declared CPLIB_ITERTOOLS_COMBINATIONS:
    const CPLIB_ITERTOOLS_COMBINATIONS* = 1
    import std/sequtils, std/algorithm
    iterator combinations*[T](v: seq[T], r: int): seq[T] =
        var x: seq[T]
        var stack = @[not 0, 0]
        while len(stack) != 0:
            var sindex = stack.pop()
            if sindex >= 0:
                if sindex != 0:
                    x.add(v[sindex-1])
                if len(x) == r:
                    yield x
                else:
                    for i in countdown(len(v)-(r-len(x)), sindex, 1):
                        stack.add(not(i+1))
                        stack.add(i+1)
            else:
                if sindex != -1:
                    discard x.pop()
