when not declared CPLIB_GRAPH_GRAPHVISUALIZATION:
    const CPLIB_GRAPH_GRAPHVISUALIZATION* = 1
    import math, strutils
    import cplib/graph/graph

    type GraphPoint = tuple[x, y: float]

    proc cross(a, b, c: GraphPoint): float =
        ## 三点の向きを外積で求める。O(1)。
        (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)

    proc layout_score(positions: seq[GraphPoint],
            edges: seq[tuple[u, v: int]]): float =
        ## 辺の交差、頂点と辺の重なり、近すぎる頂点を評価する。O((V + E)^2)。
        for i in 0..<positions.len:
            for j in i + 1..<positions.len:
                let dx = positions[i].x - positions[j].x
                let dy = positions[i].y - positions[j].y
                let shortfall = max(0.0, 44.0 - sqrt(dx * dx + dy * dy))
                result += shortfall * shortfall * 100.0
        for i, e in edges:
            let a = positions[e.u]
            let b = positions[e.v]
            let dx = b.x - a.x
            let dy = b.y - a.y
            let distanceSquared = max(0.001, dx * dx + dy * dy)
            result += distanceSquared * 0.01
            for v, p in positions:
                if v == e.u or v == e.v: continue
                let t = max(0.0, min(1.0, ((p.x - a.x) * dx + (p.y - a.y) * dy) / distanceSquared))
                let px = p.x - a.x - t * dx
                let py = p.y - a.y - t * dy
                let shortfall = max(0.0, 26.0 - sqrt(px * px + py * py))
                result += shortfall * shortfall * 100.0
            for j in i + 1..<edges.len:
                let f = edges[j]
                if e.u == f.u or e.u == f.v or e.v == f.u or e.v == f.v: continue
                let c = positions[f.u]
                let d = positions[f.v]
                if cross(a, b, c) * cross(a, b, d) < -0.001 and
                        cross(c, d, a) * cross(c, d, b) < -0.001:
                    result += 1000000.0

    proc graph_positions(g: UnWeightedDirectedGraph or UnWeightedUnDirectedGraph): seq[GraphPoint] =
        ## 固定回数のばねモデルで配置し、交差・重なりの少ない配置を選ぶ。O((V + E)^2)。
        let n = g.len
        if n == 0: return @[]
        if n == 1: return @[(160.0, 160.0)]
        var edges: seq[tuple[u, v: int]]
        for e in g.edge_info:
            if e.src != e.dst: edges.add((e.src, e.dst))
        let ideal = sqrt(40000.0 / n.float)
        var bestScore = Inf
        for attempt in 0..<4:
            var state = 123456789'u32 + attempt.uint32 * 10007'u32
            var positions = newSeq[GraphPoint](n)
            for v in 0..<n:
                for axis in 0..<2:
                    state = state xor (state shl 13)
                    state = state xor (state shr 17)
                    state = state xor (state shl 5)
                    let coordinate = state.float / high(uint32).float * 200.0 - 100.0
                    if axis == 0: positions[v].x = coordinate
                    else: positions[v].y = coordinate
            var forces = newSeq[GraphPoint](n)
            for iteration in 0..<300:
                for v in 0..<n:
                    forces[v] = (-positions[v].x * 2.0, -positions[v].y * 2.0)
                for u in 0..<n:
                    for v in u + 1..<n:
                        let dx = positions[u].x - positions[v].x
                        let dy = positions[u].y - positions[v].y
                        let distanceSquared = max(0.01, dx * dx + dy * dy)
                        let force = ideal * ideal / distanceSquared
                        forces[u].x += dx * force
                        forces[u].y += dy * force
                        forces[v].x -= dx * force
                        forces[v].y -= dy * force
                for e in edges:
                    let dx = positions[e.u].x - positions[e.v].x
                    let dy = positions[e.u].y - positions[e.v].y
                    let force = sqrt(dx * dx + dy * dy) / ideal
                    forces[e.u].x -= dx * force
                    forces[e.u].y -= dy * force
                    forces[e.v].x += dx * force
                    forces[e.v].y += dy * force
                let temperature = 12.0 * (1.0 - iteration.float / 300.0) + 0.02
                for v in 0..<n:
                    let magnitude = sqrt(forces[v].x * forces[v].x + forces[v].y * forces[v].y)
                    let step = min(temperature, magnitude) / max(0.001, magnitude)
                    positions[v].x += forces[v].x * step
                    positions[v].y += forces[v].y * step
            var minX = Inf
            var minY = Inf
            var maxX = -Inf
            var maxY = -Inf
            for p in positions:
                minX = min(minX, p.x)
                minY = min(minY, p.y)
                maxX = max(maxX, p.x)
                maxY = max(maxY, p.y)
            let scale = 244.0 / max(1.0, max(maxX - minX, maxY - minY))
            for v in 0..<n:
                positions[v].x = 160.0 + (positions[v].x - (minX + maxX) / 2.0) * scale
                positions[v].y = 160.0 + (positions[v].y - (minY + maxY) / 2.0) * scale
            let score = layout_score(positions, edges)
            if score < bestScore:
                bestScore = score
                result = positions

    proc svg_number(value: float): string =
        ## SVG の座標を小数点以下三桁で表す。
        formatFloat(value, ffDecimal, 3)

    proc graph_svg(g: UnWeightedDirectedGraph or UnWeightedUnDirectedGraph,
            indexed, serial: int): string =
        ## グラフの接続に応じて頂点を配置し SVG を生成する。O((V + E)^2)。
        result = "<svg viewBox=\"0 0 320 320\" role=\"img\" aria-label=\"Graph " & $serial & "\">\n"
        when g is UnWeightedDirectedGraph:
            let arrow = "arrow" & $serial
            result.add("<defs><marker id=\"" & arrow & "\" viewBox=\"0 0 10 10\" refX=\"9\" refY=\"5\" markerWidth=\"7\" markerHeight=\"7\" orient=\"auto\"><path d=\"M 0 0 L 10 5 L 0 10 z\" fill=\"#64748b\"/></marker></defs>\n")
        let positions = graph_positions(g)
        for e in g.edge_info:
            let a = positions[e.src]
            let b = positions[e.dst]
            when g is UnWeightedDirectedGraph:
                let dx = b.x - a.x
                let dy = b.y - a.y
                let distance = sqrt(dx * dx + dy * dy)
                let control = ((a.x + b.x) / 2.0 - dy * 0.15,
                               (a.y + b.y) / 2.0 + dx * 0.15)
                let tangentX = b.x - control[0]
                let tangentY = b.y - control[1]
                let tangentLen = sqrt(tangentX * tangentX + tangentY * tangentY)
                let startX = a.x + dx / distance * 18.0
                let startY = a.y + dy / distance * 18.0
                let endX = b.x - tangentX / tangentLen * 20.0
                let endY = b.y - tangentY / tangentLen * 20.0
                result.add("<path d=\"M " & svg_number(startX) & " " & svg_number(startY) &
                    " Q " & svg_number(control[0]) & " " & svg_number(control[1]) &
                    " " & svg_number(endX) & " " & svg_number(endY) &
                    "\" fill=\"none\" stroke=\"#64748b\" stroke-width=\"2\" marker-end=\"url(#" & arrow & ")\"/>\n")
            else:
                result.add("<line x1=\"" & svg_number(a.x) & "\" y1=\"" & svg_number(a.y) &
                    "\" x2=\"" & svg_number(b.x) & "\" y2=\"" & svg_number(b.y) &
                    "\" stroke=\"#64748b\" stroke-width=\"2\"/>\n")
        for v, p in positions:
            result.add("<circle cx=\"" & svg_number(p.x) & "\" cy=\"" & svg_number(p.y) &
                "\" r=\"17\" fill=\"#eff6ff\" stroke=\"#2563eb\" stroke-width=\"2\"/>\n")
            result.add("<text x=\"" & svg_number(p.x) & "\" y=\"" & svg_number(p.y) &
                "\" text-anchor=\"middle\" dy=\"0.35em\" font-size=\"13\" fill=\"#172554\">" & $(v + indexed) & "</text>\n")
        result.add("</svg>\n")

    template visualize_graphs*(graphs: untyped, predicate: typed,
            output: string = "graphs.html", max_results: int = 0,
            indexed: int = 0): int =
        ## 指定した列挙式から判定が真のグラフを既定で全件 HTML に保存し件数を返す。上限 0 は無制限。配置は一件 O((V + E)^2)。
        block:
            let limit = max_results
            let offset = indexed
            let acceptGraph = predicate
            if limit < 0:
                raise newException(ValueError, "表示件数の上限は非負で指定してください")
            if acceptGraph == nil:
                raise newException(ValueError, "判定関数を指定してください")
            let file = open(output, fmWrite)
            defer: file.close()
            file.write("""<!doctype html>
<html lang="ja"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Graph enumeration</title>
<style>
body{font-family:system-ui,sans-serif;background:#f8fafc;color:#0f172a;margin:24px}
main{display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:16px}
article{background:white;border:1px solid #cbd5e1;border-radius:12px;padding:16px}
h1{font-size:24px}h2{font-size:16px;margin:0}svg{width:100%;max-height:340px}
pre{white-space:pre-wrap}summary{cursor:pointer}footer{margin-top:24px}
</style><h1>条件を満たすグラフ</h1>
""")
            file.write("<main>\n")
            var count = 0
            var limited = false
            for g in graphs:
                if not acceptGraph(g): continue
                inc count
                file.write("<article data-edge-count=\"" & $g.edge_count & "\"><h2>#" & $count &
                    " / " & $g.len & " 頂点 / " & $g.edge_count & " 辺 / ")
                when g is UnWeightedDirectedGraph:
                    file.write("有向グラフ")
                else:
                    file.write("無向グラフ")
                file.write("</h2>\n")
                file.write(graph_svg(g, offset, count))
                file.write("<details><summary>辺リスト</summary><pre>" & $g.len & " " & $g.edge_count & "\n")
                for e in g.edge_info:
                    file.write($(e.src + offset) & " " & $(e.dst + offset) & "\n")
                file.write("</pre></details></article>\n")
                if limit > 0 and count >= limit:
                    limited = true
                    break
            file.write("</main><footer>表示件数: " & $count)
            if limited:
                file.write(" / 表示上限に達したため探索を終了しました（全件数は未集計）")
            elif count == 0:
                file.write(" / 条件を満たすグラフはありません")
            file.write("</footer></html>\n")
            count
