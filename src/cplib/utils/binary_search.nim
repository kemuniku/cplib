when not declared CPLIB_UTILS_BINARY_SEARCH:
    const CPLIB_UTILS_BINARY_SEARCH* = 1
    proc meguru_bisect*(ok, ng: int, is_ok: proc(x: int): bool): int =
        ## 単調な判定関数の境界となるok側の整数を求める。O(log(|ok-ng| + 1))。
        var
            ok = ok
            ng = ng
        while ok != ng and (if ok < ng: ok < ng - 1 else: ng < ok - 1):
            let mid = ok div 2 + ng div 2 + (ok mod 2 + ng mod 2) div 2
            if is_ok(mid): ok = mid
            else: ng = mid
        return ok

    proc meguru_bisect*(ok, ng: SomeFloat, is_ok: proc(x: SomeFloat): bool, eps: SomeFloat = 1e-10): SomeFloat =
        var
            ok = ok
            ng = ng
        while abs(ok - ng) > eps and abs(ok - ng) / max(abs(ok), abs(ng)) > eps:
            var mid = (ok + ng) / 2
            if is_ok(mid): ok = mid
            else: ng = mid
        return ok
