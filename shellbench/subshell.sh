
# $ for shell in bash dash; do printf %8s\ %s\\n $shell "$(brew info --json $shell |jq '.[]|.versions.stable' -r)"; done && printf %8s\ %s\\n zsh "$(ver=$(zsh --version) && echo "${ver#zsh }")" && for shell in /bin/ksh ksh93; do printf %8s\ %s\\n "$shell" "$(ver=$($shell --version 2>&1) ||:; echo "${ver#*"AT&T Research) "}")"; done
#     bash 5.2.37
#     dash 0.5.12
#      zsh 5.9 (x86_64-apple-darwin24.0)
# /bin/ksh 93u+ 2012-08-01
#    ksh93 93u+m/1.0.10 2024-08-01
# $ shellbench -c -s bash,dash,zsh,/bin/ksh,ksh93 -w 2 -t 10 subshell.sh
# -----------------------------------------------------------------------------
# name                         bash       dash        zsh   /bin/ksh      ksh93
# -----------------------------------------------------------------------------
# [null loop]               362,664    232,263    867,068    911,718    900,457
# subshell.sh:                1,134      1,606      1,158     68,629    165,482
# -----------------------------------------------------------------------------
# * count: number of executions per second

#bench
@begin
(: "${v=}")
@end
