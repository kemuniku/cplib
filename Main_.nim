# verification-helper: PROBLEM https://judge.yosupo.jp/problem/jump_on_tree
{.checks: off.}
#https://kenkoooo.hatenablog.com/entry/2016/11/30/163533より引用
{.emit: "#include <bits/stdc++.h>".}
{.emit: """
using namespace std;
std::ostream &operator<<(std::ostream &dest, __int128_t value) {
  std::ostream::sentry s(dest);
  if (s) {
    __uint128_t tmp = value < 0 ? -value : value;
    char buffer[128];
    char *d = std::end(buffer);
    do {
      --d;
      *d = "0123456789"[tmp % 10];
      tmp /= 10;
    } while (tmp != 0);
    if (value < 0) {
      --d;
      *d = '-';
    }
    int len = std::end(buffer) - d;
    if (dest.rdbuf()->sputn(d, len) != len) {
      dest.setstate(std::ios_base::badbit);
    }
  }
  return dest;
}

__int128 parseint128(const std::string &s) {
  __int128 ret = 0;
  __int128 mul = 1;
  for (int i = 0; i < s.length(); i++) {
    if ('0' <= s[i] && s[i] <= '9') ret = 10 * ret + s[i] - '0';
    else mul = -1;
}
  return ret * mul;
}

const char ENDL = '\n';
""".}
import sequtils, strutils
type int128 {.importc: "__int128", nodecl.} = object
proc `+`(a, b: int128): int128{.importcpp: "((#)+(#))", nodecl.}
proc `*`(a, b: int128): int128{.importcpp: "((#)*(#))", nodecl.}
proc put(a: int128){.importcpp: "std::cout << (#) << ENDL", nodecl.}
proc parse(a: cstring): int128{.importcpp: "parseint128((#))".}
include cplib/tmpl/sheep
var t = ii()
for _ in 0..<t:
    var ab = stdin.readLine.split.mapIt(parse(cstring(it)))
    var c = ab[0] + ab[1]
    put(c)
