import cplib/collections/avlset
import options
type RangeSet*[T] = ref object
    st* : AVLSortedMultiSet[(int,int,T)]
    default* : T

proc initRangeSet*[T](default:T):RangeSet[T]=
    return RangeSet[T](st:initAvlSortedMultiSet[(int,int,T)](@[(low(int),high(int),default)]),default:default)

proc update*[T](self:RangeSet[T],l,r:int,value:T)=
    #まず、[l,r)が完全に内包している区間について消去する
    var l = l
    var r = r
    while true:
        var x = self.st.ge((l,low(int),self.default))
        if x.isNone():
            break
        var (a,b,c) = x.get()
        if b <= r:
            discard self.st.excl((a,b,c))
        elif a < r:
            #区間の右で被っているような場合
            self.st.excl((a,b,c))
            if c == value:
                r = b
            else:
                self.st.incl((r,b,c))
            break
        else:
            if a == r and c == value:
                self.st.excl((a,b,c))
                r = b
            break
    var x = self.st.le((l,high(int),self.default))
    if x.issome():
        var (a,b,c) = x.get()
        if r < b:
            if c != value:
                self.st.excl((a,b,c))
                self.st.incl((a,l,c))
                self.st.incl((r,b,c))
            else:
                return
        elif l < b:
            if c != value:
                self.st.excl((a,b,c))
                self.st.incl((a,l,c))
            else:
                self.st.excl((a,b,c))
                l = a
        elif l == b:
            if c == value:
                self.st.excl((a,b,c))
                l = a
    self.st.incl((l,r,value))

proc get_segment*[T](self:RangeSet[T],x:int):(int,int,int)=
    #これ最大値区間が編集されているときにバグります
    self.st.le((x,high(int),self.default)).get()