import cplib/math/longdouble
put(read_and_parse_longdouble())
put(read_and_parse_longdouble())
var ended = false
try: discard read_and_parse_longdouble()
except EOFError: ended = true
doAssert ended
