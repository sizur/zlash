###############################################################################
#/ Zlash Development Environment Helpers
#
# Zlash development environment helpers for loading only specific Zlash sections
# with dependencies.
#
# This enables a dev to simply source any specific section and it will just
# work, provided this file was priviously sourced.
#
# This file and section headers declaring section dependencies need not be in
# the Zlash single-file deliverable.
#
# These functions assume POSIX sanity, but must not depend on anything at all.
# Please keep this minimal.
#
# Dev usage (while working on `src/section_B.sh`:
#
#     `. src/section_B.sh`
#
# Where `src/section_B.sh` contains the following in the section header:
#
#     ```
#     _zlsh__dev_load section_A section_X || return 1
#     ```
#
# This will source `src/section_B.sh` with all it's dependencies recursively,
# and run section checks on every dependency that has defined section checks.

#------------------------------------------------------------------------------
# _zlsh__dev_load [section | filepath ...]
#
# Dev env helper for loading section dependencies.
#
_zlsh__dev_load () {
    _zlsh__dev_with_ctxt _zlsh__dev_load_wrk "$@"; }
_zlsh__dev_load_wrk () {
    _zlsh__dev_ctxt_local _zlsh__dev_load _zlsh__dev_src_dir &&\
    while [ $# -gt 0 ]; do  # shellcheck disable=2154
        _zlsh__dev_load=$1 && shift &&\
        case $_zlsh__dev_load in *'/'*)
            _zlsh__dev_src_dir="${_zlsh__dev_load%'/'*}" &&\
            _zlsh__dev_load=${_zlsh__dev_load##*'/'}; esac &&\
        case $_zlsh__dev_load in *'.sh')
            _zlsh__dev_load=${_zlsh__dev_load%'.sh'}; esac &&\
        _zlsh__dev_src "$_zlsh__dev_load"; done; }

#------------------------------------------------------------------------------
# _zlsh__dev_src section
#
# Dev env helper for sourcing a section.  Runs section chk, if defined.
#
_zlsh__dev_src () {
    if case $1 in
        *[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)
            false; esac
    then _zlsh__dev_with_ctxt _zlsh__dev_src_wrk "$1"
    else >&2 printf 'ERROR: ILLEGAL %s\n' "$1"; return 64; fi; }
_zlsh__dev_src_wrk () {
    if eval '[ "${_zlsh__dev_srcing_'"$1"'+x}" ]'; then
        >&2 printf 'ERROR: CIRCULAR DEP %s\n' "$1";    return 1; fi &&\
    if eval '[ "${_zlsh__dev_srced_'"$1"'+x}" ]'; then return 0; fi &&\
    _zlsh__dev_ctxt_global "_zlsh__dev_srcing_$1"  &&\
    eval                   "_zlsh__dev_srcing_$1=" && \
    _zlsh__dev_ctxt_local zlsh__dev_src_dir _zlsh__dev_src &&\
    for _zlsh__dev_src_dir in\
            "${_zlsh__dev_src_dir:-${ZLASH_DEV_ROOT:-.}/src}" '.'
    do  _zlsh__dev_src=$_zlsh__dev_src_dir'/'$1'.sh' &&\
        unset -v _zlsh__dev_src_dir                  && \
        if [ -r "$_zlsh__dev_src" ]
        then  # shellcheck disable=1090
            if . "$_zlsh__dev_src"
            then  # shellcheck disable=1003
                if      command -v "_zlsh_chk_$1" >/dev/null 2>&1\
                && [ "$(command -v "_zlsh_chk_$1")" = "_zlsh_chk_$1" ]
                then  # Run section chk.
                    if eval "! _zlsh_chk_$1"
                    then  # shellcheck disable=2016
                        if ! eval '[ "${_zlsh_chk_'"$1"':+x}" ] &&'\
                            '>&2 printf FAILED\ %s:\ %s\\n'         \
                            '"_zlsh_chk_'"$1"'" "$_zlsh_chk_'"$1"'"'
                        then >&2 printf 'FAILED %s\n' "_zlsh_chk_$1"
                        fi && return 1; fi; fi
                _zlsh__dev_ctxt_global "_zlsh__dev_srced_$1"  &&\
                eval                   "_zlsh__dev_srced_$1=" && \
                unset -v               "_zlsh__dev_srcing_$1" &&  \
                >&2 printf 'OK %s\n' "$1"                     && return 0
            else >&2 printf 'ERROR: SRC %s\n' "$_zlsh__dev_src" && return 1
            fi; fi
    done && >&2  printf 'ERROR: NOT FOUND %s\n' "$1" && return 1; }

#------------------------------------------------------------------------------
# _zlsh__dev_with_ctxt cmd [arg ...]
# _zlsh__dev_ctxt_global [var ...]
# _zlsh__dev_ctxt_local [var ...]
#
# Portable context variable management interface. Contexts may be nested,
# including recursive calls. Context-local variables are restored (or unset) to
# their prior values on context exit. Context-global variables are only restored
# on exit of the last outer context. They are cross-context global and cannot
# shadow a context-local variable (nor another context-global of the same name).
#
# NOTE: This is a much simplified, less general, less robust, and less capable,
#       but hermetic version of `core_ctxt` section, as Zlash loader cannot
#       depend on anything, including other Zlash sections, like
#       `core_shell_quoting`, `core_stack`. `core_iter`, etc. It has been
#       extracted from the loader logic (and made more general) to not obscure
#       the loader logic with state management dynamic expansions. Make sure you
#       absolutely need it before using it anywhere else.
#
_zlsh__dev_with_ctxt () {
    _zlsh__dev_with_ctxt_cmd=$1      && shift &&\
    _zlsh__dev_with_ctxt=0           &&\
    _zlsh__dev_ctxt_push             && \
    "$_zlsh__dev_with_ctxt_cmd" "$@" || _zlsh__dev_with_ctxt=$?
    _zlsh__dev_ctxt_pop              && return "$_zlsh__dev_with_ctxt"; }

_zlsh__dev_ctxt_illegal () {  # [fname_sfx ...]
    while [ $# -gt 0 ]; do eval                                \
        "_zlsh__dev_ctxt_$1 () {"                               \
            ">&2 printf 'ERROR: ILLEGAL _zlsh__dev_ctxt_$1"      \
                "BEFORE _zlsh__dev_ctxt_push\\n'; return 64; }" &&\
        shift || return $?; done; }

# Context (2-)State Machine (blocking illegal operations):
# - Outside any `_zlsh__dev_ctxt`
# - Inside  a   `_zlsh__dev_ctxt`
#
# shellcheck disable=1003,2016,2317
_zlsh__dev_ctxt_reset() {
    _zlsh__dev_ctxt_illegal pop global local || return $?
    unset -v _zlsh__dev_ctxt

    _zlsh__dev_ctxt_push () {
        _zlsh__dev_ctxt=1
        _zlsh__dev_ctxt_push () {
            _zlsh__dev_ctxt=$((_zlsh__dev_ctxt + 1)); }

        # Context State Tracker Variables:
        # - `_zlsh__dev_ctxt`  : ctxt stack frame counter,
        # - `_zlsh__dev_ctxtR*`: ctxt variables restore values and code,
        # - `_zlsh__dev_ctxtU*`: ctxt variables to unset,
        # - `_zlsh__dev_ctxtG*`: ctxt-global variables.

        _zlsh__dev_ctxt_local () {  # [vname ...]
            while [ $# -gt 0 ]; do eval\
                'if [ "${'"$1"'+x}" ]; then'\
                    '_zlsh__dev_ctxtR'"$_zlsh__dev_ctxt"'_'"$1"'=$'"$1"';'\
                    '_zlsh__dev_ctxtR'"$_zlsh__dev_ctxt"'=${_zlsh__dev_ctxtR'"$_zlsh__dev_ctxt"'-}\'\
                        "$1"'=\$_zlsh__dev_ctxtR'"$_zlsh__dev_ctxt"'_'"$1"'\;;'\
                    '_zlsh__dev_ctxtU'"$_zlsh__dev_ctxt"'=${_zlsh__dev_ctxtU'"$_zlsh__dev_ctxt"'-}\'\
                        '_zlsh__dev_ctxtR'"$_zlsh__dev_ctxt"'_'"$1"';'\
                'else _zlsh__dev_ctxtU'"$_zlsh__dev_ctxt"'=${_zlsh__dev_ctxtU'"$_zlsh__dev_ctxt"'-}\'\
                    "$1"'; fi;' && shift || return 1; done; }

        # NOTE: A context-global only shadows a true-global, it cannot shadow
        #       another context variable.
        _zlsh__dev_ctxt_global () {  # [vname ...]
            while [ $# -gt 0 ]; do eval\
                'if [ "${_zlsh__dev_ctxtG'"$1"'+x}" ]; then shift && continue;'\
                'else _zlsh__dev_ctxtG'"$1"'=;'\
                    '_zlsh__dev_ctxtU1=${_zlsh__dev_ctxtU1-}\ _zlsh__dev_ctxtG'"$1"'; fi;'\
                'if [ "${'"$1"'+x}" ]; then'\
                    '_zlsh__dev_ctxtR1_'"$1"'=$'"$1"';'\
                    '_zlsh__dev_ctxtR1=${_zlsh__dev_ctxtR1-}'"$1"'=\$_zlsh__dev_ctxtR1_'"$1"'\;;'\
                    '_zlsh__dev_ctxtU1=${_zlsh__dev_ctxtU1-}\ _zlsh__dev_ctxtR1_'"$1"';'\
                'else _zlsh__dev_ctxtU1=${_zlsh__dev_ctxtU1-}\ '"$1"'; fi' &&\
                shift || return 1; done; }

        _zlsh__dev_ctxt_pop () {
            eval 'if [ "${_zlsh__dev_ctxtR'"$_zlsh__dev_ctxt"':+x}" ];'\
                'then eval "$_zlsh__dev_ctxtR'"$_zlsh__dev_ctxt"'";'   \
                    'unset -v _zlsh__dev_ctxtR'"$_zlsh__dev_ctxt"'; fi;'\
                'if [ "${_zlsh__dev_ctxtU'"$_zlsh__dev_ctxt"':+x}" ];' \
                'then eval unset -v _zlsh__dev_ctxtU'"$_zlsh__dev_ctxt"\
                    '"$_zlsh__dev_ctxtU'"$_zlsh__dev_ctxt"'"; fi' &&\
            _zlsh__dev_ctxt=$((_zlsh__dev_ctxt - 1))                    && \
            if [ "$_zlsh__dev_ctxt" -eq 0 ]; then _zlsh__dev_ctxt_reset; fi; }
    }; }
_zlsh__dev_ctxt_reset

#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
# shellcheck disable=2317
_zlsh_chk__dev_ctxt () {
    _zlsh_chk__dev_ctxt_A=0
    _zlsh_chk__dev_ctxt_B=0
    _zlsh_chk__dev_ctxt_C=0
    unset -v _zlsh_chk__dev_ctxt_D _zlsh_chk__dev_ctxt_E

    # Check:
    # - no pollution outside any context,
    # - state machine blocks illegal ops.
    _zlsh_chk__dev_ctxt_is_clear () {  # ctxt_depth
        # shellcheck disable=2015
        if [ "$1" -gt 0 ]
        then for _zlsh_chk__dev_ctxt_is_clear in\
                    _zlsh__dev_ctxt                          \
                    _zlsh__dev_ctxt_U${1}                     \
                    _zlsh__dev_ctxt_R${1}                      \
                    _zlsh__dev_ctxt_R${1}__zlsh__chk__dev_ctxt_B\
                    _zlsh__dev_ctxt_R${1}__zlsh__chk__dev_ctxt_C \
                    _zlsh__dev_ctxt_G${1}__zlsh__chk__dev_ctxt_B  \
                    _zlsh_chk__dev_ctxt_D                     \
                    _zlsh_chk__dev_ctxt_E                      \
                    _zlsh__dev_ctxt_R${1}__zlsh__chk__dev_ctxt_D\
                    _zlsh__dev_ctxt_R${1}__zlsh__chk__dev_ctxt_E \
                    _zlsh__dev_ctxt_G${1}__zlsh__chk__dev_ctxt_D  \

            do eval '! [ "${'"$_zlsh_chk__dev_ctxt_is_clear"'+x}" ]' || return 1
            done; _zlsh_chk__dev_ctxt_is_clear $(("$1" - 1))
        else { _zlsh__dev_ctxt_global _zlsh_chk__dev_ctxt_B 2>/dev/null\
                && return 1 || [ $? -eq 64 ]; } &&\
             { _zlsh__dev_ctxt_local  _zlsh_chk__dev_ctxt_C 2>/dev/null\
                && return 1 || [ $? -eq 64 ]; }; fi; }

    # Check:
    # - ctxt-local and ctxt-global behavior in nested contexts.
    _zlsh_chk__dev_ctxt_test () {
        _zlsh__dev_with_ctxt _zlsh_chk__dev_ctxt_test_wrk $(("$1" - 1)); }
    _zlsh_chk__dev_ctxt_test_wrk () {
        _zlsh__dev_ctxt_global _zlsh_chk__dev_ctxt_B _zlsh_chk__dev_ctxt_D &&\
        _zlsh__dev_ctxt_local  _zlsh_chk__dev_ctxt_C _zlsh_chk__dev_ctxt_E && \
        _zlsh_chk__dev_ctxt_A=$((_zlsh_chk__dev_ctxt_A + 1)) &&\
        _zlsh_chk__dev_ctxt_B=$((_zlsh_chk__dev_ctxt_B + 1)) && \
        _zlsh_chk__dev_ctxt_C=$((_zlsh_chk__dev_ctxt_C + 1)) &&  \
        _zlsh_chk__dev_ctxt_D=$(("${_zlsh_chk__dev_ctxt_D:-0}" + 1)) &&\
        _zlsh_chk__dev_ctxt_E=$(("${_zlsh_chk__dev_ctxt_E:-0}" + 1)) && \
        [ "$_zlsh_chk__dev_ctxt_A" -eq "$_zlsh_chk__dev_ctxt_B" ] &&\
        [ "$_zlsh_chk__dev_ctxt_A" -eq "$_zlsh_chk__dev_ctxt_C" ] && \
        [ "$_zlsh_chk__dev_ctxt_A" -eq "$_zlsh_chk__dev_ctxt_D" ] &&  \
        [ "$_zlsh_chk__dev_ctxt_A" -eq "$_zlsh_chk__dev_ctxt_E" ] &&   \
        if [ "$1" -gt 0 ]; then
            _zlsh_chk__dev_ctxt_test "$1"                             &&\
            [ "$_zlsh_chk__dev_ctxt_A" -eq "$_zlsh_chk__dev_ctxt_B" ] && \
            [ "$_zlsh_chk__dev_ctxt_A" -eq "$_zlsh_chk__dev_ctxt_D" ] &&  \
            [ "$_zlsh_chk__dev_ctxt_A" -gt "$_zlsh_chk__dev_ctxt_C" ] &&   \
            [ "$_zlsh_chk__dev_ctxt_A" -gt "$_zlsh_chk__dev_ctxt_E" ]; fi; }

    # Run the checks.
    _zlsh_chk__dev_ctxt_is_clear   3   &&\
    _zlsh_chk__dev_ctxt_test       3   && \
    [ "$_zlsh_chk__dev_ctxt_A" -eq 3 ] &&  \
    [ "$_zlsh_chk__dev_ctxt_B" -eq 0 ] &&   \
    [ "$_zlsh_chk__dev_ctxt_C" -eq 0 ] &&    \
    _zlsh_chk__dev_ctxt_is_clear   3   &&     \
    _zlsh_chk__dev_ctxt_A=0            &&\
    _zlsh_chk__dev_ctxt_test       2   && \
    [ "$_zlsh_chk__dev_ctxt_A" -eq 2 ] &&  \
    [ "$_zlsh_chk__dev_ctxt_B" -eq 0 ] &&   \
    [ "$_zlsh_chk__dev_ctxt_C" -eq 0 ] &&    \
    _zlsh_chk__dev_ctxt_is_clear   3   &&     \

    unset -v _zlsh_chk__dev_ctxt_A _zlsh_chk__dev_ctxt_B _zlsh_chk__dev_ctxt_C\
          _zlsh_chk__dev_ctxt_is_clear &&\
    unset -f _zlsh_chk__dev_ctxt_is_clear _zlsh_chk__dev_ctxt_test\
          _zlsh_chk__dev_ctxt_test_wrk; }

#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk__dev () {
    # On failure:
    # - `_zlsh_chk__dev` will be set.

    # shellcheck disable=2043
    for _zlsh_chk__dev\
    in  _zlsh_chk__dev_ctxt\

    do  eval "$_zlsh_chk__dev" || return 1
    done && unset -v _zlsh_chk__dev; }
