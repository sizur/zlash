# shellcheck disable=2034,2317,3044

# $ (for shell in bash dash; do printf %8s\ %s\\n $shell "$(brew info --json $shell |jq '.[]|.versions.stable' -r)"; done && printf %8s\ %s\\n zsh "$(ver=$(zsh --version) && echo "${ver#zsh }")" && for shell in /bin/ksh ksh93; do printf %8s\ %s\\n "$shell" "$(ver=$($shell --version 2>&1) ||:; echo "${ver#*"AT&T Research) "}")"; done)
#     bash 5.2.37
#     dash 0.5.12
#      zsh 5.9 (x86_64-apple-darwin24.0)
# /bin/ksh 93u+ 2012-08-01
#    ksh93 93u+m/1.0.10 2024-08-01
# $ shellbench -c -s bash,dash,zsh,/bin/ksh,ksh93 -w 2 -t 10 rational_rationaale.sh
# -----------------------------------------------------------------------------
# name                         bash       dash        zsh   /bin/ksh      ksh93
# -----------------------------------------------------------------------------
# [null loop]               358,562    230,056    843,405    899,563    883,990
# bc 6.5.0                      176        230     74,231    241,014    280,727
# bc 1.08.1 (brew)              171        200     70,849    241,664    280,625
# awk 20200816                  276        320     69,647    220,686    264,179
#    ^ -v                       195        220     71,582    243,582    255,594
# awk 20250116 (brew)           274        298     76,333    246,174    282,452
#    ^ -v                       271        297     77,427    248,673    283,690
# gawk 6.3.0)                    75         78     77,998    243,264    296,694
#     ^ -v                       74         79     77,102    252,371    286,600
# mawk 20250131                 250        279     78,116    247,704    291,018
#     ^ -v                      243        275     77,866    250,306    286,905
# goawk v1.29.1                 145        175     78,705    251,295    280,403
#      ^ -v                     128        143     72,007    240,873    276,336
# -----------------------------------------------------------------------------
# * countnumber of executions per second
#
# (Zsh and Ksh benches use shell-native double arithmetic, so a single
# obervation per shell would suffice. Extra observations of them are just
# just that -- extra.)
#
###############################################################################
#/ Rational Rationale
#
#  Measuring feasibility of Zlash using external tooling for floating arithmetic
#  for shells that do not support it, the dominant factor is tool's startup
#  time.
#
#  The consistent near three orders of magnitude difference strongly guides
#  toward integer-based zlash_rati implementation.
#
#  Secondary observation:
#      Variance is a bit large for what should be identical across Zsh, and more
#      so across Ksh, runs (per shell).
#

def_div() {
    if (eval '[ "${.sh.version}" ]' 2>/dev/null); then             # Ksh93
        div() { typeset -lE17 a="$1" b="$2" && got=$((a/b)); }
    elif [ "${ZSH_VERSION:+x}" ]; then                             # Zsh
        div() { typeset -E17 a="$1" b="$2" && got=$((a/b)); }
    else case $1 in                                                # Bash, Dash
         "bc") div() { got=$(
              echo 'scale=17; x='"$1/$2"'; if (x<1) print "0"; x' | $bc -l); };;
         "awk") div() { got=$(
              $awk 'BEGIN { printf "%.17f\n", '"$1/$2"' }'); };;
         "awk-v") div() { got=$(
              $awk -v a="$1" -v b="$2" 'BEGIN { printf "%.17f\n", a/b }'); };;
         esac; fi; }

#bench "bc $(cmd=bc; $cmd --version | head -n 1 | awk '{print $NF}')"
bc="bc" && def_div bc
@begin
div 1 3 && case $got in "0.3333333333"*) true;; *) false; esac
@end

#bench "bc $(cmd=$(brew --prefix bc)/bin/bc; $cmd --version | head -n 1 | awk '{print $NF}') (brew)"
bc="$(brew --prefix bc)/bin/bc" && def_div bc
@begin
div 1 3 && case $got in "0.3333333333"*) true;; *) false; esac
@end

#bench "awk $(cmd=/usr/bin/awk; $cmd --version | head -n 1 | awk '{print $NF}')"
awk="/usr/bin/awk" && def_div awk
@begin
div 1 3 && case $got in "0.3333333333"*) true;; *) false; esac
@end

#bench "   ^ -v"
awk="awk" && def_div awk-v
@begin
div 1 3 && case $got in "0.3333333333"*) true;; *) false; esac
@end

#bench "awk $(cmd=$(brew --prefix awk)/bin/awk; $cmd --version | head -n 1 | awk '{print $NF}') (brew)"
awk="$(brew --prefix awk)/bin/awk" && def_div awk
@begin
div 1 3 && case $got in "0.3333333333"*) true;; *) false; esac
@end

#bench "   ^ -v"
awk="$(brew --prefix awk)/bin/awk" && def_div awk-v
@begin
div 1 3 && case $got in "0.3333333333"*) true;; *) false; esac
@end

#bench "gawk $(cmd=gawk; $cmd --version | head -n 1 | awk '{print $NF}')"
awk="gawk" && def_div awk
@begin
div 1 3 && case $got in "0.3333333333"*) true;; *) false; esac
@end

#bench "    ^ -v"
awk="gawk" && def_div awk-v
@begin
div 1 3 && case $got in "0.3333333333"*) true;; *) false; esac
@end

#bench "mawk $(cmd=mawk; $cmd --version | head -n 1 | awk '{print $NF}')"
awk="mawk" && def_div awk
@begin
div 1 3 && case $got in "0.3333333333"*) true;; *) false; esac
@end

#bench "    ^ -v"
awk="mawk" && def_div awk-v
@begin
div 1 3 && case $got in "0.3333333333"*) true;; *) false; esac
@end

#bench "goawk $(cmd=goawk; $cmd --version | head -n 1 | awk '{print $NF}')"
awk="goawk" && def_div awk
@begin
div 1 3 && case $got in "0.3333333333"*) true;; *) false; esac
@end

#bench "     ^ -v"
awk="goawk" && def_div awk-v
@begin
div 1 3 && case $got in "0.3333333333"*) true;; *) false; esac
@end
