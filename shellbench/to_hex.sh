
# -----------------------------------------------------------------------------
# name                                     zsh      ksh93       bash       dash
# -----------------------------------------------------------------------------
# to_hex.sh: small printf %x             1,125     99,697      1,068      1,629
# to_hex.sh: small hex_one_eval         44,314    115,099     30,655     33,296
# to_hex.sh: small hex_case             49,159    132,622     33,329     40,302
# to_hex.sh: large printf %x             1,178     91,824      1,069      1,649
# to_hex.sh: large hex_one_eval          9,718     18,840      6,697      6,956
# to_hex.sh: large hex_case              9,981     20,990      6,338      6,435
# to_hex.sh: incrg printf %x             1,157     90,444      1,069      1,690
# to_hex.sh: incrg hex_one_eval         28,242     53,272     19,482     21,052
# to_hex.sh: incrg hex_case             30,548     61,797     20,476     23,897
# -----------------------------------------------------------------------------

small=31
small_hex=1f
large=9182379272246533902
large_hex=7f6e5d4c3b2a1f0e

HEX_0=0;  HEX_1=1;  HEX_2=2;  HEX_3=3;  HEX_4=4;  HEX_5=5;  HEX_6=6
HEX_7=7;  HEX_8=8;  HEX_9=9;  HEX_10=a; HEX_11=b; HEX_12=c; HEX_13=d
HEX_14=e; HEX_15=f

hex_one_eval() {
    hex=''  &&\
    hex_=$1 || return 1
    while [ "$hex_" != 0 ]; do
        hex=\$HEX_$((hex_%16))$hex\
            && hex_=$((hex_/16))\
                || return 1
    done
    eval "hex=$hex" || return 1
}

hex_case() {
    hex='' && hex_=$1 || return 1
    while [ "$hex_" != 0 ]; do
        case $((hex_%16)) in
            ?) hex=$((hex_%16))$hex;;
            10) hex=a$hex;;
            11) hex=b$hex;;
            12) hex=c$hex;;
            13) hex=d$hex;;
            14) hex=e$hex;;
            15) hex=f$hex;;
        esac &&\
        hex_=$((hex_/16)) || return 1
    done
}

#bench "small printf %x"
hex=
@begin
hex=$(printf '%x\n' "$small")
# [ "$hex" = "$small_hex" ]
@end

#bench "small hex_one_eval"
hex=
@begin
hex_one_eval "$small"
# [ "$hex" = "$small_hex" ]
@end

#bench "small hex_case"
hex=
@begin
hex_case "$small"
# [ "$hex" = "$small_hex" ]
@end

#bench "large printf %x"
hex=
@begin
hex=$(printf '%x\n' "$large")
# [ "$hex" = "$large_hex" ]
@end

#bench "large hex_one_eval"
hex=
@begin
hex_one_eval "$large"
# [ "$hex" = "$large_hex" ]
@end

#bench "large hex_case"
hex=
@begin
hex_case "$large"
# [ "$hex" = "$large_hex" ]
@end

#bench "incrg printf %x"
i=0
@begin
i=$((i+1)) &&\
hex=$(printf '%x\n' "$i")
@end

#bench "incrg hex_one_eval"
i=0
@begin
i=$((i+1)) &&\
hex_one_eval "$i"
@end

#bench "incrg hex_case"
i=0
@begin
i=$((i+1)) &&\
hex_case "$i"
@end
