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

        #ifndef CPLIB_WARSHALL_FLOYD_BLOCK_SIZE
        #define CPLIB_WARSHALL_FLOYD_BLOCK_SIZE 192
        #endif

        #ifndef CPLIB_WARSHALL_FLOYD_INT32_BLOCK_SIZE
        #define CPLIB_WARSHALL_FLOYD_INT32_BLOCK_SIZE 256
        #endif

        #pragma GCC push_options
        #pragma GCC target("avx2")
        #pragma GCC optimize("O3")

        static inline void cplib_warshall_floyd_relax_avx2(
                std::int64_t* row_i,
                const std::int64_t* row_k,
                std::int64_t dik,
                std::size_t begin,
                std::size_t end,
                __m256i inf4,
                std::int64_t inf) {
            const __m256i dik4 = _mm256_set1_epi64x(dik);
            std::size_t j = begin;
            for (; j + 4 <= end; j += 4) {
                const __m256i dkj = _mm256_loadu_si256(
                    reinterpret_cast<const __m256i*>(row_k + j));
                const __m256i dij = _mm256_loadu_si256(
                    reinterpret_cast<const __m256i*>(row_i + j));
                const __m256i candidate = _mm256_add_epi64(dik4, dkj);
                const __m256i unreachable = _mm256_cmpeq_epi64(dkj, inf4);
                const __m256i improves = _mm256_cmpgt_epi64(dij, candidate);
                const __m256i take = _mm256_andnot_si256(unreachable, improves);
                const __m256i updated = _mm256_blendv_epi8(
                    dij, candidate, take);
                _mm256_storeu_si256(
                    reinterpret_cast<__m256i*>(row_i + j), updated);
            }
            for (; j < end; ++j) {
                if (row_k[j] != inf) {
                    const std::int64_t candidate = dik + row_k[j];
                    if (candidate < row_i[j]) row_i[j] = candidate;
                }
            }
        }

        extern "C" bool cplib_warshall_floyd_int64_avx2(
                void* raw_rows,
                std::size_t n,
                std::int64_t zero,
                std::int64_t inf) {
            std::int64_t** d = static_cast<std::int64_t**>(raw_rows);
            const __m256i inf4 = _mm256_set1_epi64x(inf);
            constexpr std::size_t block_size =
                CPLIB_WARSHALL_FLOYD_BLOCK_SIZE;

            for (std::size_t i = 0; i < n; ++i) {
                if (d[i][i] < zero) return true;
            }

            for (std::size_t kk = 0; kk < n; kk += block_size) {
                const std::size_t kend =
                    kk + block_size < n ? kk + block_size : n;

                // Phase 1: close the diagonal block.
                for (std::size_t k = kk; k < kend; ++k) {
                    const std::int64_t* const row_k = d[k];
                    for (std::size_t i = kk; i < kend; ++i) {
                        const std::int64_t dik = d[i][k];
                        if (dik != inf) cplib_warshall_floyd_relax_avx2(
                            d[i], row_k, dik, kk, kend, inf4, inf);
                    }
                }

                for (std::size_t i = 0; i < n; ++i) {
                    if (d[i][i] < zero) return true;
                }

                // Phase 2a: update the blocks in the diagonal block row.
                for (std::size_t jj = 0; jj < n; jj += block_size) {
                    if (jj == kk) continue;
                    const std::size_t jend =
                        jj + block_size < n ? jj + block_size : n;
                    for (std::size_t k = kk; k < kend; ++k) {
                        const std::int64_t* const row_k = d[k];
                        for (std::size_t i = kk; i < kend; ++i) {
                            const std::int64_t dik = d[i][k];
                            if (dik != inf) cplib_warshall_floyd_relax_avx2(
                                d[i], row_k, dik, jj, jend, inf4, inf);
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
                        for (std::size_t i = ii; i < iend; ++i) {
                            const std::int64_t dik = d[i][k];
                            if (dik != inf) cplib_warshall_floyd_relax_avx2(
                                d[i], row_k, dik, kk, kend, inf4, inf);
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
                        for (std::size_t k = kk; k < kend; ++k) {
                            const std::int64_t* const row_k = d[k];
                            for (std::size_t i = ii; i < iend; ++i) {
                                const std::int64_t dik = d[i][k];
                                if (dik != inf) cplib_warshall_floyd_relax_avx2(
                                    d[i], row_k, dik, jj, jend, inf4, inf);
                            }
                        }
                    }
                }

                for (std::size_t i = 0; i < n; ++i) {
                    if (d[i][i] < zero) return true;
                }
            }
            return false;
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

        extern "C" bool cplib_warshall_floyd_int32_avx2(
                void* raw_rows,
                std::size_t n,
                std::int32_t zero,
                std::int32_t inf) {
            std::int32_t** d = static_cast<std::int32_t**>(raw_rows);
            const __m256i inf8 = _mm256_set1_epi32(inf);
            constexpr std::size_t block_size =
                CPLIB_WARSHALL_FLOYD_INT32_BLOCK_SIZE;

            for (std::size_t i = 0; i < n; ++i) {
                if (d[i][i] < zero) return true;
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
                }

                for (std::size_t i = 0; i < n; ++i) {
                    if (d[i][i] < zero) return true;
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
                    if (d[i][i] < zero) return true;
                }
            }
            return false;
        }

        #pragma GCC pop_options

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

    proc warshall_floyd_impl[T](g: DynamicGraph[T] or StaticGraph[T], zero, inf: T): tuple[negative_cycle: bool, d: seq[seq[T]]] =
        var d = newSeqWith(g.len, newSeqWith(g.len, inf))
        for i in 0..<g.len: d[i][i] = zero
        for i in 0..<g.len:
            for (j, cost) in g.to_and_cost(i):
                d[i][j] = cost
        for k in 0..<g.len:
            for i in 0..<g.len:
                for j in 0..<g.len:
                    if d[i][k] != inf and d[k][j] != inf:
                        d[i][j] = min(d[i][j], d[i][k] + d[k][j])
            for i in 0..<g.len:
                if d[i][i] < zero: return (negative_cycle: true, d: d)
        return (negative_cycle: false, d: d)

    proc warshall_floyd*(g: DynamicGraph[int] or StaticGraph[int], zero: int = 0, inf: int = INF64): tuple[negative_cycle: bool, d: seq[seq[int]]] =
        when defined(cpp) and sizeof(int) == 8:
            var d = newSeqWith(g.len, newSeqWith(g.len, inf))
            for i in 0..<g.len: d[i][i] = zero
            for i in 0..<g.len:
                for (j, cost) in g.to_and_cost(i):
                    d[i][j] = cost

            if g.len == 0:
                return (negative_cycle: false, d: d)

            var rows = newSeq[ptr int](g.len)
            for i in 0..<g.len:
                rows[i] = addr d[i][0]
            let negativeCycle = warshallFloydInt64Avx2(
                cast[pointer](addr rows[0]), g.len.csize_t, zero, inf)
            return (negative_cycle: negativeCycle, d: d)
        else:
            return warshall_floyd_impl(g, zero, inf)
    proc warshall_floyd*(g: DynamicGraph[int32] or StaticGraph[int32], zero: int32 = 0.int32, inf: int32 = INF32): tuple[negative_cycle: bool, d: seq[seq[int32]]] =
        when defined(cpp):
            var d = newSeqWith(g.len, newSeqWith(g.len, inf))
            for i in 0..<g.len: d[i][i] = zero
            for i in 0..<g.len:
                for (j, cost) in g.to_and_cost(i):
                    d[i][j] = cost

            if g.len == 0:
                return (negative_cycle: false, d: d)

            var rows = newSeq[ptr int32](g.len)
            for i in 0..<g.len:
                rows[i] = addr d[i][0]
            let negativeCycle = warshallFloydInt32Avx2(
                cast[pointer](addr rows[0]), g.len.csize_t, zero, inf)
            return (negative_cycle: negativeCycle, d: d)
        else:
            return warshall_floyd_impl(g, zero, inf)
    proc warshall_floyd*(g: DynamicGraph[float] or StaticGraph[float], zero: float = 0.0, inf: float = 1e100): tuple[negative_cycle: bool, d: seq[seq[float]]] = warshall_floyd_impl(g, zero, inf)
    proc warshall_floyd*(g: DynamicGraph[float32] or StaticGraph[float32], zero: float32 = 0.0'f32, inf: float32 = 1e30'f32): tuple[negative_cycle: bool, d: seq[seq[float32]]] = warshall_floyd_impl(g, zero, inf)
    proc warshall_floyd*[T](g: DynamicGraph[T] or StaticGraph[T], zero, inf: T): tuple[negative_cycle: bool, d: seq[seq[T]]] = warshall_floyd_impl(g, zero, inf)
