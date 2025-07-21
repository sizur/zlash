# shellcheck disable=2016

# Zlash dev-env section dependencies. (stripped on release)
_zlsh__dev_load\
    init_sanity \
    || return 1

###############################################################################
#/ Core Validators
#
_ZLSH_TOPIC_about_core_validators='about core validators

These are the first and required line of defense for input. More advanced
checking assumes values have already passed one or more of these, as required.
Every public function should use at least them to validate its inputs.

`zlash_str_*` VS `zlash_var_*`
==============================

`zlash_str_*` functions validate direct string value arguments:

```bash
if zlash_str_is_digits "123"; then ...
```

or

```bash
var="123"
if zlash_str_is_digits "$var"; then ...
```

The `zlash_var_*` variants validate values stored in variables provided by name
as argument. They exist for reference ergonomics:

```bash
var="123"
ref=var
if zlash_str_is_var_is_digits "$ref"; then ...
```

When not dealing with references, `zlash_str_*` variants are generally
preferred. That is, instead of:

```bash
if zlash_str_is_var_is_digits var; then ...
```

For not large values of `var`, the following will be better:

```bash
if zlash_str_is_digits "$var"; then ...
```

If `var` will commonly contain large strings -- then benchmarks should guide
which to use -- if performance critical.

Why two variants / Why not dynamic dispatch?
--------------------------------------------

The most important reason is that, without adding a second argument everywhere,
there is no way to disambiguate intent when a string is a valid identifier,
regardless of type (variable/function/alias) and state (set/unset) of the
identifier.

Secondary is performance. Since all public functions must validate their inputs,
the avoidable overhead a dynamic dispatch of validators would require
(conditionals and not inlined inner calls) may add up to a significant
performance impact.

' # TODO: Write more about core validators.

# NOTE:
#   TLDR: `*_as_*` assumes, `*_is_*` verifies.
#
#   Private functions (`_zlsh_*`) perform no validation -- they only implement
#   their core logic. Only `_zlsh_str_*` are safe to call with arbitrary input.
#   All other private functions must never be entry points for any unvalidated
#   data (any I/O, including interactive commands).
#
#   All unvalidated input must enter only through public functions. Public
#   functions -- whether lower-level (`zlash_*`) or higher-level (`Verb_Noun`,
#   `Zlash*`, user-defined Zlash advanced functions, and public interfaces of
#   Zlash objects) -- always perform full validation and assume nothing.
#
#   Once validated, data may be freely composed using private functions, without
#   redundant checks, in current execution context or `(...)` subshells.
#
#   Developers are responsible for revalidation when invariants may be violated,
#   including cases where inert data may become unsafe again. Some common cases
#   requiring dev's attention to keep in mind:
#
#       - `eval`s (**especially** nested)
#       - `read`s
#       - external environment variables
#       - operations on strings that have already been validated (or made
#         inert via Zlash quoting functions), like:
#           - concatenation
#           - substring extraction
#           - partial replacement
#       - I/O reintroduction, like:
#           - piping
#           - redirections
#           - command substitutions
#           - process substitutions

# NOTE: Character classes are `LC_CTYPE`-dependent, and character ranges are
#    `LC_COLLATE`-dependent. We can't afford subshell performance penalty in
#    each validator, and there is no reliable and portable alternative to
#    restoring a modified variable, that is also simple. More complex solutions
#    require validators already, so we are left with the only available option
#    for portable core validators: spelling out the ASCII patterns for character
#    classes under `LC_ALL=C`.
#
#    [:digits:]  = [0123456789]
#    [:xdigits:] = [0123456789abcdefABCDEF]
#    [:alpha:]   = [abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]
#    [:alnum:]=[0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]

#------------------------------------------------------------------------------
#, zlash_str_is_digits
_ZLSH_TOPIC_zlash_str_is_digits='is a string only decimal digits?

Succeeds if the supplied argument contains only decimal digits and is not empty.
'
_ZLSH_USAGE_zlash_str_is_digits='Usage

zlash_str_is_digits str
'
_ZLSH_PARAMS_zlash_str_is_digits='Parameters

1. *str*
   : Raw string needing validation.
'
zlash_str_is_digits() {
    if [ $# -eq 1 ]; then _zlsh_str_is_digits "$1"
    else   _zlsh_usage    zlash_str_is_digits && return 64; fi; }
_zlsh_str_is_digits() {
    [ "${1:+x}" ] && case $1 in
        *[!0123456789]*) return 1;; *) return 0; esac; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_str_is_digits() {
    for _zlsh_chk_str_is_digits in '0123456789' '0'
    do zlash_str_is_digits "$_zlsh_chk_str_is_digits" || return 1
    done &&\
    for _zlsh_chk_str_is_digits in '' ' ' '-1' '.1' '0.' '0.1' 'a' ' 1' '1 '
    do ! zlash_str_is_digits "$_zlsh_chk_str_is_digits" || return 1
    done && unset -v _zlsh_chk_str_is_digits; }

#------------------------------------------------------------------------------
#, zlash_str_is_var_is_digits
_ZLSH_TOPIC_zlash_str_is_var_is_digits='is a variable only decimal digits?

Succeeds if the supplied argument is a variable containing only decimal digits
and is not empty.
'
_ZLSH_USAGE_zlash_str_is_var_is_digits='Usage

zlash_str_is_var_is_digits var
'
_ZLSH_PARAMS_zlash_str_is_var_is_digits='Parameters

1. *var*
   : Name of a variable containing a raw string needing validation.
'
zlash_str_is_var_is_digits() {
    if [ $# -eq 1 ]; then _zlsh_str_is_var_is_digits "$1"
    else   _zlsh_usage    zlash_str_is_var_is_digits && return 64; fi; }
_zlsh_str_is_var_is_digits() {
    [ "${1:+x}" ] && case $1 in
        [!_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*|*[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)
            return 1;;
        *) eval '[ "${'"$1"':+x}" ] && case $'"$1"\
            'in *[!0123456789]*) return 1;; *) return 0; esac'; esac; }
_zlsh_str_as_var_is_digits() {  # NOTE: ASSUMPTION: str is var.
    eval '[ "${'"$1"':+x}" ] && case $'"$1"\
       'in *[!0123456789]*) return 1;; *) return 0; esac'; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_var_is_digits() {
    for _zlsh_chk_var_is_digits in '0123456789' '0'
    do  zlash_str_is_var_is_digits _zlsh_chk_var_is_digits &&\
        _zlsh_str_as_var_is_digits _zlsh_chk_var_is_digits || return 1
    done &&\
    for _zlsh_chk_var_is_digits in\
                '' ' ' '-1' '.1' '0.' '0.1' 'a' ' 1' '1 '
    do  ! zlash_str_is_var_is_digits _zlsh_chk_var_is_digits &&\
        ! _zlsh_str_as_var_is_digits _zlsh_chk_var_is_digits || return 1
    done && unset -v _zlsh_chk_var_is_digits; }

#------------------------------------------------------------------------------
#, zlash_str_is_xdigits
_ZLSH_TOPIC_zlash_str_is_xdigits='is a string only hexadecimal digits?

Succeeds if the supplied argument contains only hexadecimal digits and is not
empty.
'
_ZLSH_USAGE_zlash_str_is_xdigits='Usage

zlash_str_is_xdigits str
'
_ZLSH_PARAMS_zlash_str_is_xdigits='Parameters

1. *str*
   : Raw string needing validation.
'
zlash_str_is_xdigits() {
    if [ $# -eq 1 ]; then _zlsh_str_is_xdigits "$1"
    else   _zlsh_usage    zlash_str_is_xdigits && return 64; fi; }
_zlsh_str_is_xdigits() {
    [ "${1:+x}" ] && case $1 in
        *[!0123456789abcdefABCDEF]*) return 1;;
        *) return 0; esac; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_str_is_xdigits() {
    for _zlsh_chk_str_is_xdigits in '0123456789abcdefABCDEF' '0'
    do zlash_str_is_xdigits "$_zlsh_chk_str_is_xdigits" || return 1
    done &&\
    for _zlsh_chk_str_is_xdigits in\
        '-1' '.1' '0.' '0.1' 'g' 'G' ' 1' '1 ' ' ' ''
    do ! zlash_str_is_xdigits "$_zlsh_chk_str_is_xdigits" || return 1
    done && unset -v _zlsh_chk_str_is_xdigits; }

#------------------------------------------------------------------------------
#, zlash_str_is_var_is_xdigits
_ZLSH_TOPIC_zlash_str_is_var_is_xdigits='is a variable only hexadecimal digits?

Succeeds if the supplied variable contains only hexadecimal digits and is not
empty.
'
_ZLSH_USAGE_zlash_str_is_var_is_xdigits='Usage

zlash_str_is_var_is_xdigits var
'
_ZLSH_PARAMS_zlash_str_is_var_is_xdigits='Parameters

1. *var*
   : Name of a variable containing a raw string needing validation.
'
zlash_str_is_var_is_xdigits() {
    if [ $# -eq 1 ]; then _zlsh_str_is_var_is_xdigits "$1"
    else   _zlsh_usage    zlash_str_is_var_is_xdigits && return 64; fi; }
_zlsh_str_is_var_is_xdigits() {
    [ "${1:+x}" ] && case $1 in
        [!_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*|*[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)
            return 1;;
        *) eval '[ "${'"$1"':+x}" ] && case $'"$1"\
            'in *[!0123456789abcdefABCDEF]*) return 1;; *) return 0; esac'
    esac; }
_zlsh_str_as_var_is_xdigits() {  # NOTE: ASSUMPTION: str is var.
    eval '[ "${'"$1"':+x}" ] && case $'"$1"\
        'in *[!0123456789abcdefABCDEF]*) return 1;; *) return 0; esac'; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_var_is_xdigits() {
    for _zlsh_chk_var_is_xdigits in '0123456789abcdefABCDEF' '0'
    do zlash_str_is_var_is_xdigits _zlsh_chk_var_is_xdigits &&\
       _zlsh_str_as_var_is_xdigits _zlsh_chk_var_is_xdigits || return 1
    done &&\
    for _zlsh_chk_var_is_xdigits in\
            '' ' ' '-1' '.1' '0.' '0.1' 'g' 'G' ' 1' '1 '
    do  ! zlash_str_is_var_is_xdigits _zlsh_chk_var_is_xdigits &&\
        ! _zlsh_str_as_var_is_xdigits _zlsh_chk_var_is_xdigits || return 1
    done && unset -v _zlsh_chk_var_is_xdigits; }

#------------------------------------------------------------------------------
#  zlash_str_is_vname_sfx
_ZLSH_TOPIC_zlash_str_is_vname_sfx='is a string a valid variable name suffix?

Succeeds if a raw string is suitable to be used as a variable name suffix. That
is, only containing characters from the class `[_0-9a-zA-Z]` under `LC_ALL=C`.
'
_ZLSH_USAGE_zlash_str_is_vname_sfx='Usage

zlash_str_is_vname_sfx str
'
_ZLSH_PARAMS_zlash_str_is_vname_sfx='Parameters

1. *str*
   : Raw string needing validation.
'
zlash_str_is_vname_sfx() {
    if [ $# -eq 1 ]; then _zlsh_str_is_vname_sfx "$1"
    else   _zlsh_usage    zlash_str_is_vname_sfx && return 64; fi;}
_zlsh_str_is_vname_sfx() {
    [ "${1:+x}" ] && case $1 in\
        *[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)
            return 1;;
        *)  return 0; esac; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_str_is_vname_sfx() {
    for _zlsh_chk_str_is_vname_sfx in '0O_' '_' 'a'
    do _zlsh_str_is_vname_sfx "$_zlsh_chk_str_is_vname_sfx" || return 1
    done && for _zlsh_chk_str_is_vname_sfx in\
            '' ' ' 'a b' 'a ' ' a' '$a' '\a' '"a"' "'a'" '`a`'
    do ! _zlsh_str_is_vname_sfx "$_zlsh_chk_str_is_vname_sfx" || return 1
    done && unset -v _zlsh_chk_str_is_vname_sfx; }

#------------------------------------------------------------------------------
#, zlash_str_is_var_is_vname_sfx
_ZLSH_TOPIC_zlash_str_is_var_is_vname_sfx='is variable a valid varname suffix?

Succeeds if a variable contains a raw string that is suitable to be used as a
variable name suffix. That is, only containing characters from the class
`[_0-9a-zA-Z]` under `LC_ALL=C`.
'
_ZLSH_USAGE_zlash_str_is_var_is_vname_sfx='Usage

zlash_str_is_var_is_vname_sfx var
'
_ZLSH_PARAMS_zlash_str_is_var_is_vname_sfx='Parameters

1. *var*
   : Variable containing a string needing validation.
'
zlash_str_is_var_is_vname_sfx() {
    if [ $# -eq 1 ]; then _zlsh_str_is_var_is_vname_sfx "$1"
    else   _zlsh_usage    zlash_str_is_var_is_vname_sfx && return 64; fi; }
_zlsh_str_is_var_is_vname_sfx() {
    [ "${1:+x}" ] && case $1 in
        [!_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*|*[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)
            return 1;;
        *) eval '[ "${'"$1"':+x}" ] && case $'"$1"\
            'in *[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)'\
                'return 1;; *) return 0; esac'; esac; }
_zlsh_str_as_var_is_vname_sfx() {  # NOTE: ASSUMPTION: str is var
    eval '[ "${'"$1"':+x}" ] && case $'"$1"\
        'in *[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)'\
            'return 1;; *) return 0; esac'; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_var_is_vname_sfx() {
    for _zlsh_chk_var_is_vname_sfx in '0O_' '_' 'a'
    do  zlash_str_is_var_is_vname_sfx _zlsh_chk_var_is_vname_sfx &&\
        _zlsh_str_as_var_is_vname_sfx _zlsh_chk_var_is_vname_sfx || return 1
    done &&\
    for _zlsh_chk_var_is_vname_sfx in\
            '' ' ' 'a b' 'a ' ' a' '$a' '\a' '"a"' "'a'" '`a`'
    do  ! zlash_str_is_var_is_vname_sfx _zlsh_chk_var_is_vname_sfx &&\
        ! _zlsh_str_as_var_is_vname_sfx _zlsh_chk_var_is_vname_sfx || return 1
    done && unset -v _zlsh_chk_var_is_vname_sfx; }

#------------------------------------------------------------------------------
#, zlash_str_is_vname
_ZLSH_TOPIC_zlash_str_is_vname='is string a valid name for a variable?

Succeeds if a string is suitable to be used as a variable name. That is, only
containing characters from the class `[_0-9a-zA-Z]` under `LC_ALL=C`, with
additional constraint on the first character not being numeric.
'
_ZLSH_USAGE__zlash_str_is_vname='Usage

zlash_str_is_vname str
'
_ZLSH_PARAMS_zlash_str_is_vname='Parameters

1. *str*
   : Raw string needing validation.
'
zlash_str_is_vname() {
    if [ $# -eq 1 ]; then _zlsh_str_is_vname "$1"
    else _zlsh_usage zlash_str_is_vname && return 64; fi; }
_zlsh_str_is_vname() {
    [ "${1:+x}" ] && case $1 in
        [!_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*|*[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)
            return 1;;
        *)  return 0; esac; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_str_is_vname() {
    for _zlsh_chk_str_is_vname in '_0O' '_'
    do zlash_str_is_vname "$_zlsh_chk_str_is_vname" || return 1; done &&\
    for _zlsh_chk_str_is_vname in\
                '' ' ' '0a' 'a b' 'a ' ' a' '$a' '\a' '"a"' "'a'" '`a`'
    do ! zlash_str_is_vname "$_zlsh_chk_str_is_vname" || return 1
    done && unset -v _zlsh_chk_str_is_vname; }

#------------------------------------------------------------------------------
#, zlash_str_is_var_is_vname
_ZLSH_TOPIC_zlash_str_is_var_is_vname='is variable a valid variable name?

Validates that a variable contains a string that is suitable to be used as a
variable name. That is, only containing characters from the class `[_0-9a-zA-Z]`
under `LC_ALL=C`, with additional constraint on the first character not being
numeric.
'
_ZLSH_USAGE__zlash_str_is_var_is_vname='Usage

zlash_str_is_var_is_vname var
'
_ZLSH_PARAMS_zlash_str_is_var_is_vname='Parameters

1. *var*
   : Variable containing a string needing validation.
'
zlash_str_is_var_is_vname() {
    if [ $# -eq 1 ]; then _zlsh_str_is_var_is_vname "$1"
    else   _zlsh_usage    zlash_str_is_var_is_vname && return 64; fi; }
_zlsh_str_is_var_is_vname() {
    [ "${1:+x}" ] && case $1 in
        [!_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*|*[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)
            return 1;;
        *) eval '[ "${'"$1"':+x}" ] && case $'"$1"\
            'in [!_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*|*[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)'\
                'return 1;; *) return 0; esac'
    esac; }
_zlsh_str_as_var_is_vname() {  # NOTE: ASSUMPTION: str is var
    eval '[ "${'"$1"':+x}" ] && case $'"$1"\
         'in [!_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*|*[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)'\
            'return 1;; *) return 0; esac'; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_var_is_vname() {
    for _zlsh_chk_var_is_vname in '_0O' '_'
    do  zlash_str_is_var_is_vname _zlsh_chk_var_is_vname &&\
        _zlsh_str_as_var_is_vname _zlsh_chk_var_is_vname || return 1; done &&\
    for _zlsh_chk_var_is_vname in\
                '' ' ' '0a' 'a b' 'a ' ' a' '$a' '\a' '"a"' "'a'" '`a`'
    do  ! zlash_str_is_var_is_vname _zlsh_chk_var_is_vname &&\
        ! _zlsh_str_as_var_is_vname _zlsh_chk_var_is_vname || return 1
    done && unset -v _zlsh_chk_var_is_vname; }

# NOTE: The portable fallbacks for function name validation have identical
#       implementations as variable name validation. However, shell-specific
#       specializations will differ.
#------------------------------------------------------------------------------
#, zlash_str_is_fname_sfx
_ZLSH_TOPIC_zlash_str_is_fname_sfx='is string a valid function name suffix?

'  # TODO
_ZLSH_USAGE__zlash_str_is_fname_sfx='Usage

zlash_str_is_fname_sfx str
'
_ZLSH_PARAMS_zlash_str_is_fname_sfx='Parameters

1. *str*
   : Raw string needing validation.
'
zlash_str_is_fname_sfx() {
    if [ $# -eq 1 ]; then _zlsh_str_is_fname_sfx "$1"
    else   _zlsh_usage    zlash_str_is_fname_sfx && return 64; fi; }
_zlsh_str_is_fname_sfx() {
    [ "${1:+x}" ] && case $1 in
        *[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)
            return 1;;
        *)  return 0; esac; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_str_is_fname_sfx() {
    for _zlsh_chk_str_is_fname_sfx in '0O_' '_'
    do zlash_str_is_fname_sfx "$_zlsh_chk_str_is_fname_sfx" || return 1
    done && for _zlsh_chk_str_is_fname_sfx in\
                '' ' ' 'a b' 'a ' ' a' '$a' '\a' '"a"' "'a'" '`a`'
    do ! zlash_str_is_fname_sfx "$_zlsh_chk_str_is_fname_sfx" || return 1
    done && unset -v _zlsh_chk_str_is_fname_sfx; }

#------------------------------------------------------------------------------
#, zlash_str_is_var_is_fname_sfx
_ZLSH_TOPIC_zlash_str_is_var_is_fname_sfx='is var a valid function name suffix?

'  # TODO
_ZLSH_USAGE__zlash_str_is_var_is_fname_sfx='Usage

zlash_str_is_var_is_fname_sfx var
'
_ZLSH_PARAMS_zlash_str_is_var_is_fname_sfx='Parameters

1. *var*
   : Variable containing a string needing validation.
'
zlash_str_is_var_is_fname_sfx() {
    if [ $# -eq 1 ]; then _zlsh_str_is_var_is_fname_sfx "$1"
    else   _zlsh_usage    zlash_str_is_var_is_fname_sfx && return 64; fi; }
_zlsh_str_is_var_is_fname_sfx() {
    [ "${1:+x}" ] && case $1 in
        [!_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*|*[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)
            return 1;;
        *) eval '[ "${'"$1"':+x}" ] && case $'"$1"\
            'in *[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)'\
                'return 1;; *) return 0; esac'; esac; }
_zlsh_str_as_var_is_fname_sfx() {  # NOTE: ASSUMPTION: str is var
    eval '[ "${'"$1"':+x}" ] && case $'"$1"\
        'in *[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)'\
            'return 1;; *) return 0; esac'; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_var_is_fname_sfx() {
    for _zlsh_chk_var_is_fname_sfx in '0O_' '_'
    do  zlash_str_is_var_is_fname_sfx _zlsh_chk_var_is_fname_sfx &&\
        _zlsh_str_as_var_is_fname_sfx _zlsh_chk_var_is_fname_sfx || return 1
    done && for _zlsh_chk_var_is_fname_sfx in\
                '' ' ' 'a b' 'a ' ' a' '$a' '\a' '"a"' "'a'" '`a`'
    do  ! zlash_str_is_var_is_fname_sfx _zlsh_chk_var_is_fname_sfx &&\
        ! _zlsh_str_as_var_is_fname_sfx _zlsh_chk_var_is_fname_sfx || return 1
    done && unset -v _zlsh_chk_var_is_fname_sfx; }

#------------------------------------------------------------------------------
#, zlash_str_is_fname
_ZLSH_TOPIC_zlash_str_is_fname='is string a valid function name?

'  # TODO
_ZLSH_USAGE__zlash_str_is_fname='Usage

zlash_str_is_fname str
'
_ZLSH_PARAMS_zlash_str_is_fname='Parameters

1. *str*
   : Raw string needing validation.
'
zlash_str_is_fname() {
    if [ $# -eq 1 ]; then _zlsh_str_is_fname "$1"
    else   _zlsh_usage    zlash_str_is_fname; return 64; fi; }
_zlsh_str_is_fname() {
    [ "${1:+x}" ] && case $1 in
        [!_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*|*[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)
            return 1;;
        *)  return 0; esac; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_str_is_fname() {
    for _zlsh_chk_str_is_fname in 'O0_' '_'
    do zlash_str_is_fname "$_zlsh_chk_str_is_fname" || return 1
    done && for _zlsh_chk_str_is_fname in\
                '0a' 'a b' 'a ' ' a' '$a' '\a' '"a"' "'a'" '`a`'
    do ! zlash_str_is_fname "$_zlsh_chk_str_is_fname" || return 1
    done && unset -v _zlsh_chk_str_is_fname; }

#------------------------------------------------------------------------------
#, zlash_str_is_var_is_fname
_ZLSH_TOPIC_zlash_str_is_var_is_fname='is variable a valid function name?

'
_ZLSH_USAGE__zlash_str_is_var_is_fname='Usage

zlash_str_is_var_is_fname var
'
_ZLSH_PARAMS_zlash_str_is_var_is_fname='Parameters

1. *var*
   : Variable containing a string needing validation.
'
zlash_str_is_var_is_fname() {
    if [ $# -eq 1 ]; then _zlsh_str_is_var_is_fname "$1"
    else   _zlsh_usage    zlash_str_is_var_is_fname; return 64; fi; }
_zlsh_str_is_var_is_fname() {
    [ "${1:+x}" ] && case $1 in
        [!_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*|*[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)
            return 1;;
        *) eval '[ "${'"$1"':+x}" ] && case $'"$1"\
            'in [!_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*|*[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)'\
            'return 1;; *) return 0; esac'
    esac; }
_zlsh_str_as_var_is_fname() {  # NOTE: ASSUMPTION: str is var
    eval '[ "${'"$1"':+x}" ] && case $'"$1"\
        'in [!_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*|*[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)'\
            'return 1;; *) return 0; esac'; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_var_is_fname() {
    for _zlsh_chk_var_is_fname in 'O0_' '_'
    do  zlash_str_is_var_is_fname _zlsh_chk_var_is_fname &&\
        _zlsh_str_as_var_is_fname _zlsh_chk_var_is_fname || return 1
    done && for _zlsh_chk_var_is_fname in\
                '' ' ' '0a' 'a b' 'a ' ' a' '$a' '\a' '"a"' "'a'" '`a`'
    do  ! zlash_str_is_var_is_fname _zlsh_chk_var_is_fname &&\
        ! _zlsh_str_as_var_is_fname _zlsh_chk_var_is_fname || return 1
    done && unset -v _zlsh_chk_var_is_fname; }

#------------------------------------------------------------------------------
#, zlash_str_is_var_exists
_ZLSH_TOPIC_zlash_str_is_var_exists='is string a defined variable?

Succeeds if a provided name is a defined variable, even if empty.
'
_ZLSH_USAGE__zlash_str_is_var_exists='Usage

zlash_str_is_var_exists var
'
_ZLSH_PARAMS_zlash_str_is_var_exists='Parameters

1. *var*
   : Variable name.
'
zlash_str_is_var_exists() {
    if [ $# -eq 1 ]; then _zlsh_str_is_var_exists "$1"
    else   _zlsh_usage    zlash_str_is_var_exists; return 64; fi; }
_zlsh_str_is_var_exists() {
    [ "${1:+x}" ] && case $1 in
        [!_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*|*[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)
            return 1;;
        *) eval '[ "${'"$1"'+x}" ]'; esac; }
_zlsh_str_as_var_exists() {  # NOTE: ASSUMPTION: str is var
    eval '[ "${'"$1"'+x}" ]'; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_str_is_var_exists() {
    unset -v _ZLSH_DONOTSETME ||:
    ! zlash_str_is_var_exists _ZLSH_DONOTSETME &&\
    ! _zlsh_str_as_var_exists _ZLSH_DONOTSETME && \
    _ZLSH_DONOTSETME=notempty                  &&\
    zlash_str_is_var_exists   _ZLSH_DONOTSETME && \
    _zlsh_str_as_var_exists   _ZLSH_DONOTSETME &&  \
    unset -v _ZLSH_DONOTSETME                  &&\
    ! zlash_str_is_var_exists _ZLSH_DONOTSETME && \
    ! _zlsh_str_as_var_exists _ZLSH_DONOTSETME &&  \
    _ZLSH_DONOTSETME=                          &&\
    zlash_str_is_var_exists   _ZLSH_DONOTSETME && \
    _zlsh_str_as_var_exists   _ZLSH_DONOTSETME &&  \
    unset -v _ZLSH_DONOTSETME; }

#------------------------------------------------------------------------------
#, zlash_str_is_var_notempty
_ZLSH_TOPIC_zlash_str_is_var_notempty='is string a not empty variable?

Succeeds if a provided string is a defined and not empty variable.
'
_ZLSH_USAGE_zlash_str_is_var_notempty='Usage

zlash_str_is_var_notempty var
'
_ZLSH_PARAMS_zlash_str_is_var_notempty='Parameters

1. *var*
   : Variable name.
'
zlash_str_is_var_notempty() {
    if [ $# -eq 1 ]; then _zlsh_str_is_var_notempty "$1"
    else   _zlsh_usage    zlash_str_is_var_notempty; return 64; fi; }
_zlsh_str_is_var_notempty() {
    [ "${1:+x}" ] && case $1 in
        [!_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*|*[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)
            return 1;;
        *) eval '[ "${'"$1"':+x}" ]'; esac; }
_zlsh_str_as_var_notempty() {  # NOTE: ASSUMPTION: str is var
    eval '[ "${'"$1"':+x}" ]'; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_str_is_var_notempty() {
    unset -v _ZLSH_DONOTSETME ||:
    ! zlash_str_is_var_notempty _ZLSH_DONOTSETME &&\
    ! _zlsh_str_as_var_notempty _ZLSH_DONOTSETME && \
    _ZLSH_DONOTSETME=notempty                    &&\
    zlash_str_is_var_notempty _ZLSH_DONOTSETME   && \
    _zlsh_str_as_var_notempty _ZLSH_DONOTSETME   &&  \
    unset -v _ZLSH_DONOTSETME                    &&\
    ! zlash_str_is_var_notempty _ZLSH_DONOTSETME && \
    ! _zlsh_str_as_var_notempty _ZLSH_DONOTSETME &&  \
    _ZLSH_DONOTSETME=                            &&\
    ! zlash_str_is_var_notempty _ZLSH_DONOTSETME && \
    ! _zlsh_str_as_var_notempty _ZLSH_DONOTSETME &&  \
    unset -v _ZLSH_DONOTSETME; }

#------------------------------------------------------------------------------
#, zlash_str_is_vref
_ZLSH_TOPIC_zlash_str_is_vref='is variable referencing a defined variable?

Succeeds if a provided variable is a reference to a defined variable.
'
_ZLSH_USAGE__zlash_str_is_vref='Usage

zlash_str_is_vref ref
'
_ZLSH_PARAMS_zlash_str_is_vref='Parameters

1. *ref*
   : Name of a reference to validate.
'
zlash_str_is_vref() {
    if [ $# -eq 1 ]; then _zlsh_str_is_vref "$1"
    else   _zlsh_usage    zlash_str_is_vref; return 64; fi; }
_zlsh_str_is_vref() {
    # NOTE: Yes, the double-eval is unfortunately needed under POSIX compliance,
    #       whether hidden under `str_is_var_exists` or inline, as it is here.
    [ "${1:+x}" ] && case $1 in
        [!_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*|*[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)
            return 1;;
        *) eval '[ "${'"$1"':+x}" ] && case $'"$1"         \
            'in [!_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*|*[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)'\
                'return 1;; *) eval "[ \${$'"$1"'+x} ]"; esac'; esac; }
_zlsh_str_as_var_is_vref() {  # NOTE: ASSUMPTION: str is var
    eval '[ "${'"$1"':+x}" ] && case $'"$1"            \
        'in [!_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*|*[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)'\
            'return 1;; *) eval "[ \${$'"$1"'+x} ]"; esac'; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_str_is_vref() {
    unset -v _ZLSH_DONOTSETME              ||:
    _zlsh_chk_str_is_vref=_ZLSH_DONOTSETME &&\
    ! zlash_str_is_var_exists "$_zlsh_chk_str_is_vref" &&\
    ! zlash_str_is_vref         _zlsh_chk_str_is_vref  && \
    ! _zlsh_str_as_var_is_vref  _zlsh_chk_str_is_vref  &&  \
    _ZLSH_DONOTSETME=notempty                          &&\
    zlash_str_is_var_exists "$_zlsh_chk_str_is_vref"   && \
    zlash_str_is_vref         _zlsh_chk_str_is_vref    &&  \
    _zlsh_str_as_var_is_vref  _zlsh_chk_str_is_vref    &&   \
    unset -v _ZLSH_DONOTSETME                          &&\
    ! zlash_str_is_var_exists "$_zlsh_chk_str_is_vref" &&\
    ! zlash_str_is_vref         _zlsh_chk_str_is_vref  && \
    ! _zlsh_str_as_var_is_vref  _zlsh_chk_str_is_vref  &&  \
    _ZLSH_DONOTSETME=                                  &&\
    zlash_str_is_var_exists "$_zlsh_chk_str_is_vref"   && \
    zlash_str_is_vref         _zlsh_chk_str_is_vref    &&  \
    _zlsh_str_as_var_is_vref  _zlsh_chk_str_is_vref    &&   \
    unset -v _ZLSH_DONOTSETME _zlsh_chk_str_is_vref; }

#------------------------------------------------------------------------------
#, zlash_str_is_fn_undef
#  NOTE: Unfortunately, there is no portable way to test if a function is
#    defined (that test can be done after probing, by shell-specific
#    means). But we can portably test if a function is NOT defined.
_ZLSH_TOPIC_zlash_str_is_fn_undef='is string not a defined function name?

Succeeds if a function is not defined by the provided name.

Failure ***does not imply*** that a function is defined by the provided name. It
only implies that a command by that name exist -- it could be a builtin or an
alias, depending on shell and it'\''s options.
'  # TODO: update the description to reference zlash_is_fun_set, once that's
   #       defined after probing.
_ZLSH_USAGE__zlash_str_is_fn_undef='Usage

zlash_str_is_fn_undef fn
'
_ZLSH_PARAMS_zlash_str_is_fn_undef='Parameters

1. *fn*
   : Name of a function.
'
zlash_str_is_fn_undef() {
    if [ $# -eq 1 ]; then _zlsh_str_is_fn_undef "$1"
    else   _zlsh_usage    zlash_str_is_fn_undef; return 64; fi; }
_zlsh_str_is_fn_undef() {
    [ "${1:+x}" ] && case $1 in
        [!_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*|*[!_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ]*)
            return 1;;
        *)  # Do not subshell when there's no need to subshell.
            if      command -v "$1" 2>/dev/null >/dev/null\
            && [ "$(command -v "$1" 2>/dev/null)" = "$1" ]
            then return 1; else return 0; fi; esac; }
_zlsh_str_as_fn_undef() {  # NOTE: ASSUMPTION: str is fname
    # Do not subshell when there's no need to subshell.
    if      command -v "$1"  >/dev/null 2>&1\
    && [ "$(command -v "$1" 2>/dev/null)" = "$1" ]
    then return 1; else return 0; fi; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_str_is_fn_undef() {
    unset -f _ZLSH_DONOTSETME 2>/dev/null ||:
    !   zlash_str_is_fn_undef zlash_str_is_fn_undef &&\
        zlash_str_is_fn_undef _ZLSH_DONOTSETME      && \
        _zlsh_str_as_fn_undef _ZLSH_DONOTSETME      &&  \
        _ZLSH_DONOTSETME() { # shellcheck disable=2317
            :; }                               &&\
    !   zlash_str_is_fn_undef _ZLSH_DONOTSETME && \
    !   _zlsh_str_as_fn_undef _ZLSH_DONOTSETME &&  \
        unset -f _ZLSH_DONOTSETME              &&\
        zlash_str_is_fn_undef _ZLSH_DONOTSETME && \
        _zlsh_str_as_fn_undef _ZLSH_DONOTSETME; }

#------------------------------------------------------------------------------
#, zlash_var_eq_var
_ZLSH_TOPIC_zlash_var_eq_var='are variable contents string-equal?

Succeeds if contents of one variable string-equal contents of another variable.
'
_ZLSH_USAGE_zlash_var_eq_var='Usage

zlash_var_eq_var var var
'
_ZLSH_PARAMS_zlash_var_eq_var='Parameters

1. *var*
   : Name of a first variable containing a string.
2. *var*
   : Name of a second variable containing a string.
'
zlash_var_eq_var() {
    if  case $# in
            2)  _zlsh_str_is_var_exists "$1" &&\
                     _zlsh_str_is_var_exists "$2" ;;
            *)  false; esac
    then _zlsh_var_eq_var "$1" "$2"
    else _zlsh_usage zlash_var_eq_var; return 64; fi; }
_zlsh_var_eq_var() { eval '[ "$'"$1"'" = "$'"$2"'" ]'; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_var_eq_var() {
    _zlsh_chk_var_eq_var_2=2 &&\
        for _zlsh_chk_var_eq_var in '1' ''; do
            zlash_var_eq_var   _zlsh_chk_var_eq_var _zlsh_chk_var_eq_var   &&\
            ! zlash_var_eq_var _zlsh_chk_var_eq_var _zlsh_chk_var_eq_var_2 || \
                                                                        return 1
        done       &&        _zlsh_chk_var_eq_var=2                  &&\
        zlash_var_eq_var _zlsh_chk_var_eq_var _zlsh_chk_var_eq_var_2 && \
        unset -v _zlsh_chk_var_eq_var _zlsh_chk_var_eq_var_2; }

#------------------------------------------------------------------------------
#, zlash_usage
_ZLSH_TOPIC_zlash_usage='show usage of a function

Output usage of a function to STDERR.
'
_ZLSH_USAGE_zlash_usage='Usage

zlash_usage fn
'
_ZLSH_PARAMS_zlash_usage='Parameters

1. *fn*
   : Name of a function.
'
_ZLSH_EXIT_zlash_usage='Exit Code

 0   Success
>0   Error
64   Usage Error
'
zlash_usage () {
    if  case $# in
            1) ! _zlsh_str_is_fn_undef "$1" ;;
            *)   false; esac
    then _zlsh_usage "$1"
    else _zlsh_usage zlash_usage; return 64; fi; }
_zlsh_usage () {
    if _zlsh_str_is_var_notempty "_ZLSH_TOPIC_$1"; then
        eval '>&2 printf \\n\#\ \`%s\`\ -\ %s\\n "$1" "$'"_ZLSH_TOPIC_$1"'"'
        for _zlsh_usage in USAGE PARAMS
        do if _zlsh_str_is_var_notempty "_ZLSH_${_zlsh_usage}_$1"
           then eval '>&2 printf \#\#\ %s\\n'\
                '"$'"_ZLSH_${_zlsh_usage}_$1"'"' || return 1; fi
        done && unset -v _zlsh_usage &&\
        if _zlsh_str_is_var_notempty "_ZLSH_EXIT_$1"
        then eval '>&2 printf \#\#\ %s\\n "$'"_ZLSH_EXIT_$1"'"'
        else >&2 printf '## %s\n' "$_ZLSH_EXIT_zlash_usage"; fi
    else >&2 printf 'No documentation for: %s\n' "$1" && return 1; fi; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_usage () {  # shellcheck disable=2015
    2>/dev/null      zlash_usage zlash_usage                \
    && { 2>/dev/null zlash_usage _zlsh_usage || [ $? = 1 ]; }\
    && { 2>/dev/null zlash_usage _ZLSH_DONOTSETME && return 1 || [ $? = 64 ]; }
}

#------------------------------------------------------------------------------
_zlsh_chk_core_validators() {
    # On failure:
    # - `_zlsh_chk_core_validators` will be set.
    for _zlsh_chk_core_validators\
    in  _zlsh_chk_str_is_digits\
        _zlsh_chk_var_is_digits \
        _zlsh_chk_str_is_xdigits \
        _zlsh_chk_var_is_xdigits  \
        _zlsh_chk_str_is_vname_sfx \
        _zlsh_chk_var_is_vname_sfx  \
        _zlsh_chk_str_is_vname       \
        _zlsh_chk_var_is_vname        \
        _zlsh_chk_str_is_fname_sfx     \
        _zlsh_chk_var_is_fname_sfx      \
        _zlsh_chk_str_is_fname           \
        _zlsh_chk_var_is_fname            \
        _zlsh_chk_str_is_var_exists        \
        _zlsh_chk_str_is_var_notempty       \
        _zlsh_chk_str_is_vref                \
        _zlsh_chk_str_is_fn_undef             \
        _zlsh_chk_var_eq_var                   \
        _zlsh_chk_usage                         \

    do  eval $_zlsh_chk_core_validators || return 1
    done && unset -v _zlsh_chk_core_validators; }

###############################################################################
#  TODO: Functions below are not validators and need to find a more suitable
#        codebase sections to call their home, when that will emerge. (Don't
#        forget to move their tests from _zlsh_chk_core_validators as well!)

#------------------------------------------------------------------------------
#, zlash_ensure
_ZLSH_TOPIC_zlash_ensure='succeed always if successful once

On a successful evaluation of a no arguments function by name, always succeed
without reevaluating the function again.

Useful for a lazy initialization pattern:

```bash
common_init() {
    : #  Stuff needed for `myfunc` and others.
}
myfunc() {
    zlash_ensure common_init &&\
    myfunc() {
        : # Myfunc impl using inited stuff.
    } &&\
    myfunc "$@"
}
```

Any function dependent on `common_init` and using the above pattern, when called
first, will initialize for all, and all functions will not suffer the condition
penalty after their first calls.
'
_ZLSH_USAGE__zlash_ensure='Usage

zlash_ensure fname
'
_ZLSH_PARAMS_zlash_ensure='Parameters

1. *fname*: a name of a function
'
zlash_ensure() {
    if [ $# -eq 1 ] && _zlsh_str_is_fname "$1" && ! _zlsh_str_is_fn_undef "$1"
    then _zlsh_ensure "$1"
    else _zlsh_usage zlash_ensure; return 64; fi; }
_zlsh_ensure() { eval                                  \
    'if [ "${_ZLSH_ENSURED_'"$1"'+x}" ]; then return 0;'\
    'else '"$1"' && _ZLSH_ENSURED_'"$1"'=; fi'; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_ensure() {
    # TODO: Decouple this test's dependency on the portable fallback
    #       implementation.
    unset -v _ZLSH_ENSURED__ZLSH_DONOTSETME 2>/dev/null ||:
    unset -f _ZLSH_DONOTSETME               2>/dev/null ||:
    _zlsh_chk_ensure=0                          &&\
    ! zlash_ensure _ZLSH_DONOTSETME 2>/dev/null && \
    _ZLSH_DONOTSETME() {  # shellcheck disable=2317
        _zlsh_chk_ensure=$((_zlsh_chk_ensure + 1)); }              &&\
                                     [ "$_zlsh_chk_ensure" -eq 0 ] && \
    zlash_ensure _ZLSH_DONOTSETME && [ "$_zlsh_chk_ensure" -eq 1 ] &&  \
    zlash_ensure _ZLSH_DONOTSETME && [ "$_zlsh_chk_ensure" -eq 1 ] &&   \
    unset -f _ZLSH_DONOTSETME && unset -v _ZLSH_ENSURED__ZLSH_DONOTSETME; }
