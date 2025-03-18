
# shellbench -c -s zsh,ksh93,bash,dash overhead.unset.sh
# -----------------------------------------------------------------------------
# name                                     zsh      ksh93       bash       dash
# -----------------------------------------------------------------------------
# [null loop]                          879,865    889,600    364,412    234,892
# overhead.unset.sh: assign null     6,563,002 16,646,533  1,322,723    521,033
# overhead.unset.sh: ^, unset -v       349,940  3,230,046    306,319    211,703
# overhead.unset.sh: define noop     3,189,105  6,322,211  1,153,205  4,936,562
# overhead.unset.sh: ^, unset -f       371,686  1,361,949    289,849    430,941
# overhead.unset.sh: function call     213,118    965,062    248,670    242,402
# overhead.unset.sh: local assign      134,622    579,554    110,312    122,137
# overhead.unset.sh: local shadow      132,221    562,672    109,544    115,828
# -----------------------------------------------------------------------------
# * count: number of executions per second
#
#
# Differentials in microseconds (µs):
# -----------------------------------------------------------------------------
#          (1000000/n)                     zsh      ksh93       bash       dash
# -----------------------------------------------------------------------------
#     (unset -v)-(assign null)             2.7       0.25        2.5        2.8
#     (unset -f)-(define noop)             2.4       0.58        2.6        2.1
# (local assign)-(function call)           2.7       0.69        5.0        4.0
# (local shadow)-(function call)           2.8       0.74        5.1        4.5
# -----------------------------------------------------------------------------
#
# NOTE: I suspect Ksh93 benchmarking maybe affected by too eager
#       overoptimization in Ksh93 affecting timing of signal processing.
#

#bench "assign null"
@begin
var=
@end

#bench "^, unset -v"
@begin
var= && unset -v var
@end

#bench "define noop"
@begin
fun() { var=; }
@end

#bench "^, unset -f"
@begin
fun() { var=; } && unset -f fun
@end

#bench "function call"
fun() { return 0; }
@begin
fun
@end

#bench "local assign"
if (eval '[ "${.sh.version}" ]' 2>/dev/null)
then eval 'function fun { typeset var && var=; }'
else eval 'fun() { local var && var= && return 0; }'
fi
@begin
fun
@end

#bench "local shadow"
if (eval '[ "${.sh.version}" ]' 2>/dev/null)
then eval 'function fun { typeset var && var=; }'
else eval 'fun() { local var && var= && return 0; }'
fi
var=var
@begin
fun
@end
