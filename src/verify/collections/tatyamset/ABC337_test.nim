# verification-helper: PROBLEM https://atcoder.jp/contests/abc337/tasks/abc337_b
import cplib/collections/tatyamset
import sequtils, strutils
var S = stdin.readLine()
var st = initSortedMultiset(S.toseq())
if st.toseq().join() == S:
    echo "Yes"
else:
    echo "No"
