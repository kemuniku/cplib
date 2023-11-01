when not declared CPLIB_TMPL_QCFIUM:
    const CPLIB_TMPL_QCFIUM* = 1
    {.emit: """
    #pragma GCC target ("avx2")
    #pragma GCC optimize("O3")
    #pragma GCC optimize("unroll-loops")
    """.}