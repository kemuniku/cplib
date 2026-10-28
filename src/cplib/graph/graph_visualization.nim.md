---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/graph/graph_visualization_test.nim
    title: verify/graph/graph_visualization_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/graph_visualization_test.nim
    title: verify/graph/graph_visualization_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_GRAPHVISUALIZATION:\n    const CPLIB_GRAPH_GRAPHVISUALIZATION*\
    \ = 1\n    import math, strutils\n    import cplib/graph/graph\n\n    type GraphPoint\
    \ = tuple[x, y: float]\n\n    proc cross(a, b, c: GraphPoint): float =\n     \
    \   ## \u4E09\u70B9\u306E\u5411\u304D\u3092\u5916\u7A4D\u3067\u6C42\u3081\u308B\
    \u3002O(1)\u3002\n        (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)\n\
    \n    proc layout_score(positions: seq[GraphPoint],\n            edges: seq[tuple[u,\
    \ v: int]]): float =\n        ## \u8FBA\u306E\u4EA4\u5DEE\u3001\u9802\u70B9\u3068\
    \u8FBA\u306E\u91CD\u306A\u308A\u3001\u8FD1\u3059\u304E\u308B\u9802\u70B9\u3092\
    \u8A55\u4FA1\u3059\u308B\u3002O((V + E)^2)\u3002\n        for i in 0..<positions.len:\n\
    \            for j in i + 1..<positions.len:\n                let dx = positions[i].x\
    \ - positions[j].x\n                let dy = positions[i].y - positions[j].y\n\
    \                let shortfall = max(0.0, 44.0 - sqrt(dx * dx + dy * dy))\n  \
    \              result += shortfall * shortfall * 100.0\n        for i, e in edges:\n\
    \            let a = positions[e.u]\n            let b = positions[e.v]\n    \
    \        let dx = b.x - a.x\n            let dy = b.y - a.y\n            let distanceSquared\
    \ = max(0.001, dx * dx + dy * dy)\n            result += distanceSquared * 0.01\n\
    \            for v, p in positions:\n                if v == e.u or v == e.v:\
    \ continue\n                let t = max(0.0, min(1.0, ((p.x - a.x) * dx + (p.y\
    \ - a.y) * dy) / distanceSquared))\n                let px = p.x - a.x - t * dx\n\
    \                let py = p.y - a.y - t * dy\n                let shortfall =\
    \ max(0.0, 26.0 - sqrt(px * px + py * py))\n                result += shortfall\
    \ * shortfall * 100.0\n            for j in i + 1..<edges.len:\n             \
    \   let f = edges[j]\n                if e.u == f.u or e.u == f.v or e.v == f.u\
    \ or e.v == f.v: continue\n                let c = positions[f.u]\n          \
    \      let d = positions[f.v]\n                if cross(a, b, c) * cross(a, b,\
    \ d) < -0.001 and\n                        cross(c, d, a) * cross(c, d, b) < -0.001:\n\
    \                    result += 1000000.0\n\n    proc graph_positions(g: UnWeightedDirectedGraph\
    \ or UnWeightedUnDirectedGraph): seq[GraphPoint] =\n        ## \u56FA\u5B9A\u56DE\
    \u6570\u306E\u3070\u306D\u30E2\u30C7\u30EB\u3067\u914D\u7F6E\u3057\u3001\u4EA4\
    \u5DEE\u30FB\u91CD\u306A\u308A\u306E\u5C11\u306A\u3044\u914D\u7F6E\u3092\u9078\
    \u3076\u3002O((V + E)^2)\u3002\n        let n = g.len\n        if n == 0: return\
    \ @[]\n        if n == 1: return @[(160.0, 160.0)]\n        var edges: seq[tuple[u,\
    \ v: int]]\n        for e in g.edge_info:\n            if e.src != e.dst: edges.add((e.src,\
    \ e.dst))\n        let ideal = sqrt(40000.0 / n.float)\n        var bestScore\
    \ = Inf\n        for attempt in 0..<4:\n            var state = 123456789'u32\
    \ + attempt.uint32 * 10007'u32\n            var positions = newSeq[GraphPoint](n)\n\
    \            for v in 0..<n:\n                for axis in 0..<2:\n           \
    \         state = state xor (state shl 13)\n                    state = state\
    \ xor (state shr 17)\n                    state = state xor (state shl 5)\n  \
    \                  let coordinate = state.float / high(uint32).float * 200.0 -\
    \ 100.0\n                    if axis == 0: positions[v].x = coordinate\n     \
    \               else: positions[v].y = coordinate\n            var forces = newSeq[GraphPoint](n)\n\
    \            for iteration in 0..<300:\n                for v in 0..<n:\n    \
    \                forces[v] = (-positions[v].x * 2.0, -positions[v].y * 2.0)\n\
    \                for u in 0..<n:\n                    for v in u + 1..<n:\n  \
    \                      let dx = positions[u].x - positions[v].x\n            \
    \            let dy = positions[u].y - positions[v].y\n                      \
    \  let distanceSquared = max(0.01, dx * dx + dy * dy)\n                      \
    \  let force = ideal * ideal / distanceSquared\n                        forces[u].x\
    \ += dx * force\n                        forces[u].y += dy * force\n         \
    \               forces[v].x -= dx * force\n                        forces[v].y\
    \ -= dy * force\n                for e in edges:\n                    let dx =\
    \ positions[e.u].x - positions[e.v].x\n                    let dy = positions[e.u].y\
    \ - positions[e.v].y\n                    let force = sqrt(dx * dx + dy * dy)\
    \ / ideal\n                    forces[e.u].x -= dx * force\n                 \
    \   forces[e.u].y -= dy * force\n                    forces[e.v].x += dx * force\n\
    \                    forces[e.v].y += dy * force\n                let temperature\
    \ = 12.0 * (1.0 - iteration.float / 300.0) + 0.02\n                for v in 0..<n:\n\
    \                    let magnitude = sqrt(forces[v].x * forces[v].x + forces[v].y\
    \ * forces[v].y)\n                    let step = min(temperature, magnitude) /\
    \ max(0.001, magnitude)\n                    positions[v].x += forces[v].x * step\n\
    \                    positions[v].y += forces[v].y * step\n            var minX\
    \ = Inf\n            var minY = Inf\n            var maxX = -Inf\n           \
    \ var maxY = -Inf\n            for p in positions:\n                minX = min(minX,\
    \ p.x)\n                minY = min(minY, p.y)\n                maxX = max(maxX,\
    \ p.x)\n                maxY = max(maxY, p.y)\n            let scale = 244.0 /\
    \ max(1.0, max(maxX - minX, maxY - minY))\n            for v in 0..<n:\n     \
    \           positions[v].x = 160.0 + (positions[v].x - (minX + maxX) / 2.0) *\
    \ scale\n                positions[v].y = 160.0 + (positions[v].y - (minY + maxY)\
    \ / 2.0) * scale\n            let score = layout_score(positions, edges)\n   \
    \         if score < bestScore:\n                bestScore = score\n         \
    \       result = positions\n\n    proc svg_number(value: float): string =\n  \
    \      ## SVG \u306E\u5EA7\u6A19\u3092\u5C0F\u6570\u70B9\u4EE5\u4E0B\u4E09\u6841\
    \u3067\u8868\u3059\u3002\n        formatFloat(value, ffDecimal, 3)\n\n    proc\
    \ graph_svg(g: UnWeightedDirectedGraph or UnWeightedUnDirectedGraph,\n       \
    \     indexed, serial: int): string =\n        ## \u30B0\u30E9\u30D5\u306E\u63A5\
    \u7D9A\u306B\u5FDC\u3058\u3066\u9802\u70B9\u3092\u914D\u7F6E\u3057 SVG \u3092\u751F\
    \u6210\u3059\u308B\u3002O((V + E)^2)\u3002\n        result = \"<svg viewBox=\\\
    \"0 0 320 320\\\" role=\\\"img\\\" aria-label=\\\"Graph \" & $serial & \"\\\"\
    >\\n\"\n        when g is UnWeightedDirectedGraph:\n            let arrow = \"\
    arrow\" & $serial\n            result.add(\"<defs><marker id=\\\"\" & arrow &\
    \ \"\\\" viewBox=\\\"0 0 10 10\\\" refX=\\\"9\\\" refY=\\\"5\\\" markerWidth=\\\
    \"7\\\" markerHeight=\\\"7\\\" orient=\\\"auto\\\"><path d=\\\"M 0 0 L 10 5 L\
    \ 0 10 z\\\" fill=\\\"#64748b\\\"/></marker></defs>\\n\")\n        let positions\
    \ = graph_positions(g)\n        for e in g.edge_info:\n            let a = positions[e.src]\n\
    \            let b = positions[e.dst]\n            when g is UnWeightedDirectedGraph:\n\
    \                let dx = b.x - a.x\n                let dy = b.y - a.y\n    \
    \            let distance = sqrt(dx * dx + dy * dy)\n                let control\
    \ = ((a.x + b.x) / 2.0 - dy * 0.15,\n                               (a.y + b.y)\
    \ / 2.0 + dx * 0.15)\n                let tangentX = b.x - control[0]\n      \
    \          let tangentY = b.y - control[1]\n                let tangentLen = sqrt(tangentX\
    \ * tangentX + tangentY * tangentY)\n                let startX = a.x + dx / distance\
    \ * 18.0\n                let startY = a.y + dy / distance * 18.0\n          \
    \      let endX = b.x - tangentX / tangentLen * 20.0\n                let endY\
    \ = b.y - tangentY / tangentLen * 20.0\n                result.add(\"<path d=\\\
    \"M \" & svg_number(startX) & \" \" & svg_number(startY) &\n                 \
    \   \" Q \" & svg_number(control[0]) & \" \" & svg_number(control[1]) &\n    \
    \                \" \" & svg_number(endX) & \" \" & svg_number(endY) &\n     \
    \               \"\\\" fill=\\\"none\\\" stroke=\\\"#64748b\\\" stroke-width=\\\
    \"2\\\" marker-end=\\\"url(#\" & arrow & \")\\\"/>\\n\")\n            else:\n\
    \                result.add(\"<line x1=\\\"\" & svg_number(a.x) & \"\\\" y1=\\\
    \"\" & svg_number(a.y) &\n                    \"\\\" x2=\\\"\" & svg_number(b.x)\
    \ & \"\\\" y2=\\\"\" & svg_number(b.y) &\n                    \"\\\" stroke=\\\
    \"#64748b\\\" stroke-width=\\\"2\\\"/>\\n\")\n        for v, p in positions:\n\
    \            result.add(\"<circle cx=\\\"\" & svg_number(p.x) & \"\\\" cy=\\\"\
    \" & svg_number(p.y) &\n                \"\\\" r=\\\"17\\\" fill=\\\"#eff6ff\\\
    \" stroke=\\\"#2563eb\\\" stroke-width=\\\"2\\\"/>\\n\")\n            result.add(\"\
    <text x=\\\"\" & svg_number(p.x) & \"\\\" y=\\\"\" & svg_number(p.y) &\n     \
    \           \"\\\" text-anchor=\\\"middle\\\" dy=\\\"0.35em\\\" font-size=\\\"\
    13\\\" fill=\\\"#172554\\\">\" & $(v + indexed) & \"</text>\\n\")\n        result.add(\"\
    </svg>\\n\")\n\n    template visualize_graphs*(graphs: untyped, predicate: typed,\n\
    \            output: string = \"graphs.html\", max_results: int = 0,\n       \
    \     indexed: int = 0): int =\n        ## \u6307\u5B9A\u3057\u305F\u5217\u6319\
    \u5F0F\u304B\u3089\u5224\u5B9A\u304C\u771F\u306E\u30B0\u30E9\u30D5\u3092\u65E2\
    \u5B9A\u3067\u5168\u4EF6 HTML \u306B\u4FDD\u5B58\u3057\u4EF6\u6570\u3092\u8FD4\
    \u3059\u3002\u4E0A\u9650 0 \u306F\u7121\u5236\u9650\u3002\u914D\u7F6E\u306F\u4E00\
    \u4EF6 O((V + E)^2)\u3002\n        block:\n            let limit = max_results\n\
    \            let offset = indexed\n            let acceptGraph = predicate\n \
    \           if limit < 0:\n                raise newException(ValueError, \"\u8868\
    \u793A\u4EF6\u6570\u306E\u4E0A\u9650\u306F\u975E\u8CA0\u3067\u6307\u5B9A\u3057\
    \u3066\u304F\u3060\u3055\u3044\")\n            if acceptGraph == nil:\n      \
    \          raise newException(ValueError, \"\u5224\u5B9A\u95A2\u6570\u3092\u6307\
    \u5B9A\u3057\u3066\u304F\u3060\u3055\u3044\")\n            let file = open(output,\
    \ fmWrite)\n            defer: file.close()\n            file.write(\"\"\"<!doctype\
    \ html>\n<html lang=\"ja\"><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"\
    width=device-width,initial-scale=1\">\n<title>Graph enumeration</title>\n<style>\n\
    body{font-family:system-ui,sans-serif;background:#f8fafc;color:#0f172a;margin:24px}\n\
    main{display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:16px}\n\
    article{background:white;border:1px solid #cbd5e1;border-radius:12px;padding:16px}\n\
    h1{font-size:24px}h2{font-size:16px;margin:0}svg{width:100%;max-height:340px}\n\
    pre{white-space:pre-wrap}summary{cursor:pointer}footer{margin-top:24px}\n</style><h1>\u6761\
    \u4EF6\u3092\u6E80\u305F\u3059\u30B0\u30E9\u30D5</h1>\n\"\"\")\n            file.write(\"\
    <main>\\n\")\n            var count = 0\n            var limited = false\n   \
    \         for g in graphs:\n                if not acceptGraph(g): continue\n\
    \                inc count\n                file.write(\"<article data-edge-count=\\\
    \"\" & $g.edge_count & \"\\\"><h2>#\" & $count &\n                    \" / \"\
    \ & $g.len & \" \u9802\u70B9 / \" & $g.edge_count & \" \u8FBA / \")\n        \
    \        when g is UnWeightedDirectedGraph:\n                    file.write(\"\
    \u6709\u5411\u30B0\u30E9\u30D5\")\n                else:\n                   \
    \ file.write(\"\u7121\u5411\u30B0\u30E9\u30D5\")\n                file.write(\"\
    </h2>\\n\")\n                file.write(graph_svg(g, offset, count))\n       \
    \         file.write(\"<details><summary>\u8FBA\u30EA\u30B9\u30C8</summary><pre>\"\
    \ & $g.len & \" \" & $g.edge_count & \"\\n\")\n                for e in g.edge_info:\n\
    \                    file.write($(e.src + offset) & \" \" & $(e.dst + offset)\
    \ & \"\\n\")\n                file.write(\"</pre></details></article>\\n\")\n\
    \                if limit > 0 and count >= limit:\n                    limited\
    \ = true\n                    break\n            file.write(\"</main><footer>\u8868\
    \u793A\u4EF6\u6570: \" & $count)\n            if limited:\n                file.write(\"\
    \ / \u8868\u793A\u4E0A\u9650\u306B\u9054\u3057\u305F\u305F\u3081\u63A2\u7D22\u3092\
    \u7D42\u4E86\u3057\u307E\u3057\u305F\uFF08\u5168\u4EF6\u6570\u306F\u672A\u96C6\
    \u8A08\uFF09\")\n            elif count == 0:\n                file.write(\" /\
    \ \u6761\u4EF6\u3092\u6E80\u305F\u3059\u30B0\u30E9\u30D5\u306F\u3042\u308A\u307E\
    \u305B\u3093\")\n            file.write(\"</footer></html>\\n\")\n           \
    \ count\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/graph_visualization.nim
  requiredBy: []
  timestamp: '2026-10-27 08:51:05+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/graph_visualization_test.nim
  - verify/graph/graph_visualization_test.nim
documentation_of: cplib/graph/graph_visualization.nim
layout: document
redirect_from:
- /library/cplib/graph/graph_visualization.nim
- /library/cplib/graph/graph_visualization.nim.html
title: cplib/graph/graph_visualization.nim
---
