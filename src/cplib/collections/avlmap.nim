when not declared CPLIB_COLLECTIONS_AVLMAP:
    const CPLIB_COLLECTIONS_AVLMAP* = 1
    import cplib/collections/avltreenode

    ## AVLの回転・削除・部分木サイズを既存AvlTreeNodeから再利用する。
    ## N要素の格納領域はO(N)。検索・挿入・削除の最悪時間はO(log(N+1))、lenはO(1)。
    ## キー比較・K/VのコピーをO(1)とした計算量で、GCや解放費用は別途かかる。
    ## lowerBound/upperBoundは既存AVL setと同じ0..lenの順位を返す。
    ## `<`が互いに偽のキーは同じキーとし、置換時は最初のキーを保持する。
    ## NaN等で順序が一貫しないキーは対象外。要素数はintに収まる必要がある。
    ## 返却値はNimの通常コピーで、参照型の参照先まで複製しない。
    ## 削除時に内部格納要素への参照は無効化される。APIはその参照を返さず、
    ## 取得済みのK/Vのコピーは削除後も有効（参照型Vの参照先も保持される）。
    ## 宣言のみのAvlMapも空として使える。代入コピーを保持したままの変更は禁止。
    ## 独立コピーはinitAvlMap[K,V](toSeq(map.pairs))で作る（O(N log(N+1))）。

    type
        AvlMapEntry[K, V] = object
            key: K
            value: V
        AvlMap*[K, V] = object
            ## キー順の連想配列。Kの厳密弱順序 `<` だけを使い、Vは比較しない。
            ## 内部ノードやキーへのvar参照は公開しない。列挙中の変更は禁止。
            ## 参照型キーの比較結果を外部から変更しないこと。
            ## 代入コピーはノードを共有するため、コピーを保持したまま変更しない。
            root: AvlTreeNode[AvlMapEntry[K, V]]

    proc `<`*[K, V](a, b: AvlMapEntry[K, V]): bool =
        ## キーだけを比較する。
        a.key < b.key

    proc `<=`*[K, V](a, b: AvlMapEntry[K, V]): bool =
        ## キーの厳密弱順序から以下を判定する。
        not (b.key < a.key)

    proc findNode[K, V](self: AvlMap[K, V], key: K): AvlTreeNode[AvlMapEntry[K, V]] =
        ## キーと順序同値のノードをO(log(N+1))で探す。
        let (_, node) = self.root.lower_bound_node(AvlMapEntry[K, V](key: key))
        if not node.isNil and not (key < node.key.key): result = node

    proc len*[K, V](self: AvlMap[K, V]): int =
        ## 要素数をO(1)で返す。
        if self.root.isNil: 0 else: self.root.len

    proc contains*[K, V](self: AvlMap[K, V], key: K): bool =
        ## キーの存在をO(log(N+1))で判定する。
        not self.findNode(key).isNil

    proc `[]`*[K, V](self: AvlMap[K, V], key: K): V =
        ## 値のコピーをO(log(N+1))で返す。不在ならKeyError。
        let node = self.findNode(key)
        if node.isNil: raise newException(KeyError, "AvlMapにキーが存在しません")
        node.key.value

    proc getOrDefault*[K, V](self: AvlMap[K, V], key: K, defaultValue: V = default(V)): V =
        ## 値、不在なら既定値のコピーをO(log(N+1))で返す。挿入はしない。
        let node = self.findNode(key)
        if node.isNil: defaultValue else: node.key.value

    proc `[]=`*[K, V](self: var AvlMap[K, V], key: K, value: V) =
        ## O(log(N+1))で挿入、既存の順序同値キーなら値だけを置換する。
        let node = self.findNode(key)
        if not node.isNil:
            node.key.value = value
        else:
            self.root = self.root.insert(AvlTreeNode[AvlMapEntry[K, V]](
                h: 1, len: 1, key: AvlMapEntry[K, V](key: key, value: value)))

    proc del*[K, V](self: var AvlMap[K, V], key: K): bool {.discardable.} =
        ## O(log(N+1))で削除し、存在したかを返す。不在なら何もしない。
        ## 削除した格納要素は無効になるが、既に返したコピーの寿命は変えない。
        let node = self.findNode(key)
        if node.isNil: return false
        self.root = self.root.erase(node, node.next)
        true

    proc lowerBound*[K, V](self: AvlMap[K, V], key: K): int =
        ## キー未満の要素数（挿入順位）をO(log(N+1))で返す。
        let (_, node) = self.root.lower_bound_node(AvlMapEntry[K, V](key: key))
        if node.isNil: self.len else: node.index

    proc upperBound*[K, V](self: AvlMap[K, V], key: K): int =
        ## キー以下の要素数（同値の直後の順位）をO(log(N+1))で返す。
        let (_, node) = self.root.upper_bound_node(AvlMapEntry[K, V](key: key))
        if node.isNil: self.len else: node.index

    iterator pairs*[K, V](self: AvlMap[K, V]): tuple[key: K, value: V] =
        ## キー昇順にコピーを列挙する。全体O(N)、補助領域O(log(N+1))。
        var stack: seq[AvlTreeNode[AvlMapEntry[K, V]]]
        var node = self.root
        while not node.isNil or stack.len > 0:
            while not node.isNil:
                stack.add(node)
                node = node.l
            node = stack.pop()
            yield (node.key.key, node.key.value)
            node = node.r

    iterator keys*[K, V](self: AvlMap[K, V]): K =
        ## キーを昇順にコピーして列挙する。全体O(N)、補助領域O(log(N+1))。
        for key, value in self.pairs: yield key

    iterator values*[K, V](self: AvlMap[K, V]): V =
        ## キー昇順に値のコピーを列挙する。全体O(N)、補助領域O(log(N+1))。
        for key, value in self.pairs: yield value

    proc initAvlMap*[K, V](entries: openArray[tuple[key: K, value: V]] = []): AvlMap[K, V] =
        ## M要素からO(M log(M+1))で構築する。同値キーは最後の値を採用。
        for entry in entries: result[entry.key] = entry.value
