# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/utils/inversion_number

assert inversion_number(@[2, 1, 5, 3, 4]) == 3
assert inversion_number(@[1, 1, 1]) == 0
assert inversion_number(@[3, 2, 1]) == 3
