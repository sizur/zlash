
# Zlash dev-env section dependencies. (stripped on release)
_zlsh__dev_load   \
    core_pncounters\
    || return 1

###############################################################################
#/ Lower-Level StrStack Implementation
#
_ZLSH_DOC_TOPIC_about_strstacks='about strstacks

Strstacks are not object-aware. Their elements are plain strings only, and their
names are plain variable identifier suffixes. Strstacks should not be used to
build nested structures directly, as `zlash_strstack_repr` will represent
references nominally.

' # TODO
_zlsh_chk_strstacks() {
    _zlsh_chk_strstacks_metrics_helper() {
        zlash_metric_strstacks_gauge _zlsh_chk_strstacks_G2 &&
        zlash_metric_strstacks_created_counter _zlsh_chk_strstacks_C2 &&
        [ "$zlash_metric_strstacks_gauge" -eq "$_zlsh_chk_strstacks_G2" ] &&
        [ "$zlash_metric_strstacks_gauge" -eq $((_zlsh_chk_strstacks_G + $1)) ] &&
        [ "$zlash_metric_strstacks_created_counter" -eq "$_zlsh_chk_strstacks_C2" ] &&
        [ "$zlash_metric_strstacks_created_counter" -eq $((_zlsh_chk_strstacks_C + $2)) ]
    } &&\

    zlash_metric_strstacks_gauge _zlsh_chk_strstacks_G &&\
    zlash_metric_strstacks_created_counter _zlsh_chk_strstacks_C &&\

    _zlsh_chk_strstacks_metrics_helper 0 0 &&\
    ! zlash_is_strstack _zlsh_chk_strstacks &&\
    zlash_mk_strstack _zlsh_chk_strstacks &&\
    zlash_is_strstack _zlsh_chk_strstacks &&\
    _zlsh_chk_strstacks_metrics_helper 1 1 &&\

    zlash_strstack_len _zlsh_chk_strstacks && [ "$zlash_strstack_len" -eq 0 ] &&\
    zlash_strstack_push _zlsh_chk_strstacks "first" &&\
    zlash_strstack_len _zlsh_chk_strstacks && [ "$zlash_strstack_len" -eq 1 ] &&\
    zlash_strstack_peek _zlsh_chk_strstacks && [ "$zlash_strstack_peek" = "first" ] &&\

    zlash_strstack_push _zlsh_chk_strstacks "second" "third" &&\
    zlash_strstack_len _zlsh_chk_strstacks && [ "$zlash_strstack_len" -eq 3 ] &&\
    zlash_strstack_peek _zlsh_chk_strstacks && [ "$zlash_strstack_peek" = "third" ] &&\

    zlash_strstack_pop _zlsh_chk_strstacks && [ "$zlash_strstack_pop" = "third" ] &&\
    zlash_strstack_len _zlsh_chk_strstacks && [ "$zlash_strstack_len" -eq 2 ] &&\

    zlash_strstack_at _zlsh_chk_strstacks 0 && [ "$zlash_strstack_at" = "first" ] &&\
    zlash_strstack_at _zlsh_chk_strstacks 1 && [ "$zlash_strstack_at" = "second" ] &&\

    ! zlash_mk_strstack _zlsh_chk_strstacks 2>/dev/null &&\
    _zlsh_chk_strstacks_metrics_helper 1 1 &&\

    zlash_rm_strstack _zlsh_chk_strstacks &&\
    ! zlash_is_strstack _zlsh_chk_strstacks &&\
    _zlsh_chk_strstacks_metrics_helper 0 1 &&\

    unset -v _zlsh_chk_strstacks_G _zlsh_chk_strstacks_C _zlsh_chk_strstacks_G2 _zlsh_chk_strstacks_C2
}

#------------------------------------------------------------------------------
#, zlash_metric_strstacks_gauge
_ZLSH_DOC_TOPIC_zlash_metric_strstacks_gauge='strstacks gauge

On success, a gauge measurement of current number of stacks is observed and
stored in the `zlash_metric_strstacks_gauge` variable.
'
_ZLSH_DOC_USAGE_zlash_metric_strstacks_gauge='Usage

zlash_metric_strstacks_gauge [out_vname]
'
_ZLSH_DOC_PARAMS_zlash_metric_strstacks_gauge='Parameters

1. *out_vname*: an optional variable name to store the observation in, instead
   of printing to *STDOUT*
'
zlash_metric_strstacks_gauge() {
    if  case $# in
            1) _zlsh_is_vname "$1" ;;
            0) true                ;;
            *) false; esac
    then _zlsh_metric_strstacks_gauge && if [ $# -eq 1 ]
        then   eval    "$1=\$zlash_metric_strstacks_gauge"
        else printf '%s\n' "$zlash_metric_strstacks_gauge"; fi
    else _zlsh_usage zlash_metric_strstacks_gauge && return 64; fi; }
_zlsh_metric_strstacks_gauge() {
    _zlsh_ensure_pncounter _ZLSH_LCYC_RSTK &&\
    _zlsh_metric_strstacks_gauge() {
        _zlsh_pncounter_val _ZLSH_LCYC_RSTK &&\
        zlash_metric_strstacks_gauge=$zlash_pncounter_val
    } && _zlsh_metric_strstacks_gauge; }

#------------------------------------------------------------------------------
#, zlash_metric_strstacks_created_counter
_ZLSH_DOC_TOPIC_zlash_metric_strstacks_created_counter='
strstacks constructed counter

On success, a counter measurement of number of strstacks constructed is observed
and stored in the `zlash_metric_strstacks_created_counter` variable.
'
_ZLSH_DOC_USAGE_zlash_metric_strstacks_created_counter='Usage

zlash_metric_strstacks_created_counter [out_vname]
'
_ZLSH_DOC_PARAMS_zlash_metric_strstacks_created_counter='Parameters

1. *out_vname*: an optional variable name to store the observation in, instead
   of printing to *STDOUT*
'
zlash_metric_strstacks_created_counter() {
    if  case $# in
            1) _zlsh_is_vname "$1" ;;
            0) true                ;;
            *) false; esac
    then _zlsh_metric_strstacks_created_counter && if [ $# -eq 1 ]
        then   eval    "$1=\$zlash_metric_strstacks_created_counter"
        else printf '%s\n' "$zlash_metric_strstacks_created_counter"; fi
    else _zlsh_usage zlash_metric_strstacks_created_counter && return 64; fi; }
_zlsh_metric_strstacks_created_counter() {
    _zlsh_ensure_pncounter _ZLSH_LCYC_RSTK &&\
    _zlsh_metric_strstacks_created_counter() {
        _zlsh_pncounter_p _ZLSH_LCYC_RSTK &&\
        zlash_metric_strstacks_created_counter=$zlash_pncounter_p
    } && _zlsh_metric_strstacks_created_counter; }

#------------------------------------------------------------------------------
#, zlash_mk_strstack
_ZLSH_DOC_TOPIC_zlash_mk_strstack='create a new strstack

A lower-level function creating a new global stack by name. Stack names have
their own global namespace, so they will not clash with other types of names,
but should still be prefixed appropriately to not clash with other stacks.

Optional arguments after the first will be initial elements of the new stack.
'
_ZLSH_DOC_USAGE_zlash_mk_strstack='Usage

zlash_mk_strstack name [item ...]
'
_ZLSH_DOC_PARAMS_zlash_mk_strstack='Parameters

1. *name*: a global identifier for the new strstack
2. *item*: optional initial element(s) of the new strstack
'
zlash_mk_strstack() {
    if [ $# -gt 0 ] && _zlsh_is_vname_sfx "$1"
    then if _zlsh_is_strstack "$1"; then
            printf '%s\n' "ERROR creating stack: '$1' already exists" >&2
            return 1
        else _zlsh_mk_strstack "$@"; fi
    else _zlsh_usage zlash_mk_strstack && return 64; fi; }
_zlsh_mk_strstack() {
    _zlsh_ensure_pncounter _ZLSH_LCYC_RSTK &&\
    _zlsh_mk_strstack() {
        _zlsh_mk_strstack_N=0 &&\
        _zlsh_mk_strstack=$1  && shift &&\
        while [ $# -gt 0 ]; do
            # On break, error is consummed, so condition needs to be checked
            # again after the loop.
            eval "_ZLSH_RSTK_${_zlsh_mk_strstack_N}_$_zlsh_mk_strstack=\$1"\
            && _zlsh_mk_strstack_N=$((_zlsh_mk_strstack_N + 1))\
            && shift || break
        done && [ $# -eq 0 ] &&\
        : $((_ZLSH_RSTK_N_$_zlsh_mk_strstack = _zlsh_mk_strstack_N)) &&\
        _zlsh_pncounter_incr _ZLSH_LCYC_RSTK  #nocomment highlighting-helper ""
    } && _zlsh_mk_strstack "$@"; }

#------------------------------------------------------------------------------
#, zlash_is_strstack
_ZLSH_DOC_TOPIC_zlash_is_strstack='check if name is for an existing strstack
'
_ZLSH_DOC_USAGE_zlash_is_strstack='Usage

zlash_is_strstack name
'
_ZLSH_DOC_PARAMS_zlash_is_strstack='Parameters

1. *name*: a global identifier for an existing strstack
'
zlash_is_strstack() {
    if  case $# in
            1) _zlsh_is_vname_sfx "$1" ;;
            *) false; esac
    then _zlsh_is_strstack "$1"
    else _zlsh_usage zlash_is_strstack && return 64; fi; }
_zlsh_is_strstack() { eval "[ \"\${_ZLSH_RSTK_N_$1:+x}\" ]"; }

#------------------------------------------------------------------------------
#, zlash_rm_strstack
_ZLSH_DOC_TOPIC_zlash_rm_strstack='destroy a strstack
'
_ZLSH_DOC_USAGE_zlash_rm_strstack='Usage

zlash_rm_strstack name
'
_ZLSH_DOC_PARAMS_zlash_rm_strstack='Parameters

1. *name*: a global identifier for an existing stack
'
zlash_rm_strstack() {
    if  case $# in
            1) _zlsh_is_vname_sfx "$1" && _zlsh_is_strstack "$1" ;;
            *) false; esac
    then _zlsh_rm_strstack "$1"
    else _zlsh_usage zlash_rm_strstack && return 64; fi; }
_zlsh_rm_strstack() {
    _zlsh_rm_strstack=$((_ZLSH_RSTK_N_$1)) &&\
    while [ "$_zlsh_rm_strstack" -gt 0 ]; do
        _zlsh_rm_strstack=$((_zlsh_rm_strstack - 1))     &&\
        unset -v "_ZLSH_RSTK_${_zlsh_rm_strstack}_$1" || break
    done && [ "$_zlsh_rm_strstack" -eq 0 ] &&\
    unset -v "_ZLSH_RSTK_N_$1" && _zlsh_pncounter_decr _ZLSH_LCYC_RSTK; }

#------------------------------------------------------------------------------
#, zlash_strstack_len
_ZLSH_DOC_TOPIC_zlash_strstack_len='get strstack size

On success, the length of the stack is stored in the `zlash_strstack_len` variable.
'
_ZLSH_DOC_USAGE_zlash_strstack_len='Usage

zlash_strstack_len name [out_vname]
'
_ZLSH_DOC_PARAMS_zlash_strstack_len='Parameters

1. *name*: a global strstack identifier
2. *out_vname*: optional variable name to store the length in, instead of
   printing it to *STDOUT*
'
zlash_strstack_len() {
    if  case $# in
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_strstack "$1" &&\
                _zlsh_is_vname     "$2" ;;
            1)  _zlsh_is_vname_sfx "$1" && _zlsh_is_strstack "$1" ;;
            *)  false; esac
    then _zlsh_strstack_len "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_strstack_len"
        else printf '%s\n' "$zlash_strstack_len"; fi
    else _zlsh_usage zlash_strstack_len && return 64; fi; }
_zlsh_strstack_len() { : $((zlash_strstack_len = _ZLSH_RSTK_N_$1)); }

#------------------------------------------------------------------------------
#, zlash_strstack_peek
_ZLSH_DOC_TOPIC_zlash_strstack_peek='peek at the top of the strstack

On success, the top item of the stack is stored (without removing it) in the
`zlash_strstack_peek` variable.
'
_ZLSH_DOC_USAGE_zlash_strstack_peek='Usage

zlash_strstack_peek name [out_vname]
'
_ZLSH_DOC_PARAMS_zlash_strstack_peek='Parameters

1. *name*: a global strstack identifier
2. *out_vname*: optional variable name to store the item in, instead of
   printing it to *STDOUT*
'
zlash_strstack_peek() {
    if  case $# in
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_strstack "$1" &&\
                _zlsh_is_vname     "$2" ;;
            1)  _zlsh_is_vname_sfx "$1" && _zlsh_is_strstack "$1" ;;
            *)  false; esac
    then _zlsh_strstack_peek "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_strstack_peek"
        else printf '%s\n' "$zlash_strstack_peek"; fi
    else _zlsh_usage zlash_strstack_peek && return 64; fi; }
_zlsh_strstack_peek() {
    [ $((_ZLSH_RSTK_N_$1)) -gt 0 ] &&\
    eval "zlash_strstack_peek=\$_ZLSH_RSTK_$((_ZLSH_RSTK_N_$1 - 1))_$1"; }

#------------------------------------------------------------------------------
#, zlash_strstack_at
_ZLSH_DOC_TOPIC_zlash_strstack_at='get an item at an index of a strstack

On success, the item at the specified index (where index of zero is the bottom)
of the stack is stored (without removal) in the `zlash_strstack_at` variable.
'
_ZLSH_DOC_USAGE_zlash_strstack_at='Usage

zlash_strstack_at name index [out_vname]
'
_ZLSH_DOC_PARAMS_zlash_strstack_at='Parameters

1. *name*: a global strstack identifier
2. *index*: a non-negative decimal integer less than the length of the stack
3. *out_vname*: optional variable name to store the item in, instead of
   printing it to *STDOUT*
'
zlash_strstack_at() {
    if  case $# in
            3)  _zlsh_is_vname_sfx "$1" && _zlsh_is_strstack "$1" &&\
                _zlsh_is_digits    "$2" &&\
                _zlsh_is_vname     "$3" ;;
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_strstack "$1" &&\
                _zlsh_is_digits    "$2" ;;
            *)  false; esac
    then _zlsh_strstack_at "$1" "$2" && if [ $# -eq 3 ]
        then   eval    "$3=\$zlash_strstack_at"
        else printf '%s\n' "$zlash_strstack_at"; fi
    else _zlsh_usage zlash_strstack_at && return 64; fi; }
_zlsh_strstack_at() {
    [ $((_ZLSH_RSTK_N_$1)) -gt "$2" ] &&\
    eval "zlash_strstack_at=\$_ZLSH_RSTK_$2_$1"; }

#------------------------------------------------------------------------------
#, zlash_strstack_push
_ZLSH_DOC_TOPIC_zlash_strstack_push='push item(s) onto a strstack

Store one or more items on a stack, pushed down in the argument oder.
'
_ZLSH_DOC_USAGE_zlash_strstack_push='Usage

zlash_strstack_push name item [item ...]
'
_ZLSH_DOC_PARAMS_zlash_strstack_push='Parameters

1. *name*: a global strstack identifier
2. *item*: an item to store
'
zlash_strstack_push() {
    if [ $# -gt 1 ] && _zlsh_is_vname_sfx "$1" && _zlsh_is_strstack "$1"
    then _zlsh_strstack_push "$@"
    else _zlsh_usage zlash_strstack_push && return 64; fi; }
_zlsh_strstack_push() {
    _zlsh_strstack_push_N=$((_ZLSH_RSTK_N_$1)) &&\
    _zlsh_strstack_push=$1 &&      shift         && \
    while [ $# -gt 0 ]; do
        eval "_ZLSH_RSTK_${_zlsh_strstack_push_N}_$_zlsh_strstack_push=\$1" &&\
        _zlsh_strstack_push_N=$((_zlsh_strstack_push_N + 1)) && shift || break
    done && [ $# -eq 0 ] &&\
    : $((_ZLSH_RSTK_N_$_zlsh_strstack_push = _zlsh_strstack_push_N));
    #nocomment highlighting-helper ""
}

#------------------------------------------------------------------------------
#, zlash_strstack_pop
_ZLSH_DOC_TOPIC_zlash_strstack_pop='pop an item from the top of the strstack

On success, the item at the at the top of the stack is removed and stored in the
`zlash_strstack_pop` variable.
'
_ZLSH_DOC_USAGE_zlash_strstack_pop='Usage

zlash_strstack_pop name [out_vname]
'
_ZLSH_DOC_PARAMS_zlash_strstack_pop='Parameters

1. *name*: a global strstack identifier
2. *out_vname*: optional variable name to store the popped item in, instead of
   printing it to *STDOUT*
'
zlash_strstack_pop() {
    if  case $# in
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_strstack "$1" &&\
                _zlsh_is_vname     "$2" ;;
            1)  _zlsh_is_vname_sfx "$1" && _zlsh_is_strstack "$1" ;;
            *)  false; esac
    then _zlsh_strstack_pop "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_strstack_pop"
        else printf '%s\n' "$zlash_strstack_pop"; fi
    else _zlsh_usage zlash_strstack_pop && return 64; fi; }
_zlsh_strstack_pop() {
    [ $((_ZLSH_RSTK_N_$1)) -gt 0 ] &&\
    eval "zlash_strstack_pop=\$_ZLSH_RSTK_$((_ZLSH_RSTK_N_$1 - 1))_$1"\
        "&& _ZLSH_RSTK_N_$1=$((_ZLSH_RSTK_N_$1 - 1))"; }

#------------------------------------------------------------------------------
#, zlash_strstack_repr
_ZLSH_DOC_TOPIC_zlash_strstack_repr='get a representation of a strstack

Output a represenation of the stack, safe to be evaluated to reconstruct the
stack.
'
_ZLSH_DOC_USAGE_zlash_strstack_repr='Usage

zlash_strstack_pop name [out_vname]
'
_ZLSH_DOC_PARAMS_zlash_strstack_repr='Parameters

1. *name*: a global strstack identifier
2. *out_vname*: optional variable name to store the representation in, instead
   of printing it to *STDOUT*
'
zlash_strstack_repr() {
    if  case $# in
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_strstack "$1" &&\
                _zlsh_is_vname     "$2" ;;
            1)  _zlsh_is_vname_sfx "$1" && _zlsh_is_strstack "$1" ;;
            *)  false; esac
    then _zlsh_strstack_repr "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_strstack_repr"
        else printf '%s\n' "$zlash_strstack_repr"; fi
    else _zlsh_usage zlash_strstack_repr && return 64; fi; }
_zlsh_strstack_repr() {
    _zlsh_strstack_repr_I=0 &&\
    _zlsh_strstack_repr="zlash_mk_strstack $1" &&\
    while [ $((_ZLSH_RSTK_N_$1)) -gt "$_zlsh_strstack_repr_I" ]; do
        eval "_zlsh_q \"\$_ZLSH_RSTK_${_zlsh_strstack_repr_I}_$1\""\
        && _zlsh_strstack_repr=$_zlsh_strstack_repr\ $zlash_q\
        && _zlsh_strstack_repr_I=$((_zlsh_strstack_repr_I + 1)) || break
    done && [ $((_ZLSH_RSTK_N_$1)) -eq "$_zlsh_strstack_repr_I" ] &&\
        zlash_strstack_repr=$_zlsh_strstack_repr; }
