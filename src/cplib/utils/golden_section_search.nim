when not declared CPLIB_UTILS_GOLDEN_SECTION_SEARCH:
    const CPLIB_UTILS_GOLDEN_SECTION_SEARCH* = 1
    proc init_golden_div(): array[90, int] =
        var t: array[90, int]
        t[0] = 1
        t[1] = 1
        for i in 2..<t.len: t[i] = t[i-1] + t[i-2]
        return t
    const golden_div = init_golden_div()
    proc golden_section_search*[T](l, r: int, f: proc(x: int): T): int =
        ## [l, r)の範囲でf(x)が最小となるxを返します。
        ## （値ではなくインデックスを返す）
        if r - l == 1: return l
        var k = -1
        for i in 0..<golden_div.len-1:
            if l + golden_div[i] + 2 * golden_div[i+1] >= r:
                k = i
                break
        assert(k != -1, "sectoin too large")
        var p1 = l
        var p2 = p1 + golden_div[k+1]
        var p3 = p2 + golden_div[k]
        var p4 = p3 + golden_div[k+1]
        var v2, v3: T
        if p2 in l..<r: v2 = f(p2)
        if p3 in l..<r: v3 = f(p3)
        for k in countdown(k, 1):
            proc move_lower() =
                p4 = p3
                p3 = p2
                v3 = v2
                p2 = p1 + golden_div[k]
                if p2 in l..<r: v2 = f(p2)
            proc move_upper() =
                p1 = p2
                p2 = p3
                v2 = v3
                p3 = p2 + golden_div[k-1]
                if p3 in l..<r: v3 = f(p3)
            if p3 notin l..<r:
                move_lower()
                continue
            if v2 < v3:
                move_lower()
            else:
                move_upper()
        var ans = f(p1)
        var p = p1
        if p2 in l..<r and v2 < ans:
            ans = v2
            p = p2
        if p3 in l..<r and v3 < ans:
            ans = v3
            p = p3
        if p4 in l..<r:
            var x = f(p4)
            if x < ans:
                ans = x
                p = p4
        return p

