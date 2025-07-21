# shellcheck disable=2034

# Zlash dev-env section dependencies. (stripped on release)
_zlsh__dev_load   \
    core_validators\
    || return 1

###############################################################################
#/ Basic Math
#
#------------------------------------------------------------------------------
#  ZLASH_MAXINT_DECI  , ZLASH_MAXINT_DECI_LEN
#  ZLASH_MAXINT_BITLEN, ZLASH_MAXINT_BITLEN_SOFTCAP (if probe reached it)
_zlsh_probe_maxint() {
    # S: bitshift step
    ZLASH_MAXINT_BITLEN=1 && ZLASH_MAXINT_DECI=1                          &&\
    : "${ZLASH_MAXINT_BITLEN_SOFTCAP:=256}" "${_zlsh_probe_maxint_S:=62}" && \
    while [ "$ZLASH_MAXINT_BITLEN" -lt "$ZLASH_MAXINT_BITLEN_SOFTCAP" ]; do
          _zlsh_probe_maxint=$(( (ZLASH_MAXINT_DECI << _zlsh_probe_maxint_S)\
                                + ((1 << _zlsh_probe_maxint_S) - 1) ))     &&\
          if _zlsh_is_digits "$_zlsh_probe_maxint"\
          && [ $((ZLASH_MAXINT_BITLEN + _zlsh_probe_maxint_S))\
              -le "$ZLASH_MAXINT_BITLEN_SOFTCAP" ]
          then ZLASH_MAXINT_BITLEN=$((
                  ZLASH_MAXINT_BITLEN + _zlsh_probe_maxint_S)) &&\
              ZLASH_MAXINT_DECI=$_zlsh_probe_maxint            || return 1
          else  [ "$_zlsh_probe_maxint_S" -ne 1 ] || break         &&\
                _zlsh_probe_maxint_S=$((_zlsh_probe_maxint_S / 2)) && \
                [ "$_zlsh_probe_maxint_S" -ne 0 ] ||\
                    _zlsh_probe_maxint_S=1                         || return 1
          fi; done &&\
    if [ "$ZLASH_MAXINT_BITLEN" -lt "$ZLASH_MAXINT_BITLEN_SOFTCAP" ]; then
        unset -v ZLASH_MAXINT_BITLEN_SOFTCAP; fi &&\
    ZLASH_MAXINT_DECI_LEN=${#ZLASH_MAXINT_DECI}  && \
    unset -v _zlsh_probe_maxint_S;                   }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_probe_maxint() { (
    _zlsh_bits() { _zlsh_int=$(( (1<<($1 - 1)) + ((1<<($1 - 1)) - 1) )); }
    _zlsh_clamp() {
        _zlsh_clamp=$1
        _zlsh_is_digits() {
            case $1 in
                *[![:digit:]]*) false;;
                *) true; esac && [ "$1" -le "$_zlsh_clamp" ]; }; }
    _zlsh_check() { # softcap shiftstep maxint bitlen
        ZLASH_MAXINT_BITLEN_SOFTCAP=$1 &&\
        _zlsh_probe_maxint_S=$2        || return 1
        unset -v  ZLASH_MAXINT_DECI ZLASH_MAXINT_BITLEN\
            ZLASH_MAXINT_DECI_LEN 2>/dev/null ||:; # shellcheck disable=2016
        _zlsh_probe_maxint                                            \
        &&             [   "$3"   -eq "$ZLASH_MAXINT_DECI"     ]       \
        &&             [ "${#3}"  -eq "$ZLASH_MAXINT_DECI_LEN" ]        \
        &&             [   "$4"   -eq "$ZLASH_MAXINT_BITLEN"   ]         \
        && _zlsh_iff  '[ "'"$4"'" -eq "'"$1"'" ]'                         \
                      '[ "'"$4"'" -eq "${ZLASH_MAXINT_BITLEN_SOFTCAP-0}" ]'\
        && unset -v ZLASH_MAXINT_BITLEN_SOFTCAP _zlsh_probe_maxint_S; }
    _zlsh_clamp       7   &&\
    _zlsh_check '' '' 7 3 && \
    _zlsh_check '' 1  7 3 &&  \
    _zlsh_check '' 2  7 3 &&   \
    _zlsh_check '' 3  7 3 &&    \
    _zlsh_check '' 4  7 3 &&     \
    _zlsh_bits 7                     &&\
    _zlsh_clamp "$_zlsh_int"         && \
    _zlsh_check '' '' "$_zlsh_int" 7 &&  \
    _zlsh_check '' 1  "$_zlsh_int" 7 &&   \
    _zlsh_check '' 2  "$_zlsh_int" 7 &&    \
    _zlsh_check '' 3  "$_zlsh_int" 7 &&     \
    _zlsh_check '' 4  "$_zlsh_int" 7 &&      \
    _zlsh_check 8  4  "$_zlsh_int" 7 &&\
    _zlsh_check 7  4  "$_zlsh_int" 7 && \
    _zlsh_bits 6                     &&\
    _zlsh_check 6  8  "$_zlsh_int" 6 && \
    _zlsh_check 6  1  "$_zlsh_int" 6 &&  \
    _zlsh_bits 7                     &&\
    _zlsh_check '' '' "$_zlsh_int" 7 ); }

#------------------------------------------------------------------------------
#, zlash_is_int
_ZLSH_DOC_TOPIC__zlash_is_int='validates a decimal integer

Checks that argument consists only of decimal digits, and the integer does not
exceed the maximum that shell can handle.
'
_ZLSH_DOC_USAGE__zlash_is_int='Usage
zlash_is_int decimal
'
_ZLSH_DOC_PARAMS__zlash_is_int='Parameters
1. *decimal*: a non-negative decimal integer
'
zlash_is_int() {
    if [ $# -eq 1 ]; then _zlsh_is_digits "$1" && _zlsh_is_int "$1"
    else _zlsh_usage zlash_is_int; return 64; fi; }
_zlsh_is_int() {
    _zlsh_ensure _zlsh_probe_maxint &&\
    _zlsh_is_int() {  # shellcheck disable=2071,3012
        [ "${#1}" -lt "${#ZLASH_MAXINT}" ] || {
            [ "${#1}" -eq "${#ZLASH_MAXINT}" ] && {
                test "$1" '<' "$ZLASH_MAXINT" || [ "$1" = "$ZLASH_MAXINT" ]; }
        }; } && _zlsh_is_int "$1"; }

#------------------------------------------------------------------------------
#, zlash_to_hexi
_ZLSH_DOC_TOPIC__zlash_to_hexi='decimal integer to hexadecimal

Convert a non-negative decimal integer to a hexadecimal.
'
_ZLSH_DOC_USAGE__zlash_to_hexi='Usage
zlash_to_hexi decimal [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_to_hexi='Parameters
1. *decimal*: a non-negative decimal integer
2. *out_vname*: an optional variable name to store result instead of outputing
   it to *STDOUT*
'
zlash_to_hexi() {
    _zlsh_ensure_MAXINT &&\
    zlash_to_hexi() {
        if  case $# in
                2)  _zlsh_is_digits "$1" &&\
                    _zlsh_is_vname  "$2" ;;
                1)  _zlsh_is_digits "$1" ;;
                *)  false; esac
        then
            if [   "${#1}" -lt "${#ZLASH_MAXINT}" ]\
            || { [ "${#1}" -eq "${#ZLASH_MAXINT}" ] \
                && { [   "$1" < "$ZLASH_MAXINT" ]    \
                    || [ "$1" = "$ZLASH_MAXINT" ]; }; }
            then _zlsh_to_hexi "$1"
            else printf '%s\n' "ERROR: $1 is too large." >&2; return 1
            fi && if [ $# -eq 2 ]
                then   eval    "$2=\$zlash_to_hexi"
                else printf '%s\n' "$zlash_to_hexi"; fi
        else _zlsh_usage zlash_to_hexi && return 64; fi; } &&\
    zlash_to_hexi "$@"; }
_zlsh_to_hexi() {
    # See shellbench/to_hex.sh for why this implementation is selected as a
    # portable fallback. (It's performance.)
    zlash_to_hexi='' &&\
    _zlsh_to_hexi=$1 && \
    while [ "$_zlsh_to_hexi" != 0 ]; do
        case $((_zlsh_to_hexi%16)) in
            ?) zlash_to_hexi=$((_zlsh_to_hexi%16))$zlash_to_hexi;;
            10) zlash_to_hexi=a$zlash_to_hexi;;
            11) zlash_to_hexi=b$zlash_to_hexi;;
            12) zlash_to_hexi=c$zlash_to_hexi;;
            13) zlash_to_hexi=d$zlash_to_hexi;;
            14) zlash_to_hexi=e$zlash_to_hexi;;
            15) zlash_to_hexi=f$zlash_to_hexi; esac &&\
        _zlsh_to_hexi=$((_zlsh_to_hexi/16)) || return 1; done; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_to_hexi() {  # shellcheck disable=2154
    zlash_to_hexi "$(( (1 << 31) - 1 ))" _zlsh_chk_to_hexi &&\
    [ "$zlash_to_hexi" = "$_zlsh_chk_to_hexi" ]            && \
    [ "$zlash_to_hexi" = "7fffffff" ]; }

#------------------------------------------------------------------------------
#, zlash_from_hexi
_ZLSH_DOC_TOPIC__zlash_from_hexi='hexadecimal integer to decimal

Convert a non-negative hexadecimal integer to a decimal.
'
_ZLSH_DOC_USAGE__zlash_from_hexi='Usage
zlash_to_hexi hexadecimal [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_from_hexi='Parameters
1. *hexadecimal*: a non-negative hexadecimal integer
2. *out_vname*: an optional variable name to store result instead of outputing
   it to *STDOUT*
'
zlash_from_hexi() {
    _zlsh_ensure_MAXINT_HEXI &&\
    zlash_from_hexi() {
        if  case $# in
                2)  _zlsh_is_xdigits "$1" &&\
                    _zlsh_is_vname   "$2" ;;
                1)  _zlsh_is_xdigits "$1" ;;
                *)  false; esac
        then _zlsh_from_hexi "$1" && if [ $# -eq 2 ]
            then   eval    "$2=\$zlash_from_hexi"
            else printf '%s\n' "$zlash_from_hexi"; fi
        else _zlsh_usage zlash_from_hexi && return 64; fi; } &&\
    zlash_from_hexi "$@"; }
_zlsh_from_hexi() {
    zlash_from_hexi=0   &&\
    _zlsh_from_hexi=$1  && \
    _zlsh_from_hexi_P=1 &&  \
    while [ "${_zlsh_from_hexi:+x}" ]; do
        case $_zlsh_from_hexi in
            *0) :;;
            *1) zlash_from_hexi=$((    _zlsh_from_hexi_P + zlash_from_hexi));;
            *2) zlash_from_hexi=$((2 * _zlsh_from_hexi_P + zlash_from_hexi));;
            *3) zlash_from_hexi=$((3 * _zlsh_from_hexi_P + zlash_from_hexi));;
            *4) zlash_from_hexi=$((4 * _zlsh_from_hexi_P + zlash_from_hexi));;
            *5) zlash_from_hexi=$((5 * _zlsh_from_hexi_P + zlash_from_hexi));;
            *6) zlash_from_hexi=$((6 * _zlsh_from_hexi_P + zlash_from_hexi));;
            *7) zlash_from_hexi=$((7 * _zlsh_from_hexi_P + zlash_from_hexi));;
            *8) zlash_from_hexi=$((8 * _zlsh_from_hexi_P + zlash_from_hexi));;
            *9) zlash_from_hexi=$((9 * _zlsh_from_hexi_P + zlash_from_hexi));;
            *a|*A) zlash_from_hexi=$((10*_zlsh_from_hexi_P+zlash_from_hexi));;
            *b|*B) zlash_from_hexi=$((11*_zlsh_from_hexi_P+zlash_from_hexi));;
            *c|*C) zlash_from_hexi=$((12*_zlsh_from_hexi_P+zlash_from_hexi));;
            *d|*D) zlash_from_hexi=$((13*_zlsh_from_hexi_P+zlash_from_hexi));;
            *e|*E) zlash_from_hexi=$((14*_zlsh_from_hexi_P+zlash_from_hexi));;
            *f|*F) zlash_from_hexi=$((15*_zlsh_from_hexi_P+zlash_from_hexi))
        esac\
        && _zlsh_from_hexi_P=$((16 * _zlsh_from_hexi_P))\
        && _zlsh_from_hexi=${_zlsh_from_hexi%?}          \
        || return 1; done; }
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
_zlsh_chk_from_hexi() { : # TODO
}

#------------------------------------------------------------------------------
#  Mapping of digits up to base 32
#  NOTE: This is the same mapping as b#n literals of Ksh and Bash, and is
#    not-compliant with RFC 4648, or other Base32 encoding standards. Also,
#    above base 36, case sensitivity becomes important.
_zlsh_ensure_digi_map() {
    if [ "${_ZLSH_DIGI_MAP_V-}" = '31' ]; then return 0; fi
    _ZLSH_DIGI_0=0  && _ZLSH_DIGI_MAP_0=0  &&             \
    _ZLSH_DIGI_1=1  && _ZLSH_DIGI_MAP_1=1  &&              \
    _ZLSH_DIGI_2=2  && _ZLSH_DIGI_MAP_2=2  &&               \
    _ZLSH_DIGI_3=3  && _ZLSH_DIGI_MAP_3=3  &&                \
    _ZLSH_DIGI_4=4  && _ZLSH_DIGI_MAP_4=4  &&                 \
    _ZLSH_DIGI_5=5  && _ZLSH_DIGI_MAP_5=5  &&                  \
    _ZLSH_DIGI_6=6  && _ZLSH_DIGI_MAP_6=6  &&                   \
    _ZLSH_DIGI_7=7  && _ZLSH_DIGI_MAP_7=7  &&                    \
    _ZLSH_DIGI_8=8  && _ZLSH_DIGI_MAP_8=8  &&                     \
    _ZLSH_DIGI_9=9  && _ZLSH_DIGI_MAP_9=9  &&                      \
    _ZLSH_DIGI_10=a && _ZLSH_DIGI_MAP_a=10 && _ZLSH_DIGI_MAP_A=10 &&\
    _ZLSH_DIGI_11=b && _ZLSH_DIGI_MAP_b=11 && _ZLSH_DIGI_MAP_B=11 && \
    _ZLSH_DIGI_12=c && _ZLSH_DIGI_MAP_c=12 && _ZLSH_DIGI_MAP_C=12 &&  \
    _ZLSH_DIGI_13=d && _ZLSH_DIGI_MAP_d=13 && _ZLSH_DIGI_MAP_D=13 &&   \
    _ZLSH_DIGI_14=e && _ZLSH_DIGI_MAP_e=14 && _ZLSH_DIGI_MAP_E=14 &&    \
    _ZLSH_DIGI_15=f && _ZLSH_DIGI_MAP_f=15 && _ZLSH_DIGI_MAP_F=15 &&     \
    _ZLSH_DIGI_16=g && _ZLSH_DIGI_MAP_g=16 && _ZLSH_DIGI_MAP_G=16 &&      \
    _ZLSH_DIGI_17=h && _ZLSH_DIGI_MAP_h=17 && _ZLSH_DIGI_MAP_H=17 &&       \
    _ZLSH_DIGI_18=i && _ZLSH_DIGI_MAP_i=18 && _ZLSH_DIGI_MAP_I=18 &&        \
    _ZLSH_DIGI_19=j && _ZLSH_DIGI_MAP_j=19 && _ZLSH_DIGI_MAP_J=19 &&         \
    _ZLSH_DIGI_20=k && _ZLSH_DIGI_MAP_k=20 && _ZLSH_DIGI_MAP_K=20 &&          \
    _ZLSH_DIGI_21=l && _ZLSH_DIGI_MAP_l=21 && _ZLSH_DIGI_MAP_L=21 &&           \
    _ZLSH_DIGI_22=m && _ZLSH_DIGI_MAP_m=22 && _ZLSH_DIGI_MAP_M=22 &&           \
    _ZLSH_DIGI_23=n && _ZLSH_DIGI_MAP_n=23 && _ZLSH_DIGI_MAP_N=23 &&           \
    _ZLSH_DIGI_24=o && _ZLSH_DIGI_MAP_o=24 && _ZLSH_DIGI_MAP_O=24 &&           \
    _ZLSH_DIGI_25=p && _ZLSH_DIGI_MAP_p=25 && _ZLSH_DIGI_MAP_P=25 &&           \
    _ZLSH_DIGI_26=q && _ZLSH_DIGI_MAP_q=26 && _ZLSH_DIGI_MAP_Q=26 &&           \
    _ZLSH_DIGI_27=r && _ZLSH_DIGI_MAP_r=27 && _ZLSH_DIGI_MAP_R=27 &&           \
    _ZLSH_DIGI_28=s && _ZLSH_DIGI_MAP_s=28 && _ZLSH_DIGI_MAP_S=28 &&           \
    _ZLSH_DIGI_29=t && _ZLSH_DIGI_MAP_t=29 && _ZLSH_DIGI_MAP_T=29 &&           \
    _ZLSH_DIGI_30=u && _ZLSH_DIGI_MAP_u=30 && _ZLSH_DIGI_MAP_U=30 &&           \
    _ZLSH_DIGI_31=v && _ZLSH_DIGI_MAP_v=31 && _ZLSH_DIGI_MAP_V=31; }

#------------------------------------------------------------------------------
#, zlash_to_base


#------------------------------------------------------------------------------
#, zlash_from_base

