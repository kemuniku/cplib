when not declared CPLIB_COLLECTIONS_STATICRMQ:
    const CPLIB_COLLECTIONS_STATICRMQ* = 1
    import bitops
    # https://maspypy.com/library-checker-static-rmq
    const staticRMQBlockShift = 5
    const staticRMQBlockSize = 1 shl staticRMQBlockShift
    type StaticRMQ*[T] = object
        table: seq[seq[T]]
        suffix_product, prefix_product, V: seq[T]
    proc initRMQ*[T](V: openArray[T]): StaticRMQ[T] =
        ## 配列の区間最小値を求めるためのテーブルを構築する。
        result.V = @V
        let n = V.len
        if n == 0: return
        result.suffix_product = newSeq[T](n)
        result.prefix_product = newSeq[T](n)
        let blocks = ((n - 1) shr staticRMQBlockShift) + 1
        result.table = newSeq[seq[T]](fastLog2(blocks) + 1)
        result.table[0] = newSeq[T](blocks)
        for b in 0..<blocks:
            let first = b shl staticRMQBlockShift
            let last = min(first + staticRMQBlockSize, n) - 1
            result.prefix_product[first] = V[first]
            for i in first+1..last:
                result.prefix_product[i] = min(result.prefix_product[i-1], V[i])
            result.suffix_product[last] = V[last]
            for i in countdown(last-1, first):
                result.suffix_product[i] = min(result.suffix_product[i+1], V[i])
            result.table[0][b] = result.suffix_product[first]
        for k in 1..<result.table.len:
            result.table[k] = newSeq[T](blocks - (1 shl k) + 1)
            for i in 0..<result.table[k].len:
                result.table[k][i] = min(result.table[k-1][i], result.table[k-1][i + (1 shl (k-1))])
    proc query*[T](rmq: StaticRMQ[T], l, r: int): T {.inline.} =
        ## 半開区間 [l, r) の最小値を返す。
        assert 0 <= l and l < r and r <= rmq.V.len
        let last = r - 1
        let a = l shr staticRMQBlockShift
        let b = last shr staticRMQBlockShift
        if a == b:
            result = rmq.V[l]
            for i in l+1..last:
                result = min(result, rmq.V[i])
            return
        result = min(rmq.suffix_product[l], rmq.prefix_product[last])
        if a + 1 < b:
            let k = fastLog2(b - a - 1)
            result = min(result, min(rmq.table[k][a + 1], rmq.table[k][b - (1 shl k)]))
