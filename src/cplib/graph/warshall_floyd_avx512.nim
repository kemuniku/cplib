when not declared CPLIB_GRAPH_WARSHALLFLOYD:
    const CPLIB_GRAPH_WARSHALLFLOYD* = 1
    import cplib/graph/graph
    import cplib/utils/constants
    import sequtils
    import cplib/graph/warshall_floyd_negative

    when defined(cpp) and sizeof(int) == 8:
        import strutils

        # ホスト用C++コンパイラのnative設定でコンパイル元CPUを調べる。実行時の判定とは独立。
        const warshallFloydHostCpuMacros = gorgeEx(
            "c++ -march=native -dM -E -x c++ -", "\n")
        when warshallFloydHostCpuMacros.exitCode != 0:
            {.warning: "コンパイル元CPUのAVX-512F対応を判定できませんでした。実行時の自動選択は有効です。".}
        elif "#define __AVX512F__ 1" notin warshallFloydHostCpuMacros.output:
            {.warning: "コンパイル元CPUはAVX-512F非対応です。同じ環境で実行するとAVX2版が使われます。実行先が異なる場合は実行先CPUで自動選択します。".}

        {.emit: """
        #ifndef CPLIB_GRAPH_WARSHALL_FLOYD_AVX2_HPP
        #define CPLIB_GRAPH_WARSHALL_FLOYD_AVX2_HPP

        #include <immintrin.h>

        #include <cstddef>
        #include <cstdint>
        #include <cstring>
        #include <vector>
        #include <memory>

        #ifndef CPLIB_WARSHALL_FLOYD_BLOCK_SIZE
        #define CPLIB_WARSHALL_FLOYD_BLOCK_SIZE 216
        #endif

        #ifndef CPLIB_WARSHALL_FLOYD_AVX512_BLOCK_SIZE
        #define CPLIB_WARSHALL_FLOYD_AVX512_BLOCK_SIZE 224
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

        template <bool all_reachable>
        static inline void cplib_warshall_floyd_product_int64_avx512(
                std::int64_t** out, std::int64_t** left, std::int64_t** top, std::size_t ib, std::size_t ie,
                std::size_t jb, std::size_t je,
                std::size_t kb, std::size_t ke, std::int64_t inf) {
            // 独立なタイルの4行16列をレジスタに保持して更新する。O((ie-ib)(je-jb)(ke-kb))。
            if (ib >= ie || jb >= je || kb >= ke) return;
            const __m512i infv = _mm512_set1_epi64(inf);
            std::size_t i = ib;
            for (; i + 4 <= ie; i += 4) {
                std::size_t j = jb;
                for (; j + 16 <= je; j += 16) {
                    __m512i v00 = _mm512_loadu_si512(out[i + 0] + j + 0);
                    __m512i v01 = _mm512_loadu_si512(out[i + 0] + j + 8);
                    __m512i v10 = _mm512_loadu_si512(out[i + 1] + j + 0);
                    __m512i v11 = _mm512_loadu_si512(out[i + 1] + j + 8);
                    __m512i v20 = _mm512_loadu_si512(out[i + 2] + j + 0);
                    __m512i v21 = _mm512_loadu_si512(out[i + 2] + j + 8);
                    __m512i v30 = _mm512_loadu_si512(out[i + 3] + j + 0);
                    __m512i v31 = _mm512_loadu_si512(out[i + 3] + j + 8);
                    for (std::size_t k = kb; k < ke; ++k) {
                        const __m512i b0 = _mm512_loadu_si512(top[k] + j + 0);
                        const __mmask8 m0 = all_reachable ? 0xff : _mm512_cmpneq_epi64_mask(b0, infv);
                        const __m512i b1 = _mm512_loadu_si512(top[k] + j + 8);
                        const __mmask8 m1 = all_reachable ? 0xff : _mm512_cmpneq_epi64_mask(b1, infv);
                        if (all_reachable || left[i + 0][k] != inf) {
                            const __m512i a = _mm512_set1_epi64(left[i + 0][k]);
                            const __m512i t0 = _mm512_add_epi64(a, b0);
                            v00 = all_reachable ? _mm512_min_epi64(v00, t0)
                                : _mm512_mask_min_epi64(v00, m0, v00, t0);
                            const __m512i t1 = _mm512_add_epi64(a, b1);
                            v01 = all_reachable ? _mm512_min_epi64(v01, t1)
                                : _mm512_mask_min_epi64(v01, m1, v01, t1);
                        }
                        if (all_reachable || left[i + 1][k] != inf) {
                            const __m512i a = _mm512_set1_epi64(left[i + 1][k]);
                            const __m512i t0 = _mm512_add_epi64(a, b0);
                            v10 = all_reachable ? _mm512_min_epi64(v10, t0)
                                : _mm512_mask_min_epi64(v10, m0, v10, t0);
                            const __m512i t1 = _mm512_add_epi64(a, b1);
                            v11 = all_reachable ? _mm512_min_epi64(v11, t1)
                                : _mm512_mask_min_epi64(v11, m1, v11, t1);
                        }
                        if (all_reachable || left[i + 2][k] != inf) {
                            const __m512i a = _mm512_set1_epi64(left[i + 2][k]);
                            const __m512i t0 = _mm512_add_epi64(a, b0);
                            v20 = all_reachable ? _mm512_min_epi64(v20, t0)
                                : _mm512_mask_min_epi64(v20, m0, v20, t0);
                            const __m512i t1 = _mm512_add_epi64(a, b1);
                            v21 = all_reachable ? _mm512_min_epi64(v21, t1)
                                : _mm512_mask_min_epi64(v21, m1, v21, t1);
                        }
                        if (all_reachable || left[i + 3][k] != inf) {
                            const __m512i a = _mm512_set1_epi64(left[i + 3][k]);
                            const __m512i t0 = _mm512_add_epi64(a, b0);
                            v30 = all_reachable ? _mm512_min_epi64(v30, t0)
                                : _mm512_mask_min_epi64(v30, m0, v30, t0);
                            const __m512i t1 = _mm512_add_epi64(a, b1);
                            v31 = all_reachable ? _mm512_min_epi64(v31, t1)
                                : _mm512_mask_min_epi64(v31, m1, v31, t1);
                        }
                    }
                    _mm512_storeu_si512(out[i + 0] + j + 0, v00);
                    _mm512_storeu_si512(out[i + 0] + j + 8, v01);
                    _mm512_storeu_si512(out[i + 1] + j + 0, v10);
                    _mm512_storeu_si512(out[i + 1] + j + 8, v11);
                    _mm512_storeu_si512(out[i + 2] + j + 0, v20);
                    _mm512_storeu_si512(out[i + 2] + j + 8, v21);
                    _mm512_storeu_si512(out[i + 3] + j + 0, v30);
                    _mm512_storeu_si512(out[i + 3] + j + 8, v31);
                }
                for (std::size_t r = 0; r < 4; ++r)
                    for (std::size_t k = kb; k < ke; ++k)
                        if (left[i + r][k] != inf)
                            cplib_warshall_floyd_relax_avx512(
                                out[i + r], top[k], left[i + r][k], j, je, inf);
            }
            for (; i < ie; ++i)
                for (std::size_t k = kb; k < ke; ++k)
                    if (left[i][k] != inf)
                        cplib_warshall_floyd_relax_avx512(out[i], top[k], left[i][k], jb, je, inf);
        }

        static inline void cplib_warshall_floyd_product_dense_int64_avx512(
                std::int64_t** out, std::int64_t** left, std::int64_t** top, std::size_t ib, std::size_t ie,
                std::size_t jb, std::size_t je,
                std::size_t kb, std::size_t ke, std::int64_t inf) {
            // 全て有限の独立タイルを4行32列ずつ保持して更新する。O((ie-ib)(je-jb)(ke-kb))。
            std::size_t i = ib;
            for (; i + 4 <= ie; i += 4) {
                std::size_t j = jb;
                for (; j + 32 <= je; j += 32) {
                    __m512i v00 = _mm512_loadu_si512(out[i + 0] + j + 0);
                    __m512i v01 = _mm512_loadu_si512(out[i + 0] + j + 8);
                    __m512i v02 = _mm512_loadu_si512(out[i + 0] + j + 16);
                    __m512i v03 = _mm512_loadu_si512(out[i + 0] + j + 24);
                    __m512i v10 = _mm512_loadu_si512(out[i + 1] + j + 0);
                    __m512i v11 = _mm512_loadu_si512(out[i + 1] + j + 8);
                    __m512i v12 = _mm512_loadu_si512(out[i + 1] + j + 16);
                    __m512i v13 = _mm512_loadu_si512(out[i + 1] + j + 24);
                    __m512i v20 = _mm512_loadu_si512(out[i + 2] + j + 0);
                    __m512i v21 = _mm512_loadu_si512(out[i + 2] + j + 8);
                    __m512i v22 = _mm512_loadu_si512(out[i + 2] + j + 16);
                    __m512i v23 = _mm512_loadu_si512(out[i + 2] + j + 24);
                    __m512i v30 = _mm512_loadu_si512(out[i + 3] + j + 0);
                    __m512i v31 = _mm512_loadu_si512(out[i + 3] + j + 8);
                    __m512i v32 = _mm512_loadu_si512(out[i + 3] + j + 16);
                    __m512i v33 = _mm512_loadu_si512(out[i + 3] + j + 24);
                    for (std::size_t k = kb; k < ke; ++k) {
                        const __m512i b0 = _mm512_loadu_si512(top[k] + j + 0);
                        const __m512i b1 = _mm512_loadu_si512(top[k] + j + 8);
                        const __m512i b2 = _mm512_loadu_si512(top[k] + j + 16);
                        const __m512i b3 = _mm512_loadu_si512(top[k] + j + 24);
                        {
                            const __m512i a = _mm512_set1_epi64(left[i + 0][k]);
                            v00 = _mm512_min_epi64(v00, _mm512_add_epi64(a, b0));
                            v01 = _mm512_min_epi64(v01, _mm512_add_epi64(a, b1));
                            v02 = _mm512_min_epi64(v02, _mm512_add_epi64(a, b2));
                            v03 = _mm512_min_epi64(v03, _mm512_add_epi64(a, b3));
                        }
                        {
                            const __m512i a = _mm512_set1_epi64(left[i + 1][k]);
                            v10 = _mm512_min_epi64(v10, _mm512_add_epi64(a, b0));
                            v11 = _mm512_min_epi64(v11, _mm512_add_epi64(a, b1));
                            v12 = _mm512_min_epi64(v12, _mm512_add_epi64(a, b2));
                            v13 = _mm512_min_epi64(v13, _mm512_add_epi64(a, b3));
                        }
                        {
                            const __m512i a = _mm512_set1_epi64(left[i + 2][k]);
                            v20 = _mm512_min_epi64(v20, _mm512_add_epi64(a, b0));
                            v21 = _mm512_min_epi64(v21, _mm512_add_epi64(a, b1));
                            v22 = _mm512_min_epi64(v22, _mm512_add_epi64(a, b2));
                            v23 = _mm512_min_epi64(v23, _mm512_add_epi64(a, b3));
                        }
                        {
                            const __m512i a = _mm512_set1_epi64(left[i + 3][k]);
                            v30 = _mm512_min_epi64(v30, _mm512_add_epi64(a, b0));
                            v31 = _mm512_min_epi64(v31, _mm512_add_epi64(a, b1));
                            v32 = _mm512_min_epi64(v32, _mm512_add_epi64(a, b2));
                            v33 = _mm512_min_epi64(v33, _mm512_add_epi64(a, b3));
                        }
                    }
                    _mm512_storeu_si512(out[i + 0] + j + 0, v00);
                    _mm512_storeu_si512(out[i + 0] + j + 8, v01);
                    _mm512_storeu_si512(out[i + 0] + j + 16, v02);
                    _mm512_storeu_si512(out[i + 0] + j + 24, v03);
                    _mm512_storeu_si512(out[i + 1] + j + 0, v10);
                    _mm512_storeu_si512(out[i + 1] + j + 8, v11);
                    _mm512_storeu_si512(out[i + 1] + j + 16, v12);
                    _mm512_storeu_si512(out[i + 1] + j + 24, v13);
                    _mm512_storeu_si512(out[i + 2] + j + 0, v20);
                    _mm512_storeu_si512(out[i + 2] + j + 8, v21);
                    _mm512_storeu_si512(out[i + 2] + j + 16, v22);
                    _mm512_storeu_si512(out[i + 2] + j + 24, v23);
                    _mm512_storeu_si512(out[i + 3] + j + 0, v30);
                    _mm512_storeu_si512(out[i + 3] + j + 8, v31);
                    _mm512_storeu_si512(out[i + 3] + j + 16, v32);
                    _mm512_storeu_si512(out[i + 3] + j + 24, v33);
                }
                cplib_warshall_floyd_product_int64_avx512<true>(
                    out, left, top, i, i + 4, j, je, kb, ke, inf);
            }
            cplib_warshall_floyd_product_int64_avx512<true>(
                out, left, top, i, ie, jb, je, kb, ke, inf);
        }

        static inline void cplib_warshall_floyd_product_avx512(
                std::int64_t** out, std::int64_t** left, std::int64_t** top, std::size_t ib, std::size_t ie,
                std::size_t jb, std::size_t je,
                std::size_t kb, std::size_t ke, std::int64_t inf,
                bool all_reachable) {
            // 共有した到達判定で独立タイルの更新方法を選ぶ。O((ie-ib)(je-jb)(ke-kb))。
            if (all_reachable)
                cplib_warshall_floyd_product_dense_int64_avx512(out, left, top, ib, ie, jb, je, kb, ke, inf);
            else
                cplib_warshall_floyd_product_int64_avx512<false>(out, left, top, ib, ie, jb, je, kb, ke, inf);
        }

        static inline void cplib_warshall_floyd_product_avx512(
                std::int64_t** d, std::size_t ib, std::size_t ie,
                std::size_t jb, std::size_t je,
                std::size_t kb, std::size_t ke, std::int64_t inf, bool all_reachable) {
            // 行配置の行列から独立タイルを更新する。O((ie-ib)(je-jb)(ke-kb))。
            cplib_warshall_floyd_product_avx512(d, d, d, ib, ie, jb, je, kb, ke, inf, all_reachable);
        }

        template <bool all_reachable>
        static inline void cplib_warshall_floyd_product_int32_avx512(
                std::int32_t** d, std::size_t ib, std::size_t ie,
                std::size_t jb, std::size_t je,
                std::size_t kb, std::size_t ke, std::int32_t inf) {
            // 独立なタイルの4行32列をレジスタに保持して更新する。O((ie-ib)(je-jb)(ke-kb))。
            const __m512i infv = _mm512_set1_epi32(inf);
            std::size_t i = ib;
            for (; i + 4 <= ie; i += 4) {
                std::size_t j = jb;
                for (; j + 32 <= je; j += 32) {
                    __m512i v00 = _mm512_loadu_si512(d[i + 0] + j + 0);
                    __m512i v01 = _mm512_loadu_si512(d[i + 0] + j + 16);
                    __m512i v10 = _mm512_loadu_si512(d[i + 1] + j + 0);
                    __m512i v11 = _mm512_loadu_si512(d[i + 1] + j + 16);
                    __m512i v20 = _mm512_loadu_si512(d[i + 2] + j + 0);
                    __m512i v21 = _mm512_loadu_si512(d[i + 2] + j + 16);
                    __m512i v30 = _mm512_loadu_si512(d[i + 3] + j + 0);
                    __m512i v31 = _mm512_loadu_si512(d[i + 3] + j + 16);
                    for (std::size_t k = kb; k < ke; ++k) {
                        const __m512i b0 = _mm512_loadu_si512(d[k] + j + 0);
                        const __mmask16 m0 = all_reachable ? 0xffff : _mm512_cmpneq_epi32_mask(b0, infv);
                        const __m512i b1 = _mm512_loadu_si512(d[k] + j + 16);
                        const __mmask16 m1 = all_reachable ? 0xffff : _mm512_cmpneq_epi32_mask(b1, infv);
                        if (all_reachable || d[i + 0][k] != inf) {
                            const __m512i a = _mm512_set1_epi32(d[i + 0][k]);
                            const __m512i t0 = _mm512_add_epi32(a, b0);
                            v00 = all_reachable ? _mm512_min_epi32(v00, t0)
                                : _mm512_mask_min_epi32(v00, m0, v00, t0);
                            const __m512i t1 = _mm512_add_epi32(a, b1);
                            v01 = all_reachable ? _mm512_min_epi32(v01, t1)
                                : _mm512_mask_min_epi32(v01, m1, v01, t1);
                        }
                        if (all_reachable || d[i + 1][k] != inf) {
                            const __m512i a = _mm512_set1_epi32(d[i + 1][k]);
                            const __m512i t0 = _mm512_add_epi32(a, b0);
                            v10 = all_reachable ? _mm512_min_epi32(v10, t0)
                                : _mm512_mask_min_epi32(v10, m0, v10, t0);
                            const __m512i t1 = _mm512_add_epi32(a, b1);
                            v11 = all_reachable ? _mm512_min_epi32(v11, t1)
                                : _mm512_mask_min_epi32(v11, m1, v11, t1);
                        }
                        if (all_reachable || d[i + 2][k] != inf) {
                            const __m512i a = _mm512_set1_epi32(d[i + 2][k]);
                            const __m512i t0 = _mm512_add_epi32(a, b0);
                            v20 = all_reachable ? _mm512_min_epi32(v20, t0)
                                : _mm512_mask_min_epi32(v20, m0, v20, t0);
                            const __m512i t1 = _mm512_add_epi32(a, b1);
                            v21 = all_reachable ? _mm512_min_epi32(v21, t1)
                                : _mm512_mask_min_epi32(v21, m1, v21, t1);
                        }
                        if (all_reachable || d[i + 3][k] != inf) {
                            const __m512i a = _mm512_set1_epi32(d[i + 3][k]);
                            const __m512i t0 = _mm512_add_epi32(a, b0);
                            v30 = all_reachable ? _mm512_min_epi32(v30, t0)
                                : _mm512_mask_min_epi32(v30, m0, v30, t0);
                            const __m512i t1 = _mm512_add_epi32(a, b1);
                            v31 = all_reachable ? _mm512_min_epi32(v31, t1)
                                : _mm512_mask_min_epi32(v31, m1, v31, t1);
                        }
                    }
                    _mm512_storeu_si512(d[i + 0] + j + 0, v00);
                    _mm512_storeu_si512(d[i + 0] + j + 16, v01);
                    _mm512_storeu_si512(d[i + 1] + j + 0, v10);
                    _mm512_storeu_si512(d[i + 1] + j + 16, v11);
                    _mm512_storeu_si512(d[i + 2] + j + 0, v20);
                    _mm512_storeu_si512(d[i + 2] + j + 16, v21);
                    _mm512_storeu_si512(d[i + 3] + j + 0, v30);
                    _mm512_storeu_si512(d[i + 3] + j + 16, v31);
                }
                for (std::size_t r = 0; r < 4; ++r)
                    for (std::size_t k = kb; k < ke; ++k)
                        if (d[i + r][k] != inf)
                            cplib_warshall_floyd_relax_avx512(
                                d[i + r], d[k], d[i + r][k], j, je, inf);
            }
            for (; i < ie; ++i)
                for (std::size_t k = kb; k < ke; ++k)
                    if (d[i][k] != inf)
                        cplib_warshall_floyd_relax_avx512(d[i], d[k], d[i][k], jb, je, inf);
        }

        static inline void cplib_warshall_floyd_product_avx512(
                std::int32_t** d, std::size_t ib, std::size_t ie,
                std::size_t jb, std::size_t je,
                std::size_t kb, std::size_t ke, std::int32_t inf, bool) {
            // 入力タイルが全て到達可能なら、内側の到達判定を省く。O((ie-ib)(je-jb)(ke-kb))。
            bool reachable = true;
            const __m512i infv = _mm512_set1_epi32(inf);
            for (std::size_t i = ib; i < ie && reachable; ++i)
                for (std::size_t k = kb; k < ke; ++k)
                    if (d[i][k] == inf) { reachable = false; break; }
            for (std::size_t k = kb; k < ke && reachable; ++k) {
                std::size_t j = jb;
                for (; j + 16 <= je; j += 16)
                    if (_mm512_cmpneq_epi32_mask(_mm512_loadu_si512(d[k] + j), infv) != 0xffff) {
                        reachable = false;
                        break;
                    }
                for (; j < je && reachable; ++j)
                    if (d[k][j] == inf) reachable = false;
            }
            if (reachable)
                cplib_warshall_floyd_product_int32_avx512<true>(d, ib, ie, jb, je, kb, ke, inf);
            else
                cplib_warshall_floyd_product_int32_avx512<false>(d, ib, ie, jb, je, kb, ke, inf);
        }

        static bool cplib_warshall_floyd_finite_tile_avx512(
                std::int64_t** d, std::size_t ib, std::size_t ie,
                std::size_t jb, std::size_t je, std::int64_t inf) {
            // タイル内の全要素が有限か判定する。O((ie-ib)(je-jb))。
            const __m512i infv = _mm512_set1_epi64(inf);
            for (std::size_t i = ib; i < ie; ++i) {
                std::size_t j = jb;
                for (; j + 8 <= je; j += 8)
                    if (_mm512_cmpeq_epi64_mask(_mm512_loadu_si512(d[i] + j), infv)) return false;
                for (; j < je; ++j)
                    if (d[i][j] == inf) return false;
            }
            return true;
        }

        static inline void cplib_warshall_floyd_prepare_reachable_avx512(
                std::int64_t** d, std::size_t n, std::size_t kk, std::size_t kend,
                std::size_t block_size, std::int64_t inf,
                unsigned char* left, unsigned char* top) {
            // Phase 2後の入力タイルを調べ、Phase 3で判定を共有する。O(n(kend-kk))。
            for (std::size_t b = 0; b < n; b += block_size) {
                if (b == kk) continue;
                const std::size_t end = b + block_size < n ? b + block_size : n;
                left[b / block_size] = cplib_warshall_floyd_finite_tile_avx512(d, b, end, kk, kend, inf);
                top[b / block_size] = cplib_warshall_floyd_finite_tile_avx512(d, kk, kend, b, end, inf);
            }
        }

        static inline void cplib_warshall_floyd_prepare_reachable_avx512(
                std::int32_t**, std::size_t, std::size_t, std::size_t,
                std::size_t, std::int32_t, unsigned char*, unsigned char*) {
            // int32では更新先ごとの既存の到達判定を使う。O(1)。
        }

        template <typename T, std::size_t block_size, bool check_negative = true>
        static bool cplib_warshall_floyd_blocked_avx512(
                void* raw_rows, std::size_t n, T zero, T inf) {
            // ブロック分割した全点対最短路を求める。check_negativeで負閉路検査を切り替える。O(n^3)。
            T** d = static_cast<T**>(raw_rows);
            const std::size_t cache_size = sizeof(T) == 8 ? (n + block_size - 1) / block_size : 0;
            std::vector<unsigned char> left_reachable(cache_size), top_reachable(cache_size);
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
                cplib_warshall_floyd_prepare_reachable_avx512(
                    d, n, kk, kend, block_size, inf, left_reachable.data(), top_reachable.data());
                for (std::size_t ii = 0; ii < n; ii += block_size) {
                    if (ii == kk) continue;
                    const std::size_t iend =
                        ii + block_size < n ? ii + block_size : n;
                    for (std::size_t jj = 0; jj < n; jj += block_size) {
                        if (jj == kk) continue;
                        const std::size_t jend =
                            jj + block_size < n ? jj + block_size : n;
                        cplib_warshall_floyd_product_avx512(
                            d, ii, iend, jj, jend, kk, kend, inf,
                            sizeof(T) == 8 && left_reachable[ii / block_size] && top_reachable[jj / block_size]);
                    }
                }
                for (std::size_t i = 0; i < n; ++i) {
                    if (check_negative && d[i][i] < zero) return true;
                }
            }
            return false;
        }

        template <int B>
        static inline void cplib_warshall_floyd_product_fixed_avx512(
                std::int64_t* out, const std::int64_t* left, const std::int64_t* top) {
            // 全要素が有限の独立したB×Bタイルを4行・4中継点ずつ更新する。O(B^3)。
            static_assert(B % 8 == 0, "tile width must be a multiple of 8");
            for (int k = 0; k < B; k += 4) {
                for (int i = 0; i < B; i += 4) {
                    const __m512i a00 = _mm512_set1_epi64(left[(i + 0) * B + k + 0]);
                    const __m512i a01 = _mm512_set1_epi64(left[(i + 0) * B + k + 1]);
                    const __m512i a02 = _mm512_set1_epi64(left[(i + 0) * B + k + 2]);
                    const __m512i a03 = _mm512_set1_epi64(left[(i + 0) * B + k + 3]);
                    const __m512i a10 = _mm512_set1_epi64(left[(i + 1) * B + k + 0]);
                    const __m512i a11 = _mm512_set1_epi64(left[(i + 1) * B + k + 1]);
                    const __m512i a12 = _mm512_set1_epi64(left[(i + 1) * B + k + 2]);
                    const __m512i a13 = _mm512_set1_epi64(left[(i + 1) * B + k + 3]);
                    const __m512i a20 = _mm512_set1_epi64(left[(i + 2) * B + k + 0]);
                    const __m512i a21 = _mm512_set1_epi64(left[(i + 2) * B + k + 1]);
                    const __m512i a22 = _mm512_set1_epi64(left[(i + 2) * B + k + 2]);
                    const __m512i a23 = _mm512_set1_epi64(left[(i + 2) * B + k + 3]);
                    const __m512i a30 = _mm512_set1_epi64(left[(i + 3) * B + k + 0]);
                    const __m512i a31 = _mm512_set1_epi64(left[(i + 3) * B + k + 1]);
                    const __m512i a32 = _mm512_set1_epi64(left[(i + 3) * B + k + 2]);
                    const __m512i a33 = _mm512_set1_epi64(left[(i + 3) * B + k + 3]);
                    for (int j = 0; j < B; j += 8) {
                        const __m512i b0 = _mm512_load_si512(top + (k + 0) * B + j);
                        const __m512i b1 = _mm512_load_si512(top + (k + 1) * B + j);
                        const __m512i b2 = _mm512_load_si512(top + (k + 2) * B + j);
                        const __m512i b3 = _mm512_load_si512(top + (k + 3) * B + j);
                        {
                            const __m512i candidate = _mm512_min_epi64(
                                _mm512_min_epi64(_mm512_add_epi64(a00, b0), _mm512_add_epi64(a01, b1)),
                                _mm512_min_epi64(_mm512_add_epi64(a02, b2), _mm512_add_epi64(a03, b3)));
                            const __m512i old = _mm512_load_si512(out + (i + 0) * B + j);
                            _mm512_mask_store_epi64(out + (i + 0) * B + j,
                                _mm512_cmplt_epi64_mask(candidate, old), candidate);
                        }
                        {
                            const __m512i candidate = _mm512_min_epi64(
                                _mm512_min_epi64(_mm512_add_epi64(a10, b0), _mm512_add_epi64(a11, b1)),
                                _mm512_min_epi64(_mm512_add_epi64(a12, b2), _mm512_add_epi64(a13, b3)));
                            const __m512i old = _mm512_load_si512(out + (i + 1) * B + j);
                            _mm512_mask_store_epi64(out + (i + 1) * B + j,
                                _mm512_cmplt_epi64_mask(candidate, old), candidate);
                        }
                        {
                            const __m512i candidate = _mm512_min_epi64(
                                _mm512_min_epi64(_mm512_add_epi64(a20, b0), _mm512_add_epi64(a21, b1)),
                                _mm512_min_epi64(_mm512_add_epi64(a22, b2), _mm512_add_epi64(a23, b3)));
                            const __m512i old = _mm512_load_si512(out + (i + 2) * B + j);
                            _mm512_mask_store_epi64(out + (i + 2) * B + j,
                                _mm512_cmplt_epi64_mask(candidate, old), candidate);
                        }
                        {
                            const __m512i candidate = _mm512_min_epi64(
                                _mm512_min_epi64(_mm512_add_epi64(a30, b0), _mm512_add_epi64(a31, b1)),
                                _mm512_min_epi64(_mm512_add_epi64(a32, b2), _mm512_add_epi64(a33, b3)));
                            const __m512i old = _mm512_load_si512(out + (i + 3) * B + j);
                            _mm512_mask_store_epi64(out + (i + 3) * B + j,
                                _mm512_cmplt_epi64_mask(candidate, old), candidate);
                        }
                    }
                }
            }
        }

        template <bool check_negative>
        static bool cplib_warshall_floyd_packed_int64_avx512(
                void* raw_rows, std::size_t n, std::int64_t zero, std::int64_t inf) {
            // 64×64タイルへ詰め、再帰順に全点対最短路を求める。時間O(n^3)、追加領域O(n^2)。
            constexpr std::size_t B = 64;
            std::int64_t** d = static_cast<std::int64_t**>(raw_rows);
            if (n < 512) return cplib_warshall_floyd_blocked_avx512<
                std::int64_t, CPLIB_WARSHALL_FLOYD_AVX512_BLOCK_SIZE, check_negative>(raw_rows, n, zero, inf);
            if (check_negative) for (std::size_t i = 0; i < n; ++i) if (d[i][i] < zero) return true;
            const std::size_t count = (n + B - 1) / B;
            const std::size_t cells = count * count * B * B;
            std::unique_ptr<void, decltype(&std::free)> allocation(
                std::malloc(cells * sizeof(std::int64_t) + 63), &std::free);
            if (!allocation) return cplib_warshall_floyd_blocked_avx512<
                std::int64_t, CPLIB_WARSHALL_FLOYD_AVX512_BLOCK_SIZE, check_negative>(raw_rows, n, zero, inf);
            auto* data = reinterpret_cast<std::int64_t*>(
                (reinterpret_cast<std::uintptr_t>(allocation.get()) + 63) & ~std::uintptr_t(63));
            std::fill(data, data + cells, inf);
            std::vector<std::int64_t*> rows(count * count * B);
            std::vector<unsigned char> finite(count * count);
            const auto size = [&](std::size_t b) {
                // 末尾タイルの有効な行数・列数を返す。O(1)。
                return n - b * B < B ? n - b * B : B;
            };
            const auto tile = [&](std::size_t i, std::size_t j) {
                // 指定タイルの行ポインタ配列を返す。O(1)。
                return rows.data() + (i * count + j) * B;
            };
            for (std::size_t i = 0; i < count; ++i) for (std::size_t j = 0; j < count; ++j) {
                auto r = tile(i, j);
                for (std::size_t k = 0; k < B; ++k) r[k] = data + ((i * count + j) * B + k) * B;
                for (std::size_t k = 0; k < size(i); ++k)
                    std::memcpy(r[k], d[i * B + k] + j * B, size(j) * sizeof(std::int64_t));
                finite[i * count + j] = cplib_warshall_floyd_finite_tile_avx512(r, 0, size(i), 0, size(j), inf);
            }
            const auto update = [&](std::size_t i, std::size_t j, std::size_t k) {
                // 入力と出力の依存に応じてタイルを更新し、対角では負閉路も調べる。O(B^3)。
                auto out = tile(i, j), left = tile(i, k), top = tile(k, j);
                const auto is = size(i), js = size(j), ks = size(k);
                if (i != k && j != k) {
                    const bool reachable = finite[i * count + k] && finite[k * count + j];
                    if (reachable && is == B && js == B && ks == B)
                        cplib_warshall_floyd_product_fixed_avx512<B>(out[0], left[0], top[0]);
                    else cplib_warshall_floyd_product_avx512(
                        out, left, top, 0, is, 0, js, 0, ks, inf, reachable);
                } else {
                    for (std::size_t z = 0; z < ks; ++z) {
                        for (std::size_t y = 0; y < is; ++y) if (left[y][z] != inf)
                            cplib_warshall_floyd_relax_avx512(out[y], top[z], left[y][z], 0, js, inf);
                        if (check_negative && i == j)
                            for (std::size_t y = 0; y < is; ++y) if (out[y][y] < zero) return true;
                    }
                }
                if (check_negative && i == j)
                    for (std::size_t y = 0; y < is; ++y) if (out[y][y] < zero) return true;
                if (!finite[i * count + j])
                    finite[i * count + j] = cplib_warshall_floyd_finite_tile_avx512(out, 0, is, 0, js, inf);
                return false;
            };
            const auto visit = [&](auto&& self, std::size_t i, std::size_t j,
                                   std::size_t k, std::size_t span) -> bool {
                // 中継点の前半を閉じてから後半を処理する。全体でO(n^3)。
                if (i >= count || j >= count || k >= count) return false;
                if (span == 1) return update(i, j, k);
                const auto h = span / 2;
                return self(self, i, j, k, h) || self(self, i, j + h, k, h) ||
                    self(self, i + h, j, k, h) || self(self, i + h, j + h, k, h) ||
                    self(self, i + h, j + h, k + h, h) || self(self, i + h, j, k + h, h) ||
                    self(self, i, j + h, k + h, h) || self(self, i, j, k + h, h);
            };
            std::size_t span = 1;
            while (span < count) span *= 2;
            const bool negative = visit(visit, 0, 0, 0, span);
            for (std::size_t i = 0; i < count; ++i) for (std::size_t j = 0; j < count; ++j)
                for (std::size_t k = 0; k < size(i); ++k)
                    std::memcpy(d[i * B + k] + j * B, tile(i, j)[k], size(j) * sizeof(std::int64_t));
            return negative;
        }

        #pragma GCC pop_options

        extern "C" bool cplib_warshall_floyd_int64_avx(
                void* raw_rows, std::size_t n,
                std::int64_t zero, std::int64_t inf) {
            // CPU・OSがAVX-512に対応していなければAVX2版を使用する。O(n^3)。
            if (__builtin_cpu_supports("avx512f")) {
                return cplib_warshall_floyd_packed_int64_avx512<true>(raw_rows, n, zero, inf);
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
                cplib_warshall_floyd_packed_int64_avx512<false>(raw_rows, n, zero, inf);
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
