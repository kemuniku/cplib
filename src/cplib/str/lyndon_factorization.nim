when not declared CPLIB_STR_LYNDON_FACTORIZATION:
    const CPLIB_STR_LYNDON_FACTORIZATION* = 1

    proc lyndon_factorization*[T](s: openArray[T]): seq[(int, int)] =
        ## Duval's algorithmで`s`をLyndon語へ分解する。
        ##
        ## 各要素はLyndon語に対応する半開区間`[l, r)`であり、区間は
        ## `s`全体を順に被覆する。計算量はO(|s|)、追加領域は結果を除きO(1)。
        var i = 0
        while i < s.len:
            var j = i + 1
            var k = i
            while j < s.len and not (s[j] < s[k]):
                if s[k] < s[j]:
                    k = i
                else:
                    k += 1
                j += 1

            let length = j - k
            while i <= k:
                result.add((i, i + length))
                i += length
