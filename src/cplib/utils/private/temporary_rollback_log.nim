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
            initial, flatId: int
            saved: seq[byte]
        TemporaryEntry = object
            location: TemporaryLocation
            previous: int
            offset: int # 小さい値はその値、大きい値はsaved内の位置。
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
        ## 初回の値を保存する。int以下は履歴要素内、それ以外は連続バッファへ保存する。O(sizeof(T))。
        when not supportsCopyMem(T):
            {.error: "Temporaryの履歴には参照管理や独自のコピー・破棄処理を必要としない型だけ保存できます".}
        let key: TemporaryLocation = (cast[pointer](location), sizeof(T))
        var offset = 0
        when sizeof(T) <= sizeof(int):
            # 小さい値は履歴要素に直接保存し、別バッファの操作を省く。
            when sizeof(T) > 0:
                copyMem(addr offset, location, sizeof(T))
        else:
            offset = history.used
            let required = offset + sizeof(T)
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
            history.used = required
        history.entries.add(TemporaryEntry(location: key, previous: previous, offset: offset, stamp: stamp))

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
            if entry.location.size > sizeof(int):
                copyMem(entry.location.address, addr history.saved[entry.offset], entry.location.size)
                history.used = entry.offset
            elif entry.location.size > 0:
                copyMem(entry.location.address, unsafeAddr entry.offset, entry.location.size)
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

    type
        FlatTemporaryRollbackLog* = object
            entries: seq[uint64]
            raw: TemporaryRollbackLog

    proc len*(history: FlatTemporaryRollbackLog): int =
        ## 一括復元までに保存した履歴数を返す。O(1)。
        history.entries.len

    proc remember*[T](history: var FlatTemporaryRollbackLog, location: ptr T) =
        ## 領域を特定できない更新は重複判定せず保存する。時間・領域は値のサイズに比例する。
        history.raw.saveValue(location, 0)
        history.entries.add(0)

    proc bindFlatIndexCache*[T](history: var FlatTemporaryRollbackLog, base: ptr T,
            length: int, cache: var TemporaryIndexCache): ptr TemporaryIndexCache =
        ## 配列と保存領域を対応付ける。既に別領域・実行が使用中ならnilを返す。拡張は償却O(増加分)。
        when sizeof(T) == 0:
            return nil
        else:
            if length <= 0 or uint64(length) > 0x100000000'u64 or
                    history.raw.caches.len >= high(int32).int:
                return nil
            let owner = cast[pointer](addr history)
            if cache.owner == nil:
                let words = (length - 1) div (sizeof(int) * 8) + 1
                if words > cache.stamps.len: cache.stamps.setLen(words)
                cache.owner = owner
                cache.base = cast[pointer](base)
                cache.size = sizeof(T)
                cache.length = length
                cache.initial = 0
                when sizeof(T) <= sizeof(int):
                    copyMem(addr cache.initial, base, sizeof(T))
                cache.flatId = history.raw.caches.len
                history.raw.caches.add(addr cache)
            if cache.owner == owner and cache.base == cast[pointer](base) and
                    cache.size == sizeof(T) and cache.length == length:
                return addr cache
            return nil

    proc recordFlatIndex[T](history: var FlatTemporaryRollbackLog, location: ptr T,
            index: int, cache: var TemporaryIndexCache) {.inline.} =
        ## 対応付け済みの配列の初回変更を保存する。判定O(1)、保存O(sizeof(T))。
        let word = index div (sizeof(int) * 8)
        let mask = 1 shl (index mod (sizeof(int) * 8))
        if (cache.stamps[word] and mask) != 0: return
        var savedSeparately = true
        when sizeof(T) <= sizeof(int):
            var previous = 0
            copyMem(addr previous, location, sizeof(T))
            if previous == cache.initial: savedSeparately = false
        if savedSeparately:
            let required = cache.length * sizeof(T)
            if cache.saved.len < required:
                # 各添字は初回の保存後にだけ読むため、拡張分の初期化は不要。
                let capacity = max(required, max(64, cache.saved.len * 2))
                when declared(newSeqUninit):
                    cache.saved = newSeqUninit[byte](capacity)
                else:
                    cache.saved = newSeqUninitialized[byte](capacity)
            copyMem(addr cache.saved[index * sizeof(T)], location, sizeof(T))
        # 配列番号・添字・保存先の種別を8バイトにまとめる。
        let encoded = (uint64(cache.flatId + 1) shl 32) or uint64(index) or
            (if savedSeparately: 1'u64 shl 63 else: 0'u64)
        history.entries.add(encoded)
        cache.stamps[word] = cache.stamps[word] or mask

    proc rememberBound*[T](history: var FlatTemporaryRollbackLog, location: ptr T,
            cache: ptr TemporaryIndexCache) {.inline.} =
        ## 実行前に対応付けた配列の変更を保存する。変更先はその配列内であること。
        when sizeof(T) == 0:
            history.remember(location)
        else:
            if cache == nil:
                history.remember(location)
                return
            let offset = cast[uint](location) - cast[uint](cache.base)
            let index = offset div uint(sizeof(T))
            assert index < uint(cache.length) and offset mod uint(sizeof(T)) == 0
            history.recordFlatIndex(location, int(index), cache[])

    proc rememberIndexed*[T](history: var FlatTemporaryRollbackLog, location, base: ptr T,
            length: int, cache: var TemporaryIndexCache) {.inline.} =
        ## 実行時に配列を確認して変更を保存する。判定O(1)、保存O(sizeof(T))、拡張は償却O(増加分)。
        when sizeof(T) == 0:
            history.remember(location)
        else:
            let bound = history.bindFlatIndexCache(base, length, cache)
            let offset = cast[uint](location) - cast[uint](base)
            let index = offset div uint(sizeof(T))
            if bound == nil or index >= uint(length) or offset mod uint(sizeof(T)) != 0:
                history.remember(location)
            else:
                history.recordFlatIndex(location, int(index), bound[])

    proc clearFlat*(history: var FlatTemporaryRollbackLog) =
        ## 配列別の保存値と通常の保存値を逆順に一括復元する。訪問した添字だけ判定を戻す。
        ## 時間は保存した値のサイズの合計に比例し、復元後も配列ごとの確保領域を再利用する。
        while history.entries.len > 0:
            let entry = history.entries.pop()
            if entry == 0:
                let raw = history.raw.entries.pop()
                if raw.location.size > sizeof(int):
                    copyMem(raw.location.address, addr history.raw.saved[raw.offset], raw.location.size)
                    history.raw.used = raw.offset
                elif raw.location.size > 0:
                    copyMem(raw.location.address, unsafeAddr raw.offset, raw.location.size)
            else:
                let cacheId = int((entry shr 32) and 0x7FFFFFFF'u64) - 1
                let cache = history.raw.caches[cacheId]
                let index = int(entry and 0xFFFFFFFF'u64)
                let location = cast[pointer](cast[uint](cache.base) + uint(index * cache.size))
                let source = if (entry shr 63) == 0: cast[pointer](addr cache.initial)
                    else: cast[pointer](addr cache.saved[index * cache.size])
                case cache.size
                of 1: copyMem(location, source, 1)
                of 2: copyMem(location, source, 2)
                of 4: copyMem(location, source, 4)
                of 8: copyMem(location, source, 8)
                else: copyMem(location, source, cache.size)
                let word = index div (sizeof(int) * 8)
                let mask = 1 shl (index mod (sizeof(int) * 8))
                cache.stamps[word] = cache.stamps[word] and not mask

    proc restore*(history: var FlatTemporaryRollbackLog, position: int) =
        ## 一括復元して配列の判定領域を解放する。時間は履歴量と利用配列数に比例する。
        assert position == 0, "一括復元専用です"
        history.clearFlat()
        for cache in history.raw.caches: cache.owner = nil
        history.raw.caches.setLen(0)
