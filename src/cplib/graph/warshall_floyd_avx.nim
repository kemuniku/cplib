when not declared CPLIB_GRAPH_WARSHALLFLOYD:
    const CPLIB_GRAPH_WARSHALLFLOYD* = 1
    import cplib/graph/graph
    import cplib/utils/constants
    import sequtils
    import cplib/graph/warshall_floyd_negative

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

        static bool cplib_warshall_floyd_exact_double_avx2(
                std::int64_t** d, std::size_t n, std::int64_t inf) {
            // 負閉路のない整数距離を誤差なくdoubleで計算する。時間O(n^3)、追加領域O(n^2)。
            constexpr std::size_t B = 128;
            const std::size_t count = (n + B - 1) / B;
            double* matrix = static_cast<double*>(
                _mm_malloc(count * count * B * B * sizeof(double), 32));
            if (matrix == nullptr) return false;
            const auto tile = [&](std::size_t i, std::size_t j) {
                return matrix + (i * count + j) * B * B;
            };
            for (std::size_t bi = 0; bi < count; ++bi)
                for (std::size_t bj = 0; bj < count; ++bj)
                    for (std::size_t i = 0; i < B; ++i)
                        for (std::size_t j = 0; j < B; ++j) {
                            const std::size_t row = bi * B + i;
                            const std::size_t col = bj * B + j;
                            tile(bi, bj)[i * B + j] =
                                row < n && col < n && d[row][col] != inf
                                    ? static_cast<double>(d[row][col])
                                    : __builtin_inf();
                        }
            const auto relax = [&](double* out, const double* left, const double* top) {
                // 依存のある対角・行・列タイルはkの順に更新する。
                for (std::size_t k = 0; k < B; ++k)
                    for (std::size_t i = 0; i < B; ++i) {
                        const __m256d a = _mm256_set1_pd(left[i * B + k]);
                        for (std::size_t j = 0; j < B; j += 4)
                            _mm256_store_pd(out + i * B + j, _mm256_min_pd(
                                _mm256_load_pd(out + i * B + j),
                                _mm256_add_pd(a, _mm256_load_pd(top + k * B + j))));
                    }
            };
            const auto product = [&](double* out, const double* left, const double* top) {
                // 独立なタイルでは4行8列をレジスタに保持する。
                for (std::size_t i = 0; i < B; i += 4)
                    for (std::size_t j = 0; j < B; j += 8) {
                        __m256d v00 = _mm256_load_pd(out + (i + 0) * B + j + 0);
                        __m256d v01 = _mm256_load_pd(out + (i + 0) * B + j + 4);
                        __m256d v10 = _mm256_load_pd(out + (i + 1) * B + j + 0);
                        __m256d v11 = _mm256_load_pd(out + (i + 1) * B + j + 4);
                        __m256d v20 = _mm256_load_pd(out + (i + 2) * B + j + 0);
                        __m256d v21 = _mm256_load_pd(out + (i + 2) * B + j + 4);
                        __m256d v30 = _mm256_load_pd(out + (i + 3) * B + j + 0);
                        __m256d v31 = _mm256_load_pd(out + (i + 3) * B + j + 4);
                        for (std::size_t k = 0; k < B; ++k) {
                            const __m256d b0 = _mm256_load_pd(top + k * B + j + 0);
                            const __m256d b1 = _mm256_load_pd(top + k * B + j + 4);
                            const __m256d a0 = _mm256_set1_pd(left[(i + 0) * B + k]);
                            v00 = _mm256_min_pd(v00, _mm256_add_pd(a0, b0));
                            v01 = _mm256_min_pd(v01, _mm256_add_pd(a0, b1));
                            const __m256d a1 = _mm256_set1_pd(left[(i + 1) * B + k]);
                            v10 = _mm256_min_pd(v10, _mm256_add_pd(a1, b0));
                            v11 = _mm256_min_pd(v11, _mm256_add_pd(a1, b1));
                            const __m256d a2 = _mm256_set1_pd(left[(i + 2) * B + k]);
                            v20 = _mm256_min_pd(v20, _mm256_add_pd(a2, b0));
                            v21 = _mm256_min_pd(v21, _mm256_add_pd(a2, b1));
                            const __m256d a3 = _mm256_set1_pd(left[(i + 3) * B + k]);
                            v30 = _mm256_min_pd(v30, _mm256_add_pd(a3, b0));
                            v31 = _mm256_min_pd(v31, _mm256_add_pd(a3, b1));
                        }
                        _mm256_store_pd(out + (i + 0) * B + j + 0, v00);
                        _mm256_store_pd(out + (i + 0) * B + j + 4, v01);
                        _mm256_store_pd(out + (i + 1) * B + j + 0, v10);
                        _mm256_store_pd(out + (i + 1) * B + j + 4, v11);
                        _mm256_store_pd(out + (i + 2) * B + j + 0, v20);
                        _mm256_store_pd(out + (i + 2) * B + j + 4, v21);
                        _mm256_store_pd(out + (i + 3) * B + j + 0, v30);
                        _mm256_store_pd(out + (i + 3) * B + j + 4, v31);
                    }
            };
            for (std::size_t k = 0; k < count; ++k) {
                relax(tile(k, k), tile(k, k), tile(k, k));
                for (std::size_t j = 0; j < count; ++j)
                    if (j != k) relax(tile(k, j), tile(k, k), tile(k, j));
                for (std::size_t i = 0; i < count; ++i)
                    if (i != k) relax(tile(i, k), tile(i, k), tile(k, k));
                for (std::size_t i = 0; i < count; ++i)
                    if (i != k)
                        for (std::size_t j = 0; j < count; ++j)
                            if (j != k) product(tile(i, j), tile(i, k), tile(k, j));
            }
            for (std::size_t i = 0; i < n; ++i)
                for (std::size_t j = 0; j < n; ++j) {
                    const double value = tile(i / B, j / B)[(i % B) * B + j % B];
                    d[i][j] = value < static_cast<double>(inf)
                        ? static_cast<std::int64_t>(value) : inf;
                }
            _mm_free(matrix);
            return true;
        }

        template <bool check_negative>
        static bool cplib_warshall_floyd_int64_avx2_impl(
                void* raw_rows,
                std::size_t n,
                std::int64_t zero,
                std::int64_t inf) {
            std::int64_t** d = static_cast<std::int64_t**>(raw_rows);
            // 負閉路がなければ最短路は高々n-1辺、候補の絶対値も2^53以下に収まる。
            // 負閉路検出が必要な場合の負辺・範囲外・特殊なzero/infは整数で処理する。
            bool exact = n >= 128 && zero == 0 && inf > 0;
            const std::int64_t limit = (INT64_C(1) << 52) / (n ? n : 1);
            std::size_t edges = 0;
            bool has_negative = false;
            std::int64_t max_abs = 0;
            for (std::size_t i = 0; i < n && exact; ++i)
                for (std::size_t j = 0; j < n; ++j) {
                    const std::int64_t value = d[i][j];
                    if (d[i][j] != inf &&
                            (value < (check_negative ? 0 : -limit) ||
                             value > limit || value >= inf)) {
                        exact = false;
                        break;
                    }
                    if (value != inf) {
                        has_negative = has_negative || value < 0;
                        const std::int64_t magnitude = value < 0 ? -value : value;
                        if (magnitude > max_abs) max_abs = magnitude;
                    }
                    if (i != j && d[i][j] != inf) ++edges;
                }
            // 負辺でinf以上の途中経路が再び短くなる場合は、有限infの打ち切りを維持する。
            if (has_negative && inf <= 2 * static_cast<std::int64_t>(n) * max_abs)
                exact = false;
            // 辺が極端に少ない場合は未到達行をスキップする疎カーネルを優先する。
            if (exact && edges >= n &&
                    cplib_warshall_floyd_exact_double_avx2(d, n, inf)) return false;
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

        template <bool check_negative>
        static bool cplib_warshall_floyd_int32_avx2_impl(
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

        extern "C" bool cplib_warshall_floyd_int64_avx2(
                void* raw_rows, std::size_t n,
                std::int64_t zero, std::int64_t inf) {
            // AVX2で全点対最短路を求め、負閉路の有無を返す。O(n^3)。
            return cplib_warshall_floyd_int64_avx2_impl<true>(raw_rows, n, zero, inf);
        }

        extern "C" void cplib_warshall_floyd_nonnegative_int64_avx2(
                void* raw_rows, std::size_t n,
                std::int64_t zero, std::int64_t inf) {
            // 負閉路がない場合の全点対最短路をAVX2で求める。負閉路検査なし。O(n^3)。
            cplib_warshall_floyd_int64_avx2_impl<false>(raw_rows, n, zero, inf);
        }

        extern "C" bool cplib_warshall_floyd_int32_avx2(
                void* raw_rows, std::size_t n,
                std::int32_t zero, std::int32_t inf) {
            // AVX2で全点対最短路を求め、負閉路の有無を返す。O(n^3)。
            return cplib_warshall_floyd_int32_avx2_impl<true>(raw_rows, n, zero, inf);
        }

        extern "C" void cplib_warshall_floyd_nonnegative_int32_avx2(
                void* raw_rows, std::size_t n,
                std::int32_t zero, std::int32_t inf) {
            // 負閉路がない場合の全点対最短路をAVX2で求める。負閉路検査なし。O(n^3)。
            cplib_warshall_floyd_int32_avx2_impl<false>(raw_rows, n, zero, inf);
        }

        #endif
        """.}

        proc warshallFloydInt64Avx2(
            rows: pointer,
            n: csize_t,
            zero, inf: int
        ): bool {.importc: "cplib_warshall_floyd_int64_avx2".}

        proc warshallFloydInt32Avx2(
            rows: pointer,
            n: csize_t,
            zero, inf: int32
        ): bool {.importc: "cplib_warshall_floyd_int32_avx2".}

        proc warshallFloydNonnegativeInt64Avx2(
            rows: pointer, n: csize_t, zero, inf: int
        ) {.importc: "cplib_warshall_floyd_nonnegative_int64_avx2".}
            ## 負閉路がない距離行列をAVX2で更新する。O(V^3)。

        proc warshallFloydNonnegativeInt32Avx2(
            rows: pointer, n: csize_t, zero, inf: int32
        ) {.importc: "cplib_warshall_floyd_nonnegative_int32_avx2".}
            ## 負閉路がない距離行列をAVX2で更新する。O(V^3)。

    proc warshall_floyd_inplace_run[T](d: var seq[seq[T]], zero, inf: T): bool =
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
                let negativeCycle = warshallFloydInt64Avx2(
                    cast[pointer](addr rows[0]), n.csize_t, zero, inf)
            else:
                let negativeCycle = warshallFloydInt32Avx2(
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

    proc warshall_floyd_inplace_impl[T](d: var seq[seq[T]], zero, inf: T) =
        ## 距離行列を完成させ、負閉路を経由できる組は-infにする。O(V^3)。
        if warshall_floyd_inplace_run(d, zero, inf):
            warshall_floyd_negative_finish(d, zero, inf, warshall_floyd_inplace_run[T])

    proc warshall_floyd_impl[T](g: WeightedGraph[T] or UnWeightedGraph, zero, inf: T): seq[seq[T]] =
        ## 全点対最短路を返す。到達不能はinf、負閉路を経由できる組は-inf。O(V^3)。
        result = newSeqWith(g.len, newSeqWith(g.len, inf))
        for i in 0..<g.len:
            result[i][i] = zero
            for (j, cost) in g.to_and_cost(i):
                result[i][j] = min(result[i][j], cost)
        warshall_floyd_inplace_impl(result, zero, inf)

    proc warshall_floyd*(g: DynamicGraph[int] or StaticGraph[int] or UnWeightedGraph, zero: int = 0, inf: int = INF64): seq[seq[int]] =
        ## 全点対最短路を返す。到達不能はinf、負閉路を経由できる組は-inf。O(V^3)。
        return warshall_floyd_impl(g, zero, inf)

    proc warshall_floyd*(g: DynamicGraph[int32] or StaticGraph[int32], zero: int32 = 0.int32, inf: int32 = INF32): seq[seq[int32]] =
        ## 全点対最短路を返す。到達不能はinf、負閉路を経由できる組は-inf。O(V^3)。
        return warshall_floyd_impl(g, zero, inf)

    proc warshall_floyd*(g: DynamicGraph[float] or StaticGraph[float], zero: float = 0.0, inf: float = 1e100): seq[seq[float]] =
        ## 全点対最短路を返す。到達不能はinf、負閉路を経由できる組は-inf。O(V^3)。
        return warshall_floyd_impl(g, zero, inf)

    proc warshall_floyd*(g: DynamicGraph[float32] or StaticGraph[float32], zero: float32 = 0.0'f32, inf: float32 = 1e30'f32): seq[seq[float32]] =
        ## 全点対最短路を返す。到達不能はinf、負閉路を経由できる組は-inf。O(V^3)。
        return warshall_floyd_impl(g, zero, inf)

    proc warshall_floyd*[T](g: WeightedGraph[T] or UnWeightedGraph, zero, inf: T): seq[seq[T]] =
        ## 全点対最短路を返す。到達不能はinf、負閉路を経由できる組は-inf。O(V^3)。
        return warshall_floyd_impl(g, zero, inf)

    proc warshall_floyd_matrix_impl[T](a: seq[seq[T]], zero, inf: T): seq[seq[T]] =
        ## 正方隣接行列から全点対最短路を求める。時間O(V^3)、追加領域O(V^2)。入力は変更しない。
        var d = newSeqWith(a.len, newSeqWith(a.len, inf))
        for i in 0..<a.len:
            assert a[i].len == a.len, "隣接行列は正方行列である必要があります"
            for j in 0..<a.len:
                d[i][j] = a[i][j]
        warshall_floyd_inplace_impl(d, zero, inf)
        return d

    proc warshall_floyd*(a: seq[seq[int]], zero: int = 0, inf: int = INF64): seq[seq[int]] =
        ## 隣接行列から全点対最短路をO(V^3)で返す。到達不能はinf、負閉路を経由できる組は-inf。入力は変更しない。
        return warshall_floyd_matrix_impl(a, zero, inf)

    proc warshall_floyd*(a: seq[seq[int32]], zero: int32 = 0.int32, inf: int32 = INF32): seq[seq[int32]] =
        ## 隣接行列から全点対最短路をO(V^3)で返す。到達不能はinf、負閉路を経由できる組は-inf。入力は変更しない。
        return warshall_floyd_matrix_impl(a, zero, inf)

    proc warshall_floyd*(a: seq[seq[float]], zero: float = 0.0, inf: float = 1e100): seq[seq[float]] =
        ## 隣接行列から全点対最短路をO(V^3)で返す。到達不能はinf、負閉路を経由できる組は-inf。入力は変更しない。
        return warshall_floyd_matrix_impl(a, zero, inf)

    proc warshall_floyd*(a: seq[seq[float32]], zero: float32 = 0.0'f32, inf: float32 = 1e30'f32): seq[seq[float32]] =
        ## 隣接行列から全点対最短路をO(V^3)で返す。到達不能はinf、負閉路を経由できる組は-inf。入力は変更しない。
        return warshall_floyd_matrix_impl(a, zero, inf)

    proc warshall_floyd*[T](a: seq[seq[T]], zero, inf: T): seq[seq[T]] =
        ## 隣接行列から全点対最短路をO(V^3)で返す。到達不能はinf、負閉路を経由できる組は-inf。入力は変更しない。
        return warshall_floyd_matrix_impl(a, zero, inf)

    proc warshall_floyd_nonnegative_run[T](d: var seq[seq[T]], zero, inf: T) =
        ## 非負辺を前提に、負閉路検査なしで距離行列を更新する。O(V^3)。
        when defined(cpp) and sizeof(int) == 8 and (T is int or T is int32):
            if d.len == 0: return
            var rows = newSeq[ptr T](d.len)
            for i in 0..<d.len:
                rows[i] = addr d[i][0]
            when T is int:
                warshallFloydNonnegativeInt64Avx2(
                    cast[pointer](addr rows[0]), d.len.csize_t, zero, inf)
            else:
                warshallFloydNonnegativeInt32Avx2(
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

    proc warshall_floyd_inplace*(d: var seq[seq[int]], zero: int = 0, inf: int = INF64) =
        ## 隣接行列をO(V^3)で最短距離に上書きする。到達不能はinf、負閉路を経由できる組は-inf。
        warshall_floyd_inplace_impl(d, zero, inf)

    proc warshall_floyd_inplace*(d: var seq[seq[int32]], zero: int32 = 0.int32, inf: int32 = INF32) =
        ## 隣接行列をO(V^3)で最短距離に上書きする。到達不能はinf、負閉路を経由できる組は-inf。
        warshall_floyd_inplace_impl(d, zero, inf)

    proc warshall_floyd_inplace*(d: var seq[seq[float]], zero: float = 0.0, inf: float = 1e100) =
        ## 隣接行列をO(V^3)で最短距離に上書きする。到達不能はinf、負閉路を経由できる組は-inf。
        warshall_floyd_inplace_impl(d, zero, inf)

    proc warshall_floyd_inplace*(d: var seq[seq[float32]], zero: float32 = 0.0'f32, inf: float32 = 1e30'f32) =
        ## 隣接行列をO(V^3)で最短距離に上書きする。到達不能はinf、負閉路を経由できる組は-inf。
        warshall_floyd_inplace_impl(d, zero, inf)

    proc warshall_floyd_inplace*[T](d: var seq[seq[T]], zero, inf: T) =
        ## 隣接行列をO(V^3)で最短距離に上書きする。到達不能はinf、負閉路を経由できる組は-inf。
        warshall_floyd_inplace_impl(d, zero, inf)

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
