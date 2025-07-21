# shellcheck disable=2016

# Zlash dev-env section dependencies. (stripped on release)
_zlsh__dev_load   \
    core_validators\
    || return 1

###############################################################################
#/ Shell Quoting
#
#------------------------------------------------------------------------------
#, zlash_q
_ZLSH_TOPIC_zlash_q='single-quote a string for shell eval

Single-quote (`'\''`) a string to be reused by shell.

Used for disabling interpolation of the string in shell'\''s `eval`.
'
_ZLSH_USAGE_zlash_q='Usage

zlash_q str [out_vname]
'
_ZLSH_PARAMS_zlash_q='Parameters

1. *str*
   : String to single-quote.
2. *out_vname*
   : Optional variable name where the single-quoted string should be stored,
     instead of output to *STDOUT*.
'
zlash_q() {
    if  case $# in
            2) _zlsh_str_is_vname "$2";;
            1) true                   ;;
            *) false; esac
    then _zlsh_q "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_q"
        else printf '%s\n' "$zlash_q"; fi
    else _zlsh_usage zlash_q && return 64; fi; }
_zlsh_q() {
    _zlsh_q=$1 && _zlsh_q_H= && _zlsh_q_T= && zlash_q=\' && \
    while [ "${_zlsh_q:+x}" ]; do case $_zlsh_q in *"'"*)
                _zlsh_q_T=${_zlsh_q#*"'"}         &&\
                _zlsh_q_H=${_zlsh_q%"$_zlsh_q_T"} && \
                _zlsh_q=$_zlsh_q_T                &&  \
                zlash_q="$zlash_q$_zlsh_q_H\''"   || return 1;;
            *)  zlash_q=$zlash_q$_zlsh_q || return 1; break; esac
    done && zlash_q=$zlash_q\' &&\
    unset -v _zlsh_q _zlsh_q_H  _zlsh_q_T; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_q() {
    for _zlsh_chk_q in\
        '' \  \' 'a b' \$a \\\$a \\ \`zlash_q\` '$(`zlash_q`)' \
        \''$(zlash_q)'\' '$((1 + `zlash_q`))' "$_ZLSH_TOPIC_zlash_q"
    do  # shellcheck disable=2154
        zlash_q "$_zlsh_chk_q"      _zlsh_chk_q_Q  \
        &&       [ "$zlash_q" =   "$_zlsh_chk_q_Q" ]\
        && eval "[  $zlash_q  = \"\$_zlsh_chk_q\"  ]"\
        || return 1
    done && unset -v _zlsh_chk_q _zlsh_chk_q_Q; }

#------------------------------------------------------------------------------
#, zlash_var_q
_ZLSH_TOPIC_zlash_var_q='single-quote a variable string by name

Single-quote (`'\''`) a string to be reused by shell.

Used for disabling interpolation of the string in shell'\''s `eval`.
'
_ZLSH_USAGE_zlash_var_q='Usage

zlash_var_q var [out_vname]
'
_ZLSH_PARAMS_zlash_var_q='Parameters

1. *var*
   : a variable name containing a string to single-quote
2. *out_vname*
   : optional variable name where the single-quoted string should be
     stored, instead of output to *STDOUT*
'
zlash_var_q() {
    if  case $# in
            2)  _zlsh_str_is_var_exists "$1" &&\
                _zlsh_str_is_vname      "$2" ;;
            1)  _zlsh_str_is_var_exists "$1" ;;
            *)  false; esac
    then _zlsh_var_q "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_q"
        else printf '%s\n' "$zlash_q"; fi
    else _zlsh_usage zlash_var_q && return 64; fi; }
_zlsh_var_q() { eval "_zlsh_q \"\$$1\""; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_var_q() {  # shellcheck disable=2154
    _zlsh_chk_var_q="what's up?"                  &&\
    zlash_var_q _zlsh_chk_var_q _zlsh_chk_var_q_Q && \
    [ "$zlash_q" = "$_zlsh_chk_var_q_Q" ]         &&  \
    [ "$zlash_q" = "'what'\\''s up?'"   ]         &&   \
    unset -v _zlsh_chk_var_q _zlsh_chk_var_q_Q; }

#------------------------------------------------------------------------------
# NOTE: About `zlash_qq``
#
#   `zlash_qq`, as a helper for dynamic interpolation by `eval` should not be
#   implemented.
#
#   INSTEAD: a concatenation should be utilized, or more advanced templating.
#
#   The core issue is escape handling, i.e: how `a\$b` should be handled:
#
#   - If `\` is to be escaped, then there would be no way for user to escape
#     interpolation without introducing yet another, different escaping rule.
#     Every dollar-sign (`$`) and backtick (`` ` ``) would be interpreted for
#     interpolation, always.
#
#   - If `\` is not to be escaped, letting user handle escaping, then the
#     following vulnerability would arrise: `zlash_qq '"\" date # \'`,
#     where `eval "V=$zlash_q"` is equivalent to `eval 'V="\"\\" date # \"'`.
#
#   Conclusion: The additional complexity in correct implementation and in user
#     cognitive load make `zlash_qq` unfit for Zlash.

#------------------------------------------------------------------------------
_zlsh_chk_core_shell_quoting() {
    # On failure:
    # - `_zlsh_chk_core_shell_quoting` will be set.
    for _zlsh_chk_core_shell_quoting\
    in  _zlsh_chk_q   \
        _zlsh_chk_var_q\

    do  eval "$_zlsh_chk_core_shell_quoting" || return 1
    done && unset -v _zlsh_chk_core_shell_quoting; }
