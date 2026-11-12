when not declared CPLIB_STR_PALINDROMIC_TREE_TABLE:
    ## 末尾追加に対応する回文木。Tはハッシュと等値比較に対応する型。
    ## 計算量は要素のコピー・ハッシュ・等値比較がO(1)の場合。Tableの操作にはハッシュの平均O(1)を仮定する。
    const CPLIB_STR_PALINDROMIC_TREE_TABLE* = 1
    import tables

    type
        TablePalindromicTreeCountState = ref object
            updated: bool
        TablePalindromicTreeNode*[T] = ref object
            link*: Table[T, TablePalindromicTreeNode[T]]
            parent*: TablePalindromicTreeNode[T] # linkの逆向きのリンク。根ではnil
            suffix_link*: TablePalindromicTreeNode[T]
            series_link*: TablePalindromicTreeNode[T] # 長さの差分が異なる最長の接尾回文へのリンク
            character*: T # 親の両端に追加した要素。根では使用しない
            len, id, diff: int
            terminal_count, total_count: int
            count_state: TablePalindromicTreeCountState
        TablePalindromicTree*[T] = object
            data: seq[T]
            count_state: TablePalindromicTreeCountState
            nodes*: seq[TablePalindromicTreeNode[T]]
            last_node*: TablePalindromicTreeNode[T]
            prefix_nodes*: seq[TablePalindromicTreeNode[T]] # 各接頭辞の最長回文接尾辞。空の接頭辞は含まない

    proc len*[T](node: TablePalindromicTreeNode[T]): int =
        ## 回文の長さをO(1)で返す。
        node.len

    proc count*[T](node: TablePalindromicTreeNode[T]): int =
        ## O(1)。update_count後は総出現回数、構築・追加後は最長回文接尾辞としての出現回数を返す。
        if node.count_state.updated: node.total_count else: node.terminal_count

    proc id*[T](node: TablePalindromicTreeNode[T]): int =
        ## ノードのIDをO(1)で返す。長さ-1と0の根のIDはそれぞれ0と1。
        node.id

    proc diff*[T](node: TablePalindromicTreeNode[T]): int =
        ## suffix_link先との長さの差をO(1)で返す。根では0を返す。
        node.diff

    proc len*[T](pt: TablePalindromicTree[T]): int =
        ## 現在の列の長さをO(1)で返す。
        pt.data.len

    proc newTablePalindromicTreeNode[T](pt: var TablePalindromicTree[T], length: int): TablePalindromicTreeNode[T] =
        ## ノードを生成して木に追加する。償却O(1)。
        result = TablePalindromicTreeNode[T](link: initTable[T, TablePalindromicTreeNode[T]](2),
            len: length, id: pt.nodes.len, count_state: pt.count_state)
        pt.nodes.add(result)

    proc initTablePalindromicTree*[T](): TablePalindromicTree[T] =
        ## 空の回文木をO(1)で作る。last_nodeは長さ0の根を指す。
        result.count_state = TablePalindromicTreeCountState()
        discard result.newTablePalindromicTreeNode(-1)
        discard result.newTablePalindromicTreeNode(0)
        result.nodes[1].suffix_link = result.nodes[0]
        result.nodes[1].series_link = result.nodes[0]
        result.last_node = result.nodes[1]

    proc find_longest[T](pt: TablePalindromicTree[T], node: TablePalindromicTreeNode[T]): TablePalindromicTreeNode[T] =
        ## 末尾の要素で両端を拡張できる最長の接尾回文を探す。最悪O(pt.len)。
        result = node
        let pos = pt.data.len - 1
        while true:
            let left = pos - result.len - 1
            if left >= 0 and pt.data[left] == pt.data[pos]: return
            result = result.suffix_link

    proc add*[T](pt: var TablePalindromicTree[T], value: T): TablePalindromicTreeNode[T] {.discardable.} =
        ## 末尾に要素を追加し、最長回文接尾辞を返す。期待償却O(1)、1回の最悪O(pt.len)。
        ## 出現回数の集計を無効化する。総出現回数が必要ならupdate_countで再集計する。
        pt.data.add(value)
        let parent = pt.find_longest(pt.last_node)
        result = parent.link.getOrDefault(value)
        if result == nil:
            result = pt.newTablePalindromicTreeNode(parent.len + 2)
            result.parent = parent
            result.character = value
            if parent == pt.nodes[0]:
                result.suffix_link = pt.nodes[1]
            else:
                result.suffix_link = pt.find_longest(parent.suffix_link).link[value]
            let suffix = result.suffix_link
            result.diff = result.len - suffix.len
            result.series_link = if result.diff == suffix.diff: suffix.series_link else: suffix
            parent.link[value] = result
        inc result.terminal_count
        pt.prefix_nodes.add(result)
        pt.last_node = result
        pt.count_state.updated = false

    proc initTablePalindromicTree*[T](a: openArray[T]): TablePalindromicTree[T] =
        ## 列から回文木を構築する。ハッシュと等値比較がO(1)なら期待O(a.len)。
        result = initTablePalindromicTree[T]()
        for value in a:
            result.add(value)

    proc get_palindrome*[T](node: TablePalindromicTreeNode[T]): seq[T] =
        ## 親リンクから回文をO(node.len)で復元する。根では空の列を返す。
        result = newSeq[T](max(0, node.len))
        var current = node
        var left = 0
        var right = result.len - 1
        while current.len > 0:
            result[left] = current.character
            result[right] = current.character
            inc left
            dec right
            current = current.parent

    proc get_palindrome*[T](pt: TablePalindromicTree[T], node: TablePalindromicTreeNode[T]): seq[T] =
        ## 指定したノードの回文をO(node.len)で復元する。
        node.get_palindrome()

    proc update_count*[T](pt: TablePalindromicTree[T]) =
        ## 現在の列での各回文の総出現回数をO(pt.nodes.len)で再集計する。繰り返し呼び出し可能。
        for node in pt.nodes:
            node.total_count = node.terminal_count
        for i in countdown(pt.nodes.len - 1, 1):
            let node = pt.nodes[i]
            node.suffix_link.total_count += node.total_count
        pt.count_state.updated = true
