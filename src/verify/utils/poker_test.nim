# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm
import cplib/utils/poker

let examples = [
    ([(1, 0), (3, 1), (6, 2), (9, 3), (13, 0)], PokerHand.HighCard),
    ([(2, 0), (2, 1), (6, 2), (9, 3), (13, 0)], PokerHand.OnePair),
    ([(2, 0), (2, 1), (6, 2), (6, 3), (13, 0)], PokerHand.TwoPair),
    ([(2, 0), (2, 1), (2, 2), (9, 3), (13, 0)], PokerHand.ThreeOfAKind),
    ([(1, 0), (2, 1), (3, 2), (4, 3), (5, 0)], PokerHand.Straight),
    ([(6, 0), (7, 1), (8, 2), (9, 3), (10, 0)], PokerHand.Straight),
    ([(1, 0), (10, 1), (11, 2), (12, 3), (13, 0)], PokerHand.Straight),
    ([(1, 0), (3, 0), (6, 0), (9, 0), (13, 0)], PokerHand.Flush),
    ([(2, 0), (2, 1), (2, 2), (9, 0), (9, 1)], PokerHand.FullHouse),
    ([(2, 0), (2, 1), (2, 2), (2, 3), (13, 0)], PokerHand.FourOfAKind),
    ([(1, 0), (2, 0), (3, 0), (4, 0), (5, 0)], PokerHand.StraightFlush),
    ([(9, 0), (8, 0), (7, 0), (6, 0), (5, 0)], PokerHand.StraightFlush),
    ([(1, 0), (10, 0), (11, 0), (12, 0), (13, 0)], PokerHand.RoyalFlush),
    ([(12, 0), (13, 1), (1, 2), (2, 3), (3, 0)], PokerHand.HighCard)]

for (hand, expected) in examples:
    var cards = hand
    cards.sort()
    while true:
        doAssert poker_hand(cards) == expected
        if not cards.nextPermutation(): break

for invalid in [
    newSeq[PokerCard](),
    @[(1, 0), (2, 0), (3, 0), (4, 0)],
    @[(1, 0), (2, 0), (3, 0), (4, 0), (5, 0), (6, 0)],
    @[(1, 0), (1, 0), (3, 0), (4, 0), (5, 0)],
    @[(0, 0), (2, 0), (3, 0), (4, 0), (5, 0)],
    @[(14, 0), (2, 0), (3, 0), (4, 0), (5, 0)],
    @[(1, -1), (2, 0), (3, 0), (4, 0), (5, 0)],
    @[(1, 4), (2, 0), (3, 0), (4, 0), (5, 0)]]:
    var caught = false
    try:
        discard poker_hand(invalid)
    except ValueError:
        caught = true
    doAssert caught

var deck: array[52, PokerCard]
for i in 0..<52:
    deck[i] = (i mod 13 + 1, i div 13)
var frequencies: array[PokerHand, int]
for a in 0..<52:
    for b in a + 1..<52:
        for c in b + 1..<52:
            for d in c + 1..<52:
                for e in d + 1..<52:
                    inc frequencies[poker_hand([deck[a], deck[b], deck[c], deck[d], deck[e]])]
doAssert frequencies == [1302540, 1098240, 123552, 54912, 10200,
    5108, 3744, 624, 36, 4]

echo "Hello World"
