when not declared CPLIB_STR_AHO_CORASICK:
    const CPLIB_STR_AHO_CORASICK* = 1

    import std/[deques, tables]

    type AhoCorasickState*[T] = object
        ## Trie edges, failure link, and pattern ids matched at this state.
        next*: Table[T, int]
        failure*: int
        output*: seq[int]
        terminal: seq[int]

    type AhoCorasick*[T] = object
        states*: seq[AhoCorasickState[T]]
        patternCount*: int
        built*: bool

    proc newState[T](): AhoCorasickState[T] =
        result.next = initTable[T, int]()
        result.failure = 0
        result.output = @[]
        result.terminal = @[]

    proc initAhoCorasick*[T](): AhoCorasick[T] =
        ## Initializes an empty pattern matching automaton.
        result.states = @[newState[T]()]

    proc addPattern*[T](ac: var AhoCorasick[T], pattern: openArray[T]): int =
        ## Adds a pattern and returns its zero-based id.
        ## Duplicate and empty patterns are allowed and receive distinct ids.
        if ac.states.len == 0:
            ac = initAhoCorasick[T]()
        result = ac.patternCount
        inc ac.patternCount
        var state = 0
        for c in pattern:
            if not ac.states[state].next.hasKey(c):
                ac.states[state].next[c] = ac.states.len
                ac.states.add(newState[T]())
            state = ac.states[state].next[c]
        ac.states[state].terminal.add(result)
        ac.built = false

    proc build*[T](ac: var AhoCorasick[T]) =
        ## Builds all failure links and inherited outputs.
        ## It is safe to rebuild after adding more patterns.
        if ac.states.len == 0:
            ac = initAhoCorasick[T]()
        for state in ac.states.mitems:
            state.failure = 0
            state.output = state.terminal

        var queue = initDeque[int]()
        for _, child in ac.states[0].next.pairs:
            queue.addLast(child)

        while queue.len > 0:
            let v = queue.popFirst()
            let failure = ac.states[v].failure
            ac.states[v].output.add(ac.states[failure].output)
            for c, child in ac.states[v].next.pairs:
                var fallback = failure
                while fallback != 0 and not ac.states[fallback].next.hasKey(c):
                    fallback = ac.states[fallback].failure
                if ac.states[fallback].next.hasKey(c):
                    fallback = ac.states[fallback].next[c]
                ac.states[child].failure = fallback
                queue.addLast(child)
        ac.built = true

    proc requireBuilt[T](ac: AhoCorasick[T]) =
        if not ac.built:
            raise newException(ValueError, "AhoCorasick.build must be called first")

    proc nextState*[T](ac: AhoCorasick[T], state: int, c: T): int =
        ## Advances one symbol from `state` using failure links.
        ac.requireBuilt()
        if state < 0 or state >= ac.states.len:
            raise newException(IndexDefect, "AhoCorasick state is out of bounds")
        result = state
        while result != 0 and not ac.states[result].next.hasKey(c):
            result = ac.states[result].failure
        if ac.states[result].next.hasKey(c):
            result = ac.states[result].next[c]

    proc matches*[T](ac: AhoCorasick[T], state: int): seq[int] =
        ## Returns the ids of all patterns ending at `state`.
        ac.requireBuilt()
        if state < 0 or state >= ac.states.len:
            raise newException(IndexDefect, "AhoCorasick state is out of bounds")
        return ac.states[state].output

    proc findAll*[T](ac: AhoCorasick[T], text: openArray[T]):
            seq[tuple[position, patternId: int]] =
        ## Returns every match as (inclusive end position, pattern id).
        ## Empty patterns match at position -1 and after every input symbol.
        ac.requireBuilt()
        for patternId in ac.states[0].output:
            result.add((-1, patternId))
        var state = 0
        for position, c in text:
            state = ac.nextState(state, c)
            for patternId in ac.states[state].output:
                result.add((position, patternId))

    proc countOccurrences*[T](ac: AhoCorasick[T], text: openArray[T]): seq[int] =
        ## Counts possibly overlapping occurrences for every added pattern.
        ac.requireBuilt()
        result = newSeq[int](ac.patternCount)
        for patternId in ac.states[0].output:
            inc result[patternId]
        var state = 0
        for c in text:
            state = ac.nextState(state, c)
            for patternId in ac.states[state].output:
                inc result[patternId]
