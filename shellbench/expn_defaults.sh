# shellcheck disable=2218

# (for shell in bash dash; do printf %8s\ %s\\n $shell "$(brew info --json $shell |jq '.[]|.versions.stable' -r)"; done && printf %8s\ %s\\n zsh "$(ver=$(zsh --version) && echo "${ver#zsh }")" && for shell in /bin/ksh ksh93; do printf %8s\ %s\\n "$shell" "$(ver=$($shell --version 2>&1) ||:; echo "${ver#*"AT&T Research) "}")"; done)
#     bash 5.2.37
#     dash 0.5.12
#      zsh 5.9 (x86_64-apple-darwin24.0)
# /bin/ksh 93u+ 2012-08-01
#    ksh93 93u+m/1.0.10 2024-08-01
# shellbench -c -s bash,dash,zsh,/bin/ksh,ksh93 -w 2 -t 10 expn_defaults.sh
# ------------------------------------------------------------------------------
# name                             bash     dash       zsh   /bin/ksh      ksh93
# ------------------------------------------------------------------------------
# [null loop]                   358,303   233,201   874,914   880,629    881,091
# expn_defaults.sh: no default  190,819   219,256   177,212   884,877  1,079,692
# expn_defaults.sh: defaults    182,358   215,504   190,504   886,301  1,054,824
# ------------------------------------------------------------------------------
# * count: number of executions per second

a=a

#bench "no default"
f() { : "$1"; }
@begin
f "$a"
@end

#bench "defaults"
f() { : "${1-0}"; }
@begin
f "$a"
@end
