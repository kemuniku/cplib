# verification-helper: PROBLEM https://atcoder.jp/contests/abc337/tasks/abc337_b
import cplib/collections/avlset
import sequtils, strutils
var S = stdin.readLine()
var st = initAvlSortedMultiset(S.toseq())
if st.toseq().join() == S:
    echo "Yes"
else:
    echo "No"
