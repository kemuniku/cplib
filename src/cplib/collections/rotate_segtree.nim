when not declared CPLIB_COLLECTIONS_ROTATESEGTREE:
    const CPLIB_COLLECTIONS_ROTATESEGTREE* = 1
    include cplib/collections/segtree
    import math

    type RotateSegmentTree*[T] = ref object 
        seg : SegmentTree[T]
        r : int

    proc initRotateSegmentTree*[T](v:seq[T],merge:proc(x:T,y:T):T,default:T):RotateSegmentTree[T]=
        result = RotateSegmentTree[T](seg:initSegmentTree(v,merge,default),r:0)

    proc update*[T](self:RotateSegmentTree[T],x:int,val:T)=
        self.seg.update((x+self.r) mod self.seg.length,val)

    proc get*[T](self:RotateSegmentTree[T],q_left:int,q_right:int):T=
        assert q_left <= q_right and 0 <= q_left and q_right <= self.seg.length
        if q_right + self.r <= self.seg.length:
            return self.seg.get(q_left+self.r,q_right+self.r)
        else:
            return self.seg.merge(self.seg.get(q_left+self.r,self.seg.length) , self.seg.get(0,q_right+self.r-self.seg.length))

    proc get*[T](self: RotateSegmentTree[T], segment: HSlice[int, int]): T =
        assert segment.a <= segment.b + 1 and 0 <= segment.a and segment.b+1 <= self.seg.length
        return self.get(segment.a, segment.b+1)

    proc `[]`*[T](self: RotateSegmentTree[T], segment: HSlice[int, int]): T = self.get(segment)

    proc `[]`*[T](self: RotateSegmentTree[T], index: Natural): T =
        assert index < self.seg.length
        if index + self.r < self.seg.length:
            return self.seg.arr[index+self.r+self.seg.lastnode]
        else:
            return self.seg.arr[index+self.r-self.seg.length+self.seg.lastnode]

    proc `[]=`*[T](self: RotateSegmentTree[T], index: Natural, val: T) =
        assert index < self.seg.length
        self.update(index, val)

    proc get_all*[T](self: RotateSegmentTree[T]): T =
        ## [0,len(self))区間の演算結果をO(1)で返す
        return self.seg.arr[1]

    proc len*[T](self: RotateSegmentTree[T]): int =
        return self.seg.length

    proc `$`*[T](self: RotateSegmentTree[T]): string =
        return $self.seg

    proc rotate*[T](self:RotateSegmentTree[T],r:int)=
        self.r = euclMod(self.r + r,self.seg.length)

    template newRotateSegWith*(V, merge, default: untyped): untyped =
        initRotateSegmentTree[typeof(default)](V, proc (l{.inject.}, r{.inject.}: typeof(default)): typeof(default) = merge, default)

