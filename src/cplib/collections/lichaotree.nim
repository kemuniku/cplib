import sequtils,algorithm
import cplib/utils/constants
import bitops

type LiChaoTree = ref object
    X : seq[int]
    A : seq[int]
    B : seq[int]
    lastnode : int

proc initLiChaoTree*(X:seq[int]):LiChaoTree=
    ## LiChaoTreeを初期化します
    ## get_minで用いる可能性のあるXを配列で与えてください。
    var X = X.sorted().deduplicate(true)
    var lastnode = 1
    while lastnode < len(X):
        lastnode *= 2
    result = LiChaoTree()
    result.X = newseqwith(lastnode+1,int(INF32))
    for i in 0..<len(X):
        result.X[i] = X[i]
    result.A = newseqwith(2*lastnode,0)
    result.B = newseqwith(2*lastnode,INF64)
    result.lastnode = lastnode

proc query(self:LiChaoTree,a,b,now:int)=
    var a = a
    var b = b
    var now = now
    var length = self.lastnode shr fastLog2(now)
    var i = now xor (1 shl fastLog2(now))
    var l = i*length
    var r = (i+1)*length
    while true:
        var m = (l+r) shr 1
        var left = self.X[l]*a+b < self.X[l]*self.A[now]+self.B[now]
        var right = self.X[r-1]*a+b < self.X[r-1]*self.A[now]+self.B[now]
        var mid = self.X[m]*a+b < self.X[m]*self.A[now]+self.B[now]

        if left and right:
            self.A[now] = a
            self.B[now] = b
            return
        elif (not left) and (not right):
            return
        if mid:
            swap(a,self.A[now])
            swap(b,self.B[now])
        if left != mid:
            now = now*2
            r = m
        else:
            now = now*2+1
            l = m

proc add_line*(self:LiChaoTree,a,b:int)=
    ## 直線ax+bを追加します。
    ## aは32bit整数に収まるようにしてください。
    self.query(a,b,1)

proc add_segment(self:LiChaoTree,a,b,l,r:int)=
    ## 線分ax+b (l<=x<r)を追加します。
    ## aは32bit整数に収まるようにしてください。
    var l = self.X.lowerBound(l)
    var r = self.X.lowerBound(r)

    var q_left = l
    var q_right = r
    q_left += self.lastnode
    q_right += self.lastnode
    while q_left < q_right:
        if (q_left and 1) > 0:
            self.query(a,b,q_left)
            q_left += 1
        if (q_right and 1) > 0:
            q_right -= 1
            self.query(a,b,q_right)
        q_left = q_left shr 1
        q_right = q_right shr 1

proc get_min*(self:LiChaoTree,x:int):int=
    ## xにおける最小値を返します。
    ## xは32bit整数に収まるようにしてください。
    ## 線分が存在しない場合、INF64が返ります。
    ## xは初期化時に与える必要があります。
    var now = self.X.binarySearch(x)
    assert now != -1
    now+=self.lastnode
    result = INF64
    while now != 0:
        result = min(result,self.A[now]*x+self.B[now])
        now = now shr 1