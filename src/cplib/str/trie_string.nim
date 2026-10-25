when not declared CPLIB_STR_TRIE_STRING:
    ## Trieのarenaと型付き節点で過去の文字列・要素列を保持する。同じ(親,要素)は同じ節点になる。
    ## initTrieStringArray('a'..'z') / initTrieStringTable(T)でarenaを作り、rootで空列の節点を得る。
    ## TrieStringArrayNode[chars] / TrieStringTableNode[T]はownerの強参照と内部添字を持つ値型。
    ## 節点コピー・arenaのseq再確保・元のarena変数のスコープ終了後も安全に利用できる。
    ## arenaのコピーは同一arenaを共有する。節点は内部状態を公開せず、整数IDからは生成できない。
    ## N.add(c)、N.pop()、N.compare(M)、N.lcp(M)、N.lcpNode(M)、N.prefix(length)、N[index]を使う。
    ## N.toString()はchar版、N.toSeq()は両版。N.lengthは要素数、arena.nodeCountは総節点数。
    ## add/popは新しい節点ハンドルを返し、元のハンドルと履歴を変更しない。根のpopは根。
    ## 比較・LCP・節点の==は同じownerのみ許す。異なるowner、default節点はValueError。
    ## 異なる要素型・Arrayの異なる文字範囲の節点同士の演算は型検査で拒否される。
    ## prefixの長さは0..N.length、添字は0..<N.length。範囲外は切り詰めずValueError。
    ## 同じ節点のLCPは列全体、接頭辞なら短い方、根とのLCPは根/長さ0。charは0..255のbyte。
    ## 個別節点のGCは行わない。arenaまたは節点が1つでも生存している間は全履歴を保持する。
    ## arena内部に節点ハンドルは格納せず、所有参照の循環は作らない。
    ## 最後の所有参照を失ったarena全体の解放はNimのメモリ管理に従い、下記の操作計算量とは別。
    ##
    ## Nは根を含む作成済み節点数、σはArray版の文字種数。
    ## Array版: 新規addは償却O(σ)、既存辺は最悪O(1)、空間O(Nσ)。σ固定なら償却O(1)、空間O(N)。
    ## Table版: addは期待償却O(1)、空間O(N)。Tのコピー/hash/==/<が定数時間かつ整合的で不変とする。
    ## 「期待」は良好なhash分布の仮定であり、悪意ある衝突では追加が線形時間になり得る。
    ## ジャンプ作成そのものは最悪O(1)だが、seq/Tableの再確保を含む追加は最悪O(1)ではない。
    ## popは最悪O(1)、compare/lcp/lcpNode/prefix/[]は最悪O(log(N+1))、追加空間O(1)。
    ## 変換は長さLに対して時間・出力空間O(L+1)。ハンドルのコピーはO(1)、呼び出し側のH個のハンドルは別途O(H)。
    ## 比較にはhashを使用しない。辞書のhash衝突でも==で辺を区別するため答えは厳密。
    ##
    ## 各節点のjumpは1本だけで、経路を長さ2^k-1のskew binaryブロックへ分割する。
    ## jump列の長さは非減少、等長が許されるのは先頭の2個だけ。
    ## 追加時は先頭2個が同長なら新節点と合体し、それ以外は長さ1を先頭に置くので更新は定数時間。
    ## 祖先探索はブロックを飛ばすか、親へ1歩進みブロックを2つの小さいrankへ分割する。
    ## 最初のブロック列と分割階層はいずれも対数個、各rankで飛ばす兄弟は高々1個なので最悪O(log N)。
    ## 同じ深さならjump長も同じ。2節点のjump先が異なる時だけ同時にjumpし、同じなら親へ進むと、
    ## LCAの1つ下の深さを目標とする祖先探索になる。正規化したTrieではLCAがLCPを表す。
    ## 二分累乗表・rolling hash・個別節点GCは使用しない。
    ##
    ## 使用例:
    ##   let t = initTrieStringArray('a'..'z')
    ##   let a = t.root.add('a')
    ##   let ab = a.add('b')
    ##   echo ab.toString()       # ab
    ##   echo ab[1]               # b
    ##   echo a.lcp(ab)           # 1
    ##   echo ab.prefix(1) == a   # true
    const CPLIB_STR_TRIE_STRING* = 1
    import tables

    type
        TrieStringEntry[T] = object
            parent, jump, depth: int
            character: T
        TrieStringTable*[T] = ref object
            ## 節点を所有するarena。Tのhash・==・<は整合的かつ不変とする。
            nodes: seq[TrieStringEntry[T]]
            edges: Table[tuple[parent: int, character: T], int]
        TrieStringArray*[chars: static[HSlice[char, char]]] = ref object
            ## 既存Trieと同じchar範囲指定。固定アルファベットなら空間 O(N)。
            nodes: seq[TrieStringEntry[char]]
            children: seq[array[chars.a..chars.b, int]]
        TrieStringTableNode*[T] = object
            ## ownerを強参照する節点。コピーは同じarena・節点を共有し、添字は非公開。
            owner: TrieStringTable[T]
            id: int
        TrieStringArrayNode*[chars: static[HSlice[char, char]]] = object
            ## ownerを強参照する節点。arenaの再確保や元の変数の寿命に依存しない。
            owner: TrieStringArray[chars]
            id: int
        TrieString* = TrieStringTable[char]

    proc initTrieStringTable*(T: typedesc): TrieStringTable[T] =
        ## 空文字列（根0）を含む構造を作る。時間・空間 O(1)。
        new(result)
        result.nodes.add(TrieStringEntry[T]())

    proc initTrieStringArray*(chars: static[HSlice[char, char]]): TrieStringArray[chars] =
        ## 指定文字範囲の根を作る。時間・空間 O(σ)。
        when chars.a > chars.b:
            {.error: "empty TrieStringArray alphabet".}
        new(result)
        result.nodes.add(TrieStringEntry[char]())
        result.children.setLen(1)

    proc initTrieString*(): TrieString =
        ## byte列用Table版の根を作る。時間・空間 O(1)。
        return initTrieStringTable(char)

    proc checkNode[S: TrieStringArray | TrieStringTable](self: S, node: int) {.inline.} =
        ## 未初期化・範囲外ハンドルはValueErrorとする。O(1)。
        if self == nil or node < 0 or node >= self.nodes.len:
            raise newException(ValueError, "invalid TrieString node")

    proc root*[T](self: TrieStringTable[T]): TrieStringTableNode[T] =
        ## 空列の節点を返す。未初期化arenaはValueError。O(1)。
        self.checkNode(0)
        return TrieStringTableNode[T](owner: self, id: 0)

    proc root*[chars](self: TrieStringArray[chars]): TrieStringArrayNode[chars] =
        ## 空列の節点を返す。未初期化arenaはValueError。O(1)。
        self.checkNode(0)
        return TrieStringArrayNode[chars](owner: self, id: 0)

    proc nodeCount*[S: TrieStringArray | TrieStringTable](self: S): int =
        ## arenaの根を含む作成済み節点数を返す。未初期化なら0。O(1)。
        if self != nil:
            result = self.nodes.len

    proc addNode[S: TrieStringArray | TrieStringTable, T](self: S, node: int, c: T): int =
        ## 新節点のジャンプを定数時間で求める。seq確保を含め償却 O(1)。
        let j = self.nodes[node].jump
        let jj = self.nodes[j].jump
        var jump = node
        if self.nodes[node].depth - self.nodes[j].depth ==
                self.nodes[j].depth - self.nodes[jj].depth:
            jump = jj
        result = self.nodes.len
        self.nodes.add(TrieStringEntry[T](parent: node, jump: jump,
            depth: self.nodes[node].depth + 1, character: c))

    proc addId[T](self: TrieStringTable[T], node: int, c: T): int =
        ## 末尾に1要素追加したハンドルを返す。同じ辺は共有する。期待償却 O(1)。
        self.checkNode(node)
        let key = (parent: node, character: c)
        result = self.edges.getOrDefault(key, -1)
        if result >= 0:
            return
        result = self.addNode(node, c)
        self.edges[key] = result

    proc addId[chars](self: TrieStringArray[chars], node: int, c: char): int =
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

    proc parentId[S: TrieStringArray | TrieStringTable](self: S, node: int): int =
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

    proc lcaId[S: TrieStringArray | TrieStringTable](self: S, a, b: int): int =
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

    proc prefixId[S: TrieStringArray | TrieStringTable](self: S, node, length: int): int =
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

    proc valueAt[T](self: TrieStringTable[T], node, index: int): T =
        ## 0始まりindexの要素を返す。範囲外はValueError。最悪 O(log N)。
        return self.nodes[self.nodeAtIndex(node, index)].character

    proc valueAt[chars](self: TrieStringArray[chars], node, index: int): char =
        ## 0始まりindexのbyteを返す。範囲外はValueError。最悪 O(log N)。
        return self.nodes[self.nodeAtIndex(node, index)].character

    proc restoreSeq[T](nodes: seq[TrieStringEntry[T]], node: int): seq[T] =
        ## 有効な節点から列を復元する。時間・出力空間 O(長さ+1)。
        result = newSeq[T](nodes[node].depth)
        var v = node
        var i = result.len
        while i > 0:
            dec i
            result[i] = nodes[v].character
            v = nodes[v].parent

    proc restore[T](self: TrieStringTable[T], node: int): seq[T] =
        ## 要素列を復元する。時間・出力空間 O(長さ+1)。
        self.checkNode(node)
        return restoreSeq(self.nodes, node)

    proc restore[chars](self: TrieStringArray[chars], node: int): seq[char] =
        ## byte列を復元する。時間・出力空間 O(長さ+1)。
        self.checkNode(node)
        return restoreSeq(self.nodes, node)

    proc restoreString[S: TrieStringArray | TrieStringTable[char]](self: S, node: int): string =
        ## byte列をstringへ復元する。時間・出力空間 O(長さ+1)。
        self.checkNode(node)
        result = newString(self.nodes[node].depth)
        var v = node
        var i = result.len
        while i > 0:
            dec i
            result[i] = self.nodes[v].character
            v = self.nodes[v].parent

    proc compareIds[S: TrieStringArray | TrieStringTable](self: S, a, b: int): int =
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

    proc checkHandle[S: TrieStringArrayNode | TrieStringTableNode](self: S) {.inline.} =
        ## default節点と不正な内部添字を拒否する。O(1)。
        self.owner.checkNode(self.id)

    proc checkCompatible[S: TrieStringArrayNode | TrieStringTableNode](a, b: S) {.inline.} =
        ## 両節点の有効性とownerの一致を検査する。O(1)。
        a.checkHandle()
        b.checkHandle()
        if a.owner != b.owner:
            raise newException(ValueError, "incompatible TrieString owners")

    proc `==`*[T](a, b: TrieStringTableNode[T]): bool =
        ## 同じarenaの正規化された節点かを返す。不正・異なるownerはValueError。O(1)。
        checkCompatible(a, b)
        return a.id == b.id

    proc `==`*[chars](a, b: TrieStringArrayNode[chars]): bool =
        ## 同じarenaの正規化された節点かを返す。不正・異なるownerはValueError。O(1)。
        checkCompatible(a, b)
        return a.id == b.id

    proc length*[S: TrieStringArrayNode | TrieStringTableNode](self: S): int =
        ## 節点が表す列の要素数を返す。O(1)。
        self.checkHandle()
        return self.owner.nodes[self.id].depth

    proc add*[T](self: TrieStringTableNode[T], c: T): TrieStringTableNode[T] =
        ## 末尾に1要素追加した節点を返す。期待償却O(1)。元の節点は変わらない。
        self.checkHandle()
        result = self
        result.id = self.owner.addId(self.id, c)

    proc add*[chars](self: TrieStringArrayNode[chars], c: char): TrieStringArrayNode[chars] =
        ## 末尾に1byte追加した節点を返す。既存辺O(1)、新規辺は償却O(σ)。
        self.checkHandle()
        result = self
        result.id = self.owner.addId(self.id, c)

    proc pop*[S: TrieStringArrayNode | TrieStringTableNode](self: S): S =
        ## 親節点を返す。根では根、元の節点と履歴は変わらない。最悪O(1)。
        self.checkHandle()
        result = self
        result.id = self.owner.parentId(self.id)

    proc compare*[S: TrieStringArrayNode | TrieStringTableNode](a, b: S): int =
        ## 同じarenaの列を厳密な辞書順で-1/0/1に比較する。最悪O(log N)。
        checkCompatible(a, b)
        return a.owner.compareIds(a.id, b.id)

    proc lcpNode*[S: TrieStringArrayNode | TrieStringTableNode](a, b: S): S =
        ## 同じarenaの最長共通接頭辞の節点を返す。最悪O(log N)。
        checkCompatible(a, b)
        result = a
        result.id = a.owner.lcaId(a.id, b.id)

    proc lcp*[S: TrieStringArrayNode | TrieStringTableNode](a, b: S): int =
        ## 同じarenaの最長共通接頭辞の要素数を返す。最悪O(log N)。
        return a.lcpNode(b).length

    proc prefix*[S: TrieStringArrayNode | TrieStringTableNode](self: S, length: int): S =
        ## 先頭length要素の節点を返す。範囲外はValueError。最悪O(log N)。
        self.checkHandle()
        result = self
        result.id = self.owner.prefixId(self.id, length)

    proc `[]`*[T](self: TrieStringTableNode[T], index: int): T =
        ## 0始まりindexの要素を返す。範囲外はValueError。最悪O(log N)。
        self.checkHandle()
        return self.owner.valueAt(self.id, index)

    proc `[]`*[chars](self: TrieStringArrayNode[chars], index: int): char =
        ## 0始まりindexのbyteを返す。範囲外はValueError。最悪O(log N)。
        self.checkHandle()
        return self.owner.valueAt(self.id, index)

    proc toSeq*[T](self: TrieStringTableNode[T]): seq[T] =
        ## 要素列を復元する。時間・出力空間O(長さ+1)。
        self.checkHandle()
        return self.owner.restore(self.id)

    proc toSeq*[chars](self: TrieStringArrayNode[chars]): seq[char] =
        ## byte列を復元する。時間・出力空間O(長さ+1)。
        self.checkHandle()
        return self.owner.restore(self.id)

    proc toString*[S: TrieStringArrayNode | TrieStringTableNode[char]](self: S): string =
        ## byte列をstringへ復元する。時間・出力空間O(長さ+1)。
        self.checkHandle()
        return self.owner.restoreString(self.id)
