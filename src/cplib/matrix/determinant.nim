when not declared CPLIB_MATRIX_DETERMINANT:
    const CPLIB_MATRIX_MATOPS_DETERMINANT* = 1
    proc determinant*[T](X:seq[seq[T]]):T=
        var X = X
        var H = len(X)
        var W = len(X[0])
        var w = 0
        result = 1
        for i in 0..<(H):
            block test:
                for k in i..<H:
                    if X[k][i] != 0:
                        if i != k:
                            swap(X[i],X[k])
                            result *= -1
                        result *= X[i][i]
                        var inv = 1/(X[i][i])
                        for l in (i..<W):
                            X[i][l] *= inv
                        for a in 0..<H:
                            if a != i:
                                var tmp = X[a][i]
                                for b in i..<W:
                                    X[a][b] -= X[i][b]*tmp
                        break test
                return 0