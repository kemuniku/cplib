{.push overflowChecks: on.}
when defined(testStaticMatrix):
    include cplib/matrix/static_matrix
else:
    include cplib/matrix/matrix
{.pop.}

proc checkScalar(value, exponent, expected: int) =
    when defined(testStaticMatrix):
        let a = initMatrix([[value]])
    else:
        let a = initMatrix(@[@[value]])
    let original = a
    doAssert a.pow(exponent)[0, 0] == expected
    doAssert (a ** exponent)[0, 0] == expected
    doAssert a == original

for value in [low(int), low(int) + 1, -1, 0, 1, high(int) - 1, high(int)]:
    checkScalar(value, 0, 1)
    checkScalar(value, 1, value)

let squareBase = 1 shl ((sizeof(int) * 8 - 2) div 2)
for value in [squareBase, -squareBase]:
    checkScalar(value, 2, value * value)
let cubeBase = 1 shl ((sizeof(int) * 8 - 2) div 3)
for value in [cubeBase, -cubeBase]:
    checkScalar(value, 3, value * value * value)
for exponent in [4, 8, 16]:
    let shift = (sizeof(int) * 8 - 2) div exponent
    let value = 1 shl shift
    checkScalar(value, exponent, 1 shl (shift * exponent))
    checkScalar(-value, exponent, 1 shl (shift * exponent))

proc checkSmall[N: static int]() =
    for seed in 0..<20:
        when defined(testStaticMatrix):
            var a: StaticMatrix[N, N, int]
        else:
            var a = initMatrix(N, N, 0)
        var rows: array[N, array[N, int]]
        var expected: array[N, array[N, int]]
        for i in 0..<N:
            expected[i][i] = 1
            for j in 0..<N:
                rows[i][j] = (seed * 7 + i * 3 + j * 5) mod 5 - 2
                a[i, j] = rows[i][j]
        let original = a
        for exponent in 0..8:
            let actual = a.pow(exponent)
            doAssert actual.h == N and actual.w == N
            doAssert actual == a ** exponent
            for i in 0..<N:
                for j in 0..<N:
                    doAssert actual[i, j] == expected[i][j]
            doAssert a == original
            var next: array[N, array[N, int]]
            for i in 0..<N:
                for j in 0..<N:
                    for k in 0..<N:
                        next[i][j] += expected[i][k] * rows[k][j]
            expected = next

checkSmall[0]()
checkSmall[1]()
checkSmall[2]()
checkSmall[3]()
echo "Hello World"
