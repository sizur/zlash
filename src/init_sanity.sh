# shellcheck disable=2016,2034
###############################################################################
#/ Sanity Check the underlying shell
#
#------------------------------------------------------------------------------
#, zlash_chk_init_sanity
#
_ZLSH_DOC_TOPIC__zlash_chk_init_sanity='shell sanity check

Check if Zlash assumptions hold under current shell, which are a subset of a
portable subset of the POSIX shell language.

Zlash does not support a shell under which this sanity check fails.

If `DEBUG` variable is non-empty, an effort is made to output execution trace.

The checks are all lumped together, since failing one is enough to bail out.
Isolating each individual test here could have a significant impact on
initialization performance, depending on underlying shell'\''s subshell
optimization techniques.

Current implementation priorities: smoke-testing assumptive features;
minimizing number of subshells for checks in aggregate (since this is executed
first during initialization, so on each shell invocation); and balancing being
consice (since this is just a minimal baseline check, before even anything
*Zlash* implements), (subjectively) readable, and have traceability helpers
(`"CHECK"` strings). The price it pays is individual checks composability --
checks rely on state modified by prior checks within this function'\''s
invocation. (At least this is the attempted justification of this mess of
a function.)

The sanity check is meant as a guard to not proceed unless we have enough
basic and critical capabilities, e.g. subshell isolation, substring removing
expansions (required for critical fallback implementation of quoting variable
content), etc...
'
# TODO: change this varname to a bootstrapped doc topic section dequeue.
zlash_chk_init_sanity__doc_ext_1='Significant Differences

Significant deviations in default basic behavior, most modifiable via options,
nevertheless necesitating omission from the baseline, with workarounds and in
order of shell availability prevalence:

- *Bash* aliases are not expanded in non-interactive shell mode.

    `shopt -s expand_aliases` is needed in non-interactive mode.

- *Bash* fails to use termorary environment `var= cmd` for some builtins.

    `var= eval cmd` is a workaround.

- *Bash* `return` fails if not executing a function or script. This feature is
  commonly used in Bash to check if a script is being sourced or executed as a
  script. *Zsh* and *Ksh93* have more direct ways to test this, but *Dash* has
  no reliable means of such a test at all.

- *Zsh* unquoted parameter expansions are not word-split.

    `${=var}` expansion flag needs to be used.

- *Zsh* unquoted pattern fragments derived from parameter expansions (or command
  substitutions) are treated as if they were quoted -- expanded pattern
  metacharacters are not special.

    `${~var}` unquoted expansion flag needs to be used in pattern context for
    expansion'\''s pattern metacharacters to be treated as such.

- *Zsh* does not have `0`-prefixed octal literals, not even in arithmetic
  context. `0x`-prefixed hexadecimal literals are available in arithmetic
  context ( `$((...))` ), but not in numeric context, ( `[ ... -eq ... ]` ).

    Hexadecimal literals in arithmetic contexts are sufficient for ergonomic
    bit manipulation. Additionally, multiple compatibility modes fix this as
    well.

- *Ksh93* function name validation adheres strongly to *POSIX* specification.

    `alias`  utilization is needed to relax invocation syntax.

- *Ksh93* does not restore command assignments after `var=val cmd` execution.
  This behavior is *POSIX-compliant*, since the standard has it specified as
  "unspecified".

    `typeset ...` in the body of a function defined using `function ...` syntax
    creates scoped variables local to function evaluation properly, without
    risk of collisions that are possible in *Bash*/*Zsh*/*Dash*.

- *Ksh93* converts integers to floating point numbers, if integer overflow would
   happen.

    Overflow test needs to be more robust than a simple sign check.

- *Ksh93* `printf %d\\n \""$var"` to get *ASCII* decimal value of the first
   character requires `$var` to expand to a single character.

- *Ksh93* `${#var}` results in a smaller number than expected for a byte map,
  when LC_ALL is not set. Exact conditions still need to be explored.

- *Ksh93* does not handle even number of nested quoted expansions (for some
  expansions) like other shells do. E.g.: `"${v1-"$v2"}"`,
  `${v1-"${v2-"$v3"}"}`.

    Quoting once is sufficient for all shells:

    ```bash
    [ "${v1-${v2-${v3-a b}}}" = "a b" ]
    ```

- *Dash* has no process substitutions like `<(...)`. This excludes checking the
  `.` sourcing command from sanity check, as it would require interfacing the
  filesystem.

    Use plain redirects, pipes, and command substitutions, instead of process
    substitutions, falling back to *FIFO*s, if needed. For example, if `cmdA`
    in the expression `cmdA < <(cmdB)` sets a `var` in current execution
    environment, it can instead use `printf` and be expressed as:

    ```bash
    var=$(cmdB | cmdA)
    ```

- *Dash* has no `let ...` command.

    `: $(( var = ... ))` can be used for arithmetic assignment expressions
    evaluation, or `[ $((...)) -ne 0 ]` for boolean arithmetic evaluation
    translated to shell'\''s success/failure. Extra precautions must be taken
    if these forms are evaluated by a shell that'\''s capable of at least
    indexed arrays (not *Dash*), since indexed array subscripts have arithmetic
    context, which is expanded recursively. This poses code injection
    vulnerability if not controlled or sanitized.

- *Dash* has no power operator in arithmetic context: `$((... ** ...))`.

- *Dash* has no sequence operator in arithmetic context: `$((... , ...))`.

- *Dash* arithmetic context ( `$((...))` ) does not expand recursively, like it
  does in more advanced shells. This is a more secure behavior deviation.

- *Dash* arithmetic context does not understand quoted expansion, like:
  `$(("$var"))`.

    Dynamic variables have to be unquoted, like `$((obj_$attr1+=$dyn$attr2))`,
    even though parsers (like *shellcheck*) will complain about bad syntax when
    of the `static$dynamic` form.

- *Dash* `eval "$code" 2>/dev/null || true` will exit with a fatal error if
  `$code` contains *Dash* parsing errors, instead of failing and letting `||`
  handle the failure.

    Syntax probing portably needs to be done in a subshell:

    ```bash
    if (eval ... 2>/dev/null) ...
    ```
'
zlash_chk_init_sanity() {
    if test "${DEBUG:+x}"
    then (   # Attempt to set execution trace and verbosity in a subshell.
        eval 'set -vx || set -v -x || set -x || set -v' >/dev/null 2>&1
        _zlsh_chk_init_sanity
    )
    else
        if _zlsh_chk_init_sanity
        then return 0
        else
            echo
            echo 'ERROR: FAILED Init Sanity Check!'
            echo '  Current shell is NOT POSIX-compatible!'
            echo
            echo '  For attempted execution trace, run:'
            echo
            echo '    DEBUG=1 zlash_chk_init_sanity'
            echo
            return 1
        fi
    fi
}
_zlsh_chk_init_sanity() {
    _zlsh_tmp_pass()    { return 0; }
    _zlsh_tmp_fail()    { return 1; }
    _ZLSH_TMP='NOT OK' || return 1
    : CHECK short-circuit operators as inverse-valued boolean logic
    _zlsh_tmp_fail || _zlsh_tmp_pass && : && true && ! false \
    &&  : CHECK '{...}' group compound command \
    &&  {
            ! true ||:
            : CHECK if command
            if false
            then          _ZLSH_TMP_2='NOT OK'
            else (! :) || _ZLSH_TMP_2='OK'
            fi
    }\
    &&  : CHECK eval command      \
    &&    eval 'true && ! false'   \
                                    \
    &&  : CHECK '(...)' subshell failure         \
    &&  if    (exit 1) || (return 1) || (false)   \
        ||    _ZLSH_TMP='OK'                       \
                                                    \
        &&  : CHECK command substitution                       \
        &&    _ZLSH_TMP_CHECKSUM=$(_zlsh_chk_init_sanity_helper)\
                                                                 \
        &&  : CHECK subshell isolation                  \
        &&  ! [ "${_ZLSH_DONOTSETME+x}" ]                \
        &&  ! eval CHECK failed isolation >/dev/null 2>&1 \
        &&    true
        then    : CHECK sanity                     \
            &&    [ "$_ZLSH_TMP" = 'OK' ]           \
            &&    [ "$_ZLSH_TMP" = "$_ZLSH_TMP_2" ]  \
            &&  : CHECK CHECK sum                     \
            &&    [ "${_ZLSH_TMP_CHECKSUM}" -eq 57 ]   \
                                                        \
            &&  : CHECK unset -v, -f command  \
            &&    unset -v  _ZLSH_TMP          \
                            _ZLSH_TMP_2         \
                            _ZLSH_TMP_CHECKSUM   \
            &&  ! [ "${_ZLSH_TMP+x}" ]            \
            &&  ! [ "${_ZLSH_TMP_2+x}" ]           \
            &&  ! [ "${_ZLSH_TMP_CHECKSUM+x}" ]     \
            &&    unset -f  _zlsh_tmp_fail           \
                            _zlsh_tmp_pass            \
            &&  ! eval _zlsh_tmp_pass >/dev/null 2>&1  \
                                                        \
            &&  return 0  # Sole success code path.
            return 1
        elif :; then return 1
        else return 1; fi; return 1; }
_zlsh_chk_init_sanity_helper() {
    # A counter of `CHECK` commands executed.
    _ZLSH_TMP_CHECKSUM=0 || exit 1
    : CHECK arithmetic assignment
    # shellcheck disable=2050,2078,2159,2161
    CHECK() {
        # CHECK [arg ...]
        # Arguments are for execution trace on failure.
        : CHECK $((_ZLSH_TMP_CHECKSUM += 1))
    }\
    && CHECK CHECK                            \
    &&    [ "${_ZLSH_TMP_CHECKSUM-}" -eq 1 ]   \
                                                \
    && CHECK function overriding existing command   \
    &&    true                                       \
    &&    true() { _ZLSH_TMP='NOT OK'; false; }       \
    &&  ! true                                         \
                                                        \
    && CHECK func redefinition   \
    &&    true() { return 0; }    \
    &&    true                     \
                                    \
    && CHECK test-\[ equivalence         \
    &&    test 1 && test 0 && ! test ''   \
    &&    [  1 ] && [  0 ] && ! [ '' ]     \
                                            \
    && CHECK integer vs string equality               \
    &&    [    1   -eq   1  ] && [    1   -eq 001    ] \
    &&  ! [    1    =  001  ] && [    1    =    1    ]  \
    &&    [    1    =   "1" ] && [    1    =   '1'   ]   \
    &&    [   ''    =   ''  ] && [ "value" = 'value' ]    \
    &&  ! [ 'value' =   ''  ] && [ "value" =  value  ]     \
                                                            \
    && CHECK arithmetic integers \
    &&    [ $((8 / 2)) -eq 4 ]    \
    &&    [ $((8 / 3)) -eq 2 ]     \
    &&    [ $((8 % 2)) -eq 0 ]      \
    &&    [ $((8 % 3)) -eq 2 ]       \
    &&    [ $((  1 + 2  * 3 )) -eq 7 ]\
    &&    [ $(( (1 + 2) * 3 )) -eq 9 ] \
    && CHECK arithmetic hexadecimal \
    &&    [ $((0x10 + 0xf)) -eq 31 ] \
    && CHECK arithmetic bit-shift \
    &&    [ $((   1 << 5)) -eq 32 ]\
    &&    [ $((0x20 >> 1)) -eq 16 ] \
    && CHECK arithmetic bit-logic                \
    &&    [ $((0x1100 & 0x0110)) -eq $((0x0100)) ]\
    &&    [ $((0x1100 | 0x0110)) -eq $((0x1110)) ] \
    &&    [ $((0x1100 ^ 0x0110)) -eq $((0x1010)) ]  \
    &&    [ $(( ~ 0x1 & 0xf   )) -eq $(( 0xe  )) ]   \
    && CHECK arithmetic comparison \
    &&    [ $((3 == 2 + 1)) -eq 1 ] \
    &&    [ $((3 != 2 + 1)) -eq 0 ]  \
    &&    [ $((3 >= 2 + 1)) -eq 1 ]   \
    &&    [ $((3 <= 2 + 1)) -eq 1 ]    \
    &&    [ $((3 >  2 + 1)) -eq 0 ]     \
    &&    [ $((3 <  2 + 1)) -eq 0 ]      \
    && CHECK arithmetic logic     \
    &&    [ $((!  0)) -eq 1 ]      \
    &&    [ $((! -2)) -eq 0 ]       \
    &&    [ $((   2 && - 3 )) -eq 1 ]\
    &&    [ $(( ! 2 ||   3 )) -eq 1 ] \
    &&    [ $((   2 && ! 3 )) -eq 0 ]  \
    &&    [ $((-1-  0 && 3 )) -eq 1 ]   \
    &&    [ $((-1<- 0 && 3 )) -eq 1 ]    \
    &&    [ $(( 2 && 0 + 3 )) -eq 1 ]     \
    &&    [ $(( 2 && 3 == 1)) -eq 0 ]      \
    && CHECK arithmetic ternary conditional       \
    &&    [ $(( - 1 - 0 ? 2 + 3 : 4 + 6 )) -eq 5 ] \
                                                    \
    && CHECK escaping                          \
    &&    [ "\"" =  '"' ] && [ "\\" =   \\  ]   \
    &&    [ "\`" =  '`' ] && [ "\$" =   '$' ]    \
    &&    [  "'" =  \'  ] && [  " " =   \   ]     \
    &&    [ "\ " = '\ ' ] && [ "\ " = \\\   ]      \
                                                    \
    && CHECK expanding/non-expanding quoting \
    &&  ! [  '$_ZLSH_TMP' =    'value'   ]    \
    &&  ! [  "$_ZLSH_TMP" =    'value'   ]     \
    &&  ! [  "$_ZLSH_TMP" = '$_ZLSH_TMP' ]      \
    &&    [ "\$_ZLSH_TMP" = '$_ZLSH_TMP' ]       \
    && CHECK non-local dynamic scoping            \
    &&    [  "$_ZLSH_TMP" =   'NOT OK'   ]         \
                                                    \
    && CHECK assignment no word-split          \
    &&    _ZLSH_TMP_3='OK; _ZLSH_TMP=OK'        \
    &&    _ZLSH_TMP_2=$_ZLSH_TMP_3               \
    &&    [ "$_ZLSH_TMP"   = 'NOT OK' ]           \
    &&    [ "$_ZLSH_TMP_2" = 'OK; _ZLSH_TMP=OK' ]  \
                                                    \
    && CHECK if cond assignment no word-split  \
    &&    _ZLSH_TMP_3='OK; _ZLSH_TMP=OK2'       \
    &&    if _ZLSH_TMP_2=$_ZLSH_TMP_3; then :; fi\
    &&    [ "$_ZLSH_TMP"   = 'NOT OK' ]           \
    &&    [ "$_ZLSH_TMP_2" = 'OK; _ZLSH_TMP=OK2' ] \
                                                    \
    && CHECK expansion non-arithmetic non-recursive  \
    &&    _ZLSH_TMP_3=3 && _ZLSH_TMP_2=_ZLSH_TMP_3    \
    &&    [ "$_ZLSH_TMP_2" = '_ZLSH_TMP_3' ]           \
                                                        \
    && CHECK concatenation                                    \
    &&    [ "_$_ZLSH_TMP, it's ok" = _NOT\ OK,' it'"'"'s ok' ] \
                                                                \
    && CHECK string length expansion  \
    &&    [ ${#_ZLSH_TMP} = '6' ]      \
                                        \
    && CHECK set/empty/assign param expn   \
    &&    [ "${_ZLSH_DONOTSETME-x}"  = 'x' ]\
    &&    [ "${_ZLSH_DONOTSETME:-x}" = 'x' ] \
    &&    [ "${_ZLSH_DONOTSETME+x}"  = ''  ]  \
    &&    [ "${_ZLSH_DONOTSETME:+x}" = ''  ]   \
    &&    [ "${_ZLSH_DONOTSETME=}"   = ''  ]    \
    &&    [ "${_ZLSH_DONOTSETME}"    = ''  ]     \
    &&    [ "${_ZLSH_DONOTSETME-x}"  = ''  ]      \
    &&    [ "${_ZLSH_DONOTSETME:-x}" = 'x' ]       \
    &&    [ "${_ZLSH_DONOTSETME+x}"  = 'x' ]        \
    &&    [ "${_ZLSH_DONOTSETME:+x}" = ''  ]         \
    &&    [ "${_ZLSH_DONOTSETME:=y}" = 'y' ]          \
    &&    [ "${_ZLSH_DONOTSETME}"    = 'y' ]           \
    &&    [ "${_ZLSH_DONOTSETME-x}"  = 'y' ]            \
    &&    [ "${_ZLSH_DONOTSETME:-x}" = 'y' ]             \
    &&    [ "${_ZLSH_DONOTSETME+x}"  = 'x' ]              \
    &&    [ "${_ZLSH_DONOTSETME:+x}" = 'x' ]               \
    &&    [ "${_ZLSH_DONOTSETME=z}"  = 'y' ]                \
    &&    [ "${_ZLSH_DONOTSETME:=z}" = 'y' ]                 \
    &&    [ "${_ZLSH_DONOTSETME}"    = 'y' ]                  \
    &&    [ "${_ZLSH_DONOTSETME2-$_ZLSH_DONOTSETME}" = 'y' ]   \
                                                                \
    && CHECK distinct variable versus function namespaces \
    &&  narg() {
            narg=$#
            frst=${1-}
            scnd=${2-}
            thrd=${3-}
        }\
    && CHECK argument passing                     \
    &&    narg '' '2 3' 4   && [ "$narg" -eq  3   ]\
                            && [ "$frst"  =  ''   ] \
                            && [ "$scnd"  = '2 3' ]  \
                            && [ "$thrd"  =  '4'  ]   \
    && CHECK parameter argument                        \
    &&    narg "$_ZLSH_TMP" && [ "$narg" -eq  1      ]  \
                            && [ "$frst"  = 'NOT OK' ]   \
    && CHECK empty parameter argument                     \
    &&    _ZLSH_TMP=''                                     \
    &&    narg "$_ZLSH_TMP" && [ "$narg" -eq  1 ]           \
                            && [ "$frst"  =  '' ]            \
    && CHECK no argument                                      \
    &&    narg && [ "$narg" -eq 0 ]                            \
                                                                \
    &&  recursive() {
            if [ "${1+x}" ]; then
                narg "$@"
            else
                CHECK recursion
                recursive '' '2 3' 4
            fi
        }\
    &&    recursive && [ "$narg" -eq  3    ]\
                    && [ "$frst"  =  ''    ] \
                    && [ "$scnd"  =  '2 3' ]  \
                    && [ "$thrd"  =  '4'   ]   \
                                                \
    && CHECK process substitution and printf\
    &&    [ "$(printf '%s\n' \'E)"  = \'E   ]\
    && CHECK printf ASCII code                \
    &&    [ "$(printf '%d\n' \'E)"  = '69'  ]  \
    && CHECK printf unsigned octal              \
    &&    [ "$(printf '%o\n' \'E)"  = '105' ]    \
    && CHECK printf unsigned hexadecimal          \
    &&    [ "$(printf '%x\n' \'E)"  = '45'  ]      \
                                                    \
    &&  is_valid() {
            # is_valid desc [str1 [str2 ...]]
            # Success if every strN is valid variable identifier.
            desc=$1
            _n=$#
            CHECK shift command
            shift
            CHECK -gt
            [ $_n -gt $# ] || return 1
            acc=0
            CHECK for, continue, and case commands
            for arg in "$@"; do
                case $arg in
                    [!_[:alpha:]]*|*[!_[:alnum:]]*) continue;;
                    *) acc=$((acc + 1));;
                esac
            done
            CHECK expected number of loops for number of matches
            [ $# -eq "$acc" ]
        }\
    && CHECK pattern matching                  \
    &&    is_valid 'var name' one Two _three_ _4\
    &&  ! is_valid 'bad var name'      '$one'    \
    &&  ! is_valid 'not good var name' 'one two'  \
    &&  ! is_valid 'also bad var name' '1_one'     \
                                                    \
    && CHECK substring removal           \
    &&                 _ZLSH_TMP='NOT OK' \
    &&    [ "${_ZLSH_TMP#?}"   =  'OT OK' ]\
    &&    [ "${_ZLSH_TMP#*O}"  =   'T OK' ] \
    &&    [ "${_ZLSH_TMP##*O}" =      'K' ]  \
    &&    [ "${_ZLSH_TMP%%O*}" = 'N'      ]   \
    &&    [ "${_ZLSH_TMP%O*}"  = 'NOT '   ]    \
                                                \
    && CHECK set -- command positional parameters  \
    &&    set -- '' '2 3' 4 && [ "$#" -eq  3    ]   \
                            && [ "$1"  =  ''    ]    \
                            && [ "$2"  =  '2 3' ]     \
                            && [ "$3"  =  '4'   ]      \
                                                        \
    && CHECK set command outputs safe representation \
    &&  repr() {
            # Takes a string and sets REPLY to its shell representation,
            # reusable as literal in eval.
            # NOTE: the string must not contain newlines.
            CHECK pipe read -r command respects IFS
            REPLY=$(
                repr=$1
                set | while IFS='' read -r line; do
                    # POSIX sh prefix "grep"-like
                    if [ "${line%"${line#'repr='}"}" ]; then
                        printf '%s\n' "${line#'repr='}"
                    fi
                done
            )
            [ "${REPLY+x}" ]
        }\
    &&  quote() {
            # Equivalent effect to `repr` (even if REPLYs are not equal),
            # without the newline limitation.
            REPLY=''
            while [ "${1-}" ]; do
                char=${1%"${1#?}"}
                set -- "${1#?}"
                [ "$char" = \' ]           \
                    && REPLY="${REPLY}'\''" \
                    || REPLY=$REPLY$char
            done
            REPLY="'${REPLY}'"
        }\
    &&  {   # In addition to sanity check failing, user will see "NOT_SECURE"
            # printed to /dev/stderr if current shell failed to single-quote or
            # escape properly.
            _ZLSH_TMP_2=\'';:$(printf \\n%s\\n NOT_SECURE >&2)'
            _ZLSH_TMP='it'\''s '"$_ZLSH_TMP_2"
        }\
    && CHECK eval naive unquoted interpolation      \
    &&    eval "_ZLSH_TMP_3=$_ZLSH_TMP" 2>/dev/null  \
    &&    [  "${_ZLSH_TMP_3}" = "its " ]              \
    && CHECK eval naive quoted interpolation           \
    &&    eval "_ZLSH_TMP_3=\"$_ZLSH_TMP\"" 2>/dev/null \
    &&    [  "${_ZLSH_TMP_3}" = "it's ';:" ]             \
    && CHECK eval sh quoted via set command repr          \
    &&    repr "$_ZLSH_TMP"                                \
    &&    [  "${#_ZLSH_TMP}" -eq  41         ]              \
    &&    [  "${#_ZLSH_TMP}" -lt "${#REPLY}" ]               \
    &&    eval  "_ZLSH_TMP_2=$REPLY"                          \
    &&    [    "$_ZLSH_TMP_2" = "$_ZLSH_TMP" ]                 \
    && CHECK eval sh quoted via '#, %' expansion operators \
    &&    quote "$_ZLSH_TMP"                                \
    &&    [   "${#_ZLSH_TMP}" -lt "${#REPLY}" ]              \
    &&    eval   "_ZLSH_TMP_2=$REPLY"                         \
    &&    [     "$_ZLSH_TMP_2" = "$_ZLSH_TMP" ]                \
                                                                \
    &&  {   # Confirm subshell isolation -- if after subshell exit, `true` or
            # `:` will fail, overall check cannot succeed, since the `if-then`
            # component block of the `if` compound command will not get
            # evaluated, and it is the only branch to return 0 (success) from
            # the sanity check.
            CHECK alias command
            # NOTE: We only check if `alias` command doesn't fail here. Checking
            #   alias expansion, attempting to renable alias expansions option
            #   on failure, re-evaluating a function definition command to let
            #   alias expand, and rechecking, is likely not a justified
            #   additional complexity for an already pretty complex
            #   "sanity-check".
            alias ':'='false'   || return 1
            true()   {
                # shellcheck disable=2317  # unreachable
                false
            } || return 1

            # Output number of `CHECK` commands executed.
            printf '%s\n' "${_ZLSH_TMP_CHECKSUM}"
        }\
    ||  return 1
}
