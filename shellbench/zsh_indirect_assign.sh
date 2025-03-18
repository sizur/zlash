
# $ shellbench -c -s zsh -w 3 -t 10 zsh_indirect_assign.sh
# -------------------------------------------------------------
# name                                                      zsh
# -------------------------------------------------------------
# [null loop]                                           831,460
# zsh_indirect_assign.sh: noop                          108,302
# zsh_indirect_assign.sh: val quoted                    103,475
# zsh_indirect_assign.sh: whole quoted                   99,321
# zsh_indirect_assign.sh: both quoted                    99,864
# zsh_indirect_assign.sh: unquoted                       98,082
# zsh_indirect_assign.sh: eval                           88,524
# zsh_indirect_assign.sh: big val quoted                    179
# zsh_indirect_assign.sh: big whole quoted                  178
# zsh_indirect_assign.sh: big both quoted                   192
# zsh_indirect_assign.sh: big unquoted                      166
# zsh_indirect_assign.sh: big eval                          254
# -------------------------------------------------------------
# * count: number of executions per second

var='"val "; words '
ref=res

def() {
    eval "
    fun() {
        local out="\$1" arg="\$2"
        $1
    }"
}

big=$var
i=0
while [[ $i -lt 15 ]]; do
    i=$((i+1))
    big=$big$big
done
if ! [[ ${#big} -eq 458752 ]]; then
    printf '%s\n' ${#big} >&2
    exit 1
fi

#bench noop
def ': "${(P)out}"'
@begin
res= && fun $ref var && [[ $var == "$var" ]]
@end

#bench "whole quoted"
def ': "${(P)out::=${(P)arg}}"'
@begin
res= && fun $ref var && [[ $res == "$var" ]]
@end

#bench "both quoted"
def ': "${(P)out::="${(P)arg}"}"'
@begin
res= && fun $ref var && [[ $res == "$var" ]]
@end

#bench unquoted
def ': ${(P)out::=${(P)arg}}'
@begin
res= && fun $ref var && [[ $res == "$var" ]]
@end

#bench "val quoted"
def ': ${(P)out::="${(P)arg}"}'
@begin
res= && fun $ref var && [[ $res == "$var" ]]
@end

#bench eval
def 'eval "$out=\$$arg"'
@begin
res= && fun $ref var && [[ $res == "$var" ]]
@end

#bench "big whole quoted"
def ': "${(P)out::=${(P)arg}}"'
@begin
res= && fun $ref big && [[ $res == "$big" ]]
@end

#bench "big both quoted"
def ': "${(P)out::="${(P)arg}"}"'
@begin
res= && fun $ref big && [[ $res == "$big" ]]
@end

#bench "big unquoted"
def ': ${(P)out::=${(P)arg}}'
@begin
res= && fun $ref big && [[ $res == "$big" ]]
@end

#bench "big val quoted"
def ': ${(P)out::="${(P)arg}"}'
@begin
res= && fun $ref big && [[ $res == "$big" ]]
@end

#bench "big eval"
def 'eval "$out=\$$arg"'
@begin
res= && fun $ref big && [[ $res == "$big" ]]
@end
