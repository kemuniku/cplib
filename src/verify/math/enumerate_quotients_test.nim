# verification-helper: PROBLEM https://judge.yosupo.jp/problem/enumerate_quotients
import cplib/math/enumerate_quotients
import strutils

let n = stdin.readLine.parseInt
let quotients = enumerateQuotients(n)
echo quotients.len
echo quotients.join(" ")
