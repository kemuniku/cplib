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
    unsigned long long parseint_raw8b_wrap(const std::string &s) {
        char c[8] = {0};
        size_t sz = s.size();
        for (size_t i=0; i<sz; i++) c[7-i] = s[sz-1-i];
        unsigned long long x;
        std::memcpy(&x, &c, 8);
        return parseuint_raw8b(x);
    }
    __int128_t parse_int128(std::string s) {
        bool minus = (s[0] == '-' ? (s = s.substr(1, s.size()-1), true) : false);
        __int128_t result = 0;
        __int128_t base = 1;
        size_t pos = s.size();
        while (pos >= 8) {
            pos -= 8;
            result += parseint_raw8b_wrap(s.substr(pos, 8)) * base;
            base *= 100000000;
        }
        if (pos != 0) result += base * parseint_raw8b_wrap(s.substr(0, pos));
        return minus ? -result : result;
    }
    """.}
    type int128 {.importcpp: "__int128_t", nodecl.} = object
    converter to_int128*(x: SomeInteger): int128 {.importcpp: "(__int128_t)(#)", nodecl.}
    converter int*(x: int128): int {.importcpp: "(long long)(#)", nodecl.}
    proc abs*(x: int128): int128 {.importcpp: "abs(#)", nodecl.}
    proc `-`*(x: int128): int128 {.importcpp: "-(#)", nodecl.}
    proc `+=`*(x: var int128, y: int128) {.importcpp: "((#) += (#))", nodecl.}
    proc `-=`*(x: var int128, y: int128) {.importcpp: "((#) -= (#))", nodecl.}
    proc `*=`*(x: var int128, y: int128) {.importcpp: "((#) *= (#))", nodecl.}
    proc `//=`*(x: var int128, y: int128) {.importcpp: "((#) /= (#))", nodecl.}
    proc `%=`*(x: var int128, y: int128) {.importcpp: "((#) %= (#))", nodecl.}
    proc `&=`*(x: var int128, y: int128) {.importcpp: "((#) &= (#))", nodecl.}
    proc `|=`*(x: var int128, y: int128) {.importcpp: "((#) |= (#))", nodecl.}
    proc `^=`*(x: var int128, y: int128) {.importcpp: "((#) ^= (#))", nodecl.}
    proc `<<=`*(x: var int128, y: int128) {.importcpp: "((#) <<= (#))", nodecl.}
    proc `>>=`*(x: var int128, y: int128) {.importcpp: "((#) >>= (#))", nodecl.}

    proc `+`*(x, y: int128): int128 = (result = x; result += y)
    proc `-`*(x, y: int128): int128 = (result = x; result -= y)
    proc `*`*(x, y: int128): int128 = (result = x; result *= y)
    proc `//`*(x, y: int128): int128 = (result = x; result //= y)
    proc `%`*(x, y: int128): int128 = (result = x; result %= y)
    proc `&`*(x, y: int128): int128 = (result = x; result &= y)
    proc `|`*(x, y: int128): int128 = (result = x; result |= y)
    proc `^`*(x, y: int128): int128 = (result = x; result ^= y)
    proc `<<`*(x, y: int128): int128 = (result = x; result <<= y)
    proc `>>`*(x, y: int128): int128 = (result = x; result >>= y)

    proc `>`*(x, y: int128): bool {.importcpp: "((#) > (#))", nodecl.}
    proc `>=`*(x, y: int128): bool {.importcpp: "((#) >= (#))", nodecl.}
    proc `<`*(x, y: int128): bool {.importcpp: "((#) < (#))", nodecl.}
    proc `<=`*(x, y: int128): bool {.importcpp: "((#) <= (#))", nodecl.}
    proc `==`*(x, y: int128): bool {.importcpp: "((#) == (#))", nodecl.}

    proc cmp*(x, y: int128): int = (if x < y: -1 elif x == y: 0 else: 1)
    proc hash*(x: int128): Hash = hash(x // int(100000000000000000)) !& hash(x % int(100000000000000000))

    proc to_int128_inner(s: cstring): int128 {.importcpp: "parse_int128(#)".}
    proc to_int128*(s: string): int128 = to_int128_inner(cstring(s))
    proc pow*(x, n, m: int128): int128 =
        result = 1
        var x = x
        var n = n
        while n > 0:
            if (n & 1) == 1: result = (result * x) % m
            x *= x
            n >>= 1

    proc `$`*(x: int128): string =
        if (x == 0): return "0"
        var x = x
        const digit = (proc(): array[10000, string] =
            var digit: array[10000, string]
            for i in 0..<10000:
                var sz = ($i).len
                for j in 0..<4-sz: digit[i] &= '0'
                digit[i] &= $i
            digit
        )()
        var arr: array[11, string]
        for i in 0..<11: arr[i] = ""
        if x < 0:
            arr[^1] = "-"
            x = -x
        var pos = 0
        while x > 0:
            arr[pos] = digit[int(x % 10000)]
            x //= 10000
            pos += 1
        while arr[pos-1][0] == '0': arr[pos-1] = arr[pos-1][1..^1]
        arr.reverse
        return arr.join("")
