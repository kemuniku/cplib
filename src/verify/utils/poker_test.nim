# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/utils/poker
import algorithm, random, sequtils

type Score = array[6, int]

proc score(category: PokerCategory, ranks: openArray[int]): Score =
    result[0] = ord(category)
    for i, rank in ranks: result[i + 1] = rank

proc raw(value: PokerValue): Score =
    score(value.category, value.kickers)

proc scoreCmp(a, b: Score): int =
    for i in 0..<6:
        if a[i] != b[i]: return cmp(a[i], b[i])

# 本体の5枚列挙とは独立に、全カードをソートして直接最良役を求める。
proc oracle(cards: openArray[PokerCard]): Score =
    var ranks = cards.mapIt(it.rank)
    ranks.sort(Descending)
    var unique: seq[int]
    var groups: seq[tuple[count, rank: int]]
    for rank in ranks:
        if unique.len == 0 or unique[^1] != rank:
            unique.add rank
            groups.add (1, rank)
        else:
            inc groups[^1].count
    groups.sort(proc(a, b: tuple[count, rank: int]): int =
        if a.count != b.count: cmp(b.count, a.count) else: cmp(b.rank, a.rank))

    proc straight(rs: seq[int]): int =
        var sorted = rs
        sorted.sort()
        if 14 in sorted: sorted.insert(1, 0)
        var run = 1
        for i in 1..<sorted.len:
            if sorted[i] == sorted[i - 1] + 1: inc run
            else: run = 1
            if run >= 5: result = sorted[i]

    var flushRanks: seq[int]
    for suit in PokerSuit:
        let suited = cards.filterIt(it.suit == suit).mapIt(it.rank)
        if suited.len >= 5: flushRanks = suited.sorted(Descending)
    let sf = straight(flushRanks)
    if sf > 0:
        return score((if sf == 14: RoyalFlush else: StraightFlush), [sf])
    if groups[0].count == 4:
        let other = unique.filterIt(it != groups[0].rank)
        return score(FourOfAKind, [groups[0].rank, other[0]])
    if groups[0].count == 3:
        let pairs = groups.filterIt(it.count >= 2 and it.rank != groups[0].rank).mapIt(it.rank).sorted(Descending)
        if pairs.len > 0: return score(FullHouse, [groups[0].rank, pairs[0]])
    if flushRanks.len >= 5: return score(Flush, flushRanks[0..4])
    let st = straight(unique)
    if st > 0: return score(Straight, [st])
    if groups[0].count == 3:
        let other = unique.filterIt(it != groups[0].rank)
        return score(ThreeOfAKind, @[groups[0].rank] & other[0..1])
    let pairs = groups.filterIt(it.count == 2).mapIt(it.rank).sorted(Descending)
    if pairs.len >= 2:
        let other = unique.filterIt(it != pairs[0] and it != pairs[1])
        return score(TwoPair, [pairs[0], pairs[1], other[0]])
    if pairs.len == 1:
        let other = unique.filterIt(it != pairs[0])
        return score(OnePair, @[pairs[0]] & other[0..2])
    score(HighCard, unique[0..4])

proc card(rank: int, suit = Clubs): PokerCard = initPokerCard(rank, suit)

proc check(cards: openArray[PokerCard], expected: Score) =
    let before = @cards
    doAssert raw(evaluateBest(cards)) == expected
    doAssert @cards == before
    if cards.len == 5: doAssert raw(evaluate5(cards)) == expected
    doAssert oracle(cards) == expected
    var reordered = before
    reordered.reverse()
    doAssert evaluateBest(reordered) == evaluateBest(cards)
    for c in reordered.mitems: c.suit = PokerSuit((ord(c.suit) + 1) mod 4)
    doAssert cmp(evaluateBest(reordered), evaluateBest(cards)) == 0

check([card(14), card(2, Hearts), card(3), card(4), card(5)], score(Straight, [5]))
check([card(14), card(2), card(3), card(4), card(5)], score(StraightFlush, [5]))
check([card(14), card(10), card(11), card(12), card(13)], score(RoyalFlush, [14]))
check([card(14), card(14, Hearts), card(14, Spades), card(13), card(13, Hearts), card(13, Spades), card(2)], score(FullHouse, [14, 13]))
check([card(14), card(14, Hearts), card(13), card(13, Hearts), card(12), card(12, Hearts), card(2)], score(TwoPair, [14, 13, 12]))
check([card(14), card(12), card(9), card(7), card(5), card(3), card(2)], score(Flush, [14, 12, 9, 7, 5]))
check([card(14), card(14, Diamonds), card(14, Hearts), card(14, Spades), card(13), card(2)], score(FourOfAKind, [14, 13]))
check([card(14), card(2, Hearts), card(3), card(4), card(5), card(6, Hearts), card(7, Hearts)], score(Straight, [7]))
check([card(14), card(13, Hearts), card(2), card(3), card(4)], score(HighCard, [14, 13, 4, 3, 2]))
check([card(2), card(2, Hearts), card(2, Spades), card(14), card(13)], score(ThreeOfAKind, [2, 14, 13]))
check([card(2), card(2, Hearts), card(14), card(13), card(12)], score(OnePair, [2, 14, 13, 12]))

# 同役内の最後の比較値まで検査する（フラッシュの同点もスート非依存）。
for category in PokerCategory:
    let a = PokerValue(category: category, kickers: [14, 12, 9, 7, 5])
    let b = PokerValue(category: category, kickers: [14, 12, 9, 7, 4])
    doAssert b < a and b <= a and a <= a
    doAssert cmp(a, b) == 1 and cmp(b, a) == -1 and cmp(a, a) == 0
for category in HighCard..StraightFlush:
    doAssert PokerValue(category: category, kickers: [14, 14, 14, 14, 14]) < PokerValue(category: succ(category))
let wheel = evaluate5([card(14), card(2, Hearts), card(3), card(4), card(5)])
let sixHigh = evaluate5([card(2), card(3, Hearts), card(4), card(5), card(6)])
doAssert wheel < sixHigh
let flushTie = evaluate5([card(14, Spades), card(12, Spades), card(9, Spades), card(7, Spades), card(5, Spades)])
let flushA = evaluate5([card(14), card(12), card(9), card(7), card(5)])
let flushB = evaluate5([card(14, Hearts), card(12, Hearts), card(9, Hearts), card(7, Hearts), card(4, Hearts)])
doAssert flushB < flushA
doAssert flushTie == flushA and cmp(flushTie, flushA) == 0

proc expectInvalid(cards: seq[PokerCard], best: bool) =
    var caught = false
    try:
        if best: discard evaluateBest(cards)
        else: discard evaluate5(cards)
    except ValueError: caught = true
    doAssert caught
let valid = @[card(2), card(3), card(4), card(5), card(6)]
for n in 0..8:
    if n == 5: continue
    var hand: seq[PokerCard]
    for i in 0..<n: hand.add card(i + 2)
    expectInvalid(hand, false)
    if n < 5 or n > 7: expectInvalid(hand, true)
for rank in [low(int), -1, 0, 1, 15, high(int)]:
    var caught = false
    try: discard initPokerCard(rank, Clubs)
    except ValueError: caught = true
    doAssert caught
    var hand = valid
    hand[0].rank = rank
    expectInvalid(hand, false)
    expectInvalid(hand, true)
for invalid in [-1, 4, 255]:
    var hand = valid
    hand[0].suit = cast[PokerSuit](invalid)
    expectInvalid(hand, false)
    expectInvalid(hand, true)
for n in 5..7:
    var hand = valid
    while hand.len < n: hand.add card(8 + hand.len)
    hand[^1] = hand[0]
    expectInvalid(hand, true)
    if n == 5: expectInvalid(hand, false)

var deck: array[52, PokerCard]
for i in 0..<52: deck[i] = card(i mod 13 + 2, PokerSuit(i div 13))
var rng = initRand(733)
var previous = evaluateBest(valid)
for n in 5..7:
    for trial in 0..<20000:
        var shuffled = deck
        rng.shuffle(shuffled)
        let hand = shuffled[0..<n]
        let value = evaluateBest(hand)
        doAssert raw(value) == oracle(hand)
        if n == 5: doAssert evaluate5(hand) == value
        doAssert cmp(previous, value) == -cmp(value, previous)
        doAssert (previous < value) == (scoreCmp(raw(previous), raw(value)) < 0)
        doAssert (previous <= value) == (scoreCmp(raw(previous), raw(value)) <= 0)
        var reordered = hand.reversed
        doAssert evaluateBest(reordered) == value
        for c in reordered.mitems: c.suit = PokerSuit((ord(c.suit) + 1) mod 4)
        doAssert evaluateBest(reordered) == value
        previous = value

echo "Hello World"
