# shellcheck disable=2016,2034

# Zlash dev-env section dependencies. (stripped on release)
_zlsh__dev_load     \
    core_str_matching\
    || return 1

###############################################################################
#/ Core String Operations
#
#------------------------------------------------------------------------------
#, zlash_str_mul
_ZLSH_TOPIC_zlash_str_mul='string multiplication

Multiplies a string *n* times and stores it in the `zlash_str_mul` variable.
'
_ZLSH_USAGE_zlash_str_mul='Usage

zlash_str_mul str n [out_vname]
'
_ZLSH_PARAMS_zlash_str_mul='Parameters

1. *str*
   : A non-empty string to multiply.
2. *n*
   : A positive decimal integer multiplication factor.
3. *out_vname*
   : Optional variable name where the multiplied string should be stored,
     instead of output to *STDOUT*.
'
zlash_str_mul() {
    if  case $# in
            3)  [    "${1:+x}"    ]      &&                 \
                _zlsh_str_is_digits "$2" && [ "$2" -gt 0 ] &&\
                _zlsh_str_is_vname  "$3" ;;
            2)  [    "${1:+x}"    ]      &&\
                _zlsh_str_is_digits "$2" && [ "$2" -gt 0 ] ;;
            *) false; esac
    then _zlsh_str_mul "$1" "$2" && if [ $# -eq 3 ]
        then   eval    "$3=\$zlash_str_mul"
        else printf '%s\n' "$zlash_str_mul"; fi
    else _zlsh_usage zlash_str_mul && return 64; fi; }
_zlsh_str_mul() {
    zlash_str_mul=''   && _zlsh_str_mul_S=$1 &&\
    _zlsh_str_mul_N=$2 && _zlsh_str_mul_K=1  && \
    while [ "$_zlsh_str_mul_K" -lt "$_zlsh_str_mul_N" ]; do
        if [ "$((_zlsh_str_mul_K * 2))" -le "$_zlsh_str_mul_N" ]; then
            _zlsh_str_mul_S=$_zlsh_str_mul_S$_zlsh_str_mul_S &&\
            _zlsh_str_mul_K=$((_zlsh_str_mul_K * 2))         || return 1
        else zlash_str_mul=$zlash_str_mul$_zlsh_str_mul_S          &&\
            _zlsh_str_mul_N=$((_zlsh_str_mul_N - _zlsh_str_mul_K)) && \
            _zlsh_str_mul_K=1 && _zlsh_str_mul_S=$1                || return 1
        fi; done &&\
    zlash_str_mul=$zlash_str_mul$_zlsh_str_mul_S; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
# shellcheck disable=2154
_zlsh_chk_str_mul() {
    _zlsh_chk_str_mul_test() {
        zlash_str_mul "$1" "$2" _zlsh_chk_str_mul &&\
        [ "$3" = "$_zlsh_chk_str_mul" ]           && \
        [ "$3" =     "$zlash_str_mul" ]; }
    ! _zlsh_chk_str_mul_test ''   1 '' 2>/dev/null &&\
    ! _zlsh_chk_str_mul_test 'a'  0 '' 2>/dev/null && \
    _zlsh_chk_str_mul_test   'a'  1 'a'      &&  \
    _zlsh_chk_str_mul_test   'aa' 2 'aaaa'   &&   \
    _zlsh_chk_str_mul_test   'a ' 3 'a a a ' &&    \
    _zlsh_chk_str_mul_test   'a'  4 'aaaa'   &&     \
    _zlsh_chk_str_mul_test   'a'  5 'aaaaa'  &&      \
    _zlsh_chk_str_mul_test   'a'  6 'aaaaaa' &&       \
    zlash_str_mul 'abc' 47 _zlsh_chk_str_mul &&\
    [ "${#_zlsh_chk_str_mul}" -eq 141 ]      && \
    zlash_str_mul 'abc' 60 _zlsh_chk_str_mul &&  \
    [ "${#_zlsh_chk_str_mul}" -eq 180 ]      &&   \
    unset -v _zlsh_chk_str_mul &&\
    unset -f _zlsh_chk_str_mul_test; }

#------------------------------------------------------------------------------
#, zlash_var_slice
_ZLSH_TOPIC_zlash_var_slice='slice a string

Slices a string stored in a variable supplied by name. Stores the slice in the
`zlash_var_slice` variable.
'
_ZLSH_USAGE_zlash_var_slice='Usage

zlash_var_slice str_vname index length [out_vname]
'
_ZLSH_PARAMS_zlash_var_slice='Parameters

1. *str_vname*
   : A name of a variable containing a string to slice.
2. *index*
   : A non-negative decimal integer 0-based index of the start of the slice.
3. *length*
   : A non-negative decimal integer maximum length of the slice.
4. *out_vname*
   : An optional variable name where the slice should be stored, instead of
     output to *STDOUT*.
'
zlash_var_slice() {
    if  case $# in
            4)  _zlsh_str_is_var_exists "$1" &&\
                _zlsh_str_is_digits     "$2" && \
                _zlsh_str_is_digits     "$3" &&  \
                _zlsh_str_is_vname      "$4" ;;
            3)  _zlsh_str_is_var_exists "$1" &&\
                _zlsh_str_is_digits     "$2" && \
                _zlsh_str_is_digits     "$3" ;;
            *)  false; esac
    then _zlsh_var_slice "$1" "$2" "$3" && if [ $# -eq 4 ]
        then   eval    "$4=\$zlash_var_slice"
        else printf '%s\n' "$zlash_var_slice"; fi
    else _zlsh_usage zlash_var_slice && return 64; fi; }
_zlsh_var_slice() {
    # OL: original string length
    # SI: slice index
    # SL: slice length
    # TL: (tail) length to chop off (at the end of the original string)
    zlash_var_slice=''                &&\
    _zlsh_var_slice_SI=$2             && \
    eval "_zlsh_var_slice_OL=\${#$1}" || return 1
    # If slice length is zero, or if index is larger or equal to length of the
    # original string, then slice will be empty.
    [ "$3" -gt 0 ] && [ "$2" -lt "$_zlsh_var_slice_OL" ] || return 0
    # Clamp the length of the slice if it is out of bounds.
    if [ "$(($2 + $3))" -gt "$_zlsh_var_slice_OL" ]; then
        _zlsh_var_slice_TL=0 &&\
        _zlsh_var_slice_SL=$((_zlsh_var_slice_OL - $2))
    else
        _zlsh_var_slice_SL=$3 &&\
        _zlsh_var_slice_TL=$((_zlsh_var_slice_OL - $2 - $3)); fi &&\
    if [ "$_zlsh_var_slice_TL" = "$2" ]; then  # Symmetric slice.
        if [ "$2" = 0 ]; then  # No side needs chopping, we're done.
            eval "zlash_var_slice=\$$1" && return 0
        else  # Same length needs to be chopped from both ends.
            _zlsh_var_slice_pat "$2"                                      &&\
            eval "zlash_var_slice=\${$1#$_zlsh_var_slice_pat} &&"            \
                "zlash_var_slice=\${zlash_var_slice%$_zlsh_var_slice_pat}" && \
            return 0; fi
    elif [ "$2" -lt "$_zlsh_var_slice_TL" ]\
    &&   [ "$2"  !=        0              ]; then
        # Head to chop is shorter than tail, chopping head off first.
        _zlsh_var_slice_pat "$2"                           &&\
        eval "zlash_var_slice=\${$1#$_zlsh_var_slice_pat}" && \
        _zlsh_var_slice_OL=$((_zlsh_var_slice_OL - $2))    &&  \
        _zlsh_var_slice_SI=0
    elif [ "$_zlsh_var_slice_TL" -lt "$2" ]\
    &&   [ "$_zlsh_var_slice_TL"  !=  0   ]; then
        # Tail to chop is shorter than head, chopping tail off first.
        _zlsh_var_slice_pat "$_zlsh_var_slice_TL"                       &&\
        eval "zlash_var_slice=\${$1%$_zlsh_var_slice_pat}"              && \
        _zlsh_var_slice_OL=$((_zlsh_var_slice_OL - _zlsh_var_slice_TL)) &&  \
        _zlsh_var_slice_TL=0
    else    # No smaller chopping was done, we need to initialize the work
            # string as if work was done, for the next step.
        eval "zlash_var_slice=\$$1"; fi &&\
    if [ "$_zlsh_var_slice_TL" = 0 ]; then
        # Head left to chop.  No tail to chop.
        if [ "$_zlsh_var_slice_SI" -le "$_zlsh_var_slice_SL" ]; then
            # Head is shorter or equal slice length, just chop it off.
            _zlsh_var_slice_pat "$_zlsh_var_slice_SI" &&\
            eval "zlash_var_slice=\${zlash_var_slice#$_zlsh_var_slice_pat}"
        else    # Head is longer than slice lenth. Use double-expansion method
                # to chop it off.
            _zlsh_var_slice_pat "$_zlsh_var_slice_SL" &&\
            eval "zlash_var_slice=\${zlash_var_slice#\"\${zlash_var_slice%$_zlsh_var_slice_pat}\"}"
        fi
    else  # Tail left to chop.  No head to chop.
        if [ "$_zlsh_var_slice_TL" -le "$_zlsh_var_slice_SL" ]; then
            # Tail is shorter or equal slice length, just chop it off.
            _zlsh_var_slice_pat "$_zlsh_var_slice_TL" &&\
            eval "zlash_var_slice=\${zlash_var_slice%$_zlsh_var_slice_pat}"
        else    # Tail is longer than slice lenth. Use double-expansion method
                # to chop it off.
            _zlsh_var_slice_pat "$_zlsh_var_slice_SL" &&\
            eval "zlash_var_slice=\${zlash_var_slice%\"\${zlash_var_slice#$_zlsh_var_slice_pat}\"}"
        fi; fi; }
_zlsh_var_slice_pat() {
    if ! eval "[ \"\${_ZLSH_PAT_LEN_$1+x}\" ]"\
        "&& _zlsh_var_slice_pat=\$_ZLSH_PAT_LEN_$1"
    then _zlsh_str_mul '?' "$1" && _zlsh_var_slice_pat=$zlash_str_mul &&\
        eval "_ZLSH_PAT_LEN_$1=\$zlash_str_mul"; fi; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_var_slice() {
    # On Failure:
    # - `_zlsh_chk_var_slice_IX`    is set to index  of the failed slice test
    # - `_zlsh_chk_var_slice_SLICE` is set to result of the failed slice test
    _zlsh_chk_var_slice_SLICE () {  # shellcheck disable=2154
        unset -v _zlsh_chk_var_slice_SLICE &&\
        _zlsh_chk_var_slice_IX=0           && \
        while [ $# -gt 0 ]
        do                  _zlsh_chk_var_slice=$1                 &&\
            zlash_var_slice _zlsh_chk_var_slice "$2" "$3"             \
                _zlsh_chk_var_slice_SLICE                          &&  \
            [ "$_zlsh_chk_var_slice_SLICE" = "$4" ]                &&   \
            [ "$zlash_var_slice"           = "$4" ]                &&    \
            _zlsh_chk_var_slice_IX=$((_zlsh_chk_var_slice_IX + 1)) &&     \
            shift 4                                                || return 1
        done && [ $# -eq 0 ]; } &&\
    _zlsh_chk_var_slice_SLICE                                           \
        ''     0 0 ''    ''     1 0 ''    ''     0 1 ''     ''     1 1 ''\
        'a'    0 0 ''    'a'    1 0 ''    'a'    2 0 ''     'a'    0 1 'a'\
        'a'    1 0 ''    'a'    1 1 ''    'a'    2 1 ''     'a'    0 2 'a' \
        'a'    1 2 ''    'a'    2 2 ''    'ab'   0 0 ''     'ab'   0 1 'a'  \
        'ab'   0 2 'ab'  'ab'   0 3 'ab'  'ab'   1 0 ''     'ab'   1 1 'b'   \
        'ab'   1 2 'b'   'ab'   1 3 'b'   'ab'   2 0 ''     'ab'   2 1 ''     \
        'abc'  0 0 ''    'abc'  0 1 'a'   'abc'  0 2 'ab'   'abc'  0 3 'abc'  \
        'abc'  0 4 'abc' 'abc'  1 0 ''    'abc'  1 1 'b'    'abc'  1 2 'bc'   \
        'abc'  1 3 'bc'  'abc'  2 0 ''    'abc'  2 1 'c'    'abc'  2 2 'c'    \
        'abc'  3 0 ''    'abc'  3 1 ''    'abcd' 0 0 ''     'abcd' 0 1 'a'    \
        'abcd' 0 2 'ab'  'abcd' 0 3 'abc' 'abcd' 0 4 'abcd' 'abcd' 0 5 'abcd' \
        'abcd' 1 0 ''    'abcd' 1 1 'b'   'abcd' 1 2 'bc'   'abcd' 1 3 'bcd'  \
        'abcd' 1 4 'bcd' 'abcd' 2 0 ''    'abcd' 2 1 'c'    'abcd' 2 2 'cd'   \
        'abcd' 2 3 'cd'  'abcd' 3 0 ''    'abcd' 3 1 'd'    'abcd' 3 2 'd'    \
        'abcd' 4 0 ''    'abcd' 4 1 ''                                      &&\
    unset  -v   _zlsh_chk_var_slice _zlsh_chk_var_slice_IX \
                _zlsh_chk_var_slice_SLICE zlash_var_slice &&\
    unset  -f   _zlsh_chk_var_slice_SLICE; }

#------------------------------------------------------------------------------
#, zlash_var_trim
_ZLSH_TOPIC_zlash_var_trim='remove prefix and suffix whitespaces from a variable

Removes all leading and trailing whitespace from a string value of a variable
supplied by name, storing the result in `zlash_var_trim` variable.
'
_ZLSH_USAGE_zlash_var_trim='Usage

zlash_var_trim var [out_vname]
'
_ZLSH_PARAMS_zlash_var_trim='Parameters

1. *var*
   : A name of a variable containing a string to trim.
2. *out_vname*
   : An optional name of a variable to contain result, instead of printing to
     *STDOUT*.
'
zlash_var_trim() {
    if  case $# in
            2)  _zlsh_str_is_var_exists "$1" &&\
                _zlsh_str_is_vname      "$2" ;;
            1)  _zlsh_str_is_var_exists "$1" ;;
            *)  false; esac
    then _zlsh_var_trim "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_var_trim"
        else printf '%s\n' "$zlash_var_trim"; fi
    else _zlsh_usage zlash_var_trim && return 64; fi; }
_zlsh_var_trim() {
    eval "zlash_var_trim=\${$1#\"\${$1%%[![:space:]]*}\"}" &&\
        zlash_var_trim=${zlash_var_trim%"${zlash_var_trim##*[![:space:]]}"}; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_var_trim() {
    _zlsh_chk_var_trim_tst zlash_var_trim\
        0  ''      ''     1 ' '    ''    2 '
        '          ''     3 'a'    'a'   4 'a  '  'a'   5 '  a'  'a' \
        6  ' a '   'a'    7 'a b' 'a b'  8 'a b ' 'a b' 9 ' a b' 'a b'\
        10 ' a b ' 'a b' 11 '
        a b
        '          'a b'; }
_zlsh_chk_var_trim_tst () {  # shellcheck disable=2154
    # On Failure:
    # - `_zlsh_chk_var_trim_IX`  is set to index  of the failed slice test
    # - `_zlsh_chk_var_trim_OUT` is set to result of the failed slice test
    unset -v _zlsh_chk_var_trim_tst_OUT &&\
    _zlsh_chk_var_trim_tst_IX=0         && \
    _zlsh_chk_var_trim_tst=$1 && shift  &&  \
    while [ $# -gt 0 ]
    do      _zlsh_chk_var_trim_tst_IX=$1                          \
                                    _zlsh_chk_var_trim_tst_IN=$2 &&\
          "$_zlsh_chk_var_trim_tst" _zlsh_chk_var_trim_tst_IN       \
            _zlsh_chk_var_trim_tst_OUT                           &&  \
        [ "$_zlsh_chk_var_trim_tst_OUT"        = "$3" ]          &&   \
        eval '[ "$'"$_zlsh_chk_var_trim_tst"'" = "$3" ]'         &&    \
        shift 3                                                  || return 1
    done && [ $# -eq 0 ] && unset -v zlash_var_trim _zlsh_chk_var_trim_tst_IX\
        _zlsh_chk_var_trim_tst_OUT _zlsh_chk_var_trim_tst_IN; }

#------------------------------------------------------------------------------
#, zlash_var_trim_pfx
_ZLSH_TOPIC_zlash_var_trim_pfx='remove prefix whitespaces from a variable

Removes all leading whitespace from a string value of a variable supplied by
name, storing the result in `zlash_var_trim_pfx` variable.
'
_ZLSH_USAGE_zlash_var_trim_pfx='Usage

zlash_var_trim_pfx var [out_vname]
'
_ZLSH_PARAMS_zlash_var_trim_pfx='Parameters

1. *var*
   : A name of a variable containing a string to trim.
2. *out_vname*
   : An optional name of a variable to contain result, instead of printing to
     *STDOUT*.
'
zlash_var_trim_pfx() {  # shellcheck disable=2154
    if  case $# in
            2)  _zlsh_str_is_var_exists "$1" &&\
                _zlsh_str_is_vname      "$2" ;;
            1)  _zlsh_str_is_var_exists "$1" ;;
            *)  false; esac
    then _zlsh_var_trim_pfx "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_var_trim_pfx"
        else printf '%s\n' "$zlash_var_trim_pfx"; fi
    else _zlsh_usage zlash_var_trim_pfx && return 64; fi; }
_zlsh_var_trim_pfx() {
    eval "zlash_var_trim_pfx=\${$1#\"\${$1%%[![:space:]]*}\"}"; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_var_trim_pfx() {
    _zlsh_chk_var_trim_tst zlash_var_trim_pfx\
        0  ''      ''      1 ' '    ''    2 '
        '          ''      3 'a'    'a'   4 'a  '  'a  '  5 '  a'  'a' \
        6  ' a '   'a '    7 'a b' 'a b'  8 'a b ' 'a b ' 9 ' a b' 'a b'\
        10 ' a b ' 'a b ' 11 '
        a b
        '          'a b
        '; }

#------------------------------------------------------------------------------
#, zlash_var_trim_sfx
_ZLSH_TOPIC_zlash_var_trim_sfx='remove suffix whitespaces from a variable

Removes all trailing whitespace from a string value of a variable supplied by
name, storing the result in `zlash_var_trim_sfx` variable.
'
_ZLSH_USAGE_zlash_var_trim_sfx='Usage

zlash_var_trim_sfx var [out_vname]
'
_ZLSH_PARAMS_zlash_var_trim_sfx='Parameters

1. *var*
   : A name of a variable containing a string to trim.
2. *out_vname*
   : An optional name of a variable to contain result, instead of printing to
     *STDOUT*.
'
zlash_var_trim_sfx() {  # shellcheck disable=2154
    if  case $# in
            2)  _zlsh_str_is_var_exists "$1" &&\
                _zlsh_str_is_vname      "$2" ;;
            1)  _zlsh_str_is_var_exists "$1" ;;
            *)  false; esac
    then _zlsh_var_trim_sfx "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_var_trim_sfx"
        else printf '%s\n' "$zlash_var_trim_sfx"; fi
    else _zlsh_usage zlash_var_trim_sfx && return 64; fi; }
_zlsh_var_trim_sfx() {
    eval "zlash_var_trim_sfx=\${$1%\"\${$1##*[![:space:]]}\"}"; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_var_trim_sfx() {
    _zlsh_chk_var_trim_tst zlash_var_trim_sfx\
        0  ''      ''     1 ' '    ''    2 '
        '          ''     3 'a'    'a'   4 'a  '  'a'   5 '  a'  '  a' \
        6  ' a '   ' a'   7 'a b' 'a b'  8 'a b ' 'a b' 9 ' a b' ' a b' \
        10 ' a b ' ' a b' 11 '
        a b
        '          '
        a b'; }

# TODO: `zlash_lower` and `zlash_higher` portable fallback implementations need
#   to be changed to not use subshelling, or limit it to one eval or subshell
#   per invocation. Possibly moved to later sections that enable to do that.
#------------------------------------------------------------------------------
#, zlash_lower
_ZLSH_TOPIC_zlash_lower='convert string to lower-case

Convert supplied string to lower-case and store the converted string in the
`zlash_lower` variable.

When the shell does not natively support text case modification, the fallback is
using the 6th bit of *ASCII* representation of characters that match
`[[:alpha:]]` pattern.
'
_ZLSH_USAGE_zlash_lower='Usage

zlash_lower str [out_vname]
'
_ZLSH_PARAMS_zlash_lower='

1. *str*: a string to lower-case
2. *out_vname*: an optional name of a variable to store result in, instead of
   outputing to *STDOUT*
'
zlash_lower() {
    if  case $# in
            2) _zlsh_str_is_vname "$2" ;;
            1) : ;;
            *) false; esac
    then _zlsh_lower "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_lower"
        else printf '%s\n' "$zlash_lower"; fi
    else _zlsh_usage zlash_lower && return 64; fi; }
_zlsh_lower() {
    # H: head            T: tail
    # C: char            A: ascii decimal
    # W: work temp var
    zlash_lower=   && _zlsh_lower=$1 &&\
    _zlsh_lower_H= && _zlsh_lower_T= && \
    _zlsh_lower_C= && _zlsh_lower_A= &&  \
    _zlsh_lower_W= &&                     \
    while [ "$_zlsh_lower" ]; do
        case $_zlsh_lower in
            *[[:alpha:]]*)  # shellcheck disable=2059
                _zlsh_lower_T=${_zlsh_lower#*[[:alpha:]]}        &&\
                _zlsh_lower_W=${_zlsh_lower%"$_zlsh_lower_T"}    && \
                _zlsh_lower_H=${_zlsh_lower_W%[[:alpha:]]}       &&  \
                _zlsh_lower_C=${_zlsh_lower_W#"$_zlsh_lower_H"}  &&   \
                _zlsh_lower=$_zlsh_lower_T                       &&    \
                _zlsh_lower_A=$(printf '%d\n' "'$_zlsh_lower_C") &&     \
                if [ $((_zlsh_lower_A & 0x20)) -ne 0 ]
                then zlash_lower=$zlash_lower$_zlsh_lower_H$_zlsh_lower_C
                else zlash_lower=$zlash_lower$_zlsh_lower_H$(
                    printf "\\$(printf '%o\n' $((_zlsh_lower_A | 0x20)))\\n")
                fi || return 1;;
            *)  zlash_lower=$zlash_lower$_zlsh_lower || return 1 &&\
                break; esac; done; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_lower() { : # TODO
}

#------------------------------------------------------------------------------
#, zlash_upper
_ZLSH_TOPIC_zlash_upper='convert string to upper-case

Convert supplied string to upper-case and store the converted string in the
`zlash_upper` variable.

When the shell does not natively support text case modification, the fallback is
using the 6th bit of *ASCII* representation of characters that match
`[[:alpha:]]` pattern.
'
_ZLSH_USAGE_zlash_upper='Usage
zlash_upper str [out_vname]
'
_ZLSH_PARAMS_zlash_upper='

1. *str*: a string to upper-case
2. *out_vname*: an optional name of a variable to store result in, instead of
   outputing to *STDOUT*
'
zlash_upper() {
    if  case $# in
            2) _zlsh_is_vname "$2" ;;
            1) :                   ;;
            *) false; esac
    then _zlsh_upper "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_upper"
        else printf '%s\n' "$zlash_upper"; fi
    else _zlsh_usage zlash_upper && return 64; fi; }
_zlsh_upper() {
    # H: head            T: tail
    # C: char            A: ascii decimal
    # W: work temp var
    zlash_upper=   && _zlsh_upper=$1 &&\
    _zlsh_upper_H= && _zlsh_upper_T= && \
    _zlsh_upper_C= && _zlsh_upper_A= &&  \
    _zlsh_upper_W= &&                     \
    while [ ${_zlsh_upper:+x} ]; do
        case $_zlsh_upper in
            *[[:alpha:]]*)  # shellcheck disable=2059
                _zlsh_upper_T=${_zlsh_upper#*[[:alpha:]]}        &&\
                _zlsh_upper_W=${_zlsh_upper%"$_zlsh_upper_T"}    && \
                _zlsh_upper_H=${_zlsh_upper_W%[[:alpha:]]}       &&  \
                _zlsh_upper_C=${_zlsh_upper_W#"$_zlsh_upper_H"}  &&   \
                _zlsh_upper=$_zlsh_upper_T                       &&    \
                _zlsh_upper_A=$(printf '%d\n' "'$_zlsh_upper_C") &&     \
                if [ $((_zlsh_upper_A & 0x20)) -eq 0 ]
                then zlash_upper=$zlash_upper$_zlsh_upper_H$_zlsh_upper_C
                else zlash_upper=$zlash_upper$_zlsh_upper_H$(
                    printf "\\$(printf '%o\n' $((_zlsh_upper_A - 0x20)))\\n")
                fi || return 1;;
            *)  zlash_upper=$zlash_upper$_zlsh_upper || return 1 &&\
                break; esac; done; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_upper() { : # TODO
}

#------------------------------------------------------------------------------
#, zlash_var_trim_sfx
zlash_split_once_str() {
    if   [  $#  != 4 ]    \
    ||   [ ${#2} = 0 ]     \
    || ! _zlsh_is_vname "$1"\
    || ! _zlsh_is_vname "$3" \
    || ! _zlsh_is_vname "$4"
    then
        _zlsh_usage zlash_split_once_str
        return 64
    fi
    _zlsh_split_once_str "$1" "$2" &&\
    eval "$3=\$zlash_head && $4=\$zlash_tail"
}
_zlsh_split_once_str() {
    if _zlsh_var_has_substr "$1" "$2"\
    && eval "zlash_head=\${$1%%\"\$2\"*} && zlash_tail=\${$1#*\"\$2\"}"
    then return 0
    else zlash_head= && zlash_tail= && return 1
    fi
}
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

#------------------------------------------------------------------------------
#, zlash_var_trim_sfx
zlash_rsplit_once_str() {
    if   [  $#  != 4 ]    \
    ||   [ ${#2} = 0 ]     \
    || ! _zlsh_is_vname "$1"\
    || ! _zlsh_is_vname "$3" \
    || ! _zlsh_is_vname "$4"
    then
        _zlsh_usage zlash_rsplit_once_str
        return 64
    fi
    _zlsh_rsplit_once_str "$1" "$2" &&\
    eval "$3=\$zlash_head && $4=\$zlash_tail"
}
_zlsh_rsplit_once_str() {
    if _zlsh_var_has_substr "$1" "$2"\
    && eval "zlash_head=\${$1%\"\$2\"*} && zlash_tail=\${$1##*\"\$2\"}"
    then return 0
    else zlash_head= && zlash_tail= && return 1
    fi
}
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

#------------------------------------------------------------------------------
#, zlash_var_trim_sfx
zlash_split_once_pat() {
    if   [  $#  != 4 ]    \
    ||   [ ${#2} = 0 ]     \
    || ! _zlsh_is_vname "$1"\
    || ! _zlsh_is_vname "$3" \
    || ! _zlsh_is_vname "$4"
    then
        _zlsh_usage zlash_split_once_pat
        return 64
    fi
    _zlsh_split_once_pat "$1" "$2" &&\
    eval "$3=\$zlash_head && $4=\$zlash_tail"
}
_zlsh_split_once_pat() {
    if _zlsh_var_match_pat "$1" "$2"\
    && eval "zlash_head=\${$1%%$2*} && zlash_tail=\${$1#*$2}"
    then return 0
    else zlash_head= && zlash_tail= && return 1
    fi
}
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

zlash_rsplit_once_pat() {
    if   [  $#  != 4 ]    \
    ||   [ ${#2} = 0 ]     \
    || ! _zlsh_is_vname "$1"\
    || ! _zlsh_is_vname "$3" \
    || ! _zlsh_is_vname "$4"
    then
        _zlsh_usage zlash_rsplit_once_pat
        return 64
    fi
    _zlsh_rsplit_once_pat "$1" "$2" &&\
    eval "$3=\$zlash_head && $4=\$zlash_tail"
}
_zlsh_rsplit_once_pat() {
    if _zlsh_var_match_pat "$1" "$2"\
    && eval "zlash_head=\${$1%$2*} && zlash_tail=\${$1##*$2}"
    then return 0
    else zlash_head= && zlash_tail= && return 1
    fi
}
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

#------------------------------------------------------------------------------
#, zlash_var_trim_sfx
zlash_gsub_str_n__DOC__USAGE='
zlash_gsub_str_n oldstr_vname oldsubstr newsubstr num newstr_vname
'
zlash_gsub_str_n() {
    if   [  $#  != 5 ]    \
    ||   [ ${#2} = 0 ]     \
    || ! _zlsh_is_vname "$1"\
    || ! _zlsh_is_digits "$4"\
    ||   [ "$4" -le 0 ]       \
    || ! _zlsh_is_vname "$5"
    then
        zlash_usage zlash_gsub_str_n
        return 64
    fi
    _zlsh_gsub_str_n "$@" &&\
    eval "$5=\$zlash_gsub_str"
}
_zlsh_gsub_str_n() {
    zlash_gsub_str=              &&\
    _zlsh_gsub_str_N=$4          && \
    eval _zlsh_gsub_str_STR=\$$1 || return 1
    while [ "$_zlsh_gsub_str_N" -gt 0 ]; do
        if ! _zlsh_split_once_str _zlsh_gsub_str_STR "$2"
        then break
        fi
        zlash_gsub_str=$zlash_gsub_str$zlash_head$3 &&\
        _zlsh_gsub_str_STR=$zlash_tail              && \
        _zlsh_gsub_str_N=$((_zlsh_gsub_str_N - 1))  || return 1
    done
    zlash_gsub_str=$zlash_gsub_str$_zlsh_gsub_str_STR &&\
    unset -v _zlsh_gsub_str_N _zlsh_gsub_str_STR
}
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

#------------------------------------------------------------------------------
#, zlash_var_trim_sfx
zlash_gsub_str() {
    if   [  $#  != 4 ]    \
             ||   [ ${#2} = 0 ]     \
             || ! _zlsh_is_vname "$1"\
             || ! _zlsh_is_vname "$4"
    then
        zlash_usage zlash_gsub_str
        return 64
    fi
    _zlsh_gsub_str "$@" &&\
        eval "$4=\$zlash_gsub_str"
}
_zlsh_gsub_str() {
    zlash_gsub_str=              &&\
        eval _zlsh_gsub_str_STR=\$$1 || return 1
    while _zlsh_split_once_str _zlsh_gsub_str_STR "$2"; do
        zlash_gsub_str=$zlash_gsub_str$zlash_head$3 &&\
            _zlsh_gsub_str_STR=$zlash_tail              || return 1
    done
    zlash_gsub_str=$zlash_gsub_str$_zlsh_gsub_str_STR &&\
        unset -v _zlsh_gsub_str_STR
}
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -

#------------------------------------------------------------------------------
_zlsh_chk_core_str_ops() {
    # On failure:
    # - `_zlsh_chk_core_str_ops` will be set.
    for _zlsh_chk_core_str_ops\
    in  _zlsh_chk_str_mul  \
        _zlsh_chk_var_slice \
        _zlsh_chk_var_trim   \
        _zlsh_chk_var_trim_pfx\
        _zlsh_chk_var_trim_sfx \

    do $_zlsh_chk_core_str_ops || return 1
    done && unset -v _zlsh_chk_core_str_ops; }
