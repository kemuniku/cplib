when not declared CPLIB_COLLECTIONS_HASHSET:
    const CPLIB_COLLECTIONS_HASHSET* = 1
    import hashes, sequtils

    type State = enum
        empty, active, inactive

    type Node[T] = object
        state: State
        value: T or typeof(nil)

    type HashSet*[T] = object
        values*: seq[Node[T]]
        len: int
        mask: int

    proc capacity*(s: HashSet): int = s.values.len div 4

    proc initHashSet*[T](): HashSet[T] =
        HashSet[T](values: newSeqWith(4, (state: State.empty, value: nil)), len: 0, mask: (1 shl 2) - 1)

    proc find[T](s: var HashSet[T], x: T) =
        let sh = hash(x) and s.mask
        while s.values[sh].state != State.empty and s.values[sh].value != x:
            sh = (sh + 1) and s.mask
        return s.values[sh]

    proc expand[T](s: HashSet[T]) =
        var vn = newSeqWith(s.values.len*2, none(T))
