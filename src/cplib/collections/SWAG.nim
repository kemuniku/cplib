when not declared CPLIB_COLLECTIONS_SWAG:
    const CPLIB_COLLECTIONS_SWAG* = 1

    import algorithm
    type SWAG*[T,S] = ref object
        op:proc(x,y:T):S
        e:S
        top:seq[T]
        bottom:seq[T]
        topfold:seq[S]
        bottomfold:seq[S]
    proc initSWAG*[T,S](op:proc(x,y:T):S,e:S):SWAG[T,S]=
        result = SWAG[T,S](op:op,e: e,top: @[],bottom: @[],topfold: @[e],bottomfold: @[e])
    proc pushbottom[T,S](self:SWAG[T,S],x:S)=
        self.bottom.add(x)
        self.bottomfold.add(self.op(self.bottomfold[^1],x))
    proc popbottom[T,S](self:SWAG[T,S]):T=
        discard self.bottomfold.pop()
        self.bottom.pop()
    proc pushtop[T,S](self:SWAG[T,S],x:S)=
        self.top.add(x)
        self.topfold.add(self.op(x,self.topfold[^1]))
    proc poptop[T,S](self:SWAG[T,S]):T=
        discard self.topfold.pop()
        self.top.pop()
    proc addFirst*[T,S](self:SWAG[T,S],x:T)=
        self.pushtop(x)
    proc addLast*[T,S](self:SWAG[T,S],x:T)=
        self.pushbottom(x)
    proc popFirst*[T,S](self:SWAG[T,S]):T=
        if len(self.top) != 0:
            return self.poptop()
        else:
            if len(self.bottom)==0:
                raise newException(IndexDefect, "index out of bounds, the container is empty ")
            var stack:seq[T]
            for _ in 0..<len(self.bottom) div 2:
                stack.add(self.popbottom())
            for _ in 0..<len(self.bottom):
                self.pushtop(self.popbottom())
            for _ in 0..<len(stack):
                self.pushbottom(stack.pop())
            return self.poptop()
    proc popLast*[T,S](self:SWAG[T,S]):T=
        if len(self.bottom) != 0:
            return self.popbottom()
        else:
            if len(self.top)==0:
                raise newException(IndexDefect, "index out of bounds, the container is empty ")
            var stack1:seq[T]
            var stack2:seq[T]
            for _ in 0..<len(self.top) div 2:
                stack1.add(self.poptop())
            for _ in 0..<len(self.top):
                stack2.add(self.poptop())
            stack2.reverse()
            for _ in 0..<len(stack1):
                self.pushtop(stack1.pop())
            for _ in 0..<len(stack2):
                self.pushbottom(stack2.pop())
            return self.popbottom()
    proc fold*[T,S](self:SWAG[T,S]):S=
        return self.op(self.topfold[^1],self.bottomfold[^1])