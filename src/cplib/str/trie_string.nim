when not declared CPLIB_STR_TRIE_STRING:
    ## Trieの節点IDで過去の文字列・要素列を保持する。辺(親, 要素)を正規化し、同じ列は同じIDになる。
    ## initTrieStringArray('a'..'z')は固定char範囲、initTrieStringTable(T)は汎用辞書版。
    ## initTrieString() / TrieStringはTable[char]版の短縮形。charはUnicode文字ではなく0..255のbyte。
    ## add(node,c)は末尾追加、pop(node)は親ID（根では根）を返し、過去の節点は破棄しない。
    ## compare(a,b)は-1/0/1、lcp(a,b)は共通接頭辞の長さ、lcpNode(a,b)はその節点IDを返す。
    ## prefix(node,length)は指定長の既存祖先、self[node,index]は0始まりの要素取得。
    ## toString(node)はchar版、toSeq(node)は両版で利用できる。根の変換結果は空列。
    ## prefixの長さは0..length(node)、添字は0..<length(node)。範囲外は切り詰めずValueError。
    ## 同一IDのLCPはその列全体、一方が接頭辞なら短い方、根とのLCPは根/長さ0。
    ## IDは同一インスタンス内でのみ有効。不正IDと未初期化はreleaseでもValueError。
    ## default値ではnodeCountだけ利用可能（0）。他の操作にはinitが必要。内部状態は非公開。
    ## 同一式の引数評価中に構造を変更せず、addの戻り値を受けてから他の操作へ渡す。
    ##
    ## Nは根を含む作成済み節点数、σはArray版の文字種数。
    ## Array版: 新規addは償却O(σ)、既存辺は最悪O(1)、空間O(Nσ)。σ固定なら償却O(1)、空間O(N)。
    ## Table版: addは期待償却O(1)、空間O(N)。Tのコピー/hash/==/<が定数時間かつ整合的で不変とする。
    ## 「期待」は良好なhash分布の仮定であり、悪意ある衝突では追加が線形時間になり得る。
    ## ジャンプ作成そのものは最悪O(1)だが、seq/Tableの再確保を含む追加は最悪O(1)ではない。
    ## popは最悪O(1)、compare/lcp/lcpNode/prefix/[]は最悪O(log(N+1))、追加空間O(1)。
    ## 変換は長さLに対して時間・出力空間O(L+1)。構造全体のコピーはこれらの操作計算量に含めない。
    ## 比較にはhashを使用しない。辞書のhash衝突でも==で辺を区別するため答えは厳密。
    ##
    ## 各節点のjumpは1本だけで、経路を長さ2^k-1のskew binaryブロックへ分割する。
    ## jump列の長さは非減少、等長が許されるのは先頭の2個だけ。
    ## 追加時は先頭2個が同長なら新節点と合体し、それ以外は長さ1を先頭に置くので更新は定数時間。
    ## 祖先探索はブロックを飛ばすか、親へ1歩進みブロックを2つの小さいrankへ分割する。
    ## 最初のブロック列と分割階層はいずれも対数個、各rankで飛ばす兄弟は高々1個なので最悪O(log N)。
    ## 同じ深さならjump長も同じ。2節点のjump先が異なる時だけ同時にjumpし、同じなら親へ進むと、
    ## LCAの1つ下の深さを目標とする祖先探索になる。正規化したTrieではLCAがLCPを表す。
    ## 二分累乗表・rolling hash・GCは使用しない。
    ##
    ## 使用例:
    ##   var t = initTrieStringArray('a'..'z')
    ##   let a = t.add(t.root, 'a')
    ##   let ab = t.add(a, 'b')
    ##   echo t.toString(ab)  # ab
    ##   echo t[ab, 1]        # b
    ##   echo t.lcp(a, ab)    # 1
    ##   echo t.prefix(ab, 1) == a  # true
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
