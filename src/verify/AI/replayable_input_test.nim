# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import strutils
import cplib/tmpl/replayable_input

block:
    let tokens = @["2", "10", "20", "hello", "18446744073709551615", "-7", "8", "9"]
    var cursor = 0

    proc input(T: typedesc): T =
        let token = tokens[cursor]
        inc cursor
        when T is string:
            result = token
        elif T is SomeUnsignedInt:
            result = T(parseBiggestUInt(token))
        else:
            result = T(parseBiggestInt(token))

    replayableInput:
        let n = ii()
        var collected: seq[int]
        peekInput:
            collected = lii(n)
            peekInput:
                doAssert si() == "hello"
                doAssert input(uint64) == high(uint64)
            doAssert si() == "hello"
        doAssert collected == @[10, 20]
        collected[0] = 999
        doAssert ii() == 10
        doAssert input(int) == 20
        doAssert input(string) == "hello"
        doAssert input(uint64) == high(uint64)
        doAssert cursor == 5
        try:
            peekInput:
                doAssert ii() == -7
                raise newException(ValueError, "test")
        except ValueError:
            discard
        doAssert ii() == -7
        peekInput:
            doAssert input(2, int) == @[8, 9]
        try:
            discard input(string)
            doAssert false
        except ValueError:
            discard
        doAssert lii(2) == @[8, 9]
        doAssert cursor == tokens.len

block:
    type
        IntAlias = int
        OtherInt = distinct int
        Small = tuple[a: int32, b: uint32]
        Large = array[3, int]
        Managed = object
            text: string
            values: seq[int]
    var reads = 0
    proc input(T: typedesc): T =
        inc reads
        when T is int: result = low(int)
        elif T is OtherInt: result = OtherInt(42)
        elif T is Small: result = (low(int32), high(uint32))
        elif T is Large: result = [1, 2, 3]
        elif T is Managed: result = Managed(text: "hello", values: @[4, 5])
        elif T is float64: result = -1.25
        elif T is bool: result = true
        elif T is char: result = 'z'
        elif T is string: result = "world"
    replayableInput:
        peekInput:
            discard input(IntAlias)
            discard input(OtherInt)
            discard input(Small)
            discard input(Large)
            var first = input(Managed)
            first.text[0] = 'H'
            first.values[0] = 99
            discard input(float64)
            discard input(bool)
            discard input(char)
            discard si()
        doAssert input(int) == low(int)
        try:
            discard ii()
            doAssert false
        except ValueError:
            discard
        doAssert int(input(OtherInt)) == 42
        doAssert input(Small) == (low(int32), high(uint32))
        doAssert input(Large) == [1, 2, 3]
        let first = input(Managed)
        doAssert first.text == "hello" and first.values == @[4, 5]
        doAssert input(float64) == -1.25
        doAssert input(bool)
        doAssert input(char) == 'z'
        doAssert si() == "world"
        doAssert reads == 9
        # 記録の破棄後に、同じ型のバッファを再度使用します。
        discard input(Managed)
        peekInput:
            discard input(Managed)
            discard si()
        doAssert input(Managed).values == @[4, 5]
        doAssert si() == "world"
        doAssert reads == 12

block:
    var reads = 0
    proc input(T: typedesc): T =
        inc reads
        T(reads)
    replayableInput:
        peekInput:
            doAssert ii() == 1
            block stop:
                peekInput:
                    doAssert lii(2) == @[2, 3]
                    break stop
            doAssert ii() == 2
        peekInput:
            doAssert lii(4) == @[1, 2, 3, 4]
        doAssert ii() == 1
        peekInput:
            doAssert lii(4) == @[2, 3, 4, 5]
        doAssert lii(4) == @[2, 3, 4, 5]
        doAssert reads == 5
        doAssert ii() == 6
        peekInput:
            doAssert ii() == 7
        doAssert ii() == 7
        doAssert reads == 7

block:
    var reads = 0
    proc input(T: typedesc): T =
        inc reads
        when T is string: result = $reads
        else: result = T(reads)
    replayableInput:
        peekInput:
            for i in 1..10000:
                if i mod 3 == 0:
                    doAssert si() == $i
                else:
                    doAssert ii() == i
        for i in 1..10000:
            if i mod 3 == 0:
                doAssert si() == $i
            else:
                doAssert ii() == i
        doAssert reads == 10000

echo "Hello World"
