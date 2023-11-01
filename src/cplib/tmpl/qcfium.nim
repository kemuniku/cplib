when not declared CPLIB_QCFIUM:
    const CPLIB_QCFIUM* = 1
    {.emit: """
    #pragma GCC target ("avx2")
    #pragma GCC optimize("O3")
    #pragma GCC optimize("unroll-loops")
    """.}
