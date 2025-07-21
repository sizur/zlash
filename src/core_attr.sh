
# Zlash dev-env section dependencies. (stripped on release)
_zlsh__dev_load   \
    core_validators\
    || return 1

###############################################################################
#/ Lower-Level Attributes Implementation
#
#------------------------------------------------------------------------------
#, zlash_setattr
_ZLSH_TOPIC_zlash_setattr='set a variable attribute

Sets an attribute of a variable to a provided string.
'
_ZLSH_USAGE_zlash_setattr='Usage

zlash_setattr var attr val
'
_ZLSH_PARAMS_zlash_setattr='Parameters

1. *var*
   : Name of an existing variable who'\''s attribute is to be set.
2. *attr*
   : Name of an attribute to be set.
3. *val*
   : String value of the attribute to be set.
'
zlash_setattr () {
    if  case $# in
            3)  _zlsh_str_is_var_exists "$1" &&\
                _zlsh_str_is_vname_sfx  "$2" ;;
            *)   false; esac
    then _zlsh_setattr "$1" "$2" "$3"
    else _zlsh_usage zlash_setattr; return 64; fi; }
_zlsh_setattr () { eval '_ZLSH_A_'"$1"'__'"$2"'=$3'; }

#------------------------------------------------------------------------------
#, zlash_getattr
_ZLSH_TOPIC_zlash_getattr='get a variable attribute

Gets an attribute of a variable.  Fails if attribute doesn'\''t exist.
'
_ZLSH_USAGE_zlash_getattr='Usage

zlash_getattr var attr [out_vname]
'
_ZLSH_PARAMS_zlash_getattr='Parameters

1. *var*
   : Name of an existing variable who'\''s attribute is to be set.
2. *attr*
   : Name of an attribute to be set.
3. *out_vname*
   : Optional variable name where the attribute value will be stored, instead of
     output to *STDOUT*.
'
zlash_getattr () {  # shellcheck disable=2154
    if  case $# in
            3)  _zlsh_str_is_var_exists "$1" &&\
                _zlsh_str_is_vname_sfx  "$2" &&\
                _zlsh_str_is_vname      "$3" ;;
            2)  _zlsh_str_is_var_exists "$1" &&\
                _zlsh_str_is_vname_sfx  "$2" ;;
            *)  false; esac
    then _zlsh_getattr "$1" "$2" && if [ $# -eq 3 ]
        then   eval    "$3=\$zlash_getattr"
        else printf '%s\n' "$zlash_getattr"; fi
    else _zlsh_usage zlash_getattr; return 64; fi; }
_zlsh_getattr () {
    eval '[ "${_ZLSH_A_'"$1"'__'"$2"'+x}" ] &&'\
         'zlash_getattr=$_ZLSH_A_'"$1"'__'"$2"; }
_zlsh__getattr () { eval 'zlash_getattr=$_ZLSH_A_'"$1"'__'"$2"; }
