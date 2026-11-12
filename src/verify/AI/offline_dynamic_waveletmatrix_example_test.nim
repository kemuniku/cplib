# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/offline_dynamic_waveletmatrix
import options

let answers = runOfflineDynamicWaveletMatrix(@[5, 1, 5], @[
    wmInsert(1, 7),
    wmSet(0, -3),
    wmKthSmallest(0, 4, 1),
    wmErase(2),
    wmPrevValue(0, 3, 7),
    wmSumSmallestWithCount(0, 3, 2)
])
doAssert answers.len == 4
doAssert answers[0].operationIndex == 2
doAssert answers[0].value == 1
doAssert answers[1].value == 1
doAssert answers[2].optionalValue == some(5)
doAssert answers[3].sumCount == (2, 2)
echo "Hello World"
