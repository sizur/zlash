# shellcheck disable=2016

# Zlash dev-env section dependencies. (stripped on release)
_zlsh__dev_load      \
    core_shell_quoting\
    || return 1

###############################################################################
#/ String Matching
#
#------------------------------------------------------------------------------
#, zlash_var_match_pat
_ZLSH_TOPIC_zlash_var_match_pat='is string by name matching a shell pattern?

The pattern cannot contain references to positional parameters, e.g `$#`, `$@`,
`$1`, `$2`, etc.... They can be quoted within the pattern to match them
literally, or assigned to non-positional parameters to reference them in the
pattern.
'
_ZLSH_USAGE_zlash_var_match_pat='Usage

zlash_var_match_pat var pat
'
_ZLSH_PARAMS_zlash_var_match_pat='Parameters

1. *var*
   : A name of a variable containing a string.
2. *pat*
   : A non-empty shell pattern as a string (should not contain non-literal
     references to positional parameters, e.g `$#`, `$@`, `$1`, `$2`, etc...).
' # TODO: Write an Examples doc section.
zlash_var_match_pat() {
    if  case $# in
            2)  _zlsh_str_is_var_exists "$1" &&\
                [      "${2:+x}"      ]      ;;
            *)  false; esac
    then _zlsh_var_match_pat "$1" "$2"
    else _zlsh_usage zlash_var_match_pat && return 64; fi; }
_zlsh_var_match_pat() {
    eval "case \$$1 in $2) return 0;; *) return 1; esac"; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_var_match_pat() {  # shellcheck disable=2088
    _zlsh_chk_var_match_pat_A='~/a bbcdd e'                    &&\
    _zlsh_chk_var_match_pat_B='~/a bb*dd e'                       \
    &&   zlash_var_match_pat _zlsh_chk_var_match_pat_A             \
                                '"$_zlsh_chk_var_match_pat_A"'      \
    && ! zlash_var_match_pat _zlsh_chk_var_match_pat_A               \
                                '"$_zlsh_chk_var_match_pat_B"'        \
    &&   zlash_var_match_pat _zlsh_chk_var_match_pat_A '\~/a\ bb*dd\ e'\
    &&   zlash_var_match_pat _zlsh_chk_var_match_pat_A '"~/a bb"*"dd e"'\
    && ! zlash_var_match_pat _zlsh_chk_var_match_pat_A '\~/a\ bb\*dd\ e' \
    &&   zlash_var_match_pat _zlsh_chk_var_match_pat_B '\~/a\ bb\*dd\ e'  \
    &&   zlash_var_match_pat _zlsh_chk_var_match_pat_B     '*"*"*'         \
    && ! zlash_var_match_pat _zlsh_chk_var_match_pat_B      '*f*'           \
    &&   zlash_var_match_pat _zlsh_chk_var_match_pat_B    '"~"*"*"*'         \
    && ! zlash_var_match_pat _zlsh_chk_var_match_pat_B   '"*~"*"*"*'          \
    &&   zlash_var_match_pat _zlsh_chk_var_match_pat_B     '*"*"*e'           \
    && ! zlash_var_match_pat _zlsh_chk_var_match_pat_B    '*"*"*"e*"'         \
    &&   zlash_var_match_pat _zlsh_chk_var_match_pat_B    '"~"*"*"*e'         \
    && ! zlash_var_match_pat _zlsh_chk_var_match_pat_B  '"~*"*"*"*"e*"'     &&\
    unset -v _zlsh_chk_var_match_pat_A _zlsh_chk_var_match_pat_B; }

#------------------------------------------------------------------------------
#, zlash_var_has_substr
_ZLSH_TOPIC_zlash_var_has_substr='does a string by name have a substring?

Succeeds if a variable contains a string.
'
_ZLSH_USAGE_zlash_var_has_substr='Usage

zlash_var_has_substr var substr
'
_ZLSH_PARAMS_zlash_var_has_substr='Parameters

1. *var*
   : A name of a variable containing a string.
2. *substr*
   : A non-empty substring to search for.
'
zlash_var_has_substr() {
    if  case $# in
            2)  _zlsh_str_is_var_exists "$1" &&\
                [      "${2:+x}"      ]      ;;
            *)  false; esac
    then _zlsh_var_has_substr "$1" "$2"
    else _zlsh_usage zlash_var_has_substr; return 64; fi; }
_zlsh_var_has_substr() {  # shellcheck disable=2154
    _zlsh_q "$2" && _zlsh_var_match_pat "$1" "*$zlash_q*"; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_var_has_substr() {
    _zlsh_chk_var_has_substr='$((1 + 1))'                && \
    zlash_var_has_substr _zlsh_chk_var_has_substr '$(('  &&  \
    zlash_var_has_substr _zlsh_chk_var_has_substr ' 1))' &&   \
    zlash_var_has_substr _zlsh_chk_var_has_substr ' + '  &&    \
    ! zlash_var_has_substr _zlsh_chk_var_has_substr 'a'  &&     \
    zlash_var_has_substr _zlsh_chk_var_has_substr '$((1 + 1))' &&\
    unset -v _zlsh_chk_var_has_substr; }

#------------------------------------------------------------------------------
#, zlash_var_has_var_substr
_ZLSH_TOPIC_zlash_var_has_var_substr='does a str by name have substr by name?

Succeeds if a variable contains a string that is a substring of another variable
content.
'
_ZLSH_USAGE_zlash_var_has_var_substr='Usage

zlash_var_has_substr var substr_var
'
_ZLSH_PARAMS_zlash_var_has_var_substr='Parameters

1. *var*
   : A name of a variable containing a string.
2. *substr_var*
   : A name of a variable containing a substring to look for.
'
zlash_var_has_var_substr() {
    if  case $# in
            2)  _zlsh_str_is_var_exists   "$1" &&\
                _zlsh_str_is_var_notempty "$2" ;;
            *)  false; esac
    then _zlsh_var_has_var_substr "$1" "$2"
    else _zlsh_usage zlash_var_has_var_substr; return 64; fi; }
_zlsh_var_has_var_substr() {  # shellcheck disable=2154
    eval _zlsh_var_has_substr "$1" "\$$2"; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_var_has_var_substr() {
    _zlsh_chk_var_has_var_substr='$((1 + 1))' &&\
    for _zlsh_chk_var_has_var_substr_ in '$((' ' 1))' ' + ' '$((1 + 1))'
    do zlash_var_has_var_substr\
        _zlsh_chk_var_has_var_substr _zlsh_chk_var_has_var_substr_ || return 1
    done && _zlsh_chk_var_has_var_substr_='a'                      &&\
    ! zlash_var_has_substr                                            \
        _zlsh_chk_var_has_var_substr _zlsh_chk_var_has_var_substr_ &&  \
    unset -v _zlsh_chk_var_has_var_substr _zlsh_chk_var_has_var_substr_; }

#------------------------------------------------------------------------------
#, zlash_var_has_pfx
_ZLSH_TOPIC_zlash_var_has_pfx='does a string by name have matching prefix?

Succeeds if a variable has a supplied prefix.
'
_ZLSH_USAGE_zlash_var_has_pfx='Usage

zlash_var_has_pfx var pfx
'
_ZLSH_PARAMS_zlash_var_has_pfx='Parameters

1. *var*
   : A name of a variable containing a string.
2. *pfx*
   : A non-empty prefix string to match.
'
zlash_var_has_pfx() {
    if  case $# in
            2)  _zlsh_str_is_var_exists "$1" &&\
                [      "${2:+x}"      ]      ;;
            *)  false; esac
    then _zlsh_var_has_pfx "$1" "$2"
    else _zlsh_usage zlash_var_has_pfx; return 64; fi; }
_zlsh_var_has_pfx() {
    _zlsh_q "$2" && _zlsh_var_match_pat "$1" "$zlash_q*"; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_var_has_pfx() {
    _zlsh_chk_var_has_pfx='a b'                      &&\
        zlash_var_has_pfx _zlsh_chk_var_has_pfx 'a ' && \
    !   zlash_var_has_pfx _zlsh_chk_var_has_pfx  ' ' &&  \
    unset -v _zlsh_chk_var_has_pfx; }

#------------------------------------------------------------------------------
#, zlash_var_has_sfx
_ZLSH_TOPIC_zlash_var_has_sfx='does a string by name have a matching suffix?

Succeeds if a variable has a supplied suffix.
'
_ZLSH_USAGE_zlash_var_has_sfx='Usage

zlash_var_has_sfx var sfx
'
_ZLSH_PARAMS_zlash_var_has_sfx='Parameters

1. *var*
   : A name of a variable containing a string.
2. *sfx*
   : A non-empty suffix string to match.
'
zlash_var_has_sfx() {
    if  case $# in
            2)  _zlsh_str_is_var_exists "$1" &&\
                [      "${2:+x}"      ]      ;;
            *)  false; esac
    then _zlsh_var_has_sfx "$1" "$2"
    else _zlsh_usage zlash_var_has_sfx; return 64; fi; }
_zlsh_var_has_sfx() {
    _zlsh_q "$2" && _zlsh_var_match_pat "$1" "*$zlash_q"; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_var_has_sfx() {
    _zlsh_chk_var_has_sfx='a b'                      &&\
        zlash_var_has_sfx _zlsh_chk_var_has_sfx ' b' && \
    !   zlash_var_has_sfx _zlsh_chk_var_has_sfx ' '  &&  \
    unset -v _zlsh_chk_var_has_sfx; }

#------------------------------------------------------------------------------
_zlsh_chk_core_str_matching() {
    # On failure:
    # - `_zlsh_chk_core_str_matching` will be set.
    for _zlsh_chk_core_str_matching\
    in  _zlsh_chk_var_match_pat   \
        _zlsh_chk_var_has_substr   \
        _zlsh_chk_var_has_var_substr\
        _zlsh_chk_var_has_pfx        \
        _zlsh_chk_var_has_sfx         \

    do $_zlsh_chk_core_str_matching || return 1
    done && unset -v _zlsh_chk_core_str_matching; }
