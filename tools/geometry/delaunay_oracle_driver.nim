import json, strutils, sequtils
import cplib/geometry/delaunay_triangulation
import cplib/geometry/euclidean_mst

for line in stdin.lines:
    let input = parseJson(line)
    var points: seq[(int64, int64)]
    for p in input:
        points.add((parseBiggestInt($p[0]), parseBiggestInt($p[1])))
    let mesh = delaunay_triangulation(points)
    echo $(%* {"representative": mesh.representative, "edges": mesh.edges.mapIt([it[0], it[1]]),
        "triangles": mesh.triangles.mapIt([it[0], it[1], it[2]]), "mst": euclidean_mst(points).mapIt([it[0], it[1]])})
