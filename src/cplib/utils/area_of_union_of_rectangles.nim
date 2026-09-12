when not declared CPLIB_UTILS_AREA_OF_UNION_OF_RECTANGLES:
    const CPLIB_UTILS_AREA_OF_UNION_OF_RECTANGLES* = 1
    # 内部の添字と型の範囲は構築時に保証する。-d:debugでは検査を有効にする。
    when not defined(debug):
        {.push boundChecks:off, overflowChecks:off, rangeChecks:off.}

    proc rectangleRadixSort[T](a:var seq[T])=
        ## 座標を基数ソートする。固定幅整数では時間O(N)、追加空間O(N)。
        # 符号ビットを反転すると、負の座標も符号なし整数の順序でソートできる。
        if a.len < 2: return
        const signBit = 1'u shl (sizeof(int)*8-1)
        const mask = 2047'u
        let first = cast[uint](a[0].coordinate)
        var varying = 0'u
        for e in a:
            varying = varying or (cast[uint](e.coordinate) xor first)
        var scratch = newSeq[T](a.len)
        var shift = 0
        while shift < sizeof(int)*8 and (varying shr shift) != 0:
            if ((varying shr shift) and mask) != 0:
                var offsets:array[2048,int]
                for e in a:
                    let digit = int(((cast[uint](e.coordinate) xor signBit) shr shift) and mask)
                    offsets[digit].inc
                var total = 0
                for i in 0..<offsets.len:
                    let count = offsets[i]
                    offsets[i] = total
                    total += count
                for e in a:
                    let digit = int(((cast[uint](e.coordinate) xor signBit) shr shift) and mask)
                    scratch[offsets[digit]] = e
                    offsets[digit].inc
                swap(a,scratch)
            shift += 11

    proc rectangleSweep[Length,Index](
        rectangles:seq[(int,int,int,int)], positions,seps:seq[int]
    ):int=
        ## 走査線と専用セグ木で面積を求める。時間O(N log N)、追加空間O(N)。
        type
            Event = tuple[coordinate:int,left,right:Index]
            Node = object
                cover:Index
                length,width:Length
        var events = newSeqOfCap[Event](2*rectangles.len)
        for i,rectangle in rectangles:
            let (l,d,r,u) = rectangle
            if l == r or d == u: continue
            let x = Index(positions[2*i])
            let z = Index(positions[2*i+1])
            # 削除イベントはleftのビット反転で表し、イベントを小さく保つ。
            events.add((d,x,z))
            events.add((u,not x,z))
        rectangleRadixSort(events)

        let n = seps.len-1
        var size = 1
        while size < n: size *= 2
        var nodes = newSeq[Node](2*size)
        for i in 0..<n:
            nodes[size+i].width = Length(seps[i+1]-seps[i])
        for i in countdown(size-1,1):
            nodes[i].width = nodes[2*i].width+nodes[2*i+1].width

        template change(node,delta:int):Length =
            block:
                var difference:Length
                let oldCover = nodes[node].cover
                nodes[node].cover += Index(delta)
                # 被覆回数が正のままなら、被覆長は変わらない。
                if nodes[node].cover == 0 or oldCover == 0:
                    let old = nodes[node].length
                    if nodes[node].cover > 0:
                        nodes[node].length = nodes[node].width
                    elif node < size:
                        nodes[node].length = nodes[node*2].length+nodes[node*2+1].length
                    else:
                        nodes[node].length = 0
                    difference = nodes[node].length-old
                difference

        var previousY = events[0].coordinate
        for event in events:
            result += int(nodes[1].length)*(event.coordinate-previousY)
            previousY = event.coordinate
            let delta = if event.left < 0: -1 else: 1
            var l = (if event.left < 0: not int(event.left) else: int(event.left))+size
            var r = int(event.right)+size
            var leftNode = l
            var rightNode = r-1
            var leftDiff,rightDiff:Length
            # 各段の両端を下から処理する。子の被覆長の差分だけを親へ渡す。
            while leftNode > 0:
                if leftNode == rightNode:
                    leftDiff += rightDiff
                    rightDiff = 0
                if leftDiff != 0:
                    if nodes[leftNode].cover == 0:
                        nodes[leftNode].length += leftDiff
                    else:
                        leftDiff = 0
                if rightDiff != 0:
                    if nodes[rightNode].cover == 0:
                        nodes[rightNode].length += rightDiff
                    else:
                        rightDiff = 0
                if l < r:
                    if (l and 1) != 0:
                        leftDiff += change(l,delta)
                        l.inc
                    if (r and 1) != 0:
                        r.dec
                        rightDiff += change(r,delta)
                # 区間への更新が完了し、差分も消えたら祖先の更新は不要。
                if l == r and leftDiff == 0 and rightDiff == 0: break
                l = l shr 1
                r = r shr 1
                leftNode = leftNode shr 1
                rightNode = rightNode shr 1

    proc area_of_union_of_rectangles*(rectangles:seq[(int,int,int,int)]):int=
        ## 軸に平行な長方形の和集合の面積を返す。N個に対して時間O(N log N)、追加空間O(N)。
        ## 各要素は(l,d,r,u) = (左端,下端,右端,上端)。l <= r, d <= uを満たすこと。
        ## 空の入力や面積0の長方形にも対応する。負の座標も使用できる。
        ## 全体のx座標幅、y座標の差、面積はintに収まること（通常は64bit環境で使用）。
        var endpoints = newSeqOfCap[tuple[coordinate,index:int]](2*rectangles.len)
        for i,rectangle in rectangles:
            let (l,d,r,u) = rectangle
            if l == r or d == u: continue
            endpoints.add((l,2*i))
            endpoints.add((r,2*i+1))
        if endpoints.len == 0: return 0
        rectangleRadixSort(endpoints)
        var positions = newSeq[int](2*rectangles.len)
        var seps = newSeqOfCap[int](endpoints.len)
        for e in endpoints:
            if seps.len == 0 or seps[^1] != e.coordinate:
                seps.add(e.coordinate)
            positions[e.index] = seps.len-1
        reset(endpoints)
        # 通常の制約ではノードを12バイトにする。大きい座標幅などにはint版を使う。
        if rectangles.len <= int32.high.int div 2:
            if seps[^1]-seps[0] <= int32.high.int:
                return rectangleSweep[int32,int32](rectangles,positions,seps)
            return rectangleSweep[int,int32](rectangles,positions,seps)
        return rectangleSweep[int,int](rectangles,positions,seps)

    when not defined(debug):
        {.pop.}
