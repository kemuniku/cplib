import cplib/math/euler_phi

when not declared CPLIB_MODINT_EXPMODINT:
    const CPLIB_MODINT_EXPMODINT* = 1

    proc getmod[P:static int](x:int):int=
        if x < 2*P:
            return x
        else:
            return (x mod P) + P
    proc mul[P:static int](x,y:int):int=
        return getmod[P](x*y)
    proc pow[P:static int](a,n:int):int=
        var
            rev = 1 mod P
            a = a
            n = n
        while n > 0:
            if n mod 2 != 0: rev = mul[P](rev, a)
            if n > 1: a = mul[P](a, a)
            n = n shr 1
        return rev
    type expmodint[P:static int] = object
        when P == 1:
            x:int
        else:
            x: int
            p: expmodint[euler_phi(P)]

    proc tomodint[P:static int](x:int):expmodint[P] =
        when P == 1:
            return expmodint[P](x:0)
        else:
            return expmodint[P](x:getmod[P](x),p:tomodint[euler_phi(P)](x))

    proc val[P:static int](a:expmodint[P]):int=
        if a.x < P:
            return a.x
        else:
            return a.x-P

    proc pow[P,Q:static int](a:expmodint[P],b:expmodint[Q]):expmodint[P]=
        when P == 1:
            return expmodint[P](x:0)
        else:
            return expmodint[P](x:pow[P](a.x,b.p.x),p:pow(a.p,b.p))

    proc `$`[P:static int](a:expmodint[P]):string=
        return $a.val()

    proc `+`[P:static int](a,b:expmodint[P]):expmodint[P]=
        when P == 1:
            return toModint[P](x:0)
        else:
            return tomodint[P](x:getmod[P](a.x+b.x),p:a.p+b.p)

    proc `*`[P:static int](a,b:expmodint[P]):expmodint[P]=
        when P == 1:
            return toModint[P](x:0)
        else:
            return tomodint[P](x:mul[P](a.x,b.x),p:a.p*b.p)
