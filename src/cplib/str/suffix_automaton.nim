when not declared CPLIB_STR_SUFFIX_AUTOMATON:
    ## 連続部分文字列を認識するオンラインSuffix Automaton。
    ## stringはNUL・非ASCIIも含め0..255のbyte列として扱う。整数列などのopenArrayにも対応。
    ## 1状態は終端位置集合が等しい文字列群を表し、単一の文字列とは限らない。
    ## 状態vの長さ範囲は nodes[nodes[v].link].len + 1 .. nodes[v].len（根を除く）。
    ## 根からの経路が全連続部分文字列、lastからsuffix linkをたどった状態が全suffixを表す。
    ## extend後も状態IDは有効だが、既存状態のlinkとnextは変わる場合がある。
    ## 遷移表の列挙には呼び出し側でもimport tablesを使う。occurrence集約や終端フラグは保持しない。
    ## 状態・遷移数は O(N)。期待時間はhash・==が O(1) の場合で、1回のextendは O(N) になり得る。
    ## 使用例:
    ##   var sam = initSuffixAutomaton(char)
    ##   discard sam.extend('a')
    ##   discard sam.extend('b')
    ##   let v = sam.findNode("ab")  # v == sam.last
    ##   let length = sam.nodes[v].len  # 2
    ##   let suffix = sam.nodes[v].link  # "b"の状態
    ##   let missing = sam.next(v, 'a')  # -1、遷移表は変更しない
    ##   let count = sam.countDistinctSubstrings()  # 3（空を除く）
    const CPLIB_STR_SUFFIX_AUTOMATON* = 1
    import tables

    type
        SuffixAutomatonNode*[T] = object
            ## 根は0。lenは最大長、linkはsuffix link（根では -1）、nextは文字から遷移先IDへの表。
            len*: int
            link*: int
            next*: Table[T, int]
        SuffixAutomaton*[T] = object
            ## initSuffixAutomatonで初期化する。nodes・lastの直接変更は不可。Tにはhashと==が必要。
            nodes*: seq[SuffixAutomatonNode[T]]
            last*: int

    proc initSuffixAutomaton*(T: typedesc): SuffixAutomaton[T] =
        ## 空の列のSAMを作る。根だけを含む。時間・空間 O(1)。
        result.nodes.add(SuffixAutomatonNode[T](link: -1))

    proc extend*[T](self: var SuffixAutomaton[T], c: T): int =
        ## 末尾に1要素追加し、列全体の状態IDを返す。全N要素で期待 O(N)、空間 O(N)。
        if self.nodes.len == 0:
            self = initSuffixAutomaton(T)
        result = self.nodes.len
        self.nodes.add(SuffixAutomatonNode[T](len: self.nodes[self.last].len + 1))
        var p = self.last
        while p != -1 and not self.nodes[p].next.hasKey(c):
            if self.nodes[p].next.len == 0:
                self.nodes[p].next = initTable[T, int](1)
            self.nodes[p].next[c] = result
            p = self.nodes[p].link
        if p != -1:
            let q = self.nodes[p].next[c]
            if self.nodes[p].len + 1 == self.nodes[q].len:
                self.nodes[result].link = q
            else:
                let clone = self.nodes.len
                # cloneの遷移表を独立させ、以後の更新がqへ波及しないようにする。
                var node = SuffixAutomatonNode[T](len: self.nodes[p].len + 1, link: self.nodes[q].link,
                    next: initTable[T, int](max(1, self.nodes[q].next.len)))
                for key, value in tables.pairs(self.nodes[q].next):
                    node.next[key] = value
                self.nodes.add(node)
                while p != -1 and self.nodes[p].next.getOrDefault(c, -1) == q:
                    self.nodes[p].next[c] = clone
                    p = self.nodes[p].link
                self.nodes[q].link = clone
                self.nodes[result].link = clone
        self.last = result

    proc initSuffixAutomaton*[T](s: openArray[T]): SuffixAutomaton[T] =
        ## 列からSAMを作る。hash・==が O(1) のとき期待時間 O(|s| + 1)、空間 O(|s| + 1)。
        result = initSuffixAutomaton(T)
        for c in s:
            discard result.extend(c)

    proc root*[T](self: SuffixAutomaton[T]): int =
        ## 根の状態ID（0）を返す。O(1)。
        return 0

    proc nodeCount*[T](self: SuffixAutomaton[T]): int =
        ## 根・cloneを含む状態数を返す。O(1)。
        return self.nodes.len

    proc next*[T](self: SuffixAutomaton[T], node: int, c: T): int =
        ## 有効な状態nodeからcで遷移したIDを返す。不在は -1。表を変更せず期待 O(1)。
        return self.nodes[node].next.getOrDefault(c, -1)

    proc findNode*[T](self: SuffixAutomaton[T], s: openArray[T]): int =
        ## 部分列でなく連続部分文字列sをたどる。空は根、不在は -1。期待 O(|s| + 1)。
        if self.nodes.len == 0:
            return -1
        for c in s:
            result = self.next(result, c)
            if result == -1:
                return

    proc contains*[T](self: SuffixAutomaton[T], s: openArray[T]): bool =
        ## 連続部分文字列sが存在するかを返す。空も含む。期待 O(|s| + 1)。
        return self.findNode(s) != -1

    proc countDistinctSubstrings*[T](self: SuffixAutomaton[T]): int64 =
        ## 空を除く異なる連続部分文字列の個数を返す。時間 O(状態数)、追加空間 O(1)。
        for node in 1..<self.nodes.len:
            result += int64(self.nodes[node].len - self.nodes[self.nodes[node].link].len)
