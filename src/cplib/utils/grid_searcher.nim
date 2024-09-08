when not declared CPLIB_UTILS_GRID_SEARCHER:
    const CPLIB_UTILS_GRID_SEARCHER* = 1
    import cplib/collections/avlset
    import options
    type GridSearcher = object
        row : AvlSortedMultiSet[(int,int)]
        col : AvlSortedMultiSet[(int,int)]

    proc initGridSearcher*():GridSearcher=
        return GridSearcher(row:initAvlSortedMultiSet[(int,int)](),col:initAvlSortedMultiSet[(int,int)]())

    proc incl*(grid:var GridSearcher,i,j:int)=
        grid.row.incl((i,j))
        grid.col.incl((j,i))
    
    proc incl*(grid:var GridSearcher,ij:(int,int))=
        grid.row.incl(ij)
        grid.col.incl((ij[1],ij[0]))

    proc excl*(grid:var GridSearcher,i,j:int)=
        grid.row.excl((i,j))
        grid.col.excl((j,i))

    proc excl*(grid:var GridSearcher,ij:(int,int))=
        grid.row.excl(ij)
        grid.col.excl((ij[1],ij[0]))

    proc contains*(grid:GridSearcher,i,j:int):bool=grid.row.contains((i,j))
    proc contains*(grid:GridSearcher,ij:(int,int)):bool=grid.row.contains(ij)

    proc up*(grid:var GridSearcher,i,j:int):Option[(int,int)]=
        ## (i,j)よりも上にある壁(=jが等しくてiより小さいような場所にある壁)を探す
        result = grid.col.lt((j,i))
        if result.isNone() or result.get()[0] != j:
            return none((int,int))
        var (j,i) = result.get()
        return some((i,j))
    
    proc up*(grid:var GridSearcher,ij:(int,int)):Option[(int,int)]=
        return grid.up(ij[0],ij[1])

    proc up_move*(grid:var GridSearcher,i,j:int):Option[(int,int)]=
        ## (i,j)よりも上にある壁(=jが等しくてiより小さいような場所にある壁)を探し、(i+1,j)を返す
        result = grid.col.lt((j,i))
        if result.isNone() or result.get()[0] != j:
            return none((int,int))
        var (j,i) = result.get()
        return some((i+1,j))
    
    proc up_move*(grid:var GridSearcher,ij:(int,int)):Option[(int,int)]=
        return grid.up_move(ij[0],ij[1])


    proc down*(grid:var GridSearcher,i,j:int):Option[(int,int)]=
        ## (i,j)よりも下にある壁(=jが等しくてiより大きいような場所にある壁)を探す
        result = grid.col.gt((j,i))
        if result.isNone() or result.get()[0] != j:
            return none((int,int))
        var (j,i) = result.get()
        return some((i,j))
    
    proc down*(grid:var GridSearcher,ij:(int,int)):Option[(int,int)]=
        return grid.down(ij[0],ij[1])

    proc down_move*(grid:var GridSearcher,i,j:int):Option[(int,int)]=
        ## (i,j)よりも下にある壁(=jが等しくてiより大きいような場所にある壁)を探し、(i-1,j)を返す
        result = grid.col.gt((j,i))
        if result.isNone() or result.get()[0] != j:
            return none((int,int))
        var (j,i) = result.get()
        return some((i-1,j))

    proc down_move*(grid:var GridSearcher,ij:(int,int)):Option[(int,int)]=
        return grid.down_move(ij[0],ij[1])

    proc left*(grid:var GridSearcher,i,j:int):Option[(int,int)]=
        ## (i,j)よりも左にある壁(=iが等しくてjより小さいような場所にある壁)を探す
        result = grid.row.lt((i,j))
        if result.isNone() or  result.get()[0] != i:
            return none((int,int))
    
    proc left*(grid:var GridSearcher,ij:(int,int)):Option[(int,int)]=
        return grid.left(ij[0],ij[1])

    proc left_move*(grid:var GridSearcher,i,j:int):Option[(int,int)]=
        ## (i,j)よりも左にある壁(=iが等しくてjより小さいような場所にある壁)を探し、(i,j+1)を返す
        result = grid.row.lt((i,j))
        if result.isNone() or  result.get()[0] != i:
            return none((int,int))
        var (i,j) = result.get()
        return some((i,j+1))
    
    proc left_move*(grid:var GridSearcher,ij:(int,int)):Option[(int,int)]=
        return grid.left_move(ij[0],ij[1])

    proc right*(grid:var GridSearcher,i,j:int):Option[(int,int)]=
        ## (i,j)よりも右にある壁(=iが等しくてjより大きいような場所にある壁)を探す
        result = grid.row.gt((i,j))
        if result.isNone() or result.get()[0] != i:
            return none((int,int))
    
    proc right*(grid:var GridSearcher,ij:(int,int)):Option[(int,int)]=
        return grid.right(ij[0],ij[1])

    proc right_move*(grid:var GridSearcher,i,j:int):Option[(int,int)]=
        ## (i,j)よりも右にある壁(=iが等しくてjより大きいような場所にある壁)を探し、(i,j-1)を返す
        result = grid.row.gt((i,j))
        if result.isNone() or result.get()[0] != i:
            return none((int,int))
        var (i,j) = result.get()
        return some((i,j-1))
    
    proc right_move*(grid:var GridSearcher,ij:(int,int)):Option[(int,int)]=
        return grid.right_move(ij[0],ij[1])

    proc updownleftright*(grid:var GridSearcher,i,j:int):array[4, Option[(int,int)]]=
        return [grid.up(i,j),grid.down(i,j),grid.left(i,j),grid.right(i,j)]
    
    proc updownleftright*(grid:var GridSearcher,ij:(int,int)):array[4, Option[(int,int)]]=
        return [grid.up(ij),grid.down(ij),grid.left(ij),grid.right(ij)]

    proc updownleftright_get*(grid:var GridSearcher,i,j:int):seq[(int,int)]=
        for xy in grid.updownleftright(i,j):
            if xy.isSome():
                result.add(xy.get())
    
    proc updownleftright_get*(grid:var GridSearcher,ij:(int,int)):seq[(int,int)]=
        for xy in grid.updownleftright(ij):
            if xy.isSome():
                result.add(xy.get())

    proc updownleftright_move*(grid:var GridSearcher,i,j:int):array[4, Option[(int,int)]]=
        return [grid.up_move(i,j),grid.down_move(i,j),grid.left_move(i,j),grid.right_move(i,j)]

    proc updownleftright_move*(grid:var GridSearcher,ij:(int,int)):array[4, Option[(int,int)]]=
        return [grid.up_move(ij),grid.down_move(ij),grid.left_move(ij),grid.right_move(ij)]
    
    proc updownleftright_move_get*(grid:var GridSearcher,i,j:int):seq[(int,int)]=
        for xy in grid.updownleftright_move(i,j):
            if xy.isSome():
                result.add(xy.get())
    
    proc updownleftright_move_get*(grid:var GridSearcher,ij:(int,int)):seq[(int,int)]=
        for xy in grid.updownleftright_move(ij):
            if xy.isSome():
                result.add(xy.get())


    proc len*(grid:GridSearcher):int=
        return len(grid.row)