when not declared CPLIB_UTILS_POKER:
    const CPLIB_UTILS_POKER* = 1

    ## 通常の52枚、jokerなしのポーカー。rankは2..14（A=14）、スートに強弱はない。
    ## evaluate5は5枚、evaluateBestは5..7枚を受け取り、不正な枚数・rank・重複はValueError。
    ## PokerValueはcategory、kickersの辞書順で比較する。kickersの未使用部分は0。
    ## ロイヤルフラッシュは独立した最上位の役とし、A2345のストレートの高さは5。
    ## HighCard/Flushのkickersは全rankの降順、Straight系は高さ1個（RoyalFlushは14）。
    ## OnePairは[ペア,残り3枚の降順]、TwoPairは[大ペア,小ペア,残り1枚]。
    ## ThreeOfAKindは[三枚組,残り2枚の降順]、FullHouseは[三枚組,ペア]、FourOfAKindは[四枚組,残り1枚]。
    ## 同rank枚数の降順、同枚数ではrank降順で比較値を作り、役の強い順に分類する。
    ## 異なるrankが5個で最大-最小=4なら連続、A2345のみ例外として扱う。
    ## 5..7枚の任意の役は5枚部分集合に存在するため、全組の最大が最良役になる。
    ## PokerValueの==も同役・同比較値を表す。入力カードは変更しない。
    ## 5枚評価は固定長のrank頻度表から求め、時間・追加領域O(1)。
    ## 最良役は全C(n,5)組（最大21組）を評価し、時間O(n+C(n,5))、追加領域O(1)。

    type
        PokerSuit* = enum
            Clubs, Diamonds, Hearts, Spades
        PokerCard* = object
            rank*: int
            suit*: PokerSuit
        PokerCategory* = enum
            HighCard, OnePair, TwoPair, ThreeOfAKind, Straight, Flush,
            FullHouse, FourOfAKind, StraightFlush, RoyalFlush
        PokerValue* = object
            category*: PokerCategory
            kickers*: array[5, int]

    proc initPokerCard*(rank: int, suit: PokerSuit): PokerCard =
        ## rankを検査してカードを作る。O(1)。
        if rank < 2 or rank > 14:
            raise newException(ValueError, "poker rank must be in 2..14")
        PokerCard(rank: rank, suit: suit)

    proc cmp*(a, b: PokerValue): int =
        ## 役、同役内の比較値の順に比較し、弱い/同点/強いを-1/0/1で返す。O(1)。
        if a.category != b.category:
            return system.cmp(ord(a.category), ord(b.category))
        for i in 0..<5:
            if a.kickers[i] != b.kickers[i]:
                return system.cmp(a.kickers[i], b.kickers[i])

    proc `<`*(a, b: PokerValue): bool =
        ## aの役がbより弱いかを返す。O(1)。
        cmp(a, b) < 0

    proc `<=`*(a, b: PokerValue): bool =
        ## aの役がbより弱いか同点かを返す。O(1)。
        cmp(a, b) <= 0

    proc validatePokerCards(cards: openArray[PokerCard], minLen, maxLen: int) =
        ## 枚数、rank、スート、カード重複を検査する。O(n)、追加領域O(1)。
        if cards.len < minLen or cards.len > maxLen:
            raise newException(ValueError, "invalid poker hand size")
        var seen: uint64
        for card in cards:
            if card.rank < 2 or card.rank > 14 or ord(card.suit) < 0 or ord(card.suit) > 3:
                raise newException(ValueError, "invalid poker card")
            let bit = 1'u64 shl (ord(card.suit) * 13 + card.rank - 2)
            if (seen and bit) != 0:
                raise newException(ValueError, "duplicate poker card")
            seen = seen or bit

    proc evaluatePokerFive(cards: openArray[PokerCard]): PokerValue =
        ## 検査済み5枚をrank頻度とスート一致から評価する。O(1)。
        var counts: array[15, int]
        var flush = true
        for card in cards:
            inc counts[card.rank]
            flush = flush and card.suit == cards[0].suit
        var ranks: array[5, int]
        var distinctCount = 0
        for rank in countdown(14, 2):
            if counts[rank] > 0:
                ranks[distinctCount] = rank
                inc distinctCount
        var straightHigh = 0
        if distinctCount == 5:
            if ranks[0] - ranks[4] == 4:
                straightHigh = ranks[0]
            elif ranks == [14, 5, 4, 3, 2]:
                straightHigh = 5
        if flush and straightHigh > 0:
            result.category = (if straightHigh == 14: RoyalFlush else: StraightFlush)
            result.kickers[0] = straightHigh
            return
        var grouped: array[5, int]
        var groupCounts: array[5, int]
        var index = 0
        for count in countdown(4, 1):
            for rank in countdown(14, 2):
                if counts[rank] == count:
                    grouped[index] = rank
                    groupCounts[index] = count
                    inc index
        if groupCounts[0] == 4:
            result.category = FourOfAKind
        elif groupCounts[0] == 3 and groupCounts[1] == 2:
            result.category = FullHouse
        elif flush:
            result.category = Flush
            result.kickers = ranks
            return
        elif straightHigh > 0:
            result.category = Straight
            result.kickers[0] = straightHigh
            return
        elif groupCounts[0] == 3:
            result.category = ThreeOfAKind
        elif groupCounts[0] == 2:
            result.category = (if groupCounts[1] == 2: TwoPair else: OnePair)
        else:
            result.category = HighCard
        result.kickers = grouped

    proc evaluate5*(cards: openArray[PokerCard]): PokerValue =
        ## 相異なる5枚の役と比較値を返す。不正入力はValueError。時間・追加領域O(1)。
        validatePokerCards(cards, 5, 5)
        evaluatePokerFive(cards)

    proc evaluateBest*(cards: openArray[PokerCard]): PokerValue =
        ## 相異なる5..7枚の最良の5枚役を返す。不正入力はValueError。最大21組、追加領域O(1)。
        validatePokerCards(cards, 5, 7)
        for a in 0..<cards.len - 4:
            for b in a + 1..<cards.len - 3:
                for c in b + 1..<cards.len - 2:
                    for d in c + 1..<cards.len - 1:
                        for e in d + 1..<cards.len:
                            let value = evaluatePokerFive([cards[a], cards[b], cards[c], cards[d], cards[e]])
                            if result < value:
                                result = value
