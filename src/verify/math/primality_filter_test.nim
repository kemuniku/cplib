# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/math/isprime

const primes = [3u64, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37]
proc check[T: SomeInteger]() =
    for p in primes:
        doAssert isprime(T(p))
        for q in primes:
            let product = p * q
            if product <= high(T).uint64:
                doAssert not isprime(T(product))
        let nearMax = high(T).uint64 - high(T).uint64 mod p
        if nearMax > p:
            doAssert not isprime(T(nearMax))
check[int8]()
check[int16]()
check[int32]()
check[int64]()
check[int]()
check[uint8]()
check[uint16]()
check[uint32]()
check[uint64]()
check[uint]()
echo "Hello World"
