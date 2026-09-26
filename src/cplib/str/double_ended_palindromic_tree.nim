when not declared CPLIB_STR_DOUBLE_ENDED_PALINDROMIC_TREE:
    ## 両端への追加・削除に対応する回文木。空の回文は個数に含めない。
    ## 文字種数をσ、これまでの最大長をNとして、追加は償却 O(σ)、削除・取得は O(1)、空間は O(σ(N + 1))。
    ## surface の管理は https://arxiv.org/abs/2210.02292 の手法に基づく。
    const CPLIB_STR_DOUBLE_ENDED_PALINDROMIC_TREE* = 1
    import deques

    type
        DoubleEndedPalindromicTreeNode = object
            length, parent, suffix, depth: int
            longestCount, suffixChildren: int
        DoubleEndedPalindromicTreeEntry = object
            # surfaceは、より長い回文の接頭辞にも接尾辞にもならない回文の出現。
            value, prefixSurface, suffixSurface: int
        DoubleEndedPalindromicTree* = object
            alphabetSize: int
            charOffset: char
            nodes: seq[DoubleEndedPalindromicTreeNode]
            children, direct: seq[int]
            # 空きノードではparentを次の空きノードへのリンクとして使う。
            freeHead, freeCount: int
            data: Deque[DoubleEndedPalindromicTreeEntry]
            total: int64

    proc initDoubleEndedPalindromicTree*(amax: int = 26, c: char = 'a'): DoubleEndedPalindromicTree =
        ## 空の回文木を O(amax) で作る。整数は 0..<amax、文字は ord(ch)-ord(c) として扱う。
        assert amax > 0
        result.alphabetSize = amax
        result.charOffset = c
        # ノード0は長さ-1の根（未接続の遷移も0）、ノード1は空文字列の根。
        result.nodes = @[DoubleEndedPalindromicTreeNode(length: -1), DoubleEndedPalindromicTreeNode()]
        result.children = newSeq[int](2 * amax)
        result.direct = newSeq[int](2 * amax)
        result.data = initDeque[DoubleEndedPalindromicTreeEntry]()

    proc len*(self: DoubleEndedPalindromicTree): int =
        ## 現在の文字列の長さを O(1) で返す。
        self.data.len

    proc isEmpty*(self: DoubleEndedPalindromicTree): bool =
        ## 現在の文字列が空かを O(1) で返す。
        self.data.len == 0

    proc count_distinct_palindromes*(self: DoubleEndedPalindromicTree): int =
        ## 現在の文字列に含まれる異なる非空回文の個数を O(1) で返す。
        self.nodes.len - self.freeCount - 2

    proc count_palindromes*(self: DoubleEndedPalindromicTree): int64 =
        ## 現在の文字列の非空回文の出現総数を O(1) で返す。位置が異なる出現も数える。
        self.total

    proc longest_prefix_palindrome*(self: DoubleEndedPalindromicTree): int =
        ## 最長回文接頭辞の長さを O(1) で返す。空文字列なら0。
        if self.data.len == 0: return 0
        self.nodes[self.data.peekFirst.prefixSurface].length

    proc longest_suffix_palindrome*(self: DoubleEndedPalindromicTree): int =
        ## 最長回文接尾辞の長さを O(1) で返す。空文字列なら0。
        if self.data.len == 0: return 0
        self.nodes[self.data.peekLast.suffixSurface].length

    proc addNode(self: var DoubleEndedPalindromicTree, parent, suffix, value, preceding: int): int =
        ## ノードを作り、真の接尾辞のうち各文字で延長可能な最長のものを償却 O(σ) で記録する。
        let sigma = self.alphabetSize
        if self.freeCount > 0:
            result = self.freeHead
            self.freeHead = self.nodes[result].parent
            dec self.freeCount
        else:
            result = self.nodes.len
            self.nodes.add(DoubleEndedPalindromicTreeNode())
            self.children.setLen(self.nodes.len * sigma)
            self.direct.setLen(self.nodes.len * sigma)
        self.nodes[result] = DoubleEndedPalindromicTreeNode(
            length: self.nodes[parent].length + 2, parent: parent,
            suffix: suffix, depth: self.nodes[suffix].depth + 1)
        for c in 0..<sigma:
            self.children[result * sigma + c] = 0
            self.direct[result * sigma + c] = self.direct[suffix * sigma + c]
        self.direct[result * sigma + preceding] = suffix
        self.children[parent * sigma + value] = result
        inc self.nodes[suffix].suffixChildren

    proc push(self: var DoubleEndedPalindromicTree, value: int, front: static[bool]) =
        ## 指定側に1文字追加し、変化するsurfaceだけを更新する。償却 O(σ)。
        assert self.alphabetSize > 0 and value >= 0 and value < self.alphabetSize
        template entry(i: int): untyped =
            when front: self.data[i]
            else: self.data[self.data.len - 1 - i]
        template nearSurface(i: int): untyped =
            when front: entry(i).prefixSurface
            else: entry(i).suffixSurface
        template farSurface(i: int): untyped =
            when front: entry(i).suffixSurface
            else: entry(i).prefixSurface

        var parent = if self.data.len == 0: 1 else: nearSurface(0)
        let item = DoubleEndedPalindromicTreeEntry(value: value, prefixSurface: 1, suffixSurface: 1)
        when front: self.data.addFirst(item)
        else: self.data.addLast(item)
        let sigma = self.alphabetSize
        let opposite = self.nodes[parent].length + 1
        if opposite >= self.data.len or entry(opposite).value != value:
            parent = self.direct[parent * sigma + value]
        var node = self.children[parent * sigma + value]
        if node == 0:
            let suffix = if parent == 0: 1
                else: self.children[self.direct[parent * sigma + value] * sigma + value]
            node = self.addNode(parent, suffix, value, entry(self.nodes[suffix].length).value)

        let length = self.nodes[node].length
        let suffix = self.nodes[node].suffix
        let suffixLength = self.nodes[suffix].length
        nearSurface(0) = node
        farSurface(length - 1) = node
        if suffixLength > 0 and nearSurface(length - suffixLength) == suffix:
            nearSurface(length - suffixLength) = 1
        inc self.nodes[node].longestCount
        self.total += int64(self.nodes[node].depth)

    proc pop(self: var DoubleEndedPalindromicTree, front: static[bool]) =
        ## 指定側から1文字削除し、露出するsurfaceと不要なノードを O(1) で更新する。
        if self.data.len == 0:
            raise newException(IndexDefect, "the palindromic tree is empty")
        template entry(i: int): untyped =
            when front: self.data[i]
            else: self.data[self.data.len - 1 - i]
        template nearSurface(i: int): untyped =
            when front: entry(i).prefixSurface
            else: entry(i).suffixSurface
        template farSurface(i: int): untyped =
            when front: entry(i).suffixSurface
            else: entry(i).prefixSurface

        let node = nearSurface(0)
        let suffix = self.nodes[node].suffix
        let length = self.nodes[node].length
        let suffixLength = self.nodes[suffix].length
        farSurface(length - 1) = 1
        if suffixLength > 0 and self.nodes[nearSurface(length - suffixLength)].length < suffixLength:
            nearSurface(length - suffixLength) = suffix
            farSurface(length - 1) = suffix
        dec self.nodes[node].longestCount
        self.total -= int64(self.nodes[node].depth)
        # 最長回文としての出現もsuffix linkの子もなくなったノードだけが消える。
        if self.nodes[node].longestCount == 0 and self.nodes[node].suffixChildren == 0:
            self.children[self.nodes[node].parent * self.alphabetSize + entry(0).value] = 0
            dec self.nodes[suffix].suffixChildren
            self.nodes[node].parent = self.freeHead
            self.freeHead = node
            inc self.freeCount
        when front: discard self.data.popFirst()
        else: discard self.data.popLast()

    proc push_front*(self: var DoubleEndedPalindromicTree, value: int) =
        ## 先頭に 0..<amax の整数を追加する。償却 O(σ)。
        self.push(value, true)

    proc push_back*(self: var DoubleEndedPalindromicTree, value: int) =
        ## 末尾に 0..<amax の整数を追加する。償却 O(σ)。
        self.push(value, false)

    proc push_front*(self: var DoubleEndedPalindromicTree, value: char) =
        ## 先頭に文字を追加する。初期化時のcとの差が 0..<amax に入る必要がある。償却 O(σ)。
        self.push_front(ord(value) - ord(self.charOffset))

    proc push_back*(self: var DoubleEndedPalindromicTree, value: char) =
        ## 末尾に文字を追加する。初期化時のcとの差が 0..<amax に入る必要がある。償却 O(σ)。
        self.push_back(ord(value) - ord(self.charOffset))

    proc pop_front*(self: var DoubleEndedPalindromicTree) =
        ## 先頭を1文字削除する。O(1)。空ならIndexDefect。
        self.pop(true)

    proc pop_back*(self: var DoubleEndedPalindromicTree) =
        ## 末尾を1文字削除する。O(1)。空ならIndexDefect。
        self.pop(false)

    proc initDoubleEndedPalindromicTree*(a: openArray[int], amax: int = -1): DoubleEndedPalindromicTree =
        ## 非負整数列から O(σ(|a| + 1)) で構築する。amax省略時は最大値+1（空なら1）。
        var sigma = amax
        if sigma < 0:
            sigma = 1
            for value in a:
                assert value >= 0 and value < int.high
                sigma = max(sigma, value + 1)
        result = initDoubleEndedPalindromicTree(sigma)
        for value in a:
            result.push_back(value)

    proc initDoubleEndedPalindromicTree*(s: openArray[char], c: char = 'a', amax: int = 26): DoubleEndedPalindromicTree =
        ## 文字列から O(amax(|s| + 1)) で構築する。既定の文字範囲は 'a'..'z'。
        result = initDoubleEndedPalindromicTree(amax, c)
        for value in s:
            result.push_back(value)
