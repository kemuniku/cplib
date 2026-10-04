when not declared CPLIB_COLLECTIONS_ADD_ALL_ARRAY:
    const CPLIB_COLLECTIONS_ADD_ALL_ARRAY* = 1

    type AddAllArray*[T] = ref object
        values: seq[T]
        offset, total: T

    proc initAddAllArray*[T](values: openArray[T], zero: T = default(T)): AddAllArray[T] =
        ## 固定長配列を入力のコピーから構築する。時間・領域 O(N)。zero は加法の単位元。
        ## T は値型で、加減算・T(N) への変換・乗算を持ち、N と全中間値が型の範囲内に収まること。
        ## 各演算と値のコピーが O(1) で、加減算が加法群の法則に従うことを前提とする。
        ## 浮動小数点の総和には丸め誤差がある。ハンドルの代入は同じ配列を共有する。
        mixin `+`
        result = AddAllArray[T](values: newSeq[T](values.len), offset: zero, total: zero)
        for i, value in values:
            result.values[i] = value
            result.total = result.total + value

    proc len*[T](self: AddAllArray[T]): int {.inline.} =
        ## 固定された要素数を返す。O(1)。
        self.values.len

    proc addAll*[T](self: AddAllArray[T], delta: T) {.inline.} =
        ## 全要素へ delta を加える。空配列は何もしない。時間・追加領域 O(1)。
        mixin `+`, `*`
        if self.values.len == 0: return
        self.offset = self.offset + delta
        self.total = self.total + delta * T(self.values.len)

    proc get*[T](self: AddAllArray[T], index: int): T {.inline.} =
        ## index の値を参照を渡さず返す。範囲外は IndexDefect。O(1)。
        mixin `+`
        if index < 0 or index >= self.values.len:
            raise newException(IndexDefect, "AddAllArray の添字が範囲外です")
        self.values[index] + self.offset

    proc set*[T](self: AddAllArray[T], index: int, value: T) {.inline.} =
        ## index の値を value に代入する。範囲外は IndexDefect。時間・追加領域 O(1)。
        mixin `+`, `-`
        let oldValue = self.get(index)
        self.total = self.total + (value - oldValue)
        self.values[index] = value - self.offset

    proc sum*[T](self: AddAllArray[T]): T {.inline.} =
        ## 全要素の総和を返す。空配列は構築時の zero。O(1)。
        self.total

    proc `[]`*[T](self: AddAllArray[T], index: int): T {.inline.} =
        ## index の値を参照を渡さず返す。範囲外は IndexDefect。O(1)。
        self.get(index)

    proc `[]=`*[T](self: AddAllArray[T], index: int, value: T) {.inline.} =
        ## index の値を value に代入する。範囲外は IndexDefect。O(1)。
        self.set(index, value)
