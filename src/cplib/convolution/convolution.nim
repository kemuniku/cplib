when not declared CPLIB_CONVOLUTION_CONVOLUTION:
    const CPLIB_CONVOLUTION_CONVOLUTION* = 1
    import bitops, sequtils, std/math
    import cplib/modint/modint
    import cplib/math/inv_gcd
    import cplib/math/isprime

    {.emit: """
#ifndef CPLIB_CONVOLUTION_AVX2_NTT_HPP
#define CPLIB_CONVOLUTION_AVX2_NTT_HPP
#include <immintrin.h>
#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <vector>
#include <unordered_map>
#include <memory>
#pragma GCC target("avx2,bmi2")
#pragma GCC optimize("O3")
namespace cplib_avx2_ntt {
using u32 = std::uint32_t;
using u64 = std::uint64_t;
using Z=std::size_t;
using V=__m256i;
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
radix = (u32)((u64(1) << 32) % modulus);
radix_squared = (u32)(u64(radix) * radix % modulus);
}
inline u32 multiply(u32 a, u32 b) const {
const u64 product = u64(a) * b;
const u32 correction = (u32)(product) * negative_inverse;
u32 value = (u32)(
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
if (exponent & 1U) result = (u32)(u64(result) * base % modulus);
base = (u32)(u64(base) * base % modulus);
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
inline V shrink(V value) {
const V mod = _mm256_set1_epi32((int)(modulus));
return _mm256_min_epu32(value, _mm256_sub_epi32(value, mod));
}
inline V shrink_twice_modulus(V value) {
const V twice_modulus = _mm256_set1_epi32(
(int)(2U * modulus));
return _mm256_min_epu32(
value, _mm256_sub_epi32(value, twice_modulus));
}
inline V add_lazy(V a, V b) {
return _mm256_add_epi32(a, b);
}
inline V subtract_lazy(V a, V b) {
const V twice_modulus = _mm256_set1_epi32(
(int)(2U * modulus));
return _mm256_sub_epi32(_mm256_add_epi32(a, twice_modulus), b);
}
inline V add_mod(V a, V b) {
return shrink(_mm256_add_epi32(a, b));
}
inline V subtract_mod(V a, V b) {
const V mod = _mm256_set1_epi32((int)(modulus));
return shrink(_mm256_sub_epi32(_mm256_add_epi32(a, mod), b));
}
inline V montgomery_multiply_lazy(
V a, V b, const Montgomery& montgomery) {
const V inverse = _mm256_set1_epi32(
(int)(montgomery.negative_inverse));
const V mod = _mm256_set1_epi32((int)(modulus));
const V even_product = _mm256_mul_epu32(a, b);
const V odd_product = _mm256_mul_epu32(
_mm256_srli_epi64(a, 32), _mm256_srli_epi64(b, 32));
const V even_correction = _mm256_mul_epu32(even_product, inverse);
const V odd_correction = _mm256_mul_epu32(odd_product, inverse);
const V even_sum = _mm256_add_epi64(
even_product, _mm256_mul_epu32(even_correction, mod));
const V odd_sum = _mm256_add_epi64(
odd_product, _mm256_mul_epu32(odd_correction, mod));
const V even_result = _mm256_srli_epi64(even_sum, 32);
const V odd_result = _mm256_slli_epi64(
_mm256_srli_epi64(odd_sum, 32), 32);
return _mm256_or_si256(even_result, odd_result);
}
inline V montgomery_multiply(
V a, V b, const Montgomery& montgomery) {
return shrink(montgomery_multiply_lazy(a, b, montgomery));
}
class TransformPlan {
Z size_;
bool lazy_bottom_;
Montgomery montgomery_;
u32* twiddles_;
void fill_stage(u32* destination, Z count, u32 ratio) {
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
V powers = _mm256_loadu_si256(
(const V*)(first_powers));
u32 ratio_eighth = first_powers[7];
ratio_eighth = montgomery_.multiply(ratio_eighth, ratio_montgomery);
const V step = _mm256_set1_epi32((int)(ratio_eighth));
for (Z i = 0; i < count; i += 8) {
_mm256_storeu_si256(
(V*)(destination + i), powers);
powers = montgomery_multiply(powers, step, montgomery_);
}
}
void build_twiddles() {
for (Z length = size_;; length >>= 1) {
const Z half = length >> 1;
const Z offset = size_ - length;
const u32 root = power_mod(
primitive_root,
(u32)((modulus - 1) / length));
fill_stage(twiddles_ + offset, half, root);
if (length == 2) break;
}
}
void forward_single(
u32* data, Z length, u32* second = nullptr) const {
const Z half = length >> 1;
const u32* twiddle = twiddles_ + size_ - length;
for (Z block = 0; block < size_; block += length) {
for (Z j = 0; j < half; j += 8) {
const V weight = _mm256_loadu_si256(
(const V*)(twiddle + j));
const auto process = [&](u32* target) {
const V left = shrink_twice_modulus(
_mm256_loadu_si256((const V*)(
target + block + j)));
const V right = shrink_twice_modulus(
_mm256_loadu_si256((const V*)(
target + block + half + j)));
_mm256_storeu_si256(
(V*)(target + block + j),
add_lazy(left, right));
_mm256_storeu_si256(
(V*)(target + block + half + j),
montgomery_multiply_lazy(
subtract_lazy(left, right), weight, montgomery_));
};
process(data);
if (second != nullptr) process(second);
}
}
}
void forward_pair(
u32* data, Z length, u32* second = nullptr) const {
const Z quarter = length >> 2;
const u32* outer = twiddles_ + size_ - length;
const u32* inner = twiddles_ + size_ - (length >> 1);
for (Z block = 0; block < size_; block += length) {
for (Z j = 0; j < quarter; j += 8) {
const V outer0 = _mm256_loadu_si256(
(const V*)(outer + j));
const V outer1 = _mm256_loadu_si256(
(const V*)(outer + quarter + j));
const V inner_weight = _mm256_loadu_si256(
(const V*)(inner + j));
const auto process = [&](u32* target) {
const V a = shrink_twice_modulus(_mm256_loadu_si256(
(const V*)(target + block + j)));
const V b = shrink_twice_modulus(_mm256_loadu_si256(
(const V*)(target + block + quarter + j)));
const V c = shrink_twice_modulus(_mm256_loadu_si256(
(const V*)(target + block + 2 * quarter + j)));
const V d = shrink_twice_modulus(_mm256_loadu_si256(
(const V*)(target + block + 3 * quarter + j)));
const V ac_sum = shrink_twice_modulus(add_lazy(a, c));
const V ac_difference = montgomery_multiply_lazy(
subtract_lazy(a, c), outer0, montgomery_);
const V bd_sum = shrink_twice_modulus(add_lazy(b, d));
const V bd_difference = montgomery_multiply_lazy(
subtract_lazy(b, d), outer1, montgomery_);
_mm256_storeu_si256(
(V*)(target + block + j),
add_lazy(ac_sum, bd_sum));
_mm256_storeu_si256(
(V*)(target + block + quarter + j),
montgomery_multiply_lazy(
subtract_lazy(ac_sum, bd_sum), inner_weight, montgomery_));
_mm256_storeu_si256(
(V*)(target + block + 2 * quarter + j),
add_lazy(ac_difference, bd_difference));
_mm256_storeu_si256(
(V*)(target + block + 3 * quarter + j),
montgomery_multiply_lazy(
subtract_lazy(ac_difference, bd_difference),
inner_weight, montgomery_));
};
process(data);
if (second != nullptr) process(second);
}
}
}
void forward_pair_half_zero(u32* data, u32* second = nullptr) const {
const Z quarter = size_ >> 2;
const u32* outer = twiddles_;
const u32* inner = twiddles_ + (size_ >> 1);
for (Z j = 0; j < quarter; j += 8) {
const V outer0 = _mm256_loadu_si256(
(const V*)(outer + j));
const V outer1 = _mm256_loadu_si256(
(const V*)(outer + quarter + j));
const V inner_weight = _mm256_loadu_si256(
(const V*)(inner + j));
const auto process = [&](u32* target) {
const V a = _mm256_loadu_si256(
(const V*)(target + j));
const V b = _mm256_loadu_si256(
(const V*)(target + quarter + j));
const V first = montgomery_multiply_lazy(
a, outer0, montgomery_);
const V second_value = montgomery_multiply_lazy(
b, outer1, montgomery_);
_mm256_storeu_si256(
(V*)(target + j), add_lazy(a, b));
_mm256_storeu_si256(
(V*)(target + quarter + j),
montgomery_multiply_lazy(
subtract_lazy(a, b), inner_weight, montgomery_));
_mm256_storeu_si256(
(V*)(target + 2 * quarter + j),
add_lazy(first, second_value));
_mm256_storeu_si256(
(V*)(target + 3 * quarter + j),
montgomery_multiply_lazy(
subtract_lazy(first, second_value),
inner_weight, montgomery_));
};
process(data);
if (second != nullptr) process(second);
}
}
void forward_single_half_zero(u32* data, u32* second = nullptr) const {
const Z half = size_ >> 1;
for (Z j = 0; j < half; j += 8) {
const V value = _mm256_loadu_si256(
(const V*)(data + j));
const V weight = _mm256_loadu_si256(
(const V*)(twiddles_ + j));
_mm256_storeu_si256(
(V*)(data + half + j),
montgomery_multiply_lazy(value, weight, montgomery_));
if (second != nullptr) {
const V second_value = _mm256_loadu_si256(
(const V*)(second + j));
_mm256_storeu_si256(
(V*)(second + half + j),
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
const V w8 = _mm256_broadcastsi128_si256(w8_low);
const V w4 = _mm256_setr_epi32(
twiddle4[0], twiddle4[1], twiddle4[0], twiddle4[1],
twiddle4[0], twiddle4[1], twiddle4[0], twiddle4[1]);
for (Z block = 0; block < size_; block += 8) {
V value = shrink(shrink_twice_modulus(_mm256_loadu_si256(
(const V*)(data + block))));
V other = _mm256_permute2x128_si256(value, value, 1);
V sum = add_mod(value, other);
V difference = montgomery_multiply(
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
(V*)(data + block), value);
} else {
const V other_transform = _mm256_loadu_si256(
(const V*)(product + block));
_mm256_storeu_si256(
(V*)(product + block),
montgomery_multiply(
other_transform, value, montgomery_));
}
}
}
void inverse_single(
u32* data, Z length, bool canonicalize = false, bool upper_only = false) const {
const Z half = length >> 1;
const u32* twiddle = twiddles_ + size_ - length;
for (Z block = 0; block < size_; block += length) {
for (Z j = 0; j < half; j += 8) {
const V left = shrink_twice_modulus(_mm256_loadu_si256(
(const V*)(data + block + j)));
const V right = montgomery_multiply_lazy(
shrink_twice_modulus(_mm256_loadu_si256(
(const V*)(data + block + half + j))),
_mm256_loadu_si256((const V*)(
twiddle + j)),
montgomery_);
if (upper_only) {
V difference = subtract_lazy(left, right);
if (canonicalize) difference = shrink(shrink_twice_modulus(difference));
_mm256_storeu_si256((V*)(data + block + half + j), difference);
continue;
}
V sum = add_lazy(left, right);
V difference = subtract_lazy(left, right);
if (canonicalize) {
sum = shrink(shrink_twice_modulus(sum));
difference = shrink(shrink_twice_modulus(difference));
}
_mm256_storeu_si256(
(V*)(data + block + j), sum);
_mm256_storeu_si256(
(V*)(data + block + half + j),
difference);
}
}
}
void inverse_pair(u32* data, Z length, bool upper_only = false) const {
const Z quarter = length >> 2;
const u32* outer = twiddles_ + size_ - length;
const u32* inner = twiddles_ + size_ - (length >> 1);
for (Z block = 0; block < size_; block += length) {
for (Z j = 0; j < quarter; j += 8) {
const V a = shrink_twice_modulus(_mm256_loadu_si256(
(const V*)(data + block + j)));
const V b = shrink_twice_modulus(_mm256_loadu_si256(
(const V*)(data + block + quarter + j)));
const V c = shrink_twice_modulus(_mm256_loadu_si256(
(const V*)(data + block + 2 * quarter + j)));
const V d = shrink_twice_modulus(_mm256_loadu_si256(
(const V*)(data + block + 3 * quarter + j)));
const V inner_weight = _mm256_loadu_si256(
(const V*)(inner + j));
const V outer0 = _mm256_loadu_si256(
(const V*)(outer + j));
const V outer1 = _mm256_loadu_si256(
(const V*)(outer + quarter + j));
const V bw = montgomery_multiply_lazy(b, inner_weight, montgomery_);
const V dw = montgomery_multiply_lazy(d, inner_weight, montgomery_);
const V ab_sum = shrink_twice_modulus(add_lazy(a, bw));
const V ab_difference = shrink_twice_modulus(subtract_lazy(a, bw));
const V cd_sum = add_lazy(c, dw);
const V cd_difference = subtract_lazy(c, dw);
const V cd_sum_weighted = montgomery_multiply_lazy(
cd_sum, outer0, montgomery_);
const V cd_difference_weighted = montgomery_multiply_lazy(
cd_difference, outer1, montgomery_);
if (upper_only) {
V output2 = subtract_lazy(ab_sum, cd_sum_weighted);
V output3 = subtract_lazy(ab_difference, cd_difference_weighted);
if (length == size_) {
output2 = shrink(shrink_twice_modulus(output2));
output3 = shrink(shrink_twice_modulus(output3));
}
_mm256_storeu_si256((V*)(data + block + 2 * quarter + j), output2);
_mm256_storeu_si256((V*)(data + block + 3 * quarter + j), output3);
continue;
}
V output0 = add_lazy(ab_sum, cd_sum_weighted);
V output1 = add_lazy(
ab_difference, cd_difference_weighted);
V output2 = subtract_lazy(ab_sum, cd_sum_weighted);
V output3 = subtract_lazy(
ab_difference, cd_difference_weighted);
if (length == size_) {
output0 = shrink(shrink_twice_modulus(output0));
output1 = shrink(shrink_twice_modulus(output1));
output2 = shrink(shrink_twice_modulus(output2));
output3 = shrink(shrink_twice_modulus(output3));
}
_mm256_storeu_si256(
(V*)(data + block + j), output0);
_mm256_storeu_si256(
(V*)(data + block + quarter + j),
output1);
_mm256_storeu_si256(
(V*)(data + block + 2 * quarter + j),
output2);
_mm256_storeu_si256(
(V*)(data + block + 3 * quarter + j),
output3);
}
}
}
void inverse_bottom8(u32* data) const {
const u32* twiddle4 = twiddles_ + size_ - 4;
const u32* twiddle8 = twiddles_ + size_ - 8;
const V w4 = _mm256_setr_epi32(
twiddle4[0], twiddle4[1], twiddle4[0], twiddle4[1],
twiddle4[0], twiddle4[1], twiddle4[0], twiddle4[1]);
const __m128i w8_low = _mm_loadu_si128(
reinterpret_cast<const __m128i*>(twiddle8));
const V w8 = _mm256_broadcastsi128_si256(w8_low);
for (Z block = 0; block < size_; block += 8) {
V value = _mm256_loadu_si256(
(const V*)(data + block));
V other = _mm256_shuffle_epi32(value, 0xB1);
V sum = add_mod(value, other);
V difference = subtract_mod(value, other);
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
(V*)(data + block), value);
}
}
void forward_bottom8_lazy(u32* data, u32* product = nullptr) const {
const u32* twiddle8 = twiddles_ + size_ - 8;
const u32* twiddle4 = twiddles_ + size_ - 4;
const __m128i w8_low = _mm_loadu_si128(
reinterpret_cast<const __m128i*>(twiddle8));
const V w8 = _mm256_broadcastsi128_si256(w8_low);
const V w4 = _mm256_setr_epi32(
twiddle4[0], twiddle4[1], twiddle4[0], twiddle4[1],
twiddle4[0], twiddle4[1], twiddle4[0], twiddle4[1]);
for (Z block = 0; block < size_; block += 8) {
V value = shrink_twice_modulus(_mm256_loadu_si256(
(const V*)(data + block)));
V other = _mm256_permute2x128_si256(value, value, 1);
V sum = add_lazy(value, other);
V difference = montgomery_multiply_lazy(
subtract_lazy(value, other), w8, montgomery_);
value = _mm256_blend_epi32(
sum, _mm256_permute2x128_si256(difference, difference, 1), 0xF0);
value = shrink_twice_modulus(value);
other = _mm256_shuffle_epi32(value, 0x4E);
sum = add_lazy(value, other);
difference = montgomery_multiply_lazy(
subtract_lazy(value, other), w4, montgomery_);
value = _mm256_blend_epi32(
sum, _mm256_shuffle_epi32(difference, 0x4E), 0xCC);
value = shrink_twice_modulus(value);
other = _mm256_shuffle_epi32(value, 0xB1);
sum = add_lazy(value, other);
difference = subtract_lazy(value, other);
value = _mm256_blend_epi32(
sum, _mm256_shuffle_epi32(difference, 0xB1), 0xAA);
value = shrink(shrink_twice_modulus(value));
if (product == nullptr) {
_mm256_storeu_si256(
(V*)(data + block), value);
} else {
const V other_transform = _mm256_loadu_si256(
(const V*)(product + block));
_mm256_storeu_si256(
(V*)(product + block),
montgomery_multiply(
other_transform, value, montgomery_));
}
}
}
void inverse_bottom8_lazy(u32* data) const {
const u32* twiddle4 = twiddles_ + size_ - 4;
const u32* twiddle8 = twiddles_ + size_ - 8;
const V w4 = _mm256_setr_epi32(
twiddle4[0], twiddle4[1], twiddle4[0], twiddle4[1],
twiddle4[0], twiddle4[1], twiddle4[0], twiddle4[1]);
const __m128i w8_low = _mm_loadu_si128(
reinterpret_cast<const __m128i*>(twiddle8));
const V w8 = _mm256_broadcastsi128_si256(w8_low);
for (Z block = 0; block < size_; block += 8) {
V value = _mm256_loadu_si256(
(const V*)(data + block));
V other = _mm256_shuffle_epi32(value, 0xB1);
V sum = add_lazy(value, other);
V difference = subtract_lazy(value, other);
value = _mm256_blend_epi32(
sum, _mm256_shuffle_epi32(difference, 0xB1), 0xAA);
value = shrink_twice_modulus(value);
other = _mm256_shuffle_epi32(value, 0x4E);
other = montgomery_multiply_lazy(other, w4, montgomery_);
sum = add_lazy(value, other);
difference = subtract_lazy(value, other);
value = _mm256_blend_epi32(
sum, _mm256_shuffle_epi32(difference, 0x4E), 0xCC);
value = shrink_twice_modulus(value);
other = _mm256_permute2x128_si256(value, value, 1);
other = montgomery_multiply_lazy(other, w8, montgomery_);
sum = add_lazy(value, other);
difference = subtract_lazy(value, other);
value = _mm256_blend_epi32(
sum, _mm256_permute2x128_si256(difference, difference, 1), 0xF0);
_mm256_storeu_si256(
(V*)(data + block), value);
}
}
public:
explicit TransformPlan(Z size, bool lazy_bottom = false)
: size_(size), lazy_bottom_(lazy_bottom),
twiddles_(static_cast<u32*>(
_mm_malloc(sizeof(u32) * size, 32))) {
build_twiddles();
}
~TransformPlan() {
_mm_free(twiddles_);
}
const Montgomery& montgomery() const { return montgomery_; }
void prepare_inverse() {
for (Z length = size_;; length >>= 1) {
const Z half = length >> 1;
u32* stage = twiddles_ + size_ - length;
Z left = 1;
Z right = half - 1;
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
Z length = size_;
if ((__builtin_ctzll(size_) & 1) != 0) {
forward_single(data, length);
length >>= 1;
}
while (length > 16) {
forward_pair(data, length);
length >>= 2;
}
forward_single(data, 16);
if (lazy_bottom_) forward_bottom8_lazy(data, product);
else forward_bottom8(data, product);
}
void forward_half_zero(u32* data, u32* product = nullptr) const {
Z length;
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
if (lazy_bottom_) forward_bottom8_lazy(data, product);
else forward_bottom8(data, product);
}
void inverse(u32* data) const {
if (lazy_bottom_) inverse_bottom8_lazy(data);
else inverse_bottom8(data);
inverse_single(data, 16);
const bool has_unpaired_top = (__builtin_ctzll(size_) & 1) != 0;
const Z paired_limit = has_unpaired_top ? size_ >> 1 : size_;
for (Z length = 64; length <= paired_limit; length <<= 2) {
inverse_pair(data, length);
}
if (has_unpaired_top) inverse_single(data, size_, true);
}void inverse_high(u32* data) const {
if (lazy_bottom_) inverse_bottom8_lazy(data);
else inverse_bottom8(data);
inverse_single(data, 16);
const bool has_unpaired_top = (__builtin_ctzll(size_) & 1) != 0;
const Z paired_limit = has_unpaired_top ? size_ >> 1 : size_;
for (Z length = 64; length <= paired_limit; length <<= 2) {
inverse_pair(data, length, length == size_);
}
if (has_unpaired_top) inverse_single(data, size_, true, true);
}
};
inline void convolution_ntt_friendly(
u32* output,
const u32* left,
Z left_size,
const u32* right,
Z right_size,
Z transform_size,
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
const V one = _mm256_set1_epi32(1);
Z i = 0;
for (; i + 8 <= left_size; i += 8) {
const V value = _mm256_loadu_si256(
(const V*)(a + i));
_mm256_storeu_si256(
(V*)(a + i),
montgomery_multiply(value, one, montgomery));
}
for (; i < left_size; ++i) a[i] = montgomery.multiply(a[i], 1);
i = 0;
for (; i + 8 <= right_size; i += 8) {
const V value = _mm256_loadu_si256(
(const V*)(b + i));
_mm256_storeu_si256(
(V*)(b + i),
montgomery_multiply(value, one, montgomery));
}
for (; i < right_size; ++i) b[i] = montgomery.multiply(b[i], 1);
}
const Z half = transform_size >> 1;
const bool left_half_zero = left_size <= half;
const bool right_half_zero = right_size <= half;
std::memset(a + left_size, 0, sizeof(u32) *
((left_half_zero ? half : transform_size) - left_size));
std::memset(b + right_size, 0, sizeof(u32) *
((right_half_zero ? half : transform_size) - right_size));
const u32 inverse_size = power_mod(
(u32)(transform_size % modulus), modulus - 2);
const u32 scaled_radix_squared = (u32)(
u64(montgomery.radix_squared) * inverse_size % modulus);
const V conversion = _mm256_set1_epi32(
(int)(scaled_radix_squared));
const Z right_initialized = right_half_zero ? half : transform_size;
for (Z i = 0; i < right_initialized; i += 8) {
const V value = _mm256_loadu_si256(
(const V*)(b + i));
_mm256_storeu_si256(
(V*)(b + i),
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
const Z output_size = left_size + right_size - 1;
const V radix_squared = _mm256_set1_epi32(
(int)(montgomery.radix_squared));
Z i = 0;
for (; i + 8 <= output_size; i += 8) {
const V value = _mm256_loadu_si256(
(const V*)(a + i));
_mm256_storeu_si256(
(V*)(a + i),
montgomery_multiply(value, radix_squared, montgomery));
}
for (; i < output_size; ++i) {
a[i] = montgomery.to_montgomery(a[i]);
}
}
_mm_free(b);
}

// Bostan--Mori の変換結果を半分ずつ再利用する。
inline u32 bostan_mori_998(const u32* p0, Z plen, const u32* q0, Z qlen, u64 k, bool input_montgomery) {
modulus = 998244353U;
primitive_root = 3U;
Z half = 64;
while (half < std::max(plen, qlen)-1) half <<= 1;
const Z n = half * 2;
TransformPlan full(n), forward(half), inverse(half);
inverse.prepare_inverse();
const Montgomery& mont = full.montgomery();
u32* storage = static_cast<u32*>(_mm_malloc(sizeof(u32) * n * 4, 32));
u32* p = storage;
u32* q = p + n;
u32* a = q + n;
u32* b = a + half;
u32* twist = b + half;
u32* inverse_z = twist + half;
std::memset(p, 0, n * 2 * sizeof(u32));
for (Z i = 0; i < plen; ++i) p[i] = input_montgomery ? p0[i] : mont.to_montgomery(p0[i]);
for (Z i = 0; i < qlen; ++i) q[i] = input_montgomery ? q0[i] : mont.to_montgomery(q0[i]);
const u32 invhalf = mont.to_montgomery(power_mod(half, modulus-2));
const u32 half_mont = mont.to_montgomery(half);
u32 plead = plen > half ? p[half] : 0;
u32 qlead = qlen > half ? q[half] : 0;
const u32 root = mont.to_montgomery(power_mod(3, (modulus-1)/n));
const u32 iroot = mont.to_montgomery(power_mod(3, modulus-1-(modulus-1)/n));
u32 w = mont.radix;
Z rev = 0;
for (Z i=0; i<half; ++i) {
twist[i] = mont.multiply(w, invhalf);
w = mont.multiply(w, root);
}
w = mont.radix;
for (Z i=0; i<half; ++i) {
inverse_z[rev] = w;
w = mont.multiply(w, iroot);
Z bit = half >> 1;
while (bit && (rev & bit)) { rev ^= bit; bit >>= 1; }
rev ^= bit;
}
if (plen > half) full.forward(p); else full.forward_half_zero(p);
if (qlen > half) full.forward(q); else full.forward_half_zero(q);
while (k > 0) {
const V evens = _mm256_setr_epi32(0,2,4,6,0,2,4,6);
for (Z i=0; i<half; i+=8) {
V pp[2], qq[2];
for (int t=0; t<2; ++t) {
const V pv = _mm256_loadu_si256((const V*)(p+2*i+8*t));
const V qv = _mm256_loadu_si256((const V*)(q+2*i+8*t));
const V qs = _mm256_shuffle_epi32(qv,0xB1);
const V uv = montgomery_multiply(pv,qs,mont);
const V vu = _mm256_shuffle_epi32(uv,0xB1);
pp[t] = _mm256_permutevar8x32_epi32((k&1) ? subtract_mod(uv,vu) : add_mod(uv,vu),evens);
const V product = montgomery_multiply(qv,qs,mont);
qq[t] = _mm256_permutevar8x32_epi32(add_mod(product,product),evens);
}
V resultp = _mm256_permute2x128_si256(pp[0],pp[1],0x20);
if (k&1) resultp = montgomery_multiply(resultp,_mm256_loadu_si256((const V*)(inverse_z+i)),mont);
_mm256_storeu_si256((V*)(a+i),resultp);
_mm256_storeu_si256((V*)(b+i),_mm256_permute2x128_si256(qq[0],qq[1],0x20));
}
plead = (k & 1) ? 0 : mont.multiply(plead,qlead);
plead = add_mod(plead,plead);
qlead = mont.multiply(qlead,qlead);
qlead = add_mod(qlead,qlead);
k >>= 1;
std::memcpy(p, a, half*sizeof(u32));
std::memcpy(q, b, half*sizeof(u32));
inverse.inverse(a);
inverse.inverse(b);
const u32 pcorrection = mont.multiply(plead,half_mont);
const u32 qcorrection = mont.multiply(qlead,half_mont);
a[0] = subtract_mod(a[0],pcorrection);
b[0] = subtract_mod(b[0],qcorrection);
if (k < 32) {
const Z upto = Z(k);
for (Z i=0; i<=upto; ++i) {
a[i] = mont.multiply(a[i], invhalf);
b[i] = mont.multiply(b[i], invhalf);
}
const u32 invq0 = mont.to_montgomery(power_mod(mont.multiply(b[0],1),modulus-2));
for (Z i=0; i<=upto; ++i) {
for (Z j=1; j<=i; ++j) a[i] = subtract_mod(a[i],mont.multiply(b[j],a[i-j]));
a[i] = mont.multiply(a[i],invq0);
}
const u32 answer = mont.multiply(a[upto],1);
_mm_free(storage);
return answer;
}
if (k < half / 2) {
for (Z i=0; i<=Z(k); ++i) {
a[i] = mont.multiply(a[i], invhalf);
b[i] = mont.multiply(b[i], invhalf);
}
const u32 answer = bostan_mori_998(a, Z(k)+1, b, Z(k)+1, k, true);
_mm_free(storage);
return answer;
}
a[0] = subtract_mod(a[0],pcorrection);
b[0] = subtract_mod(b[0],qcorrection);
for (Z i=0; i<half; i+=8) {
const V weight = _mm256_loadu_si256((const V*)(twist+i));
_mm256_storeu_si256((V*)(p+half+i), montgomery_multiply(shrink(shrink_twice_modulus(_mm256_loadu_si256((const V*)(a+i)))),weight,mont));
_mm256_storeu_si256((V*)(q+half+i), montgomery_multiply(shrink(shrink_twice_modulus(_mm256_loadu_si256((const V*)(b+i)))),weight,mont));
}
forward.forward(p+half);
forward.forward(q+half);
}
_mm_free(storage);
return 0;
}


class MultipointCyclicEvaluator {
using Poly = std::vector<u32>;
Z size_, count_, points_;
u32 mod_, root_;
Montgomery mont_;
std::vector<Poly> spectra_;
Poly leading_, corrections_, x_, leaves_;
std::unordered_map<u32, u32> exceptional_;
u32 multiply(u32 a, u32 b) const { return mont_.multiply(a, b); }
u32 inverse(u32 a) const {
return mont_.to_montgomery(power_mod(multiply(a, 1), mod_ - 2));
}
void scale(Poly& a, u32 factor) const {
const V multiplier = _mm256_set1_epi32((int)factor);
Z i = 0;
for (; i + 8 <= a.size(); i += 8) {
const V value = _mm256_loadu_si256((const V*)(a.data() + i));
_mm256_storeu_si256((V*)(a.data() + i), montgomery_multiply(value, multiplier, mont_));
}
for (; i < a.size(); ++i) a[i] = multiply(a[i], factor);
}
void build() {
// 積のスペクトルを倍長化し、係数表現への往復を各段で半分の長さに抑える。
const Z block = 16;
TransformPlan leaf_plan(32, true);
// 独立した8個の葉をSIMDの各レーンへ置き、積の係数を並行して構築する。
Z index = 0;
for (; index + 8 <= count_; index += 8) {
V coefficients[17]; coefficients[0] = _mm256_set1_epi32((int)mont_.radix);
for (Z k = 1; k <= block; ++k) coefficients[k] = _mm256_setzero_si256();
for (Z j = 0; j < block; ++j) {
u32 points[8];
for (Z lane = 0; lane < 8; ++lane) {
const Z position = (index + lane) * block + j;
points[lane] = position < points_ && corrections_[position] != 0 ? x_[position] : 0;
}
const V point = _mm256_loadu_si256((const V*)points);
for (Z k = j + 1; k > 0; --k)
coefficients[k] = subtract_mod(coefficients[k], montgomery_multiply(point, coefficients[k - 1], mont_));
}
u32 packed[17][8];
for (Z k = 0; k <= block; ++k) _mm256_storeu_si256((V*)packed[k], coefficients[k]);
for (Z lane = 0; lane < 8; ++lane) {
Poly polynomial(32, 0);
for (Z k = 0; k <= block; ++k) polynomial[k] = packed[k][lane];
std::memcpy(leaves_.data() + (index + lane) * 17, polynomial.data(), sizeof(u32) * 17);
leading_[count_ + index + lane] = polynomial[block];
leaf_plan.forward(polynomial.data());
spectra_[count_ + index + lane] = std::move(polynomial);
}
}
for (; index < count_; ++index) {
Poly coefficients(32, 0); coefficients[0] = mont_.radix;
for (Z j = 0; j < block; ++j) {
const Z position = index * block + j;
const u32 point = position < points_ && corrections_[position] != 0 ? x_[position] : 0;
Z k = j + 1;
const V x = _mm256_set1_epi32((int)point);
for (; k >= 8; k -= 8) {
const V old = _mm256_loadu_si256((const V*)(coefficients.data() + k - 7));
const V previous = _mm256_loadu_si256((const V*)(coefficients.data() + k - 8));
_mm256_storeu_si256((V*)(coefficients.data() + k - 7), subtract_mod(old, montgomery_multiply(x, previous, mont_)));
}
for (; k > 0; --k)
coefficients[k] = subtract_mod(coefficients[k], multiply(point, coefficients[k - 1]));
}
std::memcpy(leaves_.data() + index * 17, coefficients.data(), sizeof(u32) * 17);
leading_[count_ + index] = coefficients[block];
leaf_plan.forward(coefficients.data());
spectra_[count_ + index] = std::move(coefficients);
}
for (Z width = 32, first = count_ / 2; first; width *= 2, first /= 2) {
std::unique_ptr<TransformPlan> forward, backward;
if (first != 1) { forward.reset(new TransformPlan(width, true)); backward.reset(new TransformPlan(width, true)); backward->prepare_inverse(); }
const u32 inv_width = mont_.to_montgomery(power_mod((u32)width, mod_ - 2));
Poly twists;
if (first != 1) {
const u32 twist = mont_.to_montgomery(power_mod(root_, (mod_ - 1) / (2 * width)));
twists.resize(width);
u32 first_powers[8]; first_powers[0] = mont_.radix;
for (Z i = 1; i < 8; ++i) first_powers[i] = multiply(first_powers[i - 1], twist);
V powers = _mm256_loadu_si256((const V*)first_powers);
const V step = _mm256_set1_epi32((int)multiply(first_powers[7], twist));
const V normalizer = _mm256_set1_epi32((int)inv_width);
for (Z i = 0; i < width; i += 8) {
_mm256_storeu_si256((V*)(twists.data() + i), montgomery_multiply(powers, normalizer, mont_));
powers = montgomery_multiply(powers, step, mont_);
}
}
for (Z node = first; node < first * 2; ++node) {
auto& left = spectra_[2 * node]; auto& right = spectra_[2 * node + 1];
Poly product(width);
for (Z i = 0; i < width; i += 8) {
const V a = _mm256_loadu_si256((const V*)(left.data() + i));
const V b = _mm256_loadu_si256((const V*)(right.data() + i));
_mm256_storeu_si256((V*)(product.data() + i), montgomery_multiply(a, b, mont_));
}
leading_[node] = multiply(leading_[2 * node], leading_[2 * node + 1]);
scale(left, inv_width); scale(right, inv_width);
if (first == 1) { spectra_[node] = std::move(product); continue; }
Poly odd = product;
backward->inverse(odd.data());
odd[0] = subtract_mod(odd[0], multiply(add_mod(leading_[node], leading_[node]), mont_.to_montgomery((u32)width)));
for (Z i = 0; i < width; i += 8) {
const V value = _mm256_loadu_si256((const V*)(odd.data() + i));
const V weight = _mm256_loadu_si256((const V*)(twists.data() + i));
_mm256_storeu_si256((V*)(odd.data() + i), montgomery_multiply(value, weight, mont_));
}
forward->forward(odd.data());
product.insert(product.end(), odd.begin(), odd.end());
spectra_[node] = std::move(product);
}
}
}
Poly initial(const u32* f, Z length) {
// 巡回環で根の積を一括逆元により除算し、例外点は最初のNTTから回収する。
Poly transformed(size_, 0);
for (Z i = 0; i < length; ++i) transformed[size_ - 1 - i] = mont_.to_montgomery(f[i]);
TransformPlan forward(size_, true);
forward.forward(transformed.data());
if (!exceptional_.empty()) {
const u32 root = mont_.to_montgomery(power_mod(root_, (mod_ - 1) / size_));
const u32 root_inverse = inverse(root);
u32 t = mont_.radix, p = mont_.radix; Z reversed = 0;
for (Z index = 0; index < size_; ++index) {
auto found = exceptional_.find(p);
if (found != exceptional_.end()) found->second = multiply(multiply(transformed[reversed], t), 1);
t = multiply(t, root); p = multiply(p, root_inverse);
Z bit = size_ >> 1;
while (bit && (reversed & bit)) { reversed ^= bit; bit >>= 1; }
reversed ^= bit;
}
}
const auto& denominator = spectra_[1];
// 8本の独立した積列を同時に走査し、最後の8個だけスカラーで一括反転する。
Poly prefix(size_);
V product = _mm256_set1_epi32((int)mont_.radix);
for (Z i = 0; i < size_; i += 8) {
_mm256_storeu_si256((V*)(prefix.data() + i), product);
product = montgomery_multiply(product, _mm256_loadu_si256((const V*)(denominator.data() + i)), mont_);
}
u32 totals[8], cumulative[9], reciprocals[8];
_mm256_storeu_si256((V*)totals, product); cumulative[0] = mont_.radix;
for (Z i = 0; i < 8; ++i) cumulative[i + 1] = multiply(cumulative[i], totals[i]);
u32 suffix = inverse(cumulative[8]);
for (Z i = 8; i-- > 0;) {
reciprocals[i] = multiply(cumulative[i], suffix);
suffix = multiply(suffix, totals[i]);
}
V inverse_product = _mm256_loadu_si256((const V*)reciprocals);
for (Z i = size_; i != 0;) {
i -= 8;
const V reciprocal = montgomery_multiply(_mm256_loadu_si256((const V*)(prefix.data() + i)), inverse_product, mont_);
_mm256_storeu_si256((V*)(transformed.data() + i), montgomery_multiply(_mm256_loadu_si256((const V*)(transformed.data() + i)), reciprocal, mont_));
inverse_product = montgomery_multiply(inverse_product, _mm256_loadu_si256((const V*)(denominator.data() + i)), mont_);
}
return transformed;
}
Poly descend(Poly current) const {
// 一つの親NTTから二つの中間積を作り、上半分だけ次段へ渡す。
Poly next(size_), parent(size_), left(size_), right(size_);
for (Z width = size_, first = 1; first < count_; width /= 2, first *= 2) {
std::unique_ptr<TransformPlan> forward;
if (first != 1) forward.reset(new TransformPlan(width, true));
TransformPlan backward(width, true); backward.prepare_inverse();
for (Z index = 0; index < first; ++index) {
const Z node = first + index;
std::memcpy(parent.data(), current.data() + index * width, sizeof(u32) * width);
if (first != 1) forward->forward(parent.data());
for (Z i = 0; i < width; i += 8) {
const V value = _mm256_loadu_si256((const V*)(parent.data() + i));
_mm256_storeu_si256((V*)(left.data() + i), montgomery_multiply(value,
_mm256_loadu_si256((const V*)(spectra_[2 * node + 1].data() + i)), mont_));
_mm256_storeu_si256((V*)(right.data() + i), montgomery_multiply(value,
_mm256_loadu_si256((const V*)(spectra_[2 * node].data() + i)), mont_));
}
backward.inverse_high(left.data()); backward.inverse_high(right.data());
std::memcpy(next.data() + index * width, left.data() + width / 2, sizeof(u32) * (width / 2));
std::memcpy(next.data() + index * width + width / 2, right.data() + width / 2, sizeof(u32) * (width / 2));
}
current.swap(next);
}
return current;
}
public:
MultipointCyclicEvaluator(const u32* points, Z point_count, Z size)
: size_(size), count_(size / 16), points_(point_count), mod_(modulus), root_(primitive_root),
  spectra_(2 * count_), leading_(2 * count_), corrections_(point_count), x_(point_count), leaves_(count_ * 17) {
// p^L=1の点だけ別処理し、残りの因子を巡回環の単元にする。
const V radix_squared = _mm256_set1_epi32((int)mont_.radix_squared);
const V one = _mm256_set1_epi32((int)mont_.radix);
Z i = 0;
for (; i + 8 <= points_; i += 8) {
V value = montgomery_multiply(_mm256_loadu_si256((const V*)(points + i)), radix_squared, mont_);
_mm256_storeu_si256((V*)(x_.data() + i), value);
for (Z length = 1; length < size_; length *= 2) value = montgomery_multiply(value, value, mont_);
_mm256_storeu_si256((V*)(corrections_.data() + i), subtract_mod(one, value));
}
for (; i < points_; ++i) {
x_[i] = mont_.to_montgomery(points[i]);
u32 power = x_[i];
for (Z length = 1; length < size_; length *= 2) power = multiply(power, power);
corrections_[i] = subtract_mod(mont_.radix, power);
}
for (i = 0; i < points_; ++i) if (corrections_[i] == 0) exceptional_.emplace(x_[i], 0);
}
void run(u32* output, const u32* f, Z length) {
// ブロックの剰余を復元し、1-p^Lの補正を加えて全点で評価する。
build(); Poly current = descend(initial(f, length));
for (Z index = 0; index < count_; ++index) {
const Z first = index * 16, last = std::min(first + 16, points_);
if (first >= points_) break;
const u32* product = leaves_.data() + index * 17;
u32 reversed[16] = {};
for (Z i = 0; i < 16; ++i)
for (Z j = 0; j <= i; ++j) reversed[i] = add_mod(reversed[i], multiply(current[first + j], product[i - j]));
Z i = first;
const V one = _mm256_set1_epi32(1);
for (; i + 8 <= last; i += 8) {
const V point = _mm256_loadu_si256((const V*)(x_.data() + i));
V value = _mm256_setzero_si256();
for (Z j = 0; j < 16; ++j) value = add_mod(montgomery_multiply(value, point, mont_), _mm256_set1_epi32((int)reversed[j]));
value = montgomery_multiply(value, _mm256_loadu_si256((const V*)(corrections_.data() + i)), mont_);
_mm256_storeu_si256((V*)(output + i), montgomery_multiply(value, one, mont_));
}
for (; i < last; ++i) {
u32 value = 0;
for (Z j = 0; j < 16; ++j) value = add_mod(multiply(value, x_[i]), reversed[j]);
output[i] = multiply(multiply(value, corrections_[i]), 1);
}
for (i = first; i < last; ++i)
if (corrections_[i] == 0) output[i] = exceptional_.find(x_[i])->second;
}
}
};

class MultipointProductTree {
Z size_, block_, count_;
u32 modulus_, root_;
std::vector<std::vector<u32>> products_, spectra_;
public:
MultipointProductTree(const u32* leaves, Z size, Z block, u32 mod)
: size_(size), block_(block), count_(size / block), modulus_(mod),
  root_(0), products_(2 * count_), spectra_(2 * count_) {
// 子の変換を積木の構築と中間積の下降で共有する。
modulus = modulus_; root_ = find_primitive_root(modulus_); primitive_root = root_;
for (Z i = 0; i < count_; ++i)
products_[count_ + i].assign(leaves + i * (block_ + 1), leaves + (i + 1) * (block_ + 1));
for (Z width = block_ * 2, first = count_ / 2; first; width *= 2, first /= 2) {
TransformPlan forward(width), inverse(width); inverse.prepare_inverse();
const Montgomery& mont = forward.montgomery();
const u32 scale = (u32)(u64(mont.radix_squared) * power_mod((u32)width, modulus - 2) % modulus);
for (Z node = first; node < first * 2; ++node) {
auto& left = spectra_[node * 2]; auto& right = spectra_[node * 2 + 1];
left = products_[node * 2]; right = products_[node * 2 + 1];
const u32 top = (u32)(u64(left.back()) * right.back() % modulus);
left.resize(width); right.resize(width);
forward.forward(left.data()); forward.forward(right.data());
auto& product = products_[node]; product.resize(width + 1);
const V conversion = _mm256_set1_epi32((int)scale);
for (Z i = 0; i < width; i += 8) {
const V a = _mm256_loadu_si256((const V*)(left.data() + i));
const V b = montgomery_multiply(_mm256_loadu_si256((const V*)(right.data() + i)), conversion, mont);
_mm256_storeu_si256((V*)(product.data() + i), montgomery_multiply(a, b, mont));
_mm256_storeu_si256((V*)(left.data() + i), montgomery_multiply(a, conversion, mont));
_mm256_storeu_si256((V*)(right.data() + i), b);
}
inverse.inverse(product.data());
product[0] = subtract_mod(product[0], top); product[width] = top;
std::vector<u32>().swap(products_[node * 2]);
std::vector<u32>().swap(products_[node * 2 + 1]);
}
}
}
void root(u32* output) const {
// 根の反転多項式を返す。
std::memcpy(output, products_[1].data(), sizeof(u32) * (size_ + 1));
}
void descend(u32* output, const u32* input) const {
// 各親の変換を一度だけ行い、保存した兄弟の変換と乗算する。
modulus = modulus_; primitive_root = root_;
std::vector<u32> current(input, input + size_), next(size_);
std::vector<u32> parent(size_), left(size_), right(size_);
for (Z width = size_, first = 1; first < count_; width /= 2, first *= 2) {
TransformPlan forward(width), inverse(width); inverse.prepare_inverse();
const Montgomery& mont = forward.montgomery();
for (Z index = 0; index < first; ++index) {
const Z node = first + index;
std::memcpy(parent.data(), current.data() + index * width, sizeof(u32) * width);
forward.forward(parent.data());
for (Z i = 0; i < width; i += 8) {
const V value = _mm256_loadu_si256((const V*)(parent.data() + i));
_mm256_storeu_si256((V*)(left.data() + i), montgomery_multiply(value,
_mm256_loadu_si256((const V*)(spectra_[node * 2 + 1].data() + i)), mont));
_mm256_storeu_si256((V*)(right.data() + i), montgomery_multiply(value,
_mm256_loadu_si256((const V*)(spectra_[node * 2].data() + i)), mont));
}
inverse.inverse(left.data()); inverse.inverse(right.data());
std::memcpy(next.data() + index * width, left.data() + width / 2, sizeof(u32) * (width / 2));
std::memcpy(next.data() + index * width + width / 2, right.data() + width / 2, sizeof(u32) * (width / 2));
}
current.swap(next);
}
std::memcpy(output, current.data(), sizeof(u32) * size_);
}
};

class FixedConvolution {
Z size_;
u32 modulus_, root_;
u32* fixed_;
TransformPlan *forward_, *inverse_;
public:
FixedConvolution(const u32* data, Z length, Z size, u32 mod, u32 root)
: size_(size), modulus_(mod), root_(root) {
// 固定側の変換と正逆変換の計画を一度だけ構築する。
modulus = modulus_;
if (root_ == 0) root_ = find_primitive_root(modulus_);
primitive_root = root_;
forward_ = new TransformPlan(size_);
inverse_ = new TransformPlan(size_);
inverse_->prepare_inverse();
fixed_ = static_cast<u32*>(_mm_malloc(sizeof(u32) * size_, 32));
const Montgomery& mont = forward_->montgomery();
const u32 scale = (u32)(u64(mont.radix_squared) *
power_mod((u32)size_, modulus - 2) % modulus);
for (Z i = 0; i < length; ++i) fixed_[i] = mont.multiply(data[i], scale);
std::memset(fixed_ + length, 0, sizeof(u32) * (size_ - length));
if (length <= size_ / 2) forward_->forward_half_zero(fixed_);
else forward_->forward(fixed_);
}
~FixedConvolution() {
// 固定側の変換と計画を解放する。
_mm_free(fixed_);
delete forward_;
delete inverse_;
}
void run(u32* output, const u32* data, Z length) {
// 固定側を保持したまま、可変側の変換・点ごとの積・逆変換を行う。
modulus = modulus_;
primitive_root = root_;
std::memcpy(output, data, sizeof(u32) * length);
const bool half_zero = length <= size_ / 2;
std::memset(output + length, 0,
sizeof(u32) * ((half_zero ? size_ / 2 : size_) - length));
if (half_zero) forward_->forward_half_zero(output);
else forward_->forward(output);
const Montgomery& mont = forward_->montgomery();
for (Z i = 0; i < size_; i += 8) {
const V a = _mm256_loadu_si256((const V*)(output + i));
const V b = _mm256_loadu_si256((const V*)(fixed_ + i));
_mm256_storeu_si256((V*)(output + i), montgomery_multiply(a, b, mont));
}
inverse_->inverse(output);
}
};

class PolynomialSequenceProduct998 {
struct Product {
const u32* data;
Z size;
};
const Z* sizes_;
Z factor_count_;
Z* degree_prefix_;
u32* coefficients_;
u32* pool_;
Z current_;
u32* work_left_;
u32* work_right_;
Z work_size_;
TransformPlan* forward_plans_[32];
TransformPlan* inverse_plans_[32];
u32 inverse_scales_[32];
Montgomery montgomery_;

inline u32 multiply_mod(u32 a, u32 b) const {
return montgomery_.multiply(a, b);
}
inline void add_product(u32& destination, u32 a, u32 b) const {
const u32 product = multiply_mod(a, b);
destination += product;
if (destination >= 998244353U) destination -= 998244353U;
}
Z balanced_middle(Z left, Z right) const {
if (right - left == 2) return left + 1;
const Z target = degree_prefix_[left] +
(degree_prefix_[right] - degree_prefix_[left]) / 2;
Z low = left + 1;
Z high = right;
while (low < high) {
const Z middle = (low + high) / 2;
if (degree_prefix_[middle] < target) low = middle + 1;
else high = middle;
}
if (low > left + 1) {
const Z left_degree = degree_prefix_[low] - degree_prefix_[left];
const Z right_degree = degree_prefix_[right] - degree_prefix_[low];
const Z current_difference = left_degree > right_degree
? left_degree - right_degree : right_degree - left_degree;
const Z previous_left = degree_prefix_[low - 1] - degree_prefix_[left];
const Z previous_right = degree_prefix_[right] - degree_prefix_[low - 1];
const Z previous_difference = previous_left > previous_right
? previous_left - previous_right : previous_right - previous_left;
if (previous_difference < current_difference) --low;
}
return low;
}
Z required_capacity(Z left, Z right) const {
if (left + 1 == right) return 0;
const Z middle = balanced_middle(left, right);
const Z output_size = degree_prefix_[right] - degree_prefix_[left] + 1;
const Z left_size = degree_prefix_[middle] - degree_prefix_[left] + 1;
const Z left_capacity = required_capacity(left, middle);
const Z right_capacity = required_capacity(middle, right);
const Z right_offset = middle - left > 1 ? left_size : 0;
const Z child_capacity = left_capacity > right_offset + right_capacity
? left_capacity : right_offset + right_capacity;
return output_size + child_capacity;
}
void reserve_work(Z size) {
if (work_size_ >= size) return;
_mm_free(work_left_);
_mm_free(work_right_);
work_left_ = static_cast<u32*>(_mm_malloc(sizeof(u32) * size, 32));
work_right_ = static_cast<u32*>(_mm_malloc(sizeof(u32) * size, 32));
work_size_ = size;
}
TransformPlan& forward_plan(Z size) {
const unsigned index = (unsigned)__builtin_ctzll(size);
if (forward_plans_[index] == nullptr) {
forward_plans_[index] = new TransformPlan(size);
inverse_plans_[index] = new TransformPlan(size);
inverse_plans_[index]->prepare_inverse();
const u32 inverse_size = power_mod(
(u32)(size % 998244353U), 998244351U);
inverse_scales_[index] = (u32)(
u64(montgomery_.radix) * inverse_size % 998244353U);
}
return *forward_plans_[index];
}
TransformPlan& inverse_plan(Z size) {
const unsigned index = (unsigned)__builtin_ctzll(size);
return *inverse_plans_[index];
}
void multiply_schoolbook(
u32* output, const u32* left, Z left_size,
const u32* right, Z right_size) const {
const Z output_size = left_size + right_size - 1;
std::memset(output, 0, sizeof(u32) * output_size);
const u32* outer = left;
const u32* inner = right;
Z outer_size = left_size;
Z inner_size = right_size;
if (inner_size < outer_size) {
const u32* pointer_swap = outer;
outer = inner;
inner = pointer_swap;
const Z size_swap = outer_size;
outer_size = inner_size;
inner_size = size_swap;
}
for (Z i = 0; i < outer_size; ++i) {
const V coefficient = _mm256_set1_epi32((int)outer[i]);
Z j = 0;
for (; j + 8 <= inner_size; j += 8) {
const V value = _mm256_loadu_si256((const V*)(inner + j));
const V product = montgomery_multiply(value, coefficient, montgomery_);
const V previous = _mm256_loadu_si256((const V*)(output + i + j));
_mm256_storeu_si256((V*)(output + i + j), add_mod(previous, product));
}
for (; j < inner_size; ++j) {
add_product(output[i + j], outer[i], inner[j]);
}
}
}
void multiply_naive(
u32* output, const u32* left, Z left_size,
const u32* right, Z right_size) const {
multiply_schoolbook(output, left, left_size, right, right_size);
}
void multiply_ntt(
u32* output, const u32* left, Z left_size,
const u32* right, Z right_size, Z transform_size) {
reserve_work(transform_size);
u32* a = work_left_;
u32* b = work_right_;
std::memcpy(a, left, sizeof(u32) * left_size);
std::memcpy(b, right, sizeof(u32) * right_size);
TransformPlan& forward = forward_plan(transform_size);
const Z half = transform_size >> 1;
const bool left_half_zero = left_size <= half;
const bool right_half_zero = right_size <= half;
std::memset(a + left_size, 0, sizeof(u32) *
((left_half_zero ? half : transform_size) - left_size));
std::memset(b + right_size, 0, sizeof(u32) *
((right_half_zero ? half : transform_size) - right_size));
const unsigned index = (unsigned)__builtin_ctzll(transform_size);
const V conversion = _mm256_set1_epi32((int)inverse_scales_[index]);
const Z right_initialized = right_half_zero ? half : transform_size;
for (Z i = 0; i < right_initialized; i += 8) {
const V value = _mm256_loadu_si256((const V*)(b + i));
_mm256_storeu_si256(
(V*)(b + i), montgomery_multiply(value, conversion, montgomery_));
}
if (left_half_zero) forward.forward_half_zero(a);
else forward.forward(a);
if (right_half_zero) forward.forward_half_zero(b, a);
else forward.forward(b, a);
inverse_plan(transform_size).inverse(a);
std::memcpy(output, a, sizeof(u32) * (left_size + right_size - 1));
}
void multiply(
u32* output, const u32* left, Z left_size,
const u32* right, Z right_size) {
if (left_size <= 60 || right_size <= 60) {
multiply_naive(output, left, left_size, right, right_size);
return;
}
const Z output_size = left_size + right_size - 1;
Z transform_size = 1;
while (transform_size < output_size) transform_size <<= 1;
if (left_size + right_size - 3 <= (transform_size >> 1)) {
multiply(output, left, left_size - 1, right, right_size - 1);
output[output_size - 2] = 0;
output[output_size - 1] = multiply_mod(
left[left_size - 1], right[right_size - 1]);
const u32 right_last = right[right_size - 1];
for (Z i = 0; i + 1 < left_size; ++i) {
add_product(output[i + right_size - 1], left[i], right_last);
}
const u32 left_last = left[left_size - 1];
for (Z i = 0; i + 1 < right_size; ++i) {
add_product(output[i + left_size - 1], right[i], left_last);
}
return;
}
multiply_ntt(output, left, left_size, right, right_size, transform_size);
}
Product solve(Z left, Z right) {
if (left + 1 == right) {
return Product{
coefficients_ + degree_prefix_[left] + left, sizes_[left]};
}
const Z middle = balanced_middle(left, right);
const Z output_size = degree_prefix_[right] - degree_prefix_[left] + 1;
const Z mark = current_;
u32* output = pool_ + current_;
current_ += output_size;
const Product left_product = solve(left, middle);
const Product right_product = solve(middle, right);
multiply(output, left_product.data, left_product.size,
right_product.data, right_product.size);
current_ = mark + output_size;
return Product{output, output_size};
}

public:
PolynomialSequenceProduct998(
const u32* const* factors, const Z* sizes, Z factor_count)
: sizes_(sizes), factor_count_(factor_count),
degree_prefix_(new Z[factor_count + 1]),
coefficients_(nullptr), pool_(nullptr), current_(0),
work_left_(nullptr), work_right_(nullptr), work_size_(0),
forward_plans_{}, inverse_plans_{}, inverse_scales_{} {
Z coefficient_count = 0;
for (Z i = 0; i < factor_count_; ++i) coefficient_count += sizes_[i];
coefficients_ = static_cast<u32*>(_mm_malloc(
sizeof(u32) * coefficient_count, 32));
Z offset = 0;
degree_prefix_[0] = 0;
for (Z i = 0; i < factor_count_; ++i) {
for (Z j = 0; j < sizes_[i]; ++j) {
coefficients_[offset + j] = montgomery_.to_montgomery(factors[i][j]);
}
offset += sizes_[i];
degree_prefix_[i + 1] = degree_prefix_[i] + sizes_[i] - 1;
}
if (factor_count_ > 1) {
pool_ = static_cast<u32*>(_mm_malloc(
sizeof(u32) * required_capacity(0, factor_count_), 32));
}
}
~PolynomialSequenceProduct998() {
for (unsigned i = 0; i < 32; ++i) {
delete forward_plans_[i];
delete inverse_plans_[i];
}
_mm_free(work_left_);
_mm_free(work_right_);
_mm_free(coefficients_);
_mm_free(pool_);
delete[] degree_prefix_;
}
void run(u32* output) {
Product product;
if (factor_count_ == 1) {
product = Product{coefficients_, sizes_[0]};
} else {
product = solve(0, factor_count_);
}
const V one = _mm256_set1_epi32(1);
Z i = 0;
for (; i + 8 <= product.size; i += 8) {
const V value = _mm256_loadu_si256((const V*)(product.data + i));
_mm256_storeu_si256(
(V*)(output + i), montgomery_multiply(value, one, montgomery_));
}
for (; i < product.size; ++i) {
output[i] = montgomery_.multiply(product.data[i], 1);
}
}
};

inline void product_polynomial_sequence_998(
u32* output, const u32* const* factors,
const Z* sizes, Z factor_count) {
modulus = 998244353U;
primitive_root = 3U;
PolynomialSequenceProduct998 context(factors, sizes, factor_count);
context.run(output);
}
}
#endif
extern "C" std::uint32_t cplib_bostan_mori_998(std::uint32_t* p, std::size_t plen, std::uint32_t* q, std::size_t qlen, std::uint64_t k, bool mont) {
return cplib_avx2_ntt::bostan_mori_998(p, plen, q, qlen, k, mont);
}
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

extern "C" void cplib_multipoint_cyclic(std::uint32_t* output, std::uint32_t* f, std::size_t length, std::uint32_t* points, std::size_t point_count, std::size_t size, std::uint32_t mod) {
cplib_avx2_ntt::modulus = mod;
cplib_avx2_ntt::primitive_root = cplib_avx2_ntt::find_primitive_root(mod);
cplib_avx2_ntt::MultipointCyclicEvaluator context(points, point_count, size);
context.run(output, f, length);
}

extern "C" void* cplib_multipoint_tree_create(std::uint32_t* leaves, std::size_t size, std::size_t block, std::uint32_t modulus) {
return new cplib_avx2_ntt::MultipointProductTree(leaves, size, block, modulus);
}
extern "C" void cplib_multipoint_tree_root(void* context, std::uint32_t* output) {
static_cast<cplib_avx2_ntt::MultipointProductTree*>(context)->root(output);
}
extern "C" void cplib_multipoint_tree_descend(void* context, std::uint32_t* output, std::uint32_t* input) {
static_cast<cplib_avx2_ntt::MultipointProductTree*>(context)->descend(output, input);
}
extern "C" void cplib_multipoint_tree_destroy(void* context) {
delete static_cast<cplib_avx2_ntt::MultipointProductTree*>(context);
}

extern "C" void* cplib_fixed_convolution_create(
std::uint32_t* data, std::size_t length, std::size_t size,
std::uint32_t modulus, std::uint32_t root) {
// 固定側の畳み込みコンテキストを作成する。
return new cplib_avx2_ntt::FixedConvolution(data, length, size, modulus, root);
}
extern "C" void cplib_fixed_convolution_run(
void* context, std::uint32_t* output, std::uint32_t* data, std::size_t length) {
// 作成済みのコンテキストで畳み込みを実行する。
static_cast<cplib_avx2_ntt::FixedConvolution*>(context)->run(output, data, length);
}
extern "C" void cplib_fixed_convolution_destroy(void* context) {
// 畳み込みコンテキストを解放する。
delete static_cast<cplib_avx2_ntt::FixedConvolution*>(context);
}
extern "C" void cplib_product_polynomial_sequence_998(
std::uint32_t* output,
std::uint32_t** factors,
std::size_t* sizes,
std::size_t factor_count) {
cplib_avx2_ntt::product_polynomial_sequence_998(
output, factors, sizes, factor_count);
}
    """.}

    proc bostanMori998Kernel*(p: ptr uint32, plen: csize_t, q: ptr uint32,
            qlen: csize_t, k: uint64, inputMontgomery: bool): uint32
            {.importc: "cplib_bostan_mori_998".}
        ## 法998244353のBostan--Mori内部カーネル（入力は変更しない）。

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

    proc convolutionNttFriendlyU32(
        f, g: seq[uint32], modulus, primitiveRoot: uint32
    ): seq[uint32]

    proc convolutionArbitraryMod[T: BarrettModint or MontgomeryModint](
        f, g: seq[T]
    ): seq[T]

    var nttPrimalityCache: tuple[modulus: uint32, isPrime: bool]

    proc isNttFriendlyModulus(modulus, transformSize: uint32): bool =
        ## 指定した長さのNTTが法の下で成立するか判定する。
        if modulus <= 1u32 or modulus >= (1u32 shl 30): return false
        if (modulus - 1u32) mod transformSize != 0u32: return false
        if nttPrimalityCache.modulus != modulus:
            nttPrimalityCache = (modulus, isprime(modulus.int))
        return nttPrimalityCache.isPrime

    proc multipointCyclicNtt*(output, f: ptr uint32, length: csize_t,
        points: ptr uint32, pointCount, size: csize_t, modulus: uint32
    ) {.importc: "cplib_multipoint_cyclic".}
        ## 通常剰余のfをpointsで評価しoutputに書く。配列長は順にpointCount、length、pointCountで、lengthとpointCountはcanUseMultipointTreeNtt(modulus, size)を満たす2冪size以下とする。

    proc multipointTreeCreate*(leaves: ptr uint32, size, blockSize: csize_t,
        modulus: uint32): pointer {.importc: "cplib_multipoint_tree_create".}
        ## 通常剰余の各blockSize+1係数の反転葉積size div blockSize個から積木を作る。sizeはcanUseMultipointTreeNtt(modulus, size)を満たす2冪、blockSizeはsizeを割る16以上の2冪とする。
    proc multipointTreeRoot*(context: pointer, output: ptr uint32) {.importc: "cplib_multipoint_tree_root".}
        ## 作成済みcontextの根の反転積を通常剰余でoutputに書く。出力領域は作成時のsize+1係数を確保する。
    proc multipointTreeDescend*(context: pointer, output, input: ptr uint32) {.importc: "cplib_multipoint_tree_descend".}
        ## 作成済みcontextで中間積を葉まで降下させる。inputとoutputは作成時のsize係数の通常剰余とする。
    proc multipointTreeDestroy*(context: pointer) {.importc: "cplib_multipoint_tree_destroy".}
        ## multipointTreeCreateで作ったcontextを解放する。解放後のcontextは再利用しない。

    proc canUseMultipointTreeNtt*(modulus: uint32, size: int): bool =
        ## 積木の全段でNTTを使える場合に限り高速経路を選ぶ。
        size >= 64 and (size and (size - 1)) == 0 and size <= modulus.int and
            isNttFriendlyModulus(modulus, size.uint32)

    proc convolution_naive*[T: BarrettModint or MontgomeryModint or int](f, g: seq[T]): seq[T] =
        if f.len == 0 or g.len == 0: return @[]
        var ans = newSeq[T](f.len + g.len - 1)
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
        if m == 0 or n == 0: return @[]
        let deg = m + n - 1
        if min(n, m) <= 60: return convolution_naive(f, g)
        var l = (if deg == 1: 1 else: (1 shl (fastLog2(deg - 1) + 1)))
        if isNttFriendlyModulus(T.umod, l.uint32):
            result = newSeq[T](l)
            convolutionNttFriendlyAvx2(
                cast[ptr uint32](addr result[0]),
                cast[ptr uint32](unsafeAddr f[0]), m.csize_t,
                cast[ptr uint32](unsafeAddr g[0]), n.csize_t,
                l.csize_t, T.umod, 0u32,
                T is MontgomeryModint)
            result.setLen(deg)
            return
        return convolutionArbitraryMod(f, g)

    proc convolutionCyclicPowerOfTwo*[T: BarrettModint or MontgomeryModint](
            f, g: seq[T], n: int): seq[T] =
        ## 長さnの巡回畳み込みを求める。nは2の冪でなければならない。
        doAssert n > 0 and (n and (n - 1)) == 0, "変換長nは正の2の冪である必要があります"
        doAssert f.len <= n and g.len <= n, "入力配列の長さは変換長n以下である必要があります"
        result = newSeq[T](n)
        if f.len == 0 or g.len == 0: return
        if n >= 64 and isNttFriendlyModulus(T.umod, n.uint32):
            when T is MontgomeryModint:
                var normalF = newSeq[uint32](f.len)
                var normalG = newSeq[uint32](g.len)
                var normalResult = newSeq[uint32](n)
                for i in 0..<f.len: normalF[i] = f[i].val.uint32
                for i in 0..<g.len: normalG[i] = g[i].val.uint32
                convolutionNttFriendlyAvx2(
                    addr normalResult[0], addr normalF[0], f.len.csize_t,
                    addr normalG[0], g.len.csize_t, n.csize_t,
                    T.umod, 0u32, false)
                for i in 0..<n: result[i] = init(T, normalResult[i])
            else:
                convolutionNttFriendlyAvx2(
                    cast[ptr uint32](addr result[0]),
                    cast[ptr uint32](unsafeAddr f[0]), f.len.csize_t,
                    cast[ptr uint32](unsafeAddr g[0]), g.len.csize_t,
                    n.csize_t, T.umod, 0u32, false)
            return
        let product = convolution(f, g)
        for i in 0..<product.len:
            if i < n: result[i] += product[i]
            else: result[i - n] += product[i]

    proc convolution*[m: static[int]](f, g: seq[int]): seq[int] =
        doAssert m > 0 and m < (1 shl 31),
            "畳み込みの法は1以上2^31未満である必要があります"
        if f.len == 0 or g.len == 0: return @[]
        type Mint = StaticBarrettModint[m.uint32]
        var fm = newSeq[Mint](f.len)
        var gm = newSeq[Mint](g.len)
        for i in 0..<f.len: fm[i] = init(Mint, f[i])
        for i in 0..<g.len: gm[i] = init(Mint, g[i])
        let product = convolution(fm, gm)
        result = newSeq[int](product.len)
        for i in 0..<product.len: result[i] = product[i].val

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

    proc convolutionArbitraryMod[T: BarrettModint or MontgomeryModint](
            f, g: seq[T]): seq[T] =
        const
            M1 = 754974721u64
            M2 = 167772161u64
            M3 = 469762049u64
            M12 = M1 * M2
            InvM1ModM2 = inv_gcd((M1 mod M2).int, M2.int)[1].uint64
            InvM12ModM3 = inv_gcd((M12 mod M3).int, M3.int)[1].uint64

        # mod < 2^31かつこの変換長の上限では、各整数係数はM1*M2*M3未満になる。
        # そのため、3個の剰余から要求された法で還元する前の値を一意に特定できる。
        let targetMod = T.umod.uint64
        assert targetMod > 0 and targetMod < (1u64 shl 31),
            "任意mod畳み込みの法は1以上2^31未満である必要があります"
        let transformSize = 1 shl (fastLog2(f.len + g.len - 2) + 1)
        assert transformSize <= (1 shl 24),
            "任意mod畳み込みのNTT長は2^24以下である必要があります"

        var fm = newSeq[uint32](f.len)
        var gm = newSeq[uint32](g.len)
        for i in 0..<f.len: fm[i] = (f[i].val.uint64 mod M1).uint32
        for i in 0..<g.len: gm[i] = (g[i].val.uint64 mod M1).uint32
        let c1 = convolutionNttFriendlyU32(fm, gm, M1.uint32, 11u32)

        for i in 0..<f.len: fm[i] = (f[i].val.uint64 mod M2).uint32
        for i in 0..<g.len: gm[i] = (g[i].val.uint64 mod M2).uint32
        let c2 = convolutionNttFriendlyU32(fm, gm, M2.uint32, 3u32)

        for i in 0..<f.len: fm[i] = (f[i].val.uint64 mod M3).uint32
        for i in 0..<g.len: gm[i] = (g[i].val.uint64 mod M3).uint32
        let c3 = convolutionNttFriendlyU32(fm, gm, M3.uint32, 3u32)

        let m1Target = M1 mod targetMod
        let m12Target = M12 mod targetMod
        result = newSeq[T](c1.len)
        for i in 0..<result.len:
            let r1 = c1[i].uint64
            let t2 = ((c2[i].uint64 + M2 - r1 mod M2) mod M2 *
                InvM1ModM2) mod M2
            let r12ModM3 = (r1 + (M1 mod M3) * t2) mod M3
            let t3 = ((c3[i].uint64 + M3 - r12ModM3) mod M3 *
                InvM12ModM3) mod M3
            let value = ((r1 mod targetMod) + m1Target * t2 mod targetMod +
                m12Target * t3 mod targetMod) mod targetMod
            result[i] = init(T, value.int)


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
            # xは意図的に2^64を法としてオーバーフローさせる。
            # CRTのオーバーフロー補正では同じビット列を符号付き整数として解釈する。
            # 数値変換の`.int`では最上位ビットが立っているとRangeDefectになる。
            var diff = c1[i].int - floorMod(cast[int](x), M1.int)
            if diff < 0: diff += M1.int
            const offset = [0u, 0u, M123, 2u * M123, 3u * M123]
            x -= offset[diff mod 5]
            ans[i] = cast[int](x)
        return ans
