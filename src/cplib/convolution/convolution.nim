when not declared CPLIB_CONVOLUTION_CONVOLUTION:
    const CPLIB_CONVOLUTION_CONVOLUTION* = 1
    import bitops, sequtils, std/math
    import cplib/modint/modint
    import cplib/convolution/ntt
    import cplib/math/inv_gcd

    {.emit: """
    // Independently written AVX2 kernel for convolution over 30-bit NTT primes.
    //
    // The transform is the standard decimation-in-frequency NTT followed by its
    // decimation-in-time inverse.  Values stay in the ordinary residue domain;
    // only twiddle factors use Montgomery representation.  Forward transforms
    // consequently produce matching bit-reversed orders without a permutation.
    #ifndef CPLIB_CONVOLUTION_AVX2_NTT_HPP
    #define CPLIB_CONVOLUTION_AVX2_NTT_HPP

    #include <immintrin.h>

    #include <algorithm>
    #include <cstddef>
    #include <cstdint>
    #include <cstring>

    #pragma GCC target("avx2,bmi2")
    #pragma GCC optimize("O3")

    namespace cplib_avx2_ntt {

    using u32 = std::uint32_t;
    using u64 = std::uint64_t;

    // Set once at the start of each transform.  Convolution is deliberately
    // single-threaded; keeping these values in one context lets the same AVX2
    // code serve every suitable 30-bit NTT prime without duplicating the kernel.
    u32 modulus = 998244353U;
    u32 primitive_root = 3U;

    struct Montgomery {
        u32 negative_inverse;
        u32 radix;
        u32 radix_squared;

        Montgomery() {
            negative_inverse = 1;
            for (int i = 0; i < 5; ++i) {
                negative_inverse *= 2U + negative_inverse * modulus;
            }
            radix = static_cast<u32>((u64(1) << 32) % modulus);
            radix_squared = static_cast<u32>(u64(radix) * radix % modulus);
        }

        inline u32 multiply(u32 a, u32 b) const {
            const u64 product = u64(a) * b;
            const u32 correction = static_cast<u32>(product) * negative_inverse;
            u32 value = static_cast<u32>(
                (product + u64(correction) * modulus) >> 32);
            if (value >= modulus) value -= modulus;
            return value;
        }

        inline u32 to_montgomery(u32 value) const {
            return multiply(value, radix_squared);
        }
    };

    inline u32 add_mod(u32 a, u32 b) {
        const u32 sum = a + b;
        return sum >= modulus ? sum - modulus : sum;
    }

    inline u32 subtract_mod(u32 a, u32 b) {
        return a >= b ? a - b : a + modulus - b;
    }

    inline u32 power_mod(u32 base, u32 exponent) {
        u32 result = 1;
        while (exponent != 0) {
            if (exponent & 1U) result = static_cast<u32>(u64(result) * base % modulus);
            base = static_cast<u32>(u64(base) * base % modulus);
            exponent >>= 1;
        }
        return result;
    }

    inline u32 find_primitive_root(u32 prime) {
        switch (prime) {
            case 998244353U: return 3U;
            case 754974721U: return 11U;
            case 167772161U: return 3U;
            case 469762049U: return 3U;
            default: break;
        }
        u32 factors[16];
        int factor_count = 0;
        u32 remaining = prime - 1;
        for (u32 divisor = 2; u64(divisor) * divisor <= remaining; ++divisor) {
            if (remaining % divisor != 0) continue;
            factors[factor_count++] = divisor;
            do {
                remaining /= divisor;
            } while (remaining % divisor == 0);
        }
        if (remaining != 1) factors[factor_count++] = remaining;
        for (u32 candidate = 2;; ++candidate) {
            bool valid = true;
            for (int i = 0; i < factor_count; ++i) {
                if (power_mod(candidate, (prime - 1) / factors[i]) == 1) {
                    valid = false;
                    break;
                }
            }
            if (valid) return candidate;
        }
    }

    inline __m256i shrink(__m256i value) {
        const __m256i mod = _mm256_set1_epi32(static_cast<int>(modulus));
        return _mm256_min_epu32(value, _mm256_sub_epi32(value, mod));
    }

    inline __m256i shrink_twice_modulus(__m256i value) {
        const __m256i twice_modulus = _mm256_set1_epi32(
            static_cast<int>(2U * modulus));
        return _mm256_min_epu32(
            value, _mm256_sub_epi32(value, twice_modulus));
    }

    inline __m256i add_lazy(__m256i a, __m256i b) {
        return _mm256_add_epi32(a, b);
    }

    inline __m256i subtract_lazy(__m256i a, __m256i b) {
        const __m256i twice_modulus = _mm256_set1_epi32(
            static_cast<int>(2U * modulus));
        return _mm256_sub_epi32(_mm256_add_epi32(a, twice_modulus), b);
    }

    inline __m256i add_mod(__m256i a, __m256i b) {
        return shrink(_mm256_add_epi32(a, b));
    }

    inline __m256i subtract_mod(__m256i a, __m256i b) {
        const __m256i mod = _mm256_set1_epi32(static_cast<int>(modulus));
        return shrink(_mm256_sub_epi32(_mm256_add_epi32(a, mod), b));
    }

    // Eight independent 32-bit Montgomery products.  AVX2 provides four
    // 32x32->64 multipliers, so even and odd lanes are reduced separately and
    // interleaved afterwards.
    inline __m256i montgomery_multiply_lazy(
            __m256i a, __m256i b, const Montgomery& montgomery) {
        const __m256i inverse = _mm256_set1_epi32(
            static_cast<int>(montgomery.negative_inverse));
        const __m256i mod = _mm256_set1_epi32(static_cast<int>(modulus));

        const __m256i even_product = _mm256_mul_epu32(a, b);
        const __m256i odd_product = _mm256_mul_epu32(
            _mm256_srli_epi64(a, 32), _mm256_srli_epi64(b, 32));

        const __m256i even_correction = _mm256_mul_epu32(even_product, inverse);
        const __m256i odd_correction = _mm256_mul_epu32(odd_product, inverse);
        const __m256i even_sum = _mm256_add_epi64(
            even_product, _mm256_mul_epu32(even_correction, mod));
        const __m256i odd_sum = _mm256_add_epi64(
            odd_product, _mm256_mul_epu32(odd_correction, mod));

        const __m256i even_result = _mm256_srli_epi64(even_sum, 32);
        const __m256i odd_result = _mm256_slli_epi64(
            _mm256_srli_epi64(odd_sum, 32), 32);
        return _mm256_or_si256(even_result, odd_result);
    }

    inline __m256i montgomery_multiply(
            __m256i a, __m256i b, const Montgomery& montgomery) {
        return shrink(montgomery_multiply_lazy(a, b, montgomery));
    }

    class TransformPlan {
        std::size_t size_;
        Montgomery montgomery_;
        u32* twiddles_;

        void fill_stage(u32* destination, std::size_t count, u32 ratio) {
            const u32 ratio_montgomery = montgomery_.to_montgomery(ratio);
            u32 first_powers[8];
            first_powers[0] = montgomery_.radix;
            for (int i = 1; i < 8; ++i) {
                first_powers[i] = montgomery_.multiply(
                    first_powers[i - 1], ratio_montgomery);
            }

            if (count < 8) {
                std::memcpy(destination, first_powers, count * sizeof(u32));
                return;
            }

            __m256i powers = _mm256_loadu_si256(
                reinterpret_cast<const __m256i*>(first_powers));
            u32 ratio_eighth = first_powers[7];
            ratio_eighth = montgomery_.multiply(ratio_eighth, ratio_montgomery);
            const __m256i step = _mm256_set1_epi32(static_cast<int>(ratio_eighth));
            for (std::size_t i = 0; i < count; i += 8) {
                _mm256_storeu_si256(
                    reinterpret_cast<__m256i*>(destination + i), powers);
                powers = montgomery_multiply(powers, step, montgomery_);
            }
        }

        void build_twiddles() {
            for (std::size_t length = size_;; length >>= 1) {
                const std::size_t half = length >> 1;
                const std::size_t offset = size_ - length;
                const u32 root = power_mod(
                    primitive_root,
                    static_cast<u32>((modulus - 1) / length));
                fill_stage(twiddles_ + offset, half, root);
                if (length == 2) break;
            }
        }

        void forward_single(
                u32* data, std::size_t length, u32* second = nullptr) const {
            const std::size_t half = length >> 1;
            const u32* twiddle = twiddles_ + size_ - length;
            for (std::size_t block = 0; block < size_; block += length) {
                for (std::size_t j = 0; j < half; j += 8) {
                    const __m256i weight = _mm256_loadu_si256(
                        reinterpret_cast<const __m256i*>(twiddle + j));
                    const auto process = [&](u32* target) {
                        const __m256i left = shrink_twice_modulus(
                            _mm256_loadu_si256(reinterpret_cast<const __m256i*>(
                                target + block + j)));
                        const __m256i right = shrink_twice_modulus(
                            _mm256_loadu_si256(reinterpret_cast<const __m256i*>(
                                target + block + half + j)));
                        _mm256_storeu_si256(
                            reinterpret_cast<__m256i*>(target + block + j),
                            add_lazy(left, right));
                        _mm256_storeu_si256(
                            reinterpret_cast<__m256i*>(target + block + half + j),
                            montgomery_multiply_lazy(
                                subtract_lazy(left, right), weight, montgomery_));
                    };
                    process(data);
                    if (second != nullptr) process(second);
                }
            }
        }

        // Fuse two DIF layers.  Four quarters are loaded once, transformed fully
        // in registers, and stored once.
        void forward_pair(
                u32* data, std::size_t length, u32* second = nullptr) const {
            const std::size_t quarter = length >> 2;
            const u32* outer = twiddles_ + size_ - length;
            const u32* inner = twiddles_ + size_ - (length >> 1);
            for (std::size_t block = 0; block < size_; block += length) {
                for (std::size_t j = 0; j < quarter; j += 8) {
                    const __m256i outer0 = _mm256_loadu_si256(
                        reinterpret_cast<const __m256i*>(outer + j));
                    const __m256i outer1 = _mm256_loadu_si256(
                        reinterpret_cast<const __m256i*>(outer + quarter + j));
                    const __m256i inner_weight = _mm256_loadu_si256(
                        reinterpret_cast<const __m256i*>(inner + j));
                    const auto process = [&](u32* target) {
                        const __m256i a = shrink_twice_modulus(_mm256_loadu_si256(
                            reinterpret_cast<const __m256i*>(target + block + j)));
                        const __m256i b = shrink_twice_modulus(_mm256_loadu_si256(
                            reinterpret_cast<const __m256i*>(target + block + quarter + j)));
                        const __m256i c = shrink_twice_modulus(_mm256_loadu_si256(
                            reinterpret_cast<const __m256i*>(target + block + 2 * quarter + j)));
                        const __m256i d = shrink_twice_modulus(_mm256_loadu_si256(
                            reinterpret_cast<const __m256i*>(target + block + 3 * quarter + j)));
                        const __m256i ac_sum = shrink_twice_modulus(add_lazy(a, c));
                        const __m256i ac_difference = montgomery_multiply_lazy(
                            subtract_lazy(a, c), outer0, montgomery_);
                        const __m256i bd_sum = shrink_twice_modulus(add_lazy(b, d));
                        const __m256i bd_difference = montgomery_multiply_lazy(
                            subtract_lazy(b, d), outer1, montgomery_);
                        _mm256_storeu_si256(
                            reinterpret_cast<__m256i*>(target + block + j),
                            add_lazy(ac_sum, bd_sum));
                        _mm256_storeu_si256(
                            reinterpret_cast<__m256i*>(target + block + quarter + j),
                            montgomery_multiply_lazy(
                                subtract_lazy(ac_sum, bd_sum), inner_weight, montgomery_));
                        _mm256_storeu_si256(
                            reinterpret_cast<__m256i*>(target + block + 2 * quarter + j),
                            add_lazy(ac_difference, bd_difference));
                        _mm256_storeu_si256(
                            reinterpret_cast<__m256i*>(target + block + 3 * quarter + j),
                            montgomery_multiply_lazy(
                                subtract_lazy(ac_difference, bd_difference),
                                inner_weight, montgomery_));
                    };
                    process(data);
                    if (second != nullptr) process(second);
                }
            }
        }

        // The common convolution case starts with exactly half of the transform
        // occupied.  Fuse the first two DIF layers while treating the other half
        // as implicit zeroes, avoiding both its initialization and its loads.
        void forward_pair_half_zero(u32* data, u32* second = nullptr) const {
            const std::size_t quarter = size_ >> 2;
            const u32* outer = twiddles_;
            const u32* inner = twiddles_ + (size_ >> 1);
            for (std::size_t j = 0; j < quarter; j += 8) {
                const __m256i outer0 = _mm256_loadu_si256(
                    reinterpret_cast<const __m256i*>(outer + j));
                const __m256i outer1 = _mm256_loadu_si256(
                    reinterpret_cast<const __m256i*>(outer + quarter + j));
                const __m256i inner_weight = _mm256_loadu_si256(
                    reinterpret_cast<const __m256i*>(inner + j));
                const auto process = [&](u32* target) {
                    const __m256i a = _mm256_loadu_si256(
                        reinterpret_cast<const __m256i*>(target + j));
                    const __m256i b = _mm256_loadu_si256(
                        reinterpret_cast<const __m256i*>(target + quarter + j));
                    const __m256i first = montgomery_multiply_lazy(
                        a, outer0, montgomery_);
                    const __m256i second_value = montgomery_multiply_lazy(
                        b, outer1, montgomery_);
                    _mm256_storeu_si256(
                        reinterpret_cast<__m256i*>(target + j), add_lazy(a, b));
                    _mm256_storeu_si256(
                        reinterpret_cast<__m256i*>(target + quarter + j),
                        montgomery_multiply_lazy(
                            subtract_lazy(a, b), inner_weight, montgomery_));
                    _mm256_storeu_si256(
                        reinterpret_cast<__m256i*>(target + 2 * quarter + j),
                        add_lazy(first, second_value));
                    _mm256_storeu_si256(
                        reinterpret_cast<__m256i*>(target + 3 * quarter + j),
                        montgomery_multiply_lazy(
                            subtract_lazy(first, second_value),
                            inner_weight, montgomery_));
                };
                process(data);
                if (second != nullptr) process(second);
            }
        }

        void forward_single_half_zero(u32* data, u32* second = nullptr) const {
            const std::size_t half = size_ >> 1;
            for (std::size_t j = 0; j < half; j += 8) {
                const __m256i value = _mm256_loadu_si256(
                    reinterpret_cast<const __m256i*>(data + j));
                const __m256i weight = _mm256_loadu_si256(
                    reinterpret_cast<const __m256i*>(twiddles_ + j));
                _mm256_storeu_si256(
                    reinterpret_cast<__m256i*>(data + half + j),
                    montgomery_multiply_lazy(value, weight, montgomery_));
                if (second != nullptr) {
                    const __m256i second_value = _mm256_loadu_si256(
                        reinterpret_cast<const __m256i*>(second + j));
                    _mm256_storeu_si256(
                        reinterpret_cast<__m256i*>(second + half + j),
                        montgomery_multiply_lazy(
                            second_value, weight, montgomery_));
                }
            }
        }

        void forward_bottom8(u32* data, u32* product = nullptr) const {
            const u32* twiddle8 = twiddles_ + size_ - 8;
            const u32* twiddle4 = twiddles_ + size_ - 4;
            const __m128i w8_low = _mm_loadu_si128(
                reinterpret_cast<const __m128i*>(twiddle8));
            const __m256i w8 = _mm256_broadcastsi128_si256(w8_low);
            const __m256i w4 = _mm256_setr_epi32(
                twiddle4[0], twiddle4[1], twiddle4[0], twiddle4[1],
                twiddle4[0], twiddle4[1], twiddle4[0], twiddle4[1]);

            for (std::size_t block = 0; block < size_; block += 8) {
                __m256i value = shrink(shrink_twice_modulus(_mm256_loadu_si256(
                    reinterpret_cast<const __m256i*>(data + block))));

                __m256i other = _mm256_permute2x128_si256(value, value, 1);
                __m256i sum = add_mod(value, other);
                __m256i difference = montgomery_multiply(
                    subtract_mod(value, other), w8, montgomery_);
                value = _mm256_blend_epi32(
                    sum, _mm256_permute2x128_si256(difference, difference, 1), 0xF0);

                other = _mm256_shuffle_epi32(value, 0x4E);
                sum = add_mod(value, other);
                difference = montgomery_multiply(
                    subtract_mod(value, other), w4, montgomery_);
                value = _mm256_blend_epi32(
                    sum, _mm256_shuffle_epi32(difference, 0x4E), 0xCC);

                other = _mm256_shuffle_epi32(value, 0xB1);
                sum = add_mod(value, other);
                difference = subtract_mod(value, other);
                value = _mm256_blend_epi32(
                    sum, _mm256_shuffle_epi32(difference, 0xB1), 0xAA);
                if (product == nullptr) {
                    _mm256_storeu_si256(
                        reinterpret_cast<__m256i*>(data + block), value);
                } else {
                    const __m256i other_transform = _mm256_loadu_si256(
                        reinterpret_cast<const __m256i*>(product + block));
                    _mm256_storeu_si256(
                        reinterpret_cast<__m256i*>(product + block),
                        montgomery_multiply(
                            other_transform, value, montgomery_));
                }
            }
        }

        void inverse_single(
                u32* data, std::size_t length, bool canonicalize = false) const {
            const std::size_t half = length >> 1;
            const u32* twiddle = twiddles_ + size_ - length;
            for (std::size_t block = 0; block < size_; block += length) {
                for (std::size_t j = 0; j < half; j += 8) {
                    const __m256i left = shrink_twice_modulus(_mm256_loadu_si256(
                        reinterpret_cast<const __m256i*>(data + block + j)));
                    const __m256i right = montgomery_multiply_lazy(
                        shrink_twice_modulus(_mm256_loadu_si256(
                            reinterpret_cast<const __m256i*>(data + block + half + j))),
                        _mm256_loadu_si256(reinterpret_cast<const __m256i*>(
                            twiddle + j)),
                        montgomery_);
                    __m256i sum = add_lazy(left, right);
                    __m256i difference = subtract_lazy(left, right);
                    if (canonicalize) {
                        sum = shrink(shrink_twice_modulus(sum));
                        difference = shrink(shrink_twice_modulus(difference));
                    }
                    _mm256_storeu_si256(
                        reinterpret_cast<__m256i*>(data + block + j), sum);
                    _mm256_storeu_si256(
                        reinterpret_cast<__m256i*>(data + block + half + j),
                        difference);
                }
            }
        }

        // Fuse the inverse DIT layers corresponding to forward_pair.
        void inverse_pair(u32* data, std::size_t length) const {
            const std::size_t quarter = length >> 2;
            const u32* outer = twiddles_ + size_ - length;
            const u32* inner = twiddles_ + size_ - (length >> 1);
            for (std::size_t block = 0; block < size_; block += length) {
                for (std::size_t j = 0; j < quarter; j += 8) {
                    const __m256i a = shrink_twice_modulus(_mm256_loadu_si256(
                        reinterpret_cast<const __m256i*>(data + block + j)));
                    const __m256i b = shrink_twice_modulus(_mm256_loadu_si256(
                        reinterpret_cast<const __m256i*>(data + block + quarter + j)));
                    const __m256i c = shrink_twice_modulus(_mm256_loadu_si256(
                        reinterpret_cast<const __m256i*>(data + block + 2 * quarter + j)));
                    const __m256i d = shrink_twice_modulus(_mm256_loadu_si256(
                        reinterpret_cast<const __m256i*>(data + block + 3 * quarter + j)));
                    const __m256i inner_weight = _mm256_loadu_si256(
                        reinterpret_cast<const __m256i*>(inner + j));
                    const __m256i outer0 = _mm256_loadu_si256(
                        reinterpret_cast<const __m256i*>(outer + j));
                    const __m256i outer1 = _mm256_loadu_si256(
                        reinterpret_cast<const __m256i*>(outer + quarter + j));

                    const __m256i bw = montgomery_multiply_lazy(b, inner_weight, montgomery_);
                    const __m256i dw = montgomery_multiply_lazy(d, inner_weight, montgomery_);
                    const __m256i ab_sum = shrink_twice_modulus(add_lazy(a, bw));
                    const __m256i ab_difference = shrink_twice_modulus(subtract_lazy(a, bw));
                    const __m256i cd_sum = add_lazy(c, dw);
                    const __m256i cd_difference = subtract_lazy(c, dw);
                    const __m256i cd_sum_weighted = montgomery_multiply_lazy(
                        cd_sum, outer0, montgomery_);
                    const __m256i cd_difference_weighted = montgomery_multiply_lazy(
                        cd_difference, outer1, montgomery_);

                    __m256i output0 = add_lazy(ab_sum, cd_sum_weighted);
                    __m256i output1 = add_lazy(
                        ab_difference, cd_difference_weighted);
                    __m256i output2 = subtract_lazy(ab_sum, cd_sum_weighted);
                    __m256i output3 = subtract_lazy(
                        ab_difference, cd_difference_weighted);
                    if (length == size_) {
                        output0 = shrink(shrink_twice_modulus(output0));
                        output1 = shrink(shrink_twice_modulus(output1));
                        output2 = shrink(shrink_twice_modulus(output2));
                        output3 = shrink(shrink_twice_modulus(output3));
                    }
                    _mm256_storeu_si256(
                        reinterpret_cast<__m256i*>(data + block + j), output0);
                    _mm256_storeu_si256(
                        reinterpret_cast<__m256i*>(data + block + quarter + j),
                        output1);
                    _mm256_storeu_si256(
                        reinterpret_cast<__m256i*>(data + block + 2 * quarter + j),
                        output2);
                    _mm256_storeu_si256(
                        reinterpret_cast<__m256i*>(data + block + 3 * quarter + j),
                        output3);
                }
            }
        }

        void inverse_bottom8(u32* data) const {
            const u32* twiddle4 = twiddles_ + size_ - 4;
            const u32* twiddle8 = twiddles_ + size_ - 8;
            const __m256i w4 = _mm256_setr_epi32(
                twiddle4[0], twiddle4[1], twiddle4[0], twiddle4[1],
                twiddle4[0], twiddle4[1], twiddle4[0], twiddle4[1]);
            const __m128i w8_low = _mm_loadu_si128(
                reinterpret_cast<const __m128i*>(twiddle8));
            const __m256i w8 = _mm256_broadcastsi128_si256(w8_low);

            for (std::size_t block = 0; block < size_; block += 8) {
                __m256i value = _mm256_loadu_si256(
                    reinterpret_cast<const __m256i*>(data + block));

                __m256i other = _mm256_shuffle_epi32(value, 0xB1);
                __m256i sum = add_mod(value, other);
                __m256i difference = subtract_mod(value, other);
                value = _mm256_blend_epi32(
                    sum, _mm256_shuffle_epi32(difference, 0xB1), 0xAA);

                other = _mm256_shuffle_epi32(value, 0x4E);
                other = montgomery_multiply(other, w4, montgomery_);
                sum = add_mod(value, other);
                difference = subtract_mod(value, other);
                value = _mm256_blend_epi32(
                    sum, _mm256_shuffle_epi32(difference, 0x4E), 0xCC);

                other = _mm256_permute2x128_si256(value, value, 1);
                other = montgomery_multiply(other, w8, montgomery_);
                sum = add_mod(value, other);
                difference = subtract_mod(value, other);
                value = _mm256_blend_epi32(
                    sum, _mm256_permute2x128_si256(difference, difference, 1), 0xF0);
                _mm256_storeu_si256(
                    reinterpret_cast<__m256i*>(data + block), value);
            }
        }

       public:
        explicit TransformPlan(std::size_t size)
            : size_(size),
              twiddles_(static_cast<u32*>(
                  _mm_malloc(sizeof(u32) * size, 32))) {
            build_twiddles();
        }

        ~TransformPlan() {
            _mm_free(twiddles_);
        }

        const Montgomery& montgomery() const { return montgomery_; }

        void prepare_inverse() {
            // w^(-j) = -w^(half-j).  Every stage occupies a disjoint slice,
            // so reverse and negate it in place after both forward transforms.
            for (std::size_t length = size_;; length >>= 1) {
                const std::size_t half = length >> 1;
                u32* stage = twiddles_ + size_ - length;
                std::size_t left = 1;
                std::size_t right = half - 1;
                while (left < right) {
                    const u32 a = stage[left];
                    const u32 b = stage[right];
                    stage[left++] = modulus - b;
                    stage[right--] = modulus - a;
                }
                if (left == right && left != 0) {
                    stage[left] = modulus - stage[left];
                }
                if (length == 2) break;
            }
        }

        void forward(u32* data, u32* product = nullptr) const {
            std::size_t length = size_;
            if ((__builtin_ctzll(size_) & 1) != 0) {
                forward_single(data, length);
                length >>= 1;
            }
            while (length > 16) {
                forward_pair(data, length);
                length >>= 2;
            }
            forward_single(data, 16);
            forward_bottom8(data, product);
        }

        void forward_half_zero(u32* data, u32* product = nullptr) const {
            std::size_t length;
            if ((__builtin_ctzll(size_) & 1) == 0) {
                forward_pair_half_zero(data);
                length = size_ >> 2;
            } else {
                forward_single_half_zero(data);
                length = size_ >> 1;
            }
            while (length > 16) {
                forward_pair(data, length);
                length >>= 2;
            }
            forward_single(data, 16);
            forward_bottom8(data, product);
        }

        void inverse(u32* data) const {
            inverse_bottom8(data);
            inverse_single(data, 16);
            const bool has_unpaired_top = (__builtin_ctzll(size_) & 1) != 0;
            const std::size_t paired_limit = has_unpaired_top ? size_ >> 1 : size_;
            for (std::size_t length = 64; length <= paired_limit; length <<= 2) {
                inverse_pair(data, length);
            }
            if (has_unpaired_top) inverse_single(data, size_, true);

        }
    };

    inline void convolution_ntt_friendly(
            u32* output,
            const u32* left,
            std::size_t left_size,
            const u32* right,
            std::size_t right_size,
            std::size_t transform_size,
            u32 modulus_value,
            u32 primitive_root_value,
            bool montgomery_representation) {
        modulus = modulus_value;
        primitive_root = primitive_root_value != 0
            ? primitive_root_value : find_primitive_root(modulus_value);
        u32* a = output;
        u32* b = static_cast<u32*>(
            _mm_malloc(sizeof(u32) * transform_size, 32));
        std::memcpy(a, left, sizeof(u32) * left_size);
        std::memcpy(b, right, sizeof(u32) * right_size);

        TransformPlan plan(transform_size);
        const Montgomery& montgomery = plan.montgomery();

        if (montgomery_representation) {
            const __m256i one = _mm256_set1_epi32(1);
            std::size_t i = 0;
            for (; i + 8 <= left_size; i += 8) {
                const __m256i value = _mm256_loadu_si256(
                    reinterpret_cast<const __m256i*>(a + i));
                _mm256_storeu_si256(
                    reinterpret_cast<__m256i*>(a + i),
                    montgomery_multiply(value, one, montgomery));
            }
            for (; i < left_size; ++i) a[i] = montgomery.multiply(a[i], 1);
            i = 0;
            for (; i + 8 <= right_size; i += 8) {
                const __m256i value = _mm256_loadu_si256(
                    reinterpret_cast<const __m256i*>(b + i));
                _mm256_storeu_si256(
                    reinterpret_cast<__m256i*>(b + i),
                    montgomery_multiply(value, one, montgomery));
            }
            for (; i < right_size; ++i) b[i] = montgomery.multiply(b[i], 1);
        }

        const std::size_t half = transform_size >> 1;
        const bool left_half_zero = left_size <= half;
        const bool right_half_zero = right_size <= half;
        std::memset(a + left_size, 0, sizeof(u32) *
            ((left_half_zero ? half : transform_size) - left_size));
        std::memset(b + right_size, 0, sizeof(u32) *
            ((right_half_zero ? half : transform_size) - right_size));

        // Keeping b in Montgomery representation makes the pointwise product need
        // only one reduction while preserving the transform's linear operations.
        // Include 1/N here so inverse normalization needs no separate memory pass.
        const u32 inverse_size = power_mod(
            static_cast<u32>(transform_size % modulus), modulus - 2);
        const u32 scaled_radix_squared = static_cast<u32>(
            u64(montgomery.radix_squared) * inverse_size % modulus);
        const __m256i conversion = _mm256_set1_epi32(
            static_cast<int>(scaled_radix_squared));
        const std::size_t right_initialized = right_half_zero ? half : transform_size;
        for (std::size_t i = 0; i < right_initialized; i += 8) {
            const __m256i value = _mm256_loadu_si256(
                reinterpret_cast<const __m256i*>(b + i));
            _mm256_storeu_si256(
                reinterpret_cast<__m256i*>(b + i),
                montgomery_multiply(value, conversion, montgomery));
        }

        if (left_half_zero) plan.forward_half_zero(a); else plan.forward(a);
        if (right_half_zero) {
            plan.forward_half_zero(b, a);
        } else {
            plan.forward(b, a);
        }
        plan.prepare_inverse();
        plan.inverse(a);

        if (montgomery_representation) {
            const std::size_t output_size = left_size + right_size - 1;
            const __m256i radix_squared = _mm256_set1_epi32(
                static_cast<int>(montgomery.radix_squared));
            std::size_t i = 0;
            for (; i + 8 <= output_size; i += 8) {
                const __m256i value = _mm256_loadu_si256(
                    reinterpret_cast<const __m256i*>(a + i));
                _mm256_storeu_si256(
                    reinterpret_cast<__m256i*>(a + i),
                    montgomery_multiply(value, radix_squared, montgomery));
            }
            for (; i < output_size; ++i) {
                a[i] = montgomery.to_montgomery(a[i]);
            }
        }

        _mm_free(b);
    }

    }  // namespace cplib_avx2_ntt

    #endif

    extern "C" void cplib_convolution_ntt_friendly(
            std::uint32_t* output,
            std::uint32_t* left,
            std::size_t left_size,
            std::uint32_t* right,
            std::size_t right_size,
            std::size_t transform_size,
            std::uint32_t modulus,
            std::uint32_t primitive_root,
            bool montgomery_representation) {
        cplib_avx2_ntt::convolution_ntt_friendly(
            output, left, left_size, right, right_size, transform_size,
            modulus, primitive_root, montgomery_representation);
    }
    """.}

    proc convolutionNttFriendlyAvx2(
        output: ptr uint32,
        f: ptr uint32,
        fLen: csize_t,
        g: ptr uint32,
        gLen: csize_t,
        nttLen: csize_t,
        modulus: uint32,
        primitiveRoot: uint32,
        montgomeryRepresentation: bool
    ) {.importc: "cplib_convolution_ntt_friendly".}

    proc convolution_naive*[T: BarrettModint or MontgomeryModint or int](f, g: seq[T]): seq[T] =
        var ans = newSeqWith(f.len + g.len - 1, T(0))
        if f.len > g.len:
            for i in 0..<f.len:
                for j in 0..<g.len:
                    ans[i+j] += f[i] * g[j]
        else:
            for j in 0..<g.len:
                for i in 0..<f.len:
                    ans[i+j] += f[i] * g[j]
        return ans

    proc convolution*[T: BarrettModint or MontgomeryModint](f, g: seq[T]): seq[T] =
        let m = f.len
        let n = g.len
        let deg = m + n - 1
        if min(n, m) <= 60: return convolution_naive(f, g)
        var l = (if deg == 1: 1 else: (1 shl (fastLog2(deg - 1) + 1)))
        when T is StaticBarrettModint or T is StaticMontgomeryModint or
                T is DynamicMontgomeryModint:
            if T.umod < (1u32 shl 30) and
                    (T.umod - 1u32) mod l.uint32 == 0u32:
                result = newSeq[T](l)
                convolutionNttFriendlyAvx2(
                    cast[ptr uint32](addr result[0]),
                    cast[ptr uint32](unsafeAddr f[0]), m.csize_t,
                    cast[ptr uint32](unsafeAddr g[0]), n.csize_t,
                    l.csize_t, T.umod, 0u32,
                    T is MontgomeryModint)
                result.setLen(deg)
                return
        var f = f
        var g = g
        f.setLen(l)
        g.setLen(l)
        ntt(f)
        ntt(g)
        for i in 0..<f.len:
            f[i] *= g[i]
        intt(f)
        f.setlen(deg)
        return f

    proc convolutionNttFriendlyU32(
            f, g: seq[uint32], modulus, primitiveRoot: uint32): seq[uint32] =
        if f.len == 0 or g.len == 0: return @[]
        if min(f.len, g.len) <= 60:
            result = newSeq[uint32](f.len + g.len - 1)
            if f.len > g.len:
                for i in 0..<f.len:
                    for j in 0..<g.len:
                        result[i + j] = ((result[i + j].uint64 +
                            f[i].uint64 * g[j].uint64) mod modulus.uint64).uint32
            else:
                for j in 0..<g.len:
                    for i in 0..<f.len:
                        result[i + j] = ((result[i + j].uint64 +
                            f[i].uint64 * g[j].uint64) mod modulus.uint64).uint32
            return
        let deg = f.len + g.len - 1
        let l = (if deg == 1: 1 else: (1 shl (fastLog2(deg - 1) + 1)))
        result = newSeq[uint32](l)
        convolutionNttFriendlyAvx2(
            addr result[0], cast[ptr uint32](unsafeAddr f[0]), f.len.csize_t,
            cast[ptr uint32](unsafeAddr g[0]), g.len.csize_t, l.csize_t,
            modulus, primitiveRoot, false)
        result.setLen(deg)


    proc convolution_ll*(f, g: seq[int]): seq[int] =
        var n = f.len
        var m = g.len
        if n == 0 or m == 0: return newSeq[int]()

        const
            M1 = 754974721u
            M2 = 167772161u
            M3 = 469762049u
            M12 = M1 * M2
            M23 = M2 * M3
            M31 = M3 * M1
            M123 = M1 * M2 * M3
            i1 = inv_gcd((M2 * M3).int, M1.int)[1].uint
            i2 = inv_gcd((M3 * M1).int, M2.int)[1].uint
            i3 = inv_gcd((M1 * M2).int, M3.int)[1].uint
        var fm = newSeq[uint32](n)
        var gm = newSeq[uint32](m)
        for i in 0..<n: fm[i] = floorMod(f[i], M1.int).uint32
        for i in 0..<m: gm[i] = floorMod(g[i], M1.int).uint32
        let c1 = convolutionNttFriendlyU32(fm, gm, M1.uint32, 11u32)
        for i in 0..<n: fm[i] = floorMod(f[i], M2.int).uint32
        for i in 0..<m: gm[i] = floorMod(g[i], M2.int).uint32
        let c2 = convolutionNttFriendlyU32(fm, gm, M2.uint32, 3u32)
        for i in 0..<n: fm[i] = floorMod(f[i], M3.int).uint32
        for i in 0..<m: gm[i] = floorMod(g[i], M3.int).uint32
        let c3 = convolutionNttFriendlyU32(fm, gm, M3.uint32, 3u32)
        var ans = newseqwith(n + m - 1, 0)
        for i in 0..<ans.len:
            var x = 0.uint
            x += (c1[i].uint * i1) mod M1 * M23
            x += (c2[i].uint * i2) mod M2 * M31
            x += (c3[i].uint * i3) mod M3 * M12
            # x intentionally wraps modulo 2^64.  Reinterpret those bits as a
            # signed value for the CRT overflow correction; a numeric `.int`
            # conversion raises RangeDefect when the top bit is set.
            var diff = c1[i].int - floorMod(cast[int](x), M1.int)
            if diff < 0: diff += M1.int
            const offset = [0u, 0u, M123, 2u * M123, 3u * M123]
            x -= offset[diff mod 5]
            ans[i] = cast[int](x)
        return ans
