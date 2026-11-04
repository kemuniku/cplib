# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/utils/poker

var deck: array[52, PokerCard]
for i in 0..<52:
    deck[i] = initPokerCard(i mod 13 + 2, PokerSuit(i div 13))
var frequencies: array[10, int]
for a in 0..<48:
    for b in a + 1..<49:
        for c in b + 1..<50:
            for d in c + 1..<51:
                for e in d + 1..<52:
                    let value = evaluate5([deck[a], deck[b], deck[c], deck[d], deck[e]])
                    inc frequencies[ord(value.category)]
doAssert frequencies == [1302540, 1098240, 123552, 54912, 10200, 5108, 3744, 624, 36, 4]
echo "Hello World"
