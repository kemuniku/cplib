when not declared CPLIB_COLLECTIONS_XOR_BASIS:
    const CPLIB_COLLECTIONS_XOR_BASIS* = 1
    import algorithm

    type XorBasis* = ref object
        basis* : seq[int]

    proc initXorBasis*(A:openArray[int]):XorBasis=
        result = XorBasis()
        for i in 0..<len(A):
            var e = A[i]
            for b in result.basis:
                if (e xor b) < e:
                    e = e xor b
            if e != 0:
                for j in 0..<len(result.basis):
                    if (e xor result.basis[j]) < result.basis[j]:
                        result.basis[j] = result.basis[j] xor e
                result.basis.add(e)
        result.basis.sort()

    proc initXorBasis*():XorBasis=
        result = XorBasis()

    proc incl*(self:XorBasis,x:int)=
        var e = x
        for b in self.basis:
            if (e xor b) < e:
                e = e xor b
        if e != 0:
            for j in 0..<len(self.basis):
                if (e xor self.basis[j]) < self.basis[j]:
                    self.basis[j] = self.basis[j] xor e
            self.basis.add(e)
            self.basis.sort() # <- ほんまか？

    proc len_basis*(self:XorBasis):int=
        ## 基底の本数を返す
        return len(self.basis)

    proc can_make*(self:XorBasis,x:int):bool=
        ## 基底のXOR和でxが作成可能か？
        var e = x
        for b in self.basis:
            if (e xor b) < e:
                e = e xor b
        return e == 0

    proc kth_smallest*(self:XorBasis,k:int):int=
        ## 作成可能な値の中でk番目に小さいものを求めます。
        ## 存在しない場合は、-1を返します。
        if k >= (1 shl len(self.basis)):
            return -1
        for i in 0..<len(self.basis):
            if (k and (1 shl i)) != 0:
                result = result xor self.basis[i]

    proc lt*(self:XorBasis,x:int):int=
        ## 作成可能な値の中でx未満の内最大のもの
        ## 存在しない場合は-1
        if x == 0:
            return -1
        for i in countdown(len(self.basis)-1,0,1):
            if (result xor self.basis[i]) < x:
                result = result xor self.basis[i]

    proc le*(self:XorBasis,x:int):int=
        ## 作成可能な値の中でx以下の内最大のもの
        for i in countdown(len(self.basis)-1,0,1):
            if (result xor self.basis[i]) <= x:
                result = result xor self.basis[i]

    proc index*(self:XorBasis,x:int):int=
        ## 作成可能な値の中でxが小さい方から何番目か
        ## どの基底を使うかもコレの結果をseq[bool]として見ればわかる
        var x = x
        for i in 0..<len(self.basis):
            if (x xor self.basis[i]) < x:
                x = x xor self.basis[i]
                result += (1 shl i)

    proc xor_min*(self:XorBasis,x:int):int=
        ## 作成可能な値の中でxとxorを取ったときに値が最小となるものを求める
        result = x
        for i in countdown(len(self.basis)-1,0,1):
            if (result xor self.basis[i]) < result:
                result = result xor self.basis[i]
        result = result xor x

    proc xor_kth*(self:XorBasis,x:int,k:int):int=
        ## 作成可能な値の中でxとxorを取ったときにk番目に小さくなるもの
        ## 存在しないならば-1を返す。
        if k >= (1 shl len(self.basis)):
            return -1
        
        var v = self.xor_min(x) xor x
        for i in countdown(len(self.basis)-1,0,1):
            if (v xor self.basis[i]) < v:
                v = v xor self.basis[i]
        return (v xor self.kth_smallest(k)) xor x
