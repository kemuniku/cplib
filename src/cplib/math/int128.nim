when not declared CPLIB_MATH_INT128:
    const CPLIB_MATH_INT128* = 1
    import hashes
    {.emit: """
    #include <bits/stdc++.h>
    unsigned long long parseuint_raw8b(const unsigned long long &x) {
        // https://zenn.dev/mizar/articles/fc87d667153080
        unsigned long long result = (x & 0x0f0f0f0f0f0f0f0f);
        result *= ((10ul << 8) + 1); result >>= 8; result &= 0x00ff00ff00ff00ff;
        result *= ((100ul << 16) + 1); result >>= 16; result &= 0x0000ffff0000ffff;
        result *= ((10000ul << 32) + 1); result >>= 32;
        return result;
    }
    unsigned long long parseint_raw8b_wrap(char* p, size_t sz) {
        char c[8] = {0};
        for (size_t i=0; i<sz; i++) c[8-sz+i] = *(p++);
        unsigned long long x;
        std::memcpy(&x, &c, 8);
        return parseuint_raw8b(x);
    }
    __int128_t parse_int128(char* p) {
        // 符号付き128ビット整数を負の値として累積し、最小値も安全に解析する。
        bool minus = *p == '-' ? (p++, true) : false;
        const __int128_t base[9] = {1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000};
        __int128_t result = 0;
        while (1) {
            size_t sz = 0;
            for (size_t i=0; i<8; i++) {
                if (*(p + sz) == '\0') break;
                sz++;
            }
            result = result * base[sz] - parseint_raw8b_wrap(p, sz);
            p += sz;
            if (*p == '\0') break;
        }
        return minus ? result : -result;
    }
    constexpr size_t INT128_DIGIT_STRING_SIZE = 10000;
    constexpr size_t INT128_DIGIT_STRING_LENGHT = 4;
    struct Int128FourDigitStrings {
        char d[INT128_DIGIT_STRING_SIZE * INT128_DIGIT_STRING_LENGHT];
        constexpr Int128FourDigitStrings() : d() {
            for (size_t i=0; i<INT128_DIGIT_STRING_SIZE * INT128_DIGIT_STRING_LENGHT; i++) d[i] = '0';
            for (size_t i=0; i<INT128_DIGIT_STRING_SIZE; i++) {
                size_t pos = INT128_DIGIT_STRING_LENGHT - 1;
                size_t tmp = i;
                while (tmp) {
                    d[i*INT128_DIGIT_STRING_LENGHT+pos--] = "0123456789"[tmp % 10];
                    tmp /= 10;
                }
            }
        }
    };
    char int128_string_buffer[41];
    constexpr auto int128_four_digit_strings = Int128FourDigitStrings();
    char* to_string(__int128_t &x) {
        // 絶対値を符号なしで求め、NUL終端付きの十進文字列を返す。
        __uint128_t tmp = static_cast<__uint128_t>(x);
        if (x < 0) tmp = -tmp;
        char* end = std::end(int128_string_buffer) - 1;
        *end = '\0';
        char* d = end;
        while (tmp >= INT128_DIGIT_STRING_SIZE) {
            size_t pos = (tmp % INT128_DIGIT_STRING_SIZE) * INT128_DIGIT_STRING_LENGHT;
            d -= INT128_DIGIT_STRING_LENGHT;
            std::memcpy(d, int128_four_digit_strings.d+pos, INT128_DIGIT_STRING_LENGHT);
            tmp /= INT128_DIGIT_STRING_SIZE;
        }
        while (tmp > 0) {
            *(--d) = "0123456789"[tmp % 10];
            tmp /= 10;
        }
        if (d == end) *(--d) = '0';
        if (x < 0) *(--d) = '-';
        return d;
    }
    std::ostream &operator<<(std::ostream &dest, __int128_t &x) {
        // NUL終端付きの文字列をストリームへ出力する。
        return dest << to_string(x);
    }
    __int128_t read_and_parse_int128(int x) {
        // 空白を読み飛ばして整数を読む。値のないEOFでは0を返す。計算量O(文字数)。
        int c = getchar_unlocked();
        while (c != EOF && std::isspace(static_cast<unsigned char>(c))) {
            c = getchar_unlocked();
        }
        bool minus = c == '-';
        if (c == '-' || c == '+') c = getchar_unlocked();
        __int128_t result = 0;
        while (c >= '0' && c <= '9') {
            result = result * 10 - (c - '0');
            c = getchar_unlocked();
        }
        return minus ? result : -result;
    }
    void output_int128(__int128_t &x) { std::cout << x << '\n'; }
    """.}
    type Int128* {.importcpp: "__int128_t", nodecl.} = object
    converter to_Int128*(x: SomeInteger): Int128 {.importcpp: "(__int128_t)((#))", nodecl.}
    proc to_int*(x: Int128): int {.importcpp: "(long long)(#)", nodecl.}
    proc `-`*(x: Int128): Int128 {.importcpp: "-((#))", nodecl.}
    proc `+=`*(x: var Int128, y: Int128) {.importcpp: "((#) += (#))", nodecl.}
    proc `-=`*(x: var Int128, y: Int128) {.importcpp: "((#) -= (#))", nodecl.}
    proc `*=`*(x: var Int128, y: Int128) {.importcpp: "((#) *= (#))", nodecl.}
    proc `div=`*(x: var Int128, y: Int128) {.importcpp: "((#) /= (#))", nodecl.}
    proc `mod=`*(x: var Int128, y: Int128) {.importcpp: "((#) %= (#))", nodecl.}
    proc `&=`*(x: var Int128, y: Int128) {.importcpp: "((#) &= (#))", nodecl.}
    proc `|=`*(x: var Int128, y: Int128) {.importcpp: "((#) |= (#))", nodecl.}
    proc `^=`*(x: var Int128, y: Int128) {.importcpp: "((#) ^= (#))", nodecl.}
    proc `<<=`*(x: var Int128, y: Int128) {.importcpp: "((#) <<= (#))", nodecl.}
    proc `>>=`*(x: var Int128, y: Int128) {.importcpp: "((#) >>= (#))", nodecl.}

    proc `+`*(x, y: Int128): Int128 = (result = x; result += y)
    proc `-`*(x, y: Int128): Int128 = (result = x; result -= y)
    proc `*`*(x, y: Int128): Int128 = (result = x; result *= y)
    proc `div`*(x, y: Int128): Int128 = (result = x; result.div= y)
    proc `mod`*(x, y: Int128): Int128 = (result = x; result.mod= y)
    proc `&`*(x, y: Int128): Int128 = (result = x; result &= y)
    proc `|`*(x, y: Int128): Int128 = (result = x; result |= y)
    proc `^`*(x, y: Int128): Int128 = (result = x; result ^= y)
    proc `<<`*(x, y: Int128): Int128 = (result = x; result <<= y)
    proc `>>`*(x, y: Int128): Int128 = (result = x; result >>= y)

    proc `>`*(x, y: Int128): bool {.importcpp: "((#) > (#))", nodecl.}
    proc `>=`*(x, y: Int128): bool {.importcpp: "((#) >= (#))", nodecl.}
    proc `<`*(x, y: Int128): bool {.importcpp: "((#) < (#))", nodecl.}
    proc `<=`*(x, y: Int128): bool {.importcpp: "((#) <= (#))", nodecl.}
    proc `==`*(x, y: Int128): bool {.importcpp: "((#) == (#))", nodecl.}
    proc abs*(x: Int128): Int128 = (if x >= 0:x else: -x)
    proc cmp*(x, y: Int128): int = (if x < y: -1 elif x == y: 0 else: 1)
    proc lowBits(x: Int128): uint64 {.importcpp: "((unsigned long long)((__uint128_t)(#)))", nodecl.}
    proc highBits(x: Int128): uint64 {.importcpp: "((unsigned long long)(((__uint128_t)(#)) >> 64))", nodecl.}
    proc hash*(x: Int128): Hash =
        ## 上位・下位64ビットのハッシュを合成する。計算量O(1)。
        result = !$ (hash(lowBits(x)) !& hash(highBits(x)))

    proc parse_Int128_inner(s: cstring): Int128 {.importcpp: "parse_int128((#))", nodecl.}
    proc parseInt128*(s: string): Int128 = parse_Int128_inner(cstring(s))
    proc read_and_parse_int128_inner(x: int): Int128 {.importcpp: "read_and_parse_int128((#))".}
    proc read_and_parse_int128*(): Int128 = read_and_parse_int128_inner(0)
    proc pow*(x, n: Int128): Int128 =
        result = 1
        var x = x
        var n = n
        while n > 0:
            if (n & 1) == 1: result *= x
            if n > 1: x *= x
            n >>= 1
    proc pow*(x, n, m: Int128): Int128 =
        assert m != 0
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
    proc to_string_inner(x: Int128): cstring {.importcpp: "to_string((#))", nodecl.}
    proc `$`*(x: Int128): string = $(to_string_inner(x))
    proc put_inner*(x:Int128) {.importcpp: "output_int128((#))", nodecl.}
    proc put*(x: Int128)=put_inner(x)
