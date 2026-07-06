# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/staticRMQ

let rmq = initRMQ(@[5, 2, 7, 1, 4, 3, 6, 0, 9, 8, 11, 10, 12, 13, 14, 15, -1])
assert rmq.query(0, 1) == 5
assert rmq.query(0, 17) == -1
assert rmq.query(1, 4) == 1
assert rmq.query(4, 7) == 3
assert rmq.query(7, 16) == 0
