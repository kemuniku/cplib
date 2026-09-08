when not declared CPLIB_MATH_BIGINT:
    const CPLIB_MATH_BIGINT* = 1
    import hashes
    import cplib/convolution/convolution

    ## 符号付き多倍長整数。初期値は 0 で、整数からの暗黙変換に対応する。
    ## 10^9 進の桁数を n, m として、加減算は O(max(n, m))。
    ## 大きな数の乗算は既存の NTT を使い O((n + m) log(n + m))、筆算では O(nm)。
    ## NTT は amd64 の C++・AVX2 環境で、変換長 2^24 以下の場合に使用する。
    ## 大きな数の除算は整数の逆数を Newton 法で求め、NTT 利用時に O(n log n)。
    ## 筆算の除算は n >= m のとき O((n - m + 1)m)、文字列との変換は文字数に比例する。
    ## 除数や商が小さい場合、NTT の対応範囲外、コンパイル時評価では筆算を使う。
    ## 高速除算の補助領域は O(n)。
    ## div は 0 方向に丸め、mod の符号は被除数に合わせる。
    type BigInt* = object
        sign: int
        digits: seq[uint32]

    const BigIntBase = 1_000_000_000'u64

    proc normalize(x: var BigInt) =
        ## 上位の不要な 0 を除き、0 の符号を統一する。
        while x.digits.len > 0 and x.digits[^1] == 0:
            x.digits.setLen(x.digits.len - 1)
        if x.digits.len == 0:
            x.sign = 0

    proc initBigInt*[T: SomeInteger](x: T): BigInt =
        ## 組み込み整数から多倍長整数を作る。
        var magnitude: uint64
        when T is SomeSignedInt:
            if x < 0:
                result.sign = -1
                magnitude = uint64(-(x + 1)) + 1'u64
            else:
                magnitude = uint64(x)
        else:
            magnitude = uint64(x)
        if magnitude != 0 and result.sign == 0:
            result.sign = 1
        if magnitude != 0:
            let size = if magnitude < BigIntBase: 1
                elif magnitude < BigIntBase * BigIntBase: 2 else: 3
            result.digits = newSeq[uint32](size)
            for i in 0..<size:
                result.digits[i] = uint32(magnitude mod BigIntBase)
                magnitude = magnitude div BigIntBase

    proc parseBigInt*(s: string): BigInt =
        ## 符号付き 10 進文字列を変換し、空文字列や不正な文字には ValueError を送出する。
        if s.len == 0:
            raise newException(ValueError, "多倍長整数の文字列が空です")
        var first = 0
        result.sign = 1
        if s[0] == '+' or s[0] == '-':
            if s[0] == '-':
                result.sign = -1
            first = 1
        if first == s.len:
            raise newException(ValueError, "多倍長整数の数字がありません")
        result.digits = newSeq[uint32]((s.len - first + 8) div 9)
        var last = s.len
        var index = 0
        while last > first:
            let start = max(first, last - 9)
            var digit = 0'u32
            for i in start..<last:
                if s[i] < '0' or s[i] > '9':
                    raise newException(ValueError, "多倍長整数に不正な文字が含まれています")
                digit = digit * 10 + uint32(ord(s[i]) - ord('0'))
            result.digits[index] = digit
            inc index
            last = start
        result.normalize()

    proc initBigInt*(s: string): BigInt =
        ## 符号付き 10 進文字列から多倍長整数を作る。
        parseBigInt(s)

    converter toBigInt*(x: SomeInteger): BigInt =
        ## 組み込み整数を多倍長整数に暗黙変換する。
        initBigInt(x)

    proc `$`*(x: BigInt): string =
        ## 符号付き 10 進文字列を返す。
        if x.sign == 0:
            return "0"
        if x.digits.len <= 2:
            var value = uint64(x.digits[0])
            if x.digits.len == 2:
                value += uint64(x.digits[1]) * BigIntBase
            if x.sign < 0:
                return system.`$`(-int64(value))
            return system.`$`(value)
        const pairs = "00010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899"
        let top = system.`$`(uint64(x.digits[^1]))
        let signLen = ord(x.sign < 0)
        result = newString((x.digits.len - 1) * 9 + top.len + signLen)
        if x.sign < 0:
            result[0] = '-'
        for i in 0..<top.len:
            result[signLen + i] = top[i]
        var position = result.len
        for i in 0..<x.digits.len - 1:
            var digit = x.digits[i]
            for _ in 0..<4:
                let pair = int(digit mod 100) * 2
                result[position - 1] = pairs[pair + 1]
                result[position - 2] = pairs[pair]
                position -= 2
                digit = digit div 100
            result[position - 1] = char(ord('0') + int(digit))
            dec position

    proc isZero*(x: BigInt): bool =
        ## 0 かどうかを返す。
        x.sign == 0

    proc sgn*(x: BigInt): int =
        ## 符号を -1, 0, 1 のいずれかで返す。
        x.sign

    proc abs*(x: BigInt): BigInt =
        ## 絶対値を返す。
        result = x
        if result.sign < 0:
            result.sign = 1

    proc `-`*(x: BigInt): BigInt =
        ## 符号を反転する。
        result = x
        result.sign = -result.sign

    proc `+`*(x: BigInt): BigInt =
        ## 元の値を返す。
        x

    proc cmpAbs(x, y: BigInt): int =
        ## 絶対値を比較して -1, 0, 1 のいずれかを返す。
        if x.digits.len != y.digits.len:
            return system.cmp(x.digits.len, y.digits.len)
        for i in countdown(x.digits.len - 1, 0):
            if x.digits[i] != y.digits[i]:
                return system.cmp(x.digits[i], y.digits[i])

    proc cmp*(x, y: BigInt): int =
        ## 大小関係を -1, 0, 1 のいずれかで返す。
        if x.sign != y.sign:
            return system.cmp(x.sign, y.sign)
        x.sign * cmpAbs(x, y)

    proc `==`*(x, y: BigInt): bool =
        ## 等しいかどうかを返す。
        x.sign == y.sign and x.digits == y.digits

    proc `<`*(x, y: BigInt): bool =
        ## 左辺が右辺より小さいかを返す。
        cmp(x, y) < 0

    proc `<=`*(x, y: BigInt): bool =
        ## 左辺が右辺以下かを返す。
        cmp(x, y) <= 0

    proc `>`*(x, y: BigInt): bool =
        ## 左辺が右辺より大きいかを返す。
        cmp(x, y) > 0

    proc `>=`*(x, y: BigInt): bool =
        ## 左辺が右辺以上かを返す。
        cmp(x, y) >= 0

    proc addAbs(x, y: BigInt): BigInt =
        ## 絶対値の和を返す。
        result.sign = 1
        let n = max(x.digits.len, y.digits.len)
        result.digits = newSeq[uint32](n + 1)
        var carry = 0'u64
        for i in 0..<n:
            if i < x.digits.len:
                carry += uint64(x.digits[i])
            if i < y.digits.len:
                carry += uint64(y.digits[i])
            result.digits[i] = uint32(carry mod BigIntBase)
            carry = carry div BigIntBase
        result.digits[n] = uint32(carry)
        result.normalize()

    proc subAbs(x, y: BigInt): BigInt =
        ## |x| >= |y| を前提として絶対値の差を返す。
        result.sign = 1
        result.digits = newSeq[uint32](x.digits.len)
        var borrow = 0'i64
        for i in 0..<x.digits.len:
            var digit = int64(x.digits[i]) - borrow
            if i < y.digits.len:
                digit -= int64(y.digits[i])
            borrow = 0
            if digit < 0:
                digit += int64(BigIntBase)
                borrow = 1
            result.digits[i] = uint32(digit)
        result.normalize()

    proc `+`*(x, y: BigInt): BigInt =
        ## 和を返す。
        if x.sign == 0:
            return y
        if y.sign == 0:
            return x
        if x.sign == y.sign:
            result = addAbs(x, y)
            result.sign = x.sign
        elif cmpAbs(x, y) >= 0:
            result = subAbs(x, y)
            result.sign *= x.sign
        else:
            result = subAbs(y, x)
            result.sign *= y.sign

    proc `-`*(x, y: BigInt): BigInt =
        ## 差を返す。
        x + (-y)

    proc mulSchoolbook(x, y: BigInt): BigInt =
        ## 0 でない整数同士の積を筆算で返す。
        result.sign = x.sign * y.sign
        result.digits = newSeq[uint32](x.digits.len + y.digits.len)
        for i in 0..<x.digits.len:
            var carry = 0'u64
            for j in 0..<y.digits.len:
                let digit = uint64(result.digits[i + j]) +
                    uint64(x.digits[i]) * uint64(y.digits[j]) + carry
                result.digits[i + j] = uint32(digit mod BigIntBase)
                carry = digit div BigIntBase
            result.digits[i + y.digits.len] = uint32(carry)
        result.normalize()

    when defined(cpp) and defined(amd64):
        const
            BigIntNttThreshold = 64
            BigIntNttMaxLength = 1 shl 24
            BigIntNttMod1 = 754974721'u64
            BigIntNttMod2 = 469762049'u64
            BigIntNttInvMod1 = 221064492'u64
            BigIntNttLargeBaseMaxDigits = int(
                (BigIntNttMod1 * BigIntNttMod2 - 1) div (999999'u64 * 999999'u64))

        proc bigIntConvolutionAvx2(
                output, left: ptr uint32, leftLen: csize_t,
                right: ptr uint32, rightLen, nttLen: csize_t,
                modulus, primitiveRoot: uint32, montgomeryRepresentation: bool
                ) {.importc: "cplib_convolution_ntt_friendly".}
            ## 既存の AVX2 畳み込みを通常表現の 32 bit 配列から呼び出す。

        proc convolutionNttDigits(left, right: seq[uint32],
                modulus, primitiveRoot: uint32): seq[uint32] =
            ## 指定した NTT 素数を法とする畳み込みを返す。
            let length = left.len + right.len - 1
            var nttLength = 1
            while nttLength < length:
                nttLength *= 2
            result = newSeq[uint32](nttLength)
            bigIntConvolutionAvx2(addr result[0], unsafeAddr left[0], left.len.csize_t,
                unsafeAddr right[0], right.len.csize_t, nttLength.csize_t,
                modulus, primitiveRoot, false)
            result.setLen(length)

        proc splitNttDigits[decimalDigits: static[int]](x: BigInt): seq[uint32] =
            ## 10^9 進の桁を NTT 用の 10^6 進または 10^5 進に変換する。
            const base = if decimalDigits == 6: 1_000_000'u64 else: 100_000'u64
            result = newSeq[uint32]((x.digits.len * 9 + decimalDigits - 1) div decimalDigits)
            var value = 0'u64
            var scale = 1'u64
            var position = 0
            for digit in x.digits:
                value += uint64(digit) * scale
                scale *= BigIntBase
                while scale >= base:
                    result[position] = uint32(value mod base)
                    value = value div base
                    scale = scale div base
                    inc position
            if scale > 1:
                result[position] = uint32(value)

        proc mulNtt[decimalDigits: static[int]](x, y: BigInt): BigInt =
            ## 係数上限に合わせた 2 素数の NTT と CRT で厳密な積を返す。
            const base = if decimalDigits == 6: 1_000_000'u64 else: 100_000'u64
            let left = splitNttDigits[decimalDigits](x)
            let right = splitNttDigits[decimalDigits](y)
            let c1 = convolutionNttDigits(left, right, BigIntNttMod1.uint32, 11'u32)
            let c2 = convolutionNttDigits(left, right, BigIntNttMod2.uint32, 3'u32)
            result.sign = x.sign * y.sign
            result.digits = newSeq[uint32](x.digits.len + y.digits.len)
            # 各係数は (base - 1)^2 * min(left.len, right.len) 以下で、2 素数の積未満。
            var carry = 0'u64
            var value = 0'u64
            var scale = 1'u64
            var position = 0
            for i in 0..<c1.len:
                let r1 = uint64(c1[i])
                let t2 = ((uint64(c2[i]) + 2 * BigIntNttMod2 - r1) *
                    BigIntNttInvMod1) mod BigIntNttMod2
                carry += r1 + BigIntNttMod1 * t2
                value += (carry mod base) * scale
                carry = carry div base
                scale *= base
                if scale >= BigIntBase:
                    result.digits[position] = uint32(value mod BigIntBase)
                    value = value div BigIntBase
                    scale = scale div BigIntBase
                    inc position
            while carry != 0:
                value += (carry mod base) * scale
                carry = carry div base
                scale *= base
                if scale >= BigIntBase:
                    result.digits[position] = uint32(value mod BigIntBase)
                    value = value div BigIntBase
                    scale = scale div BigIntBase
                    inc position
            if value != 0:
                result.digits[position] = uint32(value)
            result.normalize()

    proc `*`*(x, y: BigInt): BigInt =
        ## 大きな数は NTT、小さな数や NTT の対応範囲外では筆算で積を返す。
        if x.sign == 0 or y.sign == 0:
            return
        when nimvm:
            result = mulSchoolbook(x, y)
        else:
            when defined(cpp) and defined(amd64):
                let smaller = min(x.digits.len, y.digits.len)
                let total = x.digits.len + y.digits.len
                if smaller > BigIntNttThreshold:
                    if smaller <= (BigIntNttLargeBaseMaxDigits * 2) div 3 and
                            total <= (BigIntNttMaxLength * 2) div 3:
                        return mulNtt[6](x, y)
                    if total <= (BigIntNttMaxLength * 5) div 9:
                        return mulNtt[5](x, y)
            result = mulSchoolbook(x, y)

    proc mulAbsSmall(x: BigInt, y: uint32): BigInt =
        ## 絶対値と 1 桁の非負整数との積を返す。
        result.sign = 1
        result.digits = newSeq[uint32](x.digits.len + 1)
        var carry = 0'u64
        for i in 0..<x.digits.len:
            let digit = uint64(x.digits[i]) * uint64(y) + carry
            result.digits[i] = uint32(digit mod BigIntBase)
            carry = digit div BigIntBase
        result.digits[x.digits.len] = uint32(carry)
        result.normalize()

    proc divAbsSmall(x: BigInt, y: uint32): tuple[quotient: BigInt, remainder: uint32] =
        ## 絶対値を 1 桁の正整数で割った商と余りを返す。
        result.quotient.sign = 1
        result.quotient.digits = newSeq[uint32](x.digits.len)
        var remainder = 0'u64
        for i in countdown(x.digits.len - 1, 0):
            let digit = remainder * BigIntBase + uint64(x.digits[i])
            result.quotient.digits[i] = uint32(digit div uint64(y))
            remainder = digit mod uint64(y)
        result.quotient.normalize()
        result.remainder = uint32(remainder)

    proc divmodSchoolbook(x, y: BigInt): tuple[quotient, remainder: BigInt] =
        ## 筆算で 0 方向に丸めた商と余りを返し、0 除算には DivByZeroDefect を送出する。
        if y.sign == 0:
            raise newException(DivByZeroDefect, "多倍長整数を 0 で割ることはできません")
        if cmpAbs(x, y) < 0:
            result.remainder = x
            return
        if x.digits.len <= 2:
            var numerator = uint64(x.digits[0])
            var denominator = uint64(y.digits[0])
            if x.digits.len == 2:
                numerator += uint64(x.digits[1]) * BigIntBase
            if y.digits.len == 2:
                denominator += uint64(y.digits[1]) * BigIntBase
            result.quotient = initBigInt(numerator div denominator)
            result.remainder = initBigInt(numerator mod denominator)
            result.quotient.sign *= x.sign * y.sign
            result.remainder.sign *= x.sign
            return
        if y.digits.len == 1:
            if y.digits[0] == 1:
                result.quotient = x
                result.quotient.sign *= y.sign
                return
            let division = divAbsSmall(x, y.digits[0])
            result.quotient = division.quotient
            result.quotient.sign *= x.sign * y.sign
            result.remainder = initBigInt(division.remainder)
            result.remainder.sign *= x.sign
            return

        let factor = uint32(BigIntBase div (uint64(y.digits[^1]) + 1))
        var dividend = mulAbsSmall(x, factor)
        let divisor = mulAbsSmall(y, factor)
        let n = divisor.digits.len
        let quotientLen = x.digits.len - n + 1
        dividend.digits.setLen(x.digits.len + 1)
        result.quotient.sign = x.sign * y.sign
        result.quotient.digits = newSeq[uint32](quotientLen)
        for j in countdown(quotientLen - 1, 0):
            let top = uint64(dividend.digits[j + n]) * BigIntBase +
                uint64(dividend.digits[j + n - 1])
            var estimate = min(BigIntBase - 1, top div uint64(divisor.digits[n - 1]))
            var remainder = top - estimate * uint64(divisor.digits[n - 1])
            while remainder < BigIntBase and
                    estimate * uint64(divisor.digits[n - 2]) >
                    remainder * BigIntBase + uint64(dividend.digits[j + n - 2]):
                dec estimate
                remainder += uint64(divisor.digits[n - 1])

            var borrow = 0'i64
            for i in 0..<n:
                let product = estimate * uint64(divisor.digits[i]) + uint64(borrow)
                var digit = int64(dividend.digits[j + i]) - int64(product mod BigIntBase)
                borrow = int64(product div BigIntBase)
                if digit < 0:
                    digit += int64(BigIntBase)
                    inc borrow
                dividend.digits[j + i] = uint32(digit)
            var last = int64(dividend.digits[j + n]) - borrow
            if last < 0:
                dec estimate
                var carry = 0'u64
                for i in 0..<n:
                    let digit = uint64(dividend.digits[j + i]) +
                        uint64(divisor.digits[i]) + carry
                    dividend.digits[j + i] = uint32(digit mod BigIntBase)
                    carry = digit div BigIntBase
                last += int64(carry)
            dividend.digits[j + n] = uint32(last)
            result.quotient.digits[j] = uint32(estimate)

        result.quotient.normalize()
        dividend.digits.setLen(n)
        dividend.normalize()
        result.remainder = divAbsSmall(dividend, factor).quotient
        result.remainder.sign *= x.sign

    when defined(cpp) and defined(amd64):
        const BigIntNewtonThreshold = 256

        proc shiftDigitsLeft(x: BigInt, count: int): BigInt =
            ## 基数の count 乗を掛ける。
            if x.isZero:
                return
            result.sign = x.sign
            result.digits = newSeq[uint32](x.digits.len + count)
            for i in 0..<x.digits.len:
                result.digits[i + count] = x.digits[i]

        proc shiftDigitsRight(x: BigInt, count: int): BigInt =
            ## 下位 count 桁を切り捨て、符号を維持する。
            if x.digits.len <= count:
                return
            result.sign = x.sign
            result.digits = newSeq[uint32](x.digits.len - count)
            for i in 0..<result.digits.len:
                result.digits[i] = x.digits[i + count]

        proc basePower(exponent: int): BigInt =
            ## 基数の exponent 乗を返す。
            result.sign = 1
            result.digits = newSeq[uint32](exponent + 1)
            result.digits[exponent] = 1

        proc reciprocalAbs(x: BigInt): BigInt =
            ## 正の m 桁の x に対し、B^(2m)/x 以下で誤差 2 未満の整数近似を求める。
            let m = x.digits.len
            if m <= 32:
                return divmodSchoolbook(basePower(2 * m), x).quotient
            let half = (m + 1) div 2 + 2
            let low = m - half
            let inverse = reciprocalAbs(shiftDigitsRight(x, low))
            let product = x * (inverse * inverse)
            var correction = shiftDigitsRight(product, 2 * half)
            for i in 0..<min(2 * half, product.digits.len):
                if product.digits[i] != 0:
                    correction = correction + initBigInt(1)
                    break
            # 上位半分にガード 2 桁を加えることで、Newton 更新の誤差を 1 未満にする。
            # 切り捨て後の誤差は 2 未満で保ち、厳密化は最後の商の補正にまとめる。
            result = shiftDigitsLeft(mulAbsSmall(inverse, 2), low) - correction

        proc quotientFromReciprocal(x, inverse: BigInt, divisorLen, precision: int): BigInt =
            ## 不要な被除数の下位桁を落として商を推定し、不足を高々 3 に抑える。
            let cut = max(0, divisorLen - 1)
            shiftDigitsRight(shiftDigitsRight(x, cut) * inverse, divisorLen + precision - cut)

        proc correctDivision(x, y, quotient: BigInt): tuple[quotient, remainder: BigInt] =
            ## 正の整数の推定商を下方 1 回・上方 3 回まで補正して商と余りを確定する。
            result.quotient = quotient
            result.remainder = x - quotient * y
            if result.remainder.sign < 0:
                result.quotient = result.quotient - initBigInt(1)
                result.remainder = result.remainder + y
            for _ in 0..<3:
                if cmpAbs(result.remainder, y) < 0:
                    break
                result.quotient = result.quotient + initBigInt(1)
                result.remainder = result.remainder - y

        proc divmodBlocks(x, y: BigInt): tuple[quotient, remainder: BigInt] =
            ## 正の整数の被除数を除数と同じ桁数のブロックに分け、逆数を共有して割る。
            let n = x.digits.len
            let m = y.digits.len
            let inverse = reciprocalAbs(y)
            result.quotient.sign = 1
            result.quotient.digits = newSeq[uint32](n - m + 1)
            for blockIndex in countdown((n - 1) div m, 0):
                let offset = blockIndex * m
                let width = min(m, n - offset)
                var dividend: BigInt
                dividend.sign = 1
                dividend.digits = newSeq[uint32](width + result.remainder.digits.len)
                for i in 0..<width:
                    dividend.digits[i] = x.digits[offset + i]
                for i in 0..<result.remainder.digits.len:
                    dividend.digits[width + i] = result.remainder.digits[i]
                dividend.normalize()
                if cmpAbs(dividend, y) < 0:
                    result.remainder = dividend
                    continue
                let quotient = quotientFromReciprocal(dividend, inverse, m, m)
                let division = correctDivision(dividend, y, quotient)
                for i in 0..<division.quotient.digits.len:
                    result.quotient.digits[offset + i] = division.quotient.digits[i]
                result.remainder = division.remainder
            result.quotient.normalize()

        proc divmodNewton(x, y: BigInt): tuple[quotient, remainder: BigInt] =
            ## 正負の整数の商を必要な精度の逆数から求め、商と余りを厳密に補正する。
            let dividend = abs(x)
            let divisor = abs(y)
            let n = dividend.digits.len
            let m = divisor.digits.len
            if n > 2 * m:
                result = divmodBlocks(dividend, divisor)
            else:
                let cut = max(0, m - (n - m + 2))
                let divisorHigh = shiftDigitsRight(divisor, cut)
                let precision = max(m - cut, n - m)
                let inverse = reciprocalAbs(shiftDigitsLeft(divisorHigh, precision - (m - cut)))
                let quotient = quotientFromReciprocal(shiftDigitsRight(dividend, cut),
                    inverse, m - cut, precision)
                result = correctDivision(dividend, divisor, quotient)
            result.quotient.sign *= x.sign * y.sign
            result.remainder.sign *= x.sign

    proc divmod*(x, y: BigInt): tuple[quotient, remainder: BigInt] =
        ## 0 方向に丸めた商と被除数と同符号の余りを返し、0 除算には DivByZeroDefect を送出する。
        when nimvm:
            result = divmodSchoolbook(x, y)
        else:
            when defined(cpp) and defined(amd64):
                let n = x.digits.len
                let m = y.digits.len
                if min(m, n - m) > BigIntNewtonThreshold:
                    # ブロック除算では、被除数の全長によらず除数の桁数で変換長を抑えられる。
                    let productSize = if n > 2 * m: 2 * m + 8
                        else: max(n + 1, 2 * min(m, n - m + 2) + 8)
                    if productSize <= (BigIntNttMaxLength * 5) div 9:
                        return divmodNewton(x, y)
            result = divmodSchoolbook(x, y)

    proc `div`*(x, y: BigInt): BigInt =
        ## 0 方向に丸めた商を返す。
        divmod(x, y).quotient

    proc `mod`*(x, y: BigInt): BigInt =
        ## 被除数と同符号の余りを返す。
        divmod(x, y).remainder

    proc `+=`*(x: var BigInt, y: BigInt) =
        ## 右辺を加える。
        x = x + y

    proc `-=`*(x: var BigInt, y: BigInt) =
        ## 右辺を引く。
        x = x - y

    proc `*=`*(x: var BigInt, y: BigInt) =
        ## 右辺を掛ける。
        x = x * y

    proc `div=`*(x: var BigInt, y: BigInt) =
        ## 右辺で割った商を代入する。
        x = x div y

    proc `mod=`*(x: var BigInt, y: BigInt) =
        ## 右辺で割った余りを代入する。
        x = x mod y

    proc pow*(x: BigInt, exponent: int): BigInt =
        ## 非負整数乗を繰り返し二乗法で求め、負の指数には ValueError を送出する。0^0 は 1。
        if exponent < 0:
            raise newException(ValueError, "多倍長整数の指数は非負整数で指定してください")
        result = initBigInt(1)
        var base = x
        var n = exponent
        while n > 0:
            if (n and 1) != 0:
                result *= base
            n = n shr 1
            if n > 0:
                base *= base

    proc gcd*(x, y: BigInt): BigInt =
        ## 非負の最大公約数を返す。gcd(0, 0) は 0。
        result = abs(x)
        var y = abs(y)
        while not y.isZero:
            let remainder = result mod y
            result = y
            y = remainder

    proc lcm*(x, y: BigInt): BigInt =
        ## 非負の最小公倍数を返す。いずれかが 0 なら 0。
        if x.isZero or y.isZero:
            return
        abs((x div gcd(x, y)) * y)

    proc toInt*(x: BigInt): int =
        ## int に変換し、範囲外なら OverflowDefect を送出する。
        let limit = uint64(high(int)) + uint64(ord(x.sign < 0))
        var magnitude = 0'u64
        for i in countdown(x.digits.len - 1, 0):
            let digit = uint64(x.digits[i])
            if magnitude > limit div BigIntBase or
                    (magnitude == limit div BigIntBase and digit > limit mod BigIntBase):
                raise newException(OverflowDefect, "多倍長整数が int の範囲外です")
            magnitude = magnitude * BigIntBase + digit
        if x.sign < 0:
            if magnitude == uint64(high(int)) + 1'u64:
                return low(int)
            return -int(magnitude)
        int(magnitude)

    proc hash*(x: BigInt): Hash =
        ## 多倍長整数のハッシュ値を返す。
        result = hashes.hash(x.sign)
        for digit in x.digits:
            result = result !& hashes.hash(digit)
        result = !$result
