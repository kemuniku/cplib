when not declared CPLIB_MATH_LONGDOUBLE:
    const CPLIB_MATH_LONGDOUBLE* = 1
    when not (defined(c) or defined(cpp)):
        {.error: "longdouble requires the Nim C or C++ backend".}
    when defined(posix):
        {.passL: "-lm".}

    type LongDouble* {.importc: "long double", nodecl, bycopy.} = object

    converter to_longdouble*(x: SomeInteger): LongDouble =
        ## 整数を直接long doubleへ変換する。計算量O(1)。
        {.emit: "`result` = (long double)(`x`);".}

    converter to_longdouble*(x: SomeFloat): LongDouble =
        ## 浮動小数点数をlong doubleへ変換する。元の丸めは復元しない。計算量O(1)。
        {.emit: "`result` = (long double)(`x`);".}

    proc `-`*(x: LongDouble): LongDouble =
        ## long doubleで符号を反転する。計算量O(1)。
        {.emit: "`result` = -(`x`);".}

    proc `+`*(x, y: LongDouble): LongDouble =
        ## long doubleで加算する。計算量O(1)。
        {.emit: "`result` = (`x`) + (`y`);".}

    proc `-`*(x, y: LongDouble): LongDouble =
        ## long doubleで減算する。計算量O(1)。
        {.emit: "`result` = (`x`) - (`y`);".}

    proc `*`*(x, y: LongDouble): LongDouble =
        ## long doubleで乗算する。計算量O(1)。
        {.emit: "`result` = (`x`) * (`y`);".}

    proc `/`*(x, y: LongDouble): LongDouble =
        ## long doubleで除算する。計算量O(1)。
        {.emit: "`result` = (`x`) / (`y`);".}

    proc `+=`*(x: var LongDouble, y: LongDouble) =
        ## long doubleで複合代入する。計算量O(1)。
        let p = addr x
        {.emit: "(*`p`) += (`y`);".}

    proc `-=`*(x: var LongDouble, y: LongDouble) =
        ## long doubleで複合代入する。計算量O(1)。
        let p = addr x
        {.emit: "(*`p`) -= (`y`);".}

    proc `*=`*(x: var LongDouble, y: LongDouble) =
        ## long doubleで複合代入する。計算量O(1)。
        let p = addr x
        {.emit: "(*`p`) *= (`y`);".}

    proc `/=`*(x: var LongDouble, y: LongDouble) =
        ## long doubleで複合代入する。計算量O(1)。
        let p = addr x
        {.emit: "(*`p`) /= (`y`);".}

    proc `<`*(x, y: LongDouble): bool =
        ## Cの浮動小数点比較を行う。NaNは常に偽。計算量O(1)。
        {.emit: "`result` = ((`x`) < (`y`));".}

    proc `<=`*(x, y: LongDouble): bool =
        ## Cの浮動小数点比較を行う。NaNは常に偽。計算量O(1)。
        {.emit: "`result` = ((`x`) <= (`y`));".}

    proc `>`*(x, y: LongDouble): bool =
        ## Cの浮動小数点比較を行う。NaNは常に偽。計算量O(1)。
        {.emit: "`result` = ((`x`) > (`y`));".}

    proc `>=`*(x, y: LongDouble): bool =
        ## Cの浮動小数点比較を行う。NaNは常に偽。計算量O(1)。
        {.emit: "`result` = ((`x`) >= (`y`));".}

    proc `==`*(x, y: LongDouble): bool =
        ## Cの浮動小数点比較を行う。NaNは常に偽。計算量O(1)。
        {.emit: "`result` = ((`x`) == (`y`));".}

    proc abs*(x: LongDouble): LongDouble {.importc: "fabsl", header: "<math.h>", cdecl.}
        ## long doubleで絶対値を求める。

    proc sqrt*(x: LongDouble): LongDouble {.importc: "sqrtl", header: "<math.h>", cdecl.}
        ## long doubleで平方根を求める。

    proc cbrt*(x: LongDouble): LongDouble {.importc: "cbrtl", header: "<math.h>", cdecl.}
        ## long doubleで立方根を求める。

    proc exp*(x: LongDouble): LongDouble {.importc: "expl", header: "<math.h>", cdecl.}
        ## long doubleで自然指数を求める。

    proc exp2*(x: LongDouble): LongDouble {.importc: "exp2l", header: "<math.h>", cdecl.}
        ## long doubleで2を底とする指数を求める。

    proc ln*(x: LongDouble): LongDouble {.importc: "logl", header: "<math.h>", cdecl.}
        ## long doubleで自然対数を求める。

    proc log2*(x: LongDouble): LongDouble {.importc: "log2l", header: "<math.h>", cdecl.}
        ## long doubleで2を底とする対数を求める。

    proc log10*(x: LongDouble): LongDouble {.importc: "log10l", header: "<math.h>", cdecl.}
        ## long doubleで10を底とする対数を求める。

    proc sin*(x: LongDouble): LongDouble {.importc: "sinl", header: "<math.h>", cdecl.}
        ## long doubleで正弦を求める。

    proc cos*(x: LongDouble): LongDouble {.importc: "cosl", header: "<math.h>", cdecl.}
        ## long doubleで余弦を求める。

    proc tan*(x: LongDouble): LongDouble {.importc: "tanl", header: "<math.h>", cdecl.}
        ## long doubleで正接を求める。

    proc arcsin*(x: LongDouble): LongDouble {.importc: "asinl", header: "<math.h>", cdecl.}
        ## long doubleで逆正弦を求める。

    proc arccos*(x: LongDouble): LongDouble {.importc: "acosl", header: "<math.h>", cdecl.}
        ## long doubleで逆余弦を求める。

    proc arctan*(x: LongDouble): LongDouble {.importc: "atanl", header: "<math.h>", cdecl.}
        ## long doubleで逆正接を求める。

    proc floor*(x: LongDouble): LongDouble {.importc: "floorl", header: "<math.h>", cdecl.}
        ## long doubleで負の無限大へ丸めた値を求める。

    proc ceil*(x: LongDouble): LongDouble {.importc: "ceill", header: "<math.h>", cdecl.}
        ## long doubleで正の無限大へ丸めた値を求める。

    proc trunc*(x: LongDouble): LongDouble {.importc: "truncl", header: "<math.h>", cdecl.}
        ## long doubleで0へ丸めた値を求める。

    proc round*(x: LongDouble): LongDouble {.importc: "roundl", header: "<math.h>", cdecl.}
        ## long doubleで最も近い整数（中間は0から遠い側）を求める。

    proc expm1*(x: LongDouble): LongDouble {.importc: "expm1l", header: "<math.h>", cdecl.}
        ## long doubleでexp(x)-1を求める。

    proc ln1p*(x: LongDouble): LongDouble {.importc: "log1pl", header: "<math.h>", cdecl.}
        ## long doubleでln(1+x)を求める。

    proc pow*(x, y: LongDouble): LongDouble {.importc: "powl", header: "<math.h>", cdecl.}
        ## long doubleで累乗を求める。

    proc arctan2*(x, y: LongDouble): LongDouble {.importc: "atan2l", header: "<math.h>", cdecl.}
        ## long doubleで二引数逆正接を求める。

    proc hypot*(x, y: LongDouble): LongDouble {.importc: "hypotl", header: "<math.h>", cdecl.}
        ## long doubleで平方和の平方根を求める。

    proc fmod*(x, y: LongDouble): LongDouble {.importc: "fmodl", header: "<math.h>", cdecl.}
        ## long doubleで0へ丸める商による剰余を求める。

    proc copySign*(x, y: LongDouble): LongDouble {.importc: "copysignl", header: "<math.h>", cdecl.}
        ## long doubleでyの符号を持つxの絶対値を求める。

    proc nextAfter*(x, y: LongDouble): LongDouble {.importc: "nextafterl", header: "<math.h>", cdecl.}
        ## long doubleでy方向の次の表現可能な値を求める。

    proc fma*(x, y, z: LongDouble): LongDouble {.importc: "fmal", header: "<math.h>", cdecl.}
        ## 積和を一度だけ丸めて求める。

    proc ldIsNaN(x: LongDouble): cint {.importc: "isnan", header: "<math.h>".}
    proc ldIsInf(x: LongDouble): cint {.importc: "isinf", header: "<math.h>".}
    proc ldSignbit(x: LongDouble): cint {.importc: "signbit", header: "<math.h>".}

    proc isNaN*(x: LongDouble): bool =
        ## NaNか判定する。計算量O(1)。
        ldIsNaN(x) != 0

    proc isInf*(x: LongDouble): bool =
        ## 無限大か判定する。計算量O(1)。
        ldIsInf(x) != 0

    proc signbit*(x: LongDouble): bool =
        ## 負の符号ビットを判定する。-0にも真を返す。計算量O(1)。
        ldSignbit(x) != 0

    proc cmp*(x, y: LongDouble): int =
        ## 比較して-1/0/1を返す。NaNを含むとValueError。計算量O(1)。
        if isNaN(x) or isNaN(y):
            raise newException(ValueError, "cannot order NaN")
        if x < y: -1 elif x > y: 1 else: 0

    var ldMantDig {.importc: "LDBL_MANT_DIG", header: "<float.h>".}: cint
    var ldDig {.importc: "LDBL_DIG", header: "<float.h>".}: cint
    var ldDecimalDig {.importc: "DECIMAL_DIG", header: "<float.h>".}: cint
    var ldMinExp {.importc: "LDBL_MIN_EXP", header: "<float.h>".}: cint
    var ldMaxExp {.importc: "LDBL_MAX_EXP", header: "<float.h>".}: cint
    var ldRadix {.importc: "FLT_RADIX", header: "<float.h>".}: cint
    var ldEpsilon {.importc: "LDBL_EPSILON", header: "<float.h>".}: LongDouble
    var ldMin {.importc: "LDBL_MIN", header: "<float.h>".}: LongDouble
    var ldMax {.importc: "LDBL_MAX", header: "<float.h>".}: LongDouble
    var ldDoubleMax {.importc: "DBL_MAX", header: "<float.h>".}: LongDouble

    type LongDoubleInfo* = object
        size*, mantissaDigits*, digits*, decimalDigits*, radix*: int
        minExponent*, maxExponent*: int

    proc longDoubleInfo*(): LongDoubleInfo =
        ## 利用環境のsizeof・精度・指数範囲を返す。計算量O(1)。
        result = LongDoubleInfo(size: sizeof(LongDouble),
            mantissaDigits: int(ldMantDig), digits: int(ldDig),
            decimalDigits: int(ldDecimalDig), radix: int(ldRadix),
            minExponent: int(ldMinExp), maxExponent: int(ldMaxExp))

    proc epsilonLongDouble*(): LongDouble =
        ## 1とその次の値の差LDBL_EPSILONを返す。計算量O(1)。
        ldEpsilon

    proc minPositiveLongDouble*(): LongDouble =
        ## 正の最小正規化値LDBL_MINを返す。計算量O(1)。
        ldMin

    proc maxLongDouble*(): LongDouble =
        ## 最大有限値LDBL_MAXを返す。計算量O(1)。
        ldMax

    proc to_float*(x: LongDouble): float =
        ## doubleへ明示的に丸める。範囲外は符号付きInf。計算量O(1)。
        if x > ldDoubleMax: return system.Inf
        if x < -ldDoubleMax: return -system.Inf
        {.emit: "`result` = (double)(`x`);".}

    proc to_integer*[T: SomeInteger](x: LongDouble, target: typedesc[T]): T =
        ## 0方向に丸めて整数にする。NaN/Inf/範囲外はRangeDefect。計算量O(1)。
        let t = trunc(x)
        when T is SomeUnsignedInt:
            let upper = to_longdouble(high(T) div 2 + 1) * 2
            let outside = t < 0 or t >= upper
        else:
            let lower = to_longdouble(low(T))
            let outside = t < lower or t >= -lower
        if isNaN(t) or isInf(t) or outside:
            raise newException(RangeDefect, "long double is outside integer range")
        {.emit: "`result` = `t`;".}

    proc to_int*(x: LongDouble): int =
        ## 0方向に丸めてintへ変換する。範囲外はRangeDefect。計算量O(1)。
        to_integer(x, int)

    proc ldStrtold(s: cstring, ending: ptr cstring): LongDouble {.importc: "strtold", header: "<stdlib.h>", cdecl.}

    proc parseLongDouble*(s: string): LongDouble =
        ## 文字列から直接変換する。不正な文字列はValueError。計算量O(文字数)。
        for c in s:
            if c == '\0':
                raise newException(ValueError, "embedded NUL in long double")
        var ending: cstring
        result = ldStrtold(s.cstring, addr ending)
        if ending == s.cstring:
            raise newException(ValueError, "invalid long double")
        var i = 0
        while ending[i] in {' ', '\t', '\r', '\n', '\v', '\f'}: inc i
        if ending[i] != '\0':
            raise newException(ValueError, "trailing characters in long double")

    proc ldSnprintf(buffer: cstring, size: csize_t, format: cstring,
                    precision: cint, x: LongDouble): cint {.importc: "snprintf", header: "<stdio.h>", varargs.}

    proc formatLongDouble*(x: LongDouble, precision: int = 0): string =
        ## %Lgで有効桁数を指定して整形する。0は往復に十分なDECIMAL_DIG。計算量O(出力長)。
        if precision < 0 or precision > int(high(cint)):
            raise newException(ValueError, "invalid long double precision")
        let digits = if precision == 0: ldDecimalDig else: cint(precision)
        let length = ldSnprintf(nil, 0, "%.*Lg", digits, x)
        if length < 0 or length == high(cint):
            raise newException(ValueError, "long double formatting failed")
        result = newString(int(length) + 1)
        let written = ldSnprintf(cast[cstring](addr result[0]),
            csize_t(result.len), "%.*Lg", digits, x)
        if written != length:
            raise newException(ValueError, "long double formatting changed length")
        result.setLen(int(length))

    proc `$`*(x: LongDouble): string =
        ## 往復に十分な桁数の文字列を返す。計算量O(出力長)。
        formatLongDouble(x)

    proc read_and_parse_longdouble*(): LongDouble =
        ## 標準入力の空白区切り文字列を直接変換する。EOFはEOFError。計算量O(文字数)。
        var token = ""
        var c: char
        while stdin.readBuffer(addr c, 1) == 1:
            if c notin {' ', '\t', '\r', '\n', '\v', '\f'}:
                token.add(c)
                break
        if token.len == 0:
            raise newException(EOFError, "no long double token")
        while stdin.readBuffer(addr c, 1) == 1:
            if c in {' ', '\t', '\r', '\n', '\v', '\f'}: break
            token.add(c)
        parseLongDouble(token)

    proc put*(x: LongDouble) =
        ## 標準出力へ改行付きで整形出力する。計算量O(出力長)。
        echo $x
