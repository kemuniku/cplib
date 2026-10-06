when not declared CPLIB_COLLECTIONS_PERSISTENT_MULTISET:
    const CPLIB_COLLECTIONS_PERSISTENT_MULTISET* = 1
    import algorithm
    import cplib/collections/persistent_sequence

    type PersistentMultiset*[T] = object
        values: PersistentSequence[T, PersistentSequenceNoAction]
        compare: proc(a, b: T): int

    proc initPersistentMultiset*[T](values: openArray[T], compare: proc(a, b: T): int): PersistentMultiset[T] =
        ## 重複を保持する永続multisetをO(N log(N+1))、整列済みならO(N)で構築します。compareは純粋な厳密弱順序とします。
        if compare == nil: raise newException(ValueError, "比較関数が未指定です")
        var sorted = @values
        var ordered = true
        for i in 1..<sorted.len:
            if compare(sorted[i - 1], sorted[i]) > 0:
                ordered = false
                break
        if not ordered: sorted.sort(compare)
        result.values = initPersistentSequence(sorted)
        result.compare = compare

    proc initPersistentMultiset*[T](values: openArray[T]): PersistentMultiset[T] =
        ## 標準比較による永続multisetをO(N log(N+1))で構築します。
        initPersistentMultiset(values, proc(a, b: T): int = cmp(a, b))

    proc len*[T](s: PersistentMultiset[T]): int =
        ## 重複を含む要素数をO(1)で返します。
        s.values.len

    proc lower_bound*[T](s: PersistentMultiset[T], value: T): int =
        ## value未満の要素数をO(log(N+1))で返します。
        s.values.partition_point(proc(x: T): bool = s.compare(x, value) < 0)

    proc upper_bound*[T](s: PersistentMultiset[T], value: T): int =
        ## value以下の要素数をO(log(N+1))で返します。
        s.values.partition_point(proc(x: T): bool = s.compare(x, value) <= 0)

    proc count*[T](s: PersistentMultiset[T], value: T): int =
        ## 比較で同値な要素の個数をO(log(N+1))で返します。
        s.upper_bound(value) - s.lower_bound(value)

    proc contains*[T](s: PersistentMultiset[T], value: T): bool =
        ## 比較で同値な要素が存在するかO(log(N+1))で返します。
        let rank = s.lower_bound(value)
        rank < s.len and s.compare(s.values[rank], value) == 0

    proc kth*[T](s: PersistentMultiset[T], k: int): T =
        ## 比較順で0始まりのk番目をO(log(N+1))で返します。
        s.values[k]

    proc `[]`*[T](s: PersistentMultiset[T], k: int): T =
        ## 比較順で0始まりのk番目をO(log(N+1))で返します。
        s.kth(k)

    proc insert*[T](s: PersistentMultiset[T], value: T): PersistentMultiset[T] =
        ## 同値要素の後に一個追加した版を返します。時間・追加領域O(log(N+1))。
        result = s
        result.values = s.values.insert(s.upper_bound(value), value)

    proc erase*[T](s: PersistentMultiset[T], value: T): PersistentMultiset[T] =
        ## 最初の同値要素を一個削除した版を返します。不在なら同じ版。時間・追加領域O(log(N+1))。
        let k = s.lower_bound(value)
        if k == s.len or s.compare(s[k], value) != 0: return s
        result = s
        result.values = s.values.erase(k)

    proc erase_all*[T](s: PersistentMultiset[T], value: T): PersistentMultiset[T] =
        ## 同値要素をすべて削除した版を返します。時間・追加領域O(log(N+1))。
        result = s
        result.values = s.values.erase(s.lower_bound(value), s.upper_bound(value))

    proc split*[T](s: PersistentMultiset[T], value: T): tuple[left, right: PersistentMultiset[T]] =
        ## value未満と以上に分割します。時間・追加領域O(log(N+1))。
        let p = s.values.split(s.lower_bound(value))
        (PersistentMultiset[T](values: p.left, compare: s.compare), PersistentMultiset[T](values: p.right, compare: s.compare))

    proc concat*[T](a, b: PersistentMultiset[T]): PersistentMultiset[T] =
        ## 同じ設定から派生しmax(a)<=min(b)のmultisetを連結します。時間・追加領域O(log(N+1))。
        discard a.len
        discard b.len
        if a.len > 0 and b.len > 0 and a.compare(a[a.len - 1], b[0]) > 0:
            raise newException(ValueError, "multisetの連結順序が不正です")
        result = a
        result.values = a.values.concat(b.values)

    proc to_seq*[T](s: PersistentMultiset[T]): seq[T] =
        ## 比較順で要素を列挙します。時間・返り値の領域O(N)。
        s.values.to_seq
