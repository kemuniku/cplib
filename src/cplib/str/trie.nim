when not declared CPLIB_STR_TRIE:
    const CPLIB_STR_TRIE* = 1

    type
        TrieNode*[chars: static[HSlice[char, char]]] = object
            ## 根のIDは0、親は -1。childの0は子なし。characterは親からの文字（根では未使用）。
            child*: array[chars.a..chars.b, int32]
            terminal*, subtree*: int32
            parent*: int32
            character*: char
        Trie*[chars: static[HSlice[char, char]]] = object
            nodes*: seq[TrieNode[chars]]
        TriePointer*[chars: static[HSlice[char, char]]] = object
            ## 元のTrieが生存し、移動・再代入されない間だけ使用可能。コピー後の位置は独立する。
            owner: ptr Trie[chars]
            id: int32

    proc initTrie*(chars: static[HSlice[char, char]]): Trie[chars] =
        ## 指定した文字範囲の空の多重集合を作る。文字種数をσとして O(σ)。
        static: doAssert chars.a <= chars.b
        result.nodes.setLen(1)
        result.nodes[0].parent = -1

    proc root*[chars](self: Trie[chars]): int =
        ## 根の節点ID（0）を返す。O(1)。
        return 0

    proc getChild*[chars](self: var Trie[chars], node: int, c: char): int =
        ## cを末尾に追加した節点IDを返し、なければ作る。個数は変えない。σ固定で償却 O(1)。
        doAssert c >= chars.a and c <= chars.b
        if self.nodes.len == 0:
            doAssert node == 0
            self = initTrie(chars)
        doAssert node >= 0 and node < self.nodes.len
        result = self.nodes[node].child[c]
        if result == 0:
            result = self.nodes.len
            doAssert result <= int(high(int32))
            self.nodes.setLen(result + 1)
            self.nodes[result].parent = int32(node)
            self.nodes[result].character = c
            self.nodes[node].child[c] = int32(result)

    proc getParent*[chars](self: Trie[chars], node: int): int =
        ## 親の節点IDを返す。根の親は -1。O(1)。
        doAssert node >= 0 and node < self.nodes.len
        return self.nodes[node].parent

    proc restoreString*[chars](self: Trie[chars], node: int): string =
        ## 節点が示す文字列を復元する。根なら空文字列。O(深さ + 1)。
        doAssert node >= 0 and node < self.nodes.len
        var current = node
        while current != 0:
            result.add(self.nodes[current].character)
            current = self.nodes[current].parent
        for i in 0..<result.len div 2:
            swap(result[i], result[result.high - i])

    proc len*[chars](self: Trie[chars]): int =
        ## 重複を含む文字列の総数を返す。O(1)。
        if self.nodes.len > 0:
            result = self.nodes[0].subtree

    proc findNode*[chars](self: Trie[chars], s: string): int =
        ## sに対応する節点IDを個数が0でも返す。存在しなければ -1。O(|s|)。
        if self.nodes.len == 0:
            return -1
        for c in s:
            if c < chars.a or c > chars.b:
                return -1
            result = self.nodes[result].child[c]
            if result == 0:
                return -1

    proc count*[chars](self: Trie[chars], s: string): int =
        ## sと完全一致する文字列の個数を返す。O(|s|)。
        let node = self.findNode(s)
        if node >= 0:
            result = self.nodes[node].terminal

    proc contains*[chars](self: Trie[chars], s: string): bool =
        ## sが1個以上含まれるかを返す。O(|s|)。
        return self.count(s) > 0

    proc countPrefix*[chars](self: Trie[chars], prefix: string): int =
        ## prefixで始まる文字列の個数を返す。空のprefixなら総数。O(|prefix|)。
        let node = self.findNode(prefix)
        if node >= 0:
            result = self.nodes[node].subtree

    proc incl*[chars](self: var Trie[chars], s: string, v: Natural = 1) =
        ## sをv個追加する。範囲外の文字は許さない。償却 O(σ|s| + 1)。
        if v == 0:
            return
        for c in s:
            doAssert c >= chars.a and c <= chars.b
        doAssert v <= int(high(int32)) - self.len
        let added = int32(v)
        if self.nodes.len == 0:
            self = initTrie(chars)
        var node = 0
        self.nodes[node].subtree += added
        for c in s:
            node = self.getChild(node, c)
            self.nodes[node].subtree += added
        self.nodes[node].terminal += added

    proc initTrie*(words: openArray[string], chars: static[HSlice[char, char]]): Trie[chars] =
        ## 文字列列から重複を保って構築する。O(σ(1 + Σ|s|) + words.len)。
        result = initTrie(chars)
        for s in words:
            result.incl(s)

    proc excl*[chars](self: var Trie[chars], s: string, v: Natural = 1) =
        ## sを最大v個削除する。不足分は無視し、節点は保持する。O(|s|)。
        let removed = int32(min(v, self.count(s)))
        if removed == 0:
            return
        var node = 0
        self.nodes[node].subtree -= removed
        for c in s:
            node = self.nodes[node].child[c]
            self.nodes[node].subtree -= removed
        self.nodes[node].terminal -= removed

    proc lowerBound*[chars](self: Trie[chars], s: string): int =
        ## 辞書順でs未満の文字列の個数を返す。範囲外の文字も比較可能。O(σ|s| + 1)。
        if self.nodes.len == 0:
            return 0
        var node = 0
        for c in s:
            result += self.nodes[node].terminal
            for smaller in chars.a..chars.b:
                if smaller >= c:
                    break
                let next = self.nodes[node].child[smaller]
                if next != 0:
                    result += self.nodes[next].subtree
            if c < chars.a or c > chars.b:
                return
            node = self.nodes[node].child[c]
            if node == 0:
                return

    proc upperBound*[chars](self: Trie[chars], s: string): int =
        ## 辞書順でs以下の文字列の個数を返す。O(σ|s| + 1)。
        return self.lowerBound(s) + self.count(s)

    proc initTriePointer*[chars](self: var Trie[chars], node: int = 0): TriePointer[chars] =
        ## 指定した節点を指すポインタを作る。省略時は根。σ固定で O(1)。
        if self.nodes.len == 0:
            doAssert node == 0
            self = initTrie(chars)
        doAssert node >= 0 and node < self.nodes.len
        result.owner = addr self
        result.id = int32(node)

    proc nodeId*[chars](self: TriePointer[chars]): int =
        ## 指している節点IDを返す。O(1)。
        doAssert self.owner != nil
        return self.id

    proc subtree*[chars](self: TriePointer[chars]): int =
        ## 指している文字列をprefixとする登録個数を返す。O(1)。
        doAssert self.owner != nil
        return self.owner[].nodes[self.id].subtree

    proc terminal*[chars](self: TriePointer[chars]): int =
        ## 指している文字列と完全一致する登録個数を返す。O(1)。
        doAssert self.owner != nil
        return self.owner[].nodes[self.id].terminal

    proc restoreString*[chars](self: TriePointer[chars]): string =
        ## 指している節点の文字列を復元する。O(深さ + 1)。
        doAssert self.owner != nil
        return self.owner[].restoreString(self.id)

    proc `$`*[chars](self: TriePointer[chars]): string =
        ## 指している節点を文字列として返す。O(深さ + 1)。
        return self.restoreString()

    proc getChild*[chars](self: TriePointer[chars], c: char): TriePointer[chars] =
        ## cを末尾に追加した位置を返し、なければ節点を作る。σ固定で償却 O(1)。
        doAssert self.owner != nil
        result = self
        result.id = int32(self.owner[].getChild(self.id, c))

    proc getParent*[chars](self: TriePointer[chars]): TriePointer[chars] =
        ## 末尾を1文字削除した位置を返す。根では呼べない。O(1)。
        doAssert self.owner != nil and self.id != 0
        result = self
        result.id = int32(self.owner[].getParent(self.id))

    proc `&`*[chars](self: TriePointer[chars], c: char): TriePointer[chars] =
        ## 末尾にcを追加した位置を返す。σ固定で償却 O(1)。
        return self.getChild(c)

    proc add*[chars](self: var TriePointer[chars], c: char) =
        ## 末尾にcを追加した位置へ移動する。登録個数は変えない。σ固定で償却 O(1)。
        self = self.getChild(c)

    proc `&=`*[chars](self: var TriePointer[chars], c: char) =
        ## 末尾にcを追加した位置へ移動する。σ固定で償却 O(1)。
        self.add(c)

    proc pop*[chars](self: var TriePointer[chars]): char =
        ## 末尾の文字を返して親へ移動する。空文字列では呼べない。O(1)。
        doAssert self.owner != nil and self.id != 0
        result = self.owner[].nodes[self.id].character
        self = self.getParent()
