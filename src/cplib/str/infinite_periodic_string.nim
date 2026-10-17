## 非空の文字列 S を無限回繰り返したバイト列 SSS... を扱う。
## `initInfinitePeriodicString("ab")[3]` は 'b'、`[1..4]` は "baba"。
## `contains("babab")` は true、周期 "ab" と "abab" の無限列は等しい。
## UTF-8 もバイト単位で扱う。Unicode の文字単位の添字ではない。
##
## 添字は非負の int、slice は有限長だけを受け付ける。既定の実体化上限は
## 100万バイトで、slice の maxLength 引数で変更できる。増やした上限のメモリは
## 呼出側の責任で確保する。空周期・未初期化値は ValueError、負添字・不正区間は
## IndexDefect、取得長・上限の違反は ValueError を送出する。release でも検査する。
## 割当サイズの加算溢れを防ぐため length > high(int) div 2 は常に拒否する。
##
## 包含: 開始位置を周期長 p で剰余化できるため、先頭 p+m-1 バイトを
## KMP で探索すれば長さ m のパターンの全候補を判定できる。
## 比較: 共通接頭辞は周期 p と q を持つ。Fine-Wilf の定理により
## p+q-gcd(p,q) バイトが一致すれば gcd(p,q) 周期になり、両方の周期全体を
## 含むため無限列も一致する。最初の不一致で辞書順が決まる。
## 参考: https://arxiv.org/abs/0906.1780 (Fine-Wilf graphs)。
## どちらの走査も長さの和を計算せず2段階で行い、int の加算溢れを避ける。
when not declared CPLIB_STR_INFINITE_PERIODIC_STRING:
    const CPLIB_STR_INFINITE_PERIODIC_STRING* = 1
    import math

    const InfinitePeriodicStringDefaultSliceLimit* = 1_000_000

    type InfinitePeriodicString* = object
        ## 非空のバイト文字列を無限回繰り返した、0始まりの列。
        ## 長さと末尾を持たないため len、後ろからの添字、全体の実体化は提供しない。
        ## initInfinitePeriodicString で初期化する。既定値のオブジェクトは無効。
        period: string

    proc checkInitialized(S: InfinitePeriodicString) {.inline.} =
        ## 空周期・未初期化の列を拒否する。O(1)。
        if S.period.len == 0:
            raise newException(ValueError, "無限周期文字列の周期は非空である必要があります")

    proc initInfinitePeriodicString*(period: string): InfinitePeriodicString =
        ## 非空の周期から列を構築する。周期を所有し、時間・空間 O(period.len)。
        result.period = newString(period.len)
        for i, c in period:
            result.period[i] = c
        checkInitialized(result)

    proc `[]`*(S: InfinitePeriodicString, index: int): char {.inline.} =
        ## 非負の添字の文字を返す。high(int) まで時間・追加空間 O(1)。
        checkInitialized(S)
        if index < 0:
            raise newException(IndexDefect, "無限周期文字列の添字は非負である必要があります")
        S.period[index mod S.period.len]

    proc slice*(S: InfinitePeriodicString, first, length: int,
            maxLength: int = InfinitePeriodicStringDefaultSliceLimit): string =
        ## first から length バイトを取得する。時間・追加空間 O(length)。
        ## first、length、maxLength は非負。length > min(maxLength, high(int) div 2) は ValueError。
        ## 既定の実体化上限は100万バイト。上限を増やす場合は呼出側でメモリを確保する。
        ## first + length を計算しないため high(int) 近傍からの取得も可能。
        checkInitialized(S)
        if first < 0:
            raise newException(IndexDefect, "開始添字は非負である必要があります")
        if length < 0 or maxLength < 0 or length > maxLength or length > high(int) div 2:
            raise newException(ValueError, "取得長は非負かつ実体化上限以下である必要があります")
        result = newString(length)
        var position = first mod S.period.len
        for i in 0..<length:
            result[i] = S.period[position]
            inc position
            if position == S.period.len:
                position = 0

    proc `[]`*(S: InfinitePeriodicString, bounds: Slice[int]): string =
        ## 閉区間 a..b を取得する。時間・追加空間 O(b-a+1)、上限100万バイト。
        ## 空区間は a..a-1 のみ許可する。負添字と長さのオーバーフローを拒否する。
        checkInitialized(S)
        if bounds.a < 0 or bounds.b < bounds.a - 1:
            raise newException(IndexDefect, "区間は非負の添字または a..a-1 である必要があります")
        if bounds.b == bounds.a - 1:
            return ""
        let difference = bounds.b - bounds.a
        if difference >= InfinitePeriodicStringDefaultSliceLimit:
            raise newException(ValueError, "取得長が実体化上限を超えています")
        S.slice(bounds.a, difference + 1)

    proc contains*(S: InfinitePeriodicString, pattern: string): bool =
        ## 部分文字列を含むかを厳密に判定する。時間 O(p+m)、追加空間 O(m)。
        ## p は周期長、m は pattern.len。空パターンは常に含まれる。
        checkInitialized(S)
        if pattern.len == 0:
            return true
        var prefix = newSeq[int](pattern.len)
        for i in 1..<pattern.len:
            var matched = prefix[i - 1]
            while matched > 0 and pattern[i] != pattern[matched]:
                matched = prefix[matched - 1]
            if pattern[i] == pattern[matched]:
                inc matched
            prefix[i] = matched
        var matched = 0
        var position = 0
        # 開始位置は最初の p 箇所だけで十分。p+m-1 の加算は避ける。
        for count in [S.period.len, pattern.len - 1]:
            for i in 0..<count:
                let c = S.period[position]
                while matched > 0 and c != pattern[matched]:
                    matched = prefix[matched - 1]
                if c == pattern[matched]:
                    inc matched
                if matched == pattern.len:
                    return true
                inc position
                if position == S.period.len:
                    position = 0
        false

    proc contains*(S: InfinitePeriodicString, c: char): bool =
        ## 文字を含むかを判定する。時間 O(p)、追加空間 O(1)。
        checkInitialized(S)
        for value in S.period:
            if value == c:
                return true
        false

    proc cmp*(S, T: InfinitePeriodicString): int =
        ## 無限列の辞書順で -1/0/1 を返す。時間 O(p+q)、追加空間 O(1)。
        ## Fine-Wilf の定理により先頭 p+q-gcd(p,q) 文字が同じなら全体も同じ。
        ## 非最小周期も許可し、ハッシュ・LCM長の走査・長さの番兵は使わない。
        checkInitialized(S)
        checkInitialized(T)
        var left = 0
        var right = 0
        for count in [S.period.len, T.period.len - gcd(S.period.len, T.period.len)]:
            for i in 0..<count:
                if S.period[left] < T.period[right]:
                    return -1
                if S.period[left] > T.period[right]:
                    return 1
                inc left
                if left == S.period.len:
                    left = 0
                inc right
                if right == T.period.len:
                    right = 0
        0

    proc `==`*(S, T: InfinitePeriodicString): bool {.inline.} =
        ## 無限列の一致を厳密に判定する。時間 O(p+q)、追加空間 O(1)。
        cmp(S, T) == 0

    proc `<`*(S, T: InfinitePeriodicString): bool {.inline.} =
        ## 無限列の辞書順を比較する。時間 O(p+q)、追加空間 O(1)。
        cmp(S, T) < 0

    proc `<=`*(S, T: InfinitePeriodicString): bool {.inline.} =
        ## 無限列の辞書順を比較する。時間 O(p+q)、追加空間 O(1)。
        cmp(S, T) <= 0

    proc `>`*(S, T: InfinitePeriodicString): bool {.inline.} =
        ## 無限列の辞書順を比較する。時間 O(p+q)、追加空間 O(1)。
        cmp(S, T) > 0

    proc `>=`*(S, T: InfinitePeriodicString): bool {.inline.} =
        ## 無限列の辞書順を比較する。時間 O(p+q)、追加空間 O(1)。
        cmp(S, T) >= 0
