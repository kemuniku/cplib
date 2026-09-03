---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy:
  - icon: ':warning:'
    path: verify/str/merged_static_string.nim
    title: verify/str/merged_static_string.nim
  - icon: ':warning:'
    path: verify/str/merged_static_string.nim
    title: verify/str/merged_static_string.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/sheep_test.nim
    title: verify/AI/sheep_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/sheep_test.nim
    title: verify/AI/sheep_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/restore_dijkstra_test.nim
    title: verify/graph/dynamic/restore_dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/restore_dijkstra_test.nim
    title: verify/graph/dynamic/restore_dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/shortest_path_test.nim
    title: verify/graph/dynamic/shortest_path_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/shortest_path_test.nim
    title: verify/graph/dynamic/shortest_path_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/restore_dijkstra_static_test.nim
    title: verify/graph/static/restore_dijkstra_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/restore_dijkstra_static_test.nim
    title: verify/graph/static/restore_dijkstra_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/shortest_path_static_test.nim
    title: verify/graph/static/shortest_path_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/shortest_path_static_test.nim
    title: verify/graph/static/shortest_path_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/isprime_yosupo_test.nim
    title: verify/math/isprime_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/isprime_yosupo_test.nim
    title: verify/math/isprime_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/isprime_yukicoder_test.nim
    title: verify/math/isprime_yukicoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/isprime_yukicoder_test.nim
    title: verify/math/isprime_yukicoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
    title: verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
    title: verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/get_palindromes_test.nim
    title: verify/str/get_palindromes_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/get_palindromes_test.nim
    title: verify/str/get_palindromes_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/hash_string/hash_string_mul_test.nim
    title: verify/str/hash_string/hash_string_mul_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/hash_string/hash_string_mul_test.nim
    title: verify/str/hash_string/hash_string_mul_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_TMPL_SHEEP:\n    const CPLIB_TMPL_SHEEP* = 1\n  \
    \  {.warning[UnusedImport]: off.}\n    {.hint[XDeclaredButNotUsed]: off.}\n  \
    \  import algorithm\n    import sequtils\n    import tables\n    import macros\n\
    \    import math\n    import sets\n    import strutils\n    import strformat\n\
    \    import sugar\n    import heapqueue\n    import streams\n    import deques\n\
    \    import bitops\n    import std/lenientops\n    import options\n    #\u5165\
    \u529B\u7CFB\n    {.emit: \"\"\"\n    #include <cstdio>\n    #include <cstdint>\n\
    \    #include <cstring>\n    #include <sys/mman.h>\n    #include <sys/stat.h>\n\
    \n    namespace cplib_sheep_input {\n    constexpr std::size_t buffer_size = 1U\
    \ << 20;\n    char buffer[buffer_size];\n    std::size_t cursor = 0;\n    std::size_t\
    \ length = 0;\n    const char* mapped = nullptr;\n    bool initialized = false;\n\
    \n    inline void initialize() {\n      if (initialized) return;\n      initialized\
    \ = true;\n\n      struct stat st;\n      const int fd = fileno(stdin);\n    \
    \  if (fstat(fd, &st) == 0 && S_ISREG(st.st_mode) && st.st_size > 0) {\n     \
    \   void* p = mmap(nullptr, static_cast<std::size_t>(st.st_size),\n          \
    \             PROT_READ, MAP_PRIVATE, fd, 0);\n        if (p != MAP_FAILED) {\n\
    \          mapped = static_cast<const char*>(p);\n          length = static_cast<std::size_t>(st.st_size);\n\
    \          madvise(const_cast<char*>(mapped), length, MADV_SEQUENTIAL);\n    \
    \    }\n      }\n    }\n\n    inline int get_char() {\n      initialize();\n \
    \     if (mapped != nullptr) {\n        if (cursor == length) return -1;\n   \
    \     return static_cast<unsigned char>(mapped[cursor++]);\n      }\n\n      if\
    \ (cursor == length) {\n        length = fread_unlocked(buffer, 1, buffer_size,\
    \ stdin);\n        cursor = 0;\n        if (length == 0) return -1;\n      }\n\
    \      return static_cast<unsigned char>(buffer[cursor++]);\n    }\n\n    inline\
    \ bool refill() {\n      length = fread_unlocked(buffer, 1, buffer_size, stdin);\n\
    \      cursor = 0;\n      return length != 0;\n    }\n\n    inline bool has_eight_digits(const\
    \ char* source) {\n      std::uint64_t bytes;\n      std::memcpy(&bytes, source,\
    \ sizeof(bytes));\n      constexpr std::uint64_t high_nibbles = 0xf0f0f0f0f0f0f0f0ULL;\n\
    \      return (bytes & high_nibbles) == 0x3030303030303030ULL &&\n           \
    \  ((bytes + 0x0606060606060606ULL) & high_nibbles) ==\n                 0x3030303030303030ULL;\n\
    \    }\n\n    inline unsigned parse_eight_digits(const char* source) {\n#if defined(__BYTE_ORDER__)\
    \ && __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__\n      std::uint64_t digits;\n\
    \      std::memcpy(&digits, source, sizeof(digits));\n      digits -= 0x3030303030303030ULL;\n\
    \      digits = (digits * 10 + (digits >> 8)) & 0x00ff00ff00ff00ffULL;\n     \
    \ digits = (digits * 100 + (digits >> 16)) & 0x0000ffff0000ffffULL;\n      return\
    \ static_cast<unsigned>(\n          (digits * 10000 + (digits >> 32)) & 0xffffffffULL);\n\
    #else\n      unsigned result = 0;\n      for (int i = 0; i < 8; ++i) {\n     \
    \   result = result * 10U + static_cast<unsigned>(source[i] - '0');\n      }\n\
    \      return result;\n#endif\n    }\n\n    inline long long read_int() {\n  \
    \    initialize();\n\n      if (mapped != nullptr) {\n        while (cursor <\
    \ length && mapped[cursor] <= ' ') ++cursor;\n        if (cursor == length) return\
    \ 0;\n\n        const bool negative = mapped[cursor] == '-';\n        if (negative)\
    \ {\n          ++cursor;\n          if (cursor == length) return 0;\n        }\n\
    \n        if (!negative && length - cursor >= 9 &&\n            has_eight_digits(mapped\
    \ + cursor)) {\n          const unsigned value = parse_eight_digits(mapped + cursor);\n\
    \          const unsigned ninth = static_cast<unsigned>(mapped[cursor + 8] - '0');\n\
    \          if (ninth >= 10U) {\n            cursor += 8;\n            return static_cast<long\
    \ long>(value);\n          }\n          if (length - cursor >= 10 &&\n       \
    \       static_cast<unsigned>(mapped[cursor + 9] - '0') >= 10U) {\n          \
    \  cursor += 9;\n            return static_cast<long long>(value * 10U + ninth);\n\
    \          }\n        }\n\n        long long value = 0;\n        if (negative)\
    \ {\n          while (length - cursor >= 2) {\n            const unsigned first\
    \ = static_cast<unsigned>(mapped[cursor] - '0');\n            const unsigned second\
    \ = static_cast<unsigned>(mapped[cursor + 1] - '0');\n            if (first >=\
    \ 10U || second >= 10U) break;\n            value = value * 100 - static_cast<long\
    \ long>(first * 10U + second);\n            cursor += 2;\n          }\n      \
    \    if (cursor < length) {\n            const unsigned digit = static_cast<unsigned>(mapped[cursor]\
    \ - '0');\n            if (digit < 10U) {\n              value = value * 10 -\
    \ static_cast<long long>(digit);\n              ++cursor;\n            }\n   \
    \       }\n        } else {\n          while (length - cursor >= 2) {\n      \
    \      const unsigned first = static_cast<unsigned>(mapped[cursor] - '0');\n \
    \           const unsigned second = static_cast<unsigned>(mapped[cursor + 1] -\
    \ '0');\n            if (first >= 10U || second >= 10U) break;\n            value\
    \ = value * 100 + static_cast<long long>(first * 10U + second);\n            cursor\
    \ += 2;\n          }\n          if (cursor < length) {\n            const unsigned\
    \ digit = static_cast<unsigned>(mapped[cursor] - '0');\n            if (digit\
    \ < 10U) {\n              value = value * 10 + static_cast<long long>(digit);\n\
    \              ++cursor;\n            }\n          }\n        }\n        return\
    \ value;\n      }\n\n      for (;;) {\n        if (cursor == length && !refill())\
    \ return 0;\n        while (cursor < length && buffer[cursor] <= ' ') ++cursor;\n\
    \        if (cursor < length) break;\n      }\n\n      const bool negative = buffer[cursor]\
    \ == '-';\n      if (negative) ++cursor;\n      long long value = 0;\n\n     \
    \ for (;;) {\n        if (!negative && length - cursor >= 9 &&\n            has_eight_digits(buffer\
    \ + cursor)) {\n          const unsigned first_eight = parse_eight_digits(buffer\
    \ + cursor);\n          const unsigned ninth = static_cast<unsigned>(buffer[cursor\
    \ + 8] - '0');\n          if (ninth >= 10U) {\n            cursor += 8;\n    \
    \        return static_cast<long long>(first_eight);\n          }\n          if\
    \ (length - cursor >= 10 &&\n              static_cast<unsigned>(buffer[cursor\
    \ + 9] - '0') >= 10U) {\n            cursor += 9;\n            return static_cast<long\
    \ long>(first_eight * 10U + ninth);\n          }\n        }\n\n        while (length\
    \ - cursor >= 2) {\n          const unsigned first = static_cast<unsigned>(buffer[cursor]\
    \ - '0');\n          const unsigned second = static_cast<unsigned>(buffer[cursor\
    \ + 1] - '0');\n          if (first >= 10U) return value;\n          if (second\
    \ >= 10U) {\n            value = negative\n                ? value * 10 - static_cast<long\
    \ long>(first)\n                : value * 10 + static_cast<long long>(first);\n\
    \            ++cursor;\n            return value;\n          }\n          value\
    \ = negative\n              ? value * 100 - static_cast<long long>(first * 10U\
    \ + second)\n              : value * 100 + static_cast<long long>(first * 10U\
    \ + second);\n          cursor += 2;\n        }\n\n        if (cursor < length)\
    \ {\n          const unsigned digit = static_cast<unsigned>(buffer[cursor] - '0');\n\
    \          if (digit >= 10U) return value;\n          value = negative\n     \
    \         ? value * 10 - static_cast<long long>(digit)\n              : value\
    \ * 10 + static_cast<long long>(digit);\n          ++cursor;\n        }\n    \
    \    if (!refill()) return value;\n      }\n    }\n\n    template <class T>\n\
    \    inline void read_int_array(T* output, std::size_t count) {\n      for (std::size_t\
    \ i = 0; i < count; ++i) {\n        output[i] = static_cast<T>(read_int());\n\
    \      }\n    }\n    } // namespace cplib_sheep_input\n    \"\"\".}\n\n    proc\
    \ sheepGetChar(): cint {.importcpp: \"cplib_sheep_input::get_char()\", nodecl,\
    \ inline.}\n    proc sheepReadInt(): clonglong {.importcpp: \"cplib_sheep_input::read_int()\"\
    , nodecl, inline.}\n    proc sheepReadIntArray(values: ptr int, count: csize_t)\
    \ {.importcpp: \"cplib_sheep_input::read_int_array(@)\", nodecl, inline.}\n\n\
    \    proc ii(): int {.inline.} = sheepReadInt().int\n    proc lii(N: int): seq[int]\
    \ {.inline.} =\n        result = newSeq[int](N)\n        if N > 0:\n         \
    \   sheepReadIntArray(addr result[0], N.csize_t)\n\n    proc si(): string {.inline.}\
    \ =\n        var c = sheepGetChar()\n        while c >= 0 and c <= ord(' '):\n\
    \            c = sheepGetChar()\n        while c > ord(' '):\n            result.add(char(c))\n\
    \            c = sheepGetChar()\n    \n    # \u51FA\u529B\u7CFB\n    {.emit: \"\
    \"\"\n    #include <cstddef>\n    #include <cstdint>\n    #include <cstring>\n\
    \    #include <type_traits>\n\n    namespace cplib_sheep_output {\n    struct\
    \ FourDigits {\n      char data[10000][4];\n      FourDigits() {\n        for\
    \ (unsigned i = 0; i < 10000; ++i) {\n          data[i][0] = static_cast<char>('0'\
    \ + i / 1000);\n          data[i][1] = static_cast<char>('0' + i / 100 % 10);\n\
    \          data[i][2] = static_cast<char>('0' + i / 10 % 10);\n          data[i][3]\
    \ = static_cast<char>('0' + i % 10);\n        }\n      }\n    };\n\n    inline\
    \ const FourDigits& four_digits() {\n      static const FourDigits table;\n  \
    \    return table;\n    }\n\n    inline char* write_small(char* output, unsigned\
    \ value,\n                             const FourDigits& table) {\n      if (value\
    \ >= 1000) {\n        std::memcpy(output, table.data[value], 4);\n        return\
    \ output + 4;\n      }\n      if (value >= 100) {\n        std::memcpy(output,\
    \ table.data[value] + 1, 3);\n        return output + 3;\n      }\n      if (value\
    \ >= 10) {\n        std::memcpy(output, table.data[value] + 2, 2);\n        return\
    \ output + 2;\n      }\n      *output++ = static_cast<char>('0' + value);\n  \
    \    return output;\n    }\n\n    template <class Unsigned>\n    inline char*\
    \ write_unsigned(char* output, Unsigned value,\n                             \
    \   const FourDigits& table) {\n      unsigned chunks[5];\n      unsigned count\
    \ = 0;\n      while (value >= 10000) {\n        const Unsigned quotient = value\
    \ / 10000;\n        chunks[count++] = static_cast<unsigned>(value - quotient *\
    \ 10000);\n        value = quotient;\n      }\n      output = write_small(output,\
    \ static_cast<unsigned>(value), table);\n      while (count != 0) {\n        std::memcpy(output,\
    \ table.data[chunks[--count]], 4);\n        output += 4;\n      }\n      return\
    \ output;\n    }\n\n    template <class Integer>\n    inline std::size_t join_signed(\n\
    \            const Integer* values, std::size_t count, char* output,\n       \
    \     const char* separator, std::size_t separator_length) {\n      const FourDigits&\
    \ table = four_digits();\n      char* cursor = output;\n      using Unsigned =\
    \ typename std::make_unsigned<Integer>::type;\n      for (std::size_t i = 0; i\
    \ < count; ++i) {\n        const Integer value = values[i];\n        Unsigned\
    \ magnitude = static_cast<Unsigned>(value);\n        if (value < 0) {\n      \
    \    *cursor++ = '-';\n          magnitude = Unsigned(0) - magnitude;\n      \
    \  }\n        cursor = write_unsigned(cursor, magnitude, table);\n        if (i\
    \ + 1 != count) {\n          std::memcpy(cursor, separator, separator_length);\n\
    \          cursor += separator_length;\n        }\n      }\n      return static_cast<std::size_t>(cursor\
    \ - output);\n    }\n\n    template <class Integer>\n    inline std::size_t join_unsigned(\n\
    \            const Integer* values, std::size_t count, char* output,\n       \
    \     const char* separator, std::size_t separator_length) {\n      const FourDigits&\
    \ table = four_digits();\n      char* cursor = output;\n      for (std::size_t\
    \ i = 0; i < count; ++i) {\n        cursor = write_unsigned(cursor, values[i],\
    \ table);\n        if (i + 1 != count) {\n          std::memcpy(cursor, separator,\
    \ separator_length);\n          cursor += separator_length;\n        }\n     \
    \ }\n      return static_cast<std::size_t>(cursor - output);\n    }\n    }  //\
    \ namespace cplib_sheep_output\n    \"\"\".}\n\n    proc sheepJoinI32(values:\
    \ ptr int32, count: csize_t, output: ptr char,\n                      separator:\
    \ cstring, separatorLen: csize_t): csize_t\n        {.importcpp: \"cplib_sheep_output::join_signed(@)\"\
    , nodecl.}\n    proc sheepJoinI64(values: ptr int64, count: csize_t, output: ptr\
    \ char,\n                      separator: cstring, separatorLen: csize_t): csize_t\n\
    \        {.importcpp: \"cplib_sheep_output::join_signed(@)\", nodecl.}\n    proc\
    \ sheepJoinU32(values: ptr uint32, count: csize_t, output: ptr char,\n       \
    \               separator: cstring, separatorLen: csize_t): csize_t\n        {.importcpp:\
    \ \"cplib_sheep_output::join_unsigned(@)\", nodecl.}\n    proc sheepJoinU64(values:\
    \ ptr uint64, count: csize_t, output: ptr char,\n                      separator:\
    \ cstring, separatorLen: csize_t): csize_t\n        {.importcpp: \"cplib_sheep_output::join_unsigned(@)\"\
    , nodecl.}\n\n    # 1. \u5B9F\u969B\u306E\u51E6\u7406\u3092\u884C\u3046 proc (openArray\
    \ \u3092\u53D7\u3051\u53D6\u308B)\n    proc print_internal(prop: tuple[f: File,\
    \ sepc: string, endc: string, flush: bool], args: openArray[string]) =\n     \
    \   for i in 0 ..< args.len:\n            prop.f.write(args[i])\n            if\
    \ i != args.len - 1:\n                prop.f.write(prop.sepc)\n            else:\n\
    \                prop.f.write(prop.endc)\n        if prop.flush:\n           \
    \ prop.f.flushFile()\n\n    # 2. \u30E6\u30FC\u30B6\u30FC\u304C\u547C\u3073\u51FA\
    \u3059\u305F\u3081\u306E\u30A4\u30F3\u30BF\u30FC\u30D5\u30A7\u30FC\u30B9 (varargs\
    \ \u3092\u53D7\u3051\u53D6\u308B)\n    proc print*(prop: tuple[f: File, sepc:\
    \ string, endc: string, flush: bool], args: varargs[string, `$`]) =\n        #\
    \ varargs \u306F\u5185\u90E8\u3067\u306F openArray \u3068\u3057\u3066\u6271\u3048\
    \u308B\u306E\u3067\u3001\u305D\u306E\u307E\u307E\u6E21\u305B\u308B\n        print_internal(prop,\
    \ args)\n\n    proc print*(args: varargs[string, `$`]) =\n        # \u3053\u3061\
    \u3089\u3082\u5185\u90E8\u7528\u306E proc \u3092\u547C\u3076\n        print_internal((f:\
    \ stdout, sepc: \" \", endc: \"\\n\", flush: false), args)\n\n    proc sheepPrintWithSeparator(sep:\
    \ string,\n            args: varargs[string, `$`]) =\n        print_internal((f:\
    \ stdout, sepc: sep, endc: \"\\n\", flush: false), args)\n\n    macro getSymbolName(x:\
    \ typed): string = x.toStrLit\n    macro debug*(args: varargs[untyped]): untyped\
    \ =\n        when defined(debug):\n            result = newNimNode(nnkStmtList,\
    \ args)\n            template prop(e: string = \"\"): untyped = (f: stderr, sepc:\
    \ \"\", endc: e, flush: true)\n            for i, arg in args:\n             \
    \   if arg.kind == nnkStrLit:\n                    result.add(quote do: print(prop(),\
    \ \"\\\"\", `arg`, \"\\\"\"))\n                else:\n                    result.add(quote\
    \ do: print(prop(\": \"), getSymbolName(`arg`)))\n                    result.add(quote\
    \ do: print(prop(), `arg`))\n                if i != args.len - 1: result.add(quote\
    \ do: print(prop(), \", \"))\n                else: result.add(quote do: print(prop(),\
    \ \"\\n\"))\n        else:\n            return (quote do: discard)\n    #chmin,chmax\n\
    \    template `max=`(x, y) =\n        let yVal = y # y\u304C\u8A08\u7B97\u5F0F\
    \u306E\u5834\u5408\u306B\u8A55\u4FA1\u30921\u56DE\u306B\u3059\u308B\u305F\u3081\
    \n        if x < yVal:\n            x = yVal\n\n    template `min=`(x, y) =\n\
    \        let yVal = y\n        if x > yVal:\n            x = yVal\n    proc chmin[T](x:\
    \ var T, y: T):bool=\n        if x > y:\n            x = y\n            return\
    \ true\n        return false\n    proc chmax[T](x: var T, y: T):bool=\n      \
    \  if x < y:\n            x = y\n            return true\n        return false\n\
    \    #bit\u6F14\u7B97\n    proc `%`*(x: int, y: int): int =\n        result =\
    \ x mod y\n        if y > 0 and result < 0: result += y\n        if y < 0 and\
    \ result > 0: result += y\n    proc `//`*(x: int, y: int): int{.inline.} =\n \
    \       result = x div y\n        if y > 0 and result * y > x: result -= 1\n \
    \       if y < 0 and result * y < x: result -= 1\n    proc `%=`(x: var int, y:\
    \ int): void = x = x%y\n    proc `//=`(x: var int, y: int): void = x = x//y\n\
    \    proc `**`(x: int, y: int): int = x^y\n    proc `**=`(x: var int, y: int):\
    \ void = x = x^y\n    proc `^`(x: int, y: int): int = x xor y\n    proc `|`(x:\
    \ int, y: int): int = x or y\n    proc `&`(x: int, y: int): int = x and y\n  \
    \  proc `>>`(x: int, y: int): int = x shr y\n    proc `<<`(x: int, y: int): int\
    \ = x shl y\n    proc `~`(x: int): int = not x\n    proc `^=`(x: var int, y: int):\
    \ void = x = x ^ y\n    proc `&=`(x: var int, y: int): void = x = x & y\n    proc\
    \ `|=`(x: var int, y: int): void = x = x | y\n    proc `>>=`(x: var int, y: int):\
    \ void = x = x >> y\n    proc `<<=`(x: var int, y: int): void = x = x << y\n \
    \   proc `[]`(x: int, n: int): bool = (x and (1 shl n)) != 0\n    #\u4FBF\u5229\
    \u306A\u5909\u63DB\n    proc `!`(x: char, a = '0'): int = int(x)-int(a)\n    #\u5B9A\
    \u6570\n    include cplib/utils/constants\n    const INF = INF64\n    #converter\n\
    \n    #range\n    iterator range(start: int, ends: int, step: int): int =\n  \
    \      var i = start\n        if step < 0:\n            while i > ends:\n    \
    \            yield i\n                i += step\n        elif step > 0:\n    \
    \        while i < ends:\n                yield i\n                i += step\n\
    \    iterator range(ends: int): int = (for i in 0..<ends: yield i)\n    iterator\
    \ range(start: int, ends: int): int = (for i in\n            start..<ends: yield\
    \ i)\n\n    # \u6574\u6570\u306F4\u6841\u30C6\u30FC\u30D6\u30EB\u3092\u4F7F\u3046\
    C++\u30D5\u30A9\u30FC\u30DE\u30C3\u30BF\u3078\u307E\u3068\u3081\u3066\u6E21\u3059\
    \u3002\n    proc sheepJoinImpl[T](a: openArray[T], sep: string): string =\n  \
    \      if a.len == 0:\n            return \"\"\n        when T is SomeSignedInt\
    \ and sizeof(T) == 8:\n            result = newString(a.len * 20 + (a.len - 1)\
    \ * sep.len)\n            let written = sheepJoinI64(cast[ptr int64](unsafeAddr\
    \ a[0]),\n                a.len.csize_t, addr result[0], sep.cstring, sep.len.csize_t)\n\
    \            result.setLen(written.int)\n        elif T is SomeSignedInt and sizeof(T)\
    \ == 4:\n            result = newString(a.len * 11 + (a.len - 1) * sep.len)\n\
    \            let written = sheepJoinI32(cast[ptr int32](unsafeAddr a[0]),\n  \
    \              a.len.csize_t, addr result[0], sep.cstring, sep.len.csize_t)\n\
    \            result.setLen(written.int)\n        elif T is SomeUnsignedInt and\
    \ sizeof(T) == 8:\n            result = newString(a.len * 20 + (a.len - 1) * sep.len)\n\
    \            let written = sheepJoinU64(cast[ptr uint64](unsafeAddr a[0]),\n \
    \               a.len.csize_t, addr result[0], sep.cstring, sep.len.csize_t)\n\
    \            result.setLen(written.int)\n        elif T is SomeUnsignedInt and\
    \ sizeof(T) == 4:\n            result = newString(a.len * 10 + (a.len - 1) * sep.len)\n\
    \            let written = sheepJoinU32(cast[ptr uint32](unsafeAddr a[0]),\n \
    \               a.len.csize_t, addr result[0], sep.cstring, sep.len.csize_t)\n\
    \            result.setLen(written.int)\n        elif compiles(a[0].umod) and\
    \ compiles(a[0].val):\n            # Montgomery\u8868\u73FE\u3092\u542B\u3081\u3001\
    \u516C\u958B\u5024\u3078\u6B63\u898F\u5316\u3057\u3066\u304B\u3089\u4E00\u62EC\
    \u5909\u63DB\u3059\u308B\u3002\n            var canonical = newSeq[uint32](a.len)\n\
    \            for i, value in a:\n                canonical[i] = value.val.uint32\n\
    \            result = sheepJoinImpl(canonical, sep)\n        else:\n         \
    \   result = newStringOfCap(a.len * 4)\n            for i, value in a:\n     \
    \           if i != 0:\n                    result.add(sep)\n                result.add($value)\n\
    \n    proc join*[T: not string](a: openArray[T], sep: string = \"\"): string {.inline.}\
    \ =\n        sheepJoinImpl(a, sep)\n\n    # Python\u98A8\u306B print(*X) \u3068\
    \u66F8\u304F\u3068\u3001X\u3092\u7A7A\u767D\u533A\u5207\u308A\u30671\u884C\u306B\
    \u51FA\u529B\u3059\u308B\u3002\n    template `*`*[T](values: openArray[T]): string\
    \ =\n        sheepJoinImpl(values, \" \")\n\n    # \u6700\u5F8C\u306E\u6587\u5B57\
    \u5217\u5F15\u6570\u3092sep\u3068\u8AA4\u8A8D\u3057\u306A\u3044\u3088\u3046\u3001\
    \u540D\u524D\u4ED8\u304Dsep\u306F\u30DE\u30AF\u30ED\u3067\u51E6\u7406\u3059\u308B\
    \u3002\n    macro print*(args: varargs[untyped]): untyped =\n        var sep =\
    \ newLit(\" \")\n        var hasSep = false\n        var values: seq[NimNode]\n\
    \        for arg in args:\n            if arg.kind == nnkExprEqExpr and arg[0].eqIdent(\"\
    sep\"):\n                if hasSep:\n                    error(\"sep can only\
    \ be specified once\", arg)\n                sep = arg[1]\n                hasSep\
    \ = true\n            else:\n                values.add(arg)\n        var splatValues:\
    \ NimNode\n        if values.len == 1:\n            if values[0].kind == nnkPrefix\
    \ and values[0][0].eqIdent(\"*\"):\n                splatValues = values[0][1]\n\
    \            elif values[0].kind in nnkCallKinds and values[0].len == 3 and\n\
    \                    values[0][0].eqIdent(\"sheepJoinImpl\"):\n              \
    \  # \u30AA\u30FC\u30D0\u30FC\u30ED\u30FC\u30C9\u89E3\u6C7A\u6642\u306B *values\
    \ \u304C\u5148\u306B\u5C55\u958B\u3055\u308C\u305F\u5834\u5408\u3002\n       \
    \         splatValues = values[0][1]\n        if not splatValues.isNil:\n    \
    \        let joined = newCall(bindSym\"sheepJoinImpl\", splatValues, sep)\n  \
    \          result = newCall(bindSym\"sheepPrintWithSeparator\", newLit(\" \"),\
    \ joined)\n        else:\n            result = newCall(bindSym\"sheepPrintWithSeparator\"\
    , sep)\n            for value in values:\n                result.add(value)\n\n\
    \    proc dump[T](arr:seq[seq[T]])=\n        for i in 0..<len(arr):\n        \
    \    echo arr[i]\n\n    proc sum(slice:HSlice[int,int]):int=\n        return (slice.a+slice.b)*len(slice)//2\n\
    \    \n    proc `<`[T](l,r:seq[T]):bool=\n        for i in 0..<min(len(l),len(r)):\n\
    \            if l[i] > r[i]:\n                return false\n            elif l[i]\
    \ < r[i]:\n                return true\n        return len(l) < len(r)\n    \n\
    \    # Yes/No\n    proc yes*(b: bool = true): void = print(if b: \"Yes\" else:\
    \ \"No\")\n\n    template dblock(body: untyped) =\n        when defined(debug):\n\
    \            block:\n                body\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  isVerificationFile: false
  path: cplib/tmpl/sheep.nim
  requiredBy:
  - verify/str/merged_static_string.nim
  - verify/str/merged_static_string.nim
  timestamp: '2026-09-02 04:31:29+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/isprime_yukicoder_test.nim
  - verify/math/isprime_yukicoder_test.nim
  - verify/math/isprime_yosupo_test.nim
  - verify/math/isprime_yosupo_test.nim
  - verify/str/get_palindromes_test.nim
  - verify/str/get_palindromes_test.nim
  - verify/str/hash_string/hash_string_mul_test.nim
  - verify/str/hash_string/hash_string_mul_test.nim
  - verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
  - verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
  - verify/graph/static/restore_dijkstra_static_test.nim
  - verify/graph/static/restore_dijkstra_static_test.nim
  - verify/graph/static/shortest_path_static_test.nim
  - verify/graph/static/shortest_path_static_test.nim
  - verify/graph/dynamic/restore_dijkstra_test.nim
  - verify/graph/dynamic/restore_dijkstra_test.nim
  - verify/graph/dynamic/shortest_path_test.nim
  - verify/graph/dynamic/shortest_path_test.nim
  - verify/AI/sheep_test.nim
  - verify/AI/sheep_test.nim
documentation_of: cplib/tmpl/sheep.nim
layout: document
redirect_from:
- /library/cplib/tmpl/sheep.nim
- /library/cplib/tmpl/sheep.nim.html
title: cplib/tmpl/sheep.nim
---
