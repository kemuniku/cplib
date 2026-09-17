---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd_negative.nim
    title: cplib/graph/warshall_floyd_negative.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd_negative.nim
    title: cplib/graph/warshall_floyd_negative.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_cases.nim
    title: verify/AI/warshall_floyd_avx512_register_cases.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_cases.nim
    title: verify/AI/warshall_floyd_avx512_register_cases.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_int32_test.nim
    title: verify/AI/warshall_floyd_avx512_register_int32_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_int32_test.nim
    title: verify/AI/warshall_floyd_avx512_register_int32_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_large_test.nim
    title: verify/AI/warshall_floyd_avx512_register_large_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_large_test.nim
    title: verify/AI/warshall_floyd_avx512_register_large_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_packed_large_test.nim
    title: verify/AI/warshall_floyd_avx512_register_packed_large_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_packed_large_test.nim
    title: verify/AI/warshall_floyd_avx512_register_packed_large_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_packed_tail_test.nim
    title: verify/AI/warshall_floyd_avx512_register_packed_tail_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_packed_tail_test.nim
    title: verify/AI/warshall_floyd_avx512_register_packed_tail_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_packed_test.nim
    title: verify/AI/warshall_floyd_avx512_register_packed_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_packed_test.nim
    title: verify/AI/warshall_floyd_avx512_register_packed_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_test.nim
    title: verify/AI/warshall_floyd_avx512_register_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_test.nim
    title: verify/AI/warshall_floyd_avx512_register_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_test.nim
    title: verify/AI/warshall_floyd_avx512_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_test.nim
    title: verify/AI/warshall_floyd_avx512_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_negative_test.nim
    title: verify/AI/warshall_floyd_negative_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_negative_test.nim
    title: verify/AI/warshall_floyd_negative_test.nim
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
  code: "when not declared CPLIB_GRAPH_WARSHALLFLOYD:\n    const CPLIB_GRAPH_WARSHALLFLOYD*\
    \ = 1\n    import cplib/graph/graph\n    import cplib/utils/constants\n    import\
    \ sequtils\n    import cplib/graph/warshall_floyd_negative\n\n    when defined(cpp)\
    \ and sizeof(int) == 8:\n        import strutils\n\n        # \u30DB\u30B9\u30C8\
    \u7528C++\u30B3\u30F3\u30D1\u30A4\u30E9\u306Enative\u8A2D\u5B9A\u3067\u30B3\u30F3\
    \u30D1\u30A4\u30EB\u5143CPU\u3092\u8ABF\u3079\u308B\u3002\u5B9F\u884C\u6642\u306E\
    \u5224\u5B9A\u3068\u306F\u72EC\u7ACB\u3002\n        const warshallFloydHostCpuMacros\
    \ = gorgeEx(\n            \"c++ -march=native -dM -E -x c++ -\", \"\\n\")\n  \
    \      when warshallFloydHostCpuMacros.exitCode != 0:\n            {.warning:\
    \ \"\u30B3\u30F3\u30D1\u30A4\u30EB\u5143CPU\u306EAVX-512F\u5BFE\u5FDC\u3092\u5224\
    \u5B9A\u3067\u304D\u307E\u305B\u3093\u3067\u3057\u305F\u3002\u5B9F\u884C\u6642\
    \u306E\u81EA\u52D5\u9078\u629E\u306F\u6709\u52B9\u3067\u3059\u3002\".}\n     \
    \   elif \"#define __AVX512F__ 1\" notin warshallFloydHostCpuMacros.output:\n\
    \            {.warning: \"\u30B3\u30F3\u30D1\u30A4\u30EB\u5143CPU\u306FAVX-512F\u975E\
    \u5BFE\u5FDC\u3067\u3059\u3002\u540C\u3058\u74B0\u5883\u3067\u5B9F\u884C\u3059\
    \u308B\u3068AVX2\u7248\u304C\u4F7F\u308F\u308C\u307E\u3059\u3002\u5B9F\u884C\u5148\
    \u304C\u7570\u306A\u308B\u5834\u5408\u306F\u5B9F\u884C\u5148CPU\u3067\u81EA\u52D5\
    \u9078\u629E\u3057\u307E\u3059\u3002\".}\n\n        {.emit: \"\"\"\n        #ifndef\
    \ CPLIB_GRAPH_WARSHALL_FLOYD_AVX2_HPP\n        #define CPLIB_GRAPH_WARSHALL_FLOYD_AVX2_HPP\n\
    \n        #include <immintrin.h>\n\n        #include <cstddef>\n        #include\
    \ <cstdint>\n        #include <cstring>\n        #include <vector>\n        #include\
    \ <memory>\n\n        #ifndef CPLIB_WARSHALL_FLOYD_BLOCK_SIZE\n        #define\
    \ CPLIB_WARSHALL_FLOYD_BLOCK_SIZE 216\n        #endif\n\n        #ifndef CPLIB_WARSHALL_FLOYD_AVX512_BLOCK_SIZE\n\
    \        #define CPLIB_WARSHALL_FLOYD_AVX512_BLOCK_SIZE 224\n        #endif\n\n\
    \        #ifndef CPLIB_WARSHALL_FLOYD_DENSE_BLOCK_SIZE\n        #define CPLIB_WARSHALL_FLOYD_DENSE_BLOCK_SIZE\
    \ 256\n        #endif\n\n        #ifndef CPLIB_WARSHALL_FLOYD_INT32_BLOCK_SIZE\n\
    \        #define CPLIB_WARSHALL_FLOYD_INT32_BLOCK_SIZE 256\n        #endif\n\n\
    \        #pragma GCC push_options\n        #pragma GCC target(\"avx2\")\n    \
    \    #pragma GCC optimize(\"O3\")\n\n        static inline bool cplib_warshall_floyd_all_reachable_avx2(\n\
    \                const std::int64_t* row,\n                std::size_t begin,\n\
    \                std::size_t end,\n                __m256i inf4,\n           \
    \     std::int64_t inf) {\n            std::size_t j = begin;\n            for\
    \ (; j + 4 <= end; j += 4) {\n                const __m256i values = _mm256_loadu_si256(\n\
    \                    reinterpret_cast<const __m256i*>(row + j));\n           \
    \     const __m256i unreachable = _mm256_cmpeq_epi64(values, inf4);\n        \
    \        if (!_mm256_testz_si256(unreachable, unreachable)) return false;\n  \
    \          }\n            for (; j < end; ++j) {\n                if (row[j] ==\
    \ inf) return false;\n            }\n            return true;\n        }\n\n \
    \       static inline void cplib_warshall_floyd_relax_avx2(\n                std::int64_t*\
    \ row_i,\n                const std::int64_t* row_k,\n                std::int64_t\
    \ dik,\n                std::size_t begin,\n                std::size_t end,\n\
    \                __m256i inf4,\n                std::int64_t inf,\n          \
    \      bool all_reachable) {\n            const __m256i dik4 = _mm256_set1_epi64x(dik);\n\
    \            std::size_t j = begin;\n            if (all_reachable) {\n      \
    \          #pragma GCC unroll 8\n                for (; j + 4 <= end; j += 4)\
    \ {\n                    const __m256i dkj = _mm256_loadu_si256(\n           \
    \             reinterpret_cast<const __m256i*>(row_k + j));\n                \
    \    const __m256i dij = _mm256_loadu_si256(\n                        reinterpret_cast<const\
    \ __m256i*>(row_i + j));\n                    const __m256i candidate = _mm256_add_epi64(dik4,\
    \ dkj);\n                    const __m256i take = _mm256_cmpgt_epi64(dij, candidate);\n\
    \                    _mm256_maskstore_epi64(\n                        reinterpret_cast<long\
    \ long*>(row_i + j), take, candidate);\n                }\n                for\
    \ (; j < end; ++j) {\n                    const std::int64_t candidate = dik +\
    \ row_k[j];\n                    if (candidate < row_i[j]) row_i[j] = candidate;\n\
    \                }\n            } else {\n                #pragma GCC unroll 4\n\
    \                for (; j + 4 <= end; j += 4) {\n                    const __m256i\
    \ dkj = _mm256_loadu_si256(\n                        reinterpret_cast<const __m256i*>(row_k\
    \ + j));\n                    const __m256i dij = _mm256_loadu_si256(\n      \
    \                  reinterpret_cast<const __m256i*>(row_i + j));\n           \
    \         const __m256i candidate = _mm256_add_epi64(dik4, dkj);\n           \
    \         const __m256i unreachable = _mm256_cmpeq_epi64(dkj, inf4);\n       \
    \             const __m256i improves = _mm256_cmpgt_epi64(dij, candidate);\n \
    \                   const __m256i take = _mm256_andnot_si256(\n              \
    \          unreachable, improves);\n                    _mm256_maskstore_epi64(\n\
    \                        reinterpret_cast<long long*>(row_i + j), take, candidate);\n\
    \                }\n                for (; j < end; ++j) {\n                 \
    \   if (row_k[j] != inf) {\n                        const std::int64_t candidate\
    \ = dik + row_k[j];\n                        if (candidate < row_i[j]) row_i[j]\
    \ = candidate;\n                    }\n                }\n            }\n    \
    \    }\n\n        static inline void cplib_warshall_floyd_relax4_dense_avx2(\n\
    \                std::int64_t* __restrict__ row0,\n                std::int64_t*\
    \ __restrict__ row1,\n                std::int64_t* __restrict__ row2,\n     \
    \           std::int64_t* __restrict__ row3,\n                const std::int64_t*\
    \ __restrict__ row_k,\n                std::int64_t dik0,\n                std::int64_t\
    \ dik1,\n                std::int64_t dik2,\n                std::int64_t dik3,\n\
    \                std::size_t end) {\n            const __m256i dik4_0 = _mm256_set1_epi64x(dik0);\n\
    \            const __m256i dik4_1 = _mm256_set1_epi64x(dik1);\n            const\
    \ __m256i dik4_2 = _mm256_set1_epi64x(dik2);\n            const __m256i dik4_3\
    \ = _mm256_set1_epi64x(dik3);\n            std::size_t j = 0;\n            for\
    \ (; j + 4 <= end; j += 4) {\n                const __m256i dkj = _mm256_load_si256(\n\
    \                    reinterpret_cast<const __m256i*>(row_k + j));\n         \
    \       const __m256i candidate0 = _mm256_add_epi64(dik4_0, dkj);\n          \
    \      const __m256i take0 = _mm256_cmpgt_epi64(\n                    _mm256_load_si256(\n\
    \                        reinterpret_cast<const __m256i*>(row0 + j)),\n      \
    \              candidate0);\n                _mm256_maskstore_epi64(\n       \
    \             reinterpret_cast<long long*>(row0 + j), take0, candidate0);\n\n\
    \                const __m256i candidate1 = _mm256_add_epi64(dik4_1, dkj);\n \
    \               const __m256i take1 = _mm256_cmpgt_epi64(\n                  \
    \  _mm256_load_si256(\n                        reinterpret_cast<const __m256i*>(row1\
    \ + j)),\n                    candidate1);\n                _mm256_maskstore_epi64(\n\
    \                    reinterpret_cast<long long*>(row1 + j), take1, candidate1);\n\
    \n                const __m256i candidate2 = _mm256_add_epi64(dik4_2, dkj);\n\
    \                const __m256i take2 = _mm256_cmpgt_epi64(\n                 \
    \   _mm256_load_si256(\n                        reinterpret_cast<const __m256i*>(row2\
    \ + j)),\n                    candidate2);\n                _mm256_maskstore_epi64(\n\
    \                    reinterpret_cast<long long*>(row2 + j), take2, candidate2);\n\
    \n                const __m256i candidate3 = _mm256_add_epi64(dik4_3, dkj);\n\
    \                const __m256i take3 = _mm256_cmpgt_epi64(\n                 \
    \   _mm256_load_si256(\n                        reinterpret_cast<const __m256i*>(row3\
    \ + j)),\n                    candidate3);\n                _mm256_maskstore_epi64(\n\
    \                    reinterpret_cast<long long*>(row3 + j), take3, candidate3);\n\
    \            }\n            for (; j < end; ++j) {\n                const std::int64_t\
    \ dkj = row_k[j];\n                const std::int64_t candidate0 = dik0 + dkj;\n\
    \                const std::int64_t candidate1 = dik1 + dkj;\n               \
    \ const std::int64_t candidate2 = dik2 + dkj;\n                const std::int64_t\
    \ candidate3 = dik3 + dkj;\n                if (candidate0 < row0[j]) row0[j]\
    \ = candidate0;\n                if (candidate1 < row1[j]) row1[j] = candidate1;\n\
    \                if (candidate2 < row2[j]) row2[j] = candidate2;\n           \
    \     if (candidate3 < row3[j]) row3[j] = candidate3;\n            }\n       \
    \ }\n\n        template <bool check_negative = true>\n        static bool cplib_warshall_floyd_int64_sparse_avx2(\n\
    \                void* raw_rows,\n                std::size_t n,\n           \
    \     std::int64_t zero,\n                std::int64_t inf) {\n            std::int64_t**\
    \ d = static_cast<std::int64_t**>(raw_rows);\n            const __m256i inf4 =\
    \ _mm256_set1_epi64x(inf);\n            constexpr std::size_t block_size =\n \
    \               CPLIB_WARSHALL_FLOYD_BLOCK_SIZE;\n\n            for (std::size_t\
    \ i = 0; i < n; ++i) {\n                if (check_negative && d[i][i] < zero)\
    \ return true;\n            }\n\n            for (std::size_t kk = 0; kk < n;\
    \ kk += block_size) {\n                const std::size_t kend =\n            \
    \        kk + block_size < n ? kk + block_size : n;\n\n                // Phase\
    \ 1: close the diagonal block.\n                for (std::size_t k = kk; k < kend;\
    \ ++k) {\n                    const std::int64_t* const row_k = d[k];\n      \
    \              const bool all_reachable =\n                        cplib_warshall_floyd_all_reachable_avx2(\n\
    \                            row_k, kk, kend, inf4, inf);\n                  \
    \  for (std::size_t i = kk; i < kend; ++i) {\n                        const std::int64_t\
    \ dik = d[i][k];\n                        if (dik != inf) cplib_warshall_floyd_relax_avx2(\n\
    \                            d[i], row_k, dik, kk, kend, inf4, inf,\n        \
    \                    all_reachable);\n                    }\n                \
    \    for (std::size_t i = kk; i < kend; ++i) {\n                        if (check_negative\
    \ && d[i][i] < zero) return true;\n                    }\n                }\n\n\
    \                // Phase 2a: update the blocks in the diagonal block row.\n \
    \               for (std::size_t jj = 0; jj < n; jj += block_size) {\n       \
    \             if (jj == kk) continue;\n                    const std::size_t jend\
    \ =\n                        jj + block_size < n ? jj + block_size : n;\n    \
    \                for (std::size_t k = kk; k < kend; ++k) {\n                 \
    \       const std::int64_t* const row_k = d[k];\n                        const\
    \ bool all_reachable =\n                            cplib_warshall_floyd_all_reachable_avx2(\n\
    \                                row_k, jj, jend, inf4, inf);\n              \
    \          for (std::size_t i = kk; i < kend; ++i) {\n                       \
    \     const std::int64_t dik = d[i][k];\n                            if (dik !=\
    \ inf) cplib_warshall_floyd_relax_avx2(\n                                d[i],\
    \ row_k, dik, jj, jend, inf4, inf,\n                                all_reachable);\n\
    \                        }\n                    }\n                }\n\n     \
    \           // Phase 2b: update the blocks in the diagonal block column.\n   \
    \             for (std::size_t ii = 0; ii < n; ii += block_size) {\n         \
    \           if (ii == kk) continue;\n                    const std::size_t iend\
    \ =\n                        ii + block_size < n ? ii + block_size : n;\n    \
    \                for (std::size_t k = kk; k < kend; ++k) {\n                 \
    \       const std::int64_t* const row_k = d[k];\n                        const\
    \ bool all_reachable =\n                            cplib_warshall_floyd_all_reachable_avx2(\n\
    \                                row_k, kk, kend, inf4, inf);\n              \
    \          for (std::size_t i = ii; i < iend; ++i) {\n                       \
    \     const std::int64_t dik = d[i][k];\n                            if (dik !=\
    \ inf) cplib_warshall_floyd_relax_avx2(\n                                d[i],\
    \ row_k, dik, kk, kend, inf4, inf,\n                                all_reachable);\n\
    \                        }\n                    }\n                }\n\n     \
    \           // Phase 3: update all remaining blocks while the three tiles\n  \
    \              // stay cache-resident, reusing them across the inner loops.\n\
    \                for (std::size_t ii = 0; ii < n; ii += block_size) {\n      \
    \              if (ii == kk) continue;\n                    const std::size_t\
    \ iend =\n                        ii + block_size < n ? ii + block_size : n;\n\
    \                    for (std::size_t jj = 0; jj < n; jj += block_size) {\n  \
    \                      if (jj == kk) continue;\n                        const\
    \ std::size_t jend =\n                            jj + block_size < n ? jj + block_size\
    \ : n;\n                        bool reachable[block_size];\n                \
    \        for (std::size_t k = kk; k < kend; ++k) {\n                         \
    \   const std::int64_t* const row_k = d[k];\n                            reachable[k\
    \ - kk] =\n                                cplib_warshall_floyd_all_reachable_avx2(\n\
    \                                    row_k, jj, jend, inf4, inf);\n          \
    \              }\n                        std::size_t i = ii;\n              \
    \          for (; i + 16 <= iend; i += 16) {\n                            for\
    \ (std::size_t k = kk; k < kend; ++k) {\n                                const\
    \ std::int64_t* const row_k = d[k];\n                                #pragma GCC\
    \ unroll 4\n                                for (std::size_t r = 0; r < 16; ++r)\
    \ {\n                                    const std::int64_t dik = d[i + r][k];\n\
    \                                    if (dik != inf)\n                       \
    \                 cplib_warshall_floyd_relax_avx2(\n                         \
    \                   d[i + r], row_k, dik, jj, jend,\n                        \
    \                    inf4, inf, reachable[k - kk]);\n                        \
    \        }\n                            }\n                        }\n       \
    \                 for (; i < iend; ++i) {\n                            for (std::size_t\
    \ k = kk; k < kend; ++k) {\n                                const std::int64_t*\
    \ const row_k = d[k];\n                                const std::int64_t dik\
    \ = d[i][k];\n                                if (dik != inf) cplib_warshall_floyd_relax_avx2(\n\
    \                                    d[i], row_k, dik, jj, jend, inf4, inf,\n\
    \                                    reachable[k - kk]);\n                   \
    \         }\n                        }\n                    }\n              \
    \  }\n\n                for (std::size_t i = 0; i < n; ++i) {\n              \
    \      if (check_negative && d[i][i] < zero) return true;\n                }\n\
    \            }\n            return false;\n        }\n\n        template <bool\
    \ check_negative = true>\n        static bool cplib_warshall_floyd_int64_dense_tiled_avx2(\n\
    \                std::int64_t** d,\n                std::size_t n,\n         \
    \       std::int64_t zero,\n                std::int64_t inf) {\n            constexpr\
    \ std::size_t block_size =\n                CPLIB_WARSHALL_FLOYD_DENSE_BLOCK_SIZE;\n\
    \            const std::size_t block_count =\n                (n + block_size\
    \ - 1) / block_size;\n            const std::size_t padded_size = block_count\
    \ * block_size;\n            std::int64_t* const matrix = static_cast<std::int64_t*>(\n\
    \                _mm_malloc(padded_size * padded_size * sizeof(std::int64_t),\
    \ 32));\n            if (matrix == nullptr) {\n                return cplib_warshall_floyd_int64_sparse_avx2<check_negative>(\n\
    \                    static_cast<void*>(d), n, zero, inf);\n            }\n\n\
    \            const auto tile = [&](std::size_t bi, std::size_t bj) {\n       \
    \         return matrix + (bi * block_count + bj) *\n                    block_size\
    \ * block_size;\n            };\n\n            for (std::size_t i = 0; i < n;\
    \ ++i) {\n                const std::size_t bi = i / block_size;\n           \
    \     const std::size_t local_i = i % block_size;\n                for (std::size_t\
    \ bj = 0; bj < block_count; ++bj) {\n                    const std::size_t j_begin\
    \ = bj * block_size;\n                    const std::size_t j_size =\n       \
    \                 j_begin + block_size < n ? block_size : n - j_begin;\n     \
    \               std::memcpy(\n                        tile(bi, bj) + local_i *\
    \ block_size,\n                        d[i] + j_begin,\n                     \
    \   j_size * sizeof(std::int64_t));\n                }\n            }\n\n    \
    \        const __m256i inf4 = _mm256_set1_epi64x(inf);\n            bool negative_cycle\
    \ = false;\n            for (std::size_t kb = 0; kb < block_count; ++kb) {\n \
    \               const std::size_t k_begin = kb * block_size;\n               \
    \ const std::size_t k_size =\n                    k_begin + block_size < n ? block_size\
    \ : n - k_begin;\n                std::int64_t* const diagonal = tile(kb, kb);\n\
    \n                for (std::size_t k = 0; k < k_size; ++k) {\n               \
    \     const std::int64_t* const row_k =\n                        diagonal + k\
    \ * block_size;\n                    for (std::size_t i = 0; i < k_size; ++i)\
    \ {\n                        cplib_warshall_floyd_relax_avx2(\n              \
    \              diagonal + i * block_size, row_k,\n                           \
    \ diagonal[i * block_size + k], 0, k_size,\n                            inf4,\
    \ inf, true);\n                    }\n                    for (std::size_t i =\
    \ 0; i < k_size; ++i) {\n                        if (check_negative && diagonal[i\
    \ * block_size + i] < zero) {\n                            negative_cycle = true;\n\
    \                            break;\n                        }\n             \
    \       }\n                    if (negative_cycle) break;\n                }\n\
    \                if (negative_cycle) break;\n\n                for (std::size_t\
    \ jb = 0; jb < block_count; ++jb) {\n                    if (jb == kb) continue;\n\
    \                    const std::size_t j_begin = jb * block_size;\n          \
    \          const std::size_t j_size =\n                        j_begin + block_size\
    \ < n ? block_size : n - j_begin;\n                    std::int64_t* const top\
    \ = tile(kb, jb);\n                    for (std::size_t k = 0; k < k_size; ++k)\
    \ {\n                        const std::int64_t* const row_k = top + k * block_size;\n\
    \                        for (std::size_t i = 0; i < k_size; ++i) {\n        \
    \                    cplib_warshall_floyd_relax_avx2(\n                      \
    \          top + i * block_size, row_k,\n                                diagonal[i\
    \ * block_size + k], 0, j_size,\n                                inf4, inf, true);\n\
    \                        }\n                    }\n                }\n\n     \
    \           for (std::size_t ib = 0; ib < block_count; ++ib) {\n             \
    \       if (ib == kb) continue;\n                    const std::size_t i_begin\
    \ = ib * block_size;\n                    const std::size_t i_size =\n       \
    \                 i_begin + block_size < n ? block_size : n - i_begin;\n     \
    \               std::int64_t* const left = tile(ib, kb);\n                   \
    \ std::size_t i = 0;\n                    for (; i + 16 <= i_size; i += 16) {\n\
    \                        for (std::size_t k = 0; k < k_size; ++k) {\n        \
    \                    const std::int64_t* const row_k =\n                     \
    \           diagonal + k * block_size;\n                            cplib_warshall_floyd_relax4_dense_avx2(\n\
    \                                left + i * block_size,\n                    \
    \            left + (i + 1) * block_size,\n                                left\
    \ + (i + 2) * block_size,\n                                left + (i + 3) * block_size,\n\
    \                                row_k,\n                                left[i\
    \ * block_size + k],\n                                left[(i + 1) * block_size\
    \ + k],\n                                left[(i + 2) * block_size + k],\n   \
    \                             left[(i + 3) * block_size + k],\n              \
    \                  k_size);\n                            cplib_warshall_floyd_relax4_dense_avx2(\n\
    \                                left + (i + 4) * block_size,\n              \
    \                  left + (i + 5) * block_size,\n                            \
    \    left + (i + 6) * block_size,\n                                left + (i +\
    \ 7) * block_size,\n                                row_k,\n                 \
    \               left[(i + 4) * block_size + k],\n                            \
    \    left[(i + 5) * block_size + k],\n                                left[(i\
    \ + 6) * block_size + k],\n                                left[(i + 7) * block_size\
    \ + k],\n                                k_size);\n                          \
    \  cplib_warshall_floyd_relax4_dense_avx2(\n                                left\
    \ + (i + 8) * block_size,\n                                left + (i + 9) * block_size,\n\
    \                                left + (i + 10) * block_size,\n             \
    \                   left + (i + 11) * block_size,\n                          \
    \      row_k,\n                                left[(i + 8) * block_size + k],\n\
    \                                left[(i + 9) * block_size + k],\n           \
    \                     left[(i + 10) * block_size + k],\n                     \
    \           left[(i + 11) * block_size + k],\n                               \
    \ k_size);\n                            cplib_warshall_floyd_relax4_dense_avx2(\n\
    \                                left + (i + 12) * block_size,\n             \
    \                   left + (i + 13) * block_size,\n                          \
    \      left + (i + 14) * block_size,\n                                left + (i\
    \ + 15) * block_size,\n                                row_k,\n              \
    \                  left[(i + 12) * block_size + k],\n                        \
    \        left[(i + 13) * block_size + k],\n                                left[(i\
    \ + 14) * block_size + k],\n                                left[(i + 15) * block_size\
    \ + k],\n                                k_size);\n                        }\n\
    \                    }\n                    for (; i + 4 <= i_size; i += 4) {\n\
    \                        for (std::size_t k = 0; k < k_size; ++k) {\n        \
    \                    const std::int64_t* const row_k =\n                     \
    \           diagonal + k * block_size;\n                            cplib_warshall_floyd_relax4_dense_avx2(\n\
    \                                left + i * block_size,\n                    \
    \            left + (i + 1) * block_size,\n                                left\
    \ + (i + 2) * block_size,\n                                left + (i + 3) * block_size,\n\
    \                                row_k,\n                                left[i\
    \ * block_size + k],\n                                left[(i + 1) * block_size\
    \ + k],\n                                left[(i + 2) * block_size + k],\n   \
    \                             left[(i + 3) * block_size + k],\n              \
    \                  k_size);\n                        }\n                    }\n\
    \                    for (; i < i_size; ++i) {\n                        for (std::size_t\
    \ k = 0; k < k_size; ++k) {\n                            const std::int64_t* const\
    \ row_k =\n                                diagonal + k * block_size;\n      \
    \                      cplib_warshall_floyd_relax_avx2(\n                    \
    \            left + i * block_size, row_k,\n                                left[i\
    \ * block_size + k], 0, k_size,\n                                inf4, inf, true);\n\
    \                        }\n                    }\n                }\n\n     \
    \           for (std::size_t ib = 0; ib < block_count; ++ib) {\n             \
    \       if (ib == kb) continue;\n                    const std::size_t i_begin\
    \ = ib * block_size;\n                    const std::size_t i_size =\n       \
    \                 i_begin + block_size < n ? block_size : n - i_begin;\n     \
    \               const std::int64_t* const left = tile(ib, kb);\n             \
    \       for (std::size_t jb = 0; jb < block_count; ++jb) {\n                 \
    \       if (jb == kb) continue;\n                        const std::size_t j_begin\
    \ = jb * block_size;\n                        const std::size_t j_size =\n   \
    \                         j_begin + block_size < n ? block_size : n - j_begin;\n\
    \                        const std::int64_t* const top = tile(kb, jb);\n     \
    \                   std::int64_t* const output = tile(ib, jb);\n             \
    \           std::size_t i = 0;\n                        for (; i + 16 <= i_size;\
    \ i += 16) {\n                            for (std::size_t k = 0; k < k_size;\
    \ ++k) {\n                                const std::int64_t* const row_k =\n\
    \                                    top + k * block_size;\n                 \
    \               cplib_warshall_floyd_relax4_dense_avx2(\n                    \
    \                output + i * block_size,\n                                  \
    \  output + (i + 1) * block_size,\n                                    output\
    \ + (i + 2) * block_size,\n                                    output + (i + 3)\
    \ * block_size,\n                                    row_k,\n                \
    \                    left[i * block_size + k],\n                             \
    \       left[(i + 1) * block_size + k],\n                                    left[(i\
    \ + 2) * block_size + k],\n                                    left[(i + 3) *\
    \ block_size + k],\n                                    j_size);\n           \
    \                     cplib_warshall_floyd_relax4_dense_avx2(\n              \
    \                      output + (i + 4) * block_size,\n                      \
    \              output + (i + 5) * block_size,\n                              \
    \      output + (i + 6) * block_size,\n                                    output\
    \ + (i + 7) * block_size,\n                                    row_k,\n      \
    \                              left[(i + 4) * block_size + k],\n             \
    \                       left[(i + 5) * block_size + k],\n                    \
    \                left[(i + 6) * block_size + k],\n                           \
    \         left[(i + 7) * block_size + k],\n                                  \
    \  j_size);\n                                cplib_warshall_floyd_relax4_dense_avx2(\n\
    \                                    output + (i + 8) * block_size,\n        \
    \                            output + (i + 9) * block_size,\n                \
    \                    output + (i + 10) * block_size,\n                       \
    \             output + (i + 11) * block_size,\n                              \
    \      row_k,\n                                    left[(i + 8) * block_size +\
    \ k],\n                                    left[(i + 9) * block_size + k],\n \
    \                                   left[(i + 10) * block_size + k],\n       \
    \                             left[(i + 11) * block_size + k],\n             \
    \                       j_size);\n                                cplib_warshall_floyd_relax4_dense_avx2(\n\
    \                                    output + (i + 12) * block_size,\n       \
    \                             output + (i + 13) * block_size,\n              \
    \                      output + (i + 14) * block_size,\n                     \
    \               output + (i + 15) * block_size,\n                            \
    \        row_k,\n                                    left[(i + 12) * block_size\
    \ + k],\n                                    left[(i + 13) * block_size + k],\n\
    \                                    left[(i + 14) * block_size + k],\n      \
    \                              left[(i + 15) * block_size + k],\n            \
    \                        j_size);\n                            }\n           \
    \             }\n                        for (; i + 4 <= i_size; i += 4) {\n \
    \                           for (std::size_t k = 0; k < k_size; ++k) {\n     \
    \                           const std::int64_t* const row_k =\n              \
    \                      top + k * block_size;\n                               \
    \ cplib_warshall_floyd_relax4_dense_avx2(\n                                  \
    \  output + i * block_size,\n                                    output + (i +\
    \ 1) * block_size,\n                                    output + (i + 2) * block_size,\n\
    \                                    output + (i + 3) * block_size,\n        \
    \                            row_k,\n                                    left[i\
    \ * block_size + k],\n                                    left[(i + 1) * block_size\
    \ + k],\n                                    left[(i + 2) * block_size + k],\n\
    \                                    left[(i + 3) * block_size + k],\n       \
    \                             j_size);\n                            }\n      \
    \                  }\n                        for (; i < i_size; ++i) {\n    \
    \                        for (std::size_t k = 0; k < k_size; ++k) {\n        \
    \                        const std::int64_t* const row_k =\n                 \
    \                   top + k * block_size;\n                                cplib_warshall_floyd_relax_avx2(\n\
    \                                    output + i * block_size, row_k,\n       \
    \                             left[i * block_size + k], 0, j_size,\n         \
    \                           inf4, inf, true);\n                            }\n\
    \                        }\n                    }\n                }\n       \
    \     }\n\n            for (std::size_t i = 0; i < n; ++i) {\n               \
    \ const std::size_t bi = i / block_size;\n                const std::size_t local_i\
    \ = i % block_size;\n                for (std::size_t bj = 0; bj < block_count;\
    \ ++bj) {\n                    const std::size_t j_begin = bj * block_size;\n\
    \                    const std::size_t j_size =\n                        j_begin\
    \ + block_size < n ? block_size : n - j_begin;\n                    std::memcpy(\n\
    \                        d[i] + j_begin,\n                        tile(bi, bj)\
    \ + local_i * block_size,\n                        j_size * sizeof(std::int64_t));\n\
    \                }\n            }\n            _mm_free(matrix);\n           \
    \ return negative_cycle;\n        }\n\n        template <bool check_negative =\
    \ true>\n        static bool cplib_warshall_floyd_int64_avx2(\n              \
    \  void* raw_rows,\n                std::size_t n,\n                std::int64_t\
    \ zero,\n                std::int64_t inf) {\n            std::int64_t** d = static_cast<std::int64_t**>(raw_rows);\n\
    \            const __m256i inf4 = _mm256_set1_epi64x(inf);\n            bool dense\
    \ = true;\n            for (std::size_t i = 0; i < n && dense; ++i) {\n      \
    \          dense = cplib_warshall_floyd_all_reachable_avx2(\n                \
    \    d[i], 0, n, inf4, inf);\n            }\n            if (dense) {\n      \
    \          return cplib_warshall_floyd_int64_dense_tiled_avx2<check_negative>(\n\
    \                    d, n, zero, inf);\n            }\n            return cplib_warshall_floyd_int64_sparse_avx2<check_negative>(\n\
    \                raw_rows, n, zero, inf);\n        }\n\n        static inline\
    \ void cplib_warshall_floyd_relax_int32_avx2(\n                std::int32_t* row_i,\n\
    \                const std::int32_t* row_k,\n                std::int32_t dik,\n\
    \                std::size_t begin,\n                std::size_t end,\n      \
    \          __m256i inf8,\n                std::int32_t inf) {\n            const\
    \ __m256i dik8 = _mm256_set1_epi32(dik);\n            std::size_t j = begin;\n\
    \            for (; j + 8 <= end; j += 8) {\n                const __m256i dkj\
    \ = _mm256_loadu_si256(\n                    reinterpret_cast<const __m256i*>(row_k\
    \ + j));\n                const __m256i dij = _mm256_loadu_si256(\n          \
    \          reinterpret_cast<const __m256i*>(row_i + j));\n                const\
    \ __m256i candidate = _mm256_add_epi32(dik8, dkj);\n                const __m256i\
    \ unreachable = _mm256_cmpeq_epi32(dkj, inf8);\n                const __m256i\
    \ minimum = _mm256_min_epi32(dij, candidate);\n                const __m256i updated\
    \ = _mm256_blendv_epi8(\n                    minimum, dij, unreachable);\n   \
    \             _mm256_storeu_si256(\n                    reinterpret_cast<__m256i*>(row_i\
    \ + j), updated);\n            }\n            for (; j < end; ++j) {\n       \
    \         if (row_k[j] != inf) {\n                    const std::int32_t candidate\
    \ = dik + row_k[j];\n                    if (candidate < row_i[j]) row_i[j] =\
    \ candidate;\n                }\n            }\n        }\n\n        template\
    \ <bool check_negative = true>\n        static bool cplib_warshall_floyd_int32_avx2(\n\
    \                void* raw_rows,\n                std::size_t n,\n           \
    \     std::int32_t zero,\n                std::int32_t inf) {\n            std::int32_t**\
    \ d = static_cast<std::int32_t**>(raw_rows);\n            const __m256i inf8 =\
    \ _mm256_set1_epi32(inf);\n            constexpr std::size_t block_size =\n  \
    \              CPLIB_WARSHALL_FLOYD_INT32_BLOCK_SIZE;\n\n            for (std::size_t\
    \ i = 0; i < n; ++i) {\n                if (check_negative && d[i][i] < zero)\
    \ return true;\n            }\n\n            for (std::size_t kk = 0; kk < n;\
    \ kk += block_size) {\n                const std::size_t kend =\n            \
    \        kk + block_size < n ? kk + block_size : n;\n\n                // Phase\
    \ 1: close the diagonal block.\n                for (std::size_t k = kk; k < kend;\
    \ ++k) {\n                    const std::int32_t* const row_k = d[k];\n      \
    \              for (std::size_t i = kk; i < kend; ++i) {\n                   \
    \     const std::int32_t dik = d[i][k];\n                        if (dik != inf)\
    \ cplib_warshall_floyd_relax_int32_avx2(\n                            d[i], row_k,\
    \ dik, kk, kend, inf8, inf);\n                    }\n                    for (std::size_t\
    \ i = kk; i < kend; ++i) {\n                        if (check_negative && d[i][i]\
    \ < zero) return true;\n                    }\n                }\n\n         \
    \       // Phase 2a: update the blocks in the diagonal block row.\n          \
    \      for (std::size_t jj = 0; jj < n; jj += block_size) {\n                \
    \    if (jj == kk) continue;\n                    const std::size_t jend =\n \
    \                       jj + block_size < n ? jj + block_size : n;\n         \
    \           for (std::size_t k = kk; k < kend; ++k) {\n                      \
    \  const std::int32_t* const row_k = d[k];\n                        for (std::size_t\
    \ i = kk; i < kend; ++i) {\n                            const std::int32_t dik\
    \ = d[i][k];\n                            if (dik != inf) cplib_warshall_floyd_relax_int32_avx2(\n\
    \                                d[i], row_k, dik, jj, jend, inf8, inf);\n   \
    \                     }\n                    }\n                }\n\n        \
    \        // Phase 2b: update the blocks in the diagonal block column.\n      \
    \          for (std::size_t ii = 0; ii < n; ii += block_size) {\n            \
    \        if (ii == kk) continue;\n                    const std::size_t iend =\n\
    \                        ii + block_size < n ? ii + block_size : n;\n        \
    \            for (std::size_t k = kk; k < kend; ++k) {\n                     \
    \   const std::int32_t* const row_k = d[k];\n                        for (std::size_t\
    \ i = ii; i < iend; ++i) {\n                            const std::int32_t dik\
    \ = d[i][k];\n                            if (dik != inf) cplib_warshall_floyd_relax_int32_avx2(\n\
    \                                d[i], row_k, dik, kk, kend, inf8, inf);\n   \
    \                     }\n                    }\n                }\n\n        \
    \        // Phase 3: update all remaining cache-resident tiles.\n            \
    \    for (std::size_t ii = 0; ii < n; ii += block_size) {\n                  \
    \  if (ii == kk) continue;\n                    const std::size_t iend =\n   \
    \                     ii + block_size < n ? ii + block_size : n;\n           \
    \         for (std::size_t jj = 0; jj < n; jj += block_size) {\n             \
    \           if (jj == kk) continue;\n                        const std::size_t\
    \ jend =\n                            jj + block_size < n ? jj + block_size :\
    \ n;\n                        for (std::size_t k = kk; k < kend; ++k) {\n    \
    \                        const std::int32_t* const row_k = d[k];\n           \
    \                 for (std::size_t i = ii; i < iend; ++i) {\n                \
    \                const std::int32_t dik = d[i][k];\n                         \
    \       if (dik != inf) cplib_warshall_floyd_relax_int32_avx2(\n             \
    \                       d[i], row_k, dik, jj, jend, inf8, inf);\n            \
    \                }\n                        }\n                    }\n       \
    \         }\n\n                for (std::size_t i = 0; i < n; ++i) {\n       \
    \             if (check_negative && d[i][i] < zero) return true;\n           \
    \     }\n            }\n            return false;\n        }\n\n        #pragma\
    \ GCC pop_options\n\n        #pragma GCC push_options\n        #pragma GCC target(\"\
    avx512f\")\n        #pragma GCC optimize(\"O3\")\n\n        static inline void\
    \ cplib_warshall_floyd_relax_avx512(\n                std::int64_t* row_i,\n \
    \               const std::int64_t* row_k,\n                std::int64_t dik,\n\
    \                std::size_t begin,\n                std::size_t end,\n      \
    \          std::int64_t inf) {\n            // \u5230\u9054\u4E0D\u80FD\u306A\u9802\
    \u70B9\u3092\u9664\u5916\u3057\u30668\u8981\u7D20\u305A\u3064\u7DE9\u548C\u3059\
    \u308B\u3002O(end - begin)\u3002\n            const __m512i dikv = _mm512_set1_epi64(dik);\n\
    \            const __m512i infv = _mm512_set1_epi64(inf);\n            std::size_t\
    \ j = begin;\n            for (; j + 8 <= end; j += 8) {\n                const\
    \ __m512i dkj = _mm512_loadu_si512(row_k + j);\n                const __m512i\
    \ dij = _mm512_loadu_si512(row_i + j);\n                const __m512i candidate\
    \ = _mm512_add_epi64(dikv, dkj);\n                const __mmask8 take = _mm512_cmpneq_epi64_mask(dkj,\
    \ infv) &\n                    _mm512_cmplt_epi64_mask(candidate, dij);\n    \
    \            _mm512_mask_storeu_epi64(row_i + j, take, candidate);\n         \
    \   }\n            for (; j < end; ++j) {\n                if (row_k[j] != inf)\
    \ {\n                    const std::int64_t candidate = dik + row_k[j];\n    \
    \                if (candidate < row_i[j]) row_i[j] = candidate;\n           \
    \     }\n            }\n        }\n\n        static inline void cplib_warshall_floyd_relax_avx512(\n\
    \                std::int32_t* row_i,\n                const std::int32_t* row_k,\n\
    \                std::int32_t dik,\n                std::size_t begin,\n     \
    \           std::size_t end,\n                std::int32_t inf) {\n          \
    \  // \u5230\u9054\u4E0D\u80FD\u306A\u9802\u70B9\u3092\u9664\u5916\u3057\u3066\
    16\u8981\u7D20\u305A\u3064\u7DE9\u548C\u3059\u308B\u3002O(end - begin)\u3002\n\
    \            const __m512i dikv = _mm512_set1_epi32(dik);\n            const __m512i\
    \ infv = _mm512_set1_epi32(inf);\n            std::size_t j = begin;\n       \
    \     for (; j + 16 <= end; j += 16) {\n                const __m512i dkj = _mm512_loadu_si512(row_k\
    \ + j);\n                const __m512i dij = _mm512_loadu_si512(row_i + j);\n\
    \                const __m512i candidate = _mm512_add_epi32(dikv, dkj);\n    \
    \            const __mmask16 take = _mm512_cmpneq_epi32_mask(dkj, infv) &\n  \
    \                  _mm512_cmplt_epi32_mask(candidate, dij);\n                _mm512_mask_storeu_epi32(row_i\
    \ + j, take, candidate);\n            }\n            for (; j < end; ++j) {\n\
    \                if (row_k[j] != inf) {\n                    const std::int32_t\
    \ candidate = dik + row_k[j];\n                    if (candidate < row_i[j]) row_i[j]\
    \ = candidate;\n                }\n            }\n        }\n\n        template\
    \ <bool all_reachable>\n        static inline void cplib_warshall_floyd_product_int64_avx512(\n\
    \                std::int64_t** out, std::int64_t** left, std::int64_t** top,\
    \ std::size_t ib, std::size_t ie,\n                std::size_t jb, std::size_t\
    \ je,\n                std::size_t kb, std::size_t ke, std::int64_t inf) {\n \
    \           // \u72EC\u7ACB\u306A\u30BF\u30A4\u30EB\u306E4\u884C16\u5217\u3092\
    \u30EC\u30B8\u30B9\u30BF\u306B\u4FDD\u6301\u3057\u3066\u66F4\u65B0\u3059\u308B\
    \u3002O((ie-ib)(je-jb)(ke-kb))\u3002\n            if (ib >= ie || jb >= je ||\
    \ kb >= ke) return;\n            const __m512i infv = _mm512_set1_epi64(inf);\n\
    \            std::size_t i = ib;\n            for (; i + 4 <= ie; i += 4) {\n\
    \                std::size_t j = jb;\n                for (; j + 16 <= je; j +=\
    \ 16) {\n                    __m512i v00 = _mm512_loadu_si512(out[i + 0] + j +\
    \ 0);\n                    __m512i v01 = _mm512_loadu_si512(out[i + 0] + j + 8);\n\
    \                    __m512i v10 = _mm512_loadu_si512(out[i + 1] + j + 0);\n \
    \                   __m512i v11 = _mm512_loadu_si512(out[i + 1] + j + 8);\n  \
    \                  __m512i v20 = _mm512_loadu_si512(out[i + 2] + j + 0);\n   \
    \                 __m512i v21 = _mm512_loadu_si512(out[i + 2] + j + 8);\n    \
    \                __m512i v30 = _mm512_loadu_si512(out[i + 3] + j + 0);\n     \
    \               __m512i v31 = _mm512_loadu_si512(out[i + 3] + j + 8);\n      \
    \              for (std::size_t k = kb; k < ke; ++k) {\n                     \
    \   const __m512i b0 = _mm512_loadu_si512(top[k] + j + 0);\n                 \
    \       const __mmask8 m0 = all_reachable ? 0xff : _mm512_cmpneq_epi64_mask(b0,\
    \ infv);\n                        const __m512i b1 = _mm512_loadu_si512(top[k]\
    \ + j + 8);\n                        const __mmask8 m1 = all_reachable ? 0xff\
    \ : _mm512_cmpneq_epi64_mask(b1, infv);\n                        if (all_reachable\
    \ || left[i + 0][k] != inf) {\n                            const __m512i a = _mm512_set1_epi64(left[i\
    \ + 0][k]);\n                            const __m512i t0 = _mm512_add_epi64(a,\
    \ b0);\n                            v00 = all_reachable ? _mm512_min_epi64(v00,\
    \ t0)\n                                : _mm512_mask_min_epi64(v00, m0, v00, t0);\n\
    \                            const __m512i t1 = _mm512_add_epi64(a, b1);\n   \
    \                         v01 = all_reachable ? _mm512_min_epi64(v01, t1)\n  \
    \                              : _mm512_mask_min_epi64(v01, m1, v01, t1);\n  \
    \                      }\n                        if (all_reachable || left[i\
    \ + 1][k] != inf) {\n                            const __m512i a = _mm512_set1_epi64(left[i\
    \ + 1][k]);\n                            const __m512i t0 = _mm512_add_epi64(a,\
    \ b0);\n                            v10 = all_reachable ? _mm512_min_epi64(v10,\
    \ t0)\n                                : _mm512_mask_min_epi64(v10, m0, v10, t0);\n\
    \                            const __m512i t1 = _mm512_add_epi64(a, b1);\n   \
    \                         v11 = all_reachable ? _mm512_min_epi64(v11, t1)\n  \
    \                              : _mm512_mask_min_epi64(v11, m1, v11, t1);\n  \
    \                      }\n                        if (all_reachable || left[i\
    \ + 2][k] != inf) {\n                            const __m512i a = _mm512_set1_epi64(left[i\
    \ + 2][k]);\n                            const __m512i t0 = _mm512_add_epi64(a,\
    \ b0);\n                            v20 = all_reachable ? _mm512_min_epi64(v20,\
    \ t0)\n                                : _mm512_mask_min_epi64(v20, m0, v20, t0);\n\
    \                            const __m512i t1 = _mm512_add_epi64(a, b1);\n   \
    \                         v21 = all_reachable ? _mm512_min_epi64(v21, t1)\n  \
    \                              : _mm512_mask_min_epi64(v21, m1, v21, t1);\n  \
    \                      }\n                        if (all_reachable || left[i\
    \ + 3][k] != inf) {\n                            const __m512i a = _mm512_set1_epi64(left[i\
    \ + 3][k]);\n                            const __m512i t0 = _mm512_add_epi64(a,\
    \ b0);\n                            v30 = all_reachable ? _mm512_min_epi64(v30,\
    \ t0)\n                                : _mm512_mask_min_epi64(v30, m0, v30, t0);\n\
    \                            const __m512i t1 = _mm512_add_epi64(a, b1);\n   \
    \                         v31 = all_reachable ? _mm512_min_epi64(v31, t1)\n  \
    \                              : _mm512_mask_min_epi64(v31, m1, v31, t1);\n  \
    \                      }\n                    }\n                    _mm512_storeu_si512(out[i\
    \ + 0] + j + 0, v00);\n                    _mm512_storeu_si512(out[i + 0] + j\
    \ + 8, v01);\n                    _mm512_storeu_si512(out[i + 1] + j + 0, v10);\n\
    \                    _mm512_storeu_si512(out[i + 1] + j + 8, v11);\n         \
    \           _mm512_storeu_si512(out[i + 2] + j + 0, v20);\n                  \
    \  _mm512_storeu_si512(out[i + 2] + j + 8, v21);\n                    _mm512_storeu_si512(out[i\
    \ + 3] + j + 0, v30);\n                    _mm512_storeu_si512(out[i + 3] + j\
    \ + 8, v31);\n                }\n                for (std::size_t r = 0; r < 4;\
    \ ++r)\n                    for (std::size_t k = kb; k < ke; ++k)\n          \
    \              if (left[i + r][k] != inf)\n                            cplib_warshall_floyd_relax_avx512(\n\
    \                                out[i + r], top[k], left[i + r][k], j, je, inf);\n\
    \            }\n            for (; i < ie; ++i)\n                for (std::size_t\
    \ k = kb; k < ke; ++k)\n                    if (left[i][k] != inf)\n         \
    \               cplib_warshall_floyd_relax_avx512(out[i], top[k], left[i][k],\
    \ jb, je, inf);\n        }\n\n        static inline void cplib_warshall_floyd_product_dense_int64_avx512(\n\
    \                std::int64_t** out, std::int64_t** left, std::int64_t** top,\
    \ std::size_t ib, std::size_t ie,\n                std::size_t jb, std::size_t\
    \ je,\n                std::size_t kb, std::size_t ke, std::int64_t inf) {\n \
    \           // \u5168\u3066\u6709\u9650\u306E\u72EC\u7ACB\u30BF\u30A4\u30EB\u3092\
    4\u884C32\u5217\u305A\u3064\u4FDD\u6301\u3057\u3066\u66F4\u65B0\u3059\u308B\u3002\
    O((ie-ib)(je-jb)(ke-kb))\u3002\n            std::size_t i = ib;\n            for\
    \ (; i + 4 <= ie; i += 4) {\n                std::size_t j = jb;\n           \
    \     for (; j + 32 <= je; j += 32) {\n                    __m512i v00 = _mm512_loadu_si512(out[i\
    \ + 0] + j + 0);\n                    __m512i v01 = _mm512_loadu_si512(out[i +\
    \ 0] + j + 8);\n                    __m512i v02 = _mm512_loadu_si512(out[i + 0]\
    \ + j + 16);\n                    __m512i v03 = _mm512_loadu_si512(out[i + 0]\
    \ + j + 24);\n                    __m512i v10 = _mm512_loadu_si512(out[i + 1]\
    \ + j + 0);\n                    __m512i v11 = _mm512_loadu_si512(out[i + 1] +\
    \ j + 8);\n                    __m512i v12 = _mm512_loadu_si512(out[i + 1] + j\
    \ + 16);\n                    __m512i v13 = _mm512_loadu_si512(out[i + 1] + j\
    \ + 24);\n                    __m512i v20 = _mm512_loadu_si512(out[i + 2] + j\
    \ + 0);\n                    __m512i v21 = _mm512_loadu_si512(out[i + 2] + j +\
    \ 8);\n                    __m512i v22 = _mm512_loadu_si512(out[i + 2] + j + 16);\n\
    \                    __m512i v23 = _mm512_loadu_si512(out[i + 2] + j + 24);\n\
    \                    __m512i v30 = _mm512_loadu_si512(out[i + 3] + j + 0);\n \
    \                   __m512i v31 = _mm512_loadu_si512(out[i + 3] + j + 8);\n  \
    \                  __m512i v32 = _mm512_loadu_si512(out[i + 3] + j + 16);\n  \
    \                  __m512i v33 = _mm512_loadu_si512(out[i + 3] + j + 24);\n  \
    \                  for (std::size_t k = kb; k < ke; ++k) {\n                 \
    \       const __m512i b0 = _mm512_loadu_si512(top[k] + j + 0);\n             \
    \           const __m512i b1 = _mm512_loadu_si512(top[k] + j + 8);\n         \
    \               const __m512i b2 = _mm512_loadu_si512(top[k] + j + 16);\n    \
    \                    const __m512i b3 = _mm512_loadu_si512(top[k] + j + 24);\n\
    \                        {\n                            const __m512i a = _mm512_set1_epi64(left[i\
    \ + 0][k]);\n                            v00 = _mm512_min_epi64(v00, _mm512_add_epi64(a,\
    \ b0));\n                            v01 = _mm512_min_epi64(v01, _mm512_add_epi64(a,\
    \ b1));\n                            v02 = _mm512_min_epi64(v02, _mm512_add_epi64(a,\
    \ b2));\n                            v03 = _mm512_min_epi64(v03, _mm512_add_epi64(a,\
    \ b3));\n                        }\n                        {\n              \
    \              const __m512i a = _mm512_set1_epi64(left[i + 1][k]);\n        \
    \                    v10 = _mm512_min_epi64(v10, _mm512_add_epi64(a, b0));\n \
    \                           v11 = _mm512_min_epi64(v11, _mm512_add_epi64(a, b1));\n\
    \                            v12 = _mm512_min_epi64(v12, _mm512_add_epi64(a, b2));\n\
    \                            v13 = _mm512_min_epi64(v13, _mm512_add_epi64(a, b3));\n\
    \                        }\n                        {\n                      \
    \      const __m512i a = _mm512_set1_epi64(left[i + 2][k]);\n                \
    \            v20 = _mm512_min_epi64(v20, _mm512_add_epi64(a, b0));\n         \
    \                   v21 = _mm512_min_epi64(v21, _mm512_add_epi64(a, b1));\n  \
    \                          v22 = _mm512_min_epi64(v22, _mm512_add_epi64(a, b2));\n\
    \                            v23 = _mm512_min_epi64(v23, _mm512_add_epi64(a, b3));\n\
    \                        }\n                        {\n                      \
    \      const __m512i a = _mm512_set1_epi64(left[i + 3][k]);\n                \
    \            v30 = _mm512_min_epi64(v30, _mm512_add_epi64(a, b0));\n         \
    \                   v31 = _mm512_min_epi64(v31, _mm512_add_epi64(a, b1));\n  \
    \                          v32 = _mm512_min_epi64(v32, _mm512_add_epi64(a, b2));\n\
    \                            v33 = _mm512_min_epi64(v33, _mm512_add_epi64(a, b3));\n\
    \                        }\n                    }\n                    _mm512_storeu_si512(out[i\
    \ + 0] + j + 0, v00);\n                    _mm512_storeu_si512(out[i + 0] + j\
    \ + 8, v01);\n                    _mm512_storeu_si512(out[i + 0] + j + 16, v02);\n\
    \                    _mm512_storeu_si512(out[i + 0] + j + 24, v03);\n        \
    \            _mm512_storeu_si512(out[i + 1] + j + 0, v10);\n                 \
    \   _mm512_storeu_si512(out[i + 1] + j + 8, v11);\n                    _mm512_storeu_si512(out[i\
    \ + 1] + j + 16, v12);\n                    _mm512_storeu_si512(out[i + 1] + j\
    \ + 24, v13);\n                    _mm512_storeu_si512(out[i + 2] + j + 0, v20);\n\
    \                    _mm512_storeu_si512(out[i + 2] + j + 8, v21);\n         \
    \           _mm512_storeu_si512(out[i + 2] + j + 16, v22);\n                 \
    \   _mm512_storeu_si512(out[i + 2] + j + 24, v23);\n                    _mm512_storeu_si512(out[i\
    \ + 3] + j + 0, v30);\n                    _mm512_storeu_si512(out[i + 3] + j\
    \ + 8, v31);\n                    _mm512_storeu_si512(out[i + 3] + j + 16, v32);\n\
    \                    _mm512_storeu_si512(out[i + 3] + j + 24, v33);\n        \
    \        }\n                cplib_warshall_floyd_product_int64_avx512<true>(\n\
    \                    out, left, top, i, i + 4, j, je, kb, ke, inf);\n        \
    \    }\n            cplib_warshall_floyd_product_int64_avx512<true>(\n       \
    \         out, left, top, i, ie, jb, je, kb, ke, inf);\n        }\n\n        static\
    \ inline void cplib_warshall_floyd_product_avx512(\n                std::int64_t**\
    \ out, std::int64_t** left, std::int64_t** top, std::size_t ib, std::size_t ie,\n\
    \                std::size_t jb, std::size_t je,\n                std::size_t\
    \ kb, std::size_t ke, std::int64_t inf,\n                bool all_reachable) {\n\
    \            // \u5171\u6709\u3057\u305F\u5230\u9054\u5224\u5B9A\u3067\u72EC\u7ACB\
    \u30BF\u30A4\u30EB\u306E\u66F4\u65B0\u65B9\u6CD5\u3092\u9078\u3076\u3002O((ie-ib)(je-jb)(ke-kb))\u3002\
    \n            if (all_reachable)\n                cplib_warshall_floyd_product_dense_int64_avx512(out,\
    \ left, top, ib, ie, jb, je, kb, ke, inf);\n            else\n               \
    \ cplib_warshall_floyd_product_int64_avx512<false>(out, left, top, ib, ie, jb,\
    \ je, kb, ke, inf);\n        }\n\n        static inline void cplib_warshall_floyd_product_avx512(\n\
    \                std::int64_t** d, std::size_t ib, std::size_t ie,\n         \
    \       std::size_t jb, std::size_t je,\n                std::size_t kb, std::size_t\
    \ ke, std::int64_t inf, bool all_reachable) {\n            // \u884C\u914D\u7F6E\
    \u306E\u884C\u5217\u304B\u3089\u72EC\u7ACB\u30BF\u30A4\u30EB\u3092\u66F4\u65B0\
    \u3059\u308B\u3002O((ie-ib)(je-jb)(ke-kb))\u3002\n            cplib_warshall_floyd_product_avx512(d,\
    \ d, d, ib, ie, jb, je, kb, ke, inf, all_reachable);\n        }\n\n        template\
    \ <bool all_reachable>\n        static inline void cplib_warshall_floyd_product_int32_avx512(\n\
    \                std::int32_t** d, std::size_t ib, std::size_t ie,\n         \
    \       std::size_t jb, std::size_t je,\n                std::size_t kb, std::size_t\
    \ ke, std::int32_t inf) {\n            // \u72EC\u7ACB\u306A\u30BF\u30A4\u30EB\
    \u306E4\u884C32\u5217\u3092\u30EC\u30B8\u30B9\u30BF\u306B\u4FDD\u6301\u3057\u3066\
    \u66F4\u65B0\u3059\u308B\u3002O((ie-ib)(je-jb)(ke-kb))\u3002\n            const\
    \ __m512i infv = _mm512_set1_epi32(inf);\n            std::size_t i = ib;\n  \
    \          for (; i + 4 <= ie; i += 4) {\n                std::size_t j = jb;\n\
    \                for (; j + 32 <= je; j += 32) {\n                    __m512i\
    \ v00 = _mm512_loadu_si512(d[i + 0] + j + 0);\n                    __m512i v01\
    \ = _mm512_loadu_si512(d[i + 0] + j + 16);\n                    __m512i v10 =\
    \ _mm512_loadu_si512(d[i + 1] + j + 0);\n                    __m512i v11 = _mm512_loadu_si512(d[i\
    \ + 1] + j + 16);\n                    __m512i v20 = _mm512_loadu_si512(d[i +\
    \ 2] + j + 0);\n                    __m512i v21 = _mm512_loadu_si512(d[i + 2]\
    \ + j + 16);\n                    __m512i v30 = _mm512_loadu_si512(d[i + 3] +\
    \ j + 0);\n                    __m512i v31 = _mm512_loadu_si512(d[i + 3] + j +\
    \ 16);\n                    for (std::size_t k = kb; k < ke; ++k) {\n        \
    \                const __m512i b0 = _mm512_loadu_si512(d[k] + j + 0);\n      \
    \                  const __mmask16 m0 = all_reachable ? 0xffff : _mm512_cmpneq_epi32_mask(b0,\
    \ infv);\n                        const __m512i b1 = _mm512_loadu_si512(d[k] +\
    \ j + 16);\n                        const __mmask16 m1 = all_reachable ? 0xffff\
    \ : _mm512_cmpneq_epi32_mask(b1, infv);\n                        if (all_reachable\
    \ || d[i + 0][k] != inf) {\n                            const __m512i a = _mm512_set1_epi32(d[i\
    \ + 0][k]);\n                            const __m512i t0 = _mm512_add_epi32(a,\
    \ b0);\n                            v00 = all_reachable ? _mm512_min_epi32(v00,\
    \ t0)\n                                : _mm512_mask_min_epi32(v00, m0, v00, t0);\n\
    \                            const __m512i t1 = _mm512_add_epi32(a, b1);\n   \
    \                         v01 = all_reachable ? _mm512_min_epi32(v01, t1)\n  \
    \                              : _mm512_mask_min_epi32(v01, m1, v01, t1);\n  \
    \                      }\n                        if (all_reachable || d[i + 1][k]\
    \ != inf) {\n                            const __m512i a = _mm512_set1_epi32(d[i\
    \ + 1][k]);\n                            const __m512i t0 = _mm512_add_epi32(a,\
    \ b0);\n                            v10 = all_reachable ? _mm512_min_epi32(v10,\
    \ t0)\n                                : _mm512_mask_min_epi32(v10, m0, v10, t0);\n\
    \                            const __m512i t1 = _mm512_add_epi32(a, b1);\n   \
    \                         v11 = all_reachable ? _mm512_min_epi32(v11, t1)\n  \
    \                              : _mm512_mask_min_epi32(v11, m1, v11, t1);\n  \
    \                      }\n                        if (all_reachable || d[i + 2][k]\
    \ != inf) {\n                            const __m512i a = _mm512_set1_epi32(d[i\
    \ + 2][k]);\n                            const __m512i t0 = _mm512_add_epi32(a,\
    \ b0);\n                            v20 = all_reachable ? _mm512_min_epi32(v20,\
    \ t0)\n                                : _mm512_mask_min_epi32(v20, m0, v20, t0);\n\
    \                            const __m512i t1 = _mm512_add_epi32(a, b1);\n   \
    \                         v21 = all_reachable ? _mm512_min_epi32(v21, t1)\n  \
    \                              : _mm512_mask_min_epi32(v21, m1, v21, t1);\n  \
    \                      }\n                        if (all_reachable || d[i + 3][k]\
    \ != inf) {\n                            const __m512i a = _mm512_set1_epi32(d[i\
    \ + 3][k]);\n                            const __m512i t0 = _mm512_add_epi32(a,\
    \ b0);\n                            v30 = all_reachable ? _mm512_min_epi32(v30,\
    \ t0)\n                                : _mm512_mask_min_epi32(v30, m0, v30, t0);\n\
    \                            const __m512i t1 = _mm512_add_epi32(a, b1);\n   \
    \                         v31 = all_reachable ? _mm512_min_epi32(v31, t1)\n  \
    \                              : _mm512_mask_min_epi32(v31, m1, v31, t1);\n  \
    \                      }\n                    }\n                    _mm512_storeu_si512(d[i\
    \ + 0] + j + 0, v00);\n                    _mm512_storeu_si512(d[i + 0] + j +\
    \ 16, v01);\n                    _mm512_storeu_si512(d[i + 1] + j + 0, v10);\n\
    \                    _mm512_storeu_si512(d[i + 1] + j + 16, v11);\n          \
    \          _mm512_storeu_si512(d[i + 2] + j + 0, v20);\n                    _mm512_storeu_si512(d[i\
    \ + 2] + j + 16, v21);\n                    _mm512_storeu_si512(d[i + 3] + j +\
    \ 0, v30);\n                    _mm512_storeu_si512(d[i + 3] + j + 16, v31);\n\
    \                }\n                for (std::size_t r = 0; r < 4; ++r)\n    \
    \                for (std::size_t k = kb; k < ke; ++k)\n                     \
    \   if (d[i + r][k] != inf)\n                            cplib_warshall_floyd_relax_avx512(\n\
    \                                d[i + r], d[k], d[i + r][k], j, je, inf);\n \
    \           }\n            for (; i < ie; ++i)\n                for (std::size_t\
    \ k = kb; k < ke; ++k)\n                    if (d[i][k] != inf)\n            \
    \            cplib_warshall_floyd_relax_avx512(d[i], d[k], d[i][k], jb, je, inf);\n\
    \        }\n\n        static inline void cplib_warshall_floyd_product_avx512(\n\
    \                std::int32_t** d, std::size_t ib, std::size_t ie,\n         \
    \       std::size_t jb, std::size_t je,\n                std::size_t kb, std::size_t\
    \ ke, std::int32_t inf, bool) {\n            // \u5165\u529B\u30BF\u30A4\u30EB\
    \u304C\u5168\u3066\u5230\u9054\u53EF\u80FD\u306A\u3089\u3001\u5185\u5074\u306E\
    \u5230\u9054\u5224\u5B9A\u3092\u7701\u304F\u3002O((ie-ib)(je-jb)(ke-kb))\u3002\
    \n            bool reachable = true;\n            const __m512i infv = _mm512_set1_epi32(inf);\n\
    \            for (std::size_t i = ib; i < ie && reachable; ++i)\n            \
    \    for (std::size_t k = kb; k < ke; ++k)\n                    if (d[i][k] ==\
    \ inf) { reachable = false; break; }\n            for (std::size_t k = kb; k <\
    \ ke && reachable; ++k) {\n                std::size_t j = jb;\n             \
    \   for (; j + 16 <= je; j += 16)\n                    if (_mm512_cmpneq_epi32_mask(_mm512_loadu_si512(d[k]\
    \ + j), infv) != 0xffff) {\n                        reachable = false;\n     \
    \                   break;\n                    }\n                for (; j <\
    \ je && reachable; ++j)\n                    if (d[k][j] == inf) reachable = false;\n\
    \            }\n            if (reachable)\n                cplib_warshall_floyd_product_int32_avx512<true>(d,\
    \ ib, ie, jb, je, kb, ke, inf);\n            else\n                cplib_warshall_floyd_product_int32_avx512<false>(d,\
    \ ib, ie, jb, je, kb, ke, inf);\n        }\n\n        static bool cplib_warshall_floyd_finite_tile_avx512(\n\
    \                std::int64_t** d, std::size_t ib, std::size_t ie,\n         \
    \       std::size_t jb, std::size_t je, std::int64_t inf) {\n            // \u30BF\
    \u30A4\u30EB\u5185\u306E\u5168\u8981\u7D20\u304C\u6709\u9650\u304B\u5224\u5B9A\
    \u3059\u308B\u3002O((ie-ib)(je-jb))\u3002\n            const __m512i infv = _mm512_set1_epi64(inf);\n\
    \            for (std::size_t i = ib; i < ie; ++i) {\n                std::size_t\
    \ j = jb;\n                for (; j + 8 <= je; j += 8)\n                    if\
    \ (_mm512_cmpeq_epi64_mask(_mm512_loadu_si512(d[i] + j), infv)) return false;\n\
    \                for (; j < je; ++j)\n                    if (d[i][j] == inf)\
    \ return false;\n            }\n            return true;\n        }\n\n      \
    \  static inline void cplib_warshall_floyd_prepare_reachable_avx512(\n       \
    \         std::int64_t** d, std::size_t n, std::size_t kk, std::size_t kend,\n\
    \                std::size_t block_size, std::int64_t inf,\n                unsigned\
    \ char* left, unsigned char* top) {\n            // Phase 2\u5F8C\u306E\u5165\u529B\
    \u30BF\u30A4\u30EB\u3092\u8ABF\u3079\u3001Phase 3\u3067\u5224\u5B9A\u3092\u5171\
    \u6709\u3059\u308B\u3002O(n(kend-kk))\u3002\n            for (std::size_t b =\
    \ 0; b < n; b += block_size) {\n                if (b == kk) continue;\n     \
    \           const std::size_t end = b + block_size < n ? b + block_size : n;\n\
    \                left[b / block_size] = cplib_warshall_floyd_finite_tile_avx512(d,\
    \ b, end, kk, kend, inf);\n                top[b / block_size] = cplib_warshall_floyd_finite_tile_avx512(d,\
    \ kk, kend, b, end, inf);\n            }\n        }\n\n        static inline void\
    \ cplib_warshall_floyd_prepare_reachable_avx512(\n                std::int32_t**,\
    \ std::size_t, std::size_t, std::size_t,\n                std::size_t, std::int32_t,\
    \ unsigned char*, unsigned char*) {\n            // int32\u3067\u306F\u66F4\u65B0\
    \u5148\u3054\u3068\u306E\u65E2\u5B58\u306E\u5230\u9054\u5224\u5B9A\u3092\u4F7F\
    \u3046\u3002O(1)\u3002\n        }\n\n        template <typename T, std::size_t\
    \ block_size, bool check_negative = true>\n        static bool cplib_warshall_floyd_blocked_avx512(\n\
    \                void* raw_rows, std::size_t n, T zero, T inf) {\n           \
    \ // \u30D6\u30ED\u30C3\u30AF\u5206\u5272\u3057\u305F\u5168\u70B9\u5BFE\u6700\u77ED\
    \u8DEF\u3092\u6C42\u3081\u308B\u3002check_negative\u3067\u8CA0\u9589\u8DEF\u691C\
    \u67FB\u3092\u5207\u308A\u66FF\u3048\u308B\u3002O(n^3)\u3002\n            T**\
    \ d = static_cast<T**>(raw_rows);\n            const std::size_t cache_size =\
    \ sizeof(T) == 8 ? (n + block_size - 1) / block_size : 0;\n            std::vector<unsigned\
    \ char> left_reachable(cache_size), top_reachable(cache_size);\n            for\
    \ (std::size_t i = 0; i < n; ++i) {\n                if (check_negative && d[i][i]\
    \ < zero) return true;\n            }\n            for (std::size_t kk = 0; kk\
    \ < n; kk += block_size) {\n                const std::size_t kend =\n       \
    \             kk + block_size < n ? kk + block_size : n;\n                const\
    \ auto relax_tile = [&](std::size_t ib, std::size_t ie,\n                    \
    \                        std::size_t jb, std::size_t je,\n                   \
    \                         bool diagonal) {\n                    // \u6307\u5B9A\
    \u3057\u305F\u30BF\u30A4\u30EB\u3092\u66F4\u65B0\u3057\u3001\u5BFE\u89D2\u30BF\
    \u30A4\u30EB\u3067\u306F\u5404\u6BB5\u968E\u3067\u8CA0\u9589\u8DEF\u3092\u8ABF\
    \u3079\u308B\u3002\n                    for (std::size_t k = kk; k < kend; ++k)\
    \ {\n                        for (std::size_t i = ib; i < ie; ++i) {\n       \
    \                     const T dik = d[i][k];\n                            if (dik\
    \ != inf) cplib_warshall_floyd_relax_avx512(\n                               \
    \ d[i], d[k], dik, jb, je, inf);\n                        }\n                \
    \        if (check_negative && diagonal) {\n                            for (std::size_t\
    \ i = ib; i < ie; ++i) {\n                                if (check_negative &&\
    \ d[i][i] < zero) return true;\n                            }\n              \
    \          }\n                    }\n                    return false;\n     \
    \           };\n                if (relax_tile(kk, kend, kk, kend, true)) return\
    \ true;\n                for (std::size_t jj = 0; jj < n; jj += block_size) {\n\
    \                    if (jj == kk) continue;\n                    const std::size_t\
    \ jend =\n                        jj + block_size < n ? jj + block_size : n;\n\
    \                    relax_tile(kk, kend, jj, jend, false);\n                }\n\
    \                for (std::size_t ii = 0; ii < n; ii += block_size) {\n      \
    \              if (ii == kk) continue;\n                    const std::size_t\
    \ iend =\n                        ii + block_size < n ? ii + block_size : n;\n\
    \                    relax_tile(ii, iend, kk, kend, false);\n                }\n\
    \                cplib_warshall_floyd_prepare_reachable_avx512(\n            \
    \        d, n, kk, kend, block_size, inf, left_reachable.data(), top_reachable.data());\n\
    \                for (std::size_t ii = 0; ii < n; ii += block_size) {\n      \
    \              if (ii == kk) continue;\n                    const std::size_t\
    \ iend =\n                        ii + block_size < n ? ii + block_size : n;\n\
    \                    for (std::size_t jj = 0; jj < n; jj += block_size) {\n  \
    \                      if (jj == kk) continue;\n                        const\
    \ std::size_t jend =\n                            jj + block_size < n ? jj + block_size\
    \ : n;\n                        cplib_warshall_floyd_product_avx512(\n       \
    \                     d, ii, iend, jj, jend, kk, kend, inf,\n                \
    \            sizeof(T) == 8 && left_reachable[ii / block_size] && top_reachable[jj\
    \ / block_size]);\n                    }\n                }\n                for\
    \ (std::size_t i = 0; i < n; ++i) {\n                    if (check_negative &&\
    \ d[i][i] < zero) return true;\n                }\n            }\n           \
    \ return false;\n        }\n\n        template <int B>\n        static inline\
    \ void cplib_warshall_floyd_product_fixed_avx512(\n                std::int64_t*\
    \ out, const std::int64_t* left, const std::int64_t* top) {\n            // \u5168\
    \u8981\u7D20\u304C\u6709\u9650\u306E\u72EC\u7ACB\u3057\u305FB\xD7B\u30BF\u30A4\
    \u30EB\u30924\u884C\u30FB4\u4E2D\u7D99\u70B9\u305A\u3064\u66F4\u65B0\u3059\u308B\
    \u3002O(B^3)\u3002\n            static_assert(B % 8 == 0, \"tile width must be\
    \ a multiple of 8\");\n            for (int k = 0; k < B; k += 4) {\n        \
    \        for (int i = 0; i < B; i += 4) {\n                    const __m512i a00\
    \ = _mm512_set1_epi64(left[(i + 0) * B + k + 0]);\n                    const __m512i\
    \ a01 = _mm512_set1_epi64(left[(i + 0) * B + k + 1]);\n                    const\
    \ __m512i a02 = _mm512_set1_epi64(left[(i + 0) * B + k + 2]);\n              \
    \      const __m512i a03 = _mm512_set1_epi64(left[(i + 0) * B + k + 3]);\n   \
    \                 const __m512i a10 = _mm512_set1_epi64(left[(i + 1) * B + k +\
    \ 0]);\n                    const __m512i a11 = _mm512_set1_epi64(left[(i + 1)\
    \ * B + k + 1]);\n                    const __m512i a12 = _mm512_set1_epi64(left[(i\
    \ + 1) * B + k + 2]);\n                    const __m512i a13 = _mm512_set1_epi64(left[(i\
    \ + 1) * B + k + 3]);\n                    const __m512i a20 = _mm512_set1_epi64(left[(i\
    \ + 2) * B + k + 0]);\n                    const __m512i a21 = _mm512_set1_epi64(left[(i\
    \ + 2) * B + k + 1]);\n                    const __m512i a22 = _mm512_set1_epi64(left[(i\
    \ + 2) * B + k + 2]);\n                    const __m512i a23 = _mm512_set1_epi64(left[(i\
    \ + 2) * B + k + 3]);\n                    const __m512i a30 = _mm512_set1_epi64(left[(i\
    \ + 3) * B + k + 0]);\n                    const __m512i a31 = _mm512_set1_epi64(left[(i\
    \ + 3) * B + k + 1]);\n                    const __m512i a32 = _mm512_set1_epi64(left[(i\
    \ + 3) * B + k + 2]);\n                    const __m512i a33 = _mm512_set1_epi64(left[(i\
    \ + 3) * B + k + 3]);\n                    for (int j = 0; j < B; j += 8) {\n\
    \                        const __m512i b0 = _mm512_load_si512(top + (k + 0) *\
    \ B + j);\n                        const __m512i b1 = _mm512_load_si512(top +\
    \ (k + 1) * B + j);\n                        const __m512i b2 = _mm512_load_si512(top\
    \ + (k + 2) * B + j);\n                        const __m512i b3 = _mm512_load_si512(top\
    \ + (k + 3) * B + j);\n                        {\n                           \
    \ const __m512i candidate = _mm512_min_epi64(\n                              \
    \  _mm512_min_epi64(_mm512_add_epi64(a00, b0), _mm512_add_epi64(a01, b1)),\n \
    \                               _mm512_min_epi64(_mm512_add_epi64(a02, b2), _mm512_add_epi64(a03,\
    \ b3)));\n                            const __m512i old = _mm512_load_si512(out\
    \ + (i + 0) * B + j);\n                            _mm512_mask_store_epi64(out\
    \ + (i + 0) * B + j,\n                                _mm512_cmplt_epi64_mask(candidate,\
    \ old), candidate);\n                        }\n                        {\n  \
    \                          const __m512i candidate = _mm512_min_epi64(\n     \
    \                           _mm512_min_epi64(_mm512_add_epi64(a10, b0), _mm512_add_epi64(a11,\
    \ b1)),\n                                _mm512_min_epi64(_mm512_add_epi64(a12,\
    \ b2), _mm512_add_epi64(a13, b3)));\n                            const __m512i\
    \ old = _mm512_load_si512(out + (i + 1) * B + j);\n                          \
    \  _mm512_mask_store_epi64(out + (i + 1) * B + j,\n                          \
    \      _mm512_cmplt_epi64_mask(candidate, old), candidate);\n                \
    \        }\n                        {\n                            const __m512i\
    \ candidate = _mm512_min_epi64(\n                                _mm512_min_epi64(_mm512_add_epi64(a20,\
    \ b0), _mm512_add_epi64(a21, b1)),\n                                _mm512_min_epi64(_mm512_add_epi64(a22,\
    \ b2), _mm512_add_epi64(a23, b3)));\n                            const __m512i\
    \ old = _mm512_load_si512(out + (i + 2) * B + j);\n                          \
    \  _mm512_mask_store_epi64(out + (i + 2) * B + j,\n                          \
    \      _mm512_cmplt_epi64_mask(candidate, old), candidate);\n                \
    \        }\n                        {\n                            const __m512i\
    \ candidate = _mm512_min_epi64(\n                                _mm512_min_epi64(_mm512_add_epi64(a30,\
    \ b0), _mm512_add_epi64(a31, b1)),\n                                _mm512_min_epi64(_mm512_add_epi64(a32,\
    \ b2), _mm512_add_epi64(a33, b3)));\n                            const __m512i\
    \ old = _mm512_load_si512(out + (i + 3) * B + j);\n                          \
    \  _mm512_mask_store_epi64(out + (i + 3) * B + j,\n                          \
    \      _mm512_cmplt_epi64_mask(candidate, old), candidate);\n                \
    \        }\n                    }\n                }\n            }\n        }\n\
    \n        template <bool check_negative>\n        static bool cplib_warshall_floyd_packed_int64_avx512(\n\
    \                void* raw_rows, std::size_t n, std::int64_t zero, std::int64_t\
    \ inf) {\n            // 64\xD764\u30BF\u30A4\u30EB\u3078\u8A70\u3081\u3001\u518D\
    \u5E30\u9806\u306B\u5168\u70B9\u5BFE\u6700\u77ED\u8DEF\u3092\u6C42\u3081\u308B\
    \u3002\u6642\u9593O(n^3)\u3001\u8FFD\u52A0\u9818\u57DFO(n^2)\u3002\n         \
    \   constexpr std::size_t B = 64;\n            std::int64_t** d = static_cast<std::int64_t**>(raw_rows);\n\
    \            if (n < 512) return cplib_warshall_floyd_blocked_avx512<\n      \
    \          std::int64_t, CPLIB_WARSHALL_FLOYD_AVX512_BLOCK_SIZE, check_negative>(raw_rows,\
    \ n, zero, inf);\n            if (check_negative) for (std::size_t i = 0; i <\
    \ n; ++i) if (d[i][i] < zero) return true;\n            const std::size_t count\
    \ = (n + B - 1) / B;\n            const std::size_t cells = count * count * B\
    \ * B;\n            std::unique_ptr<void, decltype(&std::free)> allocation(\n\
    \                std::malloc(cells * sizeof(std::int64_t) + 63), &std::free);\n\
    \            if (!allocation) return cplib_warshall_floyd_blocked_avx512<\n  \
    \              std::int64_t, CPLIB_WARSHALL_FLOYD_AVX512_BLOCK_SIZE, check_negative>(raw_rows,\
    \ n, zero, inf);\n            auto* data = reinterpret_cast<std::int64_t*>(\n\
    \                (reinterpret_cast<std::uintptr_t>(allocation.get()) + 63) & ~std::uintptr_t(63));\n\
    \            std::fill(data, data + cells, inf);\n            std::vector<std::int64_t*>\
    \ rows(count * count * B);\n            std::vector<unsigned char> finite(count\
    \ * count);\n            const auto size = [&](std::size_t b) {\n            \
    \    // \u672B\u5C3E\u30BF\u30A4\u30EB\u306E\u6709\u52B9\u306A\u884C\u6570\u30FB\
    \u5217\u6570\u3092\u8FD4\u3059\u3002O(1)\u3002\n                return n - b *\
    \ B < B ? n - b * B : B;\n            };\n            const auto tile = [&](std::size_t\
    \ i, std::size_t j) {\n                // \u6307\u5B9A\u30BF\u30A4\u30EB\u306E\
    \u884C\u30DD\u30A4\u30F3\u30BF\u914D\u5217\u3092\u8FD4\u3059\u3002O(1)\u3002\n\
    \                return rows.data() + (i * count + j) * B;\n            };\n \
    \           for (std::size_t i = 0; i < count; ++i) for (std::size_t j = 0; j\
    \ < count; ++j) {\n                auto r = tile(i, j);\n                for (std::size_t\
    \ k = 0; k < B; ++k) r[k] = data + ((i * count + j) * B + k) * B;\n          \
    \      for (std::size_t k = 0; k < size(i); ++k)\n                    std::memcpy(r[k],\
    \ d[i * B + k] + j * B, size(j) * sizeof(std::int64_t));\n                finite[i\
    \ * count + j] = cplib_warshall_floyd_finite_tile_avx512(r, 0, size(i), 0, size(j),\
    \ inf);\n            }\n            const auto update = [&](std::size_t i, std::size_t\
    \ j, std::size_t k) {\n                // \u5165\u529B\u3068\u51FA\u529B\u306E\
    \u4F9D\u5B58\u306B\u5FDC\u3058\u3066\u30BF\u30A4\u30EB\u3092\u66F4\u65B0\u3057\
    \u3001\u5BFE\u89D2\u3067\u306F\u8CA0\u9589\u8DEF\u3082\u8ABF\u3079\u308B\u3002\
    O(B^3)\u3002\n                auto out = tile(i, j), left = tile(i, k), top =\
    \ tile(k, j);\n                const auto is = size(i), js = size(j), ks = size(k);\n\
    \                if (i != k && j != k) {\n                    const bool reachable\
    \ = finite[i * count + k] && finite[k * count + j];\n                    if (reachable\
    \ && is == B && js == B && ks == B)\n                        cplib_warshall_floyd_product_fixed_avx512<B>(out[0],\
    \ left[0], top[0]);\n                    else cplib_warshall_floyd_product_avx512(\n\
    \                        out, left, top, 0, is, 0, js, 0, ks, inf, reachable);\n\
    \                } else {\n                    for (std::size_t z = 0; z < ks;\
    \ ++z) {\n                        for (std::size_t y = 0; y < is; ++y) if (left[y][z]\
    \ != inf)\n                            cplib_warshall_floyd_relax_avx512(out[y],\
    \ top[z], left[y][z], 0, js, inf);\n                        if (check_negative\
    \ && i == j)\n                            for (std::size_t y = 0; y < is; ++y)\
    \ if (out[y][y] < zero) return true;\n                    }\n                }\n\
    \                if (check_negative && i == j)\n                    for (std::size_t\
    \ y = 0; y < is; ++y) if (out[y][y] < zero) return true;\n                if (!finite[i\
    \ * count + j])\n                    finite[i * count + j] = cplib_warshall_floyd_finite_tile_avx512(out,\
    \ 0, is, 0, js, inf);\n                return false;\n            };\n       \
    \     const auto visit = [&](auto&& self, std::size_t i, std::size_t j,\n    \
    \                               std::size_t k, std::size_t span) -> bool {\n \
    \               // \u4E2D\u7D99\u70B9\u306E\u524D\u534A\u3092\u9589\u3058\u3066\
    \u304B\u3089\u5F8C\u534A\u3092\u51E6\u7406\u3059\u308B\u3002\u5168\u4F53\u3067\
    O(n^3)\u3002\n                if (i >= count || j >= count || k >= count) return\
    \ false;\n                if (span == 1) return update(i, j, k);\n           \
    \     const auto h = span / 2;\n                return self(self, i, j, k, h)\
    \ || self(self, i, j + h, k, h) ||\n                    self(self, i + h, j, k,\
    \ h) || self(self, i + h, j + h, k, h) ||\n                    self(self, i +\
    \ h, j + h, k + h, h) || self(self, i + h, j, k + h, h) ||\n                 \
    \   self(self, i, j + h, k + h, h) || self(self, i, j, k + h, h);\n          \
    \  };\n            std::size_t span = 1;\n            while (span < count) span\
    \ *= 2;\n            const bool negative = visit(visit, 0, 0, 0, span);\n    \
    \        for (std::size_t i = 0; i < count; ++i) for (std::size_t j = 0; j < count;\
    \ ++j)\n                for (std::size_t k = 0; k < size(i); ++k)\n          \
    \          std::memcpy(d[i * B + k] + j * B, tile(i, j)[k], size(j) * sizeof(std::int64_t));\n\
    \            return negative;\n        }\n\n        #pragma GCC pop_options\n\n\
    \        extern \"C\" bool cplib_warshall_floyd_int64_avx(\n                void*\
    \ raw_rows, std::size_t n,\n                std::int64_t zero, std::int64_t inf)\
    \ {\n            // CPU\u30FBOS\u304CAVX-512\u306B\u5BFE\u5FDC\u3057\u3066\u3044\
    \u306A\u3051\u308C\u3070AVX2\u7248\u3092\u4F7F\u7528\u3059\u308B\u3002O(n^3)\u3002\
    \n            if (__builtin_cpu_supports(\"avx512f\")) {\n                return\
    \ cplib_warshall_floyd_packed_int64_avx512<true>(raw_rows, n, zero, inf);\n  \
    \          }\n            return cplib_warshall_floyd_int64_avx2(raw_rows, n,\
    \ zero, inf);\n        }\n\n        extern \"C\" bool cplib_warshall_floyd_int32_avx(\n\
    \                void* raw_rows, std::size_t n,\n                std::int32_t\
    \ zero, std::int32_t inf) {\n            // CPU\u30FBOS\u304CAVX-512\u306B\u5BFE\
    \u5FDC\u3057\u3066\u3044\u306A\u3051\u308C\u3070AVX2\u7248\u3092\u4F7F\u7528\u3059\
    \u308B\u3002O(n^3)\u3002\n            if (__builtin_cpu_supports(\"avx512f\"))\
    \ {\n                return cplib_warshall_floyd_blocked_avx512<\n           \
    \         std::int32_t, CPLIB_WARSHALL_FLOYD_INT32_BLOCK_SIZE>(\n            \
    \            raw_rows, n, zero, inf);\n            }\n            return cplib_warshall_floyd_int32_avx2(raw_rows,\
    \ n, zero, inf);\n        }\n\n        extern \"C\" void cplib_warshall_floyd_nonnegative_int64_avx(\n\
    \                void* raw_rows, std::size_t n,\n                std::int64_t\
    \ zero, std::int64_t inf) {\n            // \u975E\u8CA0\u8FBA\u306E\u5168\u70B9\
    \u5BFE\u6700\u77ED\u8DEF\u3092\u8CA0\u9589\u8DEF\u691C\u67FB\u306A\u3057\u3067\
    \u6C42\u3081\u308B\u3002AVX-512\u975E\u5BFE\u5FDC\u6642\u306FAVX2\u3002O(n^3)\u3002\
    \n            if (__builtin_cpu_supports(\"avx512f\")) {\n                cplib_warshall_floyd_packed_int64_avx512<false>(raw_rows,\
    \ n, zero, inf);\n            } else {\n                cplib_warshall_floyd_int64_avx2<false>(raw_rows,\
    \ n, zero, inf);\n            }\n        }\n\n        extern \"C\" void cplib_warshall_floyd_nonnegative_int32_avx(\n\
    \                void* raw_rows, std::size_t n,\n                std::int32_t\
    \ zero, std::int32_t inf) {\n            // \u975E\u8CA0\u8FBA\u306E\u5168\u70B9\
    \u5BFE\u6700\u77ED\u8DEF\u3092\u8CA0\u9589\u8DEF\u691C\u67FB\u306A\u3057\u3067\
    \u6C42\u3081\u308B\u3002AVX-512\u975E\u5BFE\u5FDC\u6642\u306FAVX2\u3002O(n^3)\u3002\
    \n            if (__builtin_cpu_supports(\"avx512f\")) {\n                cplib_warshall_floyd_blocked_avx512<\n\
    \                    std::int32_t, CPLIB_WARSHALL_FLOYD_INT32_BLOCK_SIZE, false>(\n\
    \                        raw_rows, n, zero, inf);\n            } else {\n    \
    \            cplib_warshall_floyd_int32_avx2<false>(raw_rows, n, zero, inf);\n\
    \            }\n        }\n\n        #endif\n        \"\"\".}\n\n        proc\
    \ warshallFloydInt64Avx(\n            rows: pointer,\n            n: csize_t,\n\
    \            zero, inf: int\n        ): bool {.importc: \"cplib_warshall_floyd_int64_avx\"\
    .}\n\n        proc warshallFloydInt32Avx(\n            rows: pointer,\n      \
    \      n: csize_t,\n            zero, inf: int32\n        ): bool {.importc: \"\
    cplib_warshall_floyd_int32_avx\".}\n\n        proc warshallFloydNonnegativeInt64Avx(\n\
    \            rows: pointer, n: csize_t, zero, inf: int\n        ) {.importc: \"\
    cplib_warshall_floyd_nonnegative_int64_avx\".}\n            ## \u975E\u8CA0\u8FBA\
    \u306E\u8DDD\u96E2\u884C\u5217\u3092SIMD\u3067\u66F4\u65B0\u3059\u308B\u3002O(V^3)\u3002\
    \n\n        proc warshallFloydNonnegativeInt32Avx(\n            rows: pointer,\
    \ n: csize_t, zero, inf: int32\n        ) {.importc: \"cplib_warshall_floyd_nonnegative_int32_avx\"\
    .}\n            ## \u975E\u8CA0\u8FBA\u306E\u8DDD\u96E2\u884C\u5217\u3092SIMD\u3067\
    \u66F4\u65B0\u3059\u308B\u3002O(V^3)\u3002\n\n    proc warshall_floyd_inplace_run[T](d:\
    \ var seq[seq[T]], zero, inf: T): bool =\n        ## \u6B63\u65B9\u96A3\u63A5\u884C\
    \u5217\u3092\u6700\u77ED\u8DDD\u96E2\u3067\u4E0A\u66F8\u304D\u3057\u3001\u8CA0\
    \u9589\u8DEF\u306E\u6709\u7121\u3092\u8FD4\u3059\u3002O(V^3)\u3002\u8CA0\u9589\
    \u8DEF\u691C\u51FA\u6642\u306F\u9014\u4E2D\u306E\u884C\u5217\u3092\u6B8B\u3059\
    \u3002\n        let n = d.len\n        for i in 0..<n:\n            assert d[i].len\
    \ == n, \"\u96A3\u63A5\u884C\u5217\u306F\u6B63\u65B9\u884C\u5217\u3067\u3042\u308B\
    \u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        for i in 0..<n:\n      \
    \      d[i][i] = min(d[i][i], zero)\n        for i in 0..<n:\n            if d[i][i]\
    \ < zero:\n                return true\n        when defined(cpp) and sizeof(int)\
    \ == 8 and (T is int or T is int32):\n            if n == 0:\n               \
    \ return false\n            var rows = newSeq[ptr T](n)\n            for i in\
    \ 0..<n:\n                rows[i] = addr d[i][0]\n            when T is int:\n\
    \                let negativeCycle = warshallFloydInt64Avx(\n                \
    \    cast[pointer](addr rows[0]), n.csize_t, zero, inf)\n            else:\n \
    \               let negativeCycle = warshallFloydInt32Avx(\n                 \
    \   cast[pointer](addr rows[0]), n.csize_t, zero, inf)\n            return negativeCycle\n\
    \        else:\n            for k in 0..<n:\n                for i in 0..<n:\n\
    \                    for j in 0..<n:\n                        if d[i][k] != inf\
    \ and d[k][j] != inf:\n                            d[i][j] = min(d[i][j], d[i][k]\
    \ + d[k][j])\n                for i in 0..<n:\n                    if d[i][i]\
    \ < zero:\n                        return true\n            return false\n\n \
    \   proc warshall_floyd_inplace_impl[T](d: var seq[seq[T]], zero, inf: T) =\n\
    \        ## \u8DDD\u96E2\u884C\u5217\u3092\u5B8C\u6210\u3055\u305B\u3001\u8CA0\
    \u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\u7D44\u306F-inf\u306B\u3059\u308B\
    \u3002O(V^3)\u3002\n        if warshall_floyd_inplace_run(d, zero, inf):\n   \
    \         warshall_floyd_negative_finish(d, zero, inf, warshall_floyd_inplace_run[T])\n\
    \n    proc warshall_floyd_impl[T](g: WeightedGraph[T] or UnWeightedGraph, zero,\
    \ inf: T): seq[seq[T]] =\n        ## \u5168\u70B9\u5BFE\u6700\u77ED\u8DEF\u3092\
    \u8FD4\u3059\u3002\u5230\u9054\u4E0D\u80FD\u306Finf\u3001\u8CA0\u9589\u8DEF\u3092\
    \u7D4C\u7531\u3067\u304D\u308B\u7D44\u306F-inf\u3002O(V^3)\u3002\n        result\
    \ = newSeqWith(g.len, newSeqWith(g.len, inf))\n        for i in 0..<g.len:\n \
    \           result[i][i] = zero\n            for (j, cost) in g.to_and_cost(i):\n\
    \                result[i][j] = min(result[i][j], cost)\n        warshall_floyd_inplace_impl(result,\
    \ zero, inf)\n\n    proc warshall_floyd*(g: DynamicGraph[int] or StaticGraph[int]\
    \ or UnWeightedGraph, zero: int = 0, inf: int = INF64): seq[seq[int]] =\n    \
    \    ## \u5168\u70B9\u5BFE\u6700\u77ED\u8DEF\u3092\u8FD4\u3059\u3002\u5230\u9054\
    \u4E0D\u80FD\u306Finf\u3001\u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\
    \u7D44\u306F-inf\u3002O(V^3)\u3002\n        return warshall_floyd_impl(g, zero,\
    \ inf)\n\n    proc warshall_floyd*(g: DynamicGraph[int32] or StaticGraph[int32],\
    \ zero: int32 = 0.int32, inf: int32 = INF32): seq[seq[int32]] =\n        ## \u5168\
    \u70B9\u5BFE\u6700\u77ED\u8DEF\u3092\u8FD4\u3059\u3002\u5230\u9054\u4E0D\u80FD\
    \u306Finf\u3001\u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\u7D44\u306F\
    -inf\u3002O(V^3)\u3002\n        return warshall_floyd_impl(g, zero, inf)\n\n \
    \   proc warshall_floyd*(g: DynamicGraph[float] or StaticGraph[float], zero: float\
    \ = 0.0, inf: float = 1e100): seq[seq[float]] =\n        ## \u5168\u70B9\u5BFE\
    \u6700\u77ED\u8DEF\u3092\u8FD4\u3059\u3002\u5230\u9054\u4E0D\u80FD\u306Finf\u3001\
    \u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\u7D44\u306F-inf\u3002O(V^3)\u3002\
    \n        return warshall_floyd_impl(g, zero, inf)\n\n    proc warshall_floyd*(g:\
    \ DynamicGraph[float32] or StaticGraph[float32], zero: float32 = 0.0'f32, inf:\
    \ float32 = 1e30'f32): seq[seq[float32]] =\n        ## \u5168\u70B9\u5BFE\u6700\
    \u77ED\u8DEF\u3092\u8FD4\u3059\u3002\u5230\u9054\u4E0D\u80FD\u306Finf\u3001\u8CA0\
    \u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\u7D44\u306F-inf\u3002O(V^3)\u3002\
    \n        return warshall_floyd_impl(g, zero, inf)\n\n    proc warshall_floyd*[T](g:\
    \ WeightedGraph[T] or UnWeightedGraph, zero, inf: T): seq[seq[T]] =\n        ##\
    \ \u5168\u70B9\u5BFE\u6700\u77ED\u8DEF\u3092\u8FD4\u3059\u3002\u5230\u9054\u4E0D\
    \u80FD\u306Finf\u3001\u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\u7D44\
    \u306F-inf\u3002O(V^3)\u3002\n        return warshall_floyd_impl(g, zero, inf)\n\
    \n    proc warshall_floyd_matrix_impl[T](a: seq[seq[T]], zero, inf: T): seq[seq[T]]\
    \ =\n        ## \u6B63\u65B9\u96A3\u63A5\u884C\u5217\u304B\u3089\u5168\u70B9\u5BFE\
    \u6700\u77ED\u8DEF\u3092\u6C42\u3081\u308B\u3002\u6642\u9593O(V^3)\u3001\u8FFD\
    \u52A0\u9818\u57DFO(V^2)\u3002\u5165\u529B\u306F\u5909\u66F4\u3057\u306A\u3044\
    \u3002\n        var d = newSeqWith(a.len, newSeqWith(a.len, inf))\n        for\
    \ i in 0..<a.len:\n            assert a[i].len == a.len, \"\u96A3\u63A5\u884C\u5217\
    \u306F\u6B63\u65B9\u884C\u5217\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059\"\n            for j in 0..<a.len:\n                d[i][j] = a[i][j]\n\
    \        warshall_floyd_inplace_impl(d, zero, inf)\n        return d\n\n    proc\
    \ warshall_floyd*(a: seq[seq[int]], zero: int = 0, inf: int = INF64): seq[seq[int]]\
    \ =\n        ## \u96A3\u63A5\u884C\u5217\u304B\u3089\u5168\u70B9\u5BFE\u6700\u77ED\
    \u8DEF\u3092O(V^3)\u3067\u8FD4\u3059\u3002\u5230\u9054\u4E0D\u80FD\u306Finf\u3001\
    \u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\u7D44\u306F-inf\u3002\u5165\
    \u529B\u306F\u5909\u66F4\u3057\u306A\u3044\u3002\n        return warshall_floyd_matrix_impl(a,\
    \ zero, inf)\n\n    proc warshall_floyd*(a: seq[seq[int32]], zero: int32 = 0.int32,\
    \ inf: int32 = INF32): seq[seq[int32]] =\n        ## \u96A3\u63A5\u884C\u5217\u304B\
    \u3089\u5168\u70B9\u5BFE\u6700\u77ED\u8DEF\u3092O(V^3)\u3067\u8FD4\u3059\u3002\
    \u5230\u9054\u4E0D\u80FD\u306Finf\u3001\u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\
    \u304D\u308B\u7D44\u306F-inf\u3002\u5165\u529B\u306F\u5909\u66F4\u3057\u306A\u3044\
    \u3002\n        return warshall_floyd_matrix_impl(a, zero, inf)\n\n    proc warshall_floyd*(a:\
    \ seq[seq[float]], zero: float = 0.0, inf: float = 1e100): seq[seq[float]] =\n\
    \        ## \u96A3\u63A5\u884C\u5217\u304B\u3089\u5168\u70B9\u5BFE\u6700\u77ED\
    \u8DEF\u3092O(V^3)\u3067\u8FD4\u3059\u3002\u5230\u9054\u4E0D\u80FD\u306Finf\u3001\
    \u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\u7D44\u306F-inf\u3002\u5165\
    \u529B\u306F\u5909\u66F4\u3057\u306A\u3044\u3002\n        return warshall_floyd_matrix_impl(a,\
    \ zero, inf)\n\n    proc warshall_floyd*(a: seq[seq[float32]], zero: float32 =\
    \ 0.0'f32, inf: float32 = 1e30'f32): seq[seq[float32]] =\n        ## \u96A3\u63A5\
    \u884C\u5217\u304B\u3089\u5168\u70B9\u5BFE\u6700\u77ED\u8DEF\u3092O(V^3)\u3067\
    \u8FD4\u3059\u3002\u5230\u9054\u4E0D\u80FD\u306Finf\u3001\u8CA0\u9589\u8DEF\u3092\
    \u7D4C\u7531\u3067\u304D\u308B\u7D44\u306F-inf\u3002\u5165\u529B\u306F\u5909\u66F4\
    \u3057\u306A\u3044\u3002\n        return warshall_floyd_matrix_impl(a, zero, inf)\n\
    \n    proc warshall_floyd*[T](a: seq[seq[T]], zero, inf: T): seq[seq[T]] =\n \
    \       ## \u96A3\u63A5\u884C\u5217\u304B\u3089\u5168\u70B9\u5BFE\u6700\u77ED\u8DEF\
    \u3092O(V^3)\u3067\u8FD4\u3059\u3002\u5230\u9054\u4E0D\u80FD\u306Finf\u3001\u8CA0\
    \u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\u7D44\u306F-inf\u3002\u5165\u529B\
    \u306F\u5909\u66F4\u3057\u306A\u3044\u3002\n        return warshall_floyd_matrix_impl(a,\
    \ zero, inf)\n\n    proc warshall_floyd_nonnegative_run[T](d: var seq[seq[T]],\
    \ zero, inf: T) =\n        ## \u975E\u8CA0\u8FBA\u3092\u524D\u63D0\u306B\u3001\
    \u8CA0\u9589\u8DEF\u691C\u67FB\u306A\u3057\u3067\u8DDD\u96E2\u884C\u5217\u3092\
    \u66F4\u65B0\u3059\u308B\u3002O(V^3)\u3002\n        when defined(cpp) and sizeof(int)\
    \ == 8 and (T is int or T is int32):\n            if d.len == 0: return\n    \
    \        var rows = newSeq[ptr T](d.len)\n            for i in 0..<d.len:\n  \
    \              rows[i] = addr d[i][0]\n            when T is int:\n          \
    \      warshallFloydNonnegativeInt64Avx(\n                    cast[pointer](addr\
    \ rows[0]), d.len.csize_t, zero, inf)\n            else:\n                warshallFloydNonnegativeInt32Avx(\n\
    \                    cast[pointer](addr rows[0]), d.len.csize_t, zero, inf)\n\
    \        else:\n            for k in 0..<d.len:\n                for i in 0..<d.len:\n\
    \                    if d[i][k] != inf:\n                        for j in 0..<d.len:\n\
    \                            if d[k][j] != inf:\n                            \
    \    d[i][j] = min(d[i][j], d[i][k] + d[k][j])\n\n    proc warshall_floyd_nonnegative_impl[T](g:\
    \ WeightedGraph[T] or UnWeightedGraph, zero, inf: T): seq[seq[T]] =\n        ##\
    \ \u975E\u8CA0\u8FBA\u306E\u30B0\u30E9\u30D5\u304B\u3089\u8DDD\u96E2\u884C\u5217\
    \u3092\u6C42\u3081\u308B\u3002\u6642\u9593O(V^3)\u3001\u8FFD\u52A0\u9818\u57DF\
    O(V^2)\u3002\n        result = newSeqWith(g.len, newSeqWith(g.len, inf))\n   \
    \     for i in 0..<g.len:\n            result[i][i] = zero\n            for (j,\
    \ cost) in g.to_and_cost(i):\n                result[i][j] = min(result[i][j],\
    \ cost)\n        warshall_floyd_nonnegative_run(result, zero, inf)\n\n    proc\
    \ warshall_floyd_nonnegative_inplace_impl[T](d: var seq[seq[T]], zero, inf: T)\
    \ =\n        ## \u8CA0\u9589\u8DEF\u304C\u306A\u3044\u6B63\u65B9\u96A3\u63A5\u884C\
    \u5217\u3092\u6700\u77ED\u8DDD\u96E2\u3067\u4E0A\u66F8\u304D\u3059\u308B\u3002\
    O(V^3)\u3002\u8CA0\u8FBA\u3082\u8A31\u5BB9\u3057\u3001\u8CA0\u9589\u8DEF\u691C\
    \u67FB\u306F\u884C\u308F\u306A\u3044\u3002\n        for i in 0..<d.len:\n    \
    \        assert d[i].len == d.len, \"\u96A3\u63A5\u884C\u5217\u306F\u6B63\u65B9\
    \u884C\u5217\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n \
    \       for i in 0..<d.len:\n            d[i][i] = zero\n        warshall_floyd_nonnegative_run(d,\
    \ zero, inf)\n\n    proc warshall_floyd_nonnegative_impl[T](a: seq[seq[T]], zero,\
    \ inf: T): seq[seq[T]] =\n        ## \u975E\u8CA0\u8FBA\u306E\u6B63\u65B9\u96A3\
    \u63A5\u884C\u5217\u304B\u3089\u8DDD\u96E2\u884C\u5217\u3092\u6C42\u3081\u308B\
    \u3002\u6642\u9593O(V^3)\u3001\u8FFD\u52A0\u9818\u57DFO(V^2)\u3002\u5165\u529B\
    \u306F\u5909\u66F4\u3057\u306A\u3044\u3002\n        result = newSeqWith(a.len,\
    \ newSeqWith(a.len, inf))\n        for i in 0..<a.len:\n            assert a[i].len\
    \ == a.len, \"\u96A3\u63A5\u884C\u5217\u306F\u6B63\u65B9\u884C\u5217\u3067\u3042\
    \u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n            for j in 0..<a.len:\n\
    \                result[i][j] = a[i][j]\n        warshall_floyd_nonnegative_inplace_impl(result,\
    \ zero, inf)\n\n    proc warshall_floyd_nonnegative*(g: DynamicGraph[int] or StaticGraph[int]\
    \ or UnWeightedGraph or seq[seq[int]], zero: int = 0, inf: int = INF64): seq[seq[int]]\
    \ =\n        ## \u975E\u8CA0\u8FBA\u306E\u5168\u70B9\u5BFE\u6700\u77ED\u8DEFd\u3092\
    O(V^3)\u3067\u8FD4\u3059\u3002\u8FBA\u306A\u3057\u306Finf\u3001\u5BFE\u89D2\u306F\
    zero\u3002\u5165\u529B\u306F\u5909\u66F4\u3057\u306A\u3044\u3002\n        return\
    \ warshall_floyd_nonnegative_impl(g, zero, inf)\n\n    proc warshall_floyd_nonnegative*(g:\
    \ DynamicGraph[int32] or StaticGraph[int32] or seq[seq[int32]], zero: int32 =\
    \ 0.int32, inf: int32 = INF32): seq[seq[int32]] =\n        ## \u975E\u8CA0\u8FBA\
    \u306E\u5168\u70B9\u5BFE\u6700\u77ED\u8DEFd\u3092O(V^3)\u3067\u8FD4\u3059\u3002\
    \u8FBA\u306A\u3057\u306Finf\u3001\u5BFE\u89D2\u306Fzero\u3002\u5165\u529B\u306F\
    \u5909\u66F4\u3057\u306A\u3044\u3002\n        return warshall_floyd_nonnegative_impl(g,\
    \ zero, inf)\n\n    proc warshall_floyd_nonnegative*(g: DynamicGraph[float] or\
    \ StaticGraph[float] or seq[seq[float]], zero: float = 0.0, inf: float = 1e100):\
    \ seq[seq[float]] =\n        ## \u975E\u8CA0\u8FBA\u306E\u5168\u70B9\u5BFE\u6700\
    \u77ED\u8DEFd\u3092O(V^3)\u3067\u8FD4\u3059\u3002\u8FBA\u306A\u3057\u306Finf\u3001\
    \u5BFE\u89D2\u306Fzero\u3002\u5165\u529B\u306F\u5909\u66F4\u3057\u306A\u3044\u3002\
    \n        return warshall_floyd_nonnegative_impl(g, zero, inf)\n\n    proc warshall_floyd_nonnegative*(g:\
    \ DynamicGraph[float32] or StaticGraph[float32] or seq[seq[float32]], zero: float32\
    \ = 0.0'f32, inf: float32 = 1e30'f32): seq[seq[float32]] =\n        ## \u975E\u8CA0\
    \u8FBA\u306E\u5168\u70B9\u5BFE\u6700\u77ED\u8DEFd\u3092O(V^3)\u3067\u8FD4\u3059\
    \u3002\u8FBA\u306A\u3057\u306Finf\u3001\u5BFE\u89D2\u306Fzero\u3002\u5165\u529B\
    \u306F\u5909\u66F4\u3057\u306A\u3044\u3002\n        return warshall_floyd_nonnegative_impl(g,\
    \ zero, inf)\n\n    proc warshall_floyd_nonnegative*[T](g: WeightedGraph[T] or\
    \ UnWeightedGraph or seq[seq[T]], zero, inf: T): seq[seq[T]] =\n        ## \u975E\
    \u8CA0\u8FBA\u306E\u5168\u70B9\u5BFE\u6700\u77ED\u8DEFd\u3092O(V^3)\u3067\u8FD4\
    \u3059\u3002\u8FBA\u306A\u3057\u306Finf\u3001\u5BFE\u89D2\u306Fzero\u3002\u5165\
    \u529B\u306F\u5909\u66F4\u3057\u306A\u3044\u3002\n        return warshall_floyd_nonnegative_impl(g,\
    \ zero, inf)\n\n    proc warshall_floyd_inplace*(d: var seq[seq[int]], zero: int\
    \ = 0, inf: int = INF64) =\n        ## \u96A3\u63A5\u884C\u5217\u3092O(V^3)\u3067\
    \u6700\u77ED\u8DDD\u96E2\u306B\u4E0A\u66F8\u304D\u3059\u308B\u3002\u5230\u9054\
    \u4E0D\u80FD\u306Finf\u3001\u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\
    \u7D44\u306F-inf\u3002\n        warshall_floyd_inplace_impl(d, zero, inf)\n\n\
    \    proc warshall_floyd_inplace*(d: var seq[seq[int32]], zero: int32 = 0.int32,\
    \ inf: int32 = INF32) =\n        ## \u96A3\u63A5\u884C\u5217\u3092O(V^3)\u3067\
    \u6700\u77ED\u8DDD\u96E2\u306B\u4E0A\u66F8\u304D\u3059\u308B\u3002\u5230\u9054\
    \u4E0D\u80FD\u306Finf\u3001\u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\
    \u7D44\u306F-inf\u3002\n        warshall_floyd_inplace_impl(d, zero, inf)\n\n\
    \    proc warshall_floyd_inplace*(d: var seq[seq[float]], zero: float = 0.0, inf:\
    \ float = 1e100) =\n        ## \u96A3\u63A5\u884C\u5217\u3092O(V^3)\u3067\u6700\
    \u77ED\u8DDD\u96E2\u306B\u4E0A\u66F8\u304D\u3059\u308B\u3002\u5230\u9054\u4E0D\
    \u80FD\u306Finf\u3001\u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\u7D44\
    \u306F-inf\u3002\n        warshall_floyd_inplace_impl(d, zero, inf)\n\n    proc\
    \ warshall_floyd_inplace*(d: var seq[seq[float32]], zero: float32 = 0.0'f32, inf:\
    \ float32 = 1e30'f32) =\n        ## \u96A3\u63A5\u884C\u5217\u3092O(V^3)\u3067\
    \u6700\u77ED\u8DDD\u96E2\u306B\u4E0A\u66F8\u304D\u3059\u308B\u3002\u5230\u9054\
    \u4E0D\u80FD\u306Finf\u3001\u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\
    \u7D44\u306F-inf\u3002\n        warshall_floyd_inplace_impl(d, zero, inf)\n\n\
    \    proc warshall_floyd_inplace*[T](d: var seq[seq[T]], zero, inf: T) =\n   \
    \     ## \u96A3\u63A5\u884C\u5217\u3092O(V^3)\u3067\u6700\u77ED\u8DDD\u96E2\u306B\
    \u4E0A\u66F8\u304D\u3059\u308B\u3002\u5230\u9054\u4E0D\u80FD\u306Finf\u3001\u8CA0\
    \u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\u7D44\u306F-inf\u3002\n     \
    \   warshall_floyd_inplace_impl(d, zero, inf)\n\n    proc warshall_floyd_nonnegative_inplace*(d:\
    \ var seq[seq[int]], zero: int = 0, inf: int = INF64) =\n        ## \u8CA0\u9589\
    \u8DEF\u304C\u306A\u3044\u96A3\u63A5\u884C\u5217\u3092O(V^3)\u3067\u6700\u77ED\
    \u8DDD\u96E2\u306B\u4E0A\u66F8\u304D\u3059\u308B\u3002\u8FBA\u306A\u3057\u306F\
    inf\u3001\u5BFE\u89D2\u306Fzero\u3002\u8CA0\u8FBA\u3082\u8A31\u5BB9\u3059\u308B\
    \u3002\n        warshall_floyd_nonnegative_inplace_impl(d, zero, inf)\n\n    proc\
    \ warshall_floyd_nonnegative_inplace*(d: var seq[seq[int32]], zero: int32 = 0.int32,\
    \ inf: int32 = INF32) =\n        ## \u8CA0\u9589\u8DEF\u304C\u306A\u3044\u96A3\
    \u63A5\u884C\u5217\u3092O(V^3)\u3067\u6700\u77ED\u8DDD\u96E2\u306B\u4E0A\u66F8\
    \u304D\u3059\u308B\u3002\u8FBA\u306A\u3057\u306Finf\u3001\u5BFE\u89D2\u306Fzero\u3002\
    \u8CA0\u8FBA\u3082\u8A31\u5BB9\u3059\u308B\u3002\n        warshall_floyd_nonnegative_inplace_impl(d,\
    \ zero, inf)\n\n    proc warshall_floyd_nonnegative_inplace*(d: var seq[seq[float]],\
    \ zero: float = 0.0, inf: float = 1e100) =\n        ## \u8CA0\u9589\u8DEF\u304C\
    \u306A\u3044\u96A3\u63A5\u884C\u5217\u3092O(V^3)\u3067\u6700\u77ED\u8DDD\u96E2\
    \u306B\u4E0A\u66F8\u304D\u3059\u308B\u3002\u8FBA\u306A\u3057\u306Finf\u3001\u5BFE\
    \u89D2\u306Fzero\u3002\u8CA0\u8FBA\u3082\u8A31\u5BB9\u3059\u308B\u3002\n     \
    \   warshall_floyd_nonnegative_inplace_impl(d, zero, inf)\n\n    proc warshall_floyd_nonnegative_inplace*(d:\
    \ var seq[seq[float32]], zero: float32 = 0.0'f32, inf: float32 = 1e30'f32) =\n\
    \        ## \u8CA0\u9589\u8DEF\u304C\u306A\u3044\u96A3\u63A5\u884C\u5217\u3092\
    O(V^3)\u3067\u6700\u77ED\u8DDD\u96E2\u306B\u4E0A\u66F8\u304D\u3059\u308B\u3002\
    \u8FBA\u306A\u3057\u306Finf\u3001\u5BFE\u89D2\u306Fzero\u3002\u8CA0\u8FBA\u3082\
    \u8A31\u5BB9\u3059\u308B\u3002\n        warshall_floyd_nonnegative_inplace_impl(d,\
    \ zero, inf)\n\n    proc warshall_floyd_nonnegative_inplace*[T](d: var seq[seq[T]],\
    \ zero, inf: T) =\n        ## \u8CA0\u9589\u8DEF\u304C\u306A\u3044\u96A3\u63A5\
    \u884C\u5217\u3092O(V^3)\u3067\u6700\u77ED\u8DDD\u96E2\u306B\u4E0A\u66F8\u304D\
    \u3059\u308B\u3002\u8FBA\u306A\u3057\u306Finf\u3001\u5BFE\u89D2\u306Fzero\u3002\
    \u8CA0\u8FBA\u3082\u8A31\u5BB9\u3059\u308B\u3002\n        warshall_floyd_nonnegative_inplace_impl(d,\
    \ zero, inf)\n"
  dependsOn:
  - cplib/graph/warshall_floyd_negative.nim
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  - cplib/graph/warshall_floyd_negative.nim
  isVerificationFile: false
  path: cplib/graph/warshall_floyd_avx512.nim
  requiredBy:
  - verify/AI/warshall_floyd_avx512_register_cases.nim
  - verify/AI/warshall_floyd_avx512_register_cases.nim
  timestamp: '2026-09-14 16:47:56+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/warshall_floyd_avx512_register_packed_test.nim
  - verify/AI/warshall_floyd_avx512_register_packed_test.nim
  - verify/AI/warshall_floyd_avx512_register_packed_large_test.nim
  - verify/AI/warshall_floyd_avx512_register_packed_large_test.nim
  - verify/AI/warshall_floyd_avx512_register_int32_test.nim
  - verify/AI/warshall_floyd_avx512_register_int32_test.nim
  - verify/AI/warshall_floyd_negative_test.nim
  - verify/AI/warshall_floyd_negative_test.nim
  - verify/AI/warshall_floyd_avx512_register_large_test.nim
  - verify/AI/warshall_floyd_avx512_register_large_test.nim
  - verify/AI/warshall_floyd_avx512_test.nim
  - verify/AI/warshall_floyd_avx512_test.nim
  - verify/AI/warshall_floyd_avx512_register_packed_tail_test.nim
  - verify/AI/warshall_floyd_avx512_register_packed_tail_test.nim
  - verify/AI/warshall_floyd_avx512_register_test.nim
  - verify/AI/warshall_floyd_avx512_register_test.nim
documentation_of: cplib/graph/warshall_floyd_avx512.nim
layout: document
redirect_from:
- /library/cplib/graph/warshall_floyd_avx512.nim
- /library/cplib/graph/warshall_floyd_avx512.nim.html
title: cplib/graph/warshall_floyd_avx512.nim
---
