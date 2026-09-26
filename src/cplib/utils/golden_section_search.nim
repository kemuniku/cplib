when not declared CPLIB_UTILS_GOLDEN_SECTION_SEARCH:
    const CPLIB_UTILS_GOLDEN_SECTION_SEARCH* = 1

    proc golden_section_search*[T: SomeFloat](l, r: T, f: proc(x: T): T,
            iterations: int = 100, maximize: bool = false): tuple[x, fx: T] =
        ## 閉区間 [l, r] の単峰関数の最適点と関数値を、O(iterations + 1) 回の評価で近似する。
        ## 最小化では最小区間の前後で狭義減少・狭義増加を仮定する。最大化では逆。
        ## 有限の l <= r と非負の iterations を指定する。端点も候補に含む。
        ## 初期評価後に最大 iterations 回更新し、丸めで分割できなくなれば終了する。
        ## f の比較結果に NaN を含めないこと。反復回数は誤差を保証しない。
        assert l <= r, "探索区間には l <= r が必要です"
        assert iterations >= 0, "反復回数は非負である必要があります"

        template better(a, b: untyped): bool =
            (if maximize: b < a else: a < b)

        proc interpolate(a, b, t: T): T =
            ## 区間が 0 をまたぐ場合にも差のオーバーフローを避けて内分する。
            if a <= T(0) and T(0) <= b:
                a * (T(1) - t) + b * t
            else:
                a + (b - a) * t

        let fl = f(l)
        result = (l, fl)
        if l == r: return
        let fr = f(r)
        if better(fr, result.fx): result = (r, fr)

        template evaluate(position: T): T =
            block:
                let x = position
                let fx = if x == l: fl elif x == r: fr else: f(x)
                if better(fx, result.fx): result = (x, fx)
                fx

        const ratio = 0.6180339887498948482
        var
            left = l
            right = r
            x1 = interpolate(left, right, T(1) - T(ratio))
            x2 = interpolate(left, right, T(ratio))
            f1 = evaluate(x1)
            f2 = f1
        if x1 != x2: f2 = evaluate(x2)
        for _ in 0..<iterations:
            if not (left < x1 and x1 < x2 and x2 < right): break
            if better(f2, f1):
                left = x1
                x1 = x2
                f1 = f2
                let next = interpolate(left, right, T(ratio))
                if not (x1 < next and next < right): break
                x2 = next
                f2 = evaluate(x2)
            else:
                right = x2
                x2 = x1
                f2 = f1
                let next = interpolate(left, right, T(1) - T(ratio))
                if not (left < next and next < x2): break
                x1 = next
                f1 = evaluate(x1)

    proc golden_section_search*[V](l, r: int, f: proc(x: int): V,
            maximize: bool = false): tuple[x: int, fx: V] =
        ## 閉区間 [l, r] の単峰関数の最適点と関数値を、O(log(r - l + 2)) 回の評価で求める。
        ## 整数版はフィボナッチ探索を使い、同じ点を再評価しない。V には < のみ必要。
        ## 最小化では最小区間の前後で狭義減少・狭義増加を仮定する。最大化では逆。
        ## l <= r とし、複数の最適点がある場合はそのうち 1 点を返す。
        assert l <= r, "探索区間には l <= r が必要です"

        mixin `<`

        proc position(offset: uint): int =
            ## 符号付き整数の全範囲で、左端からの距離を座標へ戻す。
            cast[int](cast[uint](l) + offset)

        let width = cast[uint](r) - cast[uint](l)
        var
            a = 1'u
            b = 1'u
        # 仮想区間の点数 a + b - 1 が実区間を覆うまで拡張する。
        while a - 1 < width - (b - 1):
            (a, b) = (b, a + b)

        var
            offset = 0'u
            f1 = f(position(a - 1))
            f2: V
            valid2 = true
        if a == b: return (l, f1)
        f2 = f(position(b - 1))
        while a != b:
            let takeRight = valid2 and (if maximize: f1 < f2 else: f2 < f1)
            if not takeRight:
                (a, b) = (b - a, a)
                f2 = f1
                valid2 = true
                if a != b: f1 = f(position(offset + a - 1))
            else:
                offset += a
                (a, b) = (b - a, a)
                f1 = f2
                # 右端を越える仮想点は評価せず、常に実区間の点を優先する。
                valid2 = b - 1 <= width - offset
                if a != b and valid2: f2 = f(position(offset + b - 1))
        return (position(offset), f1)
