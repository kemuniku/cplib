when not declared CPLIB_UTILS_CUMSUM_ND:
    const CPLIB_UTILS_CUMSUM_ND* = 1

    type CumSumND*[T; D: static[int]] = object
        dimensions: array[D, int]
        strides: array[D, int]
        sums: seq[T]
        zero: T

    proc initCumSumND*[T; D: static[int]](shape: array[D, int]; values: openArray[T]; zero: T = default(T)): CumSumND[T, D] =
        ## 末尾軸が最速の配列から静的累積和を構築します。P=Π(shape[i]+1)として時間O(DP)、領域O(P)。
        mixin `+`
        static: assert D > 0 and D < sizeof(int) * 8 - 1
        var paddedSize = 1
        for axis in countdown(D - 1, 0):
            if shape[axis] < 0 or shape[axis] == high(int):
                raise newException(ValueError, "invalid CumSumND axis length")
            let width = shape[axis] + 1
            if paddedSize > high(int) div width:
                raise newException(ValueError, "CumSumND shape product overflows int")
            result.strides[axis] = paddedSize
            paddedSize *= width
        if paddedSize > high(int) div sizeof(T):
            raise newException(ValueError, "CumSumND storage size overflows int")
        var size = 1
        for width in shape: size *= width
        if values.len != size:
            raise newException(ValueError, "CumSumND value count does not match shape")
        result.dimensions = shape
        result.zero = zero
        result.sums = newSeq[T](paddedSize)
        for value in result.sums.mitems: value = zero
        var coordinates: array[D, int]
        for value in values:
            var index = 0
            for axis in 0..<D:
                index += (coordinates[axis] + 1) * result.strides[axis]
            result.sums[index] = value
            for axis in countdown(D - 1, 0):
                inc coordinates[axis]
                if coordinates[axis] < shape[axis]: break
                coordinates[axis] = 0
        for axis in 0..<D:
            let stride = result.strides[axis]
            let blockSize = stride * (shape[axis] + 1)
            var start = 0
            while start < paddedSize:
                for offset in stride..<blockSize:
                    let index = start + offset
                    result.sums[index] = result.sums[index] + result.sums[index - stride]
                start += blockSize

    proc shape*[T; D: static[int]](self: CumSumND[T, D]): array[D, int] =
        ## 各軸の長さを値で返します。O(D)。
        self.dimensions

    proc query*[T; D: static[int]](self: CumSumND[T, D]; lower, upper: array[D, int]): T =
        ## 各軸の半開区間[lower[i],upper[i])の総和を返します。O(D 2^D)。
        mixin `+`, `-`
        static: assert D > 0 and D < sizeof(int) * 8 - 1
        if self.sums.len == 0:
            raise newException(ValueError, "uninitialized CumSumND")
        var empty = false
        for axis in 0..<D:
            if lower[axis] < 0 or lower[axis] > upper[axis] or upper[axis] > self.dimensions[axis]:
                raise newException(ValueError, "invalid CumSumND query interval")
            if lower[axis] == upper[axis]: empty = true
        result = self.zero
        if empty: return
        for mask in 0..<(1 shl D):
            var index = 0
            var negative = false
            for axis in 0..<D:
                if (mask and (1 shl axis)) == 0:
                    index += upper[axis] * self.strides[axis]
                else:
                    index += lower[axis] * self.strides[axis]
                    negative = not negative
            if negative: result = result - self.sums[index]
            else: result = result + self.sums[index]
