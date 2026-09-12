## 固定したビット数のbitsetをキーにする多重集合です。bitsetのモジュールと併せてimportします。
## 通常・AVX2・AVX512の動的版と固定長版に対応し、添字0からfalse < trueの辞書順で扱います。
## Nはキーのビット数です。各操作はO(1 + N)（挿入は償却）、lenはO(1)です。
## 分岐を順にたどるためSIMD命令は使用しません。
## ノードは配列に保持し、削除で不要になったノードを再利用します。キーは葉だけにコピーして保持します。
## ノード領域は過去の最大使用数に比例します。圧縮トライではないため、1キーの挿入で最大Nノードを追加します。
## 使用例::
##   import cplib/collections/bitset
##   import cplib/collections/bitset_binary_trie
##   var trie = initBitSetBinaryTrie[BitSet](128)
##   var key = initBitSet(128)
##   key[0] = true
##   trie.incl(key, 2)
##   trie.excl(key)
##   doAssert trie.count(key) == 1
when not declared CPLIB_COLLECTIONS_BITSET_BINARY_TRIE:
    const CPLIB_COLLECTIONS_BITSET_BINARY_TRIE* = 1

    type
        BitSetTrieNode[T] = object
            children: array[2, int]
            count: int
            key: ref T
        BitSetBinaryTrie*[T] = object
            nodes: seq[BitSetTrieNode[T]]
            freeNodes: seq[int]
            h: int

    proc initBitSetBinaryTrie*[T](h: int): BitSetBinaryTrie[T] =
        ## hビットのキーを扱う空の多重集合を構築します。O(1)。
        if h < 0:
            raise newException(ValueError, "BitSet length must be non-negative")
        result.h = h
        result.nodes = @[BitSetTrieNode[T](children: [-1, -1])]

    proc initBitSetBinaryTrie*[T](sample: T): BitSetBinaryTrie[T] =
        ## sampleと同じ型・長さのキーを扱う空集合を構築します。sampleは挿入しません。O(1)。
        mixin len
        initBitSetBinaryTrie[T](sample.len)

    proc len*[T](self: BitSetBinaryTrie[T]): int {.inline.} =
        ## 重複を含めた要素数を返します。O(1)。
        if self.nodes.len == 0: 0 else: self.nodes[0].count

    proc checkKey[T](self: BitSetBinaryTrie[T], x: T) {.inline.} =
        ## 初期化済みであることとキーの長さを検証します。O(1)。
        mixin len
        if self.nodes.len == 0:
            raise newException(ValueError, "BitSetBinaryTrie is not initialized")
        if x.len != self.h:
            raise newException(ValueError, "BitSet length must match trie height")

    proc count*[T](self: BitSetBinaryTrie[T], x: T): int =
        ## xの重複数を返します。O(1 + N)。
        mixin `[]`
        self.checkKey(x)
        var node = 0
        for i in 0..<self.h:
            node = self.nodes[node].children[ord(x[i])]
            if node < 0:
                return 0
        self.nodes[node].count

    proc contains*[T](self: BitSetBinaryTrie[T], x: T): bool =
        ## xが1個以上存在するかを返します。O(1 + N)。
        self.count(x) > 0

    proc newNode[T](self: var BitSetBinaryTrie[T]): int =
        ## 空きノードを再利用し、なければ追加します。償却O(1)。
        if self.freeNodes.len > 0:
            result = self.freeNodes.pop()
        else:
            result = self.nodes.len
            self.nodes.add(BitSetTrieNode[T](children: [-1, -1]))

    proc incl*[T](self: var BitSetBinaryTrie[T], x: T, v: int = 1) =
        ## xをv個挿入します。vは非負です。償却O(1 + N)。
        mixin `[]`
        self.checkKey(x)
        if v < 0:
            raise newException(ValueError, "Multiplicity must be non-negative")
        if v > high(int) - self.len:
            raise newException(OverflowDefect, "BitSetBinaryTrie size overflow")
        if v == 0:
            return
        var node = 0
        self.nodes[node].count += v
        for i in 0..<self.h:
            let bit = ord(x[i])
            if self.nodes[node].children[bit] < 0:
                let child = self.newNode()
                self.nodes[node].children[bit] = child
            node = self.nodes[node].children[bit]
            self.nodes[node].count += v
        if self.nodes[node].key.isNil:
            new(self.nodes[node].key)
            self.nodes[node].key[] = x

    proc excl*[T](self: var BitSetBinaryTrie[T], x: T, v: int = 1) =
        ## xをv個削除します。不足・負のvは変更せずValueErrorにします。O(1 + N)。
        mixin `[]`
        self.checkKey(x)
        if v < 0:
            raise newException(ValueError, "Multiplicity must be non-negative")
        if v == 0:
            return
        var path = @[0]
        for i in 0..<self.h:
            let child = self.nodes[path[^1]].children[ord(x[i])]
            if child < 0:
                raise newException(ValueError, "Not enough copies of key")
            path.add(child)
        if self.nodes[path[^1]].count < v:
            raise newException(ValueError, "Not enough copies of key")
        for node in path:
            self.nodes[node].count -= v
        if self.nodes[path[^1]].count == 0:
            self.nodes[path[^1]].key = nil
        for i in countdown(self.h, 1):
            let node = path[i]
            if self.nodes[node].count != 0:
                break
            self.nodes[path[i - 1]].children[ord(x[i - 1])] = -1
            self.nodes[node] = BitSetTrieNode[T](children: [-1, -1])
            self.freeNodes.add(node)

    proc kth[T](self: BitSetBinaryTrie[T], k: Natural, mask: ptr T): T =
        ## XOR後の辞書順で0始まりk番目の元のキーを返します。O(1 + N)。
        mixin `[]`
        if k >= self.len:
            raise newException(IndexDefect, "BitSetBinaryTrie index out of bounds")
        var node = 0
        var remaining = int(k)
        for i in 0..<self.h:
            let first = if mask.isNil: 0 else: ord(mask[][i])
            let child = self.nodes[node].children[first]
            let firstCount = if child < 0: 0 else: self.nodes[child].count
            if remaining < firstCount:
                node = child
            else:
                remaining -= firstCount
                node = self.nodes[node].children[1 - first]
        result = self.nodes[node].key[]

    proc get_kth*[T](self: BitSetBinaryTrie[T], k: Natural): T =
        ## 辞書順で0始まりk番目のキーを返します。範囲外はIndexDefectです。O(1 + N)。
        self.kth(k, nil)

    proc get_kth*[T](self: BitSetBinaryTrie[T], k: Natural, xor_value: T): T =
        ## xor_valueとのXOR後の辞書順でk番目の元のキーを返します。範囲外はIndexDefectです。O(1 + N)。
        self.checkKey(xor_value)
        self.kth(k, unsafeAddr xor_value)

    proc `[]`*[T](self: BitSetBinaryTrie[T], k: Natural): T =
        ## 辞書順で0始まりk番目のキーを返します。範囲外はIndexDefectです。O(1 + N)。
        self.get_kth(k)

    proc bound[T](self: BitSetBinaryTrie[T], x: T, mask: ptr T, inclusive: bool): int =
        ## XOR後のキーがx未満（inclusiveなら以下）の個数を求めます。O(1 + N)。
        mixin `[]`
        self.checkKey(x)
        var node = 0
        for i in 0..<self.h:
            let first = if mask.isNil: 0 else: ord(mask[][i])
            let bit = ord(x[i])
            if bit == 1:
                let child = self.nodes[node].children[first]
                if child >= 0:
                    result += self.nodes[child].count
            node = self.nodes[node].children[first xor bit]
            if node < 0:
                return
        if inclusive:
            result += self.nodes[node].count

    proc lowerBound*[T](self: BitSetBinaryTrie[T], x: T): int =
        ## 辞書順でx未満の要素数を重複込みで返します。O(1 + N)。
        self.bound(x, nil, false)

    proc upperBound*[T](self: BitSetBinaryTrie[T], x: T): int =
        ## 辞書順でx以下の要素数を重複込みで返します。O(1 + N)。
        self.bound(x, nil, true)

    proc lowerBound*[T](self: BitSetBinaryTrie[T], x, xor_value: T): int =
        ## xor_valueとのXOR後のキーがx未満の要素数を返します。O(1 + N)。
        self.checkKey(xor_value)
        self.bound(x, unsafeAddr xor_value, false)

    proc upperBound*[T](self: BitSetBinaryTrie[T], x, xor_value: T): int =
        ## xor_valueとのXOR後のキーがx以下の要素数を返します。O(1 + N)。
        self.checkKey(xor_value)
        self.bound(x, unsafeAddr xor_value, true)
