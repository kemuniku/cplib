when not declared CPLIB_COLLECTIONS_ROOT_VALUE_UNIONFIND:
    const CPLIB_COLLECTIONS_UNIONFIND* = 1
    import algorithm, sequtils
    type RootValueUnionFind[T] = ref object
        count*: int
        par_or_siz: seq[int]
        op : proc(x,y:var T)
        values* : seq[T]
    proc initRootValueUnionFind*[T](N: int,op:(proc(x,y:var T)),default:(proc():T)): RootValueUnionFind[T] =
        ## opについて、xのほうが新しくrootになるものとする(よって、xのサイズはyのサイズ以上である)
        ## 関数にvarで与えられるので、関数内でxを書き換えてください
        ## なんでこうしてるの？　-> HashSetとかを載せてマージできると嬉しさがあるので。
        result = RootValueUnionFind[T](count: N, par_or_siz: newSeqwith(N, -1),op:op,values:newseqwith(N,default()))
    proc initRootValueUnionFind*[T](N: int,op:(proc(x,y:var T)),default:T): RootValueUnionFind[T] =
        ## opについて、xのほうが新しくrootになるものとする(よって、xのサイズはyのサイズ以上である)
        ## 関数にvarで与えられるので、関数内でxを書き換えてください
        ## なんでこうしてるの？　-> HashSetとかを載せてマージできると嬉しさがあるので。
        result = RootValueUnionFind[T](count: N, par_or_siz: newSeqwith(N, -1),op:op,values:newseqwith(N,default))
    proc initRootValueUnionFind*[T](N: int,op:(proc(x,y:var T)),values:seq[T]): RootValueUnionFind[T] =
        ## opについて、xのほうが新しくrootになるものとする(よって、xのサイズはyのサイズ以上である)
        ## 関数にvarで与えられるので、関数内でxを書き換えてください
        ## なんでこうしてるの？　-> HashSetとかを載せてマージできると嬉しさがあるので。
        result = RootValueUnionFind[T](count: N, par_or_siz: newSeqwith(N, -1),op:op,values:values)
    proc root*[T](self: RootValueUnionFind[T], x: int): int =
        if self.par_or_siz[x] < 0:
            return x
        else:
            self.par_or_siz[x] = self.root(self.par_or_siz[x])
            return self.par_or_siz[x]
    proc issame*[T](self: RootValueUnionFind[T], x: int, y: int): bool =
        return self.root(x) == self.root(y)
    proc unite*[T](self: RootValueUnionFind[T], x: int, y: int) =
        var x = self.root(x)
        var y = self.root(y)
        if(x != y):
            if(self.par_or_siz[x] > self.par_or_siz[y]):
                swap(x, y)
            self.op(self.values[x],self.values[y])
            self.par_or_siz[x] += self.par_or_siz[y]
            self.par_or_siz[y] = x
            self.count -= 1
    proc siz*[T](self: RootValueUnionFind[T], x: int): int =
        var x = self.root(x)
        return -self.par_or_siz[x]
    proc get*[T](self: RootValueUnionFind[T],x:int): var T=
        return self.values[self.root(x)]
    proc set*[T](self: RootValueUnionFind[T],x:int,value:T)=
        self.values[self.root(x)] = value


