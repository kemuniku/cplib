when not declared CPLIB_UTILS_POKER:
    const CPLIB_UTILS_POKER* = 1

    type
        PokerCard* = tuple[rank, suit: int]
            ## rankは1(A), 2..10, 11(J), 12(Q), 13(K)。suitは0..3の任意の対応を使う。
        PokerHand* {.pure.} = enum
            ## 役の弱い順。同じ役同士のカードの強さは比較しない。
            HighCard, OnePair, TwoPair, ThreeOfAKind, Straight, Flush,
            FullHouse, FourOfAKind, StraightFlush, RoyalFlush

    proc poker_hand*(cards: openArray[PokerCard]): PokerHand =
        ## ジョーカーなしの5枚の役をO(1)で判定する。不正な枚数・カード・重複にはValueErrorを送出する。
        runnableExamples:
            doAssert poker_hand([(1, 0), (10, 0), (11, 0), (12, 0), (13, 0)]) == PokerHand.RoyalFlush
            doAssert poker_hand([(1, 0), (2, 1), (3, 2), (4, 3), (5, 0)]) == PokerHand.Straight

        if cards.len != 5:
            raise newException(ValueError, "手札は5枚である必要があります")
        var counts: array[14, int]
        var seen: array[14, array[4, bool]]
        var flush = true
        for card in cards:
            if card.rank < 1 or card.rank > 13 or card.suit < 0 or card.suit > 3:
                raise newException(ValueError, "rankは1..13、suitは0..3で指定してください")
            if seen[card.rank][card.suit]:
                raise newException(ValueError, "同じカードは複数回使用できません")
            seen[card.rank][card.suit] = true
            inc counts[card.rank]
            if card.suit != cards[0].suit:
                flush = false

        var pairs, triples, quads, rank_count: int
        var lowest = 13
        var highest = 1
        for rank in 1..13:
            if counts[rank] > 0:
                inc rank_count
                lowest = min(lowest, rank)
                highest = max(highest, rank)
            case counts[rank]
            of 2: inc pairs
            of 3: inc triples
            of 4: inc quads
            else: discard
        let royal = counts[1] == 1 and counts[10] == 1 and
            counts[11] == 1 and counts[12] == 1 and counts[13] == 1
        let straight = rank_count == 5 and (highest - lowest == 4 or royal)
        if straight and flush:
            if royal: return PokerHand.RoyalFlush
            return PokerHand.StraightFlush
        if quads == 1: return PokerHand.FourOfAKind
        if triples == 1 and pairs == 1: return PokerHand.FullHouse
        if flush: return PokerHand.Flush
        if straight: return PokerHand.Straight
        if triples == 1: return PokerHand.ThreeOfAKind
        if pairs == 2: return PokerHand.TwoPair
        if pairs == 1: return PokerHand.OnePair
        return PokerHand.HighCard
