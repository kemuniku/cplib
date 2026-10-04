when not declared CPLIB_STR_SUFFIX_AUTOMATON_ARRAY:
    ## 固定文字範囲のarray遷移で連続部分文字列を認識するオンラインSuffix Automaton。
    ## charsはコンパイル時の非空HSlice[char,char]。stringはUnicode文字でなくbyte列として扱う。
    ## 任意のhashable要素列のtable版は cplib/str/suffix_automaton_table を使う。
    ## 1状態は終端位置集合が等しい文字列群を表し、単一の文字列とは限らない。
    ## 状態vの長さ範囲は nodes[nodes[v].link].len + 1 .. nodes[v].len（根を除く）。
    ## 根からの経路が全連続部分文字列、lastからsuffix linkをたどった状態が全suffixを表す。
    ## extend後も状態IDは有効だが、既存状態のlinkとnextは変わる場合がある。
    ## next[c]はint32の遷移先ID、不在は -1。cloneの配列は値コピーで独立する。
    ## 節点数がint32.high以上ならextendは変更前にValueError。公開メソッドのIDはint。
    ## 初期化した空SAMは根1状態、空文字列を認識し、異なる部分文字列数は空を除いて0。
    ## default値は未初期化で、findNodeは空も -1。最初のextendで自動初期化する。
    ## occurrence集約や終端フラグは保持しない。nodes・lastの直接変更は不可。
    ## σ = ord(chars.b) - ord(chars.a) + 1。N文字の構築時間・空間 O((N + 1)σ)。
    ## 配列初期化・cloneのコピーに O(σ)。σ固定ならextendは償却 O(1)。
    ## seqの再確保を含む1回のextendは最悪 O((N + 1)σ)。
    ## 使用例:
    ##   var sam = initSuffixAutomatonArray('a'..'z')
    ##   discard sam.extend('a')
    ##   discard sam.extend('b')
    ##   let v = sam.findNode("ab")  # v == sam.last
    ##   let missing = sam.next(v, 'a')  # -1
    ##   let count = sam.countDistinctSubstrings()  # 3（空を除く）
    ##   let digits = initSuffixAutomatonArray("01201", '0'..'9')
    const CPLIB_STR_SUFFIX_AUTOMATON_ARRAY* = 1

    type
        SuffixAutomatonArrayNode*[chars: static[HSlice[char, char]]] = object
            ## 根は0。lenは最大長、linkはsuffix link（根では -1）、nextは文字で直接添字化する。
            len*: int
            link*: int
            next*: array[chars.a..chars.b, int32]
        SuffixAutomatonArray*[chars: static[HSlice[char, char]]] = object
            ## initSuffixAutomatonArrayで初期化する。公開フィールドは参照・遷移列挙用。
            nodes*: seq[SuffixAutomatonArrayNode[chars]]
            last*: int

    proc initSuffixAutomatonArrayNode(chars: static[HSlice[char, char]]): SuffixAutomatonArrayNode[chars] =
        ## 全遷移を不在にした状態を作る。O(σ)。
        for c in chars.a..chars.b:
            result.next[c] = -1

    proc initSuffixAutomatonArray*(chars: static[HSlice[char, char]]): SuffixAutomatonArray[chars] =
        ## 指定文字範囲の空SAMを作る。逆順の範囲はコンパイルエラー。時間・空間 O(σ)。
        when chars.a > chars.b:
            {.error: "SuffixAutomatonArray requires a nonempty character range".}
        var node = initSuffixAutomatonArrayNode(chars)
        node.link = -1
        result.nodes.add(node)

    proc extend*[chars](self: var SuffixAutomatonArray[chars], c: char): int =
        ## 末尾に1文字追加し全体の状態IDを返す。全N文字で O((N + 1)σ)。範囲外は変更前にValueError。
        if c < chars.a or c > chars.b:
            raise newException(ValueError, "character outside SuffixAutomatonArray alphabet")
        if self.nodes.len >= int(high(int32)):
            raise newException(ValueError, "too many SuffixAutomatonArray states")
        if self.nodes.len == 0:
            self = initSuffixAutomatonArray(chars)
        result = self.nodes.len
        var node = initSuffixAutomatonArrayNode(chars)
        node.len = self.nodes[self.last].len + 1
        self.nodes.add(node)
        var p = self.last
        while p != -1 and self.nodes[p].next[c] == -1:
            self.nodes[p].next[c] = int32(result)
            p = self.nodes[p].link
        if p != -1:
            let q = int(self.nodes[p].next[c])
            if self.nodes[p].len + 1 == self.nodes[q].len:
                self.nodes[result].link = q
            else:
                let clone = self.nodes.len
                var cloned = self.nodes[q]
                cloned.len = self.nodes[p].len + 1
                self.nodes.add(cloned)
                while p != -1 and int(self.nodes[p].next[c]) == q:
                    self.nodes[p].next[c] = int32(clone)
                    p = self.nodes[p].link
                self.nodes[q].link = clone
                self.nodes[result].link = clone
        self.last = result

    proc initSuffixAutomatonArray*(s: openArray[char], chars: static[HSlice[char, char]]): SuffixAutomatonArray[chars] =
        ## 文字列・文字配列から構築する。範囲外はValueError。時間・空間 O((|s| + 1)σ)。
        result = initSuffixAutomatonArray(chars)
        for c in s:
            discard result.extend(c)

    proc root*[chars](self: SuffixAutomatonArray[chars]): int =
        ## 根の状態ID（0）を返す。O(1)。
        return 0

    proc nodeCount*[chars](self: SuffixAutomatonArray[chars]): int =
        ## 根・cloneを含む状態数を返す。O(1)。
        return self.nodes.len

    proc next*[chars](self: SuffixAutomatonArray[chars], node: int, c: char): int =
        ## 有効な状態nodeからcで遷移したIDを返す。不在・範囲外は -1。変更せず O(1)。
        if c < chars.a or c > chars.b:
            return -1
        return int(self.nodes[node].next[c])

    proc findNode*[chars](self: SuffixAutomatonArray[chars], s: openArray[char]): int =
        ## 連続部分文字列sをたどる。空は根、不在・範囲外は -1。O(|s| + 1)。
        if self.nodes.len == 0:
            return -1
        for c in s:
            result = self.next(result, c)
            if result == -1:
                return

    proc contains*[chars](self: SuffixAutomatonArray[chars], s: openArray[char]): bool =
        ## 連続部分文字列sが存在するかを返す。空も含む。範囲外はfalse。O(|s| + 1)。
        return self.findNode(s) != -1

    proc countDistinctSubstrings*[chars](self: SuffixAutomatonArray[chars]): int64 =
        ## 空を除く異なる連続部分文字列の個数を返す。時間 O(状態数)、追加空間 O(1)。
        for node in 1..<self.nodes.len:
            result += int64(self.nodes[node].len - self.nodes[self.nodes[node].link].len)
