when not declared CPLIB_UTILS_KTH_ELEMENT:
    const CPLIB_UTILS_KTH_ELEMENT* = 1
    import random,sequtils
    randomize()
    proc kth_element*[T](X:openArray[T],K:int):T=
        var now = 0
        var r = len(X)
        var C = newseqwith(r,0)
        var X = @X
        while true:
            var L = 0
            var S = 1
            swap(X[rand(0..<r)],X[r-1])
            C[r-1] = 0
            for i in 0..<(r-1):
                var tmp = cmp(X[i],X[r-1])
                if tmp < 0:
                    L += 1
                elif tmp == 0:
                    S += 1
                C[i] = tmp
            if now+L > K:
                var idx = 0
                for i in 0..<(r-1):
                    if C[i] < 0:
                        swap(X[i],X[idx])
                        idx += 1
                r = idx
            elif now+L+S > K:
                return X[r-1]
            else:
                var idx = 0
                for i in 0..<(r-1):
                    if C[i] > 0:
                        swap(X[i],X[idx])
                        idx += 1
                now += L+S
                r = idx
    
    proc kth_element_break*[T](nums : var seq[T], k:int):T=
        ## 引数のnumsの順番がバラバラになります！
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
                var c = cmp(nums[i],pivot)
                if c < 0:
                    swap(nums[lt],nums[i])
                    # nums[lt], nums[i] = nums[i], nums[lt]
                    lt += 1
                    i += 1
                elif c > 0:
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
