when not declared CPLIB_UTILS_SEQUTILS2D:
    const CPLIB_UTILS_SEQUTILS2D* = 1
    proc maxIndex*[T](V : openArray[seq[T]]):(int,int)=
        result = (-1,-1)
        for i in 0..<len(V):
            for j in 0..<len(V[i]):
                if result == (-1,-1) or V[i][j] > V[result[0]][result[1]]:
                    result = (i,j)

    proc minIndex*[T](V : openArray[seq[T]]):(int,int)=
        result = (-1,-1)
        for i in 0..<len(V):
            for j in 0..<len(V[i]):
                if result == (-1,-1) or V[i][j] < V[result[0]][result[1]]:
                    result = (i,j)
