when not declared CPLIB_STR_HASHSTRING:
    const CPLIB_STR_HASHSTRING* = 1
    import cplib/utils/backwards_index
    import random
    # -d:cplibHashStringDebug の時だけ生文字列と構成 DAG を保持する。
    # 通常ビルドの型・ハッシュ演算・既定の $ は従来通り。
    # char 入力はコピー O(N)、連結・反復・prefix 除去は追加 O(1) ノード。
    # RollingHash からの変換は元文字列を共有し、切り出しをコピーしない。
    # 長さと反復回数は非負で int に収まること、removePrefix は一致する
    # prefix を渡すことが既存 API の前提。公開 hash の手動変更は追跡しない。
    # 整数入力は char と区別し、元整数値は保持しない。
    when defined(cplibHashStringDebug):
        import strutils
        type
            HashStringDebugKind = enum
                hsChars, hsIntegers, hsUnknown, hsConcat, hsRepeat, hsSlice
            HashStringDebugNode = ref object
                kind: HashStringDebugKind
                size, offset: int
                text: string
                left, right: HashStringDebugNode

        proc debugSource(node: HashStringDebugNode, size: int): HashStringDebugNode =
            ## 手動構築された値の情報欠落を記録する。時間・領域 O(1)。
            if node == nil: HashStringDebugNode(kind: hsUnknown, size: size)
            else: node

        proc debugLeaf(text: string): HashStringDebugNode =
            ## 文字列を保持する葉を作る。時間・領域 O(text.len)。
            HashStringDebugNode(kind: hsChars, size: text.len, text: text)

    type HashString* = object
        hash*: uint
        bpow: uint
        size: int
        when defined(cplibHashStringDebug):
            debugNode: HashStringDebugNode
    const MASK30 = (1u shl 30) - 1
    const MASK31 = (1u shl 31) - 1
    const RH_MOD = (1u shl 61) - 1
    const POW_CALC = 500000

    randomize()

    proc calc_mod(x: uint): uint =
        result = (x shr 61) + (x and RH_MOD)
        if result >= RH_MOD:
            result -= RH_MOD

    proc mul(a, b: uint): uint =
        let
            a_upper = a shr 31
            a_lower = a and MASK31
            b_upper = b shr 31
            b_lower = b and MASK31
            mid = a_lower * b_upper + a_upper * b_lower
            mid_upper = mid shr 30
            mid_lower = mid and MASK30
        result = a_upper * b_upper * 2 + mid_upper + (mid_lower shl 31) + a_lower * b_lower


    proc inner_pow(a: uint, n: int): uint =
        var a = a
        var n = n
        result = 1
        while n > 0:
            if (n and 1) != 0:
                result = mul(result, a).calc_mod
            a = mul(a, a).calc_mod
            n = n shr 1

    let hashstring_base: uint = rand(129u..(1u shl 30))
    let inv_hashstring_base: uint = inner_pow(hashstring_base, int(RH_MOD)-2)
    var pows: seq[uint] = newseq[uint](POW_CALC+1)
    var invpows: seq[uint] = newseq[uint](POW_CALC+1)
    pows[0] = 1
    invpows[0] = 1
    for i in 1..POW_CALC:
        pows[i] = (mul(pows[i-1], hashstring_base).calc_mod)
        invpows[i] = (mul(invpows[i-1], inv_hashstring_base).calc_mod)

    proc base_pow(n: int): uint =
        if n >= len(pows):
            return inner_pow(hashstring_base, n)
        else:
            return pows[n]

    proc tohash*(S: int): HashString =
        result = HashString(hash: uint(S) mod RH_MOD, bpow: hashstring_base, size: 1)
        when defined(cplibHashStringDebug):
            result.debugNode = HashStringDebugNode(kind: hsIntegers, size: 1)

    proc tohash*[T](S: openArray[T]): HashString =
        var hash = 0u
        var tmp = 1u
        for i in countdown(len(S)-1, 0, 1):
            hash = (hash+mul(int(S[i]).tohash.hash, tmp)).calc_mod
            tmp = mul(tmp, hashstring_base).calc_mod
        result = HashString(hash: hash, bpow: base_pow(len(S)), size: len(S))
        when defined(cplibHashStringDebug):
            when T is char:
                var text = newString(S.len)
                for i in 0..<S.len: text[i] = S[i]
                result.debugNode = debugLeaf(text)
            else:
                result.debugNode = HashStringDebugNode(kind: hsIntegers, size: S.len)

    proc tohash*(S: char): HashString =
        result = HashString(hash: uint(int(S)), bpow: hashstring_base, size: 1)
        when defined(cplibHashStringDebug):
            result.debugNode = debugLeaf($S)

    proc get_emptystring_hash*(): HashString =
        result = HashString(hash: 0u, bpow: 1u, size: 0)
        when defined(cplibHashStringDebug):
            result.debugNode = debugLeaf("")

    proc `&`*(L, R: HashString): HashString =
        result = HashString(hash: (mul(L.hash, R.bpow).calc_mod+R.hash).calc_mod, bpow: mul(L.bpow, R.bpow).calc_mod, size: L.size+R.size)
        when defined(cplibHashStringDebug):
            if L.size == 0: result.debugNode = R.debugNode
            elif R.size == 0: result.debugNode = L.debugNode
            else:
                result.debugNode = HashStringDebugNode(kind: hsConcat,
                    size: result.size, left: debugSource(L.debugNode, L.size),
                    right: debugSource(R.debugNode, R.size))

    proc `==`*(L, R: HashString): bool =
        return (L.size == R.size) and (L.hash == R.hash)

    proc len*(H: HashString): int = int(H.size)

    proc `*`*(H: HashString, x: int): HashString =
        var
            size = H.size * x
            bpow = uint(1)
            tmp_hash = H.hash
            tmp_b = H.bpow
            hash = uint(0)
            x = x
        while x > 0:
            if x mod 2 != 0:
                hash = (mul(hash, tmp_b).calc_mod+tmp_hash).calc_mod
                bpow = mul(bpow, tmp_b).calc_mod
            if x > 1:
                tmp_hash = (mul(tmp_hash, tmp_b).calc_mod+tmp_hash).calc_mod
                tmp_b = mul(tmp_b, tmp_b).calc_mod
            x = x shr 1
        result = HashString(hash: hash, bpow: bpow, size: size)
        when defined(cplibHashStringDebug):
            if size == 0: result.debugNode = debugLeaf("")
            else:
                result.debugNode = HashStringDebugNode(kind: hsRepeat,
                    size: size, left: debugSource(H.debugNode, H.size))

    proc removePrefix*(H, prefix: HashString): HashString =
        var hash = (H.hash + (RH_MOD - mul(prefix.hash, base_pow(len(H)-len(prefix))).calc_mod)).calc_mod
        var l = len(H)-len(prefix)
        result = HashString(hash: hash, bpow: base_pow(l), size: l)
        when defined(cplibHashStringDebug):
            if l == 0: result.debugNode = debugLeaf("")
            else:
                result.debugNode = HashStringDebugNode(kind: hsSlice,
                    size: l, offset: prefix.size, left: debugSource(H.debugNode, H.size))

    when defined(cplibHashStringDebug):
        proc debugString*(H: HashString, maxChars: int = 80): string =
            ## 最大 maxChars 要素のプレビューと全長を返す。負の上限は ValueError。
            ## DAG を反復走査し、巨大な反復を実体化しない。k=min(len,maxChars)、
            ## 深さ d に対し時間 O((k+1)(d+1))、追加領域 O(k+d+1)。
            ## char は引用・エスケープし、整数列/情報なしは別の印で表示する。
            if maxChars < 0:
                raise newException(ValueError, "maxChars must be nonnegative")
            type Frame = tuple[node: HashStringDebugNode, start, count: int]
            var stack: seq[Frame] = @[(debugSource(H.debugNode, H.size), 0, min(H.size, maxChars))]
            var text = ""
            var part = ""
            while stack.len > 0:
                let (node, start, count) = stack.pop()
                if count == 0: continue
                if node.kind == hsChars:
                    for i in 0..<count: part.add(node.text[node.offset + start + i])
                    continue
                if node.kind in {hsIntegers, hsUnknown} and part.len > 0:
                    text.add(part.escape())
                    part.setLen(0)
                case node.kind
                of hsChars: discard
                of hsIntegers: text.add("<integers:" & $count & ">")
                of hsUnknown: text.add("<unavailable:" & $count & ">")
                of hsSlice: stack.add((node.left, start + node.offset, count))
                of hsConcat:
                    let leftCount = min(count, max(0, node.left.size - start))
                    if leftCount < count:
                        stack.add((node.right, max(0, start - node.left.size), count - leftCount))
                    if leftCount > 0: stack.add((node.left, start, leftCount))
                of hsRepeat:
                    let offset = start mod node.left.size
                    let firstCount = min(count, node.left.size - offset)
                    if firstCount < count:
                        stack.add((node, start + firstCount, count - firstCount))
                    stack.add((node.left, offset, firstCount))
            if part.len > 0: text.add(part.escape())
            if text.len == 0:
                if H.size == 0 and H.debugNode == nil: text = "<unavailable:0>"
                elif H.size == 0 and H.debugNode.kind == hsIntegers: text = "<integers:0>"
                else: text = "\"\""
            if H.size > maxChars: text.add("...")
            result = text & " (len=" & $H.size & ")"

        proc `$`*(H: HashString): string =
            ## デバッグ定義時のみ、最大80要素のプレビューを返す。
            H.debugString()

    type RollingHashBase = ref object
        S: string
        when defined(cplibHashStringDebug):
            debugNode: HashStringDebugNode
        prefixs: seq[uint]
        size: int

    type RollingHash* = object
        R*: RollingHashBase
        l*: int
        r*: int

    proc len*(S: RollingHashBase): int =
        return int(S.size)

    proc len*(S: RollingHash): int =
        return int(S.r-S.l)

    proc get_substring(R: RollingHashBase, l, r: int): RollingHash =
        # 半開区間とする。
        # 空文字列用にr=0も許容していることに注意。
        # 空文字列はl=0,r=0のみ許容している。
        assert (l == 0 and r == 0) or
            (l in 0..<R.size and r in 1..R.size and l < r), "部分文字列の範囲は0 <= l < r <= R.sizeか、空文字列を表すl == r == 0である必要があります"
        result.R = R
        result.l = l
        result.r = r

    proc `[]`*(R: RollingHashBase, slice: HSlice[int, int]): RollingHash =
        assert slice.a >= 0 and slice.b >= 0, "指定した区間が有効な範囲内である必要があります: slice.a >= 0 and slice.b >= 0"
        return R.get_substring(slice.a, slice.b+1)


    proc `[]`*(S: RollingHash, slice: HSlice[int, int]): RollingHash =
        if len(slice) == 0:
            return S.R.get_substring(0, 0)
        assert slice.a in 0..<len(S) and slice.b in 0..<len(S), "指定した区間が有効な範囲内である必要があります: slice.a in 0 ..< len(S) and slice.b in 0 ..< len(S)"
        return S.R.get_substring(S.l+slice.a, S.l+slice.b+1)

    proc gethash(S: RollingHash, slice: HSlice[int, int]): uint =
        return (S.R.prefixs[(S.l+slice.b+1)] + (RH_MOD - mul(S.R.prefixs[S.l+slice.a], base_pow(((S.l+slice.b+1)-(S.l+slice.a)))).calc_mod)).calc_mod


    proc `[]`*(S: RollingHash, idx: int): char {.backwardsIndex.} =
        return S.R.S[idx+int(S.l)]

    proc initRollingHash*(S: openArray[char]): RollingHash =
        var rolling = RollingHashBase()
        rolling.S = newString(len(S))
        for i in 0..<len(S):
            rolling.S[i] = S[i]
        when defined(cplibHashStringDebug):
            rolling.debugNode = debugLeaf(rolling.S)
        rolling.prefixs = newSeq[uint](len(S)+1)
        rolling.prefixs[0] = 0
        for i in 1..len(S):
            rolling.prefixs[i] = (mul(rolling.prefixs[i-1], hashstring_base) + uint(int(S[i-1]))).calc_mod()
        rolling.size = (len(S))
        if len(S) == 0:
            return RollingHash(R: rolling, l: 0, r: 0)
        return rolling[0..<len(S)]



    converter toHashString*(self: RollingHash): HashString =
        result = HashString(hash: (self.R.prefixs[self.r] + (RH_MOD - mul(self.R.prefixs[self.l], base_pow(self.r-self.l)).calc_mod)).calc_mod, bpow: base_pow(self.r-self.l), size: self.r-self.l)
        when defined(cplibHashStringDebug):
            result.debugNode = HashStringDebugNode(kind: hsSlice,
                size: self.r-self.l, offset: self.l, left: self.R.debugNode)

    proc `$`*(S: RollingHash): string =
        return S.R.S[S.l..<S.r]

    proc `==`*(S, T: RollingHash): bool =
        return len(S) == len(T) and (S.R.prefixs[S.r] + (RH_MOD - mul(S.R.prefixs[S.l], base_pow(S.r-S.l)).calc_mod)).calc_mod ==
            (T.R.prefixs[T.r] + (RH_MOD - mul(T.R.prefixs[T.l], base_pow(T.r-T.l)).calc_mod)).calc_mod

    proc LCP*(S, T: RollingHash): int =
        var ok = 0
        var ng = min(len(S), len(T))+1
        while ng-ok > 1:
            var mid = (ok + ng) div 2
            if S.gethash(0..<mid) == T.gethash(0..<mid): ok = mid
            else: ng = mid
        return ok

    proc cmp*(S, T: RollingHash): int =
        var S = S
        var T = T
        var flg = 1
        if len(S) > len(T):
            swap(S, T)
            flg *= -1
        var lcp = LCP(S, T)
        if len(S) == lcp:
            if len(S) == len(T):
                return 0
            else:
                return -1*flg
        else:
            if S[lcp] < T[lcp]:
                return -1*flg
            else:
                return flg

    proc `<`*(S, T: RollingHash): bool =
        return cmp(S, T) < 0
