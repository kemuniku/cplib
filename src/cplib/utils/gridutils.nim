when not declared CPLIB_UTILS_GRIDUTILS:
    const CPLIB_UTILS_GRIDUTILS* = 1

    const dij4* = @[(0,1),(-1,0),(0,-1),(1,0)]
    const dij8* = @[(0,1),(-1,1),(-1,0),(-1,-1),(0,-1),(1,-1),(1,0),(1,1)]

    iterator griditer*(i,j,H,W:int,dij:openArray[(int,int)] = dij4):(int,int)=
        for (di,dj) in dij:
            if i+di in 0..<H and j+dj in 0..<W:
                yield (i+di,j+dj)
    
    proc gridfind*[T](grid : openArray[seq[T]],value:T):(int,int)=
        # 見つかったら (i,j) の内辞書順最小
        # そうでない場合は (-1,-1)
        for i in 0..<len(grid):
            for j in 0..<len(grid[i]):
                if grid[i][j] == value:
                    return (i,j)
        return (-1,-1)

    proc gridfinds*[T](grid : seq[seq[T]],value:T):seq[(int,int)]=
        for i in 0..<len(grid):
            for j in 0..<len(grid[i]):
                if grid[i][j] == value:
                    result.add((i,j))

    proc gridfind*(grid : openArray[string],value:char):(int,int)=
        # 見つかったら (i,j) の内辞書順最小
        # そうでない場合は (-1,-1)
        for i in 0..<len(grid):
            for j in 0..<len(grid[i]):
                if grid[i][j] == value:
                    return (i,j)
        return (-1,-1)

    proc gridfinds*(grid : seq[string],value:char):seq[(int,int)]=
        for i in 0..<len(grid):
            for j in 0..<len(grid[i]):
                if grid[i][j] == value:
                    result.add((i,j))

    proc height*[T](grid: openArray[seq[T]]): int {.inline.} =
        grid.len

    proc height*(grid: openArray[string]): int {.inline.} =
        grid.len

    proc width*[T](grid: openArray[seq[T]]): int {.inline.} =
        if grid.len == 0: 0 else: grid[0].len

    proc width*(grid: openArray[string]): int {.inline.} =
        if grid.len == 0: 0 else: grid[0].len
    
    proc getid*[T](grid: openArray[seq[T]],i,j:int):int=
        return i*(grid.width) + j

    proc getid*(grid: openArray[string],i,j:int):int=
        return i*(grid.width) + j

    proc to_pos*[T](grid: openArray[seq[T]],id:int):(int,int)=
        return (id div grid.width,id mod grid.width)

    proc to_pos*(grid: openArray[string],id:int):(int,int)=
        return (id div grid.width,id mod grid.width)
