when not declared CPLIB_STR_PALINDROMIC_TREE:
    ## 静的な要素範囲をarrayで管理する回文木。文字種数σ、分岐ノード数Bとして空間O(N+σB)。
    ## 使用例: var pt = initPalindromicTree('a'..'z'); pt.add('a')
    ## ノードは内部配列とIDを保持するハンドル。リンクとノード情報は読み取り専用。
    const CPLIB_STR_PALINDROMIC_TREE* = 1
    when NimMajor >= 2:
        type PalindromicTreeAlphabet = HSlice
    else:
        # Nim 1.6では型引数に依存するstatic HSliceを解決できないため、内部だけ整数範囲にする。
        type PalindromicTreeAlphabet = HSlice[int, int]
    type
        PalindromicTreeNodeData[T; alphabet: static[PalindromicTreeAlphabet]] = object
            length, parent, suffix, series: int32
            # 0は子なし、正は唯一の子のID、負は遷移配列の添字を-(添字+1)で保持する。
            children: int32
            terminal_count, total_count: int32
            character: T
        PalindromicTreeStorage[T; alphabet: static[PalindromicTreeAlphabet]] = ref object
            data: seq[T]
            nodes: seq[PalindromicTreeNodeData[T, alphabet]]
            branches: seq[array[alphabet.a..alphabet.b, int32]]
            updated: bool
        PalindromicTreeNode*[T; alphabet: static[PalindromicTreeAlphabet]] = object
            storage: PalindromicTreeStorage[T, alphabet]
            index: int32
        PalindromicTreeLinks*[T; alphabet: static[PalindromicTreeAlphabet]] = object
            storage: PalindromicTreeStorage[T, alphabet]
            parent: int32
        PalindromicTree*[T; alphabet: static[PalindromicTreeAlphabet]] = object
            storage: PalindromicTreeStorage[T, alphabet]
            nodes*: seq[PalindromicTreeNode[T, alphabet]]
            last_node*: PalindromicTreeNode[T, alphabet]
            prefix_nodes*: seq[PalindromicTreeNode[T, alphabet]]

    proc nodeAt[T, alphabet](storage: PalindromicTreeStorage[T, alphabet], index: int32): PalindromicTreeNode[T, alphabet] {.inline.} =
        ## IDからハンドルをO(1)で作る。負のIDなら空のハンドル。
        if index >= 0: result = PalindromicTreeNode[T, alphabet](storage: storage, index: index)

    proc isNil*[T, alphabet](node: PalindromicTreeNode[T, alphabet]): bool {.inline.} =
        ## 空のハンドルかをO(1)で返す。
        node.storage == nil

    proc `==`*[T, alphabet](a, b: PalindromicTreeNode[T, alphabet]): bool {.inline.} =
        ## 同じ木の同じノードかをO(1)で返す。
        a.storage == b.storage and (a.storage == nil or a.index == b.index)

    proc `==`*[T, alphabet](node: PalindromicTreeNode[T, alphabet], value: typeof(nil)): bool {.inline.} =
        ## 空のハンドルとnilの比較をO(1)で行う。
        node.isNil

    proc `==`*[T, alphabet](value: typeof(nil), node: PalindromicTreeNode[T, alphabet]): bool {.inline.} =
        ## nilと空のハンドルの比較をO(1)で行う。
        node.isNil

    proc len*[T, alphabet](node: PalindromicTreeNode[T, alphabet]): int {.inline.} =
        ## 回文の長さをO(1)で返す。
        node.storage.nodes[node.index].length.int

    proc id*[T, alphabet](node: PalindromicTreeNode[T, alphabet]): int {.inline.} =
        ## IDをO(1)で返す。長さ-1と0の根のIDはそれぞれ0と1。
        node.index.int

    proc character*[T, alphabet](node: PalindromicTreeNode[T, alphabet]): T {.inline.} =
        ## 親の両端に追加した要素を返す。根では使用しない。
        node.storage.nodes[node.index].character

    proc parent*[T, alphabet](node: PalindromicTreeNode[T, alphabet]): PalindromicTreeNode[T, alphabet] {.inline.} =
        ## 両端の要素を除いた親をO(1)で返す。根では空のハンドル。
        node.storage.nodeAt(node.storage.nodes[node.index].parent)

    proc suffix_link*[T, alphabet](node: PalindromicTreeNode[T, alphabet]): PalindromicTreeNode[T, alphabet] {.inline.} =
        ## 最長の真の回文接尾辞をO(1)で返す。長さ-1の根では空のハンドル。
        node.storage.nodeAt(node.storage.nodes[node.index].suffix)

    proc series_link*[T, alphabet](node: PalindromicTreeNode[T, alphabet]): PalindromicTreeNode[T, alphabet] {.inline.} =
        ## 長さの差分が異なる最長の接尾回文をO(1)で返す。長さ-1の根では空のハンドル。
        node.storage.nodeAt(node.storage.nodes[node.index].series)

    proc diff*[T, alphabet](node: PalindromicTreeNode[T, alphabet]): int {.inline.} =
        ## suffix_link先との長さの差をO(1)で返す。根では0。
        if node.index < 2: return 0
        let storage = node.storage
        storage.nodes[node.index].length.int - storage.nodes[storage.nodes[node.index].suffix].length.int

    proc count*[T, alphabet](node: PalindromicTreeNode[T, alphabet]): int {.inline.} =
        ## O(1)。update_count後は総出現回数、構築・追加後は最長回文接尾辞としての出現回数。
        if node.storage.updated: node.storage.nodes[node.index].total_count.int
        else: node.storage.nodes[node.index].terminal_count.int

    proc findChild[T, alphabet](storage: PalindromicTreeStorage[T, alphabet], parent: int32, value: T): int32 {.inline.} =
        ## 指定した要素で拡張した子のIDをO(1)で返す。存在しなければ0。
        if ord(value) < ord(alphabet.a) or ord(value) > ord(alphabet.b): return 0
        let children = storage.nodes[parent].children
        if children > 0:
            if storage.nodes[children].character == value: return children
        elif children < 0:
            return storage.branches[-children - 1][typeof(alphabet.a)(value)]

    proc addChild[T, alphabet](storage: PalindromicTreeStorage[T, alphabet], parent, index: int32, value: T) {.inline.} =
        ## 子を登録する。2つ目の子を追加するときだけO(σ)で遷移配列を確保する。
        let children = storage.nodes[parent].children
        if children == 0:
            storage.nodes[parent].children = index
        elif children > 0:
            var branch: typeof(storage.branches[0])
            branch[typeof(alphabet.a)(storage.nodes[children].character)] = children
            branch[typeof(alphabet.a)(value)] = index
            storage.branches.add(branch)
            storage.nodes[parent].children = -int32(storage.branches.len)
        else:
            storage.branches[-children - 1][typeof(alphabet.a)(value)] = index

    proc link*[T, alphabet](node: PalindromicTreeNode[T, alphabet]): PalindromicTreeLinks[T, alphabet] {.inline.} =
        ## 子への遷移の読み取り専用ビューをO(1)で返す。
        PalindromicTreeLinks[T, alphabet](storage: node.storage, parent: node.index)

    proc len*[T, alphabet](links: PalindromicTreeLinks[T, alphabet]): int {.inline.} =
        ## 子の個数をO(σ)で返す。
        let children = links.storage.nodes[links.parent].children
        if children > 0: return 1
        if children < 0:
            for value in alphabet.a..alphabet.b:
                if links.storage.branches[-children - 1][value] != 0: inc result

    proc getOrDefault*[T, alphabet](links: PalindromicTreeLinks[T, alphabet], value: T): PalindromicTreeNode[T, alphabet] {.inline.} =
        ## 子をO(1)で返す。存在しなければ空のハンドル。
        let index = links.storage.findChild(links.parent, value)
        if index != 0: result = links.storage.nodeAt(index)

    proc hasKey*[T, alphabet](links: PalindromicTreeLinks[T, alphabet], value: T): bool {.inline.} =
        ## 対応する子が存在するかをO(1)で返す。
        links.storage.findChild(links.parent, value) != 0

    proc `[]`*[T, alphabet](links: PalindromicTreeLinks[T, alphabet], value: T): PalindromicTreeNode[T, alphabet] {.inline.} =
        ## 子をO(1)で返す。存在しなければKeyError。
        let index = links.storage.findChild(links.parent, value)
        if index == 0: raise newException(KeyError, "palindromic tree transition not found")
        links.storage.nodeAt(index)

    iterator pairs*[T, alphabet](links: PalindromicTreeLinks[T, alphabet]): tuple[key: T, val: PalindromicTreeNode[T, alphabet]] =
        ## 要素と子を列挙する。O(σ)。
        let children = links.storage.nodes[links.parent].children
        if children > 0:
            yield (links.storage.nodes[children].character, links.storage.nodeAt(children))
        elif children < 0:
            for value in alphabet.a..alphabet.b:
                let index = links.storage.branches[-children - 1][value]
                if index != 0:
                    yield (T(value), links.storage.nodeAt(index))

    proc len*[T, alphabet](pt: PalindromicTree[T, alphabet]): int {.inline.} =
        ## 現在の列の長さをO(1)で返す。
        pt.storage.data.len

    proc initPalindromicTree*[T: Ordinal](alphabet: static[HSlice[T, T]], capacity: int = 0): auto =
        ## 静的な要素範囲の空の木を作る。capacity要素分を事前確保し、超えたら自動拡張する。
        ## 初期確保は時間・空間O(capacity+1)。分岐ノード数Bとして構築全体の時間はO(N+σB)。
        when NimMajor >= 2:
            const bounds = alphabet
        else:
            const bounds = ord(alphabet.a)..ord(alphabet.b)
        static: assert bounds.a <= bounds.b
        assert capacity >= 0 and capacity <= int32.high.int - 2
        var pt: PalindromicTree[T, bounds]
        pt.storage = PalindromicTreeStorage[T, bounds](data: newSeqOfCap[T](capacity),
            nodes: newSeqOfCap[PalindromicTreeNodeData[T, bounds]](capacity + 2))
        pt.nodes = newSeqOfCap[PalindromicTreeNode[T, bounds]](capacity + 2)
        pt.prefix_nodes = newSeqOfCap[PalindromicTreeNode[T, bounds]](capacity)
        pt.storage.nodes.add(PalindromicTreeNodeData[T, bounds](length: -1, parent: -1, suffix: -1, series: -1))
        pt.storage.nodes.add(PalindromicTreeNodeData[T, bounds](parent: -1, suffix: 0, series: 0))
        pt.nodes.add(pt.storage.nodeAt(0))
        pt.nodes.add(pt.storage.nodeAt(1))
        pt.last_node = pt.nodes[1]
        pt

    proc find_longest[T, alphabet](storage: PalindromicTreeStorage[T, alphabet], node: int32): int32 {.inline.} =
        ## 末尾の要素で拡張できる最長の接尾回文を探す。最悪O(列の長さ)。
        result = node
        let pos = storage.data.len - 1
        while true:
            let left = pos - storage.nodes[result].length.int - 1
            if left >= 0 and storage.data[left] == storage.data[pos]: return
            result = storage.nodes[result].suffix

    proc add*[T, alphabet](pt: var PalindromicTree[T, alphabet], value: T): PalindromicTreeNode[T, alphabet] {.discardable.} =
        ## 末尾に要素を追加し最長回文接尾辞を返す。償却O(σ)。σ固定なら償却O(1)。
        ## 総出現回数はupdate_countで再集計する。列の長さの上限はint32.high-2。
        let storage = pt.storage
        assert storage.data.len < int32.high.int - 2
        assert ord(value) >= ord(alphabet.a) and ord(value) <= ord(alphabet.b)
        storage.data.add(value)
        let parent = storage.find_longest(pt.last_node.index)
        var index = storage.findChild(parent, value)
        if index == 0:
            let suffix = if parent == 0: 1'i32
                else: storage.findChild(storage.find_longest(storage.nodes[parent].suffix), value)
            let length = storage.nodes[parent].length + 2
            let diff = length - storage.nodes[suffix].length
            let suffixDiff = if suffix < 2: 0'i32
                else: storage.nodes[suffix].length - storage.nodes[storage.nodes[suffix].suffix].length
            let series = if diff == suffixDiff: storage.nodes[suffix].series else: suffix
            index = int32(storage.nodes.len)
            storage.nodes.add(PalindromicTreeNodeData[T, alphabet](length: length, parent: parent,
                suffix: suffix, series: series, character: value))
            pt.nodes.add(storage.nodeAt(index))
            storage.addChild(parent, index, value)
        inc storage.nodes[index].terminal_count
        result = storage.nodeAt(index)
        pt.prefix_nodes.add(result)
        pt.last_node = result
        storage.updated = false

    proc initPalindromicTree*[T: Ordinal](a: openArray[T], alphabet: static[HSlice[T, T]]): auto =
        ## 静的な要素範囲を指定し、列からO(σ(a.len+1))で構築する。
        var pt = initPalindromicTree(alphabet, a.len)
        for value in a:
            pt.add(value)
        pt

    proc initPalindromicTree*(s: openArray[char]): auto =
        ## 英小文字列から回文木をO(s.len+1)で構築する。
        initPalindromicTree(s, 'a'..'z')

    proc get_palindrome*[T, alphabet](node: PalindromicTreeNode[T, alphabet]): seq[T] =
        ## 親リンクから回文をO(node.len)で復元する。根では空の列。
        result = newSeq[T](max(0, node.len))
        var index = node.index
        var left = 0
        var right = result.len - 1
        while node.storage.nodes[index].length > 0:
            result[left] = node.storage.nodes[index].character
            result[right] = node.storage.nodes[index].character
            inc left
            dec right
            index = node.storage.nodes[index].parent

    proc get_palindrome*[T, alphabet](pt: PalindromicTree[T, alphabet], node: PalindromicTreeNode[T, alphabet]): seq[T] =
        ## 指定したノードの回文をO(node.len)で復元する。
        node.get_palindrome()

    proc update_count*[T, alphabet](pt: PalindromicTree[T, alphabet]) =
        ## 各回文の総出現回数をO(pt.nodes.len)で再集計する。繰り返し呼び出し可能。
        let storage = pt.storage
        for node in storage.nodes.mitems:
            node.total_count = node.terminal_count
        for i in countdown(storage.nodes.len - 1, 1):
            let suffix = storage.nodes[i].suffix
            storage.nodes[suffix].total_count += storage.nodes[i].total_count
        storage.updated = true
