when not declared CPLIB_GRAPH_DIJKSTRA:
    import cplib/graph/graph
    import std/heapqueue
    import algorithm
    const CPLIB_GRAPH_DIJKSTRA* = 1 
    proc restore_dijkstra*[T](G:Graph[T],start:int,ZERO:T = 0,INF:T = int(3300300300300300491)):tuple[costs:seq[T],prev:seq[int]]=
        var
            queue = initHeapQueue[(T,int)]()
            costs = newSeq[T](len(G.edges))
            prev = newseq[int](len(G.edges))
        costs.fill(INF)
        prev.fill(-1)
        queue.push((ZERO,start))
        costs[start] = ZERO
        while len(queue) != 0:
            var (cost,i) = queue.pop()
            if cost > costs[i]:
                continue
            for (j,c) in G.edges[i]:
                var temp = costs[i] + c
                if temp < costs[j]:
                    prev[j] = i
                    costs[j] = temp
                    queue.push((temp,j))
        return (costs,prev)
    proc dijkstra*[T](G:Graph[T],start:int,ZERO:T = 0,INF:T = int(3300300300300300491)):seq[T]=
        var costs,_ = restore_dijkstra(G,start,ZERO,INF)
        return costs
    proc restore_shortestpath_from_prev*(prev:seq[int],goal:int):seq[int]=
        var i = goal
        while i != -1:
            result.add(i)
            i = prev[i]
        result = result.reversed()
    proc shortest_path*[T](G:Graph[T],start:int,goal:int,ZERO:T = 0,INF:T = int(3300300300300300491)):tuple[path:seq[int],cost:int]=
        var (costs,prev) = restore_dijkstra(G,start,ZERO,INF)
        result.path = prev.restore_shortestpath_from_prev(goal)
        result.cost = costs[goal]