
# $ (for shell in bash dash; do printf %8s\ %s\\n $shell "$(brew info --json $shell |jq '.[]|.versions.stable' -r)"; done && printf %8s\ %s\\n zsh "$(ver=$(zsh --version) && echo "${ver#zsh }")" && for shell in /bin/ksh ksh93; do printf %8s\ %s\\n "$shell" "$(ver=$($shell --version 2>&1) ||:; echo "${ver#*"AT&T Research) "}")"; done)
#     bash 5.2.37
#     dash 0.5.12
#      zsh 5.9 (x86_64-apple-darwin24.0)
# /bin/ksh 93u+ 2012-08-01
#    ksh93 93u+m/1.0.10 2024-08-01
# $ shellbench -c -s bash,dash,zsh,/bin/ksh,ksh93 -w 2 -t 10 eval.sh
# -----------------------------------------------------------------------------
# name                         bash       dash        zsh   /bin/ksh      ksh93
# -----------------------------------------------------------------------------
# [null loop]               358,158    230,803    881,159    911,978    891,018
# eval.sh:                  189,538    229,313    190,202    559,806    649,564
# -----------------------------------------------------------------------------
# * count: number of executions per second

#bench
@begin
eval ": ${v=}"
@end
