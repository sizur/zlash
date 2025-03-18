

var=val

def_f() {
    if (eval '[ "${.sh.version}" ]' 2>/dev/null); then  # Ksh93
        eval 'function f { typeset -n out="$1" && out=\$2; }'
    elif [ "${ZSH_VERSION+x}" ]; then                   # Zsh
        eval 'f() { local out="$1" && : ${(P)out::=\$2}; }'
    elif [ "${BASH_VERSION+x}" ]; then                  # Bash
        eval 'f() { local -n out="$1" && out=\$2; }'
    else                                                # Dash
        eval 'f() { local out="$1" && eval "$out=\$$2"; }'
    fi
}

#bench "direct assign"
f() { out=$var; }
@begin
f
@end

#bench "eval assign"
f() { eval "out=\$var"; }
@begin
f
@end

#bench "indirect eval assign"
ref=out
f() { eval "$ref=\$var"; }
@begin
f
@end

#bench "specific local indirect"
ref=out
def_f
@begin
f ref var
@end
