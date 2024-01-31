# verification-helper: PROBLEM https://judge.yosupo.jp/problem/aplusb
import strscans
import cplib/tmpl/citrus
include cplib/tmpl/qcfium

var a, b: int
discard stdin.readLine.scanf("$i $i", a, b)
echo a + b
