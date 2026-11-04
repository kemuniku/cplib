when not declared CPLIB_COLLECTIONS_PERSISTENT_QUEUE:
    const CPLIB_COLLECTIONS_PERSISTENT_QUEUE* = 1

    type
        PersistentQueueNode[T] = object
            value: T
            firstJump: int
        PersistentQueuePool[T] = ref object
            nodes: seq[PersistentQueueNode[T]]
            jumps: seq[int]
        PersistentQueue*[T] = object
            ## 全過去版から分岐できるFIFOキュー。代入・各操作は元の版を変更しない。
            ## 末尾から2^k個前のノードを共有プールの祖先表で参照する。
            ## V回のpush全体でO(V log(V+1))領域。全版が破棄されるまでプールを保持する。
            ## Tのコピーの時間・領域は別途必要。参照型の要素を深くコピーしない。
            pool: PersistentQueuePool[T]
            tail: int
            size: int

    proc initPersistentQueue*[T](): PersistentQueue[T] =
        ## 空のキューを作る。宣言だけでも空になる。O(1)。
        result = default(PersistentQueue[T])

    proc len*[T](self: PersistentQueue[T]): int {.inline.} =
        ## この版の要素数を返す。O(1)。
        self.size

    proc push*[T](self: PersistentQueue[T], value: T): PersistentQueue[T] =
        ## 末尾に追加した新しい版を返す。償却O(log(N+2))時間・追加領域（Nは元の長さ）。
        ## 祖先表の構築自体は最悪O(log(N+2))。プールのseq再確保は償却で評価する。
        assert self.size < int.high, "キューの長さがintの上限に達しています"
        result = self
        if result.pool.isNil:
            result.pool = PersistentQueuePool[T]()
        let pool = result.pool
        let firstJump = pool.jumps.len
        if self.size > 0:
            pool.jumps.add(self.tail)
            var level = 1
            while (self.size shr level) > 0:
                let middle = pool.jumps[firstJump + level - 1]
                let ancestor = pool.jumps[pool.nodes[middle].firstJump + level - 1]
                pool.jumps.add(ancestor)
                inc level
        result.tail = pool.nodes.len
        pool.nodes.add(PersistentQueueNode[T](value: value, firstJump: firstJump))
        inc result.size

    proc front*[T](self: PersistentQueue[T]): T =
        ## 空でない版の先頭を返す。最悪O(log(N+1))時間・O(1)補助領域。
        assert self.size > 0, "空のキューの先頭は取得できません"
        var node = self.tail
        var distance = self.size - 1
        var level = 0
        while distance > 0:
            if (distance and 1) != 0:
                node = self.pool.jumps[self.pool.nodes[node].firstJump + level]
            distance = distance shr 1
            inc level
        self.pool.nodes[node].value

    proc pop*[T](self: PersistentQueue[T]): PersistentQueue[T] =
        ## 空でない版の先頭を除いた新しい版を返す。O(1)。削除値はfrontで取得する。
        assert self.size > 0, "空のキューからは削除できません"
        result = self
        dec result.size
