when not declared CPLIB_UTILS_RANDOMHELPER:
    const CPLIB_UTILS_RANDOMHELPER* = 1
    import random,sequtils,sets,algorithm,math,strutils
    import cplib/graph/graph
    import cplib/graph/planar_graph
    import cplib/tree/prufer
    import cplib/math/isprime
    # https://kanpurin.hatenablog.com/entry/2023/02/20/184752
    randomize()

    proc randomseq*(n:int,slice:HSlice[int,int],unique:bool=false):seq[int]=
        ## 長さn,各要素がsliceに含まれる数列を一様ランダムに返す
        ## option: unique = Trueのとき、重複を許さない。
        assert n >= 0, "nは非負である必要があります"
        assert slice.len >= 1, "生成元の範囲は空でない必要があります"
        if unique:
            assert n <= slice.len, "重複を許さない場合、要素数は生成元の範囲の長さ以下である必要があります"
            if n >= slice.len div 2:
                var tmp = slice.toseq()
                shuffle(tmp)
                result = tmp[0..<n]
            else:
                var st = initHashSet[int]()
                while result.len != n:
                    var x = rand(slice)
                    if x notin st:
                        st.incl(x)
                        result.add(x)
        else:
            for i in 0..<n:
                result.add(rand(slice))
        assert len(result) == n, "生成された列の長さが指定した要素数と一致しません"
        assert result.allit(it in slice), "生成された要素が指定した範囲外です"

    proc randomseq_from_sum*(n:int,sum:int):seq[int]=
        ## 長さn,総和がsumである各要素が非負整数である数列を一様ランダムに返す
        assert sum >= 0, "sumは非負である必要があります"
        assert n >= 0, "nは非負である必要があります"
        if n == 0:
            assert sum == 0, "要素数が0の場合、和も0である必要があります"
            return @[]
        var tmp = randomseq(n-1,1..(n+sum-1),true).sorted()
        var now = 0
        for x in tmp:
            result.add(x-now-1)
            now = x
        result.add((n+sum-1) - now)
        assert len(result) == n and sum(result) == sum, "生成された列の長さまたは和が指定値と一致しません"

    proc random_parenthesis_sequence*(n:int):seq[int]=
        ## 長さnの括弧列を返す。
        ##　1: "(" , -1 : ")"
        assert n mod 2 == 0, "nは偶数である必要があります"

        var N = n div 2
        var M = n div 2
        var check = 0
        for i in 0..<(n):
            var tmp = rand(1..((N-M+1)*(N+M)))
            if tmp <= (N-M)*(N+1):
                result.add(-1)
                check -= 1
                N -= 1
            else:
                result.add(1)
                check += 1
                M -= 1
            assert check >= 0, "括弧列の途中で閉じ括弧の数が開き括弧の数を超えています"
        assert check == 0, "括弧列の開き括弧と閉じ括弧の数が一致しません"

    proc random_parenthesis_string*(n:int):string=
        return random_parenthesis_sequence(n).mapit(").("[1+it]).join("")

    proc make_binary_tree_from_sequence*(PS:openArray[int]):UnWeightedUnDirectedGraph=
        ## 括弧列から二分木を復元
        var n = len(PS) div 2
        var stack : seq[int]
        var memo = newseqwith(2*n,-1)
        for i in 0..<2*n:
            if PS[i] == 1:
                stack.add(i)
            else:
                var x = stack.pop()
                memo[x] = i
        
        var g = initUnWeightedUnDirectedGraph(n)
        var now = 0
        var edge_count = 0
        proc dfs(l,r,no:int)=
            var to = memo[l]
            if to != l+1:
                now += 1
                g.add_edge(no,now)
                edge_count += 1
                dfs(l+1,to,now)
            if to+1 != r:
                now += 1
                g.add_edge(no,now)
                edge_count += 1
                dfs(to+1,r,now)
        dfs(0,2*n,0)
        assert edge_count == n-1, "生成された木の辺数は頂点数から1を引いた値である必要があります"
        return g

    proc random_binary_tree*(n:int):UnWeightedUnDirectedGraph=
        ## n頂点の二分木を一様ランダムに返す
        assert n >= 1, "nは1以上である必要があります"
        var PS = random_parenthesis_sequence(2*n)
        return make_binary_tree_from_sequence(PS)

    proc random_tree*(n:int):UnWeightedUnDirectedGraph=
        ## n頂点の木を一様ランダムに返す
        assert n >= 1, "nは1以上である必要があります"
        if n == 1:
            return initUnWeightedUnDirectedGraph(1)
        elif n == 2:
            result = initUnWeightedUnDirectedGraph(2)
            result.add_edge(0,1)
        else:
            return prufer_decode(randomseq(n-2,0..<n))

    proc random_prime*(slice:HSlice[int,int]):int=
        ## sliceに含まれる素数を一様ランダムに返す
        if len(slice) <= 1500:
            var f = false
            for x in slice:
                if isprime(x):
                    f = true
                    break
            assert f, "指定した範囲に素数が存在する必要があります" #sliceに素数が含まれるかどうか判定
        
        while true:
            var x = rand(slice)
            if isprime(x):
                return x

    proc random_prime_sequence*(n:int,slice:HSlice[int,int],unique:bool=false):seq[int]=
        if unique:
            if len(slice) <= 1_000_000_000:
                var primes : seq[int]
                for x in slice:
                    if x.isprime():
                        primes.add(x)
                result = randomseq(n,0..<len(primes),true).mapit(primes[it])
            else:
                var st = initHashSet[int]()
                while result.len != n:
                    var x = random_prime(slice)
                    if x notin st:
                        st.incl(x)
                        result.add(x)
        else:
            for i in 0..<n:
                result.add(random_prime(slice))

    proc random_simple_graph*(n,m:int):UnWeightedUnDirectedGraph=
        ## ランダムな単純グラフを作成。
        assert m <= n*(n-1) div 2, "辺数は単純無向グラフの最大辺数以下である必要があります"
        result = initUnWeightedUnDirectedGraph(n)
        if n*(n-1) <= 10_000_000:
            var tmp : seq[(int,int)]
            for i in 0..<(n-1):
                for j in (i+1)..<n:
                    tmp.add((i,j))
            shuffle(tmp)
            
            for i in 0..<m:
                var (u,v) = tmp[i]
                result.add_edge(u,v)
        else:
            var st = initHashSet[(int,int)]()
            for i in 0..<m:
                while true:
                    var u = rand(0..<(n-1))
                    var v = rand((u+1)..<n)
                    if (u,v) notin st:
                        st.incl((u,v))
                        result.add_edge(u,v)
                        break


    proc random_planar_graph*(n,m:int):UnWeightedUnDirectedGraph=
        ## n頂点m辺の単純平面グラフを生成する。全ての形が生成可能だが、一様ランダムではない。
        ## 全頂点対をランダム順に試す。期待 O(n^3 log n) 時間、O(n^2) 空間。連結性は保証しない。
        assert n >= 0, "nは非負である必要があります"
        let maximum = if n < 3: n*(n-1) div 2 else: 3*n-6
        assert m >= 0 and m <= maximum, "辺数は単純平面グラフで実現可能な範囲である必要があります"
        result = initUnWeightedUnDirectedGraph(n)
        if m == 0: return
        var candidates: seq[(int,int)]
        for u in 0..<n:
            for v in u+1..<n:
                candidates.add((u,v))
        shuffle(candidates)
        for (u,v) in candidates:
            result.add_edge(u,v)
            if result.is_planar_graph():
                if result.edge_count == m: return
            else:
                # 直前に追加した辺だけを、辺情報と両端の隣接配列から取り消す。
                discard result.edge_info.pop()
                discard result.edges[u].pop()
                discard result.edges[v].pop()
        assert result.edge_count == m, "生成されたグラフの辺数が指定値と一致しません"

    proc random_connected_graph*(n,m:int):UnWeightedUnDirectedGraph=
        ## ランダムな単純連結グラフを生成。ただし、一様ランダムでない。
        assert m >= n-1, "連結グラフの辺数は頂点数から1を引いた値以上である必要があります"
        var g = random_tree(n)
        if n*(n-1) <= 10_000_000:
            var st = initHashSet[(int,int)]()
            for i in 0..<n-1:
                for j in (i+1)..<n:
                    st.incl((i,j))
            
            for i in 0..<n:
                for j in g[i]:
                    st.excl((i,j))

            assert m-n+1 <= len(st), "追加する辺の数が候補の数を超えています"
            var x = st.toseq()
            shuffle(x)
            for i in 0..<(m-n+1):
                var (u,v) = x[i]
                g.add_edge(u,v)
            return g
        else:
            var st = initHashSet[(int,int)]()
            for i in 0..<n:
                for j in g[i]:
                    st.incl((i,j))
            assert n*(n-1) - (n-1) >= m, "指定した辺数が生成可能な辺数の上限を超えています"
            for i in 0..<(m-n+1):
                while true:
                    var u = rand(0..<(n-1))
                    var v = rand((u+1)..<n)
                    if (u,v) notin st:
                        st.incl((u,v))
                        g.add_edge(u,v)
                        break
            return g

    proc random_01sequence*(n:int,one:int):seq[int]=
        ## 1の数がoneであるような長さnの01列を一様ランダムに返す
        assert one in 0..n, "指定した値が有効な範囲内である必要があります: one in 0 .. n"
        var tmp = randomseq(one,0..<n,true)
        result = newseqwith(n,0)
        for x in tmp:
            result[x] = 1
    
    proc random_string*(n:int,slice:HSlice[char,char]):string=
        ## sliceに含まれる文字からなる長さnの文字列を一様ランダムに返す
        assert n >= 0, "nは非負である必要があります"
        assert slice.len >= 1, "生成元の範囲は空でない必要があります"
        for i in 0..<n:
            result.add(rand(slice))
        return result
    
    proc random_string*(n:int,s:string):string=
        ## sに含まれる文字からなる長さnの文字列を一様ランダムに返す
        assert n >= 0, "nは非負である必要があります"
        assert s.len >= 1, "文字の候補は空でない必要があります"
        for i in 0..<n:
            result.add(s[rand(0..<len(s))])
        return result
