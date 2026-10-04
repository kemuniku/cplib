import cplib/math/longdouble

proc peerValue*(x: LongDouble): LongDouble = x + epsilonLongDouble()
proc peerSum*(xs: openArray[LongDouble]): LongDouble =
    result = 0
    for x in xs: result += x
proc peerGeneric*[T](x: T): T = x + x
