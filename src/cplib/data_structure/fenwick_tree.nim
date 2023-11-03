when not declared CPLIB_DATA_STRUCTURE_FENWICK_TREE:
    const CPLIB_DATA_STRUCTURE_FENWICK_TREE * = 1
    import std/sequtils

    type FenwickTree_Type*[T] = object
        data*: seq[T]

    proc initFenwickTree*[T](n: int): FenwickTree_Type[T] =
        return FenwickTree_Type()
