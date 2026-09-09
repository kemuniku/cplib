when not declared CPLIB_COLLECTIONS_ROOT_VALUE_UNIONFIND:
    const CPLIB_COLLECTIONS_ROOT_VALUE_UNIONFIND* = 1
    import algorithm, sequtils
    type RootValueUnionFind*[T] = ref object
        count*: int
        par_or_siz: seq[int32]
        op : proc(x,y:var T)
        values* : seq[T]
    proc initRootValueUnionFind*[T](N: int,op:(proc(x,y:var T)),default:(proc():T)): RootValueUnionFind[T] =
        ## opについて、xのほうが新しくrootになるものとする(よって、xのサイズはyのサイズ以上である)
        ## 関数にvarで与えられるので、関数内でxを書き換えてください
        ## なんでこうしてるの？　-> HashSetとかを載せてマージできると嬉しさがあるので。
        result = RootValueUnionFind[T](count: N, par_or_siz: newSeqwith(N, -1'i32),op:op,values:newseqwith(N,default()))
    proc initRootValueUnionFind*[T](N: int,op:(proc(x,y:var T)),default:T): RootValueUnionFind[T] =
        ## opについて、xのほうが新しくrootになるものとする(よって、xのサイズはyのサイズ以上である)
        ## 関数にvarで与えられるので、関数内でxを書き換えてください
        ## なんでこうしてるの？　-> HashSetとかを載せてマージできると嬉しさがあるので。
        result = RootValueUnionFind[T](count: N, par_or_siz: newSeqwith(N, -1'i32),op:op,values:newseqwith(N,default))
    proc initRootValueUnionFind*[T](N: int,op:(proc(x,y:var T)),values:openArray[T]): RootValueUnionFind[T] =
        ## opについて、xのほうが新しくrootになるものとする(よって、xのサイズはyのサイズ以上である)
        ## 関数にvarで与えられるので、関数内でxを書き換えてください
        ## なんでこうしてるの？　-> HashSetとかを載せてマージできると嬉しさがあるので。
        result = RootValueUnionFind[T](count: N, par_or_siz: newSeqwith(N, -1'i32),op:op,values: @values)
    proc root_i32[T](self: RootValueUnionFind[T], x: int): int32 =
        if self.par_or_siz[x] < 0:
            return x.int32
        else:
            self.par_or_siz[x] = self.root_i32(self.par_or_siz[x].int)
            return self.par_or_siz[x]
    proc root*[T](self: RootValueUnionFind[T], x: int): int =
        return self.root_i32(x).int
    proc issame*[T](self: RootValueUnionFind[T], x: int, y: int): bool =
        return self.root_i32(x) == self.root_i32(y)
    proc unite*[T](self: RootValueUnionFind[T], x: int, y: int) =
        var x = self.root_i32(x)
        var y = self.root_i32(y)
        if(x != y):
            if(self.par_or_siz[x.int] > self.par_or_siz[y.int]):
                swap(x, y)
            let xi = x.int
            let yi = y.int
            self.op(self.values[xi],self.values[yi])
            self.par_or_siz[xi] += self.par_or_siz[yi]
            self.par_or_siz[yi] = x
            self.count -= 1
    proc siz*[T](self: RootValueUnionFind[T], x: int): int =
        var x = self.root_i32(x)
        return (-self.par_or_siz[x.int]).int
    proc get*[T](self: RootValueUnionFind[T],x:int): var T=
        return self.values[self.root_i32(x).int]
    proc set*[T](self: RootValueUnionFind[T],x:int,value:T)=
        self.values[self.root_i32(x).int] = value
