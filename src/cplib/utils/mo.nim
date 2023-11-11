when not declared CPLIB_UTILS_MO:
    {.checks: off.}
    const CPLIB_UTILS_MO* = 1
    import std/math, std/algorithm
    type Mo* = object
        width: int
        N, Q: int
        qli: seq[seq[int]]
        size: int

    proc initMo*(N, Q: int, width = max(1, int(1.0 * float(N) / max(1.0, sqrt(float(Q) * 2.0 / 3.0))))): Mo =
        result.width = width
        result.N = N
        result.Q = Q
        let qlisize = Q div width + 1
        result.qli = newSeq[seq[int]](qlisize)

    proc insert*(self: var Mo, l, r: int) =
        self.qli[l div self.width].add((r shl 40) or ((l) shl 20) or self.size)
        self.size += 1

    proc run*[AL, AR, DL, DR, REM](self: var Mo, add_left: AL, add_right: AR,delete_left: DL, delete_right: DR, rem: REM) =
        var nl = 0
        var nr = 0
        const mask2 = ((1 shl 20)-1) shl 20
        const mask3 = ((1 shl 20)-1)
        for i in 0..<len(self.qli):
            if len(self.qli[i]) == 0:
                continue
            sort(self.qli[i])
            if (i and 1) == 1:
                reverse(self.qli[i])
            for x in self.qli[i]:
                let ri = x shr 40
                let li = (x and mask2) shr 20
                let idx = x and mask3
                while nl > li: nl.dec; add_left(nl)
                while nr < ri: add_right(nr); nr.inc
                while nl < li: delete_left(nl); nl.inc
                while nr > ri: nr.dec; delete_right(nr)
                rem(idx)


