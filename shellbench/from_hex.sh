
# $ shellbench -c -s bash,zsh,ksh,dash -w 3 -t 10 from_hex.sh
# -----------------------------------------------------------------------------
# name                                    bash        zsh        ksh       dash
# -----------------------------------------------------------------------------
# [null loop]                          365,994    887,005    858,269    224,709
# from_hex.sh: lo2hi                     3,624      5,573      2,814      4,062
# from_hex.sh: lo2hi_i                   3,349      6,597      7,408      3,988
# from_hex.sh: hi2lo                     2,363      3,906      2,997      2,669
# from_hex.sh: hi2lo_i                   2,333      4,165      4,882      2,554
# -----------------------------------------------------------------------------
# * count: number of executions per second

lo2hi() {
    dec=0    &&\
    input=$1 && \
    place=1  &&  \
    while [ "${input:+x}" ]; do
        case $input in
            *0) :;;
            *1) dec=$((    place + dec));;
            *2) dec=$((2 * place + dec));;
            *3) dec=$((3 * place + dec));;
            *4) dec=$((4 * place + dec));;
            *5) dec=$((5 * place + dec));;
            *6) dec=$((6 * place + dec));;
            *7) dec=$((7 * place + dec));;
            *8) dec=$((8 * place + dec));;
            *9) dec=$((9 * place + dec));;
            *a|*A) dec=$((10*place+dec));;
            *b|*B) dec=$((11*place+dec));;
            *c|*C) dec=$((12*place+dec));;
            *d|*D) dec=$((13*place+dec));;
            *e|*E) dec=$((14*place+dec));;
            *f|*F) dec=$((15*place+dec));;
        esac &&\
        place=$((16 * place)) &&\
        input=${input%?} || return 1
    done
}

lo2hi_i() {
    dec=0    &&\
    input=$1 && \
    place=1  &&  \
    while [ "${input:+x}" ]; do
        tmp=${input%?}      &&\
        ch=${input##"$tmp"} && \
        input=$tmp          &&  \
        case $ch in
            a|A) dec=$((10 * place + dec));;
            b|B) dec=$((11 * place + dec));;
            c|C) dec=$((12 * place + dec));;
            d|D) dec=$((13 * place + dec));;
            e|E) dec=$((14 * place + dec));;
            f|F) dec=$((15 * place + dec));;
            *)   dec=$((ch * place + dec));;
        esac &&\
        place=$((16 * place)) || return 1
    done
}

hi2lo() {
    dec=0     &&\
    input=$1  && \
    place=1   &&  \
    len=${#1} &&   \
    i=1 &&\
    while [ "$i" -lt "$len" ]; do
        place=$((place * 16)) &&\
        i=$((i + 1))          || break
    done && [ "$i" -eq "$len" ] &&\
    while [ "$i" -gt 0 ]; do
        case $input in
            0*) :;;
            1*) dec=$((    place + dec));;
            2*) dec=$((2 * place + dec));;
            3*) dec=$((3 * place + dec));;
            4*) dec=$((4 * place + dec));;
            5*) dec=$((5 * place + dec));;
            6*) dec=$((6 * place + dec));;
            7*) dec=$((7 * place + dec));;
            8*) dec=$((8 * place + dec));;
            9*) dec=$((9 * place + dec));;
            a*|A*) dec=$((10*place+dec));;
            b*|B*) dec=$((11*place+dec));;
            c*|C*) dec=$((12*place+dec));;
            d*|D*) dec=$((13*place+dec));;
            e*|E*) dec=$((14*place+dec));;
            f*|F*) dec=$((15*place+dec));;
        esac &&\
        place=$((place / 16)) &&\
        i=$((i - 1))          && \
        input=${input#?} || return 1
    done
}

# NOTE: Ksh93 bug! longer than 3 repeated characters will fail to match as a
#       suffix.
hi2lo_i() {
    dec=0     &&\
    input=$1  && \
    place=1   &&  \
    len=${#1} &&   \
    i=1 &&\
    while [ "$i" -lt "$len" ]; do
        place=$((place * 16)) &&\
        i=$((i + 1))          || break
    done && [ "$i" -eq "$len" ] &&\
    while [ "${input:+x}" ]; do
        tmp=${input#?}     &&\
        ch=${input%"$tmp"} && \
        input=$tmp         &&  \
        case $ch in
            a|A) dec=$((10 * place + dec));;
            b|B) dec=$((11 * place + dec));;
            c|C) dec=$((12 * place + dec));;
            d|D) dec=$((13 * place + dec));;
            e|E) dec=$((14 * place + dec));;
            f|F) dec=$((15 * place + dec));;
            *)   dec=$((ch * place + dec));;
        esac &&\
        place=$((place / 16)) || return 1
    done
}


#bench "lo2hi"
@begin
lo2hi 7fffffffffffffff
@end

#bench "lo2hi_i"
@begin
lo2hi_i 7fffffffffffffff
@end

#bench "hi2lo"
@begin
hi2lo 7fffffffffffffff
@end

#bench "hi2lo_i"
@begin
hi2lo_i 7fffffffffffffff
@end
