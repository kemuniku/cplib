when not declared CPLIB_UTILS_KTH_ELEMENT:
    const COMPETITIVE_UTILS_KTH_ELEMENT* = 1
    import random
    proc kth_element*[T](nums : var seq[T], k:int):T=
        var target = k
        var left = 0
        var right = len(nums) - 1
        
        while left <= right:
            if left == right:
                return nums[left]
            
            # ランダムピボット選択
            var pivot_idx = rand(left..right)
            var pivot = nums[pivot_idx]
            
            # 3-way Partition (オランダの国旗問題のアルゴリズム)
            var lt = left      # pivotより小さい要素の右端
            var i = left       # スキャン用ポインタ
            var gt = right     # pivotより大きい要素の左端
            
            while i <= gt:
                if nums[i] < pivot:
                    swap(nums[lt],nums[i])
                    # nums[lt], nums[i] = nums[i], nums[lt]
                    lt += 1
                    i += 1
                elif nums[i] > pivot:
                    swap(nums[i],nums[gt])
                    # nums[i], nums[gt] = nums[gt], nums[i]
                    gt -= 1
                else:
                    i += 1
            if lt <= target and target <= gt:
                # ターゲットが「ピボットと同じ値」の範囲内に入れば終了
                return nums[lt]
            elif target < lt:
                # 左側を探索
                right = lt - 1
            else:
                # 右側を探索
                left = gt + 1