when not declared CPLIB_MATH_INT128:
    const CPLIB_MATH_INT128* = 1
    import algorithm, hashes, strutils, sequtils
    {.emit: """
    #include <bits/stdc++.h>
    #include <cassert>
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
    char int128_string_buffer[40];
    char* to_string(__int128_t &x) {
        __int128_t tmp = x < 0 ? -x : x;
        char* d = std::end(int128_string_buffer);
        while (1) {
            *(--d) = "0123456789"[tmp % 10];
            tmp /= 10;
            if (tmp == 0) break;
        }
        if (x < 0) *(--d) = '-';
        return d;
    }
    """.}
    type Int128* {.importcpp: "__int128_t", nodecl.} = object
    converter to_Int128*(x: SomeInteger): Int128 {.importcpp: "(__int128_t)(#)", nodecl.}
    converter int*(x: Int128): int {.importcpp: "(long long)(#)", nodecl.}
    proc abs*(x: Int128): Int128 {.importcpp: "abs(#)", nodecl.}
    proc `-`*(x: Int128): Int128 {.importcpp: "-(#)", nodecl.}
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

    proc to_Int128_inner(s: cstring): Int128 {.importcpp: "parse_int128(#)".}
    proc to_Int128*(s: string): Int128 = to_Int128_inner(cstring(s))
    proc pow*(x, n, m: Int128): Int128 =
        result = 1
        var x = x
        var n = n
        while n > 0:
            if (n & 1) == 1: result = (result * x) % m
            x *= x
            n >>= 1
    proc to_string_inner(x: Int128): cstring {.importcpp: "to_string(#)", nodecl.}
    proc `$`*(x: Int128): string = $(to_string_inner(x))
