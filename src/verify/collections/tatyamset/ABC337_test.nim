# verification-helper: PROBLEM https://atcoder.jp/contests/abc294/tasks/abc294_d
import cplib/collections/tatyamset
import sequtils,strutils
var S = stdin.readLine()
var st = initSortedMultiset(S.toseq())
if st.toseq().join() == S:
    echo "Yes"
else:
    echo "No"