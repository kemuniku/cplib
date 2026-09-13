when not declared CPLIB_STR_AHO_CORASICK:
    ## 登録語の集合を固定したAho–Corasick。頂点は登録語のprefix（根は空文字列）を表す。
    ## 頂点IDは入力順に登録語を走査して頂点を作った順の連番。根は0。
    ## initAhoCorasickで構築してから使用する。構築後の登録語の追加・削除には対応しない。
    ## matchCountは現在位置で終わる一致数。空文字列は根を含むすべての位置で一致する。
    ## matchesは登録語の頂点IDを返し、重複数はterminal、入力との対応はpatternNodeで取得する。
    ## 使用例:
    ##   var ac = initAhoCorasick(@["he", "she", "hers"], 'a'..'z')
    ##   var p = ac.initAhoCorasickPointer()
    ##   p.add("ush")  # $p == "sh"（登録語の途中の頂点にも遷移する）
    ##   p &= 'e'      # $p == "she", p.matchCount == 2
    ##   p &= "rs"     # $p == "hers"
    const CPLIB_STR_AHO_CORASICK* = 1

    type
        AhoCorasickNode[chars: static[HSlice[char, char]]] = object
            next: array[chars.a..chars.b, int32]
            parent, failure, output: int32
            character: char
            terminal, matched: int
        AhoCorasick*[chars: static[HSlice[char, char]]] = object
            nodes: seq[AhoCorasickNode[chars]]
            patterns: seq[int32]
        AhoCorasickPointer*[chars: static[HSlice[char, char]]] = object
            ## 元のAhoCorasickが生存し、移動・再代入されない間だけ使用可能。コピー後の位置は独立する。
            owner: ptr AhoCorasick[chars]
            id: int32

    proc initAhoCorasick*(words: openArray[string], chars: static[HSlice[char, char]]): AhoCorasick[chars] =
        ## 登録語から構築する。文字種数σ、頂点数Nとして時間 O(Σ|s| + words.len + σN)、空間 O(σN + words.len)。
        static: doAssert chars.a <= chars.b
        result.nodes.setLen(1)
        result.nodes[0].parent = -1
        result.nodes[0].output = -1
        for s in words:
            var node = 0
            for c in s:
                doAssert c >= chars.a and c <= chars.b
                if result.nodes[node].next[c] == 0:
                    let child = result.nodes.len
                    doAssert child <= int(high(int32))
                    result.nodes.add(AhoCorasickNode[chars](parent: int32(node), character: c, output: -1))
                    result.nodes[node].next[c] = int32(child)
                node = int(result.nodes[node].next[c])
            inc result.nodes[node].terminal
            result.patterns.add(int32(node))
        result.nodes[0].matched = result.nodes[0].terminal
        var queue = @[0'i32]
        var head = 0
        while head < queue.len:
            let node = queue[head]
            inc head
            for c in chars.a..chars.b:
                let child = result.nodes[node].next[c]
                if child == 0:
                    if node != 0:
                        result.nodes[node].next[c] = result.nodes[result.nodes[node].failure].next[c]
                    continue
                var failure = 0'i32
                if node != 0:
                    failure = result.nodes[result.nodes[node].failure].next[c]
                result.nodes[child].failure = failure
                result.nodes[child].matched = result.nodes[child].terminal + result.nodes[failure].matched
                result.nodes[child].output = if result.nodes[failure].terminal > 0: failure else: result.nodes[failure].output
                queue.add(child)

    proc root*[chars](self: AhoCorasick[chars]): int =
        ## 根の頂点ID（0）を返す。O(1)。
        return 0

    proc nodeCount*[chars](self: AhoCorasick[chars]): int =
        ## 根を含む頂点数を返す。O(1)。
        return self.nodes.len

    proc patternNode*[chars](self: AhoCorasick[chars], index: int): int =
        ## 入力のindex番目の登録語の頂点IDを返す。重複語は同じID。O(1)。
        return self.patterns[index]

    proc findNode*[chars](self: AhoCorasick[chars], s: string): int =
        ## sに完全一致する頂点IDを返す。登録語のprefixも対象とし、存在しなければ -1。O(|s| + 1)。
        if self.nodes.len == 0:
            return -1
        for c in s:
            if c < chars.a or c > chars.b:
                return -1
            let child = int(self.nodes[result].next[c])
            # failure経由の遷移を除き、Trie上の子だけをたどる。
            if self.nodes[child].parent != int32(result):
                return -1
            result = child

    proc next*[chars](self: AhoCorasick[chars], node: int, c: char): int =
        ## cを追加した文字列の最長suffixに対応する頂点へ遷移する。範囲外の文字なら根。O(1)。
        doAssert node >= 0 and node < self.nodes.len
        if c >= chars.a and c <= chars.b:
            result = int(self.nodes[node].next[c])

    proc next*[chars](self: AhoCorasick[chars], node: int, s: string): int =
        ## sを追加した文字列の最長suffixに対応する頂点へ遷移する。O(|s| + 1)。
        doAssert node >= 0 and node < self.nodes.len
        result = node
        for c in s:
            result = self.next(result, c)

    proc getParent*[chars](self: AhoCorasick[chars], node: int): int =
        ## Trie上の親の頂点IDを返す。根の親は -1。O(1)。
        doAssert node >= 0 and node < self.nodes.len
        return int(self.nodes[node].parent)

    proc failure*[chars](self: AhoCorasick[chars], node: int): int =
        ## 最長の真のsuffixに対応する頂点IDを返す。根では0。O(1)。
        doAssert node >= 0 and node < self.nodes.len
        return int(self.nodes[node].failure)

    proc terminal*[chars](self: AhoCorasick[chars], node: int): int =
        ## 頂点の文字列と完全一致する登録語の個数を返す。O(1)。
        doAssert node >= 0 and node < self.nodes.len
        return self.nodes[node].terminal

    proc matchCount*[chars](self: AhoCorasick[chars], node: int): int =
        ## 現在位置で終わる登録語の個数を重複・空文字列も含めて返す。O(1)。
        doAssert node >= 0 and node < self.nodes.len
        return self.nodes[node].matched

    iterator matches*[chars](self: AhoCorasick[chars], node: int): int =
        ## 現在位置で終わる登録語の頂点を長い順に重複なく列挙する。O(列挙数 + 1)。
        doAssert node >= 0 and node < self.nodes.len
        var current = int32(node)
        if self.nodes[current].terminal == 0:
            current = self.nodes[current].output
        while current != -1:
            yield int(current)
            current = self.nodes[current].output

    proc restoreString*[chars](self: AhoCorasick[chars], node: int): string =
        ## 頂点が示す文字列を復元する。O(深さ + 1)。
        doAssert node >= 0 and node < self.nodes.len
        var current = node
        while current != 0:
            result.add(self.nodes[current].character)
            current = int(self.nodes[current].parent)
        for i in 0..<result.len div 2:
            swap(result[i], result[result.high - i])

    proc initAhoCorasickPointer*[chars](self: var AhoCorasick[chars], node: int = 0): AhoCorasickPointer[chars] =
        ## 指定した頂点を指すポインタを作る。省略時は根。O(1)。
        doAssert node >= 0 and node < self.nodes.len
        result.owner = addr self
        result.id = int32(node)

    proc nodeId*[chars](self: AhoCorasickPointer[chars]): int =
        ## 指している頂点IDを返す。O(1)。
        doAssert self.owner != nil
        return int(self.id)

    proc getParent*[chars](self: AhoCorasickPointer[chars]): AhoCorasickPointer[chars] =
        ## 現在の頂点の文字列から末尾を1文字削った親を返す。根では呼べない。O(1)。
        doAssert self.owner != nil and self.id != 0
        result = self
        result.id = int32(self.owner[].getParent(self.id))

    proc failure*[chars](self: AhoCorasickPointer[chars]): AhoCorasickPointer[chars] =
        ## 最長の真のsuffixに対応する頂点を指すポインタを返す。根では根を返す。O(1)。
        doAssert self.owner != nil
        result = self
        result.id = int32(self.owner[].failure(self.id))

    proc next*[chars](self: AhoCorasickPointer[chars], c: char): AhoCorasickPointer[chars] =
        ## cを追加し、最長suffixへ遷移したポインタを返す。O(1)。
        doAssert self.owner != nil
        result = self
        result.id = int32(self.owner[].next(self.id, c))

    proc next*[chars](self: AhoCorasickPointer[chars], s: string): AhoCorasickPointer[chars] =
        ## sを追加し、最長suffixへ遷移したポインタを返す。O(|s| + 1)。
        doAssert self.owner != nil
        result = self
        result.id = int32(self.owner[].next(self.id, s))

    proc `&`*[chars](self: AhoCorasickPointer[chars], s: char|string): AhoCorasickPointer[chars] =
        ## 文字または文字列を追加して遷移したポインタを返す。O(|s| + 1)。
        return self.next(s)

    proc add*[chars](self: var AhoCorasickPointer[chars], s: char|string) =
        ## 文字または文字列を追加して最長suffixへ移動する。O(|s| + 1)。
        self = self.next(s)

    proc `&=`*[chars](self: var AhoCorasickPointer[chars], s: char|string) =
        ## 文字または文字列を追加して最長suffixへ移動する。O(|s| + 1)。
        self.add(s)

    proc terminal*[chars](self: AhoCorasickPointer[chars]): int =
        ## 指している文字列と完全一致する登録語の個数を返す。O(1)。
        doAssert self.owner != nil
        return self.owner[].terminal(self.id)

    proc matchCount*[chars](self: AhoCorasickPointer[chars]): int =
        ## 現在位置で終わる登録語の個数を重複・空文字列も含めて返す。O(1)。
        doAssert self.owner != nil
        return self.owner[].matchCount(self.id)

    iterator matches*[chars](self: AhoCorasickPointer[chars]): int =
        ## 現在位置で終わる登録語の頂点を長い順に重複なく列挙する。O(列挙数 + 1)。
        doAssert self.owner != nil
        for node in self.owner[].matches(self.id):
            yield node

    proc restoreString*[chars](self: AhoCorasickPointer[chars]): string =
        ## 指している頂点の文字列を復元する。O(深さ + 1)。
        doAssert self.owner != nil
        return self.owner[].restoreString(self.id)

    proc `$`*[chars](self: AhoCorasickPointer[chars]): string =
        ## 指している頂点を文字列として返す。O(深さ + 1)。
        return self.restoreString()
