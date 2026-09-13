when not declared CPLIB_STR_TRIE:
    const CPLIB_STR_TRIE* = 1

    type
        TrieNode[chars: static[HSlice[char, char]]] = object
            child: array[chars.a..chars.b, int32]
            terminal, subtree: int32
        Trie*[chars: static[HSlice[char, char]]] = object
            nodes: seq[TrieNode[chars]]

    proc initTrie*(chars: static[HSlice[char, char]]): Trie[chars] =
        ## 指定した文字範囲の空の多重集合を作る。文字種数をσとして O(σ)。
        static: doAssert chars.a <= chars.b
        result.nodes = @[TrieNode[chars]()]

    proc len*[chars](self: Trie[chars]): int =
        ## 重複を含む文字列の総数を返す。O(1)。
        if self.nodes.len > 0:
            result = self.nodes[0].subtree

    proc findNode[chars](self: Trie[chars], s: string): int =
        ## sに対応する節点を返す。存在しなければ -1。O(|s|)。
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
            if self.nodes[node].child[c] == 0:
                let next = self.nodes.len
                doAssert next <= int(high(int32))
                self.nodes.add(TrieNode[chars]())
                self.nodes[node].child[c] = int32(next)
            node = self.nodes[node].child[c]
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
