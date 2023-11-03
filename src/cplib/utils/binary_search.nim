when not declared CPLIB_MISC_BINARY_SEARCH:
    const CPLIB_MISC_BINARY_SEARCH* = 1
    proc meguru_bisect*(mn, mx: int, is_ok: proc(x: int): bool): int =
        var
            ok = mn
            ng = mx
        while abs(ok - ng) > 1:
            var mid = (ok + ng) div 2
            if is_ok(mid): ok = mid
            else: ng = mid
        return ok

    proc meguru_bisect*(mn, mx: SomeFloat, is_ok: proc(x: SomeFloat): bool,
            eps: SomeFloat = 1e-10): SomeFloat =
        var
            ok = mn
            ng = mx
        while abs(ok - ng) > eps and abs(ok - ng) / max(ok, ng) > eps:
            var mid = (ok + ng) / 2
            if is_ok(mid): ok = mid
            else: ng = mid
        return ok
