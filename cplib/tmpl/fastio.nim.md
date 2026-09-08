---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':warning:'
    path: verify/str/merged_static_string.nim
    title: verify/str/merged_static_string.nim
  - icon: ':warning:'
    path: verify/str/merged_static_string.nim
    title: verify/str/merged_static_string.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/fastio_test.nim
    title: verify/AI/fastio_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/fastio_test.nim
    title: verify/AI/fastio_test.nim
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
    path: verify/math/division_of_big_integers_test.nim
    title: verify/math/division_of_big_integers_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/division_of_big_integers_test.nim
    title: verify/math/division_of_big_integers_test.nim
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
  - icon: ':heavy_check_mark:'
    path: verify/tmpl/fastio_global_checksum_test.nim
    title: verify/tmpl/fastio_global_checksum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tmpl/fastio_global_checksum_test.nim
    title: verify/tmpl/fastio_global_checksum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tmpl/fastio_many_aplusb_test.nim
    title: verify/tmpl/fastio_many_aplusb_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tmpl/fastio_many_aplusb_test.nim
    title: verify/tmpl/fastio_many_aplusb_test.nim
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
  code: "when not declared CPLIB_TMPL_FASTIO:\n    const CPLIB_TMPL_FASTIO* = 1\n\
    \    {.passC: \"-mavx2\".}\n    # mmap\u306F\u660E\u793A\u6307\u5B9A\u6642\u306E\
    \u307F\u4F7F\u7528\u3059\u308B\u3002\u65E7\u6765\u306E\u7121\u52B9\u5316\u6307\
    \u5B9A\u3082\u512A\u5148\u3057\u3066\u5C0A\u91CD\u3059\u308B\u3002\n    when not\
    \ defined(fastioMmap) or defined(fastioNoMmap):\n        {.passC: \"-DCPLIB_FASTIO_NO_MMAP\"\
    .}\n    import macros\n\n    # \u5165\u529B\u7CFB\n    {.emit: \"\"\"\n#include\
    \ <cstdio>\n#include <cstddef>\n#include <cstdint>\n#include <cstring>\n#include\
    \ <immintrin.h>\n#include <string>\n#include <sys/mman.h>\n#include <sys/stat.h>\n\
    \nnamespace cplib_fastio_input {\nconstexpr std::size_t buffer_size = 1U << 20;\n\
    constexpr std::size_t safe_integer_bytes = 32;\n\nstruct InputState {\n  alignas(64)\
    \ char buffer[buffer_size];\n  std::size_t cursor;\n  std::size_t length;\n  const\
    \ char* mapped;\n  bool initialized;\n};\n\ninline InputState& input_state() {\n\
    \  static InputState state = {};\n  return state;\n}\n\ninline std::string& token_storage()\
    \ {\n  static std::string storage;\n  return storage;\n}\n\n#if defined(__GNUC__)\
    \ || defined(__clang__)\n#define CPLIB_FASTIO_ALWAYS_INLINE inline __attribute__((always_inline))\n\
    #define CPLIB_FASTIO_NIM_ALWAYS_INLINE \\\n    static inline __attribute__((always_inline))\n\
    #define CPLIB_FASTIO_UNLIKELY(condition) (__builtin_expect(!!(condition), 0))\n\
    #elif defined(_MSC_VER)\n#define CPLIB_FASTIO_ALWAYS_INLINE __forceinline\n#define\
    \ CPLIB_FASTIO_NIM_ALWAYS_INLINE static __forceinline\n#define CPLIB_FASTIO_UNLIKELY(condition)\
    \ (condition)\n#else\n#define CPLIB_FASTIO_ALWAYS_INLINE inline\n#define CPLIB_FASTIO_NIM_ALWAYS_INLINE\
    \ static inline\n#define CPLIB_FASTIO_UNLIKELY(condition) (condition)\n#endif\n\
    \ninline void initialize(InputState& state) {\n  if (state.initialized) return;\n\
    \  state.initialized = true;\n\n#ifndef CPLIB_FASTIO_NO_MMAP\n  struct stat st;\n\
    \  const int fd = fileno(stdin);\n  if (fstat(fd, &st) == 0 && S_ISREG(st.st_mode)\
    \ && st.st_size > 0) {\n    void* p = mmap(nullptr, static_cast<std::size_t>(st.st_size),\n\
    \                   PROT_READ, MAP_PRIVATE, fd, 0);\n    if (p != MAP_FAILED)\
    \ {\n      state.mapped = static_cast<const char*>(p);\n      state.length = static_cast<std::size_t>(st.st_size);\n\
    \      madvise(const_cast<char*>(state.mapped), state.length,\n              MADV_SEQUENTIAL);\n\
    \    }\n  }\n#endif\n}\n\ninline bool refill(InputState& state) {\n  state.length\
    \ =\n      fread_unlocked(state.buffer, 1, buffer_size, stdin);\n  state.cursor\
    \ = 0;\n  return state.length != 0;\n}\n\ninline int get_char() {\n  InputState&\
    \ state = input_state();\n  if (CPLIB_FASTIO_UNLIKELY(!state.initialized)) initialize(state);\n\
    \  if (state.mapped != nullptr) {\n    if (state.cursor == state.length) return\
    \ -1;\n    return static_cast<unsigned char>(state.mapped[state.cursor++]);\n\
    \  }\n  if (state.cursor == state.length && !refill(state)) return -1;\n  return\
    \ static_cast<unsigned char>(state.buffer[state.cursor++]);\n}\n\ninline bool\
    \ has_eight_digits(const char* source) {\n  // \u6B63\u3057\u3044\u6574\u6570\u5165\
    \u529B\u3067\u306F\u3001\u6570\u5B57\u30FB\u7B26\u53F7\u30FB\u7A7A\u767D\u3092\
    \u4E0A\u4F4D4bit\u3060\u3051\u3067\u5224\u5225\u3067\u304D\u308B\u3002\n  std::uint64_t\
    \ bytes;\n  std::memcpy(&bytes, source, sizeof(bytes));\n  return ((bytes ^ 0x3030303030303030ULL)\
    \ &\n          0xf0f0f0f0f0f0f0f0ULL) == 0;\n}\n\ninline unsigned parse_eight_digits(const\
    \ char* source) {\n  std::uint64_t digits;\n  std::memcpy(&digits, source, sizeof(digits));\n\
    \  digits ^= 0x3030303030303030ULL;\n  digits = (digits * ((10ULL << 8) + 1) >>\
    \ 8) &\n      0x00ff00ff00ff00ffULL;\n  digits = (digits * ((100ULL << 16) + 1)\
    \ >> 16) &\n      0x0000ffff0000ffffULL;\n  return static_cast<unsigned>(\n  \
    \    digits * ((10000ULL << 32) + 1) >> 32);\n}\n\ninline unsigned digit_at(const\
    \ char* source) {\n  return static_cast<unsigned>(static_cast<unsigned char>(*source))\
    \ -\n         static_cast<unsigned>('0');\n}\n\ntemplate <bool negative>\nCPLIB_FASTIO_ALWAYS_INLINE\
    \ bool try_parse_digits_unchecked(\n        const char*& source, long long& output)\
    \ {\n  long long value = 0;\n  if (has_eight_digits(source)) {\n    const long\
    \ long digits =\n        static_cast<long long>(parse_eight_digits(source));\n\
    \    value = negative ? value * 100000000LL - digits\n                     : value\
    \ * 100000000LL + digits;\n    source += 8;\n    if (has_eight_digits(source))\
    \ {\n      const long long next_digits =\n          static_cast<long long>(parse_eight_digits(source));\n\
    \      value = negative ? value * 100000000LL - next_digits\n                \
    \       : value * 100000000LL + next_digits;\n      source += 8;\n      for (int\
    \ pair = 0; pair < 2; ++pair) {\n        const unsigned first = digit_at(source);\n\
    \        if (first >= 10U) {\n          output = value;\n          return true;\n\
    \        }\n        const unsigned second = digit_at(source + 1);\n        if\
    \ (second >= 10U) {\n          ++source;\n          output = negative\n      \
    \        ? value * 10 - static_cast<long long>(first)\n              : value *\
    \ 10 + static_cast<long long>(first);\n          return true;\n        }\n   \
    \     value = negative\n            ? value * 100 - static_cast<long long>(first\
    \ * 10U + second)\n            : value * 100 + static_cast<long long>(first *\
    \ 10U + second);\n        source += 2;\n      }\n      if (digit_at(source) <\
    \ 10U) return false;\n      output = value;\n      return true;\n    }\n  }\n\
    \  for (;;) {\n    const unsigned first = digit_at(source);\n    if (first >=\
    \ 10U) {\n      output = value;\n      return true;\n    }\n    const unsigned\
    \ second = digit_at(source + 1);\n    if (second >= 10U) {\n      ++source;\n\
    \      output = negative ? value * 10 - static_cast<long long>(first)\n      \
    \                  : value * 10 + static_cast<long long>(first);\n      return\
    \ true;\n    }\n    value = negative\n        ? value * 100 - static_cast<long\
    \ long>(first * 10U + second)\n        : value * 100 + static_cast<long long>(first\
    \ * 10U + second);\n    source += 2;\n  }\n}\n\ntemplate <bool negative>\ninline\
    \ long long parse_digits_bounded(const char*& source,\n                      \
    \                const char* end) {\n  long long value = 0;\n  while (end - source\
    \ >= 8 && has_eight_digits(source)) {\n    const long long digits =\n        static_cast<long\
    \ long>(parse_eight_digits(source));\n    value = negative ? value * 100000000LL\
    \ - digits\n                     : value * 100000000LL + digits;\n    source +=\
    \ 8;\n  }\n  while (end - source >= 2) {\n    const unsigned first = digit_at(source);\n\
    \    const unsigned second = digit_at(source + 1);\n    if (first >= 10U) return\
    \ value;\n    if (second >= 10U) {\n      ++source;\n      return negative ? value\
    \ * 10 - static_cast<long long>(first)\n                      : value * 10 + static_cast<long\
    \ long>(first);\n    }\n    value = negative\n        ? value * 100 - static_cast<long\
    \ long>(first * 10U + second)\n        : value * 100 + static_cast<long long>(first\
    \ * 10U + second);\n    source += 2;\n  }\n  if (source != end) {\n    const unsigned\
    \ digit = digit_at(source);\n    if (digit < 10U) {\n      value = negative ?\
    \ value * 10 - static_cast<long long>(digit)\n                       : value *\
    \ 10 + static_cast<long long>(digit);\n      ++source;\n    }\n  }\n  return value;\n\
    }\n\nCPLIB_FASTIO_ALWAYS_INLINE bool try_parse_unsigned_digits_unchecked(\n  \
    \      const char*& source, unsigned long long& output) {\n  unsigned long long\
    \ value = 0;\n  if (has_eight_digits(source)) {\n    value = static_cast<unsigned\
    \ long long>(parse_eight_digits(source));\n    source += 8;\n    if (has_eight_digits(source))\
    \ {\n      value = value * 100000000ULL +\n              static_cast<unsigned\
    \ long long>(parse_eight_digits(source));\n      source += 8;\n      for (int\
    \ pair = 0; pair < 2; ++pair) {\n        const unsigned first = digit_at(source);\n\
    \        if (first >= 10U) {\n          output = value;\n          return true;\n\
    \        }\n        const unsigned second = digit_at(source + 1);\n        if\
    \ (second >= 10U) {\n          ++source;\n          output = value * 10ULL + first;\n\
    \          return true;\n        }\n        value = value * 100ULL + first * 10U\
    \ + second;\n        source += 2;\n      }\n      if (digit_at(source) < 10U)\
    \ return false;\n      output = value;\n      return true;\n    }\n  }\n  for\
    \ (;;) {\n    const unsigned first = digit_at(source);\n    if (first >= 10U)\
    \ {\n      output = value;\n      return true;\n    }\n    const unsigned second\
    \ = digit_at(source + 1);\n    if (second >= 10U) {\n      ++source;\n      output\
    \ = value * 10ULL + first;\n      return true;\n    }\n    value = value * 100ULL\
    \ + first * 10U + second;\n    source += 2;\n  }\n}\n\ninline unsigned long long\
    \ parse_unsigned_digits_bounded(\n        const char*& source, const char* end)\
    \ {\n  unsigned long long value = 0;\n  while (end - source >= 8 && has_eight_digits(source))\
    \ {\n    value = value * 100000000ULL +\n            static_cast<unsigned long\
    \ long>(parse_eight_digits(source));\n    source += 8;\n  }\n  while (end - source\
    \ >= 2) {\n    const unsigned first = digit_at(source);\n    const unsigned second\
    \ = digit_at(source + 1);\n    if (first >= 10U) return value;\n    if (second\
    \ >= 10U) {\n      ++source;\n      return value * 10ULL + first;\n    }\n   \
    \ value = value * 100ULL + first * 10U + second;\n    source += 2;\n  }\n  if\
    \ (source != end) {\n    const unsigned digit = digit_at(source);\n    if (digit\
    \ < 10U) {\n      value = value * 10ULL + digit;\n      ++source;\n    }\n  }\n\
    \  return value;\n}\n\nCPLIB_FASTIO_ALWAYS_INLINE long long read_mapped_at(\n\
    \        const char*& source, const char* end) {\n  while (source != end &&\n\
    \         static_cast<unsigned char>(*source) <=\n             static_cast<unsigned\
    \ char>(' ')) {\n    ++source;\n  }\n  if (source == end) return 0;\n  const bool\
    \ negative = *source == '-';\n  if (negative || *source == '+') ++source;\n  if\
    \ (end - source >= static_cast<std::ptrdiff_t>(safe_integer_bytes)) {\n    const\
    \ char* parsed = source;\n    long long value;\n    const bool complete = negative\n\
    \        ? try_parse_digits_unchecked<true>(parsed, value)\n        : try_parse_digits_unchecked<false>(parsed,\
    \ value);\n    if (complete) {\n      source = parsed;\n      return value;\n\
    \    }\n  }\n  return negative ? parse_digits_bounded<true>(source, end)\n   \
    \               : parse_digits_bounded<false>(source, end);\n}\n\nCPLIB_FASTIO_ALWAYS_INLINE\
    \ unsigned long long read_uint_mapped_at(\n        const char*& source, const\
    \ char* end) {\n  while (source != end &&\n         static_cast<unsigned char>(*source)\
    \ <=\n             static_cast<unsigned char>(' ')) {\n    ++source;\n  }\n  if\
    \ (source == end) return 0;\n  const bool negative = *source == '-';\n  if (negative\
    \ || *source == '+') ++source;\n  if (end - source >= static_cast<std::ptrdiff_t>(safe_integer_bytes))\
    \ {\n    const char* parsed = source;\n    unsigned long long value;\n    if (try_parse_unsigned_digits_unchecked(parsed,\
    \ value)) {\n      source = parsed;\n      return negative ? 0ULL - value : value;\n\
    \    }\n  }\n  const unsigned long long value =\n      parse_unsigned_digits_bounded(source,\
    \ end);\n  return negative ? 0ULL - value : value;\n}\n\ninline long long read_int_stream_slow(InputState&\
    \ state) {\n  bool negative = state.buffer[state.cursor] == '-';\n  if (negative\
    \ || state.buffer[state.cursor] == '+') {\n    ++state.cursor;\n    if (state.cursor\
    \ == state.length && !refill(state)) return 0;\n  }\n  long long value = 0;\n\
    \  for (;;) {\n    while (state.cursor != state.length) {\n      const unsigned\
    \ digit = digit_at(state.buffer + state.cursor);\n      if (digit >= 10U) return\
    \ value;\n      value = negative ? value * 10 - static_cast<long long>(digit)\n\
    \                       : value * 10 + static_cast<long long>(digit);\n      ++state.cursor;\n\
    \    }\n    if (!refill(state)) return value;\n  }\n}\n\ninline unsigned long\
    \ long read_uint_stream_slow(InputState& state) {\n  const bool negative = state.buffer[state.cursor]\
    \ == '-';\n  if (negative || state.buffer[state.cursor] == '+') {\n    ++state.cursor;\n\
    \    if (state.cursor == state.length && !refill(state)) return 0;\n  }\n  unsigned\
    \ long long value = 0;\n  for (;;) {\n    while (state.cursor != state.length)\
    \ {\n      const unsigned digit = digit_at(state.buffer + state.cursor);\n   \
    \   if (digit >= 10U) return negative ? 0ULL - value : value;\n      value = value\
    \ * 10ULL + digit;\n      ++state.cursor;\n    }\n    if (!refill(state)) return\
    \ negative ? 0ULL - value : value;\n  }\n}\n\nCPLIB_FASTIO_ALWAYS_INLINE long\
    \ long read_int_stream(InputState& state) {\n  for (;;) {\n    if (state.cursor\
    \ == state.length && !refill(state)) return 0;\n    while (state.cursor != state.length\
    \ &&\n           static_cast<unsigned char>(state.buffer[state.cursor]) <=\n \
    \              static_cast<unsigned char>(' ')) {\n      ++state.cursor;\n   \
    \ }\n    if (state.cursor != state.length) break;\n  }\n  if (state.length - state.cursor\
    \ < safe_integer_bytes) {\n    return read_int_stream_slow(state);\n  }\n  const\
    \ char* source = state.buffer + state.cursor;\n  const bool negative = *source\
    \ == '-';\n  if (negative || *source == '+') ++source;\n  long long value;\n \
    \ const bool complete = negative\n      ? try_parse_digits_unchecked<true>(source,\
    \ value)\n      : try_parse_digits_unchecked<false>(source, value);\n  if (!complete)\
    \ return read_int_stream_slow(state);\n  state.cursor = static_cast<std::size_t>(source\
    \ - state.buffer);\n  return value;\n}\n\nCPLIB_FASTIO_ALWAYS_INLINE unsigned\
    \ long long read_uint_stream(\n        InputState& state) {\n  for (;;) {\n  \
    \  if (state.cursor == state.length && !refill(state)) return 0;\n    while (state.cursor\
    \ != state.length &&\n           static_cast<unsigned char>(state.buffer[state.cursor])\
    \ <=\n               static_cast<unsigned char>(' ')) {\n      ++state.cursor;\n\
    \    }\n    if (state.cursor != state.length) break;\n  }\n  if (state.length\
    \ - state.cursor < safe_integer_bytes) {\n    return read_uint_stream_slow(state);\n\
    \  }\n  const char* source = state.buffer + state.cursor;\n  const bool negative\
    \ = *source == '-';\n  if (negative || *source == '+') ++source;\n  unsigned long\
    \ long value;\n  if (!try_parse_unsigned_digits_unchecked(source, value)) {\n\
    \    return read_uint_stream_slow(state);\n  }\n  state.cursor = static_cast<std::size_t>(source\
    \ - state.buffer);\n  return negative ? 0ULL - value : value;\n}\n\nCPLIB_FASTIO_ALWAYS_INLINE\
    \ long long read_int() {\n  InputState& state = input_state();\n  if (CPLIB_FASTIO_UNLIKELY(!state.initialized))\
    \ initialize(state);\n  if (state.mapped == nullptr) return read_int_stream(state);\n\
    \  const char* source = state.mapped + state.cursor;\n  const long long value\
    \ =\n      read_mapped_at(source, state.mapped + state.length);\n  state.cursor\
    \ = static_cast<std::size_t>(source - state.mapped);\n  return value;\n}\n\nCPLIB_FASTIO_ALWAYS_INLINE\
    \ unsigned long long read_uint() {\n  InputState& state = input_state();\n  if\
    \ (CPLIB_FASTIO_UNLIKELY(!state.initialized)) initialize(state);\n  if (state.mapped\
    \ == nullptr) return read_uint_stream(state);\n  const char* source = state.mapped\
    \ + state.cursor;\n  const unsigned long long value =\n      read_uint_mapped_at(source,\
    \ state.mapped + state.length);\n  state.cursor = static_cast<std::size_t>(source\
    \ - state.mapped);\n  return value;\n}\n\ntemplate <class T>\ninline void read_int_array(T*\
    \ output, std::size_t count) {\n  InputState& state = input_state();\n  if (CPLIB_FASTIO_UNLIKELY(!state.initialized))\
    \ initialize(state);\n  if (state.mapped != nullptr) {\n    const char* source\
    \ = state.mapped + state.cursor;\n    const char* const end = state.mapped + state.length;\n\
    \    for (std::size_t i = 0; i < count; ++i) {\n      output[i] = static_cast<T>(read_mapped_at(source,\
    \ end));\n    }\n    state.cursor = static_cast<std::size_t>(source - state.mapped);\n\
    \  } else {\n    for (std::size_t i = 0; i < count; ++i) {\n      output[i] =\
    \ static_cast<T>(read_int_stream(state));\n    }\n  }\n}\n\ninline bool fastio_is_space(char\
    \ value) {\n  return static_cast<unsigned char>(value) <=\n         static_cast<unsigned\
    \ char>(' ');\n}\n\ninline void skip_spaces(const char*& source, const char* end)\
    \ {\n  while (source != end && fastio_is_space(*source)) ++source;\n}\n\ninline\
    \ void consume_separator(const char*& source, const char* end) {\n  if (source\
    \ != end) {\n    ++source;\n    skip_spaces(source, end);\n  }\n}\n\ninline unsigned\
    \ parse_eight_digits_simd(const char* source) {\n  const __m128i bytes = _mm_loadl_epi64(\n\
    \      reinterpret_cast<const __m128i*>(source));\n  const __m128i digits = _mm_sub_epi8(bytes,\
    \ _mm_set1_epi8('0'));\n  const __m128i pairs = _mm_maddubs_epi16(\n      digits,\
    \ _mm_setr_epi8(10, 1, 10, 1, 10, 1, 10, 1,\n                            0, 0,\
    \ 0, 0, 0, 0, 0, 0));\n  const __m128i quads = _mm_madd_epi16(\n      pairs, _mm_setr_epi16(100,\
    \ 1, 100, 1, 0, 0, 0, 0));\n  return static_cast<unsigned>(_mm_cvtsi128_si32(quads))\
    \ * 10000U +\n      static_cast<unsigned>(_mm_cvtsi128_si32(_mm_srli_si128(quads,\
    \ 4)));\n}\n\n// \u547C\u3073\u51FA\u3057\u5143\u3067\u7A7A\u767D\u3092\u9664\u53BB\
    \u6E08\u307F\u3002\u9577\u3044\u5148\u982D\u30BC\u30ED\u3068\u672B\u5C3E\u306F\
    \u5883\u754C\u4ED8\u304D\u51E6\u7406\u3078\u623B\u3059\u3002\ninline std::uint32_t\
    \ read_u32_digits(const char*& source, const char* end) {\n  if (source == end)\
    \ return 0;\n  const bool negative = *source == '-';\n  if (negative || *source\
    \ == '+') ++source;\n  unsigned long long value = 0;\n  if (end - source >= 16)\
    \ {\n    if (has_eight_digits(source)) {\n      value = parse_eight_digits_simd(source);\n\
    \      const unsigned ninth = digit_at(source + 8);\n      const unsigned tenth\
    \ = digit_at(source + 9);\n      if (ninth >= 10U) {\n        source += 8;\n \
    \     } else if (tenth >= 10U) {\n        value = value * 10ULL + ninth;\n   \
    \     source += 9;\n      } else if (digit_at(source + 10) >= 10U) {\n       \
    \ value = value * 100ULL + ninth * 10U + tenth;\n        source += 10;\n     \
    \ } else {\n        value = parse_unsigned_digits_bounded(source, end);\n    \
    \  }\n    } else {\n      for (;;) {\n        const unsigned first = digit_at(source);\n\
    \        if (first >= 10U) break;\n        const unsigned second = digit_at(source\
    \ + 1);\n        if (second >= 10U) {\n          value = value * 10ULL + first;\n\
    \          ++source;\n          break;\n        }\n        value = value * 100ULL\
    \ + first * 10U + second;\n        source += 2;\n      }\n    }\n  } else {\n\
    \    value = parse_unsigned_digits_bounded(source, end);\n  }\n  return static_cast<std::uint32_t>(negative\
    \ ? 0ULL - value : value);\n}\n\nCPLIB_FASTIO_ALWAYS_INLINE std::uint32_t read_u32()\
    \ {\n  InputState& state = input_state();\n  if (CPLIB_FASTIO_UNLIKELY(!state.initialized))\
    \ initialize(state);\n  if (state.mapped != nullptr) {\n    const char* source\
    \ = state.mapped + state.cursor;\n    const char* const end = state.mapped + state.length;\n\
    \    skip_spaces(source, end);\n    const std::uint32_t value = read_u32_digits(source,\
    \ end);\n    consume_separator(source, end);\n    state.cursor = static_cast<std::size_t>(source\
    \ - state.mapped);\n    return value;\n  }\n  const char* source = state.buffer\
    \ + state.cursor;\n  const char* const end = state.buffer + state.length;\n  skip_spaces(source,\
    \ end);\n  if (CPLIB_FASTIO_UNLIKELY(end - source <\n                        \
    \   static_cast<std::ptrdiff_t>(safe_integer_bytes))) {\n    return static_cast<std::uint32_t>(read_uint_stream(state));\n\
    \  }\n  const std::uint32_t value = read_u32_digits(source, end);\n  // \u9577\
    \u3044\u5148\u982D\u30BC\u30ED\u304Crefill\u5883\u754C\u3092\u307E\u305F\u3050\
    \u5834\u5408\u306F\u3001\u5143\u306E\u4F4D\u7F6E\u304B\u3089\u8AAD\u307F\u76F4\
    \u3059\u3002\n  if (CPLIB_FASTIO_UNLIKELY(source == end)) {\n    return static_cast<std::uint32_t>(read_uint_stream(state));\n\
    \  }\n  consume_separator(source, end);\n  state.cursor = static_cast<std::size_t>(source\
    \ - state.buffer);\n  return value;\n}\n\ninline bool try_read_four_nine_digit_u32(\n\
    \        const char*& source, const char* end, std::uint32_t* output) {\n  if\
    \ (end - source < 40) return false;\n  if (!fastio_is_space(source[9]) || !fastio_is_space(source[19])\
    \ ||\n      !fastio_is_space(source[29]) || !fastio_is_space(source[39])) {\n\
    \    return false;\n  }\n  const __m128i first_two = _mm_unpacklo_epi64(\n   \
    \   _mm_loadl_epi64(reinterpret_cast<const __m128i*>(source)),\n      _mm_loadl_epi64(reinterpret_cast<const\
    \ __m128i*>(source + 10)));\n  const __m128i last_two = _mm_unpacklo_epi64(\n\
    \      _mm_loadl_epi64(reinterpret_cast<const __m128i*>(source + 20)),\n     \
    \ _mm_loadl_epi64(reinterpret_cast<const __m128i*>(source + 30)));\n  const __m256i\
    \ bytes = _mm256_set_m128i(last_two, first_two);\n  const __m256i is_digit = _mm256_and_si256(\n\
    \      _mm256_cmpgt_epi8(bytes, _mm256_set1_epi8('/')),\n      _mm256_cmpgt_epi8(_mm256_set1_epi8(':'),\
    \ bytes));\n  if (static_cast<unsigned>(_mm256_movemask_epi8(is_digit)) !=\n \
    \     0xffffffffU) {\n    return false;\n  }\n\n  const unsigned digit0 = digit_at(source\
    \ + 8);\n  const unsigned digit1 = digit_at(source + 18);\n  const unsigned digit2\
    \ = digit_at(source + 28);\n  const unsigned digit3 = digit_at(source + 38);\n\
    \  const bool ninth_digits = (digit0 < 10U) & (digit1 < 10U) &\n             \
    \               (digit2 < 10U) & (digit3 < 10U);\n  if (!ninth_digits) return\
    \ false;\n\n  const __m256i digits =\n      _mm256_sub_epi8(bytes, _mm256_set1_epi8('0'));\n\
    \  const __m256i pairs = _mm256_maddubs_epi16(\n      digits, _mm256_setr_epi8(\n\
    \          10, 1, 10, 1, 10, 1, 10, 1,\n          10, 1, 10, 1, 10, 1, 10, 1,\n\
    \          10, 1, 10, 1, 10, 1, 10, 1,\n          10, 1, 10, 1, 10, 1, 10, 1));\n\
    \  const __m256i quads = _mm256_madd_epi16(\n      pairs, _mm256_setr_epi16(\n\
    \          100, 1, 100, 1, 100, 1, 100, 1,\n          100, 1, 100, 1, 100, 1,\
    \ 100, 1));\n  const __m256i weighted = _mm256_mullo_epi32(\n      quads, _mm256_setr_epi32(\n\
    \          10000, 1, 10000, 1, 10000, 1, 10000, 1));\n  const __m256i sums =\n\
    \      _mm256_hadd_epi32(weighted, _mm256_setzero_si256());\n  const __m128i first_eight\
    \ = _mm_unpacklo_epi64(\n      _mm256_castsi256_si128(sums),\n      _mm256_extracti128_si256(sums,\
    \ 1));\n  const __m128i values = _mm_add_epi32(\n      _mm_mullo_epi32(first_eight,\
    \ _mm_set1_epi32(10)),\n      _mm_setr_epi32(static_cast<int>(digit0),\n     \
    \                static_cast<int>(digit1),\n                     static_cast<int>(digit2),\n\
    \                     static_cast<int>(digit3)));\n  _mm_storeu_si128(reinterpret_cast<__m128i*>(output),\
    \ values);\n  source += 40;\n  return true;\n}\n\ninline void read_uint_array(std::uint32_t*\
    \ output, std::size_t count) {\n  InputState& state = input_state();\n  if (CPLIB_FASTIO_UNLIKELY(!state.initialized))\
    \ initialize(state);\n  if (state.mapped != nullptr) {\n    const char* source\
    \ = state.mapped + state.cursor;\n    const char* const end = state.mapped + state.length;\n\
    \    skip_spaces(source, end);\n    std::size_t i = 0;\n    unsigned nine_digit_count\
    \ = 0;\n    // \u6700\u521D\u306E16\u8981\u7D20\u3092\u8AAD\u307F\u306A\u304C\u3089\
    \u5206\u5E03\u3092\u78BA\u8A8D\u3057\u3001\u77ED\u3044\u6574\u6570\u3067\u306F\
    AVX\u5224\u5B9A\u3092\u7701\u304F\u3002\n    if (count >= 64) {\n      for (;\
    \ i < 16; ++i) {\n        nine_digit_count += end - source >= 10 &&\n        \
    \    fastio_is_space(source[9]) && has_eight_digits(source) &&\n            digit_at(source\
    \ + 8) < 10U;\n        output[i] = read_u32_digits(source, end);\n        consume_separator(source,\
    \ end);\n      }\n    }\n    if (nine_digit_count >= 12) {\n      while (i < count)\
    \ {\n        if (count - i >= 4 && try_read_four_nine_digit_u32(\n           \
    \     source, end, output + i)) {\n          i += 4;\n          skip_spaces(source,\
    \ end);\n        } else {\n          output[i++] = read_u32_digits(source, end);\n\
    \          if (i != count) consume_separator(source, end);\n        }\n      }\n\
    \    } else {\n      while (i < count) {\n        output[i++] = read_u32_digits(source,\
    \ end);\n        if (i != count) consume_separator(source, end);\n      }\n  \
    \  }\n    state.cursor = static_cast<std::size_t>(source - state.mapped);\n  }\
    \ else {\n    std::size_t i = 0;\n    unsigned nine_digit_count = 0;\n    if (count\
    \ >= 64) {\n      for (; i < 16; ++i) {\n        output[i] = static_cast<std::uint32_t>(read_uint_stream(state));\n\
    \        nine_digit_count += output[i] >= 100000000U &&\n                    \
    \        output[i] < 1000000000U;\n      }\n    }\n    if (nine_digit_count >=\
    \ 12) {\n      while (count - i >= 4) {\n        const char* source = state.buffer\
    \ + state.cursor;\n        const char* const end = state.buffer + state.length;\n\
    \        skip_spaces(source, end);\n        if (try_read_four_nine_digit_u32(source,\
    \ end, output + i)) {\n          state.cursor = static_cast<std::size_t>(source\
    \ - state.buffer);\n          i += 4;\n        } else {\n          state.cursor\
    \ = static_cast<std::size_t>(source - state.buffer);\n          // refill\u3092\
    \u307E\u305F\u3050\u6574\u6570\u306F\u65E2\u5B58\u306E\u30B9\u30C8\u30EA\u30FC\
    \u30E0\u51E6\u7406\u3067\u6700\u5F8C\u307E\u3067\u8AAD\u3080\u3002\n         \
    \ output[i++] = static_cast<std::uint32_t>(read_uint_stream(state));\n       \
    \ }\n      }\n    }\n    for (; i < count; ++i) {\n      output[i] = static_cast<std::uint32_t>(read_uint_stream(state));\n\
    \    }\n  }\n}\n\ntemplate <class T>\ninline void read_uint_array(T* output, std::size_t\
    \ count) {\n  InputState& state = input_state();\n  if (CPLIB_FASTIO_UNLIKELY(!state.initialized))\
    \ initialize(state);\n  if (state.mapped != nullptr) {\n    const char* source\
    \ = state.mapped + state.cursor;\n    const char* const end = state.mapped + state.length;\n\
    \    for (std::size_t i = 0; i < count; ++i) {\n      output[i] = static_cast<T>(read_uint_mapped_at(source,\
    \ end));\n    }\n    state.cursor = static_cast<std::size_t>(source - state.mapped);\n\
    \  } else {\n    for (std::size_t i = 0; i < count; ++i) {\n      output[i] =\
    \ static_cast<T>(read_uint_stream(state));\n    }\n  }\n}\n\ninline const char*\
    \ read_token(std::size_t* output_length) {\n  InputState& state = input_state();\n\
    \  if (CPLIB_FASTIO_UNLIKELY(!state.initialized)) initialize(state);\n  if (state.mapped\
    \ != nullptr) {\n    const char* source = state.mapped + state.cursor;\n    const\
    \ char* const end = state.mapped + state.length;\n    while (source != end &&\n\
    \           static_cast<unsigned char>(*source) <=\n               static_cast<unsigned\
    \ char>(' ')) {\n      ++source;\n    }\n    const char* const token = source;\n\
    \    while (source != end &&\n           static_cast<unsigned char>(*source) >\n\
    \               static_cast<unsigned char>(' ')) {\n      ++source;\n    }\n \
    \   state.cursor = static_cast<std::size_t>(source - state.mapped);\n    *output_length\
    \ = static_cast<std::size_t>(source - token);\n    return token;\n  }\n\n  for\
    \ (;;) {\n    if (state.cursor == state.length && !refill(state)) {\n      *output_length\
    \ = 0;\n      return \"\";\n    }\n    while (state.cursor != state.length &&\n\
    \           static_cast<unsigned char>(state.buffer[state.cursor]) <=\n      \
    \         static_cast<unsigned char>(' ')) {\n      ++state.cursor;\n    }\n \
    \   if (state.cursor != state.length) break;\n  }\n\n  const std::size_t token_begin\
    \ = state.cursor;\n  while (state.cursor != state.length &&\n         static_cast<unsigned\
    \ char>(state.buffer[state.cursor]) >\n             static_cast<unsigned char>('\
    \ ')) {\n    ++state.cursor;\n  }\n  if (state.cursor != state.length) {\n   \
    \ *output_length = state.cursor - token_begin;\n    return state.buffer + token_begin;\n\
    \  }\n\n  std::string& storage = token_storage();\n  storage.assign(state.buffer\
    \ + token_begin,\n                 state.length - token_begin);\n  while (refill(state))\
    \ {\n    while (state.cursor != state.length &&\n           static_cast<unsigned\
    \ char>(state.buffer[state.cursor]) >\n               static_cast<unsigned char>('\
    \ ')) {\n      ++state.cursor;\n    }\n    storage.append(state.buffer, state.cursor);\n\
    \    if (state.cursor != state.length) break;\n  }\n  *output_length = storage.size();\n\
    \  return storage.c_str();\n}\n\n#undef CPLIB_FASTIO_UNLIKELY\n#undef CPLIB_FASTIO_ALWAYS_INLINE\n\
    } // namespace cplib_fastio_input\n\"\"\".}\n\n    proc fastioGetChar(): cint\
    \ {.importcpp: \"cplib_fastio_input::get_char()\", nodecl, inline.}\n    proc\
    \ fastioReadInt(): clonglong {.importcpp: \"cplib_fastio_input::read_int()\",\
    \ nodecl, inline.}\n    proc fastioReadUInt(): culonglong {.importcpp: \"cplib_fastio_input::read_uint()\"\
    , nodecl, inline.}\n    proc fastioReadUInt32(): uint32 {.importcpp: \"cplib_fastio_input::read_u32()\"\
    , nodecl, inline.}\n    proc fastioReadSignedArray[T: SomeSignedInt](values: ptr\
    \ T, count: csize_t) {.importcpp: \"cplib_fastio_input::read_int_array(@)\", nodecl,\
    \ inline.}\n    proc fastioReadUnsignedArray[T: SomeUnsignedInt](values: ptr T,\
    \ count: csize_t) {.importcpp: \"cplib_fastio_input::read_uint_array(@)\", nodecl,\
    \ inline.}\n    proc fastioReadToken(length: ptr csize_t): cstring\n        {.importcpp:\
    \ \"cplib_fastio_input::read_token(@)\", nodecl, inline.}\n\n    type FastioInteger\
    \ = int | int8 | int16 | int32 | int64 |\n        uint | uint8 | uint16 | uint32\
    \ | uint64\n\n    when NimMajor >= 2:\n        template fastioNewSeqUninit(T:\
    \ typedesc, length: int): untyped =\n            newSeqUninit[T](length)\n\n \
    \       template fastioNewStringUninit(length: int): untyped =\n            newStringUninit(length)\n\
    \    else:\n        template fastioNewSeqUninit(T: typedesc, length: int): untyped\
    \ =\n            newSeqUninitialized[T](length)\n\n        template fastioNewStringUninit(length:\
    \ int): untyped =\n            newString(length)\n\n    proc ii(): int {.inline,\n\
    \            codegenDecl: \"CPLIB_FASTIO_NIM_ALWAYS_INLINE $# $#$#\".} =\n   \
    \     fastioReadInt().int\n    proc lii(N: int): seq[int] {.inline.} =\n     \
    \   result = fastioNewSeqUninit(int, N)\n        if N > 0:\n            fastioReadSignedArray(addr\
    \ result[0], N.csize_t)\n\n    # \u578B\u3060\u3051\u306A\u30891\u8981\u7D20\u3001\
    \u9577\u3055\u3068\u578B\u306A\u3089seq\u3068\u3057\u3066\u8AAD\u307F\u8FBC\u3080\
    \u3002\n    proc input[T: FastioInteger](valueType: typedesc[T]): T {.inline,\n\
    \            codegenDecl: \"CPLIB_FASTIO_NIM_ALWAYS_INLINE $# $#$#\".} =\n   \
    \     when T is range:\n            {.error: \"input supports only primitive integer\
    \ types\".}\n        elif T is SomeSignedInt:\n            T(fastioReadInt())\n\
    \        elif T is uint32:\n            fastioReadUInt32()\n        else:\n  \
    \          T(fastioReadUInt())\n\n    proc input[T: FastioInteger](N: int, valueType:\
    \ typedesc[T]): seq[T] {.inline.} =\n        when T is range:\n            {.error:\
    \ \"input supports only primitive integer types\".}\n        else:\n         \
    \   result = fastioNewSeqUninit(T, N)\n            if N > 0:\n               \
    \ when T is SomeSignedInt:\n                    fastioReadSignedArray(addr result[0],\
    \ N.csize_t)\n                else:\n                    fastioReadUnsignedArray(addr\
    \ result[0], N.csize_t)\n\n    proc si(): string {.inline.} =\n        var length:\
    \ csize_t\n        let source = fastioReadToken(addr length)\n        result =\
    \ fastioNewStringUninit(length.int)\n        if length != 0:\n            copyMem(addr\
    \ result[0], source, length.int)\n\n    proc input(valueType: typedesc[string]):\
    \ string {.inline.} =\n        si()\n\n    proc input(N: int, valueType: typedesc[string]):\
    \ seq[string] {.inline.} =\n        result = newSeq[string](N)\n        for i\
    \ in 0 ..< N:\n            result[i] = input(string)\n\n    # \u51FA\u529B\u7CFB\
    \n    {.emit: \"\"\"\n#include <cstdio>\n#include <cstddef>\n#include <cstdint>\n\
    #include <cstring>\n#include <type_traits>\n\nnamespace cplib_fastio_output {\n\
    struct StdoutBuffer {\n  static constexpr std::size_t capacity = 1U << 16;\n \
    \ alignas(64) char data[capacity];\n\n  StdoutBuffer() { setvbuf(stdout, data,\
    \ _IOFBF, capacity); }\n};\n\nstatic StdoutBuffer stdout_buffer;\n\nstruct FourDigits\
    \ {\n  char data[10000][4];\n  constexpr FourDigits() : data{} {\n    for (unsigned\
    \ i = 0; i < 10000; ++i) {\n      data[i][0] = static_cast<char>('0' + i / 1000);\n\
    \      data[i][1] = static_cast<char>('0' + i / 100 % 10);\n      data[i][2] =\
    \ static_cast<char>('0' + i / 10 % 10);\n      data[i][3] = static_cast<char>('0'\
    \ + i % 10);\n    }\n  }\n};\n\nconstexpr FourDigits four_digit_table{};\n\ninline\
    \ const FourDigits& four_digits() {\n  return four_digit_table;\n}\n\ninline char*\
    \ reserve_bytes(std::FILE* output, std::size_t size) {\n#if defined(__GLIBC__)\n\
    \  // stdio\u81EA\u8EAB\u306E\u30D0\u30C3\u30D5\u30A1\u3092\u4F7F\u3044\u3001\
    echo/write/flushFile\u3068\u306E\u51FA\u529B\u9806\u3092\u4FDD\u3064\u3002\n \
    \ if (output->_IO_write_ptr != nullptr &&\n      output->_IO_write_end != nullptr\
    \ &&\n      static_cast<std::size_t>(output->_IO_write_end -\n               \
    \                output->_IO_write_ptr) >= size) {\n    return output->_IO_write_ptr;\n\
    \  }\n#endif\n  return nullptr;\n}\n\ninline void commit_bytes(std::FILE* output,\
    \ char* end) {\n#if defined(__GLIBC__)\n  output->_IO_write_ptr = end;\n#else\n\
    \  (void)output;\n  (void)end;\n#endif\n}\n\ninline char* write_small(char* output,\
    \ unsigned value,\n                         const FourDigits& table) {\n  if (value\
    \ >= 1000) {\n    std::memcpy(output, table.data[value], 4);\n    return output\
    \ + 4;\n  }\n  if (value >= 100) {\n    std::memcpy(output, table.data[value]\
    \ + 1, 3);\n    return output + 3;\n  }\n  if (value >= 10) {\n    std::memcpy(output,\
    \ table.data[value] + 2, 2);\n    return output + 2;\n  }\n  *output++ = static_cast<char>('0'\
    \ + value);\n  return output;\n}\n\ninline char* write_four(char* output, unsigned\
    \ value,\n                        const FourDigits& table) {\n  std::memcpy(output,\
    \ table.data[value], 4);\n  return output + 4;\n}\n\ninline char* write_unsigned_32(char*\
    \ output, std::uint32_t value,\n                               const FourDigits&\
    \ table) {\n  if (value < 10000U) return write_small(output, value, table);\n\
    \  const std::uint32_t quotient = value / 10000U;\n  const unsigned low = static_cast<unsigned>(value\
    \ - quotient * 10000U);\n  if (quotient < 10000U) {\n    output = write_small(output,\
    \ quotient, table);\n    return write_four(output, low, table);\n  }\n  const\
    \ unsigned high = quotient / 10000U;\n  const unsigned middle = quotient - high\
    \ * 10000U;\n  output = write_small(output, high, table);\n  output = write_four(output,\
    \ middle, table);\n  return write_four(output, low, table);\n}\n\ninline char*\
    \ write_unsigned_64(char* output, std::uint64_t value,\n                     \
    \          const FourDigits& table) {\n  if (value < 10000ULL) {\n    return write_small(output,\
    \ static_cast<unsigned>(value), table);\n  }\n  const std::uint64_t quotient1\
    \ = value / 10000ULL;\n  const unsigned chunk1 = static_cast<unsigned>(value -\
    \ quotient1 * 10000ULL);\n  if (quotient1 < 10000ULL) {\n    output = write_small(output,\
    \ static_cast<unsigned>(quotient1), table);\n    return write_four(output, chunk1,\
    \ table);\n  }\n  const std::uint64_t quotient2 = quotient1 / 10000ULL;\n  const\
    \ unsigned chunk2 = static_cast<unsigned>(quotient1 - quotient2 * 10000ULL);\n\
    \  if (quotient2 < 10000ULL) {\n    output = write_small(output, static_cast<unsigned>(quotient2),\
    \ table);\n    output = write_four(output, chunk2, table);\n    return write_four(output,\
    \ chunk1, table);\n  }\n  const std::uint64_t quotient3 = quotient2 / 10000ULL;\n\
    \  const unsigned chunk3 = static_cast<unsigned>(quotient2 - quotient3 * 10000ULL);\n\
    \  if (quotient3 < 10000ULL) {\n    output = write_small(output, static_cast<unsigned>(quotient3),\
    \ table);\n    output = write_four(output, chunk3, table);\n    output = write_four(output,\
    \ chunk2, table);\n    return write_four(output, chunk1, table);\n  }\n  const\
    \ std::uint64_t quotient4 = quotient3 / 10000ULL;\n  const unsigned chunk4 = static_cast<unsigned>(quotient3\
    \ - quotient4 * 10000ULL);\n  output = write_small(output, static_cast<unsigned>(quotient4),\
    \ table);\n  output = write_four(output, chunk4, table);\n  output = write_four(output,\
    \ chunk3, table);\n  output = write_four(output, chunk2, table);\n  return write_four(output,\
    \ chunk1, table);\n}\n\ntemplate <class Unsigned>\ninline char* write_unsigned_dispatch(char*\
    \ output, Unsigned value,\n                                     const FourDigits&\
    \ table,\n                                     std::true_type) {\n  return write_unsigned_32(output,\
    \ static_cast<std::uint32_t>(value), table);\n}\n\ntemplate <class Unsigned>\n\
    inline char* write_unsigned_dispatch(char* output, Unsigned value,\n         \
    \                            const FourDigits& table,\n                      \
    \               std::false_type) {\n  return write_unsigned_64(output, static_cast<std::uint64_t>(value),\
    \ table);\n}\n\ntemplate <class Unsigned>\ninline char* write_unsigned(char* output,\
    \ Unsigned value,\n                            const FourDigits& table) {\n  return\
    \ write_unsigned_dispatch(output, value, table,\n      std::integral_constant<bool,\
    \ (sizeof(Unsigned) <= 4)>{});\n}\n\ntemplate <class Integer>\ninline std::size_t\
    \ join_integers(\n        const Integer* values, std::size_t count, char* output,\n\
    \        const char* separator, std::size_t separator_length) {\n  const FourDigits&\
    \ table = four_digits();\n  char* cursor = output;\n  using Unsigned = typename\
    \ std::make_unsigned<Integer>::type;\n  for (std::size_t i = 0; i < count; ++i)\
    \ {\n    const Integer value = values[i];\n    Unsigned magnitude = static_cast<Unsigned>(value);\n\
    \    if (std::is_signed<Integer>::value && value < 0) {\n      *cursor++ = '-';\n\
    \      magnitude = Unsigned(0) - magnitude;\n    }\n    cursor = write_unsigned(cursor,\
    \ magnitude, table);\n    if (i + 1 != count) {\n      std::memcpy(cursor, separator,\
    \ separator_length);\n      cursor += separator_length;\n    }\n  }\n  return\
    \ static_cast<std::size_t>(cursor - output);\n}\n\nclass BufferedWriter {\n public:\n\
    \  static constexpr std::size_t capacity = 1U << 16;\n\n  explicit BufferedWriter(std::FILE*\
    \ output)\n      : length_(0), output_(output) {}\n\n  inline char* reserve_integer()\
    \ {\n    constexpr std::size_t max_integer_length = 21;\n    if (capacity - length_\
    \ < max_integer_length) flush();\n    return data_ + length_;\n  }\n\n  inline\
    \ void commit(char* end) {\n    length_ = static_cast<std::size_t>(end - data_);\n\
    \  }\n\n  inline void append(const char* source, std::size_t size) {\n    if (size\
    \ <= capacity - length_) {\n      std::memcpy(data_ + length_, source, size);\n\
    \      length_ += size;\n      return;\n    }\n    flush();\n    if (size >= capacity)\
    \ {\n      fwrite_unlocked(source, 1, size, output_);\n    } else {\n      std::memcpy(data_,\
    \ source, size);\n      length_ = size;\n    }\n  }\n\n  inline void flush() {\n\
    \    if (length_ != 0) {\n      fwrite_unlocked(data_, 1, length_, output_);\n\
    \      length_ = 0;\n    }\n  }\n\n private:\n  char data_[capacity];\n  std::size_t\
    \ length_;\n  std::FILE* output_;\n};\n\ntemplate <class Integer>\ninline void\
    \ print_integers(std::FILE* output, const Integer* values,\n                 \
    \        std::size_t count,\n                         const char* separator,\n\
    \                         std::size_t separator_length) {\n  const FourDigits&\
    \ table = four_digits();\n  BufferedWriter writer(output);\n  using Unsigned =\
    \ typename std::make_unsigned<Integer>::type;\n  for (std::size_t i = 0; i < count;\
    \ ++i) {\n    char* cursor = writer.reserve_integer();\n    const Integer value\
    \ = values[i];\n    Unsigned magnitude = static_cast<Unsigned>(value);\n    if\
    \ (std::is_signed<Integer>::value && value < 0) {\n      *cursor++ = '-';\n  \
    \    magnitude = Unsigned(0) - magnitude;\n    }\n    cursor = write_unsigned(cursor,\
    \ magnitude, table);\n    writer.commit(cursor);\n    if (i + 1 != count) writer.append(separator,\
    \ separator_length);\n  }\n  writer.append(\"\\n\", 1);\n  writer.flush();\n}\n\
    \ntemplate <class Integer>\ninline void print_one(std::FILE* output, Integer value)\
    \ {\n  const FourDigits& table = four_digits();\n  char buffer[22];\n  char* const\
    \ reserved = reserve_bytes(output, sizeof(buffer));\n  char* const begin = reserved\
    \ == nullptr ? buffer : reserved;\n  char* cursor = begin;\n  using Unsigned =\
    \ typename std::make_unsigned<Integer>::type;\n  Unsigned magnitude = static_cast<Unsigned>(value);\n\
    \  if (std::is_signed<Integer>::value && value < 0) {\n    *cursor++ = '-';\n\
    \    magnitude = Unsigned(0) - magnitude;\n  }\n  cursor = write_unsigned(cursor,\
    \ magnitude, table);\n  *cursor++ = '\\n';\n  if (reserved != nullptr) {\n   \
    \ commit_bytes(output, cursor);\n  } else {\n    fwrite_unlocked(buffer, 1,\n\
    \                    static_cast<std::size_t>(cursor - buffer), output);\n  }\n\
    }\n\n} // namespace cplib_fastio_output\n\"\"\".}\n\n    proc fastioJoinInts[T:\
    \ SomeInteger](values: ptr T, count: csize_t,\n            output: ptr char, separator:\
    \ cstring, separatorLen: csize_t): csize_t\n        {.importcpp: \"cplib_fastio_output::join_integers(@)\"\
    , nodecl.}\n    proc fastioPrintInts[T: SomeInteger](output: File, values: ptr\
    \ T,\n            count: csize_t, separator: cstring, separatorLen: csize_t)\n\
    \        {.importcpp: \"cplib_fastio_output::print_integers(@)\", nodecl.}\n \
    \   proc fastioPrintInt[T: SomeInteger](output: File, value: T)\n        {.importcpp:\
    \ \"cplib_fastio_output::print_one(@)\", nodecl.}\n\n    proc print_internal(prop:\
    \ tuple[f: File, sepc: string, endc: string,\n            flush: bool], args:\
    \ openArray[string]) =\n        for i in 0 ..< args.len:\n            prop.f.write(args[i])\n\
    \            if i != args.len - 1:\n                prop.f.write(prop.sepc)\n\
    \            else:\n                prop.f.write(prop.endc)\n        if prop.flush:\n\
    \            prop.f.flushFile()\n\n    proc print*(prop: tuple[f: File, sepc:\
    \ string, endc: string, flush: bool],\n            args: varargs[string, `$`])\
    \ =\n        print_internal(prop, args)\n\n    proc fastioPrintWithSeparator(sep:\
    \ string, args: varargs[string, `$`]) =\n        print_internal((f: stdout, sepc:\
    \ sep, endc: \"\\n\", flush: false), args)\n\n    proc fastioAppendInteger[T:\
    \ SomeInteger](destination: var string, value: T) =\n        var magnitude: uint64\n\
    \        when T is SomeSignedInt:\n            let signedValue = value.int64\n\
    \            if signedValue < 0:\n                destination.add('-')\n     \
    \           magnitude = uint64(-(signedValue + 1)) + 1'u64\n            else:\n\
    \                magnitude = signedValue.uint64\n        else:\n            magnitude\
    \ = value.uint64\n\n        if magnitude == 0:\n            destination.add('0')\n\
    \            return\n        var digits: array[20, char]\n        var count =\
    \ 0\n        while magnitude != 0:\n            digits[count] = char(ord('0')\
    \ + int(magnitude mod 10))\n            magnitude = magnitude div 10\n       \
    \     inc count\n        while count != 0:\n            dec count\n          \
    \  destination.add(digits[count])\n\n    # \u6574\u6570\u306F4\u6841\u30C6\u30FC\
    \u30D6\u30EB\u3092\u4F7F\u3046C++\u30D5\u30A9\u30FC\u30DE\u30C3\u30BF\u3078\u307E\
    \u3068\u3081\u3066\u6E21\u3059\u3002\n    proc fastioJoinImpl[T](a: openArray[T],\
    \ sep: string): string =\n        when nimvm:\n            result = newStringOfCap(a.len\
    \ * 4)\n            for i, value in a:\n                if i != 0:\n         \
    \           result.add(sep)\n                when T is SomeInteger:\n        \
    \            fastioAppendInteger(result, value)\n                else:\n     \
    \               result.add($value)\n        else:\n            if a.len == 0:\n\
    \                return \"\"\n            when T is SomeInteger and sizeof(T)\
    \ in [4, 8]:\n                const digits = when sizeof(T) == 8: 20\n       \
    \                        elif T is SomeSignedInt: 11\n                       \
    \        else: 10\n                result = fastioNewStringUninit(\n         \
    \           a.len * digits + (a.len - 1) * sep.len)\n                let written\
    \ = fastioJoinInts(unsafeAddr a[0],\n                    a.len.csize_t, addr result[0],\
    \ sep.cstring, sep.len.csize_t)\n                result.setLen(written.int)\n\
    \            elif compiles(T.umod()) and compiles(a[0].val()):\n             \
    \   # Montgomery\u8868\u73FE\u3092\u542B\u3081\u3001\u516C\u958B\u5024\u3078\u6B63\
    \u898F\u5316\u3057\u3066\u304B\u3089\u4E00\u62EC\u5909\u63DB\u3059\u308B\u3002\
    \n                var canonical = fastioNewSeqUninit(uint32, a.len)\n        \
    \        for i, value in a:\n                    canonical[i] = value.val.uint32\n\
    \                result = fastioJoinImpl(canonical, sep)\n            else:\n\
    \                result = newStringOfCap(a.len * 4)\n                for i, value\
    \ in a:\n                    if i != 0:\n                        result.add(sep)\n\
    \                    when T is SomeInteger:\n                        fastioAppendInteger(result,\
    \ value)\n                    else:\n                        result.add($value)\n\
    \n    proc join*[T: not string](a: openArray[T], sep: string = \"\"): string {.inline.}\
    \ =\n        fastioJoinImpl(a, sep)\n\n    proc fastioPrintArrayImpl[T](a: openArray[T],\
    \ sep: string) =\n        if a.len == 0:\n            stdout.write('\\n')\n  \
    \          return\n        when T is SomeInteger and sizeof(T) in [4, 8]:\n  \
    \          fastioPrintInts(stdout, unsafeAddr a[0], a.len.csize_t,\n         \
    \       sep.cstring, sep.len.csize_t)\n        elif compiles(T.umod()) and compiles(a[0].val()):\n\
    \            var canonical = fastioNewSeqUninit(uint32, a.len)\n            for\
    \ i, value in a:\n                canonical[i] = value.val.uint32\n          \
    \  fastioPrintArrayImpl(canonical, sep)\n        else:\n            stdout.write(fastioJoinImpl(a,\
    \ sep))\n            stdout.write('\\n')\n\n    proc fastioPrintOneImpl[T](value:\
    \ T, sep: string) =\n        when T is SomeInteger and sizeof(T) in [4, 8]:\n\
    \            fastioPrintInt(stdout, value)\n        elif compiles(T.umod()) and\
    \ compiles(value.val()):\n            fastioPrintInt(stdout, value.val.uint32)\n\
    \        else:\n            fastioPrintWithSeparator(sep, value)\n\n    proc fastioPrintIntegerMany[T:\
    \ SomeInteger](sep: string,\n            values: varargs[T]) =\n        fastioPrintArrayImpl(values,\
    \ sep)\n\n    # Python\u98A8\u306B print(*X) \u3068\u66F8\u304F\u3068\u3001X\u3092\
    \u7A7A\u767D\u533A\u5207\u308A\u30671\u884C\u306B\u51FA\u529B\u3059\u308B\u3002\
    \n    template `*`*[T](values: openArray[T]): string =\n        fastioJoinImpl(values,\
    \ \" \")\n\n    # \u6700\u5F8C\u306E\u6587\u5B57\u5217\u5F15\u6570\u3092sep\u3068\
    \u8AA4\u8A8D\u3057\u306A\u3044\u3088\u3046\u3001\u540D\u524D\u4ED8\u304Dsep\u306F\
    \u30DE\u30AF\u30ED\u3067\u51E6\u7406\u3059\u308B\u3002\n    macro print*(args:\
    \ varargs[untyped]): untyped =\n        var sep = newLit(\" \")\n        var hasSep\
    \ = false\n        var values: seq[NimNode]\n        for arg in args:\n      \
    \      if arg.kind == nnkExprEqExpr and arg[0].eqIdent(\"sep\"):\n           \
    \     if hasSep:\n                    error(\"sep can only be specified once\"\
    , arg)\n                sep = arg[1]\n                hasSep = true\n        \
    \    else:\n                values.add(arg)\n        var splatValues: NimNode\n\
    \        if values.len == 1:\n            if values[0].kind == nnkPrefix and values[0][0].eqIdent(\"\
    *\"):\n                splatValues = values[0][1]\n            elif values[0].kind\
    \ in nnkCallKinds and values[0].len == 3 and\n                    values[0][0].eqIdent(\"\
    fastioJoinImpl\"):\n                # \u30AA\u30FC\u30D0\u30FC\u30ED\u30FC\u30C9\
    \u89E3\u6C7A\u6642\u306B *values \u304C\u5148\u306B\u5C55\u958B\u3055\u308C\u305F\
    \u5834\u5408\u3002\n                splatValues = values[0][1]\n        if not\
    \ splatValues.isNil:\n            result = newCall(bindSym\"fastioPrintArrayImpl\"\
    , splatValues, sep)\n        elif values.len == 1:\n            result = newCall(bindSym\"\
    fastioPrintOneImpl\", values[0], sep)\n        else:\n            let integerCall\
    \ = newCall(bindSym\"fastioPrintIntegerMany\", sep)\n            let fallbackCall\
    \ = newCall(bindSym\"fastioPrintWithSeparator\", sep)\n            for value in\
    \ values:\n                integerCall.add(value)\n                fallbackCall.add(value)\n\
    \            result = quote do:\n                when compiles(`integerCall`):\n\
    \                    `integerCall`\n                else:\n                  \
    \  `fallbackCall`\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/tmpl/fastio.nim
  requiredBy:
  - verify/str/merged_static_string.nim
  - verify/str/merged_static_string.nim
  - cplib/tmpl/sheep.nim
  - cplib/tmpl/sheep.nim
  timestamp: '2026-09-05 05:19:50+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/isprime_yukicoder_test.nim
  - verify/math/isprime_yukicoder_test.nim
  - verify/math/isprime_yosupo_test.nim
  - verify/math/isprime_yosupo_test.nim
  - verify/math/division_of_big_integers_test.nim
  - verify/math/division_of_big_integers_test.nim
  - verify/tmpl/fastio_many_aplusb_test.nim
  - verify/tmpl/fastio_many_aplusb_test.nim
  - verify/tmpl/fastio_global_checksum_test.nim
  - verify/tmpl/fastio_global_checksum_test.nim
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
  - verify/AI/fastio_test.nim
  - verify/AI/fastio_test.nim
documentation_of: cplib/tmpl/fastio.nim
layout: document
redirect_from:
- /library/cplib/tmpl/fastio.nim
- /library/cplib/tmpl/fastio.nim.html
title: cplib/tmpl/fastio.nim
---
