when not declared CPLIB_GRAPH_WARSHALLFLOYD:
    const CPLIB_GRAPH_WARSHALLFLOYD* = 1
    import cplib/graph/graph
    import cplib/utils/constants
    import sequtils

    when defined(cpp) and sizeof(int) == 8:
        {.emit: """
        #ifndef CPLIB_GRAPH_WARSHALL_FLOYD_AVX2_HPP
        #define CPLIB_GRAPH_WARSHALL_FLOYD_AVX2_HPP

        #include <immintrin.h>

        #include <cstddef>
        #include <cstdint>
        #include <cstring>

        #ifndef CPLIB_WARSHALL_FLOYD_BLOCK_SIZE
        #define CPLIB_WARSHALL_FLOYD_BLOCK_SIZE 216
        #endif

        #ifndef CPLIB_WARSHALL_FLOYD_DENSE_BLOCK_SIZE
        #define CPLIB_WARSHALL_FLOYD_DENSE_BLOCK_SIZE 256
        #endif

        #ifndef CPLIB_WARSHALL_FLOYD_INT32_BLOCK_SIZE
        #define CPLIB_WARSHALL_FLOYD_INT32_BLOCK_SIZE 256
        #endif

        #pragma GCC push_options
        #pragma GCC target("avx2")
        #pragma GCC optimize("O3")

        static inline bool cplib_warshall_floyd_all_reachable_avx2(
                const std::int64_t* row,
                std::size_t begin,
                std::size_t end,
                __m256i inf4,
                std::int64_t inf) {
            std::size_t j = begin;
            for (; j + 4 <= end; j += 4) {
                const __m256i values = _mm256_loadu_si256(
                    reinterpret_cast<const __m256i*>(row + j));
                const __m256i unreachable = _mm256_cmpeq_epi64(values, inf4);
                if (!_mm256_testz_si256(unreachable, unreachable)) return false;
            }
            for (; j < end; ++j) {
                if (row[j] == inf) return false;
            }
            return true;
        }

        static inline void cplib_warshall_floyd_relax_avx2(
                std::int64_t* row_i,
                const std::int64_t* row_k,
                std::int64_t dik,
                std::size_t begin,
                std::size_t end,
                __m256i inf4,
                std::int64_t inf,
                bool all_reachable) {
            const __m256i dik4 = _mm256_set1_epi64x(dik);
            std::size_t j = begin;
            if (all_reachable) {
                #pragma GCC unroll 8
                for (; j + 4 <= end; j += 4) {
                    const __m256i dkj = _mm256_loadu_si256(
                        reinterpret_cast<const __m256i*>(row_k + j));
                    const __m256i dij = _mm256_loadu_si256(
                        reinterpret_cast<const __m256i*>(row_i + j));
                    const __m256i candidate = _mm256_add_epi64(dik4, dkj);
                    const __m256i take = _mm256_cmpgt_epi64(dij, candidate);
                    _mm256_maskstore_epi64(
                        reinterpret_cast<long long*>(row_i + j), take, candidate);
                }
                for (; j < end; ++j) {
                    const std::int64_t candidate = dik + row_k[j];
                    if (candidate < row_i[j]) row_i[j] = candidate;
                }
            } else {
                #pragma GCC unroll 4
                for (; j + 4 <= end; j += 4) {
                    const __m256i dkj = _mm256_loadu_si256(
                        reinterpret_cast<const __m256i*>(row_k + j));
                    const __m256i dij = _mm256_loadu_si256(
                        reinterpret_cast<const __m256i*>(row_i + j));
                    const __m256i candidate = _mm256_add_epi64(dik4, dkj);
                    const __m256i unreachable = _mm256_cmpeq_epi64(dkj, inf4);
                    const __m256i improves = _mm256_cmpgt_epi64(dij, candidate);
                    const __m256i take = _mm256_andnot_si256(
                        unreachable, improves);
                    _mm256_maskstore_epi64(
                        reinterpret_cast<long long*>(row_i + j), take, candidate);
                }
                for (; j < end; ++j) {
                    if (row_k[j] != inf) {
                        const std::int64_t candidate = dik + row_k[j];
                        if (candidate < row_i[j]) row_i[j] = candidate;
                    }
                }
            }
        }

        static inline void cplib_warshall_floyd_relax4_dense_avx2(
                std::int64_t* __restrict__ row0,
                std::int64_t* __restrict__ row1,
                std::int64_t* __restrict__ row2,
                std::int64_t* __restrict__ row3,
                const std::int64_t* __restrict__ row_k,
                std::int64_t dik0,
                std::int64_t dik1,
                std::int64_t dik2,
                std::int64_t dik3,
                std::size_t end) {
            const __m256i dik4_0 = _mm256_set1_epi64x(dik0);
            const __m256i dik4_1 = _mm256_set1_epi64x(dik1);
            const __m256i dik4_2 = _mm256_set1_epi64x(dik2);
            const __m256i dik4_3 = _mm256_set1_epi64x(dik3);
            std::size_t j = 0;
            for (; j + 4 <= end; j += 4) {
                const __m256i dkj = _mm256_load_si256(
                    reinterpret_cast<const __m256i*>(row_k + j));
                const __m256i candidate0 = _mm256_add_epi64(dik4_0, dkj);
                const __m256i take0 = _mm256_cmpgt_epi64(
                    _mm256_load_si256(
                        reinterpret_cast<const __m256i*>(row0 + j)),
                    candidate0);
                _mm256_maskstore_epi64(
                    reinterpret_cast<long long*>(row0 + j), take0, candidate0);

                const __m256i candidate1 = _mm256_add_epi64(dik4_1, dkj);
                const __m256i take1 = _mm256_cmpgt_epi64(
                    _mm256_load_si256(
                        reinterpret_cast<const __m256i*>(row1 + j)),
                    candidate1);
                _mm256_maskstore_epi64(
                    reinterpret_cast<long long*>(row1 + j), take1, candidate1);

                const __m256i candidate2 = _mm256_add_epi64(dik4_2, dkj);
                const __m256i take2 = _mm256_cmpgt_epi64(
                    _mm256_load_si256(
                        reinterpret_cast<const __m256i*>(row2 + j)),
                    candidate2);
                _mm256_maskstore_epi64(
                    reinterpret_cast<long long*>(row2 + j), take2, candidate2);

                const __m256i candidate3 = _mm256_add_epi64(dik4_3, dkj);
                const __m256i take3 = _mm256_cmpgt_epi64(
                    _mm256_load_si256(
                        reinterpret_cast<const __m256i*>(row3 + j)),
                    candidate3);
                _mm256_maskstore_epi64(
                    reinterpret_cast<long long*>(row3 + j), take3, candidate3);
            }
            for (; j < end; ++j) {
                const std::int64_t dkj = row_k[j];
                const std::int64_t candidate0 = dik0 + dkj;
                const std::int64_t candidate1 = dik1 + dkj;
                const std::int64_t candidate2 = dik2 + dkj;
                const std::int64_t candidate3 = dik3 + dkj;
                if (candidate0 < row0[j]) row0[j] = candidate0;
                if (candidate1 < row1[j]) row1[j] = candidate1;
                if (candidate2 < row2[j]) row2[j] = candidate2;
                if (candidate3 < row3[j]) row3[j] = candidate3;
            }
        }

        template <bool check_negative = true>
        static bool cplib_warshall_floyd_int64_sparse_avx2(
                void* raw_rows,
                std::size_t n,
                std::int64_t zero,
                std::int64_t inf) {
            std::int64_t** d = static_cast<std::int64_t**>(raw_rows);
            const __m256i inf4 = _mm256_set1_epi64x(inf);
            constexpr std::size_t block_size =
                CPLIB_WARSHALL_FLOYD_BLOCK_SIZE;

            for (std::size_t i = 0; i < n; ++i) {
                if (check_negative && d[i][i] < zero) return true;
            }

            for (std::size_t kk = 0; kk < n; kk += block_size) {
                const std::size_t kend =
                    kk + block_size < n ? kk + block_size : n;

                // Phase 1: close the diagonal block.
                for (std::size_t k = kk; k < kend; ++k) {
                    const std::int64_t* const row_k = d[k];
                    const bool all_reachable =
                        cplib_warshall_floyd_all_reachable_avx2(
                            row_k, kk, kend, inf4, inf);
                    for (std::size_t i = kk; i < kend; ++i) {
                        const std::int64_t dik = d[i][k];
                        if (dik != inf) cplib_warshall_floyd_relax_avx2(
                            d[i], row_k, dik, kk, kend, inf4, inf,
                            all_reachable);
                    }
                    for (std::size_t i = kk; i < kend; ++i) {
                        if (check_negative && d[i][i] < zero) return true;
                    }
                }

                // Phase 2a: update the blocks in the diagonal block row.
                for (std::size_t jj = 0; jj < n; jj += block_size) {
                    if (jj == kk) continue;
                    const std::size_t jend =
                        jj + block_size < n ? jj + block_size : n;
                    for (std::size_t k = kk; k < kend; ++k) {
                        const std::int64_t* const row_k = d[k];
                        const bool all_reachable =
                            cplib_warshall_floyd_all_reachable_avx2(
                                row_k, jj, jend, inf4, inf);
                        for (std::size_t i = kk; i < kend; ++i) {
                            const std::int64_t dik = d[i][k];
                            if (dik != inf) cplib_warshall_floyd_relax_avx2(
                                d[i], row_k, dik, jj, jend, inf4, inf,
                                all_reachable);
                        }
                    }
                }

                // Phase 2b: update the blocks in the diagonal block column.
                for (std::size_t ii = 0; ii < n; ii += block_size) {
                    if (ii == kk) continue;
                    const std::size_t iend =
                        ii + block_size < n ? ii + block_size : n;
                    for (std::size_t k = kk; k < kend; ++k) {
                        const std::int64_t* const row_k = d[k];
                        const bool all_reachable =
                            cplib_warshall_floyd_all_reachable_avx2(
                                row_k, kk, kend, inf4, inf);
                        for (std::size_t i = ii; i < iend; ++i) {
                            const std::int64_t dik = d[i][k];
                            if (dik != inf) cplib_warshall_floyd_relax_avx2(
                                d[i], row_k, dik, kk, kend, inf4, inf,
                                all_reachable);
                        }
                    }
                }

                // Phase 3: update all remaining blocks while the three tiles
                // stay cache-resident, reusing them across the inner loops.
                for (std::size_t ii = 0; ii < n; ii += block_size) {
                    if (ii == kk) continue;
                    const std::size_t iend =
                        ii + block_size < n ? ii + block_size : n;
                    for (std::size_t jj = 0; jj < n; jj += block_size) {
                        if (jj == kk) continue;
                        const std::size_t jend =
                            jj + block_size < n ? jj + block_size : n;
                        bool reachable[block_size];
                        for (std::size_t k = kk; k < kend; ++k) {
                            const std::int64_t* const row_k = d[k];
                            reachable[k - kk] =
                                cplib_warshall_floyd_all_reachable_avx2(
                                    row_k, jj, jend, inf4, inf);
                        }
                        std::size_t i = ii;
                        for (; i + 16 <= iend; i += 16) {
                            for (std::size_t k = kk; k < kend; ++k) {
                                const std::int64_t* const row_k = d[k];
                                #pragma GCC unroll 4
                                for (std::size_t r = 0; r < 16; ++r) {
                                    const std::int64_t dik = d[i + r][k];
                                    if (dik != inf)
                                        cplib_warshall_floyd_relax_avx2(
                                            d[i + r], row_k, dik, jj, jend,
                                            inf4, inf, reachable[k - kk]);
                                }
                            }
                        }
                        for (; i < iend; ++i) {
                            for (std::size_t k = kk; k < kend; ++k) {
                                const std::int64_t* const row_k = d[k];
                                const std::int64_t dik = d[i][k];
                                if (dik != inf) cplib_warshall_floyd_relax_avx2(
                                    d[i], row_k, dik, jj, jend, inf4, inf,
                                    reachable[k - kk]);
                            }
                        }
                    }
                }

                for (std::size_t i = 0; i < n; ++i) {
                    if (check_negative && d[i][i] < zero) return true;
                }
            }
            return false;
        }

        template <bool check_negative = true>
        static bool cplib_warshall_floyd_int64_dense_tiled_avx2(
                std::int64_t** d,
                std::size_t n,
                std::int64_t zero,
                std::int64_t inf) {
            constexpr std::size_t block_size =
                CPLIB_WARSHALL_FLOYD_DENSE_BLOCK_SIZE;
            const std::size_t block_count =
                (n + block_size - 1) / block_size;
            const std::size_t padded_size = block_count * block_size;
            std::int64_t* const matrix = static_cast<std::int64_t*>(
                _mm_malloc(padded_size * padded_size * sizeof(std::int64_t), 32));
            if (matrix == nullptr) {
                return cplib_warshall_floyd_int64_sparse_avx2<check_negative>(
                    static_cast<void*>(d), n, zero, inf);
            }

            const auto tile = [&](std::size_t bi, std::size_t bj) {
                return matrix + (bi * block_count + bj) *
                    block_size * block_size;
            };

            for (std::size_t i = 0; i < n; ++i) {
                const std::size_t bi = i / block_size;
                const std::size_t local_i = i % block_size;
                for (std::size_t bj = 0; bj < block_count; ++bj) {
                    const std::size_t j_begin = bj * block_size;
                    const std::size_t j_size =
                        j_begin + block_size < n ? block_size : n - j_begin;
                    std::memcpy(
                        tile(bi, bj) + local_i * block_size,
                        d[i] + j_begin,
                        j_size * sizeof(std::int64_t));
                }
            }

            const __m256i inf4 = _mm256_set1_epi64x(inf);
            bool negative_cycle = false;
            for (std::size_t kb = 0; kb < block_count; ++kb) {
                const std::size_t k_begin = kb * block_size;
                const std::size_t k_size =
                    k_begin + block_size < n ? block_size : n - k_begin;
                std::int64_t* const diagonal = tile(kb, kb);

                for (std::size_t k = 0; k < k_size; ++k) {
                    const std::int64_t* const row_k =
                        diagonal + k * block_size;
                    for (std::size_t i = 0; i < k_size; ++i) {
                        cplib_warshall_floyd_relax_avx2(
                            diagonal + i * block_size, row_k,
                            diagonal[i * block_size + k], 0, k_size,
                            inf4, inf, true);
                    }
                    for (std::size_t i = 0; i < k_size; ++i) {
                        if (check_negative && diagonal[i * block_size + i] < zero) {
                            negative_cycle = true;
                            break;
                        }
                    }
                    if (negative_cycle) break;
                }
                if (negative_cycle) break;

                for (std::size_t jb = 0; jb < block_count; ++jb) {
                    if (jb == kb) continue;
                    const std::size_t j_begin = jb * block_size;
                    const std::size_t j_size =
                        j_begin + block_size < n ? block_size : n - j_begin;
                    std::int64_t* const top = tile(kb, jb);
                    for (std::size_t k = 0; k < k_size; ++k) {
                        const std::int64_t* const row_k = top + k * block_size;
                        for (std::size_t i = 0; i < k_size; ++i) {
                            cplib_warshall_floyd_relax_avx2(
                                top + i * block_size, row_k,
                                diagonal[i * block_size + k], 0, j_size,
                                inf4, inf, true);
                        }
                    }
                }

                for (std::size_t ib = 0; ib < block_count; ++ib) {
                    if (ib == kb) continue;
                    const std::size_t i_begin = ib * block_size;
                    const std::size_t i_size =
                        i_begin + block_size < n ? block_size : n - i_begin;
                    std::int64_t* const left = tile(ib, kb);
                    std::size_t i = 0;
                    for (; i + 16 <= i_size; i += 16) {
                        for (std::size_t k = 0; k < k_size; ++k) {
                            const std::int64_t* const row_k =
                                diagonal + k * block_size;
                            cplib_warshall_floyd_relax4_dense_avx2(
                                left + i * block_size,
                                left + (i + 1) * block_size,
                                left + (i + 2) * block_size,
                                left + (i + 3) * block_size,
                                row_k,
                                left[i * block_size + k],
                                left[(i + 1) * block_size + k],
                                left[(i + 2) * block_size + k],
                                left[(i + 3) * block_size + k],
                                k_size);
                            cplib_warshall_floyd_relax4_dense_avx2(
                                left + (i + 4) * block_size,
                                left + (i + 5) * block_size,
                                left + (i + 6) * block_size,
                                left + (i + 7) * block_size,
                                row_k,
                                left[(i + 4) * block_size + k],
                                left[(i + 5) * block_size + k],
                                left[(i + 6) * block_size + k],
                                left[(i + 7) * block_size + k],
                                k_size);
                            cplib_warshall_floyd_relax4_dense_avx2(
                                left + (i + 8) * block_size,
                                left + (i + 9) * block_size,
                                left + (i + 10) * block_size,
                                left + (i + 11) * block_size,
                                row_k,
                                left[(i + 8) * block_size + k],
                                left[(i + 9) * block_size + k],
                                left[(i + 10) * block_size + k],
                                left[(i + 11) * block_size + k],
                                k_size);
                            cplib_warshall_floyd_relax4_dense_avx2(
                                left + (i + 12) * block_size,
                                left + (i + 13) * block_size,
                                left + (i + 14) * block_size,
                                left + (i + 15) * block_size,
                                row_k,
                                left[(i + 12) * block_size + k],
                                left[(i + 13) * block_size + k],
                                left[(i + 14) * block_size + k],
                                left[(i + 15) * block_size + k],
                                k_size);
                        }
                    }
                    for (; i + 4 <= i_size; i += 4) {
                        for (std::size_t k = 0; k < k_size; ++k) {
                            const std::int64_t* const row_k =
                                diagonal + k * block_size;
                            cplib_warshall_floyd_relax4_dense_avx2(
                                left + i * block_size,
                                left + (i + 1) * block_size,
                                left + (i + 2) * block_size,
                                left + (i + 3) * block_size,
                                row_k,
                                left[i * block_size + k],
                                left[(i + 1) * block_size + k],
                                left[(i + 2) * block_size + k],
                                left[(i + 3) * block_size + k],
                                k_size);
                        }
                    }
                    for (; i < i_size; ++i) {
                        for (std::size_t k = 0; k < k_size; ++k) {
                            const std::int64_t* const row_k =
                                diagonal + k * block_size;
                            cplib_warshall_floyd_relax_avx2(
                                left + i * block_size, row_k,
                                left[i * block_size + k], 0, k_size,
                                inf4, inf, true);
                        }
                    }
                }

                for (std::size_t ib = 0; ib < block_count; ++ib) {
                    if (ib == kb) continue;
                    const std::size_t i_begin = ib * block_size;
                    const std::size_t i_size =
                        i_begin + block_size < n ? block_size : n - i_begin;
                    const std::int64_t* const left = tile(ib, kb);
                    for (std::size_t jb = 0; jb < block_count; ++jb) {
                        if (jb == kb) continue;
                        const std::size_t j_begin = jb * block_size;
                        const std::size_t j_size =
                            j_begin + block_size < n ? block_size : n - j_begin;
                        const std::int64_t* const top = tile(kb, jb);
                        std::int64_t* const output = tile(ib, jb);
                        std::size_t i = 0;
                        for (; i + 16 <= i_size; i += 16) {
                            for (std::size_t k = 0; k < k_size; ++k) {
                                const std::int64_t* const row_k =
                                    top + k * block_size;
                                cplib_warshall_floyd_relax4_dense_avx2(
                                    output + i * block_size,
                                    output + (i + 1) * block_size,
                                    output + (i + 2) * block_size,
                                    output + (i + 3) * block_size,
                                    row_k,
                                    left[i * block_size + k],
                                    left[(i + 1) * block_size + k],
                                    left[(i + 2) * block_size + k],
                                    left[(i + 3) * block_size + k],
                                    j_size);
                                cplib_warshall_floyd_relax4_dense_avx2(
                                    output + (i + 4) * block_size,
                                    output + (i + 5) * block_size,
                                    output + (i + 6) * block_size,
                                    output + (i + 7) * block_size,
                                    row_k,
                                    left[(i + 4) * block_size + k],
                                    left[(i + 5) * block_size + k],
                                    left[(i + 6) * block_size + k],
                                    left[(i + 7) * block_size + k],
                                    j_size);
                                cplib_warshall_floyd_relax4_dense_avx2(
                                    output + (i + 8) * block_size,
                                    output + (i + 9) * block_size,
                                    output + (i + 10) * block_size,
                                    output + (i + 11) * block_size,
                                    row_k,
                                    left[(i + 8) * block_size + k],
                                    left[(i + 9) * block_size + k],
                                    left[(i + 10) * block_size + k],
                                    left[(i + 11) * block_size + k],
                                    j_size);
                                cplib_warshall_floyd_relax4_dense_avx2(
                                    output + (i + 12) * block_size,
                                    output + (i + 13) * block_size,
                                    output + (i + 14) * block_size,
                                    output + (i + 15) * block_size,
                                    row_k,
                                    left[(i + 12) * block_size + k],
                                    left[(i + 13) * block_size + k],
                                    left[(i + 14) * block_size + k],
                                    left[(i + 15) * block_size + k],
                                    j_size);
                            }
                        }
                        for (; i + 4 <= i_size; i += 4) {
                            for (std::size_t k = 0; k < k_size; ++k) {
                                const std::int64_t* const row_k =
                                    top + k * block_size;
                                cplib_warshall_floyd_relax4_dense_avx2(
                                    output + i * block_size,
                                    output + (i + 1) * block_size,
                                    output + (i + 2) * block_size,
                                    output + (i + 3) * block_size,
                                    row_k,
                                    left[i * block_size + k],
                                    left[(i + 1) * block_size + k],
                                    left[(i + 2) * block_size + k],
                                    left[(i + 3) * block_size + k],
                                    j_size);
                            }
                        }
                        for (; i < i_size; ++i) {
                            for (std::size_t k = 0; k < k_size; ++k) {
                                const std::int64_t* const row_k =
                                    top + k * block_size;
                                cplib_warshall_floyd_relax_avx2(
                                    output + i * block_size, row_k,
                                    left[i * block_size + k], 0, j_size,
                                    inf4, inf, true);
                            }
                        }
                    }
                }
            }

            for (std::size_t i = 0; i < n; ++i) {
                const std::size_t bi = i / block_size;
                const std::size_t local_i = i % block_size;
                for (std::size_t bj = 0; bj < block_count; ++bj) {
                    const std::size_t j_begin = bj * block_size;
                    const std::size_t j_size =
                        j_begin + block_size < n ? block_size : n - j_begin;
                    std::memcpy(
                        d[i] + j_begin,
                        tile(bi, bj) + local_i * block_size,
                        j_size * sizeof(std::int64_t));
                }
            }
            _mm_free(matrix);
            return negative_cycle;
        }

        template <bool check_negative = true>
        static bool cplib_warshall_floyd_int64_avx2(
                void* raw_rows,
                std::size_t n,
                std::int64_t zero,
                std::int64_t inf) {
            std::int64_t** d = static_cast<std::int64_t**>(raw_rows);
            const __m256i inf4 = _mm256_set1_epi64x(inf);
            bool dense = true;
            for (std::size_t i = 0; i < n && dense; ++i) {
                dense = cplib_warshall_floyd_all_reachable_avx2(
                    d[i], 0, n, inf4, inf);
            }
            if (dense) {
                return cplib_warshall_floyd_int64_dense_tiled_avx2<check_negative>(
                    d, n, zero, inf);
            }
            return cplib_warshall_floyd_int64_sparse_avx2<check_negative>(
                raw_rows, n, zero, inf);
        }

        static inline void cplib_warshall_floyd_relax_int32_avx2(
                std::int32_t* row_i,
                const std::int32_t* row_k,
                std::int32_t dik,
                std::size_t begin,
                std::size_t end,
                __m256i inf8,
                std::int32_t inf) {
            const __m256i dik8 = _mm256_set1_epi32(dik);
            std::size_t j = begin;
            for (; j + 8 <= end; j += 8) {
                const __m256i dkj = _mm256_loadu_si256(
                    reinterpret_cast<const __m256i*>(row_k + j));
                const __m256i dij = _mm256_loadu_si256(
                    reinterpret_cast<const __m256i*>(row_i + j));
                const __m256i candidate = _mm256_add_epi32(dik8, dkj);
                const __m256i unreachable = _mm256_cmpeq_epi32(dkj, inf8);
                const __m256i minimum = _mm256_min_epi32(dij, candidate);
                const __m256i updated = _mm256_blendv_epi8(
                    minimum, dij, unreachable);
                _mm256_storeu_si256(
                    reinterpret_cast<__m256i*>(row_i + j), updated);
            }
            for (; j < end; ++j) {
                if (row_k[j] != inf) {
                    const std::int32_t candidate = dik + row_k[j];
                    if (candidate < row_i[j]) row_i[j] = candidate;
                }
            }
        }

        template <bool check_negative = true>
        static bool cplib_warshall_floyd_int32_avx2(
                void* raw_rows,
                std::size_t n,
                std::int32_t zero,
                std::int32_t inf) {
            std::int32_t** d = static_cast<std::int32_t**>(raw_rows);
            const __m256i inf8 = _mm256_set1_epi32(inf);
            constexpr std::size_t block_size =
                CPLIB_WARSHALL_FLOYD_INT32_BLOCK_SIZE;

            for (std::size_t i = 0; i < n; ++i) {
                if (check_negative && d[i][i] < zero) return true;
            }

            for (std::size_t kk = 0; kk < n; kk += block_size) {
                const std::size_t kend =
                    kk + block_size < n ? kk + block_size : n;

                // Phase 1: close the diagonal block.
                for (std::size_t k = kk; k < kend; ++k) {
                    const std::int32_t* const row_k = d[k];
                    for (std::size_t i = kk; i < kend; ++i) {
                        const std::int32_t dik = d[i][k];
                        if (dik != inf) cplib_warshall_floyd_relax_int32_avx2(
                            d[i], row_k, dik, kk, kend, inf8, inf);
                    }
                    for (std::size_t i = kk; i < kend; ++i) {
                        if (check_negative && d[i][i] < zero) return true;
                    }
                }

                // Phase 2a: update the blocks in the diagonal block row.
                for (std::size_t jj = 0; jj < n; jj += block_size) {
                    if (jj == kk) continue;
                    const std::size_t jend =
                        jj + block_size < n ? jj + block_size : n;
                    for (std::size_t k = kk; k < kend; ++k) {
                        const std::int32_t* const row_k = d[k];
                        for (std::size_t i = kk; i < kend; ++i) {
                            const std::int32_t dik = d[i][k];
                            if (dik != inf) cplib_warshall_floyd_relax_int32_avx2(
                                d[i], row_k, dik, jj, jend, inf8, inf);
                        }
                    }
                }

                // Phase 2b: update the blocks in the diagonal block column.
                for (std::size_t ii = 0; ii < n; ii += block_size) {
                    if (ii == kk) continue;
                    const std::size_t iend =
                        ii + block_size < n ? ii + block_size : n;
                    for (std::size_t k = kk; k < kend; ++k) {
                        const std::int32_t* const row_k = d[k];
                        for (std::size_t i = ii; i < iend; ++i) {
                            const std::int32_t dik = d[i][k];
                            if (dik != inf) cplib_warshall_floyd_relax_int32_avx2(
                                d[i], row_k, dik, kk, kend, inf8, inf);
                        }
                    }
                }

                // Phase 3: update all remaining cache-resident tiles.
                for (std::size_t ii = 0; ii < n; ii += block_size) {
                    if (ii == kk) continue;
                    const std::size_t iend =
                        ii + block_size < n ? ii + block_size : n;
                    for (std::size_t jj = 0; jj < n; jj += block_size) {
                        if (jj == kk) continue;
                        const std::size_t jend =
                            jj + block_size < n ? jj + block_size : n;
                        for (std::size_t k = kk; k < kend; ++k) {
                            const std::int32_t* const row_k = d[k];
                            for (std::size_t i = ii; i < iend; ++i) {
                                const std::int32_t dik = d[i][k];
                                if (dik != inf) cplib_warshall_floyd_relax_int32_avx2(
                                    d[i], row_k, dik, jj, jend, inf8, inf);
                            }
                        }
                    }
                }

                for (std::size_t i = 0; i < n; ++i) {
                    if (check_negative && d[i][i] < zero) return true;
                }
            }
            return false;
        }

        #pragma GCC pop_options

        #pragma GCC push_options
        #pragma GCC target("avx512f")
        #pragma GCC optimize("O3")

        static inline void cplib_warshall_floyd_relax_avx512(
                std::int64_t* row_i,
                const std::int64_t* row_k,
                std::int64_t dik,
                std::size_t begin,
                std::size_t end,
                std::int64_t inf) {
            // 到達不能な頂点を除外して8要素ずつ緩和する。O(end - begin)。
            const __m512i dikv = _mm512_set1_epi64(dik);
            const __m512i infv = _mm512_set1_epi64(inf);
            std::size_t j = begin;
            for (; j + 8 <= end; j += 8) {
                const __m512i dkj = _mm512_loadu_si512(row_k + j);
                const __m512i dij = _mm512_loadu_si512(row_i + j);
                const __m512i candidate = _mm512_add_epi64(dikv, dkj);
                const __mmask8 take = _mm512_cmpneq_epi64_mask(dkj, infv) &
                    _mm512_cmplt_epi64_mask(candidate, dij);
                _mm512_mask_storeu_epi64(row_i + j, take, candidate);
            }
            for (; j < end; ++j) {
                if (row_k[j] != inf) {
                    const std::int64_t candidate = dik + row_k[j];
                    if (candidate < row_i[j]) row_i[j] = candidate;
                }
            }
        }

        static inline void cplib_warshall_floyd_relax_avx512(
                std::int32_t* row_i,
                const std::int32_t* row_k,
                std::int32_t dik,
                std::size_t begin,
                std::size_t end,
                std::int32_t inf) {
            // 到達不能な頂点を除外して16要素ずつ緩和する。O(end - begin)。
            const __m512i dikv = _mm512_set1_epi32(dik);
            const __m512i infv = _mm512_set1_epi32(inf);
            std::size_t j = begin;
            for (; j + 16 <= end; j += 16) {
                const __m512i dkj = _mm512_loadu_si512(row_k + j);
                const __m512i dij = _mm512_loadu_si512(row_i + j);
                const __m512i candidate = _mm512_add_epi32(dikv, dkj);
                const __mmask16 take = _mm512_cmpneq_epi32_mask(dkj, infv) &
                    _mm512_cmplt_epi32_mask(candidate, dij);
                _mm512_mask_storeu_epi32(row_i + j, take, candidate);
            }
            for (; j < end; ++j) {
                if (row_k[j] != inf) {
                    const std::int32_t candidate = dik + row_k[j];
                    if (candidate < row_i[j]) row_i[j] = candidate;
                }
            }
        }

        template <typename T, std::size_t block_size, bool check_negative = true>
        static bool cplib_warshall_floyd_blocked_avx512(
                void* raw_rows, std::size_t n, T zero, T inf) {
            // ブロック分割した全点対最短路を求める。check_negativeで負閉路検査を切り替える。O(n^3)。
            T** d = static_cast<T**>(raw_rows);
            for (std::size_t i = 0; i < n; ++i) {
                if (check_negative && d[i][i] < zero) return true;
            }
            for (std::size_t kk = 0; kk < n; kk += block_size) {
                const std::size_t kend =
                    kk + block_size < n ? kk + block_size : n;
                const auto relax_tile = [&](std::size_t ib, std::size_t ie,
                                            std::size_t jb, std::size_t je,
                                            bool diagonal) {
                    // 指定したタイルを更新し、対角タイルでは各段階で負閉路を調べる。
                    for (std::size_t k = kk; k < kend; ++k) {
                        for (std::size_t i = ib; i < ie; ++i) {
                            const T dik = d[i][k];
                            if (dik != inf) cplib_warshall_floyd_relax_avx512(
                                d[i], d[k], dik, jb, je, inf);
                        }
                        if (check_negative && diagonal) {
                            for (std::size_t i = ib; i < ie; ++i) {
                                if (check_negative && d[i][i] < zero) return true;
                            }
                        }
                    }
                    return false;
                };
                if (relax_tile(kk, kend, kk, kend, true)) return true;
                for (std::size_t jj = 0; jj < n; jj += block_size) {
                    if (jj == kk) continue;
                    const std::size_t jend =
                        jj + block_size < n ? jj + block_size : n;
                    relax_tile(kk, kend, jj, jend, false);
                }
                for (std::size_t ii = 0; ii < n; ii += block_size) {
                    if (ii == kk) continue;
                    const std::size_t iend =
                        ii + block_size < n ? ii + block_size : n;
                    relax_tile(ii, iend, kk, kend, false);
                }
                for (std::size_t ii = 0; ii < n; ii += block_size) {
                    if (ii == kk) continue;
                    const std::size_t iend =
                        ii + block_size < n ? ii + block_size : n;
                    for (std::size_t jj = 0; jj < n; jj += block_size) {
                        if (jj == kk) continue;
                        const std::size_t jend =
                            jj + block_size < n ? jj + block_size : n;
                        relax_tile(ii, iend, jj, jend, false);
                    }
                }
                for (std::size_t i = 0; i < n; ++i) {
                    if (check_negative && d[i][i] < zero) return true;
                }
            }
            return false;
        }

        #pragma GCC pop_options

        extern "C" bool cplib_warshall_floyd_int64_avx(
                void* raw_rows, std::size_t n,
                std::int64_t zero, std::int64_t inf) {
            // CPU・OSがAVX-512に対応していなければAVX2版を使用する。O(n^3)。
            if (__builtin_cpu_supports("avx512f")) {
                return cplib_warshall_floyd_blocked_avx512<
                    std::int64_t, CPLIB_WARSHALL_FLOYD_BLOCK_SIZE>(
                        raw_rows, n, zero, inf);
            }
            return cplib_warshall_floyd_int64_avx2(raw_rows, n, zero, inf);
        }

        extern "C" bool cplib_warshall_floyd_int32_avx(
                void* raw_rows, std::size_t n,
                std::int32_t zero, std::int32_t inf) {
            // CPU・OSがAVX-512に対応していなければAVX2版を使用する。O(n^3)。
            if (__builtin_cpu_supports("avx512f")) {
                return cplib_warshall_floyd_blocked_avx512<
                    std::int32_t, CPLIB_WARSHALL_FLOYD_INT32_BLOCK_SIZE>(
                        raw_rows, n, zero, inf);
            }
            return cplib_warshall_floyd_int32_avx2(raw_rows, n, zero, inf);
        }

        extern "C" void cplib_warshall_floyd_nonnegative_int64_avx(
                void* raw_rows, std::size_t n,
                std::int64_t zero, std::int64_t inf) {
            // 非負辺の全点対最短路を負閉路検査なしで求める。AVX-512非対応時はAVX2。O(n^3)。
            if (__builtin_cpu_supports("avx512f")) {
                cplib_warshall_floyd_blocked_avx512<
                    std::int64_t, CPLIB_WARSHALL_FLOYD_BLOCK_SIZE, false>(
                        raw_rows, n, zero, inf);
            } else {
                cplib_warshall_floyd_int64_avx2<false>(raw_rows, n, zero, inf);
            }
        }

        extern "C" void cplib_warshall_floyd_nonnegative_int32_avx(
                void* raw_rows, std::size_t n,
                std::int32_t zero, std::int32_t inf) {
            // 非負辺の全点対最短路を負閉路検査なしで求める。AVX-512非対応時はAVX2。O(n^3)。
            if (__builtin_cpu_supports("avx512f")) {
                cplib_warshall_floyd_blocked_avx512<
                    std::int32_t, CPLIB_WARSHALL_FLOYD_INT32_BLOCK_SIZE, false>(
                        raw_rows, n, zero, inf);
            } else {
                cplib_warshall_floyd_int32_avx2<false>(raw_rows, n, zero, inf);
            }
        }

        #endif
        """.}

        proc warshallFloydInt64Avx(
            rows: pointer,
            n: csize_t,
            zero, inf: int
        ): bool {.importc: "cplib_warshall_floyd_int64_avx".}

        proc warshallFloydInt32Avx(
            rows: pointer,
            n: csize_t,
            zero, inf: int32
        ): bool {.importc: "cplib_warshall_floyd_int32_avx".}

        proc warshallFloydNonnegativeInt64Avx(
            rows: pointer, n: csize_t, zero, inf: int
        ) {.importc: "cplib_warshall_floyd_nonnegative_int64_avx".}
            ## 非負辺の距離行列をSIMDで更新する。O(V^3)。

        proc warshallFloydNonnegativeInt32Avx(
            rows: pointer, n: csize_t, zero, inf: int32
        ) {.importc: "cplib_warshall_floyd_nonnegative_int32_avx".}
            ## 非負辺の距離行列をSIMDで更新する。O(V^3)。

    proc warshall_floyd_impl[T](g: WeightedGraph[T] or UnWeightedGraph, zero, inf: T): tuple[negative_cycle: bool, d: seq[seq[T]]] =
        var d = newSeqWith(g.len, newSeqWith(g.len, inf))
        for i in 0..<g.len: d[i][i] = zero
        for i in 0..<g.len:
            for (j, cost) in g.to_and_cost(i):
                d[i][j] = min(d[i][j], cost)
        for k in 0..<g.len:
            for i in 0..<g.len:
                for j in 0..<g.len:
                    if d[i][k] != inf and d[k][j] != inf:
                        d[i][j] = min(d[i][j], d[i][k] + d[k][j])
            for i in 0..<g.len:
                if d[i][i] < zero: return (negative_cycle: true, d: d)
        return (negative_cycle: false, d: d)

    proc warshall_floyd*(g: DynamicGraph[int] or StaticGraph[int] or UnWeightedGraph, zero: int = 0, inf: int = INF64): tuple[negative_cycle: bool, d: seq[seq[int]]] =
        ## 全点対最短路をO(V^3)で求める。C++ではAVX-512F対応時にAVX-512、非対応時にAVX2を使う。
        when defined(cpp) and sizeof(int) == 8:
            var d = newSeqWith(g.len, newSeqWith(g.len, inf))
            for i in 0..<g.len: d[i][i] = zero
            for i in 0..<g.len:
                for (j, cost) in g.to_and_cost(i):
                    d[i][j] = min(d[i][j], cost)

            if g.len == 0:
                return (negative_cycle: false, d: d)

            var rows = newSeq[ptr int](g.len)
            for i in 0..<g.len:
                rows[i] = addr d[i][0]
            let negativeCycle = warshallFloydInt64Avx(
                cast[pointer](addr rows[0]), g.len.csize_t, zero, inf)
            return (negative_cycle: negativeCycle, d: d)
        else:
            return warshall_floyd_impl(g, zero, inf)
    proc warshall_floyd*(g: DynamicGraph[int32] or StaticGraph[int32], zero: int32 = 0.int32, inf: int32 = INF32): tuple[negative_cycle: bool, d: seq[seq[int32]]] =
        ## 全点対最短路をO(V^3)で求める。C++ではAVX-512F対応時にAVX-512、非対応時にAVX2を使う。
        when defined(cpp) and sizeof(int) == 8:
            var d = newSeqWith(g.len, newSeqWith(g.len, inf))
            for i in 0..<g.len: d[i][i] = zero
            for i in 0..<g.len:
                for (j, cost) in g.to_and_cost(i):
                    d[i][j] = min(d[i][j], cost)

            if g.len == 0:
                return (negative_cycle: false, d: d)

            var rows = newSeq[ptr int32](g.len)
            for i in 0..<g.len:
                rows[i] = addr d[i][0]
            let negativeCycle = warshallFloydInt32Avx(
                cast[pointer](addr rows[0]), g.len.csize_t, zero, inf)
            return (negative_cycle: negativeCycle, d: d)
        else:
            return warshall_floyd_impl(g, zero, inf)
    proc warshall_floyd*(g: DynamicGraph[float] or StaticGraph[float], zero: float = 0.0, inf: float = 1e100): tuple[negative_cycle: bool, d: seq[seq[float]]] = warshall_floyd_impl(g, zero, inf)
    proc warshall_floyd*(g: DynamicGraph[float32] or StaticGraph[float32], zero: float32 = 0.0'f32, inf: float32 = 1e30'f32): tuple[negative_cycle: bool, d: seq[seq[float32]]] = warshall_floyd_impl(g, zero, inf)
    proc warshall_floyd*[T](g: WeightedGraph[T] or UnWeightedGraph, zero, inf: T): tuple[negative_cycle: bool, d: seq[seq[T]]] = warshall_floyd_impl(g, zero, inf)

    proc warshall_floyd_inplace_impl[T](d: var seq[seq[T]], zero, inf: T): bool =
        ## 正方隣接行列を最短距離で上書きし、負閉路の有無を返す。O(V^3)。負閉路検出時は途中の行列を残す。
        let n = d.len
        for i in 0..<n:
            assert d[i].len == n, "隣接行列は正方行列である必要があります"
        for i in 0..<n:
            d[i][i] = min(d[i][i], zero)
        for i in 0..<n:
            if d[i][i] < zero:
                return true
        when defined(cpp) and sizeof(int) == 8 and (T is int or T is int32):
            if n == 0:
                return false
            var rows = newSeq[ptr T](n)
            for i in 0..<n:
                rows[i] = addr d[i][0]
            when T is int:
                let negativeCycle = warshallFloydInt64Avx(
                    cast[pointer](addr rows[0]), n.csize_t, zero, inf)
            else:
                let negativeCycle = warshallFloydInt32Avx(
                    cast[pointer](addr rows[0]), n.csize_t, zero, inf)
            return negativeCycle
        else:
            for k in 0..<n:
                for i in 0..<n:
                    for j in 0..<n:
                        if d[i][k] != inf and d[k][j] != inf:
                            d[i][j] = min(d[i][j], d[i][k] + d[k][j])
                for i in 0..<n:
                    if d[i][i] < zero:
                        return true
            return false

    proc warshall_floyd_matrix_impl[T](a: seq[seq[T]], zero, inf: T): tuple[negative_cycle: bool, d: seq[seq[T]]] =
        ## 正方隣接行列から全点対最短路を求める。時間O(V^3)、追加領域O(V^2)。入力は変更しない。
        var d = newSeqWith(a.len, newSeqWith(a.len, inf))
        for i in 0..<a.len:
            assert a[i].len == a.len, "隣接行列は正方行列である必要があります"
            for j in 0..<a.len:
                d[i][j] = a[i][j]
        let negativeCycle = warshall_floyd_inplace_impl(d, zero, inf)
        return (negative_cycle: negativeCycle, d: d)

    proc warshall_floyd*(a: seq[seq[int]], zero: int = 0, inf: int = INF64): tuple[negative_cycle: bool, d: seq[seq[int]]] =
        ## 隣接行列から全点対最短路をO(V^3)で求める。辺なしはinf、対角はmin(入力値, zero)。入力は変更しない。
        return warshall_floyd_matrix_impl(a, zero, inf)

    proc warshall_floyd*(a: seq[seq[int32]], zero: int32 = 0.int32, inf: int32 = INF32): tuple[negative_cycle: bool, d: seq[seq[int32]]] =
        ## 隣接行列から全点対最短路をO(V^3)で求める。辺なしはinf、対角はmin(入力値, zero)。入力は変更しない。
        return warshall_floyd_matrix_impl(a, zero, inf)

    proc warshall_floyd*(a: seq[seq[float]], zero: float = 0.0, inf: float = 1e100): tuple[negative_cycle: bool, d: seq[seq[float]]] =
        ## 隣接行列から全点対最短路をO(V^3)で求める。辺なしはinf、対角はmin(入力値, zero)。入力は変更しない。
        return warshall_floyd_matrix_impl(a, zero, inf)

    proc warshall_floyd*(a: seq[seq[float32]], zero: float32 = 0.0'f32, inf: float32 = 1e30'f32): tuple[negative_cycle: bool, d: seq[seq[float32]]] =
        ## 隣接行列から全点対最短路をO(V^3)で求める。辺なしはinf、対角はmin(入力値, zero)。入力は変更しない。
        return warshall_floyd_matrix_impl(a, zero, inf)

    proc warshall_floyd*[T](a: seq[seq[T]], zero, inf: T): tuple[negative_cycle: bool, d: seq[seq[T]]] =
        ## 隣接行列から全点対最短路をO(V^3)で求める。辺なしはinf、対角はmin(入力値, zero)。入力は変更しない。
        return warshall_floyd_matrix_impl(a, zero, inf)

    proc warshall_floyd_nonnegative_run[T](d: var seq[seq[T]], zero, inf: T) =
        ## 非負辺を前提に、負閉路検査なしで距離行列を更新する。O(V^3)。
        when defined(cpp) and sizeof(int) == 8 and (T is int or T is int32):
            if d.len == 0: return
            var rows = newSeq[ptr T](d.len)
            for i in 0..<d.len:
                rows[i] = addr d[i][0]
            when T is int:
                warshallFloydNonnegativeInt64Avx(
                    cast[pointer](addr rows[0]), d.len.csize_t, zero, inf)
            else:
                warshallFloydNonnegativeInt32Avx(
                    cast[pointer](addr rows[0]), d.len.csize_t, zero, inf)
        else:
            for k in 0..<d.len:
                for i in 0..<d.len:
                    if d[i][k] != inf:
                        for j in 0..<d.len:
                            if d[k][j] != inf:
                                d[i][j] = min(d[i][j], d[i][k] + d[k][j])

    proc warshall_floyd_nonnegative_impl[T](g: WeightedGraph[T] or UnWeightedGraph, zero, inf: T): seq[seq[T]] =
        ## 非負辺のグラフから距離行列を求める。時間O(V^3)、追加領域O(V^2)。
        result = newSeqWith(g.len, newSeqWith(g.len, inf))
        for i in 0..<g.len:
            result[i][i] = zero
            for (j, cost) in g.to_and_cost(i):
                result[i][j] = min(result[i][j], cost)
        warshall_floyd_nonnegative_run(result, zero, inf)

    proc warshall_floyd_nonnegative_inplace_impl[T](d: var seq[seq[T]], zero, inf: T) =
        ## 負閉路がない正方隣接行列を最短距離で上書きする。O(V^3)。負辺も許容し、負閉路検査は行わない。
        for i in 0..<d.len:
            assert d[i].len == d.len, "隣接行列は正方行列である必要があります"
        for i in 0..<d.len:
            d[i][i] = zero
        warshall_floyd_nonnegative_run(d, zero, inf)

    proc warshall_floyd_nonnegative_impl[T](a: seq[seq[T]], zero, inf: T): seq[seq[T]] =
        ## 非負辺の正方隣接行列から距離行列を求める。時間O(V^3)、追加領域O(V^2)。入力は変更しない。
        result = newSeqWith(a.len, newSeqWith(a.len, inf))
        for i in 0..<a.len:
            assert a[i].len == a.len, "隣接行列は正方行列である必要があります"
            for j in 0..<a.len:
                result[i][j] = a[i][j]
        warshall_floyd_nonnegative_inplace_impl(result, zero, inf)

    proc warshall_floyd_nonnegative*(g: DynamicGraph[int] or StaticGraph[int] or UnWeightedGraph or seq[seq[int]], zero: int = 0, inf: int = INF64): seq[seq[int]] =
        ## 非負辺の全点対最短路dをO(V^3)で返す。辺なしはinf、対角はzero。入力は変更しない。
        return warshall_floyd_nonnegative_impl(g, zero, inf)

    proc warshall_floyd_nonnegative*(g: DynamicGraph[int32] or StaticGraph[int32] or seq[seq[int32]], zero: int32 = 0.int32, inf: int32 = INF32): seq[seq[int32]] =
        ## 非負辺の全点対最短路dをO(V^3)で返す。辺なしはinf、対角はzero。入力は変更しない。
        return warshall_floyd_nonnegative_impl(g, zero, inf)

    proc warshall_floyd_nonnegative*(g: DynamicGraph[float] or StaticGraph[float] or seq[seq[float]], zero: float = 0.0, inf: float = 1e100): seq[seq[float]] =
        ## 非負辺の全点対最短路dをO(V^3)で返す。辺なしはinf、対角はzero。入力は変更しない。
        return warshall_floyd_nonnegative_impl(g, zero, inf)

    proc warshall_floyd_nonnegative*(g: DynamicGraph[float32] or StaticGraph[float32] or seq[seq[float32]], zero: float32 = 0.0'f32, inf: float32 = 1e30'f32): seq[seq[float32]] =
        ## 非負辺の全点対最短路dをO(V^3)で返す。辺なしはinf、対角はzero。入力は変更しない。
        return warshall_floyd_nonnegative_impl(g, zero, inf)

    proc warshall_floyd_nonnegative*[T](g: WeightedGraph[T] or UnWeightedGraph or seq[seq[T]], zero, inf: T): seq[seq[T]] =
        ## 非負辺の全点対最短路dをO(V^3)で返す。辺なしはinf、対角はzero。入力は変更しない。
        return warshall_floyd_nonnegative_impl(g, zero, inf)

    proc warshall_floyd_inplace*(d: var seq[seq[int]], zero: int = 0, inf: int = INF64): bool =
        ## 隣接行列をO(V^3)で最短距離に上書きし、負閉路があればtrueを返す。辺なしはinf、対角はmin(入力値, zero)。
        return warshall_floyd_inplace_impl(d, zero, inf)

    proc warshall_floyd_inplace*(d: var seq[seq[int32]], zero: int32 = 0.int32, inf: int32 = INF32): bool =
        ## 隣接行列をO(V^3)で最短距離に上書きし、負閉路があればtrueを返す。辺なしはinf、対角はmin(入力値, zero)。
        return warshall_floyd_inplace_impl(d, zero, inf)

    proc warshall_floyd_inplace*(d: var seq[seq[float]], zero: float = 0.0, inf: float = 1e100): bool =
        ## 隣接行列をO(V^3)で最短距離に上書きし、負閉路があればtrueを返す。辺なしはinf、対角はmin(入力値, zero)。
        return warshall_floyd_inplace_impl(d, zero, inf)

    proc warshall_floyd_inplace*(d: var seq[seq[float32]], zero: float32 = 0.0'f32, inf: float32 = 1e30'f32): bool =
        ## 隣接行列をO(V^3)で最短距離に上書きし、負閉路があればtrueを返す。辺なしはinf、対角はmin(入力値, zero)。
        return warshall_floyd_inplace_impl(d, zero, inf)

    proc warshall_floyd_inplace*[T](d: var seq[seq[T]], zero, inf: T): bool =
        ## 隣接行列をO(V^3)で最短距離に上書きし、負閉路があればtrueを返す。辺なしはinf、対角はmin(入力値, zero)。
        return warshall_floyd_inplace_impl(d, zero, inf)

    proc warshall_floyd_nonnegative_inplace*(d: var seq[seq[int]], zero: int = 0, inf: int = INF64) =
        ## 負閉路がない隣接行列をO(V^3)で最短距離に上書きする。辺なしはinf、対角はzero。負辺も許容する。
        warshall_floyd_nonnegative_inplace_impl(d, zero, inf)

    proc warshall_floyd_nonnegative_inplace*(d: var seq[seq[int32]], zero: int32 = 0.int32, inf: int32 = INF32) =
        ## 負閉路がない隣接行列をO(V^3)で最短距離に上書きする。辺なしはinf、対角はzero。負辺も許容する。
        warshall_floyd_nonnegative_inplace_impl(d, zero, inf)

    proc warshall_floyd_nonnegative_inplace*(d: var seq[seq[float]], zero: float = 0.0, inf: float = 1e100) =
        ## 負閉路がない隣接行列をO(V^3)で最短距離に上書きする。辺なしはinf、対角はzero。負辺も許容する。
        warshall_floyd_nonnegative_inplace_impl(d, zero, inf)

    proc warshall_floyd_nonnegative_inplace*(d: var seq[seq[float32]], zero: float32 = 0.0'f32, inf: float32 = 1e30'f32) =
        ## 負閉路がない隣接行列をO(V^3)で最短距離に上書きする。辺なしはinf、対角はzero。負辺も許容する。
        warshall_floyd_nonnegative_inplace_impl(d, zero, inf)

    proc warshall_floyd_nonnegative_inplace*[T](d: var seq[seq[T]], zero, inf: T) =
        ## 負閉路がない隣接行列をO(V^3)で最短距離に上書きする。辺なしはinf、対角はzero。負辺も許容する。
        warshall_floyd_nonnegative_inplace_impl(d, zero, inf)
