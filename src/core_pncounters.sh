
# Zlash dev-env section dependencies. (stripped on release)
_zlsh__dev_load   \
    core_validators\
    || return 1

###############################################################################
#/ Positive-Negative Counters Implementation
#
# Our first object-like primitive, with portable fallback implementation having
# state in two variables per "object":
#
#   - _ZLSH_PNCTR_P_<name> positive decimal integer of increments
#   - _ZLSH_PNCTR_N_<name> positive decimal integer of decrements
#
_ZLSH_DOC_TOPIC_about_pncounters='about Zlash PN-counters
' # TODO

#------------------------------------------------------------------------------
#, zlash_ensure_pncounter
_ZLSH_DOC_TOPIC_zlash_ensure_pncounter='ensure a PN-counter

Checks that a PN-counter by a given name exists. If not, creates it, with
optional parameters.
'
_ZLSH_DOC_USAGE_zlash_ensure_pncounter='Usage

zlash_ensure_pncounter name [ini_incr [ini_decr]]
'
_ZLSH_DOC_PARAMS_zlash_ensure_pncounter='Parameters

1. *name*: a global PN-counter identifier to ensure
2. *ini_incr*: an optional initial decimal integer of increments (default: 0)
3. *ini_decr*: an optional initial decimal integer of decrements (default: 0)
'
zlash_ensure_pncounter() {
    if [ $# -gt 0 ] && _zlsh_str_is_vname "$1"
    then _zlsh_ensure_pncounter "$@"
    else _zlsh_usage zlash_ensure_pncounter; return 64; fi; }
_zlsh_ensure_pncounter() {
    _zlsh_is_pncounter "$1" || _zlsh_mk_pncounter "$@"; }

#------------------------------------------------------------------------------
#, zlash_mk_pncounter
_ZLSH_DOC_TOPIC_zlash_mk_pncounter='create a Positive-Negative counter

A lower-level function creating a new global PN-counter by name. PN-counter
names have their own global namespace, so they will not clash with other types
of names, but should still be prefixed appropriately to not clash with other
PN-counters.
'
_ZLSH_DOC_USAGE_zlash_mk_pncounter='Usage

zlash_mk_pncounter name [ini_incr [ini_decr]]
'
_ZLSH_DOC_PARAMS_zlash_mk_pncounter='Parameters

1. *name*: a global identifier for the new PN-counter
2. *ini_incr*: an optional initial decimal integer of increments (default: 0)
3. *ini_decr*: an optional initial decimal integer of decrements (default: 0)
'
zlash_mk_pncounter() {
    if  case $# in
            3)  _zlsh_str_is_vname_sfx "$1" &&\
                _zlsh_str_is_digits    "$2" && \
                _zlsh_str_is_digits    "$3" ;;
            2)  _zlsh_str_is_vname_sfx "$1" &&\
                _zlsh_str_is_digits    "$2" ;;
            1)  _zlsh_str_is_vname_sfx "$1" ;;
            *)  false; esac
    then if _zlsh_is_pncounter "$1"; then
            printf '%s\n' "ERROR creating PN-counter: '$1' already exists" >&2
            return 1
        else _zlsh_mk_pncounter "$1" "${2-0}" "${3-0}"; fi
    else _zlsh_usage zlash_mk_pncounter && return 64; fi; }
_zlsh_mk_pncounter() {
    : $(( _ZLSH_PNCTR_P_$1 = ${2-0} )) $(( _ZLSH_PNCTR_N_$1 = ${3-0} )) &&\
    _zlsh_pncounter_incr _ZLSH_LCYC_PNCTR; }

#------------------------------------------------------------------------------
#, zlash_is_pncounter
_ZLSH_DOC_TOPIC_zlash_is_pncounter='check if name is for an existing PN-counter
'
_ZLSH_DOC_USAGE_zlash_is_pncounter='Usage

zlash_is_pncounter name
'
_ZLSH_DOC_PARAMS_zlash_is_pncounter='Parameters

1. *name*: a global identifier for an existing PN-counter
'
zlash_is_pncounter() {
    if  case $# in
            1) _zlsh_str_is_vname_sfx "$1" ;;
            *) false; esac
    then _zlsh_is_pncounter "$1"
    else _zlsh_usage zlash_is_pncounter && return 64; fi; }
_zlsh_is_pncounter() { eval "[ \"\${_ZLSH_PNCTR_P_$1:+x}\" ]"; }

#------------------------------------------------------------------------------
#, zlash_rm_pncounter
_ZLSH_DOC_TOPIC_zlash_rm_pncounter='destroy a PN-counter by name
'
_ZLSH_DOC_USAGE_zlash_rm_pncounter='Usage

zlash_rm_pncounter name
'
_ZLSH_DOC_PARAMS_zlash_rm_pncounter='Parameters

1. *name*: a global identifier for an existing PN-counter
'
zlash_rm_pncounter() {
    if  case $# in
            1) _zlsh_str_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" ;;
            *) false; esac
    then _zlsh_rm_pncounter "$1"
    else _zlsh_usage zlash_rm_pncounter && return 64; fi; }
_zlsh_rm_pncounter() {
    unset -v "_ZLSH_PNCTR_P_$1" "_ZLSH_PNCTR_N_$1" &&\
    _zlsh_pncounter_decr _ZLSH_LCYC_PNCTR; }

#------------------------------------------------------------------------------
#, zlash_pncounter_incr
_ZLSH_DOC_TOPIC_zlash_pncounter_incr='increment a PN-counter by name

Increment a PN-Counter by name. Optional argument is number of times to
increment.
'
_ZLSH_DOC_USAGE_zlash_pncounter_incr='Usage

zlash_pncounter_incr name [n]
'
_ZLSH_DOC_PARAMS_zlash_pncounter_incr='Parameters

1. *name*: a global identifier for an existing PN-counter
2. *n*: an optional positive decimal integer times to increment (default: 1)
'
zlash_pncounter_incr() {
    if  case $# in
            2)  _zlsh_str_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" &&
                _zlsh_str_is_digits    "$2" ;;
            1)  _zlsh_str_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" ;;
            *)  false; esac
    then _zlsh_pncounter_incr "$1" "${2-1}"
    else _zlsh_usage zlash_pncounter_incr && return 64; fi; }
_zlsh_pncounter_incr() { : $((_ZLSH_PNCTR_P_$1 += ${2-1})); }

#------------------------------------------------------------------------------
#, zlash_pncounter_decr
_ZLSH_DOC_TOPIC_zlash_pncounter_decr='decrement a PN-counter by name

Decrement a PN-Counter by name. Optional argument is number of times to
decrement.
'
_ZLSH_DOC_USAGE_zlash_pncounter_decr='Usage

zlash_pncounter_decr name [n]
'
_ZLSH_DOC_PARAMS_zlash_pncounter_decr='Parameters

1. *name*: a global identifier for an existing PN-counter
2. *n*: an optional positive decimal integer times to decrement (default: 1)
'
zlash_pncounter_decr() {
    if  case $# in
            2)  _zlsh_str_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" &&\
                _zlsh_str_is_digits    "$2" ;;
            1)  _zlsh_str_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" ;;
            *)  false; esac
    then _zlsh_pncounter_decr "$1" "${2-1}"
    else _zlsh_usage zlash_pncounter_decr && return 64; fi; }
_zlsh_pncounter_decr() { : $((_ZLSH_PNCTR_N_$1 += ${2-1})); }

#------------------------------------------------------------------------------
#, zlash_pncounter_val
_ZLSH_DOC_TOPIC_zlash_pncounter_val='get a PN-counter value

On success, stores the counter'\''s value in the `zlash_pncounter_val` variable.
'
_ZLSH_DOC_USAGE_zlash_pncounter_val='Usage

zlash_pncounter_val name [out_vname]
'
_ZLSH_DOC_PARAMS_zlash_pncounter_val='Parameters

1. *name*: a global identifier for an existing PN-counter
2. *out_vname*: an optional variable name to store result instead of outputing
   it to *STDOUT*
'
zlash_pncounter_val() {
    if  case $# in
            2)  _zlsh_str_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" &&\
                _zlsh_str_is_vname     "$2" ;;
            1)  _zlsh_str_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" ;;
            *)  false; esac
    then _zlsh_pncounter_val "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_pncounter_val"
        else printf '%s\n' "$zlash_pncounter_val"; fi
    else _zlsh_usage zlash_pncounter_val && return 64; fi; }
_zlsh_pncounter_val() {
    zlash_pncounter_val=$((_ZLSH_PNCTR_P_$1 - _ZLSH_PNCTR_N_$1));
    #nocomment highlighting-helper ""
}

#------------------------------------------------------------------------------
#, zlash_pncounter_n
_ZLSH_DOC_TOPIC_zlash_pncounter_p='get PN-Counter P-value

On success, stores the positive part of the Positive-Negative Counter in the
`zlash_pncounter_p` variable.
'
_ZLSH_DOC_USAGE_zlash_pncounter_p='Usage

zlash_pncounter_p name [out_vname]
'
_ZLSH_DOC_PARAMS_zlash_pncounter_p='Parameters

1. *name*: a global identifier for an existing PN-counter
2. *out_vname*: an optional variable name to store result instead of outputing
   it to *STDOUT*
'
zlash_pncounter_p() {
    if  case $# in
            2)  _zlsh_str_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" &&\
                _zlsh_str_is_vname     "$2" ;;
            1)  _zlsh_str_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" ;;
            *)  false; esac
    then _zlsh_pncounter_p "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_pncounter_p"
        else printf '%s\n' "$zlash_pncounter_p"; fi
    else _zlsh_usage zlash_pncounter_p && return 64; fi; }
_zlsh_pncounter_p() { zlash_pncounter_p=$((_ZLSH_PNCTR_P_$1)); }

#------------------------------------------------------------------------------
#, zlash_pncounter_n
_ZLSH_DOC_TOPIC_zlash_pncounter_n='get PN-Counter N-value

On success, stores the negative part of the Positive-Negative Counter in the
`zlash_pncounter_n` variable.
'
_ZLSH_DOC_USAGE_zlash_pncounter_n='Usage

zlash_pncounter_n name [out_vname]
'
_ZLSH_DOC_PARAMS_zlash_pncounter_n='Parameters

1. *name*: a global identifier for an existing PN-counter
2. *out_vname*: an optional variable name to store result instead of outputing
   it to *STDOUT*
'
zlash_pncounter_n() {
    if  case $# in
            2)  _zlsh_str_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" &&\
                _zlsh_str_is_vname     "$2" ;;
            1)  _zlsh_str_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" ;;
            *)  false; esac
    then _zlsh_pncounter_n "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_pncounter_n"
        else printf '%s\n' "$zlash_pncounter_n"; fi
    else _zlsh_usage zlash_pncounter_n && return 64; fi; }
_zlsh_pncounter_n() { zlash_pncounter_n=$((_ZLSH_PNCTR_N_$1)); }

#------------------------------------------------------------------------------
#, zlash_pncounter_pix
_ZLSH_DOC_TOPIC_zlash_pncounter_pix='get PN-counter positive index hexadecimal

P-value (the positive part of the PN-counter) can be thought of as increment
index.

The result of this function can be used directly as a (more compact than a
decimal integer) key in a mapping, e.g. for unique identifier generation.
'
_ZLSH_DOC_USAGE_zlash_pncounter_pix='Usage

zlash_pncounter_pix name [out_vname]
'
_ZLSH_DOC_PARAMS_zlash_pncounter_pix='Parameters

1. *name*: a global identifier for an existing PN-counter
2. *out_vname*: an optional variable name to store result instead of outputing
   it to *STDOUT*
'
zlash_pncounter_pix() {
    if  case $# in
            2)  _zlsh_str_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" &&\
                _zlsh_str_is_vname     "$2" ;;
            1)  _zlsh_str_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" ;;
            *)  false; esac
    then _zlsh_pncounter_pix "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_pncounter_pix"
        else printf '%s\n' "$zlash_pncounter_pix"; fi
    else _zlsh_usage zlash_pncounter_pix && return 64; fi; }
_zlsh_pncounter_pix() {
    _zlsh_deci2hexi $((_ZLSH_PNCTR_P_$1)) &&\
    zlash_pncounter_pix=$zlash_deci2hexi; }

#------------------------------------------------------------------------------
#, zlash_pncounter_tix
_ZLSH_DOC_TOPIC_zlash_pncounter_tix='get PN-counter ticks index hexadecimal

P+N value (the positive and negative parts sum of the PN-counter) can be thought
of as change index, or ticks (increments and decrements).

The result of this function can be used directly as a (more compact than a
decimal integer) key in a mapping, e.g. for identifying sections of balanced
nestings, during parsing or composition.
'
_ZLSH_DOC_USAGE_zlash_pncounter_tix='Usage

zlash_pncounter_tix name [out_vname]
'
_ZLSH_DOC_PARAMS_zlash_pncounter_tix='Parameters

1. *name*: a global identifier for an existing PN-counter
2. *out_vname*: an optional variable name to store result instead of outputing
   it to *STDOUT*
'
zlash_pncounter_tix() {
    if  case $# in
            2)  _zlsh_str_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" &&\
                _zlsh_str_is_vname     "$2" ;;
            1)  _zlsh_str_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" ;;
            *)  false; esac
    then _zlsh_pncounter_tix "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_pncounter_tix"
        else printf '%s\n' "$zlash_pncounter_tix"; fi
    else _zlsh_usage zlash_pncounter_tix && return 64; fi; }
_zlsh_pncounter_tix() {
    _zlsh_deci2hexi $((_ZLSH_PNCTR_P_$1 + _ZLSH_PNCTR_N_$1)) &&\
    zlash_pncounter_tix=$zlash_deci2hexi; }

#------------------------------------------------------------------------------
#, zlash_pncounter_repr
_ZLSH_DOC_TOPIC_zlash_pncounter_repr='get a representation of a PN-counter

Output a represenation of the Positive-Negative counter, safe to be evaluated to
reconstruct the PN-counter.
'
_ZLSH_DOC_USAGE_zlash_pncounter_repr='Usage

zlash_pncounter_repr name [out_vname]
'
_ZLSH_DOC_PARAMS_zlash_pncounter_repr='Parameters

1. *name*: a global PN-counter identifier
2. *out_vname*: optional variable name to store the representation in, instead
   of printing it to *STDOUT*
'
zlash_pncounter_repr() {
    if  case $# in
            2)  _zlsh_str_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" &&\
                _zlsh_str_is_vname     "$2" ;;
            1)  _zlsh_str_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" ;;
            *)  false; esac
    then _zlsh_pncounter_repr "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_pncounter_repr"
        else printf '%s\n' "$zlash_pncounter_repr"; fi
    else _zlsh_usage zlash_pncounter_repr && return 64; fi; }
_zlsh_pncounter_repr() {
    zlash_pncounter_repr="zlash_mk_pncounter $1 $((_ZLSH_PNCTR_P_$1))" &&\
    zlash_pncounter_repr=$zlash_pncounter_repr\ $((_ZLSH_PNCTR_N_$1)); }

#------------------------------------------------------------------------------
#, zlash_metric_pncounters_gauge
_ZLSH_DOC_TOPIC_zlash_metric_pncounters_gauge='PN-counters gauge

On success, a gauge measurement of current number of Positive-Negative counters
is observed and stored in the `zlash_metric_pncounters_gauge` variable.
'
_ZLSH_DOC_USAGE_zlash_metric_pncounters_gauge='Usage

zlash_metric_pncounters_gauge [out_vname]
'
_ZLSH_DOC_PARAMS_zlash_metric_pncounters_gauge='Parameters

1. *out_vname*: an optional variable name to store the observation in, instead
   of printing to *STDOUT*
'
zlash_metric_pncounters_gauge() {
    if  case $# in
            1) _zlsh_str_is_vname "$1" ;;
            0) true                ;;
            *) false; esac
    then _zlsh_metric_pncounters_gauge && if [ $# -eq 1 ]
        then   eval    "$1=\$zlash_metric_pncounters_gauge"
        else printf '%s\n' "$zlash_metric_pncounters_gauge"; fi
    else _zlsh_usage zlash_metric_pncounters_gauge && return 64; fi; }
_zlsh_metric_pncounters_gauge() {
    _zlsh_pncounter_val _ZLSH_LCYC_PNCTR &&\
    zlash_metric_pncounters_gauge=$zlash_pncounter_val; }

#------------------------------------------------------------------------------
#, zlash_metric_pncounters_created_counter
_ZLSH_DOC_TOPIC_zlash_metric_pncounters_created_counter='
PN-counters constructed counter

On success, a counter measurement of number of Positive-Negative counters
constructed is observed and stored in the
`zlash_metric_pncounters_created_counter` variable.
'
_ZLSH_DOC_USAGE_zlash_metric_pncounters_created_counter='Usage

zlash_metric_pncounters_created_counter [out_vname]
'
_ZLSH_DOC_PARAMS_zlash_metric_pncounters_created_counter='Parameters

1. *out_vname*: an optional variable name to store the observation in, instead
   of printing to *STDOUT*
'
zlash_metric_pncounters_created_counter() {
    if  case $# in
            1) _zlsh_str_is_vname "$1" ;;
            0) true                ;;
            *) false; esac
    then _zlsh_metric_pncounters_created_counter && if [ $# -eq 1 ]
        then   eval    "$1=\$zlash_metric_pncounters_created_counter"
        else printf '%s\n' "$zlash_metric_pncounters_created_counter"; fi
    else _zlsh_usage zlash_metric_pncounters_created_counter && return 64; fi
}
_zlsh_metric_pncounters_created_counter() {
    _zlsh_pncounter_p _ZLSH_LCYC_PNCTR &&\
    zlash_metric_pncounters_created_counter=$zlash_pncounter_p; }

#------------------------------------------------------------------------------
#! A bootstrapped special PN-counter for PN-counter metrics
#  This one can't be ensured without bootstrapping, since the constructor is
#  using it.
if ! _zlsh_is_pncounter _ZLSH_LCYC_PNCTR; then
    _ZLSH_PNCTR_P__ZLSH_LCYC_PNCTR=1
    _ZLSH_PNCTR_N__ZLSH_LCYC_PNCTR=0; fi

#------------------------------------------------------------------------------
_zlsh_chk_core_pncounters() {
    # CN :   current   number of PN-counters at the start of the check
    # CR : constructed number of PN-counters at the start of the check
    # CN2:   current   number of PN-counters
    # CR2: constructed number of PN-counters
    #  V :             value  of the PN-counter
    #  P :      positive part of the PN-counter value
    #  N :      negative part of the PN-counter value
    _zlsh_chk_pncounters_helper() {  # shellcheck disable=2154
        zlash_pncounter_val _zlsh_chk_pncounters _zlsh_chk_pncounters_V &&\
        [ "$_zlsh_chk_pncounters_V"  -eq "$1" ]                         && \
        [     "$zlash_pncounter_val" -eq "$1" ]                         &&  \
        zlash_pncounter_p   _zlsh_chk_pncounters _zlsh_chk_pncounters_P &&\
        [ "$_zlsh_chk_pncounters_P"  -eq "$2" ]                         && \
        [      "$zlash_pncounter_p"  -eq "$2" ]                         &&  \
        zlash_pncounter_n   _zlsh_chk_pncounters _zlsh_chk_pncounters_N &&\
        [ "$_zlsh_chk_pncounters_N"  -eq "$3" ]                         && \
        [      "$zlash_pncounter_n"  -eq "$3" ]; } &&\
    _zlsh_chk_pncounters_metrics_helper() {  # shellcheck disable=2154
        zlash_metric_pncounters_gauge               _zlsh_chk_pncounters_CN2 &&\
        zlash_metric_pncounters_created_counter     _zlsh_chk_pncounters_CR2   \
        && [ "$zlash_metric_pncounters_gauge" -eq "$_zlsh_chk_pncounters_CN2" ]\
        && [ "$zlash_metric_pncounters_gauge"        \
            -eq $((_zlsh_chk_pncounters_CN + $1)) ]   \
        && [ "$zlash_metric_pncounters_created_counter"\
            -eq "$_zlsh_chk_pncounters_CR2"       ]     \
        && [ "$zlash_metric_pncounters_created_counter"  \
            -eq $((_zlsh_chk_pncounters_CR + $2)) ]; } &&\
    zlash_metric_pncounters_gauge           _zlsh_chk_pncounters_CN &&\
    zlash_metric_pncounters_created_counter _zlsh_chk_pncounters_CR    \
    &&   _zlsh_chk_pncounters_metrics_helper 0 0\
    && ! zlash_is_pncounter _zlsh_chk_pncounters \
    &&   zlash_mk_pncounter _zlsh_chk_pncounters  \
    &&   zlash_is_pncounter _zlsh_chk_pncounters   \
    &&   _zlsh_chk_pncounters_metrics_helper 1 1    \
    &&   _zlsh_chk_pncounters_helper  0 0 0          \
    &&   zlash_pncounter_incr _zlsh_chk_pncounters\
    &&   _zlsh_chk_pncounters_helper  1 1 0        \
    &&   zlash_pncounter_incr _zlsh_chk_pncounters 3\
    &&   _zlsh_chk_pncounters_helper  4 4 0          \
    &&   zlash_pncounter_decr _zlsh_chk_pncounters    \
    &&   _zlsh_chk_pncounters_helper  3 4 1            \
    &&   zlash_pncounter_decr _zlsh_chk_pncounters 5    \
    &&   _zlsh_chk_pncounters_helper -2 4 6              \
    && ! zlash_mk_pncounter _zlsh_chk_pncounters 2>/dev/null\
    &&   _zlsh_chk_pncounters_helper -2 4 6                  \
    &&   _zlsh_chk_pncounters_metrics_helper 1 1              \
    &&   zlash_rm_pncounter _zlsh_chk_pncounters \
    && ! zlash_is_pncounter _zlsh_chk_pncounters  \
    &&   _zlsh_chk_pncounters_metrics_helper 0 1 &&\
    unset -v    _zlsh_chk_pncounters_CN  _zlsh_chk_pncounters_CR\
                _zlsh_chk_pncounters_CN2 _zlsh_chk_pncounters_CR2\
        _zlsh_chk_pncounters_V _zlsh_chk_pncounters_P _zlsh_chk_pncounters_N; }
