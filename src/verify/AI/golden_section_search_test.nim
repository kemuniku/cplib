import std/math
import cplib/utils/golden_section_search

block integerMinimum:
    assert goldenSectionSearch(-100, 100,
        proc(x: int): int = (x - 7) * (x - 7)) == 7

block integerPlateauUsesLeftmostPoint:
    assert goldenSectionSearch(0, 20,
        proc(x: int): int = max(0, abs(x - 10) - 2)) == 8

block integerSmallAndSingletonIntervals:
    assert goldenSectionSearch(2, 5, proc(x: int): int = -x) == 5
    assert goldenSectionSearch(4, 4, proc(x: int): int = x) == 4

block floatingPointMinimum:
    let x = goldenSectionSearch(-10.0, 20.0,
        proc(x: float64): float64 = (x - PI) * (x - PI))
    assert abs(x - PI) < 1e-8

block float32IsSupported:
    let x = goldenSectionSearch(0'f32, 5'f32,
        proc(x: float32): float32 = (x - 1.5'f32) * (x - 1.5'f32),
        1e-5'f32)
    assert abs(x - 1.5'f32) < 1e-3'f32

echo "ok"
