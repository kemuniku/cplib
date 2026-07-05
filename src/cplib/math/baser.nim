when not declared(CPLIB_MATH_BASER):
    const CPLIB_MATH_BASER* = 1

    proc baser*(num,base:int,size:int = -1):seq[int]=
        ## K進数に変換する。
        ## sizeを指定しない場合、その数の桁数となる。0の場合は空配列を返す点に注意。
        if size == -1:
            var num = num
            while num > 0:
                result.add(num mod base)
                num = num div base
            return result
        else:
            var num = num
            for _ in 0..<size:
                result.add(num mod base)
                num = num div base
            return result