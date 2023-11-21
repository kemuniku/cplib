when not declared CPLIB_COLLECTIONS_SWAG:
    const CPLIB_COLLECTIONS_SWAG* = 1

    import algorithm
    type QSWAG*[T] = ref object
        op: proc(x, y: T): T
        e: T
        top: seq[T]
        bottom: seq[T]
        topfold: seq[T]
        bottomfold: seq[T]
    proc initSWAG*[T](op: proc(x, y: T): T, e: T): QSWAG[T] =
        result = QSWAG[T](op: op, e: e, top: @[], bottom: @[], topfold: @[e], bottomfold: @[e])
    proc pushbottom[T](self: QSWAG[T], x: T) =
        self.bottom.add(x)
        self.bottomfold.add(self.op(self.bottomfold[^1], x))
    proc popbottom[T](self: QSWAG[T]): T =
        discard self.bottomfold.pop()
        self.bottom.pop()
    proc pushtop[T](self: QSWAG[T], x: T) =
        self.top.add(x)
        self.topfold.add(self.op(x, self.topfold[^1]))
    proc poptop[T](self: QSWAG[T]): T =
        discard self.topfold.pop()
        self.top.pop()
    proc push*[T](self: QSWAG[T], x: T) =
        self.pushbottom(x)
    proc pop*[T](self: QSWAG[T]): T =
        if len(self.top) != 0:
            return self.poptop()
        else:
            if len(self.bottom) == 0:
                raise newException(IndexDefect, "index out of bounds, the container is empty ")
            for _ in 0..<len(self.bottom):
                self.pushtop(self.popbottom)
            return self.poptop()
    proc fold*[T](self: QSWAG[T]): T =
        return self.op(self.topfold[^1], self.bottomfold[^1])
    proc `$`*[T](self: QSWAG[T]): string =
        return $reversed(self.top) & $self.bottom