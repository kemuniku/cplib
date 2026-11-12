when not declared CPLIB_MATH_INT128:
    const CPLIB_MATH_INT128* = 1
    import hashes
    {.emit: """
    #include <stdio.h>
    #include <string.h>
    #include <ctype.h>
    static unsigned long long cplib_int128_parseuint_raw8b(unsigned long long x) {
        // 8桁分の十進数をまとめて整数へ変換する。計算量O(1)。
        // https://zenn.dev/mizar/articles/fc87d667153080
        unsigned long long result = (x & 0x0f0f0f0f0f0f0f0f);
        result *= ((10ULL << 8) + 1); result >>= 8; result &= 0x00ff00ff00ff00ff;
        result *= ((100ULL << 16) + 1); result >>= 16; result &= 0x0000ffff0000ffff;
        result *= ((10000ULL << 32) + 1); result >>= 32;
        return result;
    }
    static unsigned long long cplib_int128_parseint_raw8b_wrap(const char* p, size_t sz) {
        // 8桁以下の十進文字列を右詰めで整数へ変換する。計算量O(1)。
        char c[8] = {0};
        for (size_t i=0; i<sz; i++) c[8-sz+i] = *(p++);
        unsigned long long x;
        memcpy(&x, &c, 8);
        return cplib_int128_parseuint_raw8b(x);
    }
    static __int128_t cplib_int128_parse_int128(const char* p) {
        // 負の値として累積し、最小値も安全に解析する。計算量O(文字数)。
        int minus = *p == '-';
        if (minus) p++;
        const __int128_t base[9] = {1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000};
        __int128_t result = 0;
        while (1) {
            size_t sz = 0;
            for (size_t i=0; i<8; i++) {
                if (*(p + sz) == '\0') break;
                sz++;
            }
            result = result * base[sz] - cplib_int128_parseint_raw8b_wrap(p, sz);
            p += sz;
            if (*p == '\0') break;
        }
        return minus ? result : -result;
    }
    static const char cplib_int128_digit_pairs[] =
        "0001020304050607080910111213141516171819"
        "2021222324252627282930313233343536373839"
        "4041424344454647484950515253545556575859"
        "6061626364656667686970717273747576777879"
        "8081828384858687888990919293949596979899";
    static char cplib_int128_string_buffer[41];
    static char* cplib_int128_to_string(__int128_t x) {
        // 絶対値を符号なしで求め、NUL終端付きの十進文字列を返す。計算量O(桁数)。
        __uint128_t tmp = (__uint128_t)x;
        if (x < 0) tmp = -tmp;
        char* end = cplib_int128_string_buffer + sizeof(cplib_int128_string_buffer) - 1;
        *end = '\0';
        char* d = end;
        while (tmp >= 10000) {
            unsigned int part = (unsigned int)(tmp % 10000);
            d -= 4;
            memcpy(d, cplib_int128_digit_pairs + (part / 100) * 2, 2);
            memcpy(d + 2, cplib_int128_digit_pairs + (part % 100) * 2, 2);
            tmp /= 10000;
        }
        while (tmp > 0) {
            *(--d) = "0123456789"[tmp % 10];
            tmp /= 10;
        }
        if (d == end) *(--d) = '0';
        if (x < 0) *(--d) = '-';
        return d;
    }
    static __int128_t cplib_int128_read_and_parse_int128(int x) {
        // 空白を読み飛ばして整数を読む。値のないEOFでは0を返す。計算量O(文字数)。
        int c = getchar_unlocked();
        while (c != EOF && isspace((unsigned char)c)) {
            c = getchar_unlocked();
        }
        int minus = c == '-';
        if (c == '-' || c == '+') c = getchar_unlocked();
        __int128_t result = 0;
        while (c >= '0' && c <= '9') {
            result = result * 10 - (c - '0');
            c = getchar_unlocked();
        }
        return minus ? result : -result;
    }
    static void cplib_int128_output_int128(__int128_t x) {
        // 十進表記と改行を標準出力へ書き込む。計算量O(桁数)。
        fputs(cplib_int128_to_string(x), stdout);
        fputc('\n', stdout);
    }
    """.}
    type Int128* {.importc: "__int128_t", nodecl, bycopy.} = object
        ## GCC/Clangの符号付き128ビット整数。C・C++両バックエンドで利用できる。
    converter to_Int128*(x: SomeInteger): Int128 {.inline.} =
        ## 整数を128ビットへ変換する。計算量O(1)。
        {.emit: "`result` = (__int128_t)((`x`));".}
    proc to_int*(x: Int128): int {.inline.} =
        ## 下位ビットをintへ変換する。計算量O(1)。
        {.emit: "`result` = (long long)(`x`);".}
    proc `-`*(x: Int128): Int128 {.inline.} =
        ## 符号を反転する。計算量O(1)。
        {.emit: "`result` = -((`x`));".}
    proc `+=`*(x: var Int128, y: Int128) {.inline.} =
        ## 加算の結果で値を更新する。計算量O(1)。
        let p = addr x
        {.emit: "((*`p`) += (`y`));".}
    proc `-=`*(x: var Int128, y: Int128) {.inline.} =
        ## 減算の結果で値を更新する。計算量O(1)。
        let p = addr x
        {.emit: "((*`p`) -= (`y`));".}
    proc `*=`*(x: var Int128, y: Int128) {.inline.} =
        ## 乗算の結果で値を更新する。計算量O(1)。
        let p = addr x
        {.emit: "((*`p`) *= (`y`));".}
    proc `div=`*(x: var Int128, y: Int128) {.inline.} =
        ## 除算の結果で値を更新する。計算量O(1)。
        let p = addr x
        {.emit: "((*`p`) /= (`y`));".}
    proc `mod=`*(x: var Int128, y: Int128) {.inline.} =
        ## 剰余演算の結果で値を更新する。計算量O(1)。
        let p = addr x
        {.emit: "((*`p`) %= (`y`));".}
    proc `&=`*(x: var Int128, y: Int128) {.inline.} =
        ## ビット積の結果で値を更新する。計算量O(1)。
        let p = addr x
        {.emit: "((*`p`) &= (`y`));".}
    proc `|=`*(x: var Int128, y: Int128) {.inline.} =
        ## ビット和の結果で値を更新する。計算量O(1)。
        let p = addr x
        {.emit: "((*`p`) |= (`y`));".}
    proc `^=`*(x: var Int128, y: Int128) {.inline.} =
        ## 排他的論理和の結果で値を更新する。計算量O(1)。
        let p = addr x
        {.emit: "((*`p`) ^= (`y`));".}
    proc `<<=`*(x: var Int128, y: Int128) {.inline.} =
        ## 左シフトの結果で値を更新する。計算量O(1)。
        let p = addr x
        {.emit: "((*`p`) <<= (`y`));".}
    proc `>>=`*(x: var Int128, y: Int128) {.inline.} =
        ## 右シフトの結果で値を更新する。計算量O(1)。
        let p = addr x
        {.emit: "((*`p`) >>= (`y`));".}

    proc `+`*(x, y: Int128): Int128 =
        ## 和を返す。計算量O(1)。
        (result = x; result += y)
    proc `-`*(x, y: Int128): Int128 =
        ## 差を返す。計算量O(1)。
        (result = x; result -= y)
    proc `*`*(x, y: Int128): Int128 =
        ## 積を返す。計算量O(1)。
        (result = x; result *= y)
    proc `div`*(x, y: Int128): Int128 =
        ## 商を返す。計算量O(1)。
        (result = x; result.div= y)
    proc `mod`*(x, y: Int128): Int128 =
        ## 剰余を返す。計算量O(1)。
        (result = x; result.mod= y)
    proc `&`*(x, y: Int128): Int128 =
        ## ビット積を返す。計算量O(1)。
        (result = x; result &= y)
    proc `|`*(x, y: Int128): Int128 =
        ## ビット和を返す。計算量O(1)。
        (result = x; result |= y)
    proc `^`*(x, y: Int128): Int128 =
        ## 排他的論理和を返す。計算量O(1)。
        (result = x; result ^= y)
    proc `<<`*(x, y: Int128): Int128 =
        ## 左シフトした値を返す。計算量O(1)。
        (result = x; result <<= y)
    proc `>>`*(x, y: Int128): Int128 =
        ## 右シフトした値を返す。計算量O(1)。
        (result = x; result >>= y)

    proc `>`*(x, y: Int128): bool {.inline.} =
        ## 128ビット整数を比較する。計算量O(1)。
        {.emit: "`result` = ((`x`) > (`y`));".}
    proc `>=`*(x, y: Int128): bool {.inline.} =
        ## 128ビット整数を比較する。計算量O(1)。
        {.emit: "`result` = ((`x`) >= (`y`));".}
    proc `<`*(x, y: Int128): bool {.inline.} =
        ## 128ビット整数を比較する。計算量O(1)。
        {.emit: "`result` = ((`x`) < (`y`));".}
    proc `<=`*(x, y: Int128): bool {.inline.} =
        ## 128ビット整数を比較する。計算量O(1)。
        {.emit: "`result` = ((`x`) <= (`y`));".}
    proc `==`*(x, y: Int128): bool {.inline.} =
        ## 128ビット整数を比較する。計算量O(1)。
        {.emit: "`result` = ((`x`) == (`y`));".}
    proc abs*(x: Int128): Int128 =
        ## 絶対値を返す。計算量O(1)。
        (if x >= 0:x else: -x)
    proc cmp*(x, y: Int128): int =
        ## 大小関係を-1、0、1で返す。計算量O(1)。
        (if x < y: -1 elif x == y: 0 else: 1)
    proc lowBits(x: Int128): uint64 {.inline.} =
        ## 下位64ビットを返す。計算量O(1)。
        {.emit: "`result` = ((unsigned long long)((__uint128_t)(`x`)));".}
    proc highBits(x: Int128): uint64 {.inline.} =
        ## 上位64ビットを返す。計算量O(1)。
        {.emit: "`result` = ((unsigned long long)(((__uint128_t)(`x`)) >> 64));".}
    proc hash*(x: Int128): Hash =
        ## 上位・下位64ビットのハッシュを合成する。計算量O(1)。
        result = !$ (hash(lowBits(x)) !& hash(highBits(x)))

    proc parse_Int128_inner(s: cstring): Int128 =
        ## 十進文字列を128ビット整数へ変換する。計算量O(文字数)。
        {.emit: "`result` = cplib_int128_parse_int128((`s`));".}
    proc parseInt128*(s: string): Int128 =
        ## 十進文字列を128ビット整数へ変換する。計算量O(文字数)。
        parse_Int128_inner(cstring(s))
    proc read_and_parse_int128_inner(x: int): Int128 =
        ## 標準入力から128ビット整数を読む。計算量O(文字数)。
        {.emit: "`result` = cplib_int128_read_and_parse_int128((`x`));".}
    proc read_and_parse_int128*(): Int128 =
        ## 標準入力から128ビット整数を読む。計算量O(文字数)。
        read_and_parse_int128_inner(0)
    proc pow*(x, n: Int128): Int128 =
        ## 非負整数乗を繰り返し二乗法で求める。計算量O(log(n+1))。
        result = 1
        var x = x
        var n = n
        while n > 0:
            if (n & 1) == 1: result *= x
            if n > 1: x *= x
            n >>= 1
    proc pow*(x, n, m: Int128): Int128 =
        ## 非負整数乗を繰り返し二乗法で求める。計算量O(log(n+1))。
        assert m != 0, "法mは0以外である必要があります"
        if m == 1:
            return 0
        result = 1
        var x = x mod m
        var n = n
        while n > 0:
            if (n & 1) == 1: result = (result * x) mod m
            if n > 1:
                x *= x
                x.mod= m
            n >>= 1
    proc to_string_inner(x: Int128): cstring =
        ## 十進表記の一時バッファを返す。計算量O(桁数)。
        {.emit: "`result` = cplib_int128_to_string((`x`));".}
    proc `$`*(x: Int128): string =
        ## 十進文字列へ変換する。計算量O(桁数)。
        $(to_string_inner(x))
    proc put_inner*(x: Int128) =
        ## 十進表記と改行を標準出力へ書き込む。計算量O(桁数)。
        {.emit: "cplib_int128_output_int128((`x`));".}
    proc put*(x: Int128) =
        ## 十進表記と改行を標準出力へ書き込む。計算量O(桁数)。
        put_inner(x)
