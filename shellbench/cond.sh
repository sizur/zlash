
# $ shellbench -c -s bash,zsh,ksh,dash -w 3 -t 10 cond.sh
# -----------------------------------------------------------------------------
# name                                    bash        zsh        ksh       dash
# -----------------------------------------------------------------------------
# [null loop]                          352,086    846,385    919,528    233,793
# cond.sh: base                         22,524     30,188     97,179     28,290
# cond.sh: v1                           18,041     22,288     83,144     23,351
# cond.sh: v2                           18,214     22,309     82,647     22,783
# cond.sh: v3                           19,839     24,304     91,804     26,276
# -----------------------------------------------------------------------------
# * count: number of executions per second

t=t
bool() { chk=$((chk+1)) && [ "${1-}" = 't' ]; }

#bench "base"
base() { bool $t && bool $t && bool $t && bool $t; }
@begin
chk=0 && base $t $t && [ "$chk" -eq 4 ]
@end

#bench v1
v1() {
    if { [ $# -ne 1 ] || ! bool $t || ! bool $t || ! bool $t;              }\
    && { [ $# -ne 2 ] || ! bool $t || ! bool $t || ! bool $t || ! bool $t; }
    then return 1
    else return 0
    fi
}
@begin
chk=0 && v1 $t $t && [ "$chk" -eq 4 ]
@end

#bench v2
v2() {
    if { [ $# -eq 1 ] && bool $t && bool $t && bool $t;            }\
    || { [ $# -eq 2 ] && bool $t && bool $t && bool $t && bool $t; }
    then return 0
    else return 1
    fi
}
@begin
chk=0 && v2 $t $t && [ "$chk" -eq 4 ]
@end

#bench v3
v3() {
    if  case $# in
            1) bool $t && \
               bool $t &&  \
               bool $t ;;   \
            2) bool $t &&\
               bool $t && \
               bool $t &&  \
               bool $t ;;   \
            *) false
        esac
    then return 0
    else return 1
    fi
}
@begin
chk=0 && v3 $t $t && [ "$chk" -eq 4 ]
@end
