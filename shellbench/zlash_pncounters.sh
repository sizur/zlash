
# shellbench/shellbench -c -s bash,zsh,ksh -w 3 -t 10 shellbench/zlash_pncounters.sh
# -----------------------------------------------------------------------------------
# name                                                     bash        zsh        ksh
# -----------------------------------------------------------------------------------
# [null loop]                                           355,494    848,646    892,502
# zlash_pncounters.sh: _zlsh_chk_pncounters                 328        409        669
# zlash_pncounters.sh: _zlsh_pncounter_incr              93,804    135,674    374,781
# -----------------------------------------------------------------------------------
# * count: number of executions per second

. src/zla.sh

#bench _zlsh_chk_pncounters
@begin
_zlsh_chk_pncounters
@end

#bench _zlsh_pncounter_incr
zlash_mk_pncounter C
@begin
_zlsh_pncounter_incr C
@end
