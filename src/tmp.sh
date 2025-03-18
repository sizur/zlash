

###############################################################################
#/ Lower-Level Rawdeque Implementation
#
_ZLSH_DOC_TOPIC__about_rawdeques='about Zlash lower-level rawdeques

Rawdeques are not object-aware. Their elements are plain strings only, and their
names are plain identifier suffixes. Rawdeques should not be used to build
nested structures directly, as `zlash_rawdeque_repr` will fail to represent
referenced objects.
' # TODO

#------------------------------------------------------------------------------
#, zlash_metric_rawdeques_gauge
_ZLSH_DOC_TOPIC__zlash_metric_rawdeques_gauge='rawdeques gauge

On success, a gauge measurement of current number of rawdeques is observed and
stored in the `zlash_metric_rawdeques_gauge` variable.
'
_ZLSH_DOC_USAGE__zlash_metric_rawdeques_gauge='Usage

zlash_metric_rawdeques_gauge [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_metric_rawdeques_gauge='Parameters

1. *out_vname*: an optional variable name to store the observation in, instead
   of printing to *STDOUT*
'
zlash_metric_rawdeques_gauge() {
    if  case $# in
            1) _zlsh_is_vname "$1" ;;
            0) true                ;;
            *) false; esac
    then _zlsh_metric_rawdeques_gauge && if [ $# -eq 1 ]
        then   eval    "$1=\$zlash_metric_rawdeques_gauge"
        else printf '%s\n' "$zlash_metric_rawdeques_gauge"; fi
    else _zlsh_usage zlash_metric_rawdeques_gauge && return 64; fi; }
_zlsh_metric_rawdeques_gauge() {
    _zlsh_ensure_pncounter _ZLSH_LCYC_DEQ &&\
    _zlsh_metric_rawdeques_gauge() {
        _zlsh_pncounter_val _ZLSH_LCYC_DEQ &&\
        zlash_metric_rawdeques_gauge=$zlash_pncounter_val
    } && _zlsh_metric_rawdeques_gauge; }

#------------------------------------------------------------------------------
#, zlash_metric_rawdeques_created_counter
_ZLSH_DOC_TOPIC__zlash_metric_rawdeques_created_counter='
rawdeques constructed counter

On success, a counter measurement of number of rawdeques constructed is observed
and stored in the `zlash_metric_rawdeques_created_counter` variable.
'
_ZLSH_DOC_USAGE__zlash_metric_rawdeques_created_counter='Usage

zlash_metric_rawdeques_created_counter [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_metric_rawdeques_created_counter='Parameters

1. *out_vname*: an optional variable name to store the observation in, instead
   of printing to *STDOUT*
'
zlash_metric_rawdeques_created_counter() {
    if  case $# in
            1) _zlsh_is_vname "$1" ;;
            0) true                ;;
            *) false; esac
    then _zlsh_metric_rawdeques_created_counter && if [ $# -eq 1 ]
        then   eval    "$1=\$zlash_metric_rawdeques_created_counter"
        else printf '%s\n' "$zlash_metric_rawdeques_created_counter"; fi
    else _zlsh_usage zlash_metric_rawdeques_created_counter && return 64; fi; }
_zlsh_metric_rawdeques_created_counter() {
    _zlsh_ensure_pncounter _ZLSH_LCYC_DEQ &&\
    _zlsh_metric_rawdeques_created_counter() {
        _zlsh_pncounter_p _ZLSH_LCYC_DEQ &&\
        zlash_metric_rawdeques_created_counter=$zlash_pncounter_p
    } && _zlsh_metric_rawdeques_created_counter; }

#------------------------------------------------------------------------------
#, zlash_mk_rawdeque
_ZLSH_DOC_TOPIC__zlash_mk_rawdeque='create a new rawdeque

A lower-level function creating a new global rawdeque by name. Stack names have
their own global namespace, so they will not clash with other types of names,
but should still be prefixed appropriately to not clash with other rawdeques.

Optional arguments after the first will be initial elements of the new rawdeque.
'
_ZLSH_DOC_USAGE__zlash_mk_rawdeque='Usage

zlash_mk_rawdeque name [item ...]
'
_ZLSH_DOC_PARAMS__zlash_mk_rawdeque='Parameters

1. *name*: a global identifier for the new rawdeque
2. *item*: optional initial element(s) of the new rawdeque
'
zlash_mk_rawdeque() {
    if [ $# -gt 0 ] && _zlsh_is_vname_sfx "$1"
    then if _zlsh_is_rawdeque "$1"; then
            printf '%s\n' "ERROR creating rawdeque: '$1' already exists" >&2
            return 1
        else _zlsh_mk_rawdeque "$@"; fi
    else _zlsh_usage zlash_mk_rawdeque && return 64; fi; }
_zlsh_mk_rawdeque() {
    _zlsh_ensure_pncounter _ZLSH_LCYC_DEQ &&\
    _zlsh_mk_rawdeque() {
        _zlsh_mk_rawdeque=$1        &&        shift            &&\
        _zlsh_mk_stack "_ZLSH_RDEQ_T_$_zlsh_mk_rawdeque" "$@" && \
        _zlsh_mk_stack "_ZLSH_RDEQ_H_$_zlsh_mk_rawdeque"      &&  \
        _zlsh_pncounter_incr _ZLSH_LCYC_DEQ
    } && _zlsh_mk_rawdeque "$@"; }

#------------------------------------------------------------------------------
#, zlash_is_rawdeque
_ZLSH_DOC_TOPIC__zlash_is_rawdeque='check if name is for an existing rawdeque
'
_ZLSH_DOC_USAGE__zlash_is_rawdeque='Usage

zlash_is_rawdeque name
'
_ZLSH_DOC_PARAMS__zlash_is_rawdeque='Parameters

1. *name*: a global identifier for an existing rawdeque
'
zlash_is_rawdeque() {
    if  case $# in
            1) _zlsh_is_vname_sfx "$1" ;;
            *) false; esac
    then _zlsh_is_rawdeque "$1"
    else _zlsh_usage zlash_is_rawdeque && return 64; fi; }
_zlsh_is_rawdeque() { _zlsh_is_stack "_ZLSH_RDEQ_H_$1"; }

#------------------------------------------------------------------------------
#, zlash_rm_rawdeque
_ZLSH_DOC_TOPIC__zlash_rm_rawdeque='destroy a rawdeque
'
_ZLSH_DOC_USAGE__zlash_rm_rawdeque='Usage

zlash_rm_rawdeque name
'
_ZLSH_DOC_PARAMS__zlash_rm_rawdeque='Parameters

1. *name*: a global identifier for an existing rawdeque
'
zlash_rm_rawdeque() {
    if  case $# in
            1) _zlsh_is_vname_sfx "$1" && _zlsh_is_rawdeque "$1" ;;
            *) false; esac
    then _zlsh_rm_rawdeque "$1"
    else _zlsh_usage zlash_rm_rawdeque && return 64; fi; }
_zlsh_rm_rawdeque() {
    _zlsh_rm_stack "_ZLSH_RDEQ_H_$1" && _zlsh_rm_stack "_ZLSH_RDEQ_T_$1" &&\
    _zlsh_pncounter_decr _ZLSH_LCYC_DEQ; }

#------------------------------------------------------------------------------
#, zlash_rawdeque_len
_ZLSH_DOC_TOPIC__zlash_rawdeque_len='get rawdeque size

On success, the length of the rawdeque is stored in the `zlash_rawdeque_len` variable.
'
_ZLSH_DOC_USAGE__zlash_rawdeque_len='Usage

zlash_rawdeque_len name [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_rawdeque_len='Parameters

1. *name*: a global rawdeque identifier
2. *out_vname*: optional variable name to store the length in, instead of
   printing it to *STDOUT*
'
zlash_rawdeque_len() {
    if  case $# in
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_rawdeque "$1" &&\
                _zlsh_is_vname     "$2" ;;
            1)  _zlsh_is_vname_sfx "$1" && _zlsh_is_rawdeque "$1" ;;
            *)  false; esac
    then _zlsh_rawdeque_len "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_rawdeque_len"
        else printf '%s\n' "$zlash_rawdeque_len"; fi
    else _zlsh_usage zlash_rawdeque_len && return 64; fi; }
_zlsh_rawdeque_len() {
    _zlsh_stack_len "_ZLSH_RDEQ_H_$1" &&\
    zlash_rawdeque_len=$zlash_stack_len  && \
    _zlsh_stack_len "_ZLSH_RDEQ_T_$1" &&  \
    zlash_rawdeque_len=$((zlash_rawdeque_len + zlash_stack_len)); }

#------------------------------------------------------------------------------
#, zlash_rawdeque_at
_ZLSH_DOC_TOPIC__zlash_rawdeque_at='get item at an index of a rawdeque

On success, the item at the specified index of the rawdeque is stored in the
`zlash_rawdeque_at` variable.
'
_ZLSH_DOC_USAGE__zlash_rawdeque_at='Usage

zlash_rawdeque_at name index [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_rawdeque_at='Parameters

1. *name*: a global rawdeque identifier
2. *index*: a non-negative decimal integer less than the length of the rawdeque
3. *out_vname*: an optional variable name to store the item in, instead of
   printing it to *STDOUT*
'
zlash_rawdeque_at() {
    if  case $# in
            3)  _zlsh_is_vname_sfx "$1" && _zlsh_is_rawdeque "$1" &&\
                _zlsh_is_digits    "$2" &&\
                _zlsh_is_vname     "$3" ;;
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_rawdeque "$1" &&\
                _zlsh_is_digits    "$2" ;;
            *)  false; esac
    then _zlsh_rawdeque_at "$1" "$2" && if [ $# -eq 3 ]
        then   eval    "$3=\$zlash_rawdeque_at"
        else printf '%s\n' "$zlash_rawdeque_at"; fi
    else _zlsh_usage zlash_rawdeque_at && return 64; fi; }
_zlsh_rawdeque_at() {
    _zlsh_stack_len "_ZLSH_RDEQ_H_$1" &&\
    if [ "$zlash_stack_len" -gt "$2" ]; then
        _zlsh_stack_at "_ZLSH_RDEQ_H_$1" "$2" &&\
        zlash_rawdeque_at=$zlash_stack_at
    else _zlsh_rawdeque_at=$(($2 - zlash_stack_len))      &&\
        _zlsh_stack_len "_ZLSH_RDEQ_T_$1"                 && \
        [ "$zlash_stack_len" -gt "$_zlsh_rawdeque_at" ]   &&  \
        _zlsh_stack_at "_ZLSH_RDEQ_T_$1"                       \
            $((zlash_stack_len - 1 - $_zlsh_rawdeque_at)) &&    \
        zlash_rawdeque_at=$zlash_stack_at; fi; }

#------------------------------------------------------------------------------
#, zlash_rawdeque_push
_ZLSH_DOC_TOPIC__zlash_rawdeque_push='append item(s) onto a rawdeque end

Store one or more items on a rawdeque end.
'
_ZLSH_DOC_USAGE__zlash_rawdeque_push='Usage

zlash_rawdeque_push name item [item ...]
'
_ZLSH_DOC_PARAMS__zlash_rawdeque_push='Parameters

1. *name*: a global rawdeque identifier
2. *item*: an item to store
'
zlash_rawdeque_push() {
    if [ $# -gt 1 ] && _zlsh_is_vname_sfx "$1" && _zlsh_is_rawdeque "$1"
    then _zlsh_rawdeque_push "$@"
    else _zlsh_usage zlash_rawdeque_push && return 64; fi; }
_zlsh_rawdeque_push() {
    _zlsh_rawdeque_push=$1 && shift &&\
    _zlsh_stack_push "_ZLSH_RDEQ_T_$_zlsh_rawdeque_push" "$@"; }

#------------------------------------------------------------------------------
#, zlash_rawdeque_pop
_ZLSH_DOC_TOPIC__zlash_rawdeque_pop='pop an item from the end of the rawdeque

On success, the item at the at the end of the rawdeque is removed and stored in the
`zlash_rawdeque_pop` variable.
'
_ZLSH_DOC_USAGE__zlash_rawdeque_pop='Usage

zlash_rawdeque_pop name [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_rawdeque_pop='Parameters

1. *name*: a global rawdeque identifier
2. *out_vname*: optional variable name to store the popped item in, instead of
   printing it to *STDOUT*
'
zlash_rawdeque_pop() {
    if  case $# in
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_rawdeque "$1" &&\
                _zlsh_is_vname     "$2" ;;
            1)  _zlsh_is_vname_sfx "$1" && _zlsh_is_rawdeque "$1" ;;
            *)  false; esac
    then _zlsh_rawdeque_pop "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_rawdeque_pop"
        else printf '%s\n' "$zlash_rawdeque_pop"; fi
    else _zlsh_usage zlash_rawdeque_pop && return 64; fi; }
_zlsh_rawdeque_pop() {
    if _zlsh_rawstack_pop "_ZLSH_RDEQ_T_$1"; then
        zlash_rawdeque_pop=$zlash_rawstack_pop
    else while _zlsh_rawstack_pop "_ZLSH_RDEQ_H_$1"; do
             _zlsh_rawstack_push "_ZLSH_RDEQ_T_$1" "$zlash_rawstack_pop"; done
        _zlsh_rawstack_pop "_ZLSH_RDEQ_T_$1" &&\
        zlash_rawdeque_pop=$zlash_rawstack_pop; fi; }

#------------------------------------------------------------------------------
#, zlash_rawdeque_unshift
_ZLSH_DOC_TOPIC__zlash_rawdeque_unshift='append item(s) onto a rawdeque front

Store one or more items on a rawdeque beginning.
'
_ZLSH_DOC_USAGE__zlash_rawdeque_unshift='Usage

zlash_rawdeque_unshift name item [item ...]
'
_ZLSH_DOC_PARAMS__zlash_rawdeque_unshift='Parameters

1. *name*: a global rawdeque identifier
2. *item*: an item to store
'
zlash_rawdeque_unshift() {
    if [ $# -gt 1 ] && _zlsh_is_vname_sfx "$1" && _zlsh_is_rawdeque "$1"
    then _zlsh_rawdeque_unshift "$@"
    else _zlsh_usage zlash_rawdeque_unshift && return 64; fi; }
_zlsh_rawdeque_unshift() {
    # If we have multiple items to unshift, they need to be pushed on the Head
    # stack in reverse order. We use a temporary stack for that, which must
    # depend on the deque, so on error items won't remain to be unshifted into
    # the wrong stack.
    if [ $# -eq 2 ]; then _zlsh_rawstack_push "_ZLSH_RDEQ_H_$1" "$2"
    else _zlsh_rawdeque_unshift_T="_zlsh_rawdeque_unshift_$1" &&\
        _zlsh_rawdeque_unshift=$1 &&          shift           && \
        _zlsh_mk_rawstack "$_zlsh_rawdeque_unshift_T" "$@"    &&  \
        while _zlsh_rawstack_pop "$_zlsh_rawdeque_unshift_T"; do
            _zlsh_rawstack_push "_ZLSH_RDEQ_H_$_zlsh_rawdeque_unshift"\
                                "$zlash_rawstack_pop"                 || break
        done && _zlsh_rawstack_len "$_zlsh_rawdeque_unshift_T" &&\
        [ "$zlash_rawstack_len" -eq 0 ]                        && \
        _zlsh_rm_rawstack "$_zlsh_rawdeque_unshift_T"; fi; }

#------------------------------------------------------------------------------
#, zlash_rawdeque_shift
_ZLSH_DOC_TOPIC__zlash_rawdeque_shift='
shift an item from the beginning of the rawdeque

On success, the item at the from the start of the rawdeque is removed and stored
in the `zlash_rawdeque_shift` variable.
'
_ZLSH_DOC_USAGE__zlash_rawdeque_shift='Usage

zlash_rawdeque_shift name [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_rawdeque_shift='Parameters

1. *name*: a global rawdeque identifier
2. *out_vname*: optional variable name to store the shifted item in, instead of
   printing it to *STDOUT*
'
zlash_rawdeque_shift() {
    if  case $# in
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_rawdeque "$1" &&\
                _zlsh_is_vname     "$2" ;;
            1)  _zlsh_is_vname_sfx "$1" && _zlsh_is_rawdeque "$1" ;;
            *)  false; esac
    then _zlsh_rawdeque_shift "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_rawdeque_shift"
        else printf '%s\n' "$zlash_rawdeque_shift"; fi
    else _zlsh_usage zlash_rawdeque_shift && return 64; fi; }
_zlsh_rawdeque_shift() {
    if _zlsh_rawstack_pop "_ZLSH_RDEQ_H_$1"; then
        zlash_rawdeque_shift=$zlash_rawstack_pop
    else while _zlsh_rawstack_pop "_ZLSH_RDEQ_T_$1"; do
             _zlsh_rawstack_push "_ZLSH_RDEQ_H_$1" "$zlash_rawstack_pop"; done
        _zlsh_rawstack_pop "_ZLSH_RDEQ_H_$1" &&\
        zlash_rawdeque_pop=$zlash_rawstack_pop; fi; }
