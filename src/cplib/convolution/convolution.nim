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
u32* data, Z length, bool canonicalize = false) const {
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
void inverse_pair(u32* data, Z length) const {
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
public:
explicit TransformPlan(Z size)
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
forward_bottom8(data, product);
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
forward_bottom8(data, product);
}
void inverse(u32* data) const {
inverse_bottom8(data);
inverse_single(data, 16);
const bool has_unpaired_top = (__builtin_ctzll(size_) & 1) != 0;
const Z paired_limit = has_unpaired_top ? size_ >> 1 : size_;
for (Z length = 64; length <= paired_limit; length <<= 2) {
inverse_pair(data, length);
}
if (has_unpaired_top) inverse_single(data, size_, true);
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
extern "C" void cplib_product_polynomial_sequence_998(
std::uint32_t* output,
std::uint32_t** factors,
std::size_t* sizes,
std::size_t factor_count) {
cplib_avx2_ntt::product_polynomial_sequence_998(
output, factors, sizes, factor_count);
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
        doAssert n > 0 and (n and (n - 1)) == 0
        doAssert f.len <= n and g.len <= n
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
            "convolution modulus must be in [1, 2^31)"
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
            "arbitrary-mod convolution requires a modulus in [1, 2^31)"
        let transformSize = 1 shl (fastLog2(f.len + g.len - 2) + 1)
        assert transformSize <= (1 shl 24),
            "arbitrary-mod convolution requires an NTT length at most 2^24"

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
