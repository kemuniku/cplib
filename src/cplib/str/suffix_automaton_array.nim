when not declared CPLIB_STR_SUFFIX_AUTOMATON_ARRAY:
    ## 固定ordinal範囲のarray遷移で連続部分文字列を認識するオンラインSuffix Automaton。
    ## TはOrdinalの組み込み整数・char・bool・穴なしenumとそれらのrange型。
    ## 疎なenum・float・distinct型は非対応。
    ## 初期化のalphabetはコンパイル時の非空HSlice[T,T]、幅σは1..65536。
    ## 型はSuffixAutomatonArray[T, σ]、下限・上限は各インスタンスが保持する。
    ## stringはT=charのときUnicode文字でなくbyte列として扱う。
    ## 任意のhashable要素列のtable版は cplib/str/suffix_automaton_table を使う。
    ## 1状態は終端位置集合が等しい文字列群を表し、単一の文字列とは限らない。
    ## 状態vの長さ範囲は nodes[nodes[v].link].len + 1 .. nodes[v].len（根を除く）。
    ## 根からの経路が全連続部分文字列、lastからsuffix linkをたどった状態が全suffixを表す。
    ## extend後も状態IDは有効だが、既存状態のlinkとnextは変わる場合がある。
    ## nodes[v].next[i]は下限からi番目の要素でのint32遷移先、不在は -1。
    ## 添字の取得はalphabetIndex(c)、範囲の取得はalphabet()。cloneの配列は値コピーで独立する。
    ## 節点数がint32.high以上ならextendは変更前にValueError。公開メソッドのIDはint。
    ## 初期化した空SAMは根1状態、空文字列を認識し、異なる部分文字列数は空を除いて0。
    ## default値は範囲未設定。findNodeは空も -1、extendはValueError。必ずinitで範囲を設定する。
    ## occurrence集約や終端フラグは保持しない。nodes・lastの直接変更は不可。
    ## σは上下限のordinal差+1。符号なし64bitで検査し、整数境界でもordや符号付き差のoverflowを避ける。
    ## N要素の構築時間・空間 O((N + 1)σ)。配列幅の上限は巨大な固定配列を避けるため。
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
    ##   let integers = initSuffixAutomatonArray(@[-2, 0, -2], -3..1)  # T=int, σ=5
    const CPLIB_STR_SUFFIX_AUTOMATON_ARRAY* = 1

    const SuffixAutomatonArrayMaxAlphabetSize* = 65536

    proc suffixAutomatonArrayOrdinal[T: Ordinal](c: T): uint64 =
        ## 要素を順序を保つ符号なし64bitへ変換する。O(1)。
        when T is distinct:
            {.error: "SuffixAutomatonArray does not support distinct element types".}
        elif T is SomeUnsignedInt:
            return uint64(c)
        elif T is SomeSignedInt:
            return cast[uint64](int64(c)) xor (1'u64 shl 63)
        else:
            return cast[uint64](int64(ord(c))) xor (1'u64 shl 63)

    proc suffixAutomatonArrayWidth[T: Ordinal](alphabet: HSlice[T, T]): int {.compileTime.} =
        ## 非空・配列幅上限をoverflow前に検査する。O(1)。
        if alphabet.a > alphabet.b:
            raise newException(ValueError, "SuffixAutomatonArray requires a nonempty ordinal range")
        let span = suffixAutomatonArrayOrdinal(alphabet.b) - suffixAutomatonArrayOrdinal(alphabet.a)
        if span >= uint64(SuffixAutomatonArrayMaxAlphabetSize):
            raise newException(ValueError, "SuffixAutomatonArray alphabet exceeds 65536 elements")
        return int(span) + 1

    proc checkedSuffixAutomatonArraySize(size: int): int {.compileTime.} =
        ## 型を直接指定した場合も配列幅を検査する。O(1)。
        if size < 1 or size > SuffixAutomatonArrayMaxAlphabetSize:
            raise newException(ValueError, "SuffixAutomatonArray alphabet size must be in 1..65536")
        return size

    type
        SuffixAutomatonArrayNode*[T; alphabetSize: static[int]] = object
            ## 根は0。lenは最大長、linkはsuffix link（根では -1）、nextは下限からの添字で引く。
            len*: int
            link*: int
            next*: array[checkedSuffixAutomatonArraySize(alphabetSize), int32]
        SuffixAutomatonArray*[T: Ordinal; alphabetSize: static[int]] = object
            ## initSuffixAutomatonArrayで初期化する。公開フィールドは参照・遷移列挙用。
            nodes*: seq[SuffixAutomatonArrayNode[T, alphabetSize]]
            last*: int
            symbols: HSlice[T, T]

    proc initSuffixAutomatonArrayNode[T: Ordinal](_: typedesc[T]; alphabetSize: static[int]): SuffixAutomatonArrayNode[T, alphabetSize] =
        ## 全遷移を不在にした状態を作る。O(σ)。
        for i in 0..<alphabetSize:
            result.next[i] = -1

    proc initSuffixAutomatonArray*[T: Ordinal](alphabet: static[HSlice[T, T]]): auto =
        ## 指定範囲の空SAMを作る。空・幅65536超はコンパイルエラー。時間・空間 O(σ)。
        const size = suffixAutomatonArrayWidth(alphabet)
        var sam = SuffixAutomatonArray[T, size](symbols: alphabet)
        var node = initSuffixAutomatonArrayNode(T, size)
        node.link = -1
        sam.nodes.add(node)
        return sam

    proc alphabet*[T; alphabetSize](self: SuffixAutomatonArray[T, alphabetSize]): HSlice[T, T] =
        ## 初期化時の要素範囲を返す。初期化済みのSAMで使用する。O(1)。
        return self.symbols

    proc alphabetIndex*[T; alphabetSize](self: SuffixAutomatonArray[T, alphabetSize]; c: T): int =
        ## 範囲内要素の配列添字を返す。未初期化・範囲外は -1。O(1)。
        if self.nodes.len == 0 or c < self.symbols.a or c > self.symbols.b:
            return -1
        return int(suffixAutomatonArrayOrdinal(c) - suffixAutomatonArrayOrdinal(self.symbols.a))

    proc extend*[T; alphabetSize](self: var SuffixAutomatonArray[T, alphabetSize]; c: T): int =
        ## 末尾に1要素追加し全体の状態IDを返す。全N要素で O((N + 1)σ)。範囲外は変更前にValueError。
        if self.nodes.len == 0:
            raise newException(ValueError, "SuffixAutomatonArray requires initialization")
        let index = self.alphabetIndex(c)
        if index == -1:
            raise newException(ValueError, "element outside SuffixAutomatonArray alphabet")
        if self.nodes.len >= int(high(int32)):
            raise newException(ValueError, "too many SuffixAutomatonArray states")
        result = self.nodes.len
        var node = initSuffixAutomatonArrayNode(T, alphabetSize)
        node.len = self.nodes[self.last].len + 1
        self.nodes.add(node)
        var p = self.last
        while p != -1 and self.nodes[p].next[index] == -1:
            self.nodes[p].next[index] = int32(result)
            p = self.nodes[p].link
        if p != -1:
            let q = int(self.nodes[p].next[index])
            if self.nodes[p].len + 1 == self.nodes[q].len:
                self.nodes[result].link = q
            else:
                let clone = self.nodes.len
                var cloned = self.nodes[q]
                cloned.len = self.nodes[p].len + 1
                self.nodes.add(cloned)
                while p != -1 and int(self.nodes[p].next[index]) == q:
                    self.nodes[p].next[index] = int32(clone)
                    p = self.nodes[p].link
                self.nodes[q].link = clone
                self.nodes[result].link = clone
        self.last = result

    proc initSuffixAutomatonArray*[T: Ordinal](s: openArray[T]; alphabet: static[HSlice[T, T]]): auto =
        ## 要素列から構築する。範囲外はValueError。時間・空間 O((|s| + 1)σ)。
        var sam = initSuffixAutomatonArray(alphabet)
        for c in s:
            discard sam.extend(c)
        return sam

    proc root*[T; alphabetSize](self: SuffixAutomatonArray[T, alphabetSize]): int =
        ## 根の状態ID（0）を返す。O(1)。
        return 0

    proc nodeCount*[T; alphabetSize](self: SuffixAutomatonArray[T, alphabetSize]): int =
        ## 根・cloneを含む状態数を返す。O(1)。
        return self.nodes.len

    proc next*[T; alphabetSize](self: SuffixAutomatonArray[T, alphabetSize]; node: int; c: T): int =
        ## 有効な状態nodeからcで遷移したIDを返す。不在・範囲外は -1。変更せず O(1)。
        let index = self.alphabetIndex(c)
        if index == -1:
            return -1
        return int(self.nodes[node].next[index])

    proc findNode*[T; alphabetSize](self: SuffixAutomatonArray[T, alphabetSize]; s: openArray[T]): int =
        ## 連続部分文字列sをたどる。空は根、不在・範囲外は -1。O(|s| + 1)。
        if self.nodes.len == 0:
            return -1
        for c in s:
            result = self.next(result, c)
            if result == -1:
                return

    proc contains*[T; alphabetSize](self: SuffixAutomatonArray[T, alphabetSize]; s: openArray[T]): bool =
        ## 連続部分文字列sが存在するかを返す。空も含む。範囲外はfalse。O(|s| + 1)。
        return self.findNode(s) != -1

    proc countDistinctSubstrings*[T; alphabetSize](self: SuffixAutomatonArray[T, alphabetSize]): int64 =
        ## 空を除く異なる連続部分文字列の個数を返す。時間 O(状態数)、追加空間 O(1)。
        for node in 1..<self.nodes.len:
            result += int64(self.nodes[node].len - self.nodes[self.nodes[node].link].len)
