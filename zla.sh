# -*- mode: shell-script -*-
#
# TODO: Move this section to docs/shell-landscape.md
#
# Existing Shells Landscape (excluding archaic shells):
#
#  - bash :: Bourne Again Shell
#         PRO:
#              - ubiquitous (default on over 80% of all servers,
#                            assummed available by many standard tools),
#              - user-friendly for simple use,
#              - high POSIX compliance,
#              - stable adoption level (very slowly decreasing)
#              - excellent for prod envs where perf is not #1 constraint
#         CON:
#              - not user-friendly for advanced use,
#              - arcane invocations (consequence of POSIX compliance),
#              - ton of gotcha corner-case foot-shooters,
#              - text pipelines,
#              - compatibility concern causes very slow development
#              - performance is not the primary consideration
#          PERF (slower than zsh or ksh, latest at time of writing):
#              - 10x ksh,  ~   zsh in: command substitution
#              -  4x ksh, 1.5x zsh in: builtin output
#              -  4x ksh,  ~   zsh in: command evaluation
#              -  3x zsh,  3x  ksh in: definition evaluation
#              -  3x ksh,  ~   zsh in: positional args, str cmp
#              -  3x zsh, 2.5x ksh in: assignments
#              -  3x zsh,  2x  ksh in: increments
#              -  1.5-3x zsh, 1.5-3x ksh in: str ops via expansion
#
#  - zsh  :: [Zee-shell]
#          PRO:
#              - most user-friendly and most advanced *NIX shell,
#              - increasing adoption,
#              - under active development,
#              - high POSIX compliance,
#              - most advanced custom completion and interactive command line
#                          editing and prompting functionality from any shell
#              - excellent personal and production shell
#              - many extension modules available
#          CON:
#              - text pipelines,
#              - low (but increasing) adoption,
#              - arcane invocations (consequence of POSIX compliance)
#
#  - ksh  :: Korn Shell 93 (static scoping by default)
#          PRO:
#              - more advanced for few use-cases,
#              - required on few old enterprize UNIX systems
#              - few die-hard advanced users,
#              - very high POSIX compliance
#              - well suited for high-perf production environments
#              - outperforms dash
#          CON:
#              - very low and decreasing adoption,
#              - least user-friendly from major *NIX shells above,
#              - text pipelines,
#              - arcane invocations (consequence of POSIX compliance)
#              - non-existent development (some bug-fixes in over 20 years)
#              - not well suited as personal shell, by today's standards
#
#  - pwsh  :: PowerShell (relatively new, from Windows)
#          PRO:
#              - the most powerful shell of all currently,
#              - full .NET object pipelines, and integrated text pipelines,
#              - seamless in-process interoperability with any .NET language
#                                                            (C#, F#, etc...),
#              - very user-friendly (both simple and advanced use),
#              - discoverable functionality,
#              - under active development,
#              - available on MacOS and Linux
#              - well suited as personal shell on any major platform,
#              - extremely well suited as personal shell for .NET devs,
#                                 and as production shell in .NET environments
#              - many extension modules available,
#              - easy to create and publish extension modules
#          CON:
#              - adoption hurdles (Microsoft stigma, and works differently
#                                                      from any *NIX shell)
#              - no POSIX compliance,
#              - some *NIX usecases are not optimal (integration of POSIX parallel
#                                                    pipelines within object pipelines)
#              - will never be deployed on many *NIX production environments
#                (adds .NET runtime requirement, adding maintainability
#                 and attack surface concerns and costs, also in module providers)
#
#  - fish  :: Friendly Interactive Shell (relatively new *NIX shell)
#          PRO:
#              - structured text pipelines (helps avoid quoting pitfalls),
#              - very user-friendly for simple use,
#              - discoverable functionality for simple use
#          CON:
#              - no POSIX compliance by design,
#              - advanced abilities of other shells have no support in fish,
#              - will never be adopted in most production environments,
#              - suitable promarily as personal shell for its proponents,
#                      or in small and highly custom production environments.
#
#  - dash  :: Debian Almquist Shell
#          PRO:
#              - suitable for resource-starved production environments
#              - very high POSIX compliance
#          CONS:
#              - not suitable as personal shell
#              - no perf benefits compared to other major shells above
#              - arcane invocations (consequence of POSIX compliance)
#
#  - Oil   :: Oils for UNIX (OSH, YSH) (needs evaluation)
#
#  Exotic Shells to be evaluated (not POSIX compliant):
#
#     - xonsh   :: Python3.6-superset shell
#
#     - nushell :: Nu (pwsh-inspired cross-platform functional structured pipelines in Rust)
#
#     - elvish  :: (in Go)
#
# TODO: remove this brainstorm for naming.
# OUR PROJECT NAME PROPOSALS:
#
#  - Zlash    :: Zero-install adaptive structured shell
#               (similar-sounding to Slash (/), a very common command line character)
#
#  - Zrelish :: Zero-install relational interactive structured shell
#               (similar sounding to Zrelysh: deminutive of ripe or mature in
#                Russian, signifying this is serious business)
#               (similar sounding to Relish: something beautiful)
#
#               Diff between a function and a relation:
#
#               - Function: addition(augent, addent) -> sum
#
#                  Always one-directional: must provide two values to get the sum.
#
#               - Relation: addition(augent, addent, sum)
#
#                  Omnidirectional: any number of the three arguments
#                                   can be values or variables.
#
#                  If we use caps to denote variables, the following relation is
#                  equivalent to the addition function:
#
#                           addition(augent, addent, SUM)
#
#                  Yet the same relation with a different argument as variable
#                  is equivalent to a subtraction function:
#
#                           addition(AUGENT, addent, sum)
#
#                  And if more than one argument is a variable, a relation produces
#                  a (possibly infinite) result set of valid values for the variables.
#
# The following is aproject name brainstorming matrix, where letters in possible
# parentheses in interpretations are aligned to their anchors in project name.
# The numbers on the right margin denote interpretation groups that match well.
#
#            (i)nteractive   |
#        (rel)ational        |
#   ---------------------------
#    -  Z rel i  s  h
#    -  Z  l  a  s  h
#   ---------------------------
#      (Z)      (s)(h)       |
#           B(a)(s)(h)       |
#      (Z)en                 |
#      (Z)ero                | 1
#   instal(l)                | 1
#      (Z)ero-install        |
#         (l)ean             | 2
#         (l)ightweight      | 3
#         (l)ight            | 4
#            (a)bstraction   | 2,3,4
#            (a)dvanced      | 5
#            (a)daptive      | 6
#               (s)tructured | 7
#               (s)(h)ell    | 5,6
#                 s(h)ell    | 7
#

#
# Source this in Bash and Zsh login and interactive configurations,
# and if `/bin/sh` is Bash or Zsh, this will also be sourced by Pwsh
# when invoked as login shell.
#

# POSIX Shell Reference:
# https://pubs.opengroup.org/onlinepubs/9799919799/utilities/V3_chap02.html

# Disabling irrelevant shellcheck checks for the whole file:
#
#   - Use foo "$@" if function's $1 should mean script's $1.
#      ( https://www.shellcheck.net/wiki/SC2119 )
#
# shellcheck disable=SC2119

#------------------------------------------------------------------------------
### 1.    CONVENTIONS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
# POSIX compliance is assumed prior identification of supported shell and
# version.  After the shell and verion are identified, shell-specifics can
# be utilized.
#
# POSIX compliant functions have `_posix_` name prefix.
#
# Global variables have either a `ZLASH_` prefix, or `_ZLASH_`if they are
# private.
#
# Non-POSIX function naming convention underpins all the advanced mechanisms
# of Zlash.
#
# Functions are split into different kinds:
#
#   - Commands: <Verb>-<Noun>
#
#         Command function naming follows Powershell convention of a Noun
#         following a standard Verb, for the benefit of discoverability
#         (e.g. via `Get-Command` command).
#
#   - Namespaced: These are split thurther into:
#
#         - Static: <namespace>::<name>
#
#         - Member: $variable.<name>
#
# 
#
# Function names starting with an underscore (`_`) are private.
#
# Namespaces are encoded into function names, delimited by double colon (`::`).
#
# TODO more docs here

#------------------------------------------------------------------------------
### 2.    CONFIGURATION OPTIONS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#

# Auto-update `SHELL` environment variable for interactive shells.
#
# Some tools use `SHELL` value to determine what completions to install,
# resulting in what user may or may not be expecting. If you are using both Zsh
# and Bash, and want your "prefered" shell to be the current one, setting this
# to "always" maybe helpful.
#
# A setting of `once` maybe helpful for situations where you run different
# `main` sessions of Bash and Zsh, and want `SHELL` to not change for different
# subshell types.
#
# Valid values are:
#
#    - `always` :: update every time a shell starts and is interactive.
#
#    - `once`   :: interactive subshels will not auto-update it.
#
#    - `never`  :: keep the user login shell value.
#
# NOTE: POSIX-compliant syntax for default value if variable is unset, needed
#       in section before shell is discriminated and if this is sourced more
#       than once by shell with `nounset` set. (which we do set)
: ${ZLASH_SHELL_UPDATE:=always}
export ZLASH_SHELL_UPDATE

# Default indent level
: ${ZLASH_INDENT:=4}
export ZLASH_INDENT

# Optional Tools. A tool executable may have different names. Possibilities are
# separated by column (:).
: ${ZLASH_TOOL_BAT:=bat:batcat}
: ${ZLASH_TOOL_BAT_THEME:=gruvbox-dark}

# `true` or not.
: ${_ZLASH_IGNORE_ASSERTS:=false}

# New identifiers prefix.
#
# NOTE: This must be a valid variable identifier prefix uneder all supported
#       shells. (or modified during shell specialization accordingly)
: ${_ZLASH_IGEN_PREFIX:=_id}

#------------------------------------------------------------------------------
### 3.    SHELL TYPE AND VERSION IDENTIFICATION
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
# A very defensive section. before main definitions:
#
#   - Test shell type and version.
#
#   - Set minimal shell options, which are:
#
#         - Send HUP signal to jobs when shell exits.
#
#         - Error on use of an undeclared variable.
#
#         - Pipeline failing on any failed (and unhandled by `||`) participant,
#           instead of non-last participant's failure shadowd by the last
#           participant's status.
#
#

# An internal string representing the
# Type of the shell sourcing this.
: ${_ZLASH_SHELL_TYPE:=unknown}

# An internal string representing
# major dot minor decimal numbered version of the current shell,
# used by shell-agnosting version guarding code.
: ${_ZLASH_SHELL_VERSION:=0.0}

# An internal string representing the
# fullpath of the current shell.
: ${_ZLASH_SHELL_EXE:=$0}

# NOTE: On adding new shell type support.
#       `_posix_test_am<type>` to work correctly, the following requirements
#       must be met:
#
#         - parts of the function before <type> is determined must be POSIX
#           compliant
#
#         - `Test-Am<type>` testing conditions:
#
#             - positive self condition
#
#             - positive exclusion conditions of every other Zlash-supported
#               shell type
#
#         - positive self-exclusion condition added to every other Zlash-supported
#           shell type test

# `setopt` is not a Bash builtin.
# `ZSH_EVAL_CONTEXT` and `ZSH_SUBSHELL` are readonly variables in Zsh.
_posix_test_am_zsh() {
    # shellcheck disable=SC2034 # foo appears unused. Verify it or export it.
    if [ "$(builtin whence -w builtin 2>/dev/null)" = "builtin: builtin" ] \
    && [ "$(builtin whence -w setopt  2>/dev/null)" =  "setopt: builtin" ]  \
    && ! ( set -u; : "${.sh.version}"            ) > /dev/null 2>&1          \
    && ! (    ZSH_EVAL_CONTEXT=""                ) > /dev/null 2>&1           \
    && ! ( (( ZSH_SUBSHELL=0 , ZSH_SUBSHELL++ )) ) > /dev/null 2>&1
    then
        # POSIX compliance can be dropped here.
        _ZLASH_SHELL_TYPE="zsh"
        _ZLASH_SHELL_VERSION="${(j:.:)${${(s:.:)ZSH_VERSION}[@]:0:2}}"
        # builtin readonly -g _ZLASH_SHELL_TYPE _ZLASH_SHELL_VERSION
        _posix_test_am_zsh() { builtin return 0; }
        # builtin readonly -f _posix_test_am_zsh
        builtin return 0
    else
        # Can't guarantee the `builtin` builtin, nor `readonly -f`.
        _posix_test_am_zsh() { return 1; }
        return 1
    fi
}

# `shopt` is not a Zsh builtin.
# `BASH_VERSINFO` is a readonly variable in Bash.
_posix_test_am_bash() {
    # shellcheck disable=SC2030,SC2031
    if [ "$(builtin type -t builtin 2>/dev/null)" = "builtin" ] \
    && [ "$(builtin type -t shopt   2>/dev/null)" = "builtin" ]  \
    && ! ( set -u; : "${.sh.version}"    ) > /dev/null 2>&1       \
    && ! (             BASH_VERSINFO=(0) ) > /dev/null 2>&1
    then
        # POSIX compliance can be dropped here.
        _ZLASH_SHELL_TYPE="bash"
        _ZLASH_SHELL_VERSION="${BASH_VERSINFO[0]}.${BASH_VERSINFO[1]}"
        # NOTE: These are not to be cleared during env-clearing, if subshell
        #       doesn't want to lose their "specialness", except HOME, as per
        #       manpage.
        declare -ga _ZLASH_PROTECTED_VARS=(
            BASHPID       BASH_ALIASES    BASH_ARGV0 BASH_CMDS     BASH_COMMAND
            BASH_SUBSHELL COMP_WORDBREAKS DIRSTACK   EPOCHREALTIME EPOCHSECONDS
            FUNCNAME      GROUPS          HOME        LINENO        RANDOM
            SECONDS       SRANDOM         BASH_COMPAT BASH_XTRACEFD HOSTFILE
            MAILCHECK
        )
        # builtin readonly -g _ZLASH_SHELL_TYPE _ZLASH_SHELL_VERSION
        _posix_test_am_bash() { builtin return 0; }
        # builtin readonly -f _posix_test_am_bash
        builtin return 0
    else
        # Can't guarantee the `builtin` builtin, nor `readonly -f`.
        _posix_test_am_bash() { return 1; }
        return 1
    fi
}

# `shopt` and `setopt` are not Ksh builtins.
# `.sh.version` is an illegal veriable name in Bash and Zsh.
_posix_test_am_ksh() {
    if   [ "$(whence -t whence 2>/dev/null)" = "builtin" ] \
    && ! [ "$(whence -t shopt  2>/dev/null)" = "builtin" ]  \
    && ! [ "$(whence -t setopt 2>/dev/null)" = "builtin" ]   \
    && ! (          ZSH_EVAL_CONTEXT=""  ) >/dev/null 2>&1    \
    && ! (             BASH_VERSINFO=(0) ) >/dev/null 2>&1     \
    &&   ( set -u; : "${.sh.version}"    ) >/dev/null 2>&1
    then
        _ZLASH_SHELL_TYPE="ksh"
        # Test for some ksh93 features
        # TODO: check if `.sh.version` is already excluding older Ksh
        if (              [ "$((sqrt(9)))" = "3" ] ) 2>/dev/null \
        && ( v=( x="X" y="Y" ); [ "${v.y}" = "Y" ] ) 2>/dev/null
        then
            _ZLASH_SHELL_VERSION="93.0"
            # readonly _ZLASH_SHELL_TYPE _ZLASH_SHELL_VERSION
        else
            _ZLASH_SHELL_VERSION="0.0"
        fi
        _posix_test_am_ksh() { return 0; }
        return 0
    else
        _posix_test_am_ksh() { return 1; }
        return 1
    fi
}

# Initial POSIX-compliant implementation of a version test function,
# to be specialized after sanity checks and shell type and version
# discrimination, by appropriate and more performant implementation.
#
# Example:
#
#     _posix_test_version_majorminor "${VERSION:-0.0}" -ge 4.4 -lt 5.0
#
_posix_test_version_majorminor() {
    if [ "$#" -eq 0 ]; then
        echo "ERROR: Illegal _posix_test_version_majorminor" \
             "call with no arguments." >&2
        return 1
    fi
    [ "$#" -eq 1 ] && return 0
    _left="$1"
    shift
    if ! [ "$((${_left%%.*}))" = "${_left%%.*}" ] \
    || ! [ "$((${_left#*.}))"  = "${_left#*.}"  ]
    then
        echo "ERROR: _posix_test_version_majorminor numbers must be of the" \
             "decimal form: <major>.<minor>" >&2
        return 1
    fi
    while [ "$#" -gt 0 ]; do
        _op="$1"
        _right="$2"
        shift 2
        if ! [ "$((${_right%%.*}))" = "${_right%%.*}" ] \
        || ! [ "$((${_right#*.}))"  = "${_right#*.}"  ]
        then
            echo "ERROR: _posix_test_version_majorminor numbers must be of" \
                 "the decimal form: <major>.<minor>" >&2
            return 1
        fi
        case "$_op" in
            -ge|-le|-eq|-gt|-lt)
                if [ "${_left%%.*}" -eq "${_right%%.*}" ]; then
                    test "${_left#*.}" "$_op" "${_right#*.}" \
                        && continue || return $?
                else
                    test "${_left%%.*}" "$_op" "${_right%%.*}" \
                        && continue || return $?
                fi
                ;;
            *)
                echo "ERROR: _posix_test_version_majorminor comparison" \
                     "operator must be one of: -gt -lt -ge -le -eq" >&2
                return 1
                ;;
        esac
    done
    return 0
}

# Test supported shell type and version.
#
# TODO: Gradually lower minimal version
#       with more specialization using `Test-AmBash`, `Test-AmZsh`, etc...
_posix_id_shell_type() {
    if   _posix_test_am_bash; then
        if ! _posix_test_version_majorminor "$_ZLASH_SHELL_VERSION" -ge 5.2
        then
            builtin echo "WARNING:" "$_ZLASH_SHELL_TYPE" \
                    "$_ZLASH_SHELL_VERSION" "is too low!" >/dev/stderr
        fi
    elif _posix_test_am_zsh; then
        if ! _posix_test_version_majorminor "$_ZLASH_SHELL_VERSION" -ge 5.9
        then
            builtin echo "WARNING:" "$_ZLASH_SHELL_TYPE" \
                    "$_ZLASH_SHELL_VERSION" "is too low!" >/dev/stderr
        fi
    elif _posix_test_am_ksh; then
        if ! _posix_test_version_majorminor "$_ZLASH_SHELL_VERSION" -gt 93.0
        then
            echo "ERROR: ksh93 is not yet supported!" >/dev/stderr
            return 1
        fi
    else
        # TODO: check if POSIX guarantees /dev in all environments.
        echo "ERROR: failed to identify a supported shell type!" >&2
        return 1
    fi
}

_posix_id_shell_type || exit 1
# NOTE: POSIX compliance can be dropped from here, in favor of shell-specific
#       extenstions.

# NOTE: General Spacialization Pattern. Pre-specialized definitions are under
#       `Zlash::` namespace, for maximal dynamic introspection (dynamic
#       dependency resolution via dryrun debug traps, and minimal version
#       identification per function) and automatic forwarding of functionality
#       subsets to any remote supported shells.
Initialize-MinimalShellOptions() {
    Zlash::Initialize-MinimalShellOptions
            Initialize-MinimalShellOptions
}
Zlash::Initialize-MinimalShellOptions() {
    # TODO: Check what versions support these options.
    _posix_test_am_bash && \
        Initialize-MinimalShellOptions() {
            builtin local opt
            for opt in nounset pipefail; do
                builtin set -o $opt; done
            builtin shopt -s huponexit expand_aliases shift_verbose
        }
    _posix_test_am_zsh && \
        Initialize-MinimalShellOptions() {
            builtin setopt \
                    nolocaloptions ksharrays nounset pipefail errreturn \
                    hup aliases interactivecomments
        }
    _posix_test_am_ksh && \
        Initialize-MinimalShellOptions() {
            echo "Not Implemented!" >/dev/stderr
            exit 1
        }
}

Initialize-MinimalShellOptions
# NOTE: Can use alias expansion non-interactively from here.

Test-VersionMajorMinor() {
    Zlash::Test-VersionMajorMinor \
        && Test-VersionMajorMinor "$@"
}
Zlash::Test-VersionMajorMinor() {
    # Default unspecialized Test-VersionMajorMinor
    Test-VersionMajorMinor() { _posix_test_version_majorminor "$@"; }

    # TODO: Specialize as needed, like so:
    #
    # Test-AmBash -ge 5.2         && Test-VersionMajorMinor() { ... }
    # Test-AmBash -ge 5.0 -lt 5.2 && Test-VersionMajorMinor() { ... }
    # Test-AmBash -ge 4.4 -lt 5.0 && Test-VersionMajorMinor() { ... }
    # Test-AmBash -ge 4.0 -lt 4.4 && Test-VersionMajorMinor() { ... }
    # Test-AmZsh  -ge 5.0         && Test-VersionMajorMinor() { ... }
    # ... etc...
}

# NOTE: Try to avoid alias use in scripts, when possible.
#       Aliases introducing syntax are an obvious and rare exception.
alias amBash="Test-AmBash"
alias  amZsh="Test-AmZsh"
Test-AmBash() {
    _posix_test_am_bash && Test-VersionMajorMinor "$_ZLASH_SHELL_VERSION" "$@"
}
Test-AmZsh() {
    _posix_test_am_zsh && Test-VersionMajorMinor "$_ZLASH_SHELL_VERSION" "$@"
}

#------------------------------------------------------------------------------
### 4.    FOUNDATIONAL BOOTSTRAPPING DEFINITIONS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
# Bootstrapping foundational definitions here.  Their attibute definitions
# for parameters and help are added later, after attribute mechanisms are
# defined.
#

# TODO: check if this needs to be `printf` for more $IFS control,
#       and maybe specialized for Zsh?
Write-Out() { builtin echo "$@"; }
Write-Err() { builtin echo "$@" >/dev/stderr; }

# Making `$funcstack` work in Bash as in Zsh.
Test-AmBash -ge 5.0 && \
    builtin declare -gn funcstack="FUNCNAME"

# TODO: add more flag tests.
# TODO: decide if these should be moved and made inline later.
Test-IsFile()             { [[   -f "$1"   ]]; }
Test-IsExecutable()       { [[   -x "$1"   ]]; }
Test-IsReadable()         { [[   -r "$1"   ]]; }
Test-IsWritable()         { [[   -w "$1"   ]]; }
Test-IsDirectory()        { [[   -d "$1"   ]]; }
Test-IsPipe()             { [[   -p "$1"   ]]; }
Test-IsSocket()           { [[   -S "$1"   ]]; }
Test-IsTerminal()         { [[   -t "$1"   ]]; }
Test-IsShellInteractive() { [[ "$-" == *i* ]]; }
Test-IsShellRestricted()  { [[ "$-" == *r* ]]; }
Test-IsShellPrivileged()  { [[ "$-" == *p* ]]; }  # TODO: check zsh is same

# TODO: what are the minimal shell versions for str slicing?
Test-IsFullPath() { [[ "${1:0:1}" == "/" ]]; }

# TODO: clarify versions, and provide lower version implementations.
Test-IsAssocKey() { [[ -v "$1"'[$2]' ]]; }

: ${_ZLASH_SKIP_FRAMES:=0}

# Basic exception bootstrapping definitions,
# redefined/inlined after required definitions are complete.
Test-IsShellInteractive && \
    Error() {
        Write-Err \
            "$@" "in (" "${funcstack[@]:$((${_ZLASH_SKIP_FRAMES:-0}+1))}" ")" \
            ||:
        builtin return 1
    } \
    || \
    Error() {
        Write-Err \
            "$@" "in (" "${funcstack[@]:$((${_ZLASH_SKIP_FRAMES:-0}+1))}" ")" \
            ||:
        builtin exit 1
    }

Error::NotExpected() {
    Error "Unexpected state from call:" "${funcstack[0]}" "${@@Q}"
    return $?
}
Error::NotImplemented() {
    Error "${funcstack[0]}" "not implemented!"
    return $?
}

Test-IsShellLogin() { Error::NotImplemented; }
Test-AmBash && \
    Test-IsShellLogin() { builtin shopt -q login_shell; }

Error::Assertion() {
    Error "Failed Assertion:" "$@"
}

# TODO! (overriden on purpose, until available brain cycles)
Test-AmBash && \
    Error::DefaultHandler() {
        Write-Err "Unhandled Error:" "${FUNCNAME[0]}"                       \
                  "from"       "${FUNCNAME[$((${_ZLASH_SKIP_FRAMES:-0}+1))]}"\
                  "in"      "${BASH_SOURCE[$((${_ZLASH_SKIP_FRAMES:-0}+2))]}" \
                  "on line" "${BASH_LINENO[$((${_ZLASH_SKIP_FRAMES:-0}+1))]}"
    }
Error::DefaultHandler() { Error::NotImplemented; }
Error::DebugHandler()   { Error::NotImplemented; }

# Simply writes a message to STDERR and returns 1.  Is made inline later.
Fail() { [[ $# -gt 0 ]] && Write-Err "$@" ||:; builtin return 1; }
# Is made inline later.
Pass() { return 0; }

alias  silent="Invoke-Silent"
alias onlyout="Invoke-OnlyOut"
alias  nofail="Invoke-NoFail"
alias  assert="Invoke-Assert"
Invoke-Silent()  { "$@" &>/dev/null; }
Invoke-OnlyOut() { "$@" 2>/dev/null; }
Invoke-NoFail()  { "$@" || builtin return 0; }
Invoke-Assert()  {
    local _ZLASH_SKIP_FRAMES=2
    # eval for syntactic constructs like !,  [, [[, etc... to work.
    eval "$@" || Error::Assertion "$@"
}
Invoke-NoError() { Error::NotImplemented; }  # TODO!

[[ ${_ZLASH_IGNORE_ASSERTS:-false} == 'true' ]] && \
    alias assert=':'

# TODO: implement
Test-IsWindows() { Error::NotImplemented; }

# NOTE: Default implementations should have meaningful errors.
Test-ExesExist() { Error::NotImplemented; }
# NOTE: This relies on BASH_CMDS to not lose its specialness.
#       (not manually unset)
Test-AmBash -ge 5.0 && \
    Test-ExesExist() {
        local -i status=0
        local cmd
        for cmd in "$@"; do
            # If fullpath and executable file, we're done.
            Test-IsFullPath          "$cmd" \
                && Test-IsFile       "$cmd"  \
                && Test-IsExecutable "$cmd"   \
                && continue ||:
            # Did we already find it?
            Test-IsAssocKey BASH_CMDS "$cmd" && continue ||:
            # Let's force PATH search, even if $cmd is shadowed by
            # alias, function, builtin, or keyword.
            local onpath
            if onpath="$(Invoke-OnlyOut builtin type -P "$cmd")"; then
                Invoke-Assert builtin hash -p "$onpath" "$cmd"
            else
                Fail "Required command not available:" "$cmd" \
                    || status=$?
            fi
        done
        builtin return $status
    }

Get-ExeFullPath() { Error::NotImplemented; }
Test-AmBash -ge 5.0 && \
    Get-ExeFullPath() {
        local cmd="$1"
        local -n out="${2:-REPLY}"
        if Invoke-Silent Test-ExesExist "$cmd"; then
            if Test-IsFullPath "$cmd"; then
                out="$cmd"
            else
                assert Test-IsAssocKey BASH_CMDS "$cmd"
                out="${BASH_CMDS[$cmd]}"
            fi
        else
            Fail "WARINING: Executable not available:" "$cmd"
        fi
    }

# TODO: wrap this with handling object types later.
Get-NamesByType() { Error::NotImplemented; }
Test-AmBash -ge 5.0 && \
    Get-NamesByType() {
        local action="$1"
        local prefix="${2:-}"
        local filterpat="${3:-}"
        local -n out="${4:-REPLY}"
        local -A compgen_args=(["-A"]="$action" ["-o"]="nosort")
        [[ -n "$filterpat" ]] && compgen_args["-X"]="$filterpat"
        local IFS=$'\n'
        out=()
        < <(builtin compgen "${compgen_args[@]@k}" -- "$prefix") \
          builtin read -d '' -a out
    }

Get-AliasNames() { Error::NotImplemented; }
Test-AmBash -ge 5.0 && \
    Get-AliasNames() { Get-NamesByType "alias" "$@"; }

Get-FunctionNames() { Error::NotImplemented; }
Test-AmBash -ge 5.0 && \
    Get-FunctionNames() { Get-NamesByType "function" "$@"; }

Get-BuiltinNames() { Error::NotImplemented; }
Test-AmBash -ge 5.0 && \
    Get-BuiltinNames() { Get-NamesByType "builtin" "$@"; }

Get-KeywordNames() { Error::NotImplemented; }
Test-AmBash -ge 5.0 && \
    Get-KeywordNames() { Get-NamesByType "keyword" "$@"; }

Get-VariableNames() { Error::NotImplemented; }
Test-AmBash -ge 5.0 && \
    Get-VariableNames() { Get-NamesByType "variable" "$@"; }

Get-ShellOptionNames() { Error::NotImplemented; }
Test-AmBash -ge 5.0 && {
    Get-ShellOptionNames() {
        local prefix="${1:-}"
        local filterpat="${2:-}"
        local -n out="${3:-REPLY}"
        local -A names=()
        local -a set_opt_names shopt_names
        Get-BashSetOptNames "$prefix" "$filterpat" set_opt_names
        Get-BashShoptNames  "$prefix" "$filterpat"   shopt_names
        local name
        for name in "${set_opt_names[@]}" "${shopt_names[@]}"; do
            names["$name"]=""; done
        out=("${!names[@]}")
    }
    # The following two are Bash-specific, due to historical mess of `set -o`
    # and `shopt`.
    Get-BashSetOptNames() { Get-NamesByType "setopt" "$@"; }
    Get-BashShoptNames()  { Get-NamesByType  "shopt" "$@"; }
}

Test-IsAliasName()        { Invoke-Silent builtin alias      "$1"; }
Test-IsFunctionName()     { Invoke-Silent builtin declare -f "$1"; }
Test-IsVarName()          { Invoke-Silent builtin declare -p "$1"; }
Test-IsAssocOrIxArrName() { Error::NotImplemented; }
Test-IsAssocName()        { Error::NotImplemented; }
Test-IsIxArrName()        { Error::NotImplemented; }
Test-IsKeywordName()      { Error::NotImplemented; }
Test-IsBuiltinName()      { Error::NotImplemented; }
Test-IsExeName()          { Error::NotImplemented; }
# TODO: implement Zsh versions
Test-AmBash -ge 5.0 && {  # TODO: implement lower Bash versions
    Test-IsAssocOrIxArrName() {
        Test-IsVarName "$1" && local -n ref="$1" && [[ "${ref@a}" == *[aA]* ]]
    }
    Test-IsAssocName() {
        Test-IsVarName "$1" && local -n ref="$1" && [[ "${ref@a}" == *A* ]]
    }
    Test-IsIxArrName() {
        Test-IsVarName "$1" && local -n ref="$1" && [[ "${ref@a}" == *a* ]]
    }
}
Test-AmBash && {
    Test-IsKeywordName() {
        [[ "$(Invoke-OnlyOut builtin type -ta "$1")" == *keyword* ]]
    }
    Test-IsBuiltinName() {
        [[ "$(Invoke-OnlyOut builtin type -ta "$1")" == *builtin* ]]
    }
    Test-IsExeName() {
        [[ "$(Invoke-OnlyOut builtin type -ta "$1")" == *file* ]]
    }
}

Test-AmMacOS() {
    if [[ "$OSTYPE" == "darwin"* ]]        \
    && Invoke-Silent Test-ExesExist "uname" \
    && [[ "$(builtin command uname -s)" == "Darwin" ]]
    then
        Test-AmMacOS() { builtin return 0; }
        builtin return 0
    else
        Test-AmMacOS() { builtin return 1; }
        builtin return 1
    fi
}

Test-AmBash && Test-AmSubshell() { [[ $((BASH_SUBSHELL)) -gt 0 ]] }
Test-AmZsh  && Test-AmSubshell() { [[ $(( ZSH_SUBSHELL)) -gt 0 ]] }

# Used by `Set-Reply` to determine if reply should be shown on stdout or not.
Test-AmShowing() {
    builtin local -i skip="${1:-0}"
    Test-IsTerminal 1 \
        && [[ ${#funcstack[@]} -le $((${_ZLASH_SKIP_FRAMES:-0} + skip + 2)) ]]
}

Test-AmUserControlled() { Test-IsTerminal 0      ; }
Test-AmPiping()         { Test-IsPipe /dev/stdout; }
Test-AmPiped()          { Test-IsPipe /dev/stdin ; }

# Pipeline situation under normal conditions:
#           $  a  |  b  |  c
#     stdin : tty   pipe  pipe        a: Piping  && UserControlled
#    stdout : pipe  pipe  tty         b: Piping  && Piped
#    stderr : tty   tty   tty         c: Showing && Piped

Write-IndentOut() {
    local -i indent
    if [[ $# -gt 0 ]]; then
        indent="$1"
        shift
    else
        indent="${ZLASH_INDENT:-4}"
    fi
    local line
    if [[ $# -gt 0 ]]; then
        local text="$*"
        # local old_ifs="$IFS" IFS=$'\n'
        # local -a lines=($text)
        local -a lines=()
        mapfile -t lines <<<"$text"
        # IFS="$old_ifs"
        for line in "${lines[@]}"; do
            builtin printf "%${indent}s%s\n" "" "$line"
        done
    elif Test-AmPiped; then
        while IFS= read -r line; do
            builtin printf "%${indent}s%s\n" "" "$line"
        done
    fi
}

# Same as `Write-IndentOut`, except 1st line is not indented.
Write-IndentEx1stOut() {
    local -i indent
    if [[ $# -gt 0 ]]; then
        indent="$1"
        shift
    else
        indent="${ZLASH_INDENT:-4}"
    fi
    local first=true
    local line
    if [[ $# -gt 0 ]]; then
        local text="$*"
        local old_ifs="$IFS" IFS=$'\n'
        local -a lines=($text)
        IFS="$old_ifs"
        for line in "${lines[@]}"; do
            if $first; then
                builtin printf "%s\n" "$line"
                first=false
            else
                builtin printf "%${indent}s%s\n" "" "$line"
            fi
        done
    elif Test-AmPiped; then
        while IFS= read -r line; do
            if $first; then
                builtin printf "%s\n" "$line"
                first=false
            else
                builtin printf "%${indent}s%s\n" "" "$line"
            fi
        done
    fi
}

# Write to stdout values of arguments, and for each, if it is an object,
# introspect it, and if it is a word for existing name of an alias, keyword,
# function, builtin, command, global, and local variable. If called with a
# single argument, shows function implementation, all executables, and variabel
# contents.
# TODO: split variable output by global/local.
# TODO: wrap this with object introspection
alias show="Show-Args"
Show-Args() { Error::NotImplemented; }
# Syntax highlighter helpers, overriden if `bat` is available.
# Used for argument lines.
Show-Args::Invoke-Out() { "$@"; }
# Used for brief descriptions per argument.
Show-Args::Invoke-IndentOut() { "$@" | Write-IndentOut; }
# Used for source, if `Show-Args` has a single argument.
Show-Args::Invoke-IndentSrcOut() { "$@" | Write-IndentOut; }
Test-AmBash && \
    Show-Args() {
        local -i i=0
        local arg
        for arg in "$@"; do
            Show-Args::Invoke-Out Write-Out "\$$((++i))=${arg@Q}"
            Test-IsFunctionName "$arg" && {
                if [[ $# -eq 1 ]]; then
                    Show-Args::Invoke-IndentSrcOut \
                        Invoke-Assert builtin declare -f "$arg"
                else
                    Show-Args::Invoke-IndentOut Write-Out "${arg}() {...}"
                fi
            }   ||:
            Test-IsVarName "$arg" && {
                if [[ $# -eq 1 ]]; then
                    Show-Args::Invoke-IndentSrcOut \
                        Invoke-Assert builtin declare -p "$arg"
                else
                    local decl
                    decl="$(Invoke-Assert builtin declare -p "$arg")"
                    Show-Args::Invoke-IndentOut Write-Out "${decl%%=*}=..."
                fi
            }   ||:
            Test-IsKeywordName "$arg"                              \
                && Show-Args::Invoke-IndentOut Write-Out "# keyword"\
                ||:
            Test-IsBuiltinName "$arg"                              \
                && Show-Args::Invoke-IndentOut Write-Out "# builtin"\
                ||:
            Test-IsExeName "$arg"                                  \
                && Invoke-Assert Get-ExeFullPath "$arg"             \
                && Show-Args::Invoke-IndentOut Write-Out "# ${REPLY}"\
                ||:
            Test-IsAliasName "$arg" && {
                Show-Args::Invoke-IndentOut \
                    Write-Out "$(Invoke-Assert builtin alias "$arg")"
            }   ||:
        done
    }

# Object cell assoc.
declare -gA _ZLASH_CELL=()

# Confirm-IsObj "$var"
Test-IsObject() { [[ -v '_ZLASH_CELL[$1]' ]]; }

#------------------------------------------------------------------------------
### 5.    LOWER-LEVEL FUNCTION HANDLING
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
#

# ScriptBlock Source Cache
declare -gA _ZLASH_SCRIPTBLOCK=()

# Cache and get a reference to function's body source.
Get-ScriptBlockSrcRef() { Error::NotImplemented; }
Test-AmBash && \
    Get-ScriptBlockSrcRef() {
        local func_name="$1"
        local -n out_ref="${2:-REPLY}"
        if Test-IsAssocKey _ZLASH_SCRIPTBLOCK "$func_name"; then
            out_ref="_ZLASH_SCRIPTBLOCK[$func_name]"
        else
            local func_src
            if func_src="$(Invoke-OnlyOut builtin declare -f "$func_name")"
            then
                # shellcheck disable=SC2034
                _ZLASH_SCRIPTBLOCK["$func_name"]="{${func_src#*\{}" \
                    && out_ref="_ZLASH_SCRIPTBLOCK[$func_name]"
            else
                Fail "Error: Can't get ScriptBlock of ${func_name}"
            fi
        fi
    }

# Used in mechanisms like object instantiation and class inheritance.
Copy-Function() { Error::NotImplemented; }
Test-AmBash && \
    Copy-Function() {
        local func_name="$1" target_name="$2" ScriptBlockSrcRef
        Get-ScriptBlockSrcRef "$func_name" ScriptBlockSrcRef \
            && local -n ScriptBlockSrcRef                     \
            && eval "${target_name}() $ScriptBlockSrcRef"      \
            && _ZLASH_SCRIPTBLOCK["$target_name"]="$ScriptBlockSrcRef"
    }

Remove-Function() { Error::NotImplemented; }
Test-AmBash && \
    Remove-Function() {
        local func_name="$1"
        # https://www.shellcheck.net/wiki/SC2184
        if Test-IsFunctionName "$func_name"; then
            builtin unset -f "$func_name" \
                && builtin unset '_ZLASH_SCRIPTBLOCK[$func_name]'
        else
            Fail "Error: Can't remove non-existent function: ${func_name}!"
        fi
    }
Test-AmZsh && \
    Remove-Function() {
        local func_name="$1"
        # https://www.shellcheck.net/wiki/SC2184
        if Test-IsFunctionName "$func_name"; then
            builtin unfunction "$func_name" \
                && builtin unset '_ZLASH_SCRIPTBLOCK[$func_name]'
        else
            Fail "Error: Can't remove non-existent function: ${func_name}!"
        fi
    }

Move-Function() {
    local func_name="$1" target_name="$2"
    Copy-Function "$func_name" "$target_name" \
        && Remove-Function "$func_name"
}

# This is used to inline functions that need to operate in
# scope of their caller.  These functions cannot receive any arguments.
# NOTE: If function is not supplied, the function name used is
#       alias name appended with "::__func__" suffix.
New-AliasScriptBlock() { Error::NotImplemented; }
Test-AmBash -ge 5.0 && \
    New-AliasScriptBlock() {
        local alias_name="$1" func_name="${2:-}" ScriptBlockSrcRef
        [[ -z "$func_name" ]] && func_name="${alias_name}::__func__"
        # shellcheck disable=SC2139
        if Get-ScriptBlockSrcRef "$func_name" ScriptBlockSrcRef \
        && local -n ScriptBlockSrcRef
        then
            # NOTE: This must remain separate from logical pipeline above, or
            #       the `ScriptBlockSrcRef` will be expanded before it's
            #       assigned and set as a name reference.
            alias "$func_name"="$ScriptBlockSrcRef"
        else
            Error::NotExpected
        fi
    }

#------------------------------------------------------------------------------
### 6.    HOOKING MECHANISM
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#



#------------------------------------------------------------------------------
### 6.    ONRETURN AND ONERROR INLINE HOOKS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#

# Invoked each callback in the provided indexed array with optional arguments.
#
#     Invoke-CallbacksIxArr CALLBACKS_ARR [arg1 ...]
#
# TODO: Decide if more control should be provided via CB return values.
Invoke-CallbacksIxArr() { Error::NotImplemented; }
Test-AmBash -ge 5.0 && \
    Invoke-CallbacksIxArr() {
        local -n arr="$1"
        local cmd
        for cmd in "${arr[@]}"; do
            "$cmd" "$@"
        done ||:
    }

# Intended to be inline.
Use-OnReturn() {
    # Idempotent
    if ! [[ "${_ZLASH_ONRET_FRAME:-0}" -eq "${#funcstack[@]}" ]]; then
        local        -i _ZLASH_ONRET_FRAME="${#funcstack[@]}" \
            && local -a _ZLASH_ONRET_CBS=()                    \
            && trap 'Invoke-CallbacksIxArr _ZLASH_ONRET_CBS' RETURN
    fi ||:
}

Add-OnReturnCB() {
    [[ $((${_ZLASH_ONRET_FRAME:-0} + 1)) -eq "${#funcstack[@]}" ]] \
        && _ZLASH_ONRET_CBS+=("$@")                                 \
        || Error "${funcstack[0]}"                                   \
                "must be used after Use-OnReturn in the same scope!"
}

# Intended to be inline.
Use-OnError() {
    local -a _ZLASH_ONERR_CBS=() \
        && trap 'Invoke-CallbacksIxArr _ZLASH_ONERR_CBS' ERR
}

Add-OnErrorCB() {
    [[ $((${_ZLASH_ONERR_FRAME:-0} + 1)) -eq "${#funcstack[@]}" ]] \
        && _ZLASH_ONERR_CBS+=("$@")                                 \
            || Error "${funcstack[0]}"                                   \
                     "must be used after Use-OnError in the same scope!"
}

#------------------------------------------------------------------------------
### 6.    FUNCTION INLINING AND WRAPPING FUNCTIONALITY
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
# NOTE: Inlining is not intended to be for performance gain, but to provide
#       reusability of a command group to be executed in a coller's context,
#       while also retaining syntax and static analysis checking ability.

# Defensive bootstrapping inlining definitions.
_ZLASH::Bootstrap-Inlines() {
    local name reeval=false
    for name in "$@"; do
        # If it's already bootstrap-inlined, continue.
        if Test-IsFunctionName "${name}::__func__"; then
            Test-IsAliasName "$name" \
                && continue           \
                || { Error::NotExpected ||:; return 1; }
        fi
        Move-Function               "$name" "${name}::__func__" \
            && New-AliasScriptBlock "$name" "${name}::__func__"  \
            || { Error::NotExpected ||:; return 1; }
        reeval=true
    done
    # Re-evaluate defined functions, if new aliases.
    if "$reeval"; then
        eval declare -f || { Error::NotExpected ||:; return 1; }
    fi ||:
}

Error::NotExpected() { Error::NotImplemented; }
Test-AmBash && \
    Error::NotExpected() {
        Error "Unexpected state from call:" "${funcstack[0]}" "${@@Q}"
        return $?
    }

Use-LocalNoGlob() { Error::NotImplemented; }
Test-AmBash && \
    Use-LocalNoGlob() {
        trap "eval $(Invoke-NoFail builtin shopt -po noglob)" RETURN
        Invoke-Assert builtin set -o noglob
    }

# TODO: need to add any others here?
_ZLASH::Bootstrap-Inlines \
    Error::NotImplemented  \
    Error::NotExpected      \
    Use-LocalNoGlob

# Unique name generating counters.
#
# NOTE: Idempotance for re-sourcing this. We don't want to lose live
# identifiers.
Test-IsAssocName   _ZLASH_IGEN \
    || declare -gA _ZLASH_IGEN=()
Test-IsAssocKey    _ZLASH_IGEN "${_ZLASH_IGEN_PREFIX:-_id}" \
    ||             _ZLASH_IGEN["${_ZLASH_IGEN_PREFIX:-_id}"]=0

New-Identifier() {
    :
}
# Generated names match a regex pattern:
#
#     /(?name:[^#[:space:]]+)#(?igen:[[:digit:]]+)/
#
# Acceptable basis names must match the `name` portion of the above regex.
New-NameFrom() { Error::NotImplemented; }
Test-AmBash -ge 5.0 && \
    New-NameFrom() {
        local name="${1%#*}"
        local -n out="${2:-REPLY}"
        [[ "$name" == +([^#[:space:]$])'#'+([[:digit:]]) ]]
    }

# Mapping of inlined function names as aliases to new names.
declare -gA _ZLASH_INLINES=()

# Mapping of original function names to integral counter of wraps, used to
# create unique function names for wrapping or inlining.
declare -gA _ZLASH_ORIG=()

Test-IsNoArgsFunction() { Error::NotImplemented; }
Test-AmBash -ge 5.0 && \
    Test-IsNoArgsFunction() {
        local func_name="$1" ScriptBlockSrcRef
        if Get-ScriptBlockSrcRef "$func_name" ScriptBlockSrcRef \
        && local -n ScriptBlockSrcRef
        then
            [[ "$ScriptBlockSrcRef" != *'$'[1-9#@]* ]] && \
            [[ "$ScriptBlockSrcRef" != *'${'[1-9@]* ]]
        else
            Error::NotExpected
        fi
    }

Test-IsFunctionInline() { Error::NotImplemented; }
# NOTE: This relies on `BASH_ALIASES` specialness.
Test-AmBash && \
    Test-IsFunctionInline() {
        local func_name="$1"
        Test-IsAliasName "$func_name"                            \
            && Test-IsFunctionName   "${BASH_ALIASES[$func_name]}"\
            && Test-IsNoArgsFunction "${BASH_ALIASES[$func_name]}" \
            && Test-Assert Test-IsAssocKey _ZLASH_INLINES "$func_name"
        # Asserting to make a non-duck illegal, if it quacks.
    }

Set-FunctionInline() {
    local func_name="$1"
    Test-IsFunctionInline "$func_name" && return 1 ||:
    Test-IsNoArgsFunction "$func_name"                                    \
        || Error "Cannot inline function that uses arguments:" "$func_name"\
        || return 1
    Test-IsAssocKey _ZLASH_IGEN "$func_name" \
        || _ZLASH_IGEN["$func_name"]=0
    if local new_name="${func_name}#$((++_ZLASH_IGEN["$func_name"]))"; then
        Move-Function "$func_name" "$new_name"
        alias "$func_name"="$new_name"
    else
        Error::NotExpected
    fi
}


#------------------------------------------------------------------------------
# A brief detour for some convenience wrappers.
#
# TODO: Move this much lower and make more robust?

Get-ToolFullPath() { Error::NotImplemented; }
Test-AmBash -ge 5.0 && \
    Get-ToolFullPath() {
        local tool="$1" name
        local -n out="$2"
        local -a possibilities
        read -d ":" -a possibilities <<<"$tool"
        for name in "${possibilities[@]}"; do
            Invoke-Silent Get-ExeFullPath "$name" out && Pass ||:
        done
        Fail ""
    }

Test-ExesExist "${ZLASH_TOOL_BAT:-bat}" && {
    Get-ExeFullPath "${ZLASH_TOOL_BAT:-bat}" ZLASH_TOOL_BAT
    Show-Args::Invoke-Out() {
        "$@"\
            | "$ZLASH_TOOL_BAT"         \
                    --language    bash  \
                    --italic-text always \
                    --paging      never   \
                    --style       plain    \
                    --color       auto      \
                    --theme       "$ZLASH_TOOL_BAT_THEME"
    }
    Show-Args::Invoke-IndentOut() {
        Test-AmShowing 1           \
            && local color="always" \
            || local color="auto"
        "$@"\
            | "$ZLASH_TOOL_BAT"                            \
                    --language       bash                  \
                    --italic-text    always                 \
                    --paging         never                   \
                    --style          plain                    \
                    --color          "$color"                  \
                    --theme          "$ZLASH_TOOL_BAT_THEME"         \
                    --wrap           character                   \
                    --terminal-width "$((COLUMNS - ZLASH_INDENT))"\
            | Write-IndentOut "$((ZLASH_INDENT))"
    }
    Show-Args::Invoke-IndentSrcOut() {
        Test-AmShowing 1           \
            && local color="always" \
            || local color="auto"
        "$@"\
            | "$ZLASH_TOOL_BAT"                            \
                    --language       bash                  \
                    --italic-text    always                 \
                    --paging         never                   \
                    --style          numbers                  \
                    --color          "$color"                  \
                    --theme          "$ZLASH_TOOL_BAT_THEME"         \
                    --wrap           character                   \
                    --terminal-width "$((COLUMNS - ZLASH_INDENT))"\
            | Write-IndentOut "$((ZLASH_INDENT))"
    }
}

#------------------------------------------------------------------------------
### 6.    FUNDAMENTAL OBJECTS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#


Ref::Get() {
    :
}

: ${_ZLASH_IGEN[Ref]:=0}

Ref::New() {
    local -n bind="$1"
    local val="$2" cls self
    cls="${funcstack[0]%::*}"
    self="${cls}#$((++_ZLASH_IGEN["$cls"]))"
    _ZLASH_CELL["$self"]="$val"
    bind="$self"
}

#------------------------------------------------------------------------------
### 6.    ADVANCED FUNCTION RESULT HANDLING
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#

# TODO: Revisit and reevaluate.
#       Currently, only:
#         - linearity of 1 is supported for mutable results;
#         - dereferencing levels of 0 and 1 are supported.
#
#   - REPLY_TYPE :: either a naked type (bash:${var@a}, zsh:${(t)var}),
#                   or any Proto.* object.
#   - REPLY_DREF :: integer level of dereferencing needed from the cell.
#   - REPLY_LINR :: linearity of cell (number of allowed consumptions).
#                   negative integers for immutable results.
: ${REPLY:=}
: ${REPLY_TYPE:=}
: ${REPLY_DREF:=0}
: ${REPLY_LINR:=0}

# TODO: Define how file and socket should behave here, if differently.
# TODO: Introspect/interrogate objects how they want to be streamed.
# NOTE: This does not consume REPLY.  If REPLY value is of a linear type,
#       and consumption needs to be tracked in a subshell, additional
#       safety precautions are needed.
Test-AmBash && \
    Write-ReplyReprOut() {
        local reply="$REPLY"
        local -i dref
        for (( dref=REPLY_DREF ; dref>0 ; dref-- )); do
            local -n reply="$reply"; done
        if Test-IsObject "$reply"; then
            : # TODO
        elif Test-IsAssocOrIxArrName reply; then
            Write-Out "${reply[@]@Q}"
        else
            Write-Out "${reply@Q}"
        fi
    }
Test-AmZsh && \
    Write-ReplyReprOut() {
        local reply="$REPLY"
        local -i dref
        for ((dref=REPLY_DREF; dref>0; dref--)); do
            # shellcheck disable=SC2296
            reply="${(P)reply}"; done
        # shellcheck disable=SC2296
        Write-Out "${(Pqq)reply}"  # nocomment (syntax highlighter bug)
    }

# TODO: Introspect/interrogate if object can show itself.
Show-Reply() {
    Write-ReplyReprOut
}

Test-AmBash && Set-Reply() {
        __RESULT=("$1" "${1@a}" 0 -1)
        Test-AmShowing && Show-Result
        Test-AmPiping  && Write-ResultRepr
    }
Test-AmZsh && Set-Reply() {
        # shellcheck disable=SC2296
        __RESULT=("$1" "${(t)1}" 1 -1)
        Test-AmShowing && Show-Result
        Test-AmPiping  && Write-ResultRepr
    }

Test-AmBash && Set-ReplyRef() {
        __RESULT=("$1" "${1@a}" 1 1)
        Test-AmShowing && Show-Result
        Test-AmPiping  && Write-ResultRepr
    }
Test-AmZsh && Set-ReplyRef() {
        # shellcheck disable=SC2296
        __RESULT=("$1" "${(t)1}" 1 1)
        Test-AmShowing && Show-Result
        Test-AmPiping  && Write-ResultRepr
    }

Test-AmBash && \
    Get-Result() {
        if [[ $((REPLY_LINR)) -eq 0 ]]; then
            Write-Err "ERROR: Result is stale in:" "${FUNCNAME[@]}"
            return 1
        else
            local -n name="${1:-REPLY}"
            name="$RESULT_CELL" && : $((RESULT_LINR--))
        fi
    }

#------------------------------------------------------------------------------
### 5.    E r r o r s   a n d   A s s e r t i o n s
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
#

declare -gi _ZLASH_ERR_STACK_SKIP=0

Error__SkipScope__scriptblock() {
    local -I _ZLASH_ERR_STACK_SKIP
}
New-AliasScriptBlock Error__SkipScope

# Error() {
#     local -i status="$1"
#     Write-Err "${funcstack[0]}" "${@:2}" "in" \
#               "(" "${funcstack[@]:_ZLASH_ERR_STACK_SKIP+1}" ")";
#     exit $status
# }

Copy-Function Error Assertion__Error

Assert-Eval() {
    local -i status
    eval "$@"
    status=$?
    [[ status -eq 0 ]] || Assertion::Error $status "$@"
}

Test-AmBash && Assert-StrEq() {
        Error::SkipScope
        [[ "$1" == "$2" ]] \
            || Assertion::Error 1 "Expected" "${1@Q}" "==" "${2@Q}" "${@:3}"
    }

Test-AmBash && New-DeclDef() {
        local name="$1" begin="$2" end="$4"
        Assert-StrEq "$3" "..." "Syntax Error:" "${funcstack[0]}" "${@@Q}"
    }

#------------------------------------------------------------------------------
### 6.    B u i l t i n   P r o t o t y p e s
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
#

# Current namespace.
declare -g __NS=""

Test-AmBash && Confirm-AmInClassDef() {
    amSubshell                                \
        && [[ -v 'IN_CLASS_DEF' ]]             \
        && [[  "${IN_CLASS_DEF@a}" == 'r'    ]] \
        && [[  "${IN_CLASS_DEF}"   == 'true' ]]
}

class::start__scriptblock() {
    # Confirm we are in a class definition subshell before proceeding.
    if ! Confirm-AmInClassDef; then
        Write-Err "ERROR: Illegal internal call in:" "${funcstack[@]}"
        exit 1
    fi

    # class name [: base1 base2 ...]
    declare -g   name="$1"
    declare -ga bases=("${$@:3}")
    if [[ "$#" -gt 1 ]] && ! [[ "$2" == ':' ]]; then
        Write-Err "Error: Illegal class syntax: class" "$@"
        exit 1
    fi

    # Remove all functions (ignore readonly errors)
    # except namespaces of bases.
    Get-FunctionNames "" ""
    for func in "${REPLY[@]}"; do
        builtin unset -f "$func" &>/dev/null; done

    __NS="${__NS}${name}::"
}
New-AliasScriptBlock class::start

class::end__scriptblock() {
    declare -p name bases
    declare -f
}
New-AliasScriptBlock class::end

alias class='
class::_() {
    . <( (
        declare -gr IN_CLASS_REF="true"
        class::start '
Test-AmBash && alias ssalc='
        class::end
    ) )
}; class::_; unset -f class::_; '

_ZLASH_IGEN[Scalar]=0
Test-AmBash -ge 5.0 && \
    Scalar::New() {
        :
    }

# Object Creation Counters (for unique object ids per `proto`)
declare -giA __OBJC=()

# Object Registry
declare -gA __OBJV=()

__OBJC["Proto.Scalar"]=0
Proto.Scalar() {
    local scalar="$1:-"
    local proto="${funcname[0]}"
    let __OBJC[proto]++
    local obj="${proto}#${__OBJC[$proto]}"
    __OBJV[$proto]="$obj"
    REPLY="$obj"
}

__OBJC[customobj]=0
proto.customobj() {
    Set-Reply "${__OBJV[$self]}"
}

New-CustomObj() {
    local -n var="$1" val="${2:-}"
    let __OBJC++
    var="customobj#${__OBJC}"
    __OBJV[$var]="$val"
}

#------------------------------------------------------------------------------
#     .
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
#

Test-AmBash && Initialize-InteractiveShellOptions() {
        builtin local opt
        builtin shopt -s \
                no_empty_cmd_completion cdspell cmdhist dotglob extglob
        for opt in \
            show-all-if-ambiguous completion-ignore-case colored-stats \
            completion-map-case blink-matching-paren visible-stats      \
            mark-symlinked-directories colored-completion-prefix
        do
            builtin bind "set $opt on"
        done
        builtin bind "set completion-prefix-display-length 3"
        # for opt in page-completions; do
        #     builtin bind "set $opt off"
        # done
    }

[[ -v SHELL_current ]] || builtin declare -g SHELL_current="$0"

# $PROFILE object with members defining initialization files.
# TODO: add conditions if $SHELL_current is /bin/sh
: ${PROFILE:=PROFILE}

Test-AmBash && PROFILE.AllUsersCurrentHost   () { Set-Reply "/etc/profile"; }
Test-AmZsh  && PROFILE.AllUsersCurrentHost   () { Set-Reply "/etc/zprofile"; }
Test-AmBash && PROFILE.CurrentUserCurrentHost() {
        local -a profile=(
            "${HOME}/.bash_profile" "${HOME}/.bash_login" "${HOME}/.profile")
        local file; for file in "${profile[@]}"; do
            [[ -r "$file" ]] && Set-Reply "$file" && return 0
        done
        Set-Reply "${profile[0]}"
    }
Test-AmZsh  && PROFILE.CurrentUserCurrentHost() { __RESULT="${HOME}/.zprofile"   ; }
Test-AmBash && PROFILE.AllUsersCurrentHostInteractive() { __RESULT="/etc/bashrc" ; }
Test-AmZsh  && PROFILE.AllUsersCurrentHostInteractive() { __RESULT="/etc/zshrc"  ; }
Test-AmBash && PROFILE.CurrentUserCurrentHostInteractive() {
        __RESULT="${HOME}/.bashrc"; }
Test-AmZsh  && PROFILE.CurrentUserCurrentHostInteractive() {
        __RESULT="${HOME}/.zshrc"; }

# Ensure PROFILE.AllUsersCurrentHost is sourced.
_() {
    $PROFILE.AllUsersCurrentHost
    local profile
    Get-Result profile
    [[ -r "$profile" ]] && {
        . "$profile"
        # Reinitialize basic shell options
        Initialize-MinimalShellOptions
    }
}; _; unset -f _


Set-SHELL() {
    local shell="${1:-${SHELL_current}}" change_update=""
    case "$ZLASH_SHELL_UPDATE" in
        never)  Write-Err "ERROR: ZLASH_SHELL_UPDATE is set to 'never'."
                return 1 ;;
        once)   change_update="never" ;;
        always) : ;;
        *)      Write-Err "ERROR: ZLASH_SHELL_UPDATE has invalid value!"
                return 1 ;;
    esac

    if ! Confirm-CommandsExist "$shell"; then
        Test-ExesExist "ps"
        shell="$(builtin command ps -p $$ -o comm=)"  # Get the current process name
        Test-ExesExist "$shell"
    fi

    [[ -n "$change_update" ]] && ZLASH_SHELL_UPDATE="$change_update"
    export SHELL="$shell"
}

# case "$ZLASH_SHELL_UPDATE" in
#     always|once) Set-SHELL ;;
# esac


###############################################################################
#
#   Naming Convention
#

# module.function
# module.class.staticmethod
# $object.method
declare -g FUNC_NS_DELIMITER='.'

# module.class^method
declare -g OBJECT_DELIMITER='^'

# module:globalvar
# module.class:classvar
# module.class:^objfield
# module.class^method:param
# $obj:field
declare -g FIELD_DELIMITER=':'

# module.class@objid
declare -gr INSTANCE_ID_DELIMITER='@'

declare -gi      OBJECT_COUNTER=0
declare -ga             OBJECTS=()           # (        [id]=objname              )
declare -gA         INHERITANCE=()       # (   [objname]="objname objname ...")
declare -gA             MEMBERS=()           # (   [objname]="membername ..."     )
declare -gA        MEMBER_TYPS=()      # ([membername]="type"               )

# TODO
Class.New() {
    local -n name=$1
}

Test-AmBash && New-List() {
    local name="$1"
    local -n ref="$name"
    ref=("${@:2}")
}

Remove-EnvVarItem() {
    local ITEM="${1}" VARNAME="${2:-PATH}" DELIMITER="${3:-:}"
    typeset -n VARNAME
    Set-LocalNoGlob
    VARNAME="$(
        IFS=$DELIMITER
        [ -v VARNAME ] && ITEMS=("$VARNAME") || ITEMS=()
        for i in ${!ITEMS[@]}; do
            [ "${ITEMS[i]}" = "$ITEM" ] && unset ITEMS[i]; done
        echo "${ITEMS[*]}"
    )"
}

Add-EnvVarItem() {
    local ITEM="${1}" VARNAME="${2:-PATH}" DELIMITER="${3:-:}"
    export "${VARNAME}"="$(
        set -f
        IFS=$DELIMITER
        SEEN=false
        declare -p "$VARNAME" &>/dev/null && ITEMS=(${!VARNAME}) || ITEMS=()
        for i in ${!ITEMS[@]}; do
            [ "${ITEMS[i]}" = "$ITEM" ] && SEEN=true; done
        $SEEN || ITEMS+=("$ITEM")
        echo "${ITEMS[*]}"
    )"
}

Push-EnvVarItem() {
    local ITEM="${1}" VARNAME="${2:-PATH}" DELIMITER="${3:-:}"
    export "${VARNAME}"="$(
        set -f
        IFS=$DELIMITER
        declare -p "$VARNAME" &>/dev/null && ITEMS=(${!VARNAME}) || ITEMS=()
        for i in ${!ITEMS[@]}; do
            [ "${ITEMS[i]}" = "$ITEM" ] && unset ITEMS[i]; done
        ITEMS=("$ITEM" ${ITEMS[@]})
        echo "${ITEMS[*]}"
    )"
}

Repair-EnvVarItems() {
    local VARNAME="${1}" PRIORITY_VARNAME="${2:-}" DELIMITER="${3:-:}"
    export "${VARNAME}"="$(
        set -f
        IFS=$DELIMITER
        declare -p "$VARNAME" &>/dev/null && VAR=(${!VARNAME}) || VAR=()
        declare -p "$PRIORITY_VARNAME" &>/dev/null && \
            PRIORITY_VAR=(${!PRIORITY_VARNAME}) || \
            PRIORITY_VAR=()
        ITEMS=(${PRIORITY_VAR[@]} ${VAR[@]})
        LEN=${#ITEMS[@]}
        for i in ${!ITEMS[@]}; do
            for (( j = 1 + i ; j < LEN ; j++ )); do
                [ "${ITEMS[i]}" = "${ITEMS[j]}" ] && unset ITEMS[j]; done
        done
        echo "${ITEMS[*]}"
    )"
}

Repair-PATH() {
    Repair-EnvVarItems PATH PATH_PRIORITY
}

Register-ImportableEnv() {
    Add-EnvVarItem "${1}" ImportableEnvs
}

Import-ExitCodes() {
    declare -gA EXIT_CODE_MAPPING=(
        [0]="SUCCESS"
        [1]="FAILURE"
        [2]="SHELL_BUILTIN_MISUSE"
        [124]="RETRY_COMPLETION"
        [126]="COMMAND_NOT_EXECUTABLE"
        [127]="COMMAND_NOT_FOUND"
    )
    _() { # Add shell signals
        local -a sig
        sig=("$(kill -l)")
        local -i len=${#sigs[@]} offset=129
        [[ "${sig[0]}" == [0-9]* ]] && for ((i=0; i<len; i++)); do
            unset sig[i*2]; done
        len=${#sig[@]}
        for ((i=0; i<len; i++)); do
            [[ "${sig[i]}" != SIG* ]] && sig[i]="SIG${sig[i]}"
            EXIT_CODE_MAPPING[$offset]="${sig[i]}"
            let offset++
        done
    }; _
    _() { # Add from sysexits.h
        local -a sysexit=(
            USAGE DATAERR NOINPUT NOUSE NOHOST UNAVAILABLE SOFTWARE OSERR
            OSFILE CANTCREAT IOERR TEMPFAIL PROTOCOL NOPERM CONFIG
        )
        local -i len=${#sysexit[@]} offset=64
        for ((i=0; i<len; i++)); do
            EXIT_CODE_MAPPING[$offset]="${sysexit[i]}"
            let offset++
        done
    }; _; unset -f _
}

# export BASH_SILENCE_DEPRECATION_WARNING=1

export DOTNET_CLI_TELEMETRY_OPTOUT=1
export POWERSHELL_TELEMETRY_OPTOUT=1

Register-ImportableEnv Import-NixEnv
Import-NixEnv() {
    [ -v 'NIX_PROFILES' ] && \
        .  /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
}

Register-ImportableEnv Import-GhcUpEnv
Import-GhcUpEnv() {
    [[ "${PATH}:" != *"/.cabal/bin:"* || "${PATH}:" != *"/.ghcup/bin:"* ]] && \
        [ -d "${GHCUP_INSTALL_BASE_PREFIX:=HOME}/.ghcup" ] && \
        .    "${GHCUP_INSTALL_BASE_PREFIX}/.ghcup/env"
}

Register-ImportableEnv Import-JavaHomeEnv
Import-JavaHomeEnv() {
    export JAVA_HOME="${JAVA_HOME:-$(/usr/libexec/java_home)}"
}

Register-ImportableEnv Import-PerlEnv
Import-PerlEnv() {
    { [ -z "${PERL_MB_OPT}" ] || [ -z "${PERL_MM_OPT}" ]; } && \
        . <(/usr/bin/perl -I "${HOME}/perl5/lib/perl5/" -Mlocal::lib)
}


export PSModulePath="${PSModulePath:-${HOME}/pwsh}"

export CONDA_PREFIX="${CONDA_PREFIX:-${HOME}/opt/anaconda3}"

# [[ ":$PATH:" != *":${HOME}/.console-ninja/.bin:"* ]] && \
#     export PATH="${HOME}/.console-ninja/.bin:${PATH}:$PATH"

export PODMAN_MACOS_CFG="${PODMAN_MACOS_CFG:-${HOME}/\
.config/containers/podman/machine/qemu/podman-machine-default.json}"

Register-ImportableEnv Import-HomeBinEnv
Import-HomeBinEnv() {
    export HOMEBREW_NO_ANALYTICS=1
    [ -d "${HOME}/bin" ] && {
        Push-EnvVarItem "${HOME}/bin" PATH_PRIORITY
        Push-EnvVarItem "${HOME}/bin" PATH

        [ -x "${HOME}/bin/te" ] && \
            export EDITOR="${EDITOR:=${HOME}/bin/te}"

        [ -x "${HOME}/bin/ve" ] && \
            export VISUAL="${VISUAL:=${HOME}/bin/ve}"
    } || \
        echo "WARNING: Not found: ${HOME}/bin" >2
}

declare -ga INCLUDE_DIRS_CACHE=()

Test-AmBash && Find-HeaderFile() {
    : # TODO
    local filename="$1"
    Use-BeforeReturnHook
    if [[ "${#INCLUDE_DIRS_CACHE[@]}" -eq 0 ]]; then
        if Confirm-CommandsExist gcc; then
            local line
            while read -r line; do
                :
            done; <(
                IFS=$'\n'
                builtin command gcc -Wp,-v -E - < /dev/null 2>&1
            )
        else
                : # TODO
        fi
    fi
}

Test-AmBash && Import-BashCompletions() {
        [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] \
            && . "/usr/local/etc/profile.d/bash_completion.sh"
    }

alias c=type

cd() {
    pushd "${1:-${HOME}}"
}

alias qp=Convert-PipeToShQuote
Convert-PipeToShQuote() {
    local IFS input
    [ $# -gt 0 ] && IFS="$1"
    builtin read -s -r -d '' -a input
    echo "${input[@]@Q}"
}

alias qa=Convert-ArgsToShQuote
Convert-ArgsToShQuote() {
    echo "${@@Q}"
}

alias mc=Measure-Command
Measure-Command() {
    local cmd=("$@")
    local qcmd=()
    local TIMEFORMAT="%3Rs ""$@"
    time "$@"
}

Import-NerdFontEnv() {
    . "${HOME}/bin/bash/i_all.sh"
}

Test-AmMacOS && Test-AmBash && Import-BrewEnv() {
    export HOMEBREW_NO_ANALYTICS=1
    . <(brew shellenv bash)
    Test-AmUserControlled && {
        if type brew &>/dev/null
        then
            local brew
            brew="$(brew --prefix)"
            if [[ -r "${brew}/etc/profile.d/bash_completion.sh" ]]; \
            then
                . "${brew}/etc/profile.d/bash_completion.sh"
            else
                for COMPLETION in "${brew}/etc/bash_completion.d/"*; do
                    [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
                done
            fi
        fi
    }
}

Import-JenvEnv() {
    . <(jenv init -)
}

Import-PyenvEnv() {
    export PYENV_ROOT="${PYENV_ROOT:-${HOME}/.pyenv}"
    . <(pyenv init -)
}

Import-VirtualenvEnv() {
    . <(pyenv virtualenv-init -)
}


_posix_test_am_bash && Import-CondaEnv() {
    . <("${CONDA_PREFIX}/bin/conda" shell.bash hook)
}
_posix_test_am_zsh && Import-CondaEnv() {
    . <("${CONDA_PREFIX}/bin/conda" shell.zsh hook)
}

Import-DirenvEnv() {
    . <(direnv hook bash)
}

Import-GCloudEnv() {
    . "${HOME}/google-cloud-sdk/path.bash.inc"
}

Import-ModulesEnv() {
    . /usr/local/opt/modules/init/bash
}

Import-UtilLinuxEnv() {
    # If you need to have util-linux first in your PATH, run:
    # echo 'export PATH="/usr/local/opt/util-linux/bin:$PATH"' >> ~/.zshrc
    # echo 'export PATH="/usr/local/opt/util-linux/sbin:$PATH"' >> ~/.zshrc

    # For compilers to find util-linux you may need to set:
    # export LDFLAGS="-L/usr/local/opt/util-linux/lib"
    # export CPPFLAGS="-I/usr/local/opt/util-linux/include"

    # For pkg-config to find util-linux you may need to set:
    # export PKG_CONFIG_PATH="/usr/local/opt/util-linux/lib/pkgconfig"
    :
}


FzfHistory.Import() {
    if Test-ExesExist fsf
    then
        bind '"\C-r": "\C-x1\e^\er"'
        bind -x '"\C-x1": FzfHistory.completer';
    fi
}
FzfHistory.completer() {
    local history
    history="$(builtin history \
                | fzf --tac --tiebreak=index \
                | perl -ne 'm/^\s*([0-9]+)/ and print "!$1"' \
            )"
    if [[ -n "$history" ]]; then
        bind '"\er": redraw-current-line'
        bind '"\e^": magic-space'
        local -a readline
        readline=(
            "${READLINE_LINE:+${READLINE_LINE:0:READLINE_POINT}}"
            "$1"
            "${READLINE_LINE:+${READLINE_LINE:READLINE_POINT}}"
        )
        Join-Array "" readline
        READLINE_LINE="$__RESULT"
        READLINE_POINT=$(( READLINE_POINT + ${#1} ))
    else
        bind '"\er":'
        bind '"\e^":'
    fi
}

Repair-PATH

# TODO
Find-ExeDirs() {
    find / -maxdepth 3 -type d ! -path "/nix/store/*" -exec sh -c '
        for dir; do
            count=$(find "$dir" -maxdepth 1 -type f -perm -u+x | wc -l)
            [ "$count" -gt 0 ] && echo "$count $dir"
        done' _ {} + 2>/dev/null
}
