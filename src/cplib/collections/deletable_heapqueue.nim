## 存在しない要素を消そうとするとバグるので注意
when not declared CPLIB_COLLECTIONS_DELETABLE_HEAPQUEUE:
    const CPLIB_COLLECTIONS_DELETABLE_HEAPQUEUET* = 1
    import heapqueue
    type Deletable_HeapQueue*[T] = object
        hq : HeapQueue[T]
        dlhq : HeapQueue[T]

    proc initDeletableHeapQueue*[T]():Deletable_HeapQueue[T]=
        Deletable_HeapQueue[T](hq:initHeapQueue[T](),dlhq:initHeapQueue[T]())

    proc toDeletableHeapQueue*[T](v:seq[T]):Deletable_HeapQueue[T]=
        Deletable_HeapQueue[T](hq:v.toHeapQueue(),dlhq:initHeapQueue[T]())

    proc `[]`*[T](self:var Deletable_HeapQueue[T],i:Natural):T=
        assert i == 0
        return self.hq[i]

    proc delete*[T](self:var Deletable_HeapQueue[T],x:T)=
        self.dlhq.push(x)
        while len(self.dlhq) != 0 and self.dlhq[0] == self.hq[0]:
            discard self.dlhq.pop()
            discard self.hq.pop()

    proc push*[T](self:var Deletable_HeapQueue[T],x:T)=
        self.hq.push(x)


    proc pop*[T](self:var Deletable_HeapQueue[T]):T=
        result = self.hq.pop()
        while len(self.dlhq) != 0 and self.dlhq[0] == self.hq[0]:
            discard self.dlhq.pop()
            discard self.hq.pop()

    proc len*[T](self:var Deletable_HeapQueue[T]):int=
        return len(self.hq)-len(self.dlhq)