when not declared CPLIB_STR_TRIE_STRING:
    const CPLIB_STR_TRIE_STRING* = 1
    import tables

    type
        TrieStringNode[T] = object
            parent, jump, depth: int
            character: T
        TrieStringTable*[T] = object
            ## 同一インスタンス内のintハンドルで列を表す。Tのhash・==・<は整合的かつ不変とする。
            nodes: seq[TrieStringNode[T]]
            edges: Table[tuple[parent: int, character: T], int]
        TrieStringArray*[chars: static[HSlice[char, char]]] = object
            ## 既存Trieと同じchar範囲指定。固定アルファベットなら空間 O(N)。
            nodes: seq[TrieStringNode[char]]
            children: seq[array[chars.a..chars.b, int]]
        TrieString* = TrieStringTable[char]

    proc initTrieStringTable*(T: typedesc): TrieStringTable[T] =
        ## 空文字列（根0）を含む構造を作る。時間・空間 O(1)。
        result.nodes.add(TrieStringNode[T]())

    proc initTrieStringArray*(chars: static[HSlice[char, char]]): TrieStringArray[chars] =
        ## 指定文字範囲の根を作る。時間・空間 O(σ)。
        when chars.a > chars.b:
            {.error: "empty TrieStringArray alphabet".}
        result.nodes.add(TrieStringNode[char]())
        result.children.setLen(1)

    proc initTrieString*(): TrieString =
        ## byte列用Table版の根を作る。時間・空間 O(1)。
        return initTrieStringTable(char)

    proc checkNode[S: TrieStringArray | TrieStringTable](self: S, node: int) {.inline.} =
        ## 未初期化・範囲外ハンドルはValueErrorとする。O(1)。
        if node < 0 or node >= self.nodes.len:
            raise newException(ValueError, "invalid TrieString node")

    proc root*[S: TrieStringArray | TrieStringTable](self: S): int =
        ## 空文字列のハンドル0を返す。未初期化ならValueError。O(1)。
        self.checkNode(0)
        return 0

    proc nodeCount*[S: TrieStringArray | TrieStringTable](self: S): int =
        ## 根を含む節点数を返す。未初期化なら0。O(1)。
        return self.nodes.len

    proc length*[S: TrieStringArray | TrieStringTable](self: S, node: int): int =
        ## ハンドルが表す列の長さを返す。O(1)。
        self.checkNode(node)
        return self.nodes[node].depth

    proc addNode[S: TrieStringArray | TrieStringTable, T](self: var S, node: int, c: T): int =
        ## 新節点のジャンプを定数時間で求める。seq確保を含め償却 O(1)。
        let j = self.nodes[node].jump
        let jj = self.nodes[j].jump
        var jump = node
        if self.nodes[node].depth - self.nodes[j].depth ==
                self.nodes[j].depth - self.nodes[jj].depth:
            jump = jj
        result = self.nodes.len
        self.nodes.add(TrieStringNode[T](parent: node, jump: jump,
            depth: self.nodes[node].depth + 1, character: c))

    proc add*[T](self: var TrieStringTable[T], node: int, c: T): int =
        ## 末尾に1要素追加したハンドルを返す。同じ辺は共有する。期待償却 O(1)。
        self.checkNode(node)
        let key = (parent: node, character: c)
        result = self.edges.getOrDefault(key, -1)
        if result >= 0:
            return
        result = self.addNode(node, c)
        self.edges[key] = result

    proc add*[chars](self: var TrieStringArray[chars], node: int, c: char): int =
        ## 末尾に1byte追加する。既存辺 O(1)、新規辺は償却 O(σ)。
        self.checkNode(node)
        if c < chars.a or c > chars.b:
            raise newException(ValueError, "character outside TrieStringArray alphabet")
        result = self.children[node][c]
        if result != 0:
            return
        result = self.addNode(node, c)
        self.children.setLen(self.nodes.len)
        self.children[node][c] = result

    proc pop*[S: TrieStringArray | TrieStringTable](self: S, node: int): int =
        ## 末尾1要素を除いた親を返す。根では根を返す。節点は消さない。最悪 O(1)。
        self.checkNode(node)
        return self.nodes[node].parent

    proc ancestorAtDepth[S: TrieStringArray | TrieStringTable](self: S, node, depth: int): int =
        ## 指定深さの祖先を返す（内部用、有効な深さのみ）。最悪 O(log N)。
        result = node
        while self.nodes[result].depth > depth:
            let j = self.nodes[result].jump
            if self.nodes[j].depth >= depth:
                result = j
            else:
                result = self.nodes[result].parent

    proc lcpNode*[S: TrieStringArray | TrieStringTable](self: S, a, b: int): int =
        ## 最長共通接頭辞の節点IDを厳密に返す。最悪 O(log N)、追加空間 O(1)。
        self.checkNode(a)
        self.checkNode(b)
        var u = a
        var v = b
        let da = self.nodes[u].depth
        let db = self.nodes[v].depth
        if da > db:
            u = self.ancestorAtDepth(u, db)
        elif db > da:
            v = self.ancestorAtDepth(v, da)
        if u == v:
            return u
        while self.nodes[u].parent != self.nodes[v].parent:
            let ju = self.nodes[u].jump
            let jv = self.nodes[v].jump
            if ju != jv:
                u = ju
                v = jv
            else:
                u = self.nodes[u].parent
                v = self.nodes[v].parent
        return self.nodes[u].parent

    proc lcp*[S: TrieStringArray | TrieStringTable](self: S, a, b: int): int =
        ## 最長共通接頭辞の要素数を厳密に返す。最悪 O(log N)、追加空間 O(1)。
        return self.nodes[self.lcpNode(a, b)].depth

    proc prefix*[S: TrieStringArray | TrieStringTable](self: S, node, length: int): int =
        ## 先頭length要素の節点IDを返す。範囲外はValueError。最悪 O(log N)。
        self.checkNode(node)
        if length < 0 or length > self.nodes[node].depth:
            raise newException(ValueError, "invalid TrieString prefix length")
        return self.ancestorAtDepth(node, length)

    proc nodeAtIndex[S: TrieStringArray | TrieStringTable](self: S, node, index: int): int =
        ## 0始まりindexの要素を末尾に持つ祖先を返す。最悪 O(log N)。
        self.checkNode(node)
        if index < 0 or index >= self.nodes[node].depth:
            raise newException(ValueError, "invalid TrieString index")
        return self.ancestorAtDepth(node, index + 1)

    proc `[]`*[T](self: TrieStringTable[T], node, index: int): T =
        ## 0始まりindexの要素を返す。範囲外はValueError。最悪 O(log N)。
        return self.nodes[self.nodeAtIndex(node, index)].character

    proc `[]`*[chars](self: TrieStringArray[chars], node, index: int): char =
        ## 0始まりindexのbyteを返す。範囲外はValueError。最悪 O(log N)。
        return self.nodes[self.nodeAtIndex(node, index)].character

    proc restoreSeq[T](nodes: seq[TrieStringNode[T]], node: int): seq[T] =
        ## 有効な節点から列を復元する。時間・出力空間 O(長さ+1)。
        result = newSeq[T](nodes[node].depth)
        var v = node
        var i = result.len
        while i > 0:
            dec i
            result[i] = nodes[v].character
            v = nodes[v].parent

    proc toSeq*[T](self: TrieStringTable[T], node: int): seq[T] =
        ## 要素列を復元する。時間・出力空間 O(長さ+1)。
        self.checkNode(node)
        return restoreSeq(self.nodes, node)

    proc toSeq*[chars](self: TrieStringArray[chars], node: int): seq[char] =
        ## byte列を復元する。時間・出力空間 O(長さ+1)。
        self.checkNode(node)
        return restoreSeq(self.nodes, node)

    proc toString*[S: TrieStringArray | TrieStringTable[char]](self: S, node: int): string =
        ## byte列をstringへ復元する。時間・出力空間 O(長さ+1)。
        self.checkNode(node)
        result = newString(self.nodes[node].depth)
        var v = node
        var i = result.len
        while i > 0:
            dec i
            result[i] = self.nodes[v].character
            v = self.nodes[v].parent

    proc compare*[S: TrieStringArray | TrieStringTable](self: S, a, b: int): int =
        ## 要素の辞書順で-1/0/1を厳密に返す。最悪 O(log N)、追加空間 O(1)。
        self.checkNode(a)
        self.checkNode(b)
        if a == b:
            return 0
        let da = self.nodes[a].depth
        let db = self.nodes[b].depth
        var u = a
        var v = b
        if da > db:
            u = self.ancestorAtDepth(u, db)
        elif db > da:
            v = self.ancestorAtDepth(v, da)
        if u == v:
            return (if da < db: -1 else: 1)
        while self.nodes[u].parent != self.nodes[v].parent:
            let ju = self.nodes[u].jump
            let jv = self.nodes[v].jump
            if ju != jv:
                u = ju
                v = jv
            else:
                u = self.nodes[u].parent
                v = self.nodes[v].parent
        return (if self.nodes[u].character < self.nodes[v].character: -1 else: 1)
