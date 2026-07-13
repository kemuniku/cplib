when not declared CPLIB_STR_SUFFIX_AUTOMATON:
    const CPLIB_STR_SUFFIX_AUTOMATON* = 1

    import std/[algorithm, tables]

    type SuffixAutomatonState*[T] = object
        ## `len` is the maximum length represented by this state.
        ## `link` is -1 only for the initial state.
        len*: int
        link*: int
        next*: Table[T, int]
        occurrence*: int

    type SuffixAutomaton*[T] = object
        states*: seq[SuffixAutomatonState[T]]
        last*: int

    proc initSuffixAutomaton*[T](): SuffixAutomaton[T] =
        ## Initializes an automaton that accepts only the empty string.
        result.states = @[
            SuffixAutomatonState[T](
                len: 0,
                link: -1,
                next: initTable[T, int](),
                occurrence: 0
            )
        ]
        result.last = 0

    proc extend*[T](sam: var SuffixAutomaton[T], c: T): int =
        ## Appends `c` to the source sequence and returns the new last state.
        let cur = sam.states.len
        sam.states.add(SuffixAutomatonState[T](
            len: sam.states[sam.last].len + 1,
            link: 0,
            next: initTable[T, int](),
            occurrence: 1
        ))

        var p = sam.last
        while p >= 0 and not sam.states[p].next.hasKey(c):
            sam.states[p].next[c] = cur
            p = sam.states[p].link

        if p < 0:
            sam.states[cur].link = 0
        else:
            let q = sam.states[p].next[c]
            if sam.states[p].len + 1 == sam.states[q].len:
                sam.states[cur].link = q
            else:
                let clone = sam.states.len
                var cloned = sam.states[q]
                cloned.len = sam.states[p].len + 1
                cloned.occurrence = 0
                sam.states.add(cloned)
                while p >= 0 and sam.states[p].next.getOrDefault(c, -1) == q:
                    sam.states[p].next[c] = clone
                    p = sam.states[p].link
                sam.states[q].link = clone
                sam.states[cur].link = clone

        sam.last = cur
        return cur

    proc initSuffixAutomaton*[T](a: openArray[T]): SuffixAutomaton[T] =
        ## Builds the suffix automaton of `a` in O(n) expected time.
        result = initSuffixAutomaton[T]()
        for c in a:
            discard result.extend(c)

    proc findState*[T](sam: SuffixAutomaton[T], pattern: openArray[T]): int =
        ## Returns the state reached by `pattern`, or -1 if it is not a substring.
        result = 0
        for c in pattern:
            if not sam.states[result].next.hasKey(c):
                return -1
            result = sam.states[result].next[c]

    proc contains*[T](sam: SuffixAutomaton[T], pattern: openArray[T]): bool =
        ## Tests whether `pattern` is a substring of the source sequence.
        return sam.findState(pattern) >= 0

    proc occurrenceCounts*[T](sam: SuffixAutomaton[T]): seq[int] =
        ## Returns the end-position count for every state.
        ## The automaton itself is not modified, so this may safely be called
        ## repeatedly or before appending more symbols.
        result = newSeq[int](sam.states.len)
        var order = newSeq[int](sam.states.len)
        for i, state in sam.states:
            result[i] = state.occurrence
            order[i] = i
        order.sort(proc(a, b: int): int = cmp(sam.states[b].len, sam.states[a].len))
        for v in order:
            if sam.states[v].link >= 0:
                result[sam.states[v].link] += result[v]

    proc countOccurrences*[T](sam: SuffixAutomaton[T], pattern: openArray[T]): int =
        ## Counts (possibly overlapping) occurrences of `pattern`.
        ## The empty pattern occurs n + 1 times.
        if pattern.len == 0:
            return sam.states[sam.last].len + 1
        let state = sam.findState(pattern)
        if state < 0:
            return 0
        return sam.occurrenceCounts()[state]

    proc distinctSubstringCount*[T](sam: SuffixAutomaton[T]): int64 =
        ## Returns the number of distinct non-empty substrings.
        for i in 1..<sam.states.len:
            result += int64(sam.states[i].len - sam.states[sam.states[i].link].len)
