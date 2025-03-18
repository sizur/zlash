
# shellbench -c -s bash,zsh,ksh,dash -w 3 -t 10 dyn_var_arith.sh
# -----------------------------------------------------------------------------
# name                                    bash        zsh        ksh       dash
# -----------------------------------------------------------------------------
# [null loop]                          357,668    870,427    921,077    237,770
# dyn_var_arith.sh: A                   85,146    120,291    309,610    122,637
# dyn_var_arith.sh: B                  148,987    224,137    443,362    187,276
# dyn_var_arith.sh: C                  128,309    225,410    423,954    182,255
# dyn_var_arith.sh: D                  132,227    209,669    437,970      error
# dyn_var_arith.sh: E                  130,267    204,312    378,196    125,910
# dyn_var_arith.sh: F                  117,407    197,400    369,472      error
# -----------------------------------------------------------------------------
# * count: number of executions per second

obj_attr1=2
obj_attr2=3
key1=attr1
key2=attr2

#bench A
@begin
eval "val=\$((obj_$key1 + obj_$key2))" && [ "$val" -eq 5 ]
@end

#bench B
@begin
val=$(( obj_$key1 + obj_${key2} )) && [ "$val" -eq 5 ]
@end

#bench C
@begin
val="$(( obj_$key1 + obj_${key2} ))" && [ "$val" -eq 5 ]
@end

#bench D
@begin
val=$(( "obj_$key1" + "obj_$key2" )) && [ "$val" -eq 5 ]
@end

#bench E
@begin
obj=obj_ &&\
val=$(( $obj$key1 + $obj$key2 )) && [ "$val" -eq 5 ]
@end

#bench F
@begin
obj=obj_ &&\
val=$(( "$obj$key1" + "$obj$key2" )) && [ "$val" -eq 5 ]
@end
