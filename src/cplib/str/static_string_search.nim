when not declared CPLIB_STR_STATIC_STRING_SEARCH:
    const CPLIB_STR_STATIC_STRING_SEARCH* = 1
    import tables
    import cplib/str/static_string
    import cplib/collections/staticRMQ
    import cplib/collections/waveletmatrix

    type StaticStringSearch*[T] = object
        base: StaticStringBase[T]
        wm: WaveletMatrix

    type StaticStringSearchView*[T] = object
        search: StaticStringSearch[T]
        target: StaticString[T]

    type StaticStringSearchCacheEntry[T] = ref object of RootObj
        search: StaticStringSearch[T]

    # 索引が基底を保持するため、登録中に同じアドレスが別の基底へ再利用されることはない。
    var staticStringSearchCache: Table[pointer, RootRef]

    proc clearStaticStringSearchCache*[T](base: StaticStringBase[T]) =
        ## 指定した基底の索引をキャッシュから除く。保持済みの検索オブジェクトは引き続き使える。
        staticStringSearchCache.del(cast[pointer](base))

    proc clearStaticStringSearchCache*() =
        ## 全ての型・基底の索引とキャッシュの領域を手放す。保持済みの検索オブジェクトは引き続き使える。
        staticStringSearchCache = default(Table[pointer, RootRef])

    proc initStaticStringSearch*[T](base: StaticStringBase[T]): StaticStringSearch[T] =
        ## 基底ごとの索引を取得する。初回 O(N log(N+2)) 時間、再取得は期待 O(1) 時間。N は base.S.len。
        ## キャッシュは clearStaticStringSearchCache を呼ぶまで索引と基底を保持する。
        let key = cast[pointer](base)
        let existing = staticStringSearchCache.getOrDefault(key)
        if existing != nil:
            return StaticStringSearchCacheEntry[T](existing).search
        result.base = base
        var positions = newSeq[int](base.SA.len)
        for i, position in base.SA:
            positions[i] = int(position)
        result.wm = initWaveletMatrix(positions)
        staticStringSearchCache[key] = StaticStringSearchCacheEntry[T](search: result)

    proc suffixRange[T](search: StaticStringSearch[T], pattern: StaticString[T]): tuple[first, last: int] =
        ## 空でない pattern を接頭辞に持つ接尾辞の SA 上の半開区間を O(log(N+2)) 時間で求める。
        let m = len(pattern)
        let rank = int(search.base.RSA[pattern.l])
        var left = 0
        var right = rank
        while left < right:
            let mid = (left + right) shr 1
            if search.base.RMQ.query(mid, rank) >= m:
                right = mid
            else:
                left = mid + 1
        result.first = left

        left = rank
        right = search.base.SA.len - 1
        while left < right:
            let mid = (left + right + 1) shr 1
            if search.base.RMQ.query(rank, mid) >= m:
                left = mid
            else:
                right = mid - 1
        result.last = left + 1

    proc count*[Element](search: StaticStringSearch[Element], S, T: StaticString[Element]): int =
        ## 同じ基底の S 内で重複を許した T の出現回数を O(log(N+2)) 時間で返す。空の T は len(S)+1 回。
        assert S.base == search.base and T.base == search.base, "文字列は検索用索引と同じ基底文字列から作成されている必要があります"
        let m = len(T)
        if m == 0:
            return len(S) + 1
        if m > len(S):
            return 0
        let (first, last) = search.suffixRange(T)
        return search.wm.range_freq(first, last, int(S.l), int(S.r) - m + 1)

    proc contains*[Element](search: StaticStringSearch[Element], S, T: StaticString[Element]): bool =
        ## 同じ基底の S に T が含まれるか O(log(N+2)) 時間で判定する。空の T は常に含まれる。
        return search.count(S, T) > 0

    iterator findAll*[Element](search: StaticStringSearch[Element], S, T: StaticString[Element]): int =
        ## 同じ基底の S 内で重複を許した T の出現位置を、S の先頭を 0 とする昇順で列挙する。
        ## 準備と各要素の取得は O(log(N+2)) 時間、追加空間は O(1)。空の T は 0..len(S) を列挙する。
        assert S.base == search.base and T.base == search.base, "文字列は検索用索引と同じ基底文字列から作成されている必要があります"
        let m = len(T)
        if m == 0:
            for position in 0..len(S):
                yield position
        elif m <= len(S):
            let (first, last) = search.suffixRange(T)
            let begin = search.wm.range_lowerbound(first, last, int(S.l))
            let finish = search.wm.range_lowerbound(first, last, int(S.r) - m + 1)
            for k in begin..<finish:
                yield search.wm.kth_smallest(first, last, k) - int(S.l)

    proc count*[Element](S, T: StaticString[Element]): int =
        ## 同じ基底の S 内で重複を許した T の出現回数を返す。空の T は len(S)+1 回。
        ## 索引が必要な初回は O(N log(N+2)) 時間、構築後は期待 O(log(N+2)) 時間。
        assert S.base == T.base, "文字列は同じ基底文字列から作成されている必要があります"
        if len(T) == 0:
            return len(S) + 1
        if len(T) > len(S):
            return 0
        return initStaticStringSearch(S.base).count(S, T)

    proc contains*[Element](S, T: StaticString[Element]): bool =
        ## 同じ基底の S に T が含まれるか判定する。T in S と書ける。空の T は常に含まれる。
        ## 索引が必要な初回は O(N log(N+2)) 時間、構築後は期待 O(log(N+2)) 時間。
        return count(S, T) > 0

    iterator findAll*[Element](S, T: StaticString[Element]): int =
        ## S の先頭を 0 とする出現位置を重複を許して昇順に列挙する。空の T は 0..len(S)。
        ## 初回は必要なら索引を構築する。構築後の準備は期待 O(log(N+2))、各要素は O(log(N+2)) 時間、追加空間は O(1)。
        assert S.base == T.base, "文字列は同じ基底文字列から作成されている必要があります"
        if len(T) == 0:
            for position in 0..len(S):
                yield position
        elif len(T) <= len(S):
            let search = initStaticStringSearch(S.base)
            for position in search.findAll(S, T):
                yield position

    proc `[]`*[T](search: StaticStringSearch[T], target: StaticString[T]): StaticStringSearchView[T] {.inline.} =
        ## 同じ基底の target と索引を O(1) 時間で組にし、pattern in search[target] と書けるようにする。
        assert target.base == search.base, "文字列は検索用索引と同じ基底文字列から作成されている必要があります"
        return StaticStringSearchView[T](search: search, target: target)

    proc contains*[T](target: StaticStringSearchView[T], pattern: StaticString[T]): bool {.inline.} =
        ## 検索対象に pattern が含まれるか O(log(N+2)) 時間で判定する。in と notin に対応する。
        return target.search.contains(target.target, pattern)

    proc count*[T](target: StaticStringSearchView[T], pattern: StaticString[T]): int {.inline.} =
        ## 検索対象内で重複を許した pattern の出現回数を O(log(N+2)) 時間で返す。空の pattern は対象長+1 回。
        return target.search.count(target.target, pattern)

    iterator findAll*[T](target: StaticStringSearchView[T], pattern: StaticString[T]): int =
        ## 対象の先頭を 0 とする出現位置を昇順で列挙する。準備と各要素の取得は O(log(N+2)) 時間、追加空間は O(1)。
        for position in target.search.findAll(target.target, pattern):
            yield position
