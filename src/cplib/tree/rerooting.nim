# https://trap.jp/post/1702/ を参考に作成
when not declared CPLIB_TREE_REROOTING:
    const CPLIB_TREE_REROOTING* = 1
    import cplib/graph/graph
    import sequtils
    proc solve_Rerooting*[E,V](G:UnWeightedUnDirectedGraph,merge : proc(a,b:E):E,e:E,put_edge : proc(x:V,u,v:int):E,put_vertex : proc(x:E,v:int):V):seq[V]=
        ## モノイドの型 E   DPの値の型 V
        ## merge:モノイド同士のマージ
        ## e:単位元
        ## put_edge 辺u,v間の辺情報を付与(遷移させるときにつけたいやつ)
        ## put_vertex 頂点vの頂点情報を付与(DPの結果の値を確定させるときにつけたいやつ)
        var values = newseq[seq[E]](len(G))
        var L = newseq[seq[E]](len(G))
        var R = newseq[seq[E]](len(G))
        var res = newseq[V](len(G))
        proc dfs1(x,p:int):E=
            var values : seq[E]
            values.add(e)
            for y in G[x]:
                if y != p:
                    values.add(put_edge(put_vertex(dfs1(y,x),y),x,y))
            values.add(e)
            var now = e
            var l = newseq[E](len(values))
            var r = newseq[E](len(values))
            for i in 0..<(len(values)):
                now = merge(now,values[i])
                l[i] = now
            now = e
            for i in countdown((len(values))-1,0,1):
                now = merge(values[i],now)
                r[i] = now
            L[x] = move(l)
            R[x] = move(r)
            return now
        res[0] = put_vertex(dfs1(0,-1),0)
        proc dfs2(x,p:int,value:E)=
            if p == -1:
                var i = 0
                for y in G[x]:
                    dfs2(y,x,put_edge(put_vertex(merge(L[x][i],R[x][i+2]),x),x,y))
                    i += 1
            else:
                res[x] = put_vertex(merge(L[x][^1],value),x)
                var i = 0
                for y in G[x]:
                    if y != p:
                        dfs2(y,x,put_edge(put_vertex(merge(merge(L[x][i],R[x][i+2]),value),x),x,y))
                        i += 1
        dfs2(0,-1,e)
        return res