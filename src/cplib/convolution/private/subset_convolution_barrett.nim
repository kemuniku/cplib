when not declared CPLIB_CONVOLUTION_PRIVATE_SUBSET_CONVOLUTION_BARRETT:
    const CPLIB_CONVOLUTION_PRIVATE_SUBSET_CONVOLUTION_BARRETT* = 1
    import bitops
    import cplib/modint/modint

    {.emit: """
#include <cstdint>
#include <algorithm>
#include <limits>
template<unsigned M>
static void cplib_subset_barrett_kernel(unsigned n, uint32_t* __restrict left, uint32_t* __restrict right, const uint8_t* ranks, const uint32_t* offsets) {
    const unsigned size = 1u << n;
    // 各積は(M-1)^2以下なので、この項数ごとに剰余を取ればuint64_tに収まる。
    constexpr uint64_t capacity = std::numeric_limits<uint64_t>::max() / (uint64_t(M - 1) * (M - 1));
    constexpr unsigned terms = capacity < 64 ? unsigned(capacity) : 64;
    const unsigned blockBits = std::min(n, 12u), blockSize = 1u << blockBits;
    auto zetaStage = [&](unsigned bit, unsigned section, unsigned limit) {
        for (unsigned base = section; base < limit; base += bit * 2) {
            const unsigned first = ranks[base];
            for (unsigned j = 0; j < bit; ++j) {
                uint32_t* llo = left + offsets[base + j];
                uint32_t* lhi = left + offsets[base + j + bit];
                uint32_t* rlo = right + offsets[base + j];
                uint32_t* rhi = right + offsets[base + j + bit];
                for (unsigned d = first; d <= unsigned(ranks[base + j]); ++d) {
                    const uint32_t lv = lhi[d] + llo[d], rv = rhi[d] + rlo[d];
                    lhi[d] = lv >= M ? lv - M : lv;
                    rhi[d] = rv >= M ? rv - M : rv;
                }
            }
        }
    };
    for (unsigned section = 0; section < size; section += blockSize)
        for (unsigned h = 0; h < blockBits; ++h) zetaStage(1u << h, section, section + blockSize);
    for (unsigned h = blockBits; h < n; ++h) zetaStage(1u << h, 0, size);
    for (unsigned mask = 0; mask < size; ++mask) {
        uint32_t* lrow = left + offsets[mask];
        const uint32_t* rrow = right + offsets[mask];
        const unsigned rank = ranks[mask];
        // 入力係数を壊さず積を求めてから、必要な次数だけを同じ行に詰める。
        uint32_t output[21];
        const unsigned lastDegree = std::min(n, 2 * rank);
        for (unsigned d = rank; d <= lastDegree; ++d) {
            const unsigned first = d - rank;
            if (rank - first + 1 <= terms) {
                uint64_t sum = 0;
                for (unsigned k = first; k <= rank; ++k) sum += uint64_t(lrow[k]) * rrow[d - k];
                output[d - rank] = uint32_t(sum % M);
            } else {
                uint64_t value = 0;
                for (unsigned k = first; k <= rank;) {
                    const unsigned last = std::min(rank, k + terms - 1);
                    uint64_t sum = 0;
                    for (unsigned j = k; j <= last; ++j) sum += uint64_t(lrow[j]) * rrow[d - j];
                    value += sum % M;
                    k = last + 1;
                }
                output[d - rank] = uint32_t(value % M);
            }
        }
        for (unsigned d = rank; d <= lastDegree; ++d) lrow[d - rank] = output[d - rank];
    }
    auto mobiusStage = [&](unsigned bit, unsigned section, unsigned limit) {
        for (unsigned base = section; base < limit; base += 2 * bit) {
            for (unsigned j = 0; j < bit; ++j) {
                const uint32_t* lo = left + offsets[base + j];
                uint32_t* hi = left + offsets[base + j + bit];
                const unsigned rank = ranks[base + j + bit];
                if (rank < 2) continue;
                const unsigned last = std::min(n - rank, rank - 2);
                for (unsigned d = 0; d <= last; ++d) {
                    // 両係数はM未満、M<=2^30なので最上位bitで負の差を判別できる。
                    const uint32_t v = hi[d] - lo[d + 1];
                    hi[d] = (v & 0x80000000u) ? v + M : v;
                }
            }
        }
    };
    for (unsigned section = 0; section < size; section += blockSize)
        for (unsigned h = 0; h < blockBits; ++h) mobiusStage(1u << h, section, section + blockSize);
    for (unsigned h = blockBits; h < n; ++h) mobiusStage(1u << h, 0, size);
}

    """.}
    proc subsetConvolutionBarrett*[T: StaticBarrettModint](a, b: seq[T]): seq[T] =
        ## 静的Barrett型のsubset convolution。O(n² 2^n)時間・O(n 2^n)追加領域。
        assert a.len == b.len, "配列の長さは一致する必要があります"
        let size = a.len
        if size == 0: return @[]
        assert (size and (size - 1)) == 0, "配列の長さは2冪である必要があります"
        let n = fastLog2(size)
        assert n <= 20
        const modulus = T.M
        static: assert modulus > 1u32 and modulus <= (1u32 shl 30)
        # zetaではrank+1項だけを保存する。積後は必要な次数rank..nを先頭に詰める。
        var ranks = newSeq[uint8](size)
        var offsets = newSeq[uint32](size + 1)
        for mask in 0..<size:
            let rank = countSetBits(mask)
            ranks[mask] = rank.uint8
            offsets[mask + 1] = offsets[mask] + uint32(rank + 1)
        var left = newSeq[uint32](int(offsets[size]))
        var right = newSeq[uint32](int(offsets[size]))
        for mask in 0..<size:
            let index = int(offsets[mask]) + int(ranks[mask])
            left[index] = uint32(a[mask].val)
            right[index] = uint32(b[mask].val)
        const call = "cplib_subset_barrett_kernel<" & $modulus & ">(#, #, #, #, #)"
        proc kernel(n: cuint, left, right: ptr uint32, ranks: ptr uint8, offsets: ptr uint32) {.importcpp: call, nodecl.}
        kernel(n.cuint, addr left[0], addr right[0], addr ranks[0], addr offsets[0])
        result = newSeq[T](size)
        for mask in 0..<size: result[mask] = init(T, int(left[int(offsets[mask])]))
