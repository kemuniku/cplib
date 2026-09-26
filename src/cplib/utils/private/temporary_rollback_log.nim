when not declared CPLIB_UTILS_PRIVATE_TEMPORARY_ROLLBACK_LOG:
    const CPLIB_UTILS_PRIVATE_TEMPORARY_ROLLBACK_LOG* = 1
    import tables, typetraits

    type
        TemporaryLocation = tuple[address: pointer, size: int]
        TemporaryIndexCache* = object
            stamps: seq[int]
            owner: pointer
            base: pointer
            size, length: int
        TemporaryEntry = object
            location: TemporaryLocation
            previous: int
            offset: int
            stamp: ptr int
        TemporaryRollbackLog* = object
            entries: seq[TemporaryEntry]
            latest: Table[TemporaryLocation, int]
            scopeStart: int
            saved: seq[byte]
            used: int
            caches: seq[ptr TemporaryIndexCache]
        TemporaryCheckpoint* = tuple[position, parentStart: int]

    proc len*(history: TemporaryRollbackLog): int =
        ## 現在保存している復元処理の数を返す。O(1)。
        history.entries.len

    proc indexCapacity*(cache: TemporaryIndexCache): int =
        ## 再利用する添字判定領域の長さを返す。O(1)。
        cache.stamps.len

    proc saveValue[T](history: var TemporaryRollbackLog, location: ptr T,
            previous: int, stamp: ptr int = nil) =
        ## 初回の値を連続バッファへ保存する。時間・領域は値のサイズに比例する。
        when not supportsCopyMem(T):
            {.error: "Temporaryの履歴には参照管理や独自のコピー・破棄処理を必要としない型だけ保存できます".}
        let key: TemporaryLocation = (cast[pointer](location), sizeof(T))
        let offset = history.used
        let required = offset + sizeof(T)
        when sizeof(T) > 0:
            if required > history.saved.len:
                let capacity = max(required, max(64, history.saved.len * 2))
                when declared(newSeqUninit):
                    var grown = newSeqUninit[byte](capacity)
                else:
                    var grown = newSeqUninitialized[byte](capacity)
                if offset > 0:
                    copyMem(addr grown[0], addr history.saved[0], offset)
                history.saved = move(grown)
            copyMem(addr history.saved[offset], location, sizeof(T))
        history.entries.add(TemporaryEntry(location: key, previous: previous, offset: offset, stamp: stamp))
        history.used = required

    proc remember*[T](history: var TemporaryRollbackLog, location: ptr T) =
        ## 同じスコープでは同じアドレス・サイズの最初の値だけを保存する。重複判定は期待O(1)。
        let key: TemporaryLocation = (cast[pointer](location), sizeof(T))
        let latest = addr history.latest.mgetOrPut(key, -1)
        let previous = latest[]
        if previous >= history.scopeStart: return
        let index = history.entries.len
        history.saveValue(location, previous)
        latest[] = index

    proc rememberIndexed*[T](history: var TemporaryRollbackLog, location, base: ptr T,
            length: int, cache: var TemporaryIndexCache) =
        ## 配列要素を添字で判定する。領域拡張は償却O(増加分)、通常の判定はO(1)。
        ## 配列の混在や再入時はハッシュ判定へ戻し、使用中の判定領域を変更しない。
        when sizeof(T) == 0:
            history.remember(location)
        else:
            let owner = cast[pointer](addr history)
            if cache.owner == nil:
                if length > cache.stamps.len: cache.stamps.setLen(length)
                cache.owner = owner
                cache.base = cast[pointer](base)
                cache.size = sizeof(T)
                cache.length = length
                history.caches.add(addr cache)
            if cache.owner != owner or cache.base != cast[pointer](base) or
                    cache.size != sizeof(T) or cache.length != length:
                history.remember(location)
                return
            let offset = cast[uint](location) - cast[uint](base)
            let index = offset div uint(sizeof(T))
            if index >= uint(length) or offset mod uint(sizeof(T)) != 0:
                history.remember(location)
                return
            let stamp = addr cache.stamps[int(index)]
            let previous = stamp[] - 1
            if previous >= history.scopeStart: return
            let entry = history.entries.len
            history.saveValue(location, previous, stamp)
            stamp[] = entry + 1

    proc restore*(history: var TemporaryRollbackLog, position: int) =
        ## 保存順の逆順で復元する。範囲が重なる値も最初の状態へ戻る。
        ## 保存バッファは縮めず、同じ履歴で次に保存する際に再利用する。
        while history.entries.len > position:
            let entry = history.entries.pop()
            if entry.location.size > 0:
                copyMem(entry.location.address, addr history.saved[entry.offset], entry.location.size)
            history.used = entry.offset
            if entry.stamp != nil:
                # 訪問した添字だけを戻すため、繰り返し実行時の全初期化は不要。
                entry.stamp[] = entry.previous + 1
            elif entry.previous < 0:
                history.latest.del(entry.location)
            else:
                history.latest[entry.location] = entry.previous
        if history.entries.len == 0:
            for cache in history.caches: cache.owner = nil
            history.caches.setLen(0)

    proc beginTemporary*(history: var TemporaryRollbackLog): TemporaryCheckpoint =
        ## 入れ子の開始位置を保存し、新しいスコープで重複を判定する。O(1)。
        result = (history.entries.len, history.scopeStart)
        history.scopeStart = history.entries.len

    proc endTemporary*(history: var TemporaryRollbackLog, checkpoint: TemporaryCheckpoint) =
        ## 入れ子の変更を復元し、親スコープの重複判定に戻す。
        history.restore(checkpoint.position)
        history.scopeStart = checkpoint.parentStart
