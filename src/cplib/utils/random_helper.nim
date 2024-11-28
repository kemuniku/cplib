when not declared CPLIB_UTILS_RANDOMHELPER:
    const CPLIB_UTILS_RANDOMHELPER* = 1
    import random,sequtils,sets,algorithm,math,strutils
    import cplib/graph/graph
    import cplib/tree/prufer
    import cplib/math/isprime
    # https://kanpurin.hatenablog.com/entry/2023/02/20/184752
    randomize()

    proc randomseq*(n:int,slice:HSlice[int,int],unique:bool=false):seq[int]=
        ## 長さn,各要素がsliceに含まれる数列を一様ランダムに返す
        ## option: unique = Trueのとき、重複を許さない。
        assert n >= 0
        assert slice.len >= 1
        if unique:
            assert n <= slice.len
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
        assert len(result) == n
        assert result.allit(it in slice)

    proc randomseq_from_sum*(n:int,sum:int):seq[int]=
        ## 長さn,総和がsumである各要素が非負整数である数列を一様ランダムに返す
        assert sum >= 0
        assert n >= 0
        if n == 0:
            return @[]
        var tmp = randomseq(n-1,1..(n+sum-1),true).sorted()
        var now = 0
        for x in tmp:
            result.add(x-now-1)
            now = x
        result.add((n+sum-1) - now)
        assert len(result) == n and sum(result) == sum

    proc random_parenthesis_sequence*(n:int):seq[int]=
        ## 長さnの括弧列を返す。
        ##　1: "(" , -1 : ")"
        assert n mod 2 == 0

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
            assert check >= 0
        assert check == 0

    proc random_parenthesis_string*(n:int):string=
        return random_parenthesis_sequence(n).mapit(").("[1+it]).join("")

    proc make_binary_tree_from_sequence*(PS:seq[int]):UnWeightedUnDirectedGraph=
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
        assert edge_count == n-1
        return g

    proc random_binary_tree*(n:int):UnWeightedUnDirectedGraph=
        ## n頂点の二分木を一様ランダムに返す
        assert n >= 1
        var PS = random_parenthesis_sequence(2*n)
        return make_binary_tree_from_sequence(PS)

    proc random_tree*(n:int):UnWeightedUnDirectedGraph=
        ## n頂点の木を一様ランダムに返す
        assert n >= 1
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
            assert f #sliceに素数が含まれるかどうか判定
        
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
        assert m <= n*(n-1)
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


    proc random_connected_graph*(n,m:int):UnWeightedUnDirectedGraph=
        ## ランダムな単純連結グラフを生成。ただし、一様ランダムでない。
        assert m >= n-1
        var g = random_tree(n)
        if n*(n-1) <= 10_000_000:
            var st = initHashSet[(int,int)]()
            for i in 0..<n-1:
                for j in (i+1)..<n:
                    st.incl((i,j))
            
            for i in 0..<n:
                for j in g[i]:
                    st.excl((i,j))

            assert m-n+1 <= len(st)
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
            assert n*(n-1) - (n-1) >= m
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
        assert one in 0..n
        var tmp = randomseq(one,0..<n,true)
        result = newseqwith(n,0)
        for x in tmp:
            result[x] = 1