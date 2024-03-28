when not declared CPLIB_MATRIX_MATRIX:
    const CPLIB_MATRIX_MATRIX* = 1
    type Matrix*[T] = object
        arr: seq[seq[T]]
