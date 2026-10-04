let original: clongdouble = 1.0
let sum = original + 0.0000000000000000001
proc nativeSize(x: clongdouble): int =
    {.emit: "`result` = sizeof(`x`);".}
echo "Nim sizeof(clongdouble)=", sizeof(clongdouble)
echo "C sizeof(clongdouble argument)=", nativeSize(original)
echo "sum > original=", sum > original
