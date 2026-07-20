when not declared CPLIB_UTILS_LARGEST_RECTANGLE:
    const CPLIB_UTILS_LARGEST_RECTANGLE * = 1

    proc largest_rectangle*[T: SomeInteger](heights: openArray[T]): T =
        ## Returns the maximum rectangle area in a histogram.
        ##
        ## Each bar has width 1 and all heights must be non-negative.
        ## Time complexity is O(heights.len), and space complexity is
        ## O(heights.len).
        runnableExamples:
            assert largest_rectangle([2, 1, 4, 5, 1, 3, 3]) == 8
            assert largest_rectangle(newSeq[int]()) == 0

        var stack: seq[tuple[left: int, height: T]]
        for right in 0..heights.len:
            let height = if right < heights.len: heights[right] else: T(0)
            var left = right
            while stack.len > 0 and stack[^1].height > height:
                let bar = stack.pop()
                result = max(result, bar.height * T(right - bar.left))
                left = bar.left
            if stack.len == 0 or stack[^1].height < height:
                stack.add((left, height))
