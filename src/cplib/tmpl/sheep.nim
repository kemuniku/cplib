when not declared CPLIB_TMPL_SHEEP:
    const CPLIB_TMPL_SHEEP* = 1
    {.warning[UnusedImport]: off.}
    {.hint[XDeclaredButNotUsed]: off.}
    import algorithm
    import sequtils
    import tables
    import macros
    import math
    import sets
    import strutils
    import strformat
    import sugar
    import heapqueue
    import streams
    import deques
    import bitops
    import std/lenientops
    import options
    #入力系
    {.emit: """
    #include <cstdio>
    #include <cstdint>
    #include <cstring>
    #include <sys/mman.h>
    #include <sys/stat.h>

    namespace cplib_sheep_input {
    constexpr std::size_t buffer_size = 1U << 20;
    char buffer[buffer_size];
    std::size_t cursor = 0;
    std::size_t length = 0;
    const char* mapped = nullptr;
    bool initialized = false;

    inline void initialize() {
      if (initialized) return;
      initialized = true;

      struct stat st;
      const int fd = fileno(stdin);
      if (fstat(fd, &st) == 0 && S_ISREG(st.st_mode) && st.st_size > 0) {
        void* p = mmap(nullptr, static_cast<std::size_t>(st.st_size),
                       PROT_READ, MAP_PRIVATE, fd, 0);
        if (p != MAP_FAILED) {
          mapped = static_cast<const char*>(p);
          length = static_cast<std::size_t>(st.st_size);
          madvise(const_cast<char*>(mapped), length, MADV_SEQUENTIAL);
        }
      }
    }

    inline int get_char() {
      initialize();
      if (mapped != nullptr) {
        if (cursor == length) return -1;
        return static_cast<unsigned char>(mapped[cursor++]);
      }

      if (cursor == length) {
        length = fread_unlocked(buffer, 1, buffer_size, stdin);
        cursor = 0;
        if (length == 0) return -1;
      }
      return static_cast<unsigned char>(buffer[cursor++]);
    }

    inline bool refill() {
      length = fread_unlocked(buffer, 1, buffer_size, stdin);
      cursor = 0;
      return length != 0;
    }

    inline bool has_eight_digits(const char* source) {
      std::uint64_t bytes;
      std::memcpy(&bytes, source, sizeof(bytes));
      constexpr std::uint64_t high_nibbles = 0xf0f0f0f0f0f0f0f0ULL;
      return (bytes & high_nibbles) == 0x3030303030303030ULL &&
             ((bytes + 0x0606060606060606ULL) & high_nibbles) ==
                 0x3030303030303030ULL;
    }

    inline unsigned parse_eight_digits(const char* source) {
#if defined(__BYTE_ORDER__) && __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
      std::uint64_t digits;
      std::memcpy(&digits, source, sizeof(digits));
      digits -= 0x3030303030303030ULL;
      digits = (digits * 10 + (digits >> 8)) & 0x00ff00ff00ff00ffULL;
      digits = (digits * 100 + (digits >> 16)) & 0x0000ffff0000ffffULL;
      return static_cast<unsigned>(
          (digits * 10000 + (digits >> 32)) & 0xffffffffULL);
#else
      unsigned result = 0;
      for (int i = 0; i < 8; ++i) {
        result = result * 10U + static_cast<unsigned>(source[i] - '0');
      }
      return result;
#endif
    }

    inline long long read_int() {
      initialize();

      if (mapped != nullptr) {
        while (cursor < length && mapped[cursor] <= ' ') ++cursor;
        if (cursor == length) return 0;

        const bool negative = mapped[cursor] == '-';
        if (negative) {
          ++cursor;
          if (cursor == length) return 0;
        }

        if (!negative && length - cursor >= 9 &&
            has_eight_digits(mapped + cursor)) {
          const unsigned value = parse_eight_digits(mapped + cursor);
          const unsigned ninth = static_cast<unsigned>(mapped[cursor + 8] - '0');
          if (ninth >= 10U) {
            cursor += 8;
            return static_cast<long long>(value);
          }
          if (length - cursor >= 10 &&
              static_cast<unsigned>(mapped[cursor + 9] - '0') >= 10U) {
            cursor += 9;
            return static_cast<long long>(value * 10U + ninth);
          }
        }

        long long value = 0;
        if (negative) {
          while (length - cursor >= 2) {
            const unsigned first = static_cast<unsigned>(mapped[cursor] - '0');
            const unsigned second = static_cast<unsigned>(mapped[cursor + 1] - '0');
            if (first >= 10U || second >= 10U) break;
            value = value * 100 - static_cast<long long>(first * 10U + second);
            cursor += 2;
          }
          if (cursor < length) {
            const unsigned digit = static_cast<unsigned>(mapped[cursor] - '0');
            if (digit < 10U) {
              value = value * 10 - static_cast<long long>(digit);
              ++cursor;
            }
          }
        } else {
          while (length - cursor >= 2) {
            const unsigned first = static_cast<unsigned>(mapped[cursor] - '0');
            const unsigned second = static_cast<unsigned>(mapped[cursor + 1] - '0');
            if (first >= 10U || second >= 10U) break;
            value = value * 100 + static_cast<long long>(first * 10U + second);
            cursor += 2;
          }
          if (cursor < length) {
            const unsigned digit = static_cast<unsigned>(mapped[cursor] - '0');
            if (digit < 10U) {
              value = value * 10 + static_cast<long long>(digit);
              ++cursor;
            }
          }
        }
        return value;
      }

      for (;;) {
        if (cursor == length && !refill()) return 0;
        while (cursor < length && buffer[cursor] <= ' ') ++cursor;
        if (cursor < length) break;
      }

      const bool negative = buffer[cursor] == '-';
      if (negative) ++cursor;
      long long value = 0;

      for (;;) {
        if (!negative && length - cursor >= 9 &&
            has_eight_digits(buffer + cursor)) {
          const unsigned first_eight = parse_eight_digits(buffer + cursor);
          const unsigned ninth = static_cast<unsigned>(buffer[cursor + 8] - '0');
          if (ninth >= 10U) {
            cursor += 8;
            return static_cast<long long>(first_eight);
          }
          if (length - cursor >= 10 &&
              static_cast<unsigned>(buffer[cursor + 9] - '0') >= 10U) {
            cursor += 9;
            return static_cast<long long>(first_eight * 10U + ninth);
          }
        }

        while (length - cursor >= 2) {
          const unsigned first = static_cast<unsigned>(buffer[cursor] - '0');
          const unsigned second = static_cast<unsigned>(buffer[cursor + 1] - '0');
          if (first >= 10U) return value;
          if (second >= 10U) {
            value = negative
                ? value * 10 - static_cast<long long>(first)
                : value * 10 + static_cast<long long>(first);
            ++cursor;
            return value;
          }
          value = negative
              ? value * 100 - static_cast<long long>(first * 10U + second)
              : value * 100 + static_cast<long long>(first * 10U + second);
          cursor += 2;
        }

        if (cursor < length) {
          const unsigned digit = static_cast<unsigned>(buffer[cursor] - '0');
          if (digit >= 10U) return value;
          value = negative
              ? value * 10 - static_cast<long long>(digit)
              : value * 10 + static_cast<long long>(digit);
          ++cursor;
        }
        if (!refill()) return value;
      }
    }

    template <class T>
    inline void read_int_array(T* output, std::size_t count) {
      for (std::size_t i = 0; i < count; ++i) {
        output[i] = static_cast<T>(read_int());
      }
    }
    } // namespace cplib_sheep_input
    """.}

    proc sheepGetChar(): cint {.importcpp: "cplib_sheep_input::get_char()", nodecl, inline.}
    proc sheepReadInt(): clonglong {.importcpp: "cplib_sheep_input::read_int()", nodecl, inline.}
    proc sheepReadIntArray(values: ptr int, count: csize_t) {.importcpp: "cplib_sheep_input::read_int_array(@)", nodecl, inline.}

    proc ii(): int {.inline.} = sheepReadInt().int
    proc lii(N: int): seq[int] {.inline.} =
        result = newSeq[int](N)
        if N > 0:
            sheepReadIntArray(addr result[0], N.csize_t)

    proc si(): string {.inline.} =
        var c = sheepGetChar()
        while c >= 0 and c <= ord(' '):
            c = sheepGetChar()
        while c > ord(' '):
            result.add(char(c))
            c = sheepGetChar()
    
    # 出力系
    {.emit: """
    #include <cstddef>
    #include <cstdint>
    #include <cstring>
    #include <type_traits>

    namespace cplib_sheep_output {
    struct FourDigits {
      char data[10000][4];
      FourDigits() {
        for (unsigned i = 0; i < 10000; ++i) {
          data[i][0] = static_cast<char>('0' + i / 1000);
          data[i][1] = static_cast<char>('0' + i / 100 % 10);
          data[i][2] = static_cast<char>('0' + i / 10 % 10);
          data[i][3] = static_cast<char>('0' + i % 10);
        }
      }
    };

    inline const FourDigits& four_digits() {
      static const FourDigits table;
      return table;
    }

    inline char* write_small(char* output, unsigned value,
                             const FourDigits& table) {
      if (value >= 1000) {
        std::memcpy(output, table.data[value], 4);
        return output + 4;
      }
      if (value >= 100) {
        std::memcpy(output, table.data[value] + 1, 3);
        return output + 3;
      }
      if (value >= 10) {
        std::memcpy(output, table.data[value] + 2, 2);
        return output + 2;
      }
      *output++ = static_cast<char>('0' + value);
      return output;
    }

    template <class Unsigned>
    inline char* write_unsigned(char* output, Unsigned value,
                                const FourDigits& table) {
      unsigned chunks[5];
      unsigned count = 0;
      while (value >= 10000) {
        const Unsigned quotient = value / 10000;
        chunks[count++] = static_cast<unsigned>(value - quotient * 10000);
        value = quotient;
      }
      output = write_small(output, static_cast<unsigned>(value), table);
      while (count != 0) {
        std::memcpy(output, table.data[chunks[--count]], 4);
        output += 4;
      }
      return output;
    }

    template <class Integer>
    inline std::size_t join_signed(
            const Integer* values, std::size_t count, char* output,
            const char* separator, std::size_t separator_length) {
      const FourDigits& table = four_digits();
      char* cursor = output;
      using Unsigned = typename std::make_unsigned<Integer>::type;
      for (std::size_t i = 0; i < count; ++i) {
        const Integer value = values[i];
        Unsigned magnitude = static_cast<Unsigned>(value);
        if (value < 0) {
          *cursor++ = '-';
          magnitude = Unsigned(0) - magnitude;
        }
        cursor = write_unsigned(cursor, magnitude, table);
        if (i + 1 != count) {
          std::memcpy(cursor, separator, separator_length);
          cursor += separator_length;
        }
      }
      return static_cast<std::size_t>(cursor - output);
    }

    template <class Integer>
    inline std::size_t join_unsigned(
            const Integer* values, std::size_t count, char* output,
            const char* separator, std::size_t separator_length) {
      const FourDigits& table = four_digits();
      char* cursor = output;
      for (std::size_t i = 0; i < count; ++i) {
        cursor = write_unsigned(cursor, values[i], table);
        if (i + 1 != count) {
          std::memcpy(cursor, separator, separator_length);
          cursor += separator_length;
        }
      }
      return static_cast<std::size_t>(cursor - output);
    }
    }  // namespace cplib_sheep_output
    """.}

    proc sheepJoinI32(values: ptr int32, count: csize_t, output: ptr char,
                      separator: cstring, separatorLen: csize_t): csize_t
        {.importcpp: "cplib_sheep_output::join_signed(@)", nodecl.}
    proc sheepJoinI64(values: ptr int64, count: csize_t, output: ptr char,
                      separator: cstring, separatorLen: csize_t): csize_t
        {.importcpp: "cplib_sheep_output::join_signed(@)", nodecl.}
    proc sheepJoinU32(values: ptr uint32, count: csize_t, output: ptr char,
                      separator: cstring, separatorLen: csize_t): csize_t
        {.importcpp: "cplib_sheep_output::join_unsigned(@)", nodecl.}
    proc sheepJoinU64(values: ptr uint64, count: csize_t, output: ptr char,
                      separator: cstring, separatorLen: csize_t): csize_t
        {.importcpp: "cplib_sheep_output::join_unsigned(@)", nodecl.}

    # 1. 実際の処理を行う proc (openArray を受け取る)
    proc print_internal(prop: tuple[f: File, sepc: string, endc: string, flush: bool], args: openArray[string]) =
        for i in 0 ..< args.len:
            prop.f.write(args[i])
            if i != args.len - 1:
                prop.f.write(prop.sepc)
            else:
                prop.f.write(prop.endc)
        if prop.flush:
            prop.f.flushFile()

    # 2. ユーザーが呼び出すためのインターフェース (varargs を受け取る)
    proc print*(prop: tuple[f: File, sepc: string, endc: string, flush: bool], args: varargs[string, `$`]) =
        # varargs は内部では openArray として扱えるので、そのまま渡せる
        print_internal(prop, args)

    proc print*(args: varargs[string, `$`]) =
        # こちらも内部用の proc を呼ぶ
        print_internal((f: stdout, sepc: " ", endc: "\n", flush: false), args)

    proc sheepPrintWithSeparator(sep: string,
            args: varargs[string, `$`]) =
        print_internal((f: stdout, sepc: sep, endc: "\n", flush: false), args)

    macro getSymbolName(x: typed): string = x.toStrLit
    macro debug*(args: varargs[untyped]): untyped =
        when defined(debug):
            result = newNimNode(nnkStmtList, args)
            template prop(e: string = ""): untyped = (f: stderr, sepc: "", endc: e, flush: true)
            for i, arg in args:
                if arg.kind == nnkStrLit:
                    result.add(quote do: print(prop(), "\"", `arg`, "\""))
                else:
                    result.add(quote do: print(prop(": "), getSymbolName(`arg`)))
                    result.add(quote do: print(prop(), `arg`))
                if i != args.len - 1: result.add(quote do: print(prop(), ", "))
                else: result.add(quote do: print(prop(), "\n"))
        else:
            return (quote do: discard)
    #chmin,chmax
    template `max=`(x, y) =
        let yVal = y # yが計算式の場合に評価を1回にするため
        if x < yVal:
            x = yVal

    template `min=`(x, y) =
        let yVal = y
        if x > yVal:
            x = yVal
    proc chmin[T](x: var T, y: T):bool=
        if x > y:
            x = y
            return true
        return false
    proc chmax[T](x: var T, y: T):bool=
        if x < y:
            x = y
            return true
        return false
    #bit演算
    proc `%`*(x: int, y: int): int =
        result = x mod y
        if y > 0 and result < 0: result += y
        if y < 0 and result > 0: result += y
    proc `//`*(x: int, y: int): int{.inline.} =
        result = x div y
        if y > 0 and result * y > x: result -= 1
        if y < 0 and result * y < x: result -= 1
    proc `%=`(x: var int, y: int): void = x = x%y
    proc `//=`(x: var int, y: int): void = x = x//y
    proc `**`(x: int, y: int): int = x^y
    proc `**=`(x: var int, y: int): void = x = x^y
    proc `^`(x: int, y: int): int = x xor y
    proc `|`(x: int, y: int): int = x or y
    proc `&`(x: int, y: int): int = x and y
    proc `>>`(x: int, y: int): int = x shr y
    proc `<<`(x: int, y: int): int = x shl y
    proc `~`(x: int): int = not x
    proc `^=`(x: var int, y: int): void = x = x ^ y
    proc `&=`(x: var int, y: int): void = x = x & y
    proc `|=`(x: var int, y: int): void = x = x | y
    proc `>>=`(x: var int, y: int): void = x = x >> y
    proc `<<=`(x: var int, y: int): void = x = x << y
    proc `[]`(x: int, n: int): bool = (x and (1 shl n)) != 0
    #便利な変換
    proc `!`(x: char, a = '0'): int = int(x)-int(a)
    #定数
    include cplib/utils/constants
    const INF = INF64
    #converter

    #range
    iterator range(start: int, ends: int, step: int): int =
        var i = start
        if step < 0:
            while i > ends:
                yield i
                i += step
        elif step > 0:
            while i < ends:
                yield i
                i += step
    iterator range(ends: int): int = (for i in 0..<ends: yield i)
    iterator range(start: int, ends: int): int = (for i in
            start..<ends: yield i)

    # 整数は4桁テーブルを使うC++フォーマッタへまとめて渡す。
    proc sheepJoinImpl[T](a: openArray[T], sep: string): string =
        if a.len == 0:
            return ""
        when T is SomeSignedInt and sizeof(T) == 8:
            result = newString(a.len * 20 + (a.len - 1) * sep.len)
            let written = sheepJoinI64(cast[ptr int64](unsafeAddr a[0]),
                a.len.csize_t, addr result[0], sep.cstring, sep.len.csize_t)
            result.setLen(written.int)
        elif T is SomeSignedInt and sizeof(T) == 4:
            result = newString(a.len * 11 + (a.len - 1) * sep.len)
            let written = sheepJoinI32(cast[ptr int32](unsafeAddr a[0]),
                a.len.csize_t, addr result[0], sep.cstring, sep.len.csize_t)
            result.setLen(written.int)
        elif T is SomeUnsignedInt and sizeof(T) == 8:
            result = newString(a.len * 20 + (a.len - 1) * sep.len)
            let written = sheepJoinU64(cast[ptr uint64](unsafeAddr a[0]),
                a.len.csize_t, addr result[0], sep.cstring, sep.len.csize_t)
            result.setLen(written.int)
        elif T is SomeUnsignedInt and sizeof(T) == 4:
            result = newString(a.len * 10 + (a.len - 1) * sep.len)
            let written = sheepJoinU32(cast[ptr uint32](unsafeAddr a[0]),
                a.len.csize_t, addr result[0], sep.cstring, sep.len.csize_t)
            result.setLen(written.int)
        elif compiles(a[0].umod) and compiles(a[0].val):
            # Montgomery表現を含め、公開値へ正規化してから一括変換する。
            var canonical = newSeq[uint32](a.len)
            for i, value in a:
                canonical[i] = value.val.uint32
            result = sheepJoinImpl(canonical, sep)
        else:
            result = newStringOfCap(a.len * 4)
            for i, value in a:
                if i != 0:
                    result.add(sep)
                result.add($value)

    proc join*[T: not string](a: openArray[T], sep: string = ""): string {.inline.} =
        sheepJoinImpl(a, sep)

    # Python風に print(*X) と書くと、Xを空白区切りで1行に出力する。
    template `*`*[T](values: openArray[T]): string =
        sheepJoinImpl(values, " ")

    # 最後の文字列引数をsepと誤認しないよう、名前付きsepはマクロで処理する。
    macro print*(args: varargs[untyped]): untyped =
        var sep = newLit(" ")
        var hasSep = false
        var values: seq[NimNode]
        for arg in args:
            if arg.kind == nnkExprEqExpr and arg[0].eqIdent("sep"):
                if hasSep:
                    error("sep can only be specified once", arg)
                sep = arg[1]
                hasSep = true
            else:
                values.add(arg)
        var splatValues: NimNode
        if values.len == 1:
            if values[0].kind == nnkPrefix and values[0][0].eqIdent("*"):
                splatValues = values[0][1]
            elif values[0].kind in nnkCallKinds and values[0].len == 3 and
                    values[0][0].eqIdent("sheepJoinImpl"):
                # オーバーロード解決時に *values が先に展開された場合。
                splatValues = values[0][1]
        if not splatValues.isNil:
            let joined = newCall(bindSym"sheepJoinImpl", splatValues, sep)
            result = newCall(bindSym"sheepPrintWithSeparator", newLit(" "), joined)
        else:
            result = newCall(bindSym"sheepPrintWithSeparator", sep)
            for value in values:
                result.add(value)

    proc dump[T](arr:seq[seq[T]])=
        for i in 0..<len(arr):
            echo arr[i]

    proc sum(slice:HSlice[int,int]):int=
        return (slice.a+slice.b)*len(slice)//2
    
    proc `<`[T](l,r:seq[T]):bool=
        for i in 0..<min(len(l),len(r)):
            if l[i] > r[i]:
                return false
            elif l[i] < r[i]:
                return true
        return len(l) < len(r)
    
    # Yes/No
    proc yes*(b: bool = true): void = print(if b: "Yes" else: "No")

    template dblock(body: untyped) =
        when defined(debug):
            block:
                body
