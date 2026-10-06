import times, strformat
import cplib/geometry/base
import cplib/geometry/exact_circle
import cplib/math/fractions
let integer = initExactCircle(initPoint(0, 0), initPoint(100, 0), initPoint(0, 100))
let rational = initExactCircle(initPoint(initFraction(1, 3), initFraction(2, 7)), 100)
var sum = 0
var start = cpuTime()
for i in 0..<100000:
    sum += ord(integer.contains(initPoint(i mod 201 - 100, (i div 201) mod 201 - 100)))
echo &"int: 100000 contains, CPU {cpuTime()-start:.3f}s, checksum {sum}"
start = cpuTime()
sum = 0
for i in 0..<10000:
    sum += ord(rational.contains(initPoint(initFraction(i mod 201 - 100, 3), initFraction((i div 201) mod 201 - 100, 7))))
echo &"Fraction[int]: 10000 contains, CPU {cpuTime()-start:.3f}s, checksum {sum}"
