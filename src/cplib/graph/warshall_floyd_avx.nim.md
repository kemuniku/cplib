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
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx_exact_test.nim
    title: verify/AI/warshall_floyd_avx_exact_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx_exact_test.nim
    title: verify/AI/warshall_floyd_avx_exact_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx_test.nim
    title: verify/AI/warshall_floyd_avx_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx_test.nim
    title: verify/AI/warshall_floyd_avx_test.nim
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
    \ and sizeof(int) == 8:\n        {.emit: \"\"\"\n        #ifndef CPLIB_GRAPH_WARSHALL_FLOYD_AVX2_HPP\n\
    \        #define CPLIB_GRAPH_WARSHALL_FLOYD_AVX2_HPP\n\n        #include <immintrin.h>\n\
    \n        #include <cstddef>\n        #include <cstdint>\n        #include <cstring>\n\
    \n        #ifndef CPLIB_WARSHALL_FLOYD_BLOCK_SIZE\n        #define CPLIB_WARSHALL_FLOYD_BLOCK_SIZE\
    \ 216\n        #endif\n\n        #ifndef CPLIB_WARSHALL_FLOYD_DENSE_BLOCK_SIZE\n\
    \        #define CPLIB_WARSHALL_FLOYD_DENSE_BLOCK_SIZE 256\n        #endif\n\n\
    \        #ifndef CPLIB_WARSHALL_FLOYD_INT32_BLOCK_SIZE\n        #define CPLIB_WARSHALL_FLOYD_INT32_BLOCK_SIZE\
    \ 256\n        #endif\n\n        #pragma GCC push_options\n        #pragma GCC\
    \ target(\"avx2\")\n        #pragma GCC optimize(\"O3\")\n\n        static inline\
    \ bool cplib_warshall_floyd_all_reachable_avx2(\n                const std::int64_t*\
    \ row,\n                std::size_t begin,\n                std::size_t end,\n\
    \                __m256i inf4,\n                std::int64_t inf) {\n        \
    \    std::size_t j = begin;\n            for (; j + 4 <= end; j += 4) {\n    \
    \            const __m256i values = _mm256_loadu_si256(\n                    reinterpret_cast<const\
    \ __m256i*>(row + j));\n                const __m256i unreachable = _mm256_cmpeq_epi64(values,\
    \ inf4);\n                if (!_mm256_testz_si256(unreachable, unreachable)) return\
    \ false;\n            }\n            for (; j < end; ++j) {\n                if\
    \ (row[j] == inf) return false;\n            }\n            return true;\n   \
    \     }\n\n        static inline void cplib_warshall_floyd_relax_avx2(\n     \
    \           std::int64_t* row_i,\n                const std::int64_t* row_k,\n\
    \                std::int64_t dik,\n                std::size_t begin,\n     \
    \           std::size_t end,\n                __m256i inf4,\n                std::int64_t\
    \ inf,\n                bool all_reachable) {\n            const __m256i dik4\
    \ = _mm256_set1_epi64x(dik);\n            std::size_t j = begin;\n           \
    \ if (all_reachable) {\n                #pragma GCC unroll 8\n               \
    \ for (; j + 4 <= end; j += 4) {\n                    const __m256i dkj = _mm256_loadu_si256(\n\
    \                        reinterpret_cast<const __m256i*>(row_k + j));\n     \
    \               const __m256i dij = _mm256_loadu_si256(\n                    \
    \    reinterpret_cast<const __m256i*>(row_i + j));\n                    const\
    \ __m256i candidate = _mm256_add_epi64(dik4, dkj);\n                    const\
    \ __m256i take = _mm256_cmpgt_epi64(dij, candidate);\n                    _mm256_maskstore_epi64(\n\
    \                        reinterpret_cast<long long*>(row_i + j), take, candidate);\n\
    \                }\n                for (; j < end; ++j) {\n                 \
    \   const std::int64_t candidate = dik + row_k[j];\n                    if (candidate\
    \ < row_i[j]) row_i[j] = candidate;\n                }\n            } else {\n\
    \                #pragma GCC unroll 4\n                for (; j + 4 <= end; j\
    \ += 4) {\n                    const __m256i dkj = _mm256_loadu_si256(\n     \
    \                   reinterpret_cast<const __m256i*>(row_k + j));\n          \
    \          const __m256i dij = _mm256_loadu_si256(\n                        reinterpret_cast<const\
    \ __m256i*>(row_i + j));\n                    const __m256i candidate = _mm256_add_epi64(dik4,\
    \ dkj);\n                    const __m256i unreachable = _mm256_cmpeq_epi64(dkj,\
    \ inf4);\n                    const __m256i improves = _mm256_cmpgt_epi64(dij,\
    \ candidate);\n                    const __m256i take = _mm256_andnot_si256(\n\
    \                        unreachable, improves);\n                    _mm256_maskstore_epi64(\n\
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
    \ return negative_cycle;\n        }\n\n        static bool cplib_warshall_floyd_exact_double_avx2(\n\
    \                std::int64_t** d, std::size_t n, std::int64_t inf) {\n      \
    \      // \u8CA0\u9589\u8DEF\u306E\u306A\u3044\u6574\u6570\u8DDD\u96E2\u3092\u8AA4\
    \u5DEE\u306A\u304Fdouble\u3067\u8A08\u7B97\u3059\u308B\u3002\u6642\u9593O(n^3)\u3001\
    \u8FFD\u52A0\u9818\u57DFO(n^2)\u3002\n            constexpr std::size_t B = 128;\n\
    \            const std::size_t count = (n + B - 1) / B;\n            double* matrix\
    \ = static_cast<double*>(\n                _mm_malloc(count * count * B * B *\
    \ sizeof(double), 32));\n            if (matrix == nullptr) return false;\n  \
    \          const auto tile = [&](std::size_t i, std::size_t j) {\n           \
    \     return matrix + (i * count + j) * B * B;\n            };\n            for\
    \ (std::size_t bi = 0; bi < count; ++bi)\n                for (std::size_t bj\
    \ = 0; bj < count; ++bj)\n                    for (std::size_t i = 0; i < B; ++i)\n\
    \                        for (std::size_t j = 0; j < B; ++j) {\n             \
    \               const std::size_t row = bi * B + i;\n                        \
    \    const std::size_t col = bj * B + j;\n                            tile(bi,\
    \ bj)[i * B + j] =\n                                row < n && col < n && d[row][col]\
    \ != inf\n                                    ? static_cast<double>(d[row][col])\n\
    \                                    : __builtin_inf();\n                    \
    \    }\n            const auto relax = [&](double* out, const double* left, const\
    \ double* top) {\n                // \u4F9D\u5B58\u306E\u3042\u308B\u5BFE\u89D2\
    \u30FB\u884C\u30FB\u5217\u30BF\u30A4\u30EB\u306Fk\u306E\u9806\u306B\u66F4\u65B0\
    \u3059\u308B\u3002\n                for (std::size_t k = 0; k < B; ++k)\n    \
    \                for (std::size_t i = 0; i < B; ++i) {\n                     \
    \   const __m256d a = _mm256_set1_pd(left[i * B + k]);\n                     \
    \   for (std::size_t j = 0; j < B; j += 4)\n                            _mm256_store_pd(out\
    \ + i * B + j, _mm256_min_pd(\n                                _mm256_load_pd(out\
    \ + i * B + j),\n                                _mm256_add_pd(a, _mm256_load_pd(top\
    \ + k * B + j))));\n                    }\n            };\n            const auto\
    \ product = [&](double* out, const double* left, const double* top) {\n      \
    \          // \u72EC\u7ACB\u306A\u30BF\u30A4\u30EB\u3067\u306F4\u884C8\u5217\u3092\
    \u30EC\u30B8\u30B9\u30BF\u306B\u4FDD\u6301\u3059\u308B\u3002\n               \
    \ for (std::size_t i = 0; i < B; i += 4)\n                    for (std::size_t\
    \ j = 0; j < B; j += 8) {\n                        __m256d v00 = _mm256_load_pd(out\
    \ + (i + 0) * B + j + 0);\n                        __m256d v01 = _mm256_load_pd(out\
    \ + (i + 0) * B + j + 4);\n                        __m256d v10 = _mm256_load_pd(out\
    \ + (i + 1) * B + j + 0);\n                        __m256d v11 = _mm256_load_pd(out\
    \ + (i + 1) * B + j + 4);\n                        __m256d v20 = _mm256_load_pd(out\
    \ + (i + 2) * B + j + 0);\n                        __m256d v21 = _mm256_load_pd(out\
    \ + (i + 2) * B + j + 4);\n                        __m256d v30 = _mm256_load_pd(out\
    \ + (i + 3) * B + j + 0);\n                        __m256d v31 = _mm256_load_pd(out\
    \ + (i + 3) * B + j + 4);\n                        for (std::size_t k = 0; k <\
    \ B; ++k) {\n                            const __m256d b0 = _mm256_load_pd(top\
    \ + k * B + j + 0);\n                            const __m256d b1 = _mm256_load_pd(top\
    \ + k * B + j + 4);\n                            const __m256d a0 = _mm256_set1_pd(left[(i\
    \ + 0) * B + k]);\n                            v00 = _mm256_min_pd(v00, _mm256_add_pd(a0,\
    \ b0));\n                            v01 = _mm256_min_pd(v01, _mm256_add_pd(a0,\
    \ b1));\n                            const __m256d a1 = _mm256_set1_pd(left[(i\
    \ + 1) * B + k]);\n                            v10 = _mm256_min_pd(v10, _mm256_add_pd(a1,\
    \ b0));\n                            v11 = _mm256_min_pd(v11, _mm256_add_pd(a1,\
    \ b1));\n                            const __m256d a2 = _mm256_set1_pd(left[(i\
    \ + 2) * B + k]);\n                            v20 = _mm256_min_pd(v20, _mm256_add_pd(a2,\
    \ b0));\n                            v21 = _mm256_min_pd(v21, _mm256_add_pd(a2,\
    \ b1));\n                            const __m256d a3 = _mm256_set1_pd(left[(i\
    \ + 3) * B + k]);\n                            v30 = _mm256_min_pd(v30, _mm256_add_pd(a3,\
    \ b0));\n                            v31 = _mm256_min_pd(v31, _mm256_add_pd(a3,\
    \ b1));\n                        }\n                        _mm256_store_pd(out\
    \ + (i + 0) * B + j + 0, v00);\n                        _mm256_store_pd(out +\
    \ (i + 0) * B + j + 4, v01);\n                        _mm256_store_pd(out + (i\
    \ + 1) * B + j + 0, v10);\n                        _mm256_store_pd(out + (i +\
    \ 1) * B + j + 4, v11);\n                        _mm256_store_pd(out + (i + 2)\
    \ * B + j + 0, v20);\n                        _mm256_store_pd(out + (i + 2) *\
    \ B + j + 4, v21);\n                        _mm256_store_pd(out + (i + 3) * B\
    \ + j + 0, v30);\n                        _mm256_store_pd(out + (i + 3) * B +\
    \ j + 4, v31);\n                    }\n            };\n            for (std::size_t\
    \ k = 0; k < count; ++k) {\n                relax(tile(k, k), tile(k, k), tile(k,\
    \ k));\n                for (std::size_t j = 0; j < count; ++j)\n            \
    \        if (j != k) relax(tile(k, j), tile(k, k), tile(k, j));\n            \
    \    for (std::size_t i = 0; i < count; ++i)\n                    if (i != k)\
    \ relax(tile(i, k), tile(i, k), tile(k, k));\n                for (std::size_t\
    \ i = 0; i < count; ++i)\n                    if (i != k)\n                  \
    \      for (std::size_t j = 0; j < count; ++j)\n                            if\
    \ (j != k) product(tile(i, j), tile(i, k), tile(k, j));\n            }\n     \
    \       for (std::size_t i = 0; i < n; ++i)\n                for (std::size_t\
    \ j = 0; j < n; ++j) {\n                    const double value = tile(i / B, j\
    \ / B)[(i % B) * B + j % B];\n                    d[i][j] = value < static_cast<double>(inf)\n\
    \                        ? static_cast<std::int64_t>(value) : inf;\n         \
    \       }\n            _mm_free(matrix);\n            return true;\n        }\n\
    \n        template <bool check_negative>\n        static bool cplib_warshall_floyd_int64_avx2_impl(\n\
    \                void* raw_rows,\n                std::size_t n,\n           \
    \     std::int64_t zero,\n                std::int64_t inf) {\n            std::int64_t**\
    \ d = static_cast<std::int64_t**>(raw_rows);\n            // \u8CA0\u9589\u8DEF\
    \u304C\u306A\u3051\u308C\u3070\u6700\u77ED\u8DEF\u306F\u9AD8\u3005n-1\u8FBA\u3001\
    \u5019\u88DC\u306E\u7D76\u5BFE\u5024\u30822^53\u4EE5\u4E0B\u306B\u53CE\u307E\u308B\
    \u3002\n            // \u8CA0\u9589\u8DEF\u691C\u51FA\u304C\u5FC5\u8981\u306A\u5834\
    \u5408\u306E\u8CA0\u8FBA\u30FB\u7BC4\u56F2\u5916\u30FB\u7279\u6B8A\u306Azero/inf\u306F\
    \u6574\u6570\u3067\u51E6\u7406\u3059\u308B\u3002\n            bool exact = n >=\
    \ 128 && zero == 0 && inf > 0;\n            const std::int64_t limit = (INT64_C(1)\
    \ << 52) / (n ? n : 1);\n            std::size_t edges = 0;\n            bool\
    \ has_negative = false;\n            std::int64_t max_abs = 0;\n            for\
    \ (std::size_t i = 0; i < n && exact; ++i)\n                for (std::size_t j\
    \ = 0; j < n; ++j) {\n                    const std::int64_t value = d[i][j];\n\
    \                    if (d[i][j] != inf &&\n                            (value\
    \ < (check_negative ? 0 : -limit) ||\n                             value > limit\
    \ || value >= inf)) {\n                        exact = false;\n              \
    \          break;\n                    }\n                    if (value != inf)\
    \ {\n                        has_negative = has_negative || value < 0;\n     \
    \                   const std::int64_t magnitude = value < 0 ? -value : value;\n\
    \                        if (magnitude > max_abs) max_abs = magnitude;\n     \
    \               }\n                    if (i != j && d[i][j] != inf) ++edges;\n\
    \                }\n            // \u8CA0\u8FBA\u3067inf\u4EE5\u4E0A\u306E\u9014\
    \u4E2D\u7D4C\u8DEF\u304C\u518D\u3073\u77ED\u304F\u306A\u308B\u5834\u5408\u306F\
    \u3001\u6709\u9650inf\u306E\u6253\u3061\u5207\u308A\u3092\u7DAD\u6301\u3059\u308B\
    \u3002\n            if (has_negative && inf <= 2 * static_cast<std::int64_t>(n)\
    \ * max_abs)\n                exact = false;\n            // \u8FBA\u304C\u6975\
    \u7AEF\u306B\u5C11\u306A\u3044\u5834\u5408\u306F\u672A\u5230\u9054\u884C\u3092\
    \u30B9\u30AD\u30C3\u30D7\u3059\u308B\u758E\u30AB\u30FC\u30CD\u30EB\u3092\u512A\
    \u5148\u3059\u308B\u3002\n            if (exact && edges >= n &&\n           \
    \         cplib_warshall_floyd_exact_double_avx2(d, n, inf)) return false;\n \
    \           const __m256i inf4 = _mm256_set1_epi64x(inf);\n            bool dense\
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
    \ <bool check_negative>\n        static bool cplib_warshall_floyd_int32_avx2_impl(\n\
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
    \ GCC pop_options\n\n        extern \"C\" bool cplib_warshall_floyd_int64_avx2(\n\
    \                void* raw_rows, std::size_t n,\n                std::int64_t\
    \ zero, std::int64_t inf) {\n            // AVX2\u3067\u5168\u70B9\u5BFE\u6700\
    \u77ED\u8DEF\u3092\u6C42\u3081\u3001\u8CA0\u9589\u8DEF\u306E\u6709\u7121\u3092\
    \u8FD4\u3059\u3002O(n^3)\u3002\n            return cplib_warshall_floyd_int64_avx2_impl<true>(raw_rows,\
    \ n, zero, inf);\n        }\n\n        extern \"C\" void cplib_warshall_floyd_nonnegative_int64_avx2(\n\
    \                void* raw_rows, std::size_t n,\n                std::int64_t\
    \ zero, std::int64_t inf) {\n            // \u8CA0\u9589\u8DEF\u304C\u306A\u3044\
    \u5834\u5408\u306E\u5168\u70B9\u5BFE\u6700\u77ED\u8DEF\u3092AVX2\u3067\u6C42\u3081\
    \u308B\u3002\u8CA0\u9589\u8DEF\u691C\u67FB\u306A\u3057\u3002O(n^3)\u3002\n   \
    \         cplib_warshall_floyd_int64_avx2_impl<false>(raw_rows, n, zero, inf);\n\
    \        }\n\n        extern \"C\" bool cplib_warshall_floyd_int32_avx2(\n   \
    \             void* raw_rows, std::size_t n,\n                std::int32_t zero,\
    \ std::int32_t inf) {\n            // AVX2\u3067\u5168\u70B9\u5BFE\u6700\u77ED\
    \u8DEF\u3092\u6C42\u3081\u3001\u8CA0\u9589\u8DEF\u306E\u6709\u7121\u3092\u8FD4\
    \u3059\u3002O(n^3)\u3002\n            return cplib_warshall_floyd_int32_avx2_impl<true>(raw_rows,\
    \ n, zero, inf);\n        }\n\n        extern \"C\" void cplib_warshall_floyd_nonnegative_int32_avx2(\n\
    \                void* raw_rows, std::size_t n,\n                std::int32_t\
    \ zero, std::int32_t inf) {\n            // \u8CA0\u9589\u8DEF\u304C\u306A\u3044\
    \u5834\u5408\u306E\u5168\u70B9\u5BFE\u6700\u77ED\u8DEF\u3092AVX2\u3067\u6C42\u3081\
    \u308B\u3002\u8CA0\u9589\u8DEF\u691C\u67FB\u306A\u3057\u3002O(n^3)\u3002\n   \
    \         cplib_warshall_floyd_int32_avx2_impl<false>(raw_rows, n, zero, inf);\n\
    \        }\n\n        #endif\n        \"\"\".}\n\n        proc warshallFloydInt64Avx2(\n\
    \            rows: pointer,\n            n: csize_t,\n            zero, inf: int\n\
    \        ): bool {.importc: \"cplib_warshall_floyd_int64_avx2\".}\n\n        proc\
    \ warshallFloydInt32Avx2(\n            rows: pointer,\n            n: csize_t,\n\
    \            zero, inf: int32\n        ): bool {.importc: \"cplib_warshall_floyd_int32_avx2\"\
    .}\n\n        proc warshallFloydNonnegativeInt64Avx2(\n            rows: pointer,\
    \ n: csize_t, zero, inf: int\n        ) {.importc: \"cplib_warshall_floyd_nonnegative_int64_avx2\"\
    .}\n            ## \u8CA0\u9589\u8DEF\u304C\u306A\u3044\u8DDD\u96E2\u884C\u5217\
    \u3092AVX2\u3067\u66F4\u65B0\u3059\u308B\u3002O(V^3)\u3002\n\n        proc warshallFloydNonnegativeInt32Avx2(\n\
    \            rows: pointer, n: csize_t, zero, inf: int32\n        ) {.importc:\
    \ \"cplib_warshall_floyd_nonnegative_int32_avx2\".}\n            ## \u8CA0\u9589\
    \u8DEF\u304C\u306A\u3044\u8DDD\u96E2\u884C\u5217\u3092AVX2\u3067\u66F4\u65B0\u3059\
    \u308B\u3002O(V^3)\u3002\n\n    proc warshall_floyd_inplace_run[T](d: var seq[seq[T]],\
    \ zero, inf: T): bool =\n        ## \u6B63\u65B9\u96A3\u63A5\u884C\u5217\u3092\
    \u6700\u77ED\u8DDD\u96E2\u3067\u4E0A\u66F8\u304D\u3057\u3001\u8CA0\u9589\u8DEF\
    \u306E\u6709\u7121\u3092\u8FD4\u3059\u3002O(V^3)\u3002\u8CA0\u9589\u8DEF\u691C\
    \u51FA\u6642\u306F\u9014\u4E2D\u306E\u884C\u5217\u3092\u6B8B\u3059\u3002\n   \
    \     let n = d.len\n        for i in 0..<n:\n            assert d[i].len == n,\
    \ \"\u96A3\u63A5\u884C\u5217\u306F\u6B63\u65B9\u884C\u5217\u3067\u3042\u308B\u5FC5\
    \u8981\u304C\u3042\u308A\u307E\u3059\"\n        for i in 0..<n:\n            d[i][i]\
    \ = min(d[i][i], zero)\n        for i in 0..<n:\n            if d[i][i] < zero:\n\
    \                return true\n        when defined(cpp) and sizeof(int) == 8 and\
    \ (T is int or T is int32):\n            if n == 0:\n                return false\n\
    \            var rows = newSeq[ptr T](n)\n            for i in 0..<n:\n      \
    \          rows[i] = addr d[i][0]\n            when T is int:\n              \
    \  let negativeCycle = warshallFloydInt64Avx2(\n                    cast[pointer](addr\
    \ rows[0]), n.csize_t, zero, inf)\n            else:\n                let negativeCycle\
    \ = warshallFloydInt32Avx2(\n                    cast[pointer](addr rows[0]),\
    \ n.csize_t, zero, inf)\n            return negativeCycle\n        else:\n   \
    \         for k in 0..<n:\n                for i in 0..<n:\n                 \
    \   for j in 0..<n:\n                        if d[i][k] != inf and d[k][j] !=\
    \ inf:\n                            d[i][j] = min(d[i][j], d[i][k] + d[k][j])\n\
    \                for i in 0..<n:\n                    if d[i][i] < zero:\n   \
    \                     return true\n            return false\n\n    proc warshall_floyd_inplace_impl[T](d:\
    \ var seq[seq[T]], zero, inf: T) =\n        ## \u8DDD\u96E2\u884C\u5217\u3092\u5B8C\
    \u6210\u3055\u305B\u3001\u8CA0\u9589\u8DEF\u3092\u7D4C\u7531\u3067\u304D\u308B\
    \u7D44\u306F-inf\u306B\u3059\u308B\u3002O(V^3)\u3002\n        if warshall_floyd_inplace_run(d,\
    \ zero, inf):\n            warshall_floyd_negative_finish(d, zero, inf, warshall_floyd_inplace_run[T])\n\
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
    \      warshallFloydNonnegativeInt64Avx2(\n                    cast[pointer](addr\
    \ rows[0]), d.len.csize_t, zero, inf)\n            else:\n                warshallFloydNonnegativeInt32Avx2(\n\
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
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  - cplib/graph/warshall_floyd_negative.nim
  - cplib/graph/graph.nim
  - cplib/graph/warshall_floyd_negative.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/warshall_floyd_avx.nim
  requiredBy: []
  timestamp: '2026-09-17 22:59:05+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/warshall_floyd_avx_exact_test.nim
  - verify/AI/warshall_floyd_avx_exact_test.nim
  - verify/AI/warshall_floyd_negative_test.nim
  - verify/AI/warshall_floyd_negative_test.nim
  - verify/AI/warshall_floyd_avx_test.nim
  - verify/AI/warshall_floyd_avx_test.nim
documentation_of: cplib/graph/warshall_floyd_avx.nim
layout: document
redirect_from:
- /library/cplib/graph/warshall_floyd_avx.nim
- /library/cplib/graph/warshall_floyd_avx.nim.html
title: cplib/graph/warshall_floyd_avx.nim
---
