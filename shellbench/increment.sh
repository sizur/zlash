

# $ shellbench -c -s bash,zsh,ksh,dash increment.sh
# -----------------------------------------------------------------------------
# name                                    bash        zsh   /bin/ksh       dash
# -----------------------------------------------------------------------------
# [null loop]                          365,980    882,823    897,023    236,963
# increment.sh: call                   156,228    197,799    591,958    250,810
# increment.sh: : ""                   129,390    136,425    544,963    159,463
# increment.sh: i=$((i+1))             115,293    181,218    358,522    158,815
# increment.sh: : $((i=i+1))           110,499    120,349    307,806    148,438
# increment.sh: : $((i+=1))            110,579    131,278    314,381    155,767
# increment.sh: int i=$((i+1))         104,379    170,700    365,217      error
# increment.sh: int : $((i=i+1))        99,228    125,359    334,917      error
# increment.sh: int : $((i+=1))         99,941    127,061    349,030      error
# -----------------------------------------------------------------------------
# * count: number of executions per second

# Differential timings in microseconds:
# -----------------------------------------------------------------------------
#              1000000/n                     bash       zsh       ksh      dash
# -----------------------------------------------------------------------------
#       ( i=$((i+1)) ) - ( call )            2.3        0.46      1.1      2.3
#     ( : $((i=i+1)) ) - ( : "" )            1.3        0.98      1.4      0.47
#     ( :  $((i+=1)) ) - ( : "" )            1.3        0.29      1.3      0.15
#     ( : $((i=i+1)) ) - ( call )            2.7        3.3       1.6      2.8
#     ( :  $((i+=1)) ) - ( call )            2.6        2.6       1.5      2.4
# ( int   i=$((i+1)) ) - ( call )            3.2        0.80      1.0      NaN
# ( int : $((i=i+1)) ) - ( : "" )            2.3        0.65      1.2      NaN
# ( int :  $((i+=1)) ) - ( : "" )            2.3        0.54      1.0      NaN
# ( int : $((i=i+1)) ) - ( call )            3.7        2.9       1.3      NaN
# ( int :  $((i+=1)) ) - ( call )            3.6        2.8       1.2      NaN
# -----------------------------------------------------------------------------
# NOTE: Regarding subtractions:
#   - ( call ): Complete increment timing.
#   - ( : "" ): Increment timing when piggybacking as a part of another
#     expansion.

# This function is a template for defining an incrementing function 'func' based
# on shell type.
#
# Parameters:
#  - $1: Varies variable type between plain and (if shell supports it) numeric.
#  - $2: Varies incrementing method.
#
def_func() {
    if (eval '[ "${.sh.version}" ]' 2>/dev/null); then  # Ksh93
        eval "function func { typeset $1; $2 }"
    elif [ "${ZSH_VERSION+x}" ]; then                   # Zsh
        eval "func() { typeset $1; $2 }"
    elif [ "${BASH_VERSION+x}" ]; then                  # Bash
        eval "func() { declare $1; $2 }"
    else                                                # Dash
        eval "func() { $1; $2 }"
    fi
}

# This measures the baseline function call (that would increment) without
# incrementing.
#
#bench call
def_func i=0 ''
@begin
func
@end

# Same as above, with additional noop expansion to measure baseline for
# increments that can piggyback as part of some other expansion.
#
#bench ': ""'
def_func i=0 ': "";'
@begin
func
@end

# Shell assignment of arithmetic expression adding one.
#
#bench 'i=$((i+1))'
# shellcheck disable=SC2016
def_func i=0 'i=$((i+1));'
@begin
func
@end

# Expansion of arithmetic expression assigning addition of one.
#
#bench ': $((i=i+1))'
# shellcheck disable=SC2016
def_func i=0 ': $((i=i+1));'
@begin
func
@end

# Expansion of arithmetic expression using assigning addition operator (+=).
#
#bench ': $((i+=1))'
# shellcheck disable=SC2016
def_func i=0 ': $((i+=1));'
@begin
func
@end

# The following variants are the same as above, except they use numeric type
# when defining variable to be incremented.

#bench 'int i=$((i+1))'
# shellcheck disable=SC2016
def_func '-i i=0' 'i=$((i+1));'
@begin
func
@end

#bench 'int : $((i=i+1))'
# shellcheck disable=SC2016
def_func '-i i=0' ': $((i=i+1));'
@begin
func
@end

#bench 'int : $((i+=1))'
# shellcheck disable=SC2016
def_func '-i i=0' ': $((i+=1));'
@begin
func
@end
