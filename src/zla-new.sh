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
#  - ksh93 :: Korn Shell
#          PRO:
#              - more advanced than even Zsh in many scripting aspects (static
#                scope, true refs, multidim arrays, enums as types, type and
#                function static vars, compound vars, binary data, and more)
#              - required on few old enterprize UNIX systems
#              - few die-hard advanced users,
#              - very high POSIX compliance
#              - well suited for high-perf production environments
#              - outperforms dash
#          CON:
#              - very low and decreasing adoption,
#              - default configuration is least user-friendly from major *NIX
#                shells above for interactive use
#              - text pipelines,
#              - arcane invocations (consequence of POSIX compliance)
#              - non-existent development (some bug-fixes in over 20 years)
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
# Functions with `_compat_` prefix in name are designed to be executable
# as is in any Zlash-supported shell.
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

_compat_init() {
    ZLASH_VERSION=0.1

#------------------------------------------------------------------------------
### 2.    CONFIGURATION OPTIONS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#

    # Auto-update `SHELL` environment variable for interactive shells.
    #
    # Some tools use `SHELL` value to determine what completions to install,
    # resulting in what user may or may not be expecting. If you are using both
    # Zsh and Bash, and want your "prefered" shell to be the current one,
    # setting this to "always" maybe helpful.
    #
    # A setting of `once` maybe helpful for situations where you run different
    # `main` sessions of Bash and Zsh, and want `SHELL` to not change for
    # different subshell types.
    #
    # Valid values are:
    #
    #    - `always` :: update every time a shell starts and is interactive.
    #
    #    - `once`   :: interactive subshels will not auto-update it.
    #
    #    - `never`  :: keep the user login shell value.
    #
    # NOTE: POSIX-compliant syntax for default value if variable is unset,
    #       needed in section before shell is discriminated and if this is
    #       sourced more than once by shell with `nounset` set. (which we do
    #       set)
    : ${ZLASH_SHELL_UPDATE:="always"}
    export ZLASH_SHELL_UPDATE

    # Default indent level
    : ${ZLASH_INDENT:=4}

    # Do not clear these environment variables when performing environment
    # scrubbing by default. A string containing variable names separated by
    # colons (`:`).
    : ${ZLASH_PROTECTED__ZLASH_VARS:="HOME"}

    # Optional Tools. A tool executable may have different names. Possibilities
    # are separated by colons (`:`).

    # Bat, if available, is used for syntax highlighting.
    : ${ZLASH_TOOL_BAT:="bat:batcat"}
    : ${ZLASH_TOOL_BAT_THEME:="gruvbox-dark"}

    # Augeas, if available, is used for structured manipulation of configuration
    # files in many arcane *nix formats.
    : ${ZLASH_TOOL_AUGTOOL:="augtool"}
    : ${ZLASH_TOOL_AUGMATCH:="augmatch"}
    : ${ZLASH_TOOL_AUGPRINT:="augprint"}
    : ${ZLASH_TOOL_AUGPARSE:="augparse"}

    : ${ZLASH_TOOL_LSOF:="lsof"}

    : ${ZLASH_TOOL_OSQUERY:="osqueryi"}

    # Tree-sitter, if available, is used for ASTs of various languages it
    # supports, including Bash AST of Zlash-supported shell languages, for deep
    # dynamic introspection, generation, and even interpretation and relational
    # reasoning over dynamic code, or implementation "hole filling".
    : ${ZLASH_TOOL_TREESITTER:="tree-sitter:tree-sitter-cli"}

    # TODO
    #
    # Interactive interpreters/shells, if available, extending current shell
    # with a seamless sub-language with completions to interact with these
    # interpreters natively integrated:
    #   - IPython
    #   - Powershell
    #   ...

    # If set to `ignore`, do not exit when shell capabilities testing has
    # detected a critical security issue, at which point it should become
    # readonly.
    : ${ZLASH_CRITICAL_INSECURITY:="ignore"}

    # TODO
    # These tools, if available, will greatly speed up functionality that
    # uses the (soon) provided pure-shell implementation of miniKanren inference
    # engine:
    #   - SWI-Prolog
    #   - Clojure with core.logic
    #   - Z3 (and many other constraint solvers for cli later)
    #   - Sqlite

    # `true` or not.
    : ${_ZLASH_IGNORE_ASSERTS:="false"}

    # New Identifiers Configuration
    #
    # NOTE: This must be a valid variable identifier prefix uneder all supported
    #       shells. (or modified during shell specialization accordingly)
    : ${_ZLASH_IGEN_PREFIX:="_"}
    # Every managed object will be getting a unique identifier constrained by
    # valid variable name format. Our convention is concetenation of this prefix
    # with a decimal number for logical variables, and hexadecimal number for
    # all the other objects, like so:
    #   - logical variables: _1 _2 _255
    #   - all other objects: _0x1 _0x2 _0xff

    # Initial Identifier Generating Counter
    : ${_ZLASH_IGEN:=0}

    # Initial Logical Identifier Generating Counter
    : ${_ZLASH_LIGEN:=1}

#------------------------------------------------------------------------------
###  3.    SHELL TYPE AND VERSION IDENTIFICATION
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#

    # An internal string representing the
    # Type of the shell sourcing this.
    : ${ZLASH_SHELL_TYP:=unknown}

    # An internal string representing
    # major dot minor decimal numbered version of the current shell,
    # used by shell-agnosting version guarding code.
    : ${ZLASH_SHELL_VER:=0.0}

    # An internal string representing the
    # fullpath of the current shell.
    : ${_ZLASH_SHELL_EXE:="$0"}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#### 3.1.  Shell Capabilities Tests
#
# `zlash_cap_`-prefixed, all POSIX-compliant no-argument silent static
# evalualtion tests as non-exhaustive empirical witnesses of various shell
# capabilities. Style of these is very different form the main definitions,
# since this needs to be very compatible and defensive.
#
# Each tests defines ZLASH_CAPREQS with space-separated required
# capability names, so minimal failing dependent capability can be traced on
# capability test failure.
#
# Each test defines ZLASH_CAPDSC as a short description or example of
# the capability, which can be used when reporting on capability.
#
# Capability names are test function names with `zlash_cap_` prefix
# stripped.
#
# We are excluding "POSIX-compliant" shells that weren't updated since late
# 1980s. If we have function definitions, we also have basic parameter
# expansions, basic string and file testing, POSIX-required builtins (., :,
# break, continue, eval, exec, exit, export, readonly, return, set, shift, trap,
# unset) and utilities (alias, echo, printf, times, type, ulimit, etc...),
# redirections, compound commands like if, case-patterns, for loops, command
# lists, status negation, pipelines, groups, subshells.
#
# NOTE: `_unsafe_`-prefixed functions should be called with controlled or
#       sanitized arguments.
#

##### 3.1.1. Subshell Behavior

    # Reset OUT reporting variables. (also a capabilities testing observability
    # point)
    zlash_captest_fixture() {

        # A short description and/or example snippet of capability.
        ZLASH_CAPDESC=''

        # Capability dependencies (space separated) for finding a more
        # fundamental failing capability on failure.
        ZLASH_CAPREQS=''

        # Capability provisions on success (space separated).
        # TODO: explain format and use.
        ZLASH_CAPFOR=''
    }

    # Subshell execution environment should isolated from enclosing execution
    # environment.
    zlash_cap_sh_subsh_env() {
        zlash_captest_fixture
        ZLASH_CAPDSC='subshell execution environment isolation'

        # Subshell to not pollute execution environment with temporary variables
        # and functions before we know our capabilities.
        if (
            # if _ZLASH_VAR has been set as readonly, our tests are invalid, so
            # report no capability. This early, we don't yet know our
            # capabilities, so we should attempt to create a non-clashing
            # variable name dnamically. Similarly, some shells can set functions
            # readonly, preventing redefinition.
            _ZLASH_VAR=""                               \
                && eval '_zlash_func() { _ZLASH_VAR="OUTER"; }'\
                && [ "${_ZLASH_VAR:-}" = "" ]             \
                && _zlash_func                                   \
                && [ "${_ZLASH_VAR:-}" = "OUTER" ]          \
                && _ZLASH_VAR=""                             \
                && (
                    # Subshell should inherit outer execution environment.
                    [ "${_ZLASH_VAR:-}" = "" ] \
                        && _zlash_func                \
                        || return 1

                    # Redefine function
                    _zlash_func() { _ZLASH_VAR="INNER"; }

                    # Last call should have been of the outer function, then
                    # test the overriden, inner call.
                    [ "${_ZLASH_VAR:-}" = "OUTER" ]    \
                        && _zlash_func                        \
                        && [ "${_ZLASH_VAR:-}" = "INNER" ]
                )\
                && [ "${_ZLASH_VAR:-}" = "" ]  \
                && _zlash_func                        \
                && [ "${_ZLASH_VAR:-}" = "OUTER" ]
        ); then
            ZLASH_CAP_SH_SUBSH_ENV=true
        else
            ZLASH_CAP_SH_SUBSH_ENV=false
            return 1
        fi
    } >/dev/null 2>&1

    # Shells may or may not fork (to rely on OS) to achieve isolated execution
    # environment from the enclosing execution environment. This tests for the
    # correct behavior of the (possibly counter-intuitive) top-level return in a
    # subshell: it should exit subshell setting status of subshell to the passed
    # value, not exit the enclosing function.
    zlash_cap_sh_subsh_ret() {
        zlash_captest_fixture
        ZLASH_CAPDSC='correct subshell return behavior'

        # Status of the last command in subshell is the status of the subshell,
        # same as with functions, which here is the compound logic command.
        if (
            # Top-level return in a subshell should not return from enclosing
            # function. The `||:;` construct ensures a preceeding command, if
            # failed, will not short-circuit the function.
            _false()    { ( return 0; ) ||:; return 1; }
            _true()     { ( return 1; ) ||:; return 0; }

            # Top-level return in a subshell should exit subshell with its
            # value as status.
            _is_false() { ( return 1 ||:; exit 0; ); }
            _is_true()  { ( return 0 ||:; exit 1; ); }

            _true && ! _false && ! _is_false && _is_true
        ); then
            ZLASH_CAP_SH_SUBSH_RET=true
        else
            ZLASH_CAP_SH_SUBSH_RET=false
            return 1
        fi
    } >/dev/null 2>&1

##### 3.1.2. True/False Exit Status Logic
#

    zlash_cap_sh_truefalse() {
        zlash_captest_fixture
        ZLASH_CAPDSC='false || true  # exit status logic'

        if true && ! false; then
            ZLASH_CAP_SH_TRUEFALSE=true
        else
            ZLASH_CAP_SH_TRUEFALSE=false
            return 1
        fi
    } >/dev/null 2>&1

    # Simple enough to directly provide the missing utilities.
    if ! zlash_cap_sh_truefalse; then
        true()  { return 0; }
        false() { return 1; }
    fi

##### 3.1.2. Unset Behavior
#
# see: https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#unset
#
    # Unsafe means arguments must be either controlled or sanitized.
    # Used to test variations of variable removal.
    _unsafe_zlash_cap_sh_rm_var() {
        (
            _ZLASH_VAR='OK'                    \
                && [ "${_ZLASH_VAR:-}" = 'OK' ] \
                && eval "$1 _ZLASH_VAR"          \
                && [ "${_ZLASH_VAR:-}" = '' ]
        )
    }

    # `unset` variable delition capability.
    zlash_cap_sh_unset() {
        zlash_captest_fixture
        ZLASH_CAPDSC='unset VAR  # removes variable `VAR`'
        ZLASH_CAPFOR='rm_var_cmd'

        if _unsafe_zlash_cap_sh_rm_var 'unset'; then
            ZLASH_CAP_SH_UNSET=true
        else
            ZLASH_CAP_SH_UNSET=false
            return 1
        fi
    } >/dev/null 2>&1

    # `unset -v` explicit variable deletion capability.
    zlash_cap_sh_unset_v() {
        zlash_captest_fixture
        ZLASH_CAPDSC='unset -v VAR  # removes variable `VAR`'
        ZLASH_CAPFOR='rm_var_cmd'

        if _unsafe_zlash_cap_sh_rm_var 'unset -v'; then
            ZLASH_CAP_SH_UNSET_V=true
        else
            ZLASH_CAP_SH_UNSET_V=false
            return 1
        fi
    } >/dev/null 2>&1

    # Provides $ZLASH_CMD_RM_VAR on success.
    zlash_cap_cmd_rm_var() {
        zlash_captest_fixture
        ZLASH_CAPDSC='$ZLASH_CMD_RM_VAR VAR  # remove variable VAR'

        # Prefer the explicit variants.
        if ${ZLASH_CAP_SH_UNSET_V:-false} \
        ||   zlash_cap_sh_unset_v
        then
            ZLASH_CMD_RM_VAR='unset -v'
        elif ${ZLASH_CAP_SH_UNSET:-false} \
        ||     zlash_cap_sh_unset
        then
            ZLASH_CMD_RM_VAR='unset'
        else
            # We could do something like:
            #
            #   _unsafe_zlash_rm_var() { eval "\$${1}=''"; }
            #   ZLASH_CMD_RM_VAR='_unsafe_zlash_rm_var'
            #
            # but failure still would need to be reported, and still more cap
            # testing would need to be tested, like scoping corner cases.
            ZLASH_CAP_CMD_RM_VAR=false
            return 1
        fi
        ZLASH_CAP_CMD_RM_VAR=true
    }

    # Function deleting. Succeed only if deleted function call fails AND call
    # did not have deleted function's effect.
    zlash_cap_rm_fun_unset_f() {
        zlash_captest_fixture
        ZLASH_CAPDSC='unset -f fun  # removes function `fun`'

        if (
            _ZLASH_VAR=""                            \
                && eval '_zlash_func() { _ZLASH_VAR="OK"; }'\
                && [ "${_ZLASH_VAR:-}" = "" ]          \
                && _zlash_func                                \
                && [ "${_ZLASH_VAR:-}" = "OK" ]          \
                && _ZLASH_VAR=""                          \
                && [ "${_ZLASH_VAR:-}" = "" ]              \
                && eval 'unset -f _zlash_func'                    \
                && ! eval '_zlash_func'                            \
                && [ "${_ZLASH_VAR:-}" = "" ]
        ); then
            ZLASH_CAP_RM_FUN_UNSET_F=true
        else
            ZLASH_CAP_RM_FUN_UNSET_F=false
            return 1
        fi
    } >/dev/null 2>&1

    # Unset NAME removes function NAME if variable NAME is unset.
    # POSIX specifies this behavior as undefined.
    zlash_cap_rm_fun_unset() {
        zlash_captest_fixture
        ZLASH_CAPDSC='unset name  # removes variable or function `name`'

        if (
            # Variable and function with same name
            _zlash_name=""                                 \
                && eval '_zlah_name() { _zlash_name="OK"; }'\
                && [ "${_zlash_name:-}" = "" ]               \
                && _zlash_name                                \
                && [ "${_zlash_name:-}" = "OK" ]               \
                && eval 'unset _zlash_name'                     \
                && [ "${_zlash_name:-}" = "" ]                   \
                && eval '_zlash_name'                             \
                && [ "${_zlash_name:-}" = "OK" ]                   \
                && unset _zlash_name                                \
                && eval 'unset _zlash_name'                          \
                && [ "${_zlash_name:-}" = "" ]                        \
                && eval '_zlash_name'                                  \
                && [ "${_zlash_name:-}" = "" ]
        ); then
            ZLASH_CAP_RM_FUN_UNSET=true
        else
            ZLASH_CAP_RM_FUN_UNSET=false
            return 1
        fi
    } >/dev/null 2>&1

    # Provides $ZLASH_CMD_RM_FUN
    zlash_cap_cmd_rm_fun() {
        zlash_captest_fixture
        ZLASH_CAPDSC='$ZLASH_CMD_RM_FUN fun  # removes function `fun`'

        # Prefer explicit.
        if [ "${ZLASH_CAP_RM_FUN_UNSET_F:-}" = 'true' ] \
        || zlash_cap_rm_fun_unset_f
        then
            ZLASH_CMD_RM_FUN='unset -f'
        elif [ "${ZLASH_CAP_RM_FUN_UNSET:-}" = 'true' ] \
        || zlash_cap_rm_fun_unset
        then
            ZLASH_CMD_RM_FUN='unset'
        else
            ZLASH_CAP_CMD_RM_FUN=false
            return 1
        fi
        ZLASH_CAP_CMD_RM_FUN=true
    } >/dev/null 2>&1

##### 3.1.3. Local Variables?

    _unsafe_zlash_cap_sh_local_var() {
        ZLASH_CAPDSC="$1 VAR  # set VAR as function-local variable"
        (
            _ZLASH_VAR='OUTER' || return 1
            _zlash_func() {
                [ "$_ZLASH_VAR" = 'OUTER' ]   \
                    && eval "$1 _ZLASH_VAR"    \
                    && _ZLASH_VAR='INNER'       \
                    && [ "$_ZLASH_VAR" = 'INNER' ]
            }
            _zlash_func \
                && [ "$_ZLASH_VAR" = 'OUTER' ]
        )
    }

    zlash_cap_sh_local() {
        zlash_captest_fixture
        if _unsafe_zlash_cap_local 'local'; then
            ZLASH_CAP_SH_LOCAL=true
        else
            ZLASH_CAP_SH_LOCAL=false
            return 1
        fi
    } >/dev/null 2>&1

    zlash_cap_sh_local_declare() {
        zlash_captest_fixture
        if _unsafe_zlash_cap_local 'declare'; then
            ZLASH_CAP_SH_LOCAL_DECLARE=true
        else
            ZLASH_CAP_SH_LOCAL_DECLARE=false
            return 1
        fi
    } >/dev/null 2>&1

    zlash_cap_sh_local_typeset() {
        zlash_captest_fixture
        if _unsafe_zlash_cap_local 'typeset'; then
            ZLASH_CAP_SH_LOCAL_TYPESET=true
        else
            ZLASH_CAP_SH_LOCAL_TYPESET=false
            return 1
        fi
    } >/dev/null 2>&1

    # Provides $ZLASH_CMD_LOCAL_VAR on success.
    zlash_cap_cmd_local_var() {
        zlash_captest_fixture
        ZLASH_CAPDSC='$ZLASH_CMD_LOCAL_VAR var  # declare function-local `var`'

        # `local` is most specific. `typeset` is most portable.
        if ${ZLASH_CAP_SH_LOCAL:-false} \
        ||   zlash_cap_sh_local
        then
            ZLASH_CMD_LOCAL_VAR='local'
        elif ${ZLASH_CAP_SH_LOCAL_DECLARE:-false} \
        ||     zlash_cap_sh_local_declare
        then
            ZLASH_CMD_LOCAL_VAR='declare'
        elif ${ZLASH_CAP_SH_LOCAL_TYPESET:-false} \
        ||     zlash_cap_sh_local_typeset
        then
            ZLASH_CMD_LOCAL_VAR='typeset'
        else
            ZLASH_CAP_CMD_LOCAL_VAR=false
            return 1
        fi
        ZLASH_CAP_CMD_LOCAL_VAR=true
    } >/dev/null 2>&1

##### 3.1.4. Alternative Function Definition Synatx?
#

    zlash_cap_sh_altfundef() {
        zlash_captest_fixture
        ZLASH_CAPDSC='function name {...}'

        if (
            _ZLASH_VAR='ONE'                                        \
                && eval 'function _zlash_func { _ZLASH_VAR="TWO"; }' \
                && [ "${_ZLASH_VAR:-}" = 'ONE' ]                      \
                && _zlash_func                                         \
                && [ "${_ZLASH_VAR:-}" = 'TWO' ]
        ); then
            ZLASH_CAP_SH_ALTFUNDEF=true
        else
            ZLASH_CAP_SH_ALTFUNDEF=false
            return 1
        fi
    }

    zlash_cap_sh_mixfundef() {
        zlash_captest_fixture
        ZLASH_CAPDSC='function name () {...}'

        if (
            _ZLASH_VAR='ONE'                                           \
                && eval 'function _zlash_func () { _ZLASH_VAR="TWO"; }' \
                && [ "${_ZLASH_VAR:-}" = 'ONE' ]                         \
                && _zlash_func                                            \
                && [ "${_ZLASH_VAR:-}" = 'TWO' ]
        ); then
            ZLASH_CAP_SH_MIXFUNDEF=true
        else
            ZLASH_CAP_SH_MIXFUNDEF=false
            return 1
        fi
    }

##### 3.1.5. Global or Non-local Variables?
#

    _unsafe_zlash_cap_global_var() {
        ZLASH_CAPREQS='cmd_local_var'

        ${ZLASH_CAP_CMD_LOCAL_VAR:-false} \
            || zlash_cap_cmd_local_var     \
            && (
                _ZLASH_VAR='OUTER' || return 1
                _zlash_func() {
                    [ "$_ZLASH_VAR" = 'OUTER' ]         || return 1
                    eval "$_ZLASH_LOCAL_CMD _ZLASH_VAR" || return 1
                    _ZLASH_VAR='INNER'                  || return 1
                    [ "$_ZLASH_VAR" = 'INNER' ]         || return 1

                    # Set the outer value
                    eval 'typeset -g _ZLASH_VAR="NEW"' || return 1

                    # Inner value was not affected
                    [ "$_ZLASH_VAR" = 'INNER' ]  || return 1
                }

                [ "$_ZLASH_VAR" = 'OUTER' ]  || return 1
                _zlash_func || return 1

                # Outer value was changed
                [ "$_ZLASH_VAR" = 'NEW' ]
            )
    }


##### 3.1.4 Indexed Arrays?

    _unsafe_test_cap_ixarr() {
        ZLASH_CAPDSC="$1 VAR  # set VAR as indexed array"
        ZLASH_CAPREQS=""
        (
            eval "$1 _ZLASH_VAR"              || return 1
            eval '_ZLASH_VAR=(one two three)' || return 1

            # ${_ZLASH_VAR[*]} and (in scalar context) ${_ZLASH_VAR[@]}
            # concatenate array with the first character of IFS as the
            # separator.
            IFS=' ' || return 1
            eval '[ "${_ZLASH_VAR[*]}" = "one two three" ]' || return 1
            eval '[ "${_ZLASH_VAR[@]}" = "one two three" ]' || return 1

            # Number of elements.
            eval '[ "${#_ZLASH_VAR[@]}" -eq 3 ]' || return 1

            # Subscript `1` is ether first or second element.
            eval  '
                [ "${_ZLASH_VAR[1]}" = "one" ] || \
                [ "${_ZLASH_VAR[1]}" = "two" ]
            ' || return 1

            # Appending elements
            eval '_ZLASH_VAR+=(four five)' || return 1
            [ "${#_ZLASH_VAR[@]}" -eq 5 ]  || return 1
            [ "${_ZLASH_VAR[*]}" = 'one two three four five' ]

            # Removing elements
            _unsafe_unset_v '_ZLASH_VAR[1]' || return 1
            [ "${#_ZLASH_VAR[@]}" -eq 4 ]   || return 1
            [ "${_ZLASH_VAR[*]}" = 'one three four five' ]     \
                || [ "${_ZLASH_VAR[*]}" = 'two three four five' ]
        )
    }

    # `delcare -a ARR` sets zero-based indexed array attribute on variable ARR.
    zlash_cap_ixarr_declare_a() {
        _unsafe_test_cap_ixarr 'declare -a'
    } >/dev/null 2>&1

    # `delcare -a ARR` sets zero-based indexed array attribute on variable ARR.
    zlash_cap_ixarr_typeset_a() {
        _unsafe_test_cap_ixarr 'typeset -a'
    } >/dev/null 2>&1

    zlash_cap_ixarr() {
        zlash_cap_ixarr_declare_a \
            || zlash_cap_ixarr_typeset_a
    } >/dev/null 2>&1

    if zlash_cap_ixarr_declare_a; then
        :
    fi

##### 3.1.1 How does shell report type of a command?

    # Bash and Ksh variants
    zlash_cap_builtin_type_ta() {
        ZLASH_CAPDSC='type -ta return # *builtin*'
        ZLASH_CAPREQS=""
        if eval 'case "$(type -ta return)" in
                    *builtin*) return 0;;
                    *) return 1;;
                esac'
        then
            case "$(type -ta type)" in
                *builtin*) return 0;;
            esac
        fi
        return 1
    } >/dev/null 2>&1

    # Zsh
    zlash_cap_builtin_whence_wa() {
        ZLASH_CAPDSC='whence -wa return # *builtin*'
        ZLASH_CAPREQS=""
        if eval 'case "$(whence -wa return)" in
                    *builtin*) return 0;;
                    *) return 1;;
                esac'
        then
            case "$(whence -wa whence)" in
                *builtin*) return 0;;
            esac
        fi
        return 1
    } >/dev/null 2>&1

    zlash_cap_builtin_lists_builtins() {
        ZLASH_CAPDSC='builtin lists builtins'
        ZLASH_CAPREQS=""
        (
            eval 'OUT=$(builtin)' || return 1
            case "$OUT" in
                *return*) return 0;;
            esac
            return 1
        )
    } >/dev/null 2>&1

    # NOTE: Not a general version. Just an initialization helper, as argument is
    #       not sanitized, so must be controlled.
    _unsefe_test_word_isa() {
        if zlash_cap_builtin_type_ta; then
            _unsefe_test_word_isa() {
                case "$(type -ta "$1")" in
                    *"$2"*) return 0;;
                    *) return 1;;
                esac
            }
        elif zlash_cap_builtin_whence_wa; then
            _unsefe_test_word_isa() {
                case "$(whence -wa "$1")" in
                    *"$2"*) return 0;;
                    *) return 1;;
                esac
            }
        else
            # NOTE: Other variants don't have a reliable way to query type of a
            #       command. Not including all types means shadowing is too
            #       effective, while allowing path of executables in output
            #       enables pattern injection, (like containing `builtin` as a
            #       path substring) making test unreliable.
            _unsefe_test_word_isa() {
                echo 'ERROR: No "builtin_type_ta" or "builtin_whence_wa"' \
                     'capabilities!' >/dev/stderr
                return 1
            }
        fi
        _unsefe_test_word_isa "$1" "$2"
    }

    zlash_cap_keyword_is_keyword() {
        ZLASH_CAPDSC='keywords like "if" are "keyword"'
        ZLASH_CAPREQS=""
        _unsefe_test_word_isa if keyword
    } >/dev/null 2>&1

    zlash_cap_keyword_is_reserved() {
        ZLASH_CAPDSC='keywords like "if" are "reserved"'
        ZLASH_CAPREQS=""
        _unsefe_test_word_isa if reserved
    } >/dev/null 2>&1

    # Capability testing helper functions:
    #
    #   - _unsefe_test_word_isa_builtin
    #
    #   - _unsefe_test_word_isa_keyword
    #
    # NOTE: Still not a general version. (see NOTE of `_unsefe_test_word_isa`)
    if zlash_cap_builtin_lists_builtins; then
        _unsefe_test_word_isa_builtin() {
            case "$(builtin)" in
                *"$1"*) return 0;
            esac
            return 1;
        }
    else
        _unsefe_test_word_isa_builtin() {
            _unsefe_test_word_isa "$1" builtin
        }
    fi
    if zlash_cap_keyword_is_keyword; then
        _unsefe_test_word_isa_keyword() {
            _unsefe_test_word_isa "$1" keyword
        }
    elif zlash_cap_keyword_is_reserved; then
        _unsefe_test_word_isa_keyword() {
            _unsefe_test_word_isa "$1" reserved
        }
    else
        _unsefe_test_word_isa_keyword() {
            _unsefe_test_word_isa "$1" reserved
        }
    fi

    zlash_cap_echo_builtin() {
        ZLASH_CAPDSC='"echo" is a builtin'
        ZLASH_CAPREQS=""
        _unsefe_test_word_isa_builtin echo
    } >/dev/null 2>&1

    zlash_cap_printf_builtin() {
        ZLASH_CAPDSC='"printf" is a builtin'
        ZLASH_CAPREQS=""
        _unsefe_test_word_isa_builtin printf
    } >/dev/null 2>&1

    zlash_cap_enable_builtin() {
        ZLASH_CAPDSC='"enable" is a builtin'
        ZLASH_CAPREQS=""
        _unsefe_test_word_isa_builtin enable
    } >/dev/null 2>&1

    zlash_cap_builtin_builtin() {
        ZLASH_CAPDSC='"builtin" is a builtin'
        ZLASH_CAPREQS=""
        _unsefe_test_word_isa_builtin builtin
    } >/dev/null 2>&1

    # Ksh-like way of builtin disabling
    zlash_cap_rm_builtin_d() {
        ZLASH_CAPDSC='"builtin -d echo" removes a builtin "echo"'
        ZLASH_CAPREQS="echo_builtin"
        (
            PATH="" || return 1
            eval 'OUT=$(echo OK)' || return 1
            case "$OUT" in
                OK) :;;
                *) return 1;;
            esac
            eval 'builtin -d echo' || return 1
            eval 'OUT="$(echo OK)" || OUT="FAILED"' || return 1
            case "$OUT" in
                FAILED) ! zlash_cap_echo_builtin && return 0;;
            esac
            return 1
        )
    } >/dev/null 2>&1

    # Bash-like way of builtin disabling
    zlash_cap_rm_builtin_enable_n() {
        ZLASH_CAPDSC='"enable -n echo" removes a builtin "echo"'
        ZLASH_CAPREQS="echo_builtin"
        (
            PATH="" || return 1
            eval 'OUT=$(echo OK)' || return 1
            case "$OUT" in
                OK) :;;
                *) return 1;;
            esac
            eval 'enable -n echo' || return 1
            eval 'OUT="$(echo OK)" || OUT="FAILED"' || return 1
            case "$OUT" in
                FAILED) ! zlash_cap_echo_builtin && return 0;;
            esac
            return 1
        )
    } >/dev/null 2>&1

    # Bash and Zsh do this, but not Ksh variants.
    zlash_cap_builtin_calls_builtins() {
        ZLASH_CAPDSC='"builtin echo" calls a builtin echo'
        ZLASH_CAPREQS="echo_builtin printf_builtin builtin_builtin"
        (
            PATH="" || return 1
            echo() { printf '%s\n' 'overriden'; }
            eval 'OUT=$(builtin echo "notfunc")' || return 1
            case "$OUT" in
                'notfunc') return 0;;
            esac
            return 1
        )
    }

    # Ksh variants do this, but not Bash nor Zsh.
    zlash_cap_command_calls_builtins() {
        ZLASH_CAPDSC='"command echo" calls a builtin echo'
        ZLASH_CAPREQS="echo_builtin printf_builtin builtin_builtin"
        (
            PATH="" || return 1
            echo() { printf '%s\n' "func"; }
            eval 'OUT=$(command echo "notfunc")' || return 1
            case "$OUT" in
                'notfunc') return 0;;
            esac
            return 1
        )
    }

    # `[` is an archaic command. `[[` has been "new" prectically forever, and
    # recommended. Doesn't word-split unquoted left, and (without pattern
    # characters) unquoted right.
    zlash_cap_double_braket_str_eq() {
        ZLASH_CAPDSC='[[ $VAL == "$STR" ]]'
        ZLASH_CAPREQS=''
        ( eval '_ZLASH_VAR="~/a b" || return 1
                [ "$_ZLASH_VAR" = "~/a b"   ] && \
                [[ $_ZLASH_VAR == "~/a b"  ]] &&  \
                [[ $_ZLASH_VAR == $_ZLASH_VAR     ]] &&   \
                [[ $_ZLASH_VAR != "~/a bc" ]]'
        )
    } >/dev/null 2>&1

    # Pattern-matching double-brackets.
    zlash_cap_double_braket_str_pat() {
        ZLASH_CAPDSC='[[ $VAL == $PAT ]]'
        ZLASH_CAPREQS=""
        ( eval '
            _ZLASH_VAR="~/a bbcdd e" || return 1
            [    "$_ZLASH_VAR"   = "~/a bbcdd e"  ] &&\
            [[    $_ZLASH_VAR    ==     *"c"*    ]] && \
            [[    $_ZLASH_VAR    !=     *"f"*    ]] &&  \
            [[  ":$_ZLASH_VAR"   ==  ":~"*c*     ]] &&   \
            [[  ":$_ZLASH_VAR"   !=  ":f"*c*     ]] &&    \
            [[  "${_ZLASH_VAR}:" ==      *c*"e:" ]] &&     \
            [[  "${_ZLASH_VAR}:" !=      *c*"f:" ]] &&      \
            [[ ":${_ZLASH_VAR}:" ==  ":~"*c*"e:" ]] &&       \
            [[ ":${_ZLASH_VAR}:" !=  ":~"*f*"e:" ]]
        ')
    } >/dev/null 2>&1

    zlash_cap_builtin_calls_builtin() {
        ZLASH_CAPDSC='builtin calls a builtin'
        ZLASH_CAPREQS=""
        (
            echo() { return 1; }
            PASS='FAILED'
            eval 'PASS="$(builtin echo OK)"' || return 1
            case "$PASS" in
                'OK') return 0;;
            esac
            return 1
        )
    } >/dev/null 2>&1

    # `printf %q` shell-special character escaping, like `$` and space.
    zlash_cap_printf_q() {
        ZLASH_CAPDSC='printf %q\\n "$val"'
        ZLASH_CAPREQS=''
        # TODO: try to secure randomize, or at least just randomize the words!
        (
            IFS=' ' || return 1
            _unsefe_test_word_isa_builtin printf && \
                case "$(printf %q\\n '$one two')" in
                    '\$one\ two') return 0;;
                    *) return 1;;
                esac
        )
    } >/dev/null 2>&1

    if ! zlash_cap_printf_q; then
        echo 'WARNING: CRITICAL INSECURITY: Shell does not provide the' \
             'most portable sanitation mechanism' >/dev/stderr
        case "${ZLASH_CRITICAL_INSECURITY:-exit}" in
            'ignore')
                readonly ZLASH_CRITICAL_INSECURITY  ||  \
                    echo 'WARNING: CLIRICAL INSECURITY:' \
                         'Failed to set readonly flag on' \
                         'ZLASH_CRITICAL_INSECURITY' >/dev/stderr
                ;;
            *) exit 1;;
        esac
    fi

    # `printf` to a variable.
    zlash_cap_printf_to_var() {
        ZLASH_CAPDSC='printf -v var %s "$val"'
        ZLASH_CAPREQS=''
        _unsefe_test_word_isa_builtin printf && \
        (
            _ZLASH_VAR="one" || return 1
            eval 'printf -v _ZLASH_VAR %s "two"' || return 1
            case "$_ZLASH_VAR" in
                'two') return 0;;
                *) return 1;;
            esac
        )
    } >/dev/null 2>&1

    # Plain nested expansion indirection.
    zlash_cap_exp_indirect_naked() {
        ZLASH_CAPDSC='"${$var}"'
        ZLASH_CAPREQS=''
        (
            SECRET='password'
            INDIRECTION='SECRET'
            eval 'VAL="${$INDIRECTION}"' || return 1
            case "$VAL" in
                'password') return 0;;
                *) return 1;;
            esac
        )
    } >/dev/null 2>&1

    # Explicit expansion indirection with bang (`!`)
    zlash_cap_exp_indirect_bang() {
        ZLASH_CAPDSC='"${!var}"'
        ZLASH_CAPREQS=''
        (
            SECRET='password'
            INDIRECTION='SECRET'
            eval 'VAL="${!INDIRECTION}"' || return 1
            case "$VAL" in
                'password') return 0;;
                *) return 1;;
            esac
        )
    } >/dev/null 2>&1

    # Explicit expansion indirection with `(P)`
    zlash_cap_exp_indirect_P() {
        ZLASH_CAPDSC='"${(P)var}"'
        ZLASH_CAPREQS=''
        (
            SECRET='password'
            INDIRECTION='SECRET'
            eval 'VAL="${(P)INDIRECTION}"' || return 1
            case "$VAL" in
                'password') return 0;;
                *) return 1;;
            esac
        )
    } >/dev/null 2>&1

    # Some shells distinguish between POSIX-defined builtins and other builtins
    # and some shells do not allow function definitions with names of shadowing
    # special builtins.
    zlash_cap_return_override() {
        _unsefe_test_word_isa_builtin return && \
        ( eval 'return() { :; }' ) >/dev/null 2>&1
    }

    zlash_cap_alt_zlash_func_decl() {
        ( eval 'function name { :; }' ) >/dev/null 2>&1
    }

    # Some shells will tolerate this type of declaration.
    zlash_cap_mix_zlash_func_decl() {
        ( eval 'function name() { :; }' ) >/dev/null 2>&1
    }

    # Invalid in strict POSIX compliance.
    zlash_cap_zlash_func_name_with_dot() {
        ( eval '.name() { :; }' ) >/dev/null 2>&1
    }

    # Invalid in strict POSIX compliance.
    zlash_cap_zlash_func_name_with_colon() {
        ( eval ':name() { :; }' ) >/dev/null 2>&1
    }

    # Invalid in strict POSIX compliance.
    zlash_cap_zlash_func_name_with_at() {
        ( eval '@name() { :; }' ) >/dev/null 2>&1
    }

    # Invalid in strict POSIX compliance.
    zlash_cap_zlash_func_name_with_hash() {
        ( eval 'name#5() { :; }' ) >/dev/null 2>&1
    }

    # Invalid in strict POSIX compliance.
    # Supports Ksh93 namespacing.
    zlash_cap_var_name_with_dot() {
        ( eval '.name=' ) >/dev/null 2>&1
    }

    # Invalid in strict POSIX compliance.
    # Is Ksh93-specific.
    zlash_cap_special_ns_var_sh_version() {
        ( eval '[ -n "${.sh.version}" ]' ) >/dev/null 2>&1
    }

    zlash_cap_arith_lit_oct() {
        let '077+077==126' >/dev/null 2>&1 \
            && ! let '08'  >/dev/null 2>&1
    }

    zlash_cap_arith_lit_hex() {
        let '0xFF+0xff==510' >/dev/null 2>&1 \
            && ! let '0xG'   >/dev/null 2>&1
    }

    zlash_cap_arith_lit_bin() {
        let '0b11+0b11==6' >/dev/null 2>&1 \
            && ! let '0b2' >/dev/null 2>&1
    }

    zlash_cap_arith_lit_nbase() {
        let '3#22+3#22==16' >/dev/null 2>&1 \
            && ! let '3#3'  >/dev/null 2>&1
    }

    # Arbitrary precision decimals (Ksh93 uses libmath)
    zlash_cap_arith_arbp() {
        let '0.1+0.2==0.3' >/dev/null 2>&1
    }

    # Boolean logic in arithmetic expressions is derived from C, where
    # 0 is FALSE and non-0 is TRUE.  This is exactly opposite of shell
    # logic compound commands, where 0 is OK and non-0 is a FAILURE.
    _comp_test_cap_arith_bool_logic() {
        let '0==0 && 1<0 || 1' \
            && ! let '1 && 0'
    } >/dev/null 2>&1

    # Floating point math
    zlash_cap_arith_float() {
        let '0.1+0.2!=0.3 && 0.1+0.2<0.3001 && 0.1+0.2>0.2999' >/dev/null 2>&1
    }

    zlash_cap_arith_sqrt() {
        ( eval let 'sqrt(9)==3' ) >/dev/null 2>&1
    }

    zlash_cap_compound_vars() {
        ( eval 'v=( x="X" y="Y" ); [ "${v.y}" = "Y" ]' ) >/dev/null 2>&1
    }

    _compat_test_bash_witness() {
        # BASH_VERSINFO is readonly
        ! ( BASH_VERSINFO=(0) ) >/dev/null 2>&1 \
            || return 1

        # `shopt` is a builtin
        [ "x$(builtin type -t builtin 2>/dev/null)" = "xbuiltin" ]      \
            && [ "x$(builtin type -t shopt   2>/dev/null)" = "xbuiltin" ]\
            || return 1
    }

    # https://git.savannah.gnu.org/cgit/bash.git/tree/NEWS
    _test_bash_5_2_witness() {
        (
            # The new `globskipdots' shell option forces pathname expansion
            # never to return `.' or `..' unless explicitly matched. It is
            # enabled by default.
            [[ -n "$(builtin shopt -p globskipdots 2>/dev/null)" ]] || return 1

            # The `unset' builtin allows a subscript of `@' or `*' to unset a
            # key with that value for associative arrays instead of unsetting
            # the entire array (which you can still do with `unset arrayname').
            # For indexed arrays, it removes all elements of the array without
            # unsetting it (like `A=()').
            declare -A assoc=([one]=1 ['@']=2 [three]=3 ['*']=4 [five]=5)
            [[ ${assoc['@']} -eq 2 ]] || return 1
            [[ ${#assoc[@]}  -eq 5 ]] || return 1
            unset -v 'assoc[@]'
            [[ ${#assoc[@]} -eq 4 ]] || return 1
            unset -v 'assoc[*]'
            [[ ${#assoc[@]} -eq 3 ]] || return 1

            # There is a new parameter transformation operator: @k. This is like
            # @K, but expands the result to separate words after word splitting.
            eval 'declare -a list=("${assoc[@]@k}")' || return 1
            [[ ${#list[@]} -eq 6 ]] || return 1
        )
    }

    _test_bash_5_1_witness() {
        # SRANDOM: a new variable that expands to a 32-bit random number that is
        # not produced by an LCRNG, and uses getrandom/getentropy, falling back
        # to /dev/urandom or arc4random if available. There is a fallback
        # generator if none of these are available.
        eval '[[ -v SRANDOM ]]' 2>/dev/null \
            && [[ SRANDOM -ne SRANDOM ]]     \
            || return 1

        # Associative arrays may be assigned using a list of key-value pairs
        # within a compound assignment. Compound assignments where the words are
        # not of the form [key]=value are assumed to be key-value assignments. A
        # missing or empty key is an error; a missing value is treated as NULL.
        # Assignments may not mix the two forms.
        (
            declare -A assoc=(one 1 two 2)
            eval '[[ -v assoc[two] ]]' 2>/dev/null \
                && [[    assoc[two] -eq 2 ]]        \
                && [[ ${#assoc[@]}  -eq 2 ]]         \
                || return 1
        )
    }

    # TODO more

    _compat_test_zsh_witness() {
        # ZSH_EVAL_CONTEXT and ZSH_SUBSHELL are readonly
        ! ( ZSH_EVAL_CONTEXT="" && (( ZSH_SUBSHELL++ )) ) >/dev/null 2>&2 \
            || return 1

        # `setopt` is a builtin
        [ "x$(builtin whence -w builtin 2>/dev/null)"     \
            = "xbuiltin: builtin" ]                        \
            && [ "x$(builtin whence -w setopt  2>/dev/null)"\
                = "xsetopt: builtin" ]                       \
            || return 1
    }

    _compat_test_ksh93_witness() {
        # `return` is one of "special" builtins that cannot be overriden by
        # functions.
        ! ( eval 'function return { :; }' ) >/dev/null 2>&1 \
            || return 1

        # `.sh` is a builtin namespace.
        ( eval '[[ -n "${.sh.version}" ]]' ) >/dev/null 2>&1 \
            || return 1

        # Advanced math
        ( eval '[[ $((sqrt(9))) -eq 3 ]]' ) >/dev/null 2>&1 \
            || return 1

        # Compound variables
        ( eval 'v=( x="X" y="Y" ); [ "${v.y}" = "Y" ]' ) 2>/dev/null \
            || return 1
    }

    _compat_test_am_zsh() {
        if ! _compat_test_bash_witness \
        && ! _compat_test_ksh93_witness \
        &&   _compat_test_zsh_witness
        then
            ZLASH_SHELL_TYP="zsh"
            eval 'ZLASH_SHELL_VER=${(j:.:)${${(s:.:)ZSH_VERSION}[@]:0:2}}' \
                || return 1
            _compat_test_am_zsh() { builtin return 0; }
            builtin return 0
        else
            _compat_test_am_zsh() { return 1; }
            return 1
        fi
    }

    _compat_test_am_bash() {
        if ! _compat_test_zsh_witness  \
        && ! _compat_test_ksh93_witness \
        &&   _compat_test_bash_witness
        then
            ZLASH_SHELL_TYP="bash"
            ZLASH_SHELL_VER="${BASH_VERSINFO[0]}.${BASH_VERSINFO[1]}" \
                || return 1
            # NOTE: These are not to be cleared during env scrubbing, if
            #       scrubbed subshell doesn't want to lose their "specialness",
            #       as per bash manpage.
            ZLASH_PROTECTED__ZLASH_VARS="$( (
                IFS=":"
                declare -a protected_vars
                protected_vars=(
                    BASHPID       BASH_ALIASES  BASH_ARGV0      BASH_CMDS
                    BASH_COMMAND  BASH_SUBSHELL COMP_WORDBREAKS DIRSTACK
                    EPOCHREALTIME EPOCHSECONDS  FUNCNAME        GROUPS
                    LINENO        RANDOM        SECONDS         SRANDOM
                    BASH_COMPAT   BASH_XTRACEFD HOSTFILE        MAILCHECK
                )
                protected_vars+=("$ZLASH_PROTECTED__ZLASH_VARS")
                echo "$protected_vars"
            ) )" || return 1
            _compat_test_am_bash() { builtin return 0; }
            builtin return 0
        else
            _compat_test_am_bash() { return 1; }
            return 1
        fi
    }

    # `shopt` and `setopt` are not Ksh builtins.
    # `.sh.version` is an illegal veriable name in Bash and Zsh.
    _compat_test_am_ksh93() {
        if ! _compat_test_bash_witness \
        && ! _compat_test_zsh_witness   \
        &&   _compat_test_ksh93_witness
        then
            ZLASH_SHELL_TYP="ksh93"
            ZLASH_SHELL_VER="93.0"
            _compat_test_am_ksh93() { return 0; }
            return 0
        else
            _compat_test_am_ksh93() { return 1; }
            return 1
        fi
    }

    # Initial POSIX-compliant implementation of a version test function,
    # to be specialized after sanity checks and shell type and version
    # discrimination, by appropriate and more performant implementation.
    #
    # Example:
    #
    #     _compat_test_version_majorminor "${VERSION:-0.0}" -ge 4.4 -lt 5.0
    #
    _compat_test_version_majorminor() {
        if [ "$#" -eq 0 ]; then
            echo "ERROR: Illegal _compat_test_version_majorminor" \
                 "call with no arguments." >&2
            return 1
        fi
        [ "$#" -eq 1 ] && return 0
        _LEFT="$1"
        shift
        if ! [ "$((${_LEFT%%.*}))" = "${_LEFT%%.*}" ] \
        || ! [ "$((${_LEFT#*.}))"  = "${_LEFT#*.}"  ]
        then
            echo "ERROR: _compat_test_version_majorminor numbers must be of " \
                 "the decimal form: <major>.<minor>" >&2
            return 1
        fi
        while [ "$#" -gt 0 ]; do
            _OP="$1"
            _RIGHT="$2"
            shift 2
            if ! [ "$((${_RIGHT%%.*}))" = "${_RIGHT%%.*}" ] \
            || ! [ "$((${_RIGHT#*.}))"  = "${_RIGHT#*.}"  ]
            then
                echo "ERROR: _compat_test_version_majorminor numbers must be" \
                     "of the decimal form: <major>.<minor>" >&2
                return 1
            fi
            case "$_OP" in
                -ge|-le|-eq|-gt|-lt)
                    if [ "${_LEFT%%.*}" -eq "${_RIGHT%%.*}" ]; then
                        test "${_LEFT#*.}" "$_OP" "${_RIGHT#*.}" \
                            && continue || return $?
                    else
                        test "${_LEFT%%.*}" "$_OP" "${_RIGHT%%.*}" \
                            && continue || return $?
                    fi
                    ;;
                *)
                    echo "ERROR: _compat_test_version_majorminor comparison" \
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
    #       with more specialization using `Test_AmBash`, `Test_AmZsh`, etc...
    _compat_id_shell_type() {
        if   _compat_test_am_bash; then
            if ! _compat_test_version_majorminor "$ZLASH_SHELL_VER" -ge 5.2
            then
                builtin echo "WARNING:" "$ZLASH_SHELL_TYP" \
                        "$ZLASH_SHELL_VER" "is too low!" >/dev/stderr
            fi
        elif _compat_test_am_zsh; then
            if ! _compat_test_version_majorminor "$ZLASH_SHELL_VER" -ge 5.9
            then
                builtin echo "WARNING:" "$ZLASH_SHELL_TYP" \
                        "$ZLASH_SHELL_VER" "is too low!" >/dev/stderr
            fi
        elif _compat_test_am_ksh93; then
            echo "ERROR: ksh93 is not yet supported!" >/dev/stderr
            return 1
        else
            # TODO: check if POSIX guarantees /dev in all environments.
            echo "ERROR: failed to identify a supported shell type!" >&2
            return 1
        fi
    }

    _compat_id_shell_type || exit 1
}

_compat_init
# NOTE: POSIX compliance can be dropped from here, in favor of shell-specific
#       extenstions.

# NOTE: General Spacialization Pattern. Pre-specialized definitions are under
#       `Zlash::` namespace, for maximal dynamic introspection (dynamic
#       dependency resolution via dryrun debug traps, and minimal version
#       identification per function) and automatic forwarding of functionality
#       subsets to any remote supported shells.
# NOTE: Ksh adheres strictly to POSIX function name format, which is the same
#       as variable name format.  So despite Bash and Zsh supporting much more
#       variety of characters in functino names, to remain portable, we must
#       limit outselves in function naming, but can still use aliases to get
#       desired effect on all POSIX shells.
alias Initialize-MinShellOpts=Initialize_MinShellOpts
alias Zlash::Initialize-MinShellOpts=Zlash__Initialize_MinShellOpts
Initialize_MinShellOpts() {
    Zlash::Initialize-MinShellOpts \
        && Initialize-MinShellOpts
}
Zlash__Initialize_MinShellOpts() {
    # TODO: Check what versions support these options.
    _compat_test_am_bash && \
        Initialize_MinShellOpts() {
            builtin local opt
            for opt in nounset pipefail; do
                builtin set -o $opt; done
            builtin shopt -s huponexit expand_aliases shift_verbose
        }
    _compat_test_am_zsh && \
        Initialize_MinShellOpts() {
            builtin setopt \
                    nolocaloptions ksharrays nounset pipefail errreturn \
                    hup aliases interactivecomments
        }
    _compat_test_am_ksh93 && \
        Initialize_MinShellOpts() {
            echo "Not Implemented!" >/dev/stderr
            exit 1
        }
}

Initialize-MinShellOpts
# NOTE: Can use alias expansion non-interactively from here.

alias Test-VersionMajorMinor=Test_VersionMajorMinor
alias Zlash::Test-VersionMajorMinor=Zlash__Test_VersionMajorMinor
Test_VersionMajorMinor() {
    Zlash::Test-VersionMajorMinor \
        && Test-VersionMajorMinor "$@"
}
Zlash__Test_VersionMajorMinor() {
    # Default unspecialized Test_VersionMajorMinor
    Test_VersionMajorMinor() { _compat_test_version_majorminor "$@"; }

    # TODO: Specialize as needed, like so:
    #
    # Test-AmBash -ge 5.2         && Test_VersionMajorMinor() { ... }
    # Test-AmBash -ge 5.0 -lt 5.2 && Test_VersionMajorMinor() { ... }
    # Test-AmBash -ge 4.4 -lt 5.0 && Test_VersionMajorMinor() { ... }
    # Test-AmBash -ge 4.0 -lt 4.4 && Test_VersionMajorMinor() { ... }
    # Test-AmZsh  -ge 5.0         && Test_VersionMajorMinor() { ... }
    # ... etc...
}

alias Test-AmBash=Test_AmBash
alias Test-AmZsh=Test_AmZsh
alias Test-AmKsh=Test_AmKsh
Test_AmBash() {
    _compat_test_am_bash && Test-VersionMajorMinor "$ZLASH_SHELL_VER" "$@"
}
Test_AmZsh() {
    _compat_test_am_zsh && Test-VersionMajorMinor "$ZLASH_SHELL_VER" "$@"
}
Test_AmKsh() { _compat_test_am_ksh93; }

#------------------------------------------------------------------------------
### 4.    FOUNDATIONAL BOOTSTRAPPING DEFINITIONS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
# Bootstrapping foundational definitions here.  Their attibute definitions
# for parameters and help are added later, after attribute mechanisms are
# defined.
#

# Avoiding `echo` pitfalls. See: https://www.etalabs.net/sh_tricks.html
alias Write-Out=Write_Out
alias Zlash::Write-Out=Zlash__Write_Out
Write_Out() {
    Zlash::Write-Out \
        && Write-Out
}
Zlash__Write_Out() {
    # Default fallback
    Write_Out() { echo -- "$*"; }

    Test-AmBash && \
        Write_Out() {
            local IFS=$' '
            builtin printf $'%s\n' "$*"
        }

    # Zsh comp makes this faster (see ./shellbench/write-echo.sh)
    Test-AmZsh && \
        Write_Out() {
            [[ "$IFS" == ' '* ]] || local IFS=$' '
            builtin printf $'%s\n' "$*"
        }
}

alias Write-Err=Write_Err
Write_Err() { Write-Out "$@" >/dev/stderr; }

alias Invoke-Silent=Invoke_Silent
alias Invoke-OnlyOut=Invoke_OnlyOut
alias Invoke-NoFail=Invoke_NoFail
Invoke_Silent()  { "$@" 2>/dev/null 1>/dev/null; }
Invoke_OnlyOut() { "$@" 2>/dev/null; }

# `builtin` works differently in Ksh.  Additionally,
# Ksh has "special" builtins, which have higher precedence than
# functions, and cannot be overriden by aliases.


Invoke_NoFail()  { "$@" || builtin return 0; }  # TODO: spec ksh

# Making `$funcstack` work in Bash as in Zsh.
Test-AmBash -ge 5.0 && \
    builtin declare -gn funcstack="FUNCNAME"

# Common naming of basic variable declarations
Test-AmBash && {  # TODO: spec more versions
    alias New-LocalName='builtin local'
    alias New-LocalNameRef='builtin local -n'
    alias New-LocalShadow='builtin local -I'
    alias New-LocalInt='builtin local -i'
    alias New-LocalIxArr='builtin local -a'
    alias New-LocalAssoc='builtin local -A'
    alias New-GlobalName='builtin declare -g'
    alias New-GlobalNameRef='builtin declare -gn'
    alias New-GlobalInt='builtin declare -gi'
    alias New-GlobalIxArr='builtin declare -ga'
    alias New-GlobalAssoc='builtin declare -gA'
}
Test-AmZsh && {  # TODO: spec more versions
    alias New-LocalName='builtin local'
    alias New-LocalInt='builtin local -i'
    alias New-LocalFloat='builtin local -F'
    alias New-LocalIxArr='builtin local -a'
    alias New-LocalAssoc='builtin local -A'
    alias New-GlobalName='builtin typeset -g'
    alias New-GlobalInt='builtin typeset -gi'
    alias New-GlobalFloat='builtin typeset -gF'
    alias New-GlobalIxArr='builtin typeset -ga'
    alias New-GlobalAssoc='builtin typeset -gA'
}
Test-AmKsh && {  # TODO: spec more versions
    alias New-LocalName=typeset
    alias New-LocalNameRef='typeset -n'
    alias New-LocalInt='typeset -i'
    alias New-LocalIxArr='typeset -a'
    alias New-LocalAssoc='typeset -A'
    alias New-LocalCompound='typeset -C'
    alias New-GlobalName='typeset -g'
    alias New-GlobalInt='typeset -gi'
    alias New-GlobalFloat='typeset -gF'
    alias New-GlobalIxArr='typeset -ga'
    alias New-GlobalAssoc='typeset -gA'
    alias New-GlobalCompound='typeset -gC'
    alias Move-Variable='typeset -m'
}

# TODO: add more flag tests.
# TODO: decide if these should be moved and made inline later.
Test_IsFile()             { [[   -f "$1"   ]]; }
Test_IsExecutable()       { [[   -x "$1"   ]]; }
Test_IsReadable()         { [[   -r "$1"   ]]; }
Test_IsWritable()         { [[   -w "$1"   ]]; }
Test_IsDirectory()        { [[   -d "$1"   ]]; }
Test_IsPipe()             { [[   -p "$1"   ]]; }
Test_IsSocket()           { [[   -S "$1"   ]]; }
Test_IsTerminal()         { [[   -t "$1"   ]]; }
Test_IsShellRestricted()  { [[ "$-" == *r* ]]; }
Test_IsShellPrivileged()  { [[ "$-" == *p* ]]; }  # TODO: check zsh is same
Test_IsShellInteractive() { [[ "$-" == *i* ]]; }
alias Test-IsShellInteractive=Test_IsShellInteractive

# TODO: what are the minimal shell versions for str slicing?
Test_IsFullPath() { [[ "${1:0:1}" == "/" ]]; }

# NOTE: `Test-IsAssocName` should not be done by this for perf reason.
#       Caller should validate association array exists.
# TODO: clarify versions, and provide lower version implementations.
Test_IsAssocKey() { [[ -v "$1"'[$2]' ]]; }

alias Test-IsAliasName=Test_IsAliasName
alias Test-IsVarName=Test_IsVarName
alias Test-IsFuncName=Test_IsFuncName
Test-AmKsh && {
    Test_IsAliasName() { Invoke-Silent  alias     "$1"; }
    Test_IsVarName()   { Invoke-Silent typeset -p "$1"; }
    Test_IsFuncName()  { Invoke-Silent typeset -f "$1"; }
} || {
    Test_IsAliasName() { Invoke-Silent builtin  alias     "$1"; }
    Test_IsVarName()   { Invoke-Silent builtin typeset -p "$1"; }
    Test_IsFuncName()  { Invoke-Silent builtin typeset -f "$1"; }
}

# NOTE: This is a weak test, used for bootstrapping. Better tests are:
#         - `Test-IsIxArrName`
#         - `Test-IsAssocName`
#         - `Test-IsAssocOrIxArrName`
Test-AmBash && \
    _Test_IsArrName() {
        [[ "$(Invoke-Silent builtin declare -p "$1")" == 'declare -a'* ]]
    }
Test-AmZsh && \
    _Test_IsArrName() {
        [[ "$(Invoke-Silent builtin typeset -p "$1")" == 'typeset -a'* ]]
    }
Test-AmKsh && \
    _Test_IsArrName() {
        [[ "$(Invoke-Silent typeset -p "$1")" == 'typeset -a'* ]]
    }

# Basic exception bootstrapping definitions,
# redefined/inlined after required definitions are complete.

# Errors Stack
_Test_IsArrName ZLASH_ERRORS || {
    New-GlobalIxArr ZLASH_ERRORS
    ZLASH_ERRORS=()
}

alias Push-Error=Push_Error
Push_Error() {
    ZLASH_ERRORS=("$1" "${ZLASH_ERRORS[@]:0:${ZLASH_MAX_ERRORS:-100}}")
}

Test-AmKsh && {
    alias Pass='return 0'
    alias Fail='return 1'
} || {
    alias Pass='builtin return 0'
    alias Fail='builtin return 1'
}

alias New-ErrorAlias=New_ErrorAlias
Test-AmBash && \
    New_ErrorAlias() {
        New-LocalName name
        name="$(builtin printf %q\\n "$1")"
        alias "$1"="Push-Error \"$name in ( \${FUNCNAME[@]} )\"; Fail"
    }
Test-AmZsh && \
    New_ErrorAlias() {
        New-LocalName name
        name="$(builtin printf %q\\n "$1")"
        alias "$name"="Push-Error \"$name in ( \${funcstack[@]} )\"; Fail"
    }
Test-AmKsh && \
    New_ErrorAlias() {
        New-LocalName name
        name="$(printf %q\\n "$1")"
        alias "$name"="Push-Error \"$name in \${.sh.fun}\"; Fail"
    }

New-ErrorAlias Error::NotExpected
New-ErrorAlias Error::NotImplemented

alias Test-IsShellLogin=Test_IsShellLogin
Test_IsShellLogin() { Error::NotImplemented; }
Test-AmBash && \
    Test_IsShellLogin() { builtin shopt -q login_shell; }

Test_IsAssocOrIxArrName() { Error::NotImplemented; }
Test_IsAssocName()        { Error::NotImplemented; }
Test_IsIxArrName()        { Error::NotImplemented; }
Test_IsKeywordName()      { Error::NotImplemented; }
Test_IsBuiltinName()      { Error::NotImplemented; }
Test_IsExeName()          { Error::NotImplemented; }
# TODO: implement Zsh versions
Test-AmBash -ge 5.0 && {  # TODO: implement lower Bash versions
    Test_IsAssocOrIxArrName() {
        Test-IsVarName "$1" && local -n ref="$1" && [[ "${ref@a}" == *[aA]* ]]
    }
    Test_IsAssocName() {
        Test-IsVarName "$1" && local -n ref="$1" && [[ "${ref@a}" == *A* ]]
    }
    Test_IsIxArrName() {
        Test-IsVarName "$1" && local -n ref="$1" && [[ "${ref@a}" == *a* ]]
    }
}
Test-AmBash && {
    Test_IsKeywordName() {
        [[ "$(Invoke-OnlyOut builtin type -ta "$1")" == *keyword* ]]
    }
    Test_IsBuiltinName() {
        [[ "$(Invoke-OnlyOut builtin type -ta "$1")" == *builtin* ]]
    }
    Test_IsExeName() {
        [[ "$(Invoke-OnlyOut builtin type -ta "$1")" == *file* ]]
    }
}
