when not declared CPLIB_UTILS_MO:
    const CPLIB_UTILS_MO* = 1
    import math, algorithm
    type Mo* = object
        width*: int
        N, Q: int
        qli: seq[seq[int]]
        size: int

    proc initMo*(N, Q: int, width = max(1, int(1.0 * float(N) / max(1.0, sqrt(float(Q) * 2.0 / 3.0))))): Mo =
        ## 長さN、クエリ数Qを想定して初期化する。O(N / width)。
        result.width = width
        result.N = N
        result.Q = Q
        let qlisize = N div width + 1
        result.qli = newSeq[seq[int]](qlisize)

    proc insert*(self: var Mo, l, r: int) =
        ## 半開区間[l, r)を登録する。償却O(1)。
        ## l、r、登録順のクエリ番号（0始まり）は、いずれも20bit以内（0以上2^20未満）であることを要求する。
        assert 0 <= l and l <= r and r <= self.N
        assert r < (1 shl 20)
        assert self.size < (1 shl 20)
        self.qli[l div self.width].add((r shl 40) or ((l) shl 20) or self.size)
        self.size += 1

    template run*(self: var Mo, add_left, add_right, delete_left, delete_right, remember: untyped) =
        ## 登録した区間を処理する。ソートO(Q log Q)、端点移動O(N² / width + Q * width)。
        block:
            {.push checks: off.}
            # ローカルに保持したコールバックを呼び出し側で最適化できるようにする。
            proc executeMo(solver: var Mo) =
                ## コールバックを一度ずつ評価し、登録順の番号で結果を通知する。
                let callbackAddLeft = add_left
                let callbackAddRight = add_right
                let callbackDeleteLeft = delete_left
                let callbackDeleteRight = delete_right
                let callbackRemember = remember
                var nl = 0
                var nr = 0
                const mask2 = ((1 shl 20)-1) shl 20
                const mask3 = ((1 shl 20)-1)
                for i in 0..<len(solver.qli):
                    if len(solver.qli[i]) == 0:
                        continue
                    sort(solver.qli[i])
                    if (i and 1) == 1:
                        reverse(solver.qli[i])
                    for x in solver.qli[i]:
                        let ri = x shr 40
                        let li = (x and mask2) shr 20
                        let idx = x and mask3
                        while nl > li: nl.dec; callbackAddLeft(nl)
                        while nr < ri: callbackAddRight(nr); nr.inc
                        while nl < li: callbackDeleteLeft(nl); nl.inc
                        while nr > ri: nr.dec; callbackDeleteRight(nr)
                        callbackRemember(idx)
            executeMo(self)
            {.pop.}
