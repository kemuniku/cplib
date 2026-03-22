proc baser*(num,base,size:int):seq[int]=
    var num = num
    for _ in 0..<size:
        result.add(num mod base)
        num = num div base
    return result