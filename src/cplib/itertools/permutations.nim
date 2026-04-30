when not declared CPLIB_ITERTOOLS_PERMUTATIONS:
    const CPLIB_ITERTOOLS_PERMUTATIONS* = 1
    import algorithm,sequtils

    iterator permutations*[T](v : seq[T]):seq[T]=
        ## pythonのitertoolsのpermutationsと同じ動作をします。
        var idxs = (0..<len(v)).toseq()
        while true:
            yield idxs.mapit(v[it])
            if not nextPermutation(idxs):
                break

    iterator distinct_permutations*[T](v : seq[T]):seq[T]=
        ## next_permutaionをするのと同じ動作をします。
        var tmp = v
        while true:
            yield tmp
            if not nextPermutation(tmp):
                break