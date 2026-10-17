when not declared CPLIB_UTILS_LARGEST_RECTANGLE:
    const CPLIB_UTILS_LARGEST_RECTANGLE* = 1

    proc largest_rectangle_with_range*[T: SomeInteger](heights: openArray[T]): tuple[area: int64, l, r: int, height: int64] =
        ## 幅1のヒストグラムの最大面積と最適な半開区間[l,r)、高さを返す。時間O(N)、追加空間O(N)。
        ## 高さは非負でint64に収まり、最大面積もint64に収まること。
        ## 空入力・全要素0では(area:0,l:0,r:0,height:0)。同面積の解は任意の一つを返す。
        var stack = newSeqOfCap[tuple[left: int, height: int64]](heights.len)
        for right in 0..heights.len:
            let height = if right < heights.len: int64(heights[right]) else: 0'i64
            var left = right
            while stack.len > 0 and stack[^1].height > height:
                let bar = stack.pop()
                let area = bar.height * int64(right - bar.left)
                if area > result.area:
                    result = (area, bar.left, right, bar.height)
                left = bar.left
            # 同じ高さは最も左の開始位置だけを残す。末尾の高さ0で全候補を確定する。
            if height > 0 and (stack.len == 0 or stack[^1].height < height):
                stack.add((left, height))

    proc largest_rectangle*[T: SomeInteger](heights: openArray[T]): int64 =
        ## 幅1の非負ヒストグラムの最大面積を返す。時間O(N)、追加空間O(N)。
        ## 高さと最大面積はint64に収まること。空入力・全要素0の面積は0。
        largest_rectangle_with_range(heights).area
