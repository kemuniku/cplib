when not declared CPLIB_COLLECTIONS_DEFAULTDICT:
    const CPLIB_COLLECTIONS_DEFAULTDICT* = 1
    import tables, hashes
    type DefaultDict*[K, V] = object
        table: Table[K, V]
        default: V
    proc initDefaultDict*[K, V](default: V): DefaultDict[K, V] = DefaultDict[K, V](table: initTable[K, V](), default: default)
    proc `==`*[K, V](src, dst: DefaultDict[K, V]): bool = src.table == dst.table
    proc `[]=`*[K, V](d: var DefaultDict[K, V], key: K, val: V) = d.table[key] = val
    proc `[]`*[K, V](d: DefaultDict[K, V], key: K): V =
        if key notin d.table: return d.default()
        return d.table[key]
    proc `[]`*[K, V](d: var DefaultDict[K, V], key: K): var V =
        if key notin d.table: d.table[key] = d.default
        return d.table[key]
    proc clear*[K, V](d: var DefaultDict[K, V]) = d.table = initTable[K, V](0)
    proc contains*[K, V](d: var DefaultDict[K, V], key: K): bool = d.table.contains(key)
    proc del*[K, V](d: var DefaultDict[K, V], key: K) = d.table.del(key)
    proc hash*[K, V](d: DefaultDict[K, V]): Hash = d.table.hash
    proc hasKey*[K, V](d: DefaultDict[K, V], key: K): bool = d.table.hasKey(key)
    proc len*[K, V](d: DefaultDict[K, V]): int = d.table.len
    proc pop*[K, V](d: var DefaultDict, key: K, val: var V): bool = d.table.pop(key, val)
    proc take*[K, V](d: var DefaultDict, key: K, val: var V): bool = d.table.pop(key, val)
    proc toDefaultDict*[K, V](pairs: openArray[(K, V)], default: V): DefaultDict[K, V] =
        result = initDefaultDict[K, V](default)
        result.table = pairs.toTable
    proc toDefaultDict*[K, V](table: Table[K, V], default: V): DefaultDict[K, V] =
        result = initDefaultDict[K, V](default)
        result.table = table
    iterator pairs*[K, V](d: DefaultDict[K, V]): (K, V) =
        for k, v in d.table: yield (k, v)
    proc `$`*[K, V](d: DefaultDict[K, V]): string = $(d.table)
