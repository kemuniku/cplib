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
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx_test.nim
    title: verify/AI/warshall_floyd_avx_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx_test.nim
    title: verify/AI/warshall_floyd_avx_test.nim
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
    \ sequtils\n\n    when defined(cpp) and sizeof(int) == 8:\n        {.emit: \"\"\
    \"\n        #ifndef CPLIB_GRAPH_WARSHALL_FLOYD_AVX2_HPP\n        #define CPLIB_GRAPH_WARSHALL_FLOYD_AVX2_HPP\n\
    \n        #include <immintrin.h>\n\n        #include <cstddef>\n        #include\
    \ <cstdint>\n        #include <cstring>\n\n        #ifndef CPLIB_WARSHALL_FLOYD_BLOCK_SIZE\n\
    \        #define CPLIB_WARSHALL_FLOYD_BLOCK_SIZE 216\n        #endif\n\n     \
    \   #ifndef CPLIB_WARSHALL_FLOYD_DENSE_BLOCK_SIZE\n        #define CPLIB_WARSHALL_FLOYD_DENSE_BLOCK_SIZE\
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
    \ }\n\n        static bool cplib_warshall_floyd_int64_sparse_avx2(\n         \
    \       void* raw_rows,\n                std::size_t n,\n                std::int64_t\
    \ zero,\n                std::int64_t inf) {\n            std::int64_t** d = static_cast<std::int64_t**>(raw_rows);\n\
    \            const __m256i inf4 = _mm256_set1_epi64x(inf);\n            constexpr\
    \ std::size_t block_size =\n                CPLIB_WARSHALL_FLOYD_BLOCK_SIZE;\n\
    \n            for (std::size_t i = 0; i < n; ++i) {\n                if (d[i][i]\
    \ < zero) return true;\n            }\n\n            for (std::size_t kk = 0;\
    \ kk < n; kk += block_size) {\n                const std::size_t kend =\n    \
    \                kk + block_size < n ? kk + block_size : n;\n\n              \
    \  // Phase 1: close the diagonal block.\n                for (std::size_t k =\
    \ kk; k < kend; ++k) {\n                    const std::int64_t* const row_k =\
    \ d[k];\n                    const bool all_reachable =\n                    \
    \    cplib_warshall_floyd_all_reachable_avx2(\n                            row_k,\
    \ kk, kend, inf4, inf);\n                    for (std::size_t i = kk; i < kend;\
    \ ++i) {\n                        const std::int64_t dik = d[i][k];\n        \
    \                if (dik != inf) cplib_warshall_floyd_relax_avx2(\n          \
    \                  d[i], row_k, dik, kk, kend, inf4, inf,\n                  \
    \          all_reachable);\n                    }\n                    for (std::size_t\
    \ i = kk; i < kend; ++i) {\n                        if (d[i][i] < zero) return\
    \ true;\n                    }\n                }\n\n                // Phase\
    \ 2a: update the blocks in the diagonal block row.\n                for (std::size_t\
    \ jj = 0; jj < n; jj += block_size) {\n                    if (jj == kk) continue;\n\
    \                    const std::size_t jend =\n                        jj + block_size\
    \ < n ? jj + block_size : n;\n                    for (std::size_t k = kk; k <\
    \ kend; ++k) {\n                        const std::int64_t* const row_k = d[k];\n\
    \                        const bool all_reachable =\n                        \
    \    cplib_warshall_floyd_all_reachable_avx2(\n                              \
    \  row_k, jj, jend, inf4, inf);\n                        for (std::size_t i =\
    \ kk; i < kend; ++i) {\n                            const std::int64_t dik = d[i][k];\n\
    \                            if (dik != inf) cplib_warshall_floyd_relax_avx2(\n\
    \                                d[i], row_k, dik, jj, jend, inf4, inf,\n    \
    \                            all_reachable);\n                        }\n    \
    \                }\n                }\n\n                // Phase 2b: update the\
    \ blocks in the diagonal block column.\n                for (std::size_t ii =\
    \ 0; ii < n; ii += block_size) {\n                    if (ii == kk) continue;\n\
    \                    const std::size_t iend =\n                        ii + block_size\
    \ < n ? ii + block_size : n;\n                    for (std::size_t k = kk; k <\
    \ kend; ++k) {\n                        const std::int64_t* const row_k = d[k];\n\
    \                        const bool all_reachable =\n                        \
    \    cplib_warshall_floyd_all_reachable_avx2(\n                              \
    \  row_k, kk, kend, inf4, inf);\n                        for (std::size_t i =\
    \ ii; i < iend; ++i) {\n                            const std::int64_t dik = d[i][k];\n\
    \                            if (dik != inf) cplib_warshall_floyd_relax_avx2(\n\
    \                                d[i], row_k, dik, kk, kend, inf4, inf,\n    \
    \                            all_reachable);\n                        }\n    \
    \                }\n                }\n\n                // Phase 3: update all\
    \ remaining blocks while the three tiles\n                // stay cache-resident,\
    \ reusing them across the inner loops.\n                for (std::size_t ii =\
    \ 0; ii < n; ii += block_size) {\n                    if (ii == kk) continue;\n\
    \                    const std::size_t iend =\n                        ii + block_size\
    \ < n ? ii + block_size : n;\n                    for (std::size_t jj = 0; jj\
    \ < n; jj += block_size) {\n                        if (jj == kk) continue;\n\
    \                        const std::size_t jend =\n                          \
    \  jj + block_size < n ? jj + block_size : n;\n                        bool reachable[block_size];\n\
    \                        for (std::size_t k = kk; k < kend; ++k) {\n         \
    \                   const std::int64_t* const row_k = d[k];\n                \
    \            reachable[k - kk] =\n                                cplib_warshall_floyd_all_reachable_avx2(\n\
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
    \      if (d[i][i] < zero) return true;\n                }\n            }\n  \
    \          return false;\n        }\n\n        static bool cplib_warshall_floyd_int64_dense_tiled_avx2(\n\
    \                std::int64_t** d,\n                std::size_t n,\n         \
    \       std::int64_t zero,\n                std::int64_t inf) {\n            constexpr\
    \ std::size_t block_size =\n                CPLIB_WARSHALL_FLOYD_DENSE_BLOCK_SIZE;\n\
    \            const std::size_t block_count =\n                (n + block_size\
    \ - 1) / block_size;\n            const std::size_t padded_size = block_count\
    \ * block_size;\n            std::int64_t* const matrix = static_cast<std::int64_t*>(\n\
    \                _mm_malloc(padded_size * padded_size * sizeof(std::int64_t),\
    \ 32));\n            if (matrix == nullptr) {\n                return cplib_warshall_floyd_int64_sparse_avx2(\n\
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
    \ 0; i < k_size; ++i) {\n                        if (diagonal[i * block_size +\
    \ i] < zero) {\n                            negative_cycle = true;\n         \
    \                   break;\n                        }\n                    }\n\
    \                    if (negative_cycle) break;\n                }\n         \
    \       if (negative_cycle) break;\n\n                for (std::size_t jb = 0;\
    \ jb < block_count; ++jb) {\n                    if (jb == kb) continue;\n   \
    \                 const std::size_t j_begin = jb * block_size;\n             \
    \       const std::size_t j_size =\n                        j_begin + block_size\
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
    \ return negative_cycle;\n        }\n\n        extern \"C\" bool cplib_warshall_floyd_int64_avx2(\n\
    \                void* raw_rows,\n                std::size_t n,\n           \
    \     std::int64_t zero,\n                std::int64_t inf) {\n            std::int64_t**\
    \ d = static_cast<std::int64_t**>(raw_rows);\n            const __m256i inf4 =\
    \ _mm256_set1_epi64x(inf);\n            bool dense = true;\n            for (std::size_t\
    \ i = 0; i < n && dense; ++i) {\n                dense = cplib_warshall_floyd_all_reachable_avx2(\n\
    \                    d[i], 0, n, inf4, inf);\n            }\n            if (dense)\
    \ {\n                return cplib_warshall_floyd_int64_dense_tiled_avx2(\n   \
    \                 d, n, zero, inf);\n            }\n            return cplib_warshall_floyd_int64_sparse_avx2(\n\
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
    \ candidate;\n                }\n            }\n        }\n\n        extern \"\
    C\" bool cplib_warshall_floyd_int32_avx2(\n                void* raw_rows,\n \
    \               std::size_t n,\n                std::int32_t zero,\n         \
    \       std::int32_t inf) {\n            std::int32_t** d = static_cast<std::int32_t**>(raw_rows);\n\
    \            const __m256i inf8 = _mm256_set1_epi32(inf);\n            constexpr\
    \ std::size_t block_size =\n                CPLIB_WARSHALL_FLOYD_INT32_BLOCK_SIZE;\n\
    \n            for (std::size_t i = 0; i < n; ++i) {\n                if (d[i][i]\
    \ < zero) return true;\n            }\n\n            for (std::size_t kk = 0;\
    \ kk < n; kk += block_size) {\n                const std::size_t kend =\n    \
    \                kk + block_size < n ? kk + block_size : n;\n\n              \
    \  // Phase 1: close the diagonal block.\n                for (std::size_t k =\
    \ kk; k < kend; ++k) {\n                    const std::int32_t* const row_k =\
    \ d[k];\n                    for (std::size_t i = kk; i < kend; ++i) {\n     \
    \                   const std::int32_t dik = d[i][k];\n                      \
    \  if (dik != inf) cplib_warshall_floyd_relax_int32_avx2(\n                  \
    \          d[i], row_k, dik, kk, kend, inf8, inf);\n                    }\n  \
    \                  for (std::size_t i = kk; i < kend; ++i) {\n               \
    \         if (d[i][i] < zero) return true;\n                    }\n          \
    \      }\n\n                // Phase 2a: update the blocks in the diagonal block\
    \ row.\n                for (std::size_t jj = 0; jj < n; jj += block_size) {\n\
    \                    if (jj == kk) continue;\n                    const std::size_t\
    \ jend =\n                        jj + block_size < n ? jj + block_size : n;\n\
    \                    for (std::size_t k = kk; k < kend; ++k) {\n             \
    \           const std::int32_t* const row_k = d[k];\n                        for\
    \ (std::size_t i = kk; i < kend; ++i) {\n                            const std::int32_t\
    \ dik = d[i][k];\n                            if (dik != inf) cplib_warshall_floyd_relax_int32_avx2(\n\
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
    \             if (d[i][i] < zero) return true;\n                }\n          \
    \  }\n            return false;\n        }\n\n        #pragma GCC pop_options\n\
    \n        #endif\n        \"\"\".}\n\n        proc warshallFloydInt64Avx2(\n \
    \           rows: pointer,\n            n: csize_t,\n            zero, inf: int\n\
    \        ): bool {.importc: \"cplib_warshall_floyd_int64_avx2\".}\n\n        proc\
    \ warshallFloydInt32Avx2(\n            rows: pointer,\n            n: csize_t,\n\
    \            zero, inf: int32\n        ): bool {.importc: \"cplib_warshall_floyd_int32_avx2\"\
    .}\n\n    proc warshall_floyd_impl[T](g: DynamicGraph[T] or StaticGraph[T], zero,\
    \ inf: T): tuple[negative_cycle: bool, d: seq[seq[T]]] =\n        var d = newSeqWith(g.len,\
    \ newSeqWith(g.len, inf))\n        for i in 0..<g.len: d[i][i] = zero\n      \
    \  for i in 0..<g.len:\n            for (j, cost) in g.to_and_cost(i):\n     \
    \           d[i][j] = min(d[i][j], cost)\n        for k in 0..<g.len:\n      \
    \      for i in 0..<g.len:\n                for j in 0..<g.len:\n            \
    \        if d[i][k] != inf and d[k][j] != inf:\n                        d[i][j]\
    \ = min(d[i][j], d[i][k] + d[k][j])\n            for i in 0..<g.len:\n       \
    \         if d[i][i] < zero: return (negative_cycle: true, d: d)\n        return\
    \ (negative_cycle: false, d: d)\n\n    proc warshall_floyd*(g: DynamicGraph[int]\
    \ or StaticGraph[int], zero: int = 0, inf: int = INF64): tuple[negative_cycle:\
    \ bool, d: seq[seq[int]]] =\n        when defined(cpp) and sizeof(int) == 8:\n\
    \            var d = newSeqWith(g.len, newSeqWith(g.len, inf))\n            for\
    \ i in 0..<g.len: d[i][i] = zero\n            for i in 0..<g.len:\n          \
    \      for (j, cost) in g.to_and_cost(i):\n                    d[i][j] = min(d[i][j],\
    \ cost)\n\n            if g.len == 0:\n                return (negative_cycle:\
    \ false, d: d)\n\n            var rows = newSeq[ptr int](g.len)\n            for\
    \ i in 0..<g.len:\n                rows[i] = addr d[i][0]\n            let negativeCycle\
    \ = warshallFloydInt64Avx2(\n                cast[pointer](addr rows[0]), g.len.csize_t,\
    \ zero, inf)\n            return (negative_cycle: negativeCycle, d: d)\n     \
    \   else:\n            return warshall_floyd_impl(g, zero, inf)\n    proc warshall_floyd*(g:\
    \ DynamicGraph[int32] or StaticGraph[int32], zero: int32 = 0.int32, inf: int32\
    \ = INF32): tuple[negative_cycle: bool, d: seq[seq[int32]]] =\n        when defined(cpp):\n\
    \            var d = newSeqWith(g.len, newSeqWith(g.len, inf))\n            for\
    \ i in 0..<g.len: d[i][i] = zero\n            for i in 0..<g.len:\n          \
    \      for (j, cost) in g.to_and_cost(i):\n                    d[i][j] = min(d[i][j],\
    \ cost)\n\n            if g.len == 0:\n                return (negative_cycle:\
    \ false, d: d)\n\n            var rows = newSeq[ptr int32](g.len)\n          \
    \  for i in 0..<g.len:\n                rows[i] = addr d[i][0]\n            let\
    \ negativeCycle = warshallFloydInt32Avx2(\n                cast[pointer](addr\
    \ rows[0]), g.len.csize_t, zero, inf)\n            return (negative_cycle: negativeCycle,\
    \ d: d)\n        else:\n            return warshall_floyd_impl(g, zero, inf)\n\
    \    proc warshall_floyd*(g: DynamicGraph[float] or StaticGraph[float], zero:\
    \ float = 0.0, inf: float = 1e100): tuple[negative_cycle: bool, d: seq[seq[float]]]\
    \ = warshall_floyd_impl(g, zero, inf)\n    proc warshall_floyd*(g: DynamicGraph[float32]\
    \ or StaticGraph[float32], zero: float32 = 0.0'f32, inf: float32 = 1e30'f32):\
    \ tuple[negative_cycle: bool, d: seq[seq[float32]]] = warshall_floyd_impl(g, zero,\
    \ inf)\n    proc warshall_floyd*[T](g: DynamicGraph[T] or StaticGraph[T], zero,\
    \ inf: T): tuple[negative_cycle: bool, d: seq[seq[T]]] = warshall_floyd_impl(g,\
    \ zero, inf)\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  isVerificationFile: false
  path: cplib/graph/warshall_floyd_avx.nim
  requiredBy: []
  timestamp: '2026-09-03 23:28:44+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/warshall_floyd_avx_test.nim
  - verify/AI/warshall_floyd_avx_test.nim
documentation_of: cplib/graph/warshall_floyd_avx.nim
layout: document
redirect_from:
- /library/cplib/graph/warshall_floyd_avx.nim
- /library/cplib/graph/warshall_floyd_avx.nim.html
title: cplib/graph/warshall_floyd_avx.nim
---
