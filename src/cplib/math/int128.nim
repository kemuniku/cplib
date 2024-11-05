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
        bool minus = *p == '-' ? (p++, true) : false;
        const __int128_t base[9] = {1, 10, 100, 1000, 10000, 100000, 1000000, 10000000, 100000000};
        __int128_t result = 0;
        while (1) {
            size_t sz = 0;
            for (size_t i=0; i<8; i++) {
                if (*(p + sz) == '\0') break;
                sz++;
            }
            result = result * base[sz] + parseint_raw8b_wrap(p, sz);
            p += sz;
            if (*p == '\0') break;
        }
        return minus ? -result : result;
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
    char int128_string_buffer[40];
    constexpr auto int128_four_digit_strings = Int128FourDigitStrings();
    char* to_string(__int128_t &x) {
        __int128_t tmp = x < 0 ? -x : x;
        char* d = std::end(int128_string_buffer);
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
        if (d == std::end(int128_string_buffer)) *(--d) = '0';
        if (x < 0) *(--d) = '-';
        return d;
    }
    std::ostream &operator<<(std::ostream &dest, __int128_t &x) {
        std::ostream::sentry s(dest);
        if (s) {
            __uint128_t tmp = x < 0 ? -x : x;
            char* d = std::end(int128_string_buffer);
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
            if (d == std::end(int128_string_buffer)) *(--d) = '0';
            if (x < 0) *(--d) = '-';
            int len = std::end(int128_string_buffer) - d;
            if (dest.rdbuf()->sputn(d, len) != len) {
                dest.setstate(std::ios_base::badbit);
            }
        }
        return dest;
    }
    __int128_t read_and_parse_int128(int x) {
        char buffer[40];
        size_t offset = 0;
        while (1) {
            char c = getchar_unlocked();
            if (c == ' ' || c == '\n' || c == '\0') {
                *(buffer + offset++) = '\0';
                break;
            }
            *(buffer + offset++) = c;
        }
        return parse_int128(buffer);
    }
    void output_int128(__int128_t &x) { std::cout << x << '\n'; }
    """.}
    type Int128* {.importcpp: "__int128_t", nodecl.} = object
    converter to_Int128*(x: SomeInteger): Int128 {.importcpp: "(__int128_t)((#))", nodecl.}
    converter to_int*(x: Int128): int {.importcpp: "(long long)(#)", nodecl.}
    proc abs*(x: Int128): Int128 {.importcpp: "abs((#))", nodecl.}
    proc `-`*(x: Int128): Int128 {.importcpp: "-((#))", nodecl.}
    proc `+=`*(x: var Int128, y: Int128) {.importcpp: "((#) += (#))", nodecl.}
    proc `-=`*(x: var Int128, y: Int128) {.importcpp: "((#) -= (#))", nodecl.}
    proc `*=`*(x: var Int128, y: Int128) {.importcpp: "((#) *= (#))", nodecl.}
    proc `//=`*(x: var Int128, y: Int128) {.importcpp: "((#) /= (#))", nodecl.}
    proc `%=`*(x: var Int128, y: Int128) {.importcpp: "((#) %= (#))", nodecl.}
    proc `&=`*(x: var Int128, y: Int128) {.importcpp: "((#) &= (#))", nodecl.}
    proc `|=`*(x: var Int128, y: Int128) {.importcpp: "((#) |= (#))", nodecl.}
    proc `^=`*(x: var Int128, y: Int128) {.importcpp: "((#) ^= (#))", nodecl.}
    proc `<<=`*(x: var Int128, y: Int128) {.importcpp: "((#) <<= (#))", nodecl.}
    proc `>>=`*(x: var Int128, y: Int128) {.importcpp: "((#) >>= (#))", nodecl.}

    proc `+`*(x, y: Int128): Int128 = (result = x; result += y)
    proc `-`*(x, y: Int128): Int128 = (result = x; result -= y)
    proc `*`*(x, y: Int128): Int128 = (result = x; result *= y)
    proc `//`*(x, y: Int128): Int128 = (result = x; result //= y)
    proc `%`*(x, y: Int128): Int128 = (result = x; result %= y)
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

    proc cmp*(x, y: Int128): int = (if x < y: -1 elif x == y: 0 else: 1)
    proc hash*(x: Int128): Hash = hash(x // int(100000000000000000)) !& hash(x % int(100000000000000000))

    proc parse_Int128_inner(s: cstring): Int128 {.importcpp: "parse_int128((#))", nodecl.}
    proc parseInt128*(s: string): Int128 = parse_Int128_inner(cstring(s))
    proc read_and_parse_int128_inner(x: int): Int128 {.importcpp: "read_and_parse_int128((#))".}
    proc read_and_parse_int128*(): Int128 = read_and_parse_int128_inner(0)
    proc pow*(x, n, m: Int128): Int128 =
        result = 1
        var x = x
        var n = n
        while n > 0:
            if (n & 1) == 1: result = (result * x) % m
            x *= x
            n >>= 1
    proc to_string_inner(x: Int128): cstring {.importcpp: "to_string((#))", nodecl.}
    proc `$`*(x: Int128): string = $(to_string_inner(x))
    proc put_inner*(x:Int128) {.importcpp: "output_int128((#))", nodecl.}
    proc put*(x: Int128)=put_inner(x)
