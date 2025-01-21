# -*- mode: shell-script -*-
#
# Project: Zlash
# File:    zla.sh
# Summary: Zero-install Logical Adaptive Structured Shell
# Author:  Yevgeniy Grigoryev
# License: MIT License (https://opensource.org/licenses/MIT)
# Copyright (c) 2024-2025 Yevgeniy Grigoryev
#

# Disabling irrelevant shellcheck checks for the whole file:
#
#   - Use foo "$@" if function's $1 should mean script's $1.
#      ( https://www.shellcheck.net/wiki/SC2119 )
#
# shellcheck disable=SC2119
#

#------------------------------------------------------------------------------
### 1.         PROLOGUE
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#### 1.1.      Goal
#
# Launch any POSIX-compatible[^1] shell, including remote sessions. By sourcing
# this file -- whether manually or auto-forwarded from another shell instance --
# you unlock advanced interactive features. These include structured objects,
# object pipelines, binary data processing, custom class definitions, and more.
# Additionally, Zlash introduces novel capabilities powered by an integrated
# relational solver, all tailored to your environment without requiring
# installation, automatically optimized by available, probed tools.
#
# [^1]: By a POSIX-compatible shell, we mean any shell that is able to interpret
#       and execute a POSIX-compliant shell script.
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#### 1.2.      Motivation
#
# The increasing popularity and proliferation of modern interactive shells[^1],
# terminal emulators[^2], and a large number of new, high-quality CLI/TUI
# tools/apps[^3] is a proof of a need that a GUI cannot fulfill generally. That
# need is the expressive power and replicability that an interactive
# command-line provides.
#
# The POSIX standard, while foundational in unifying early computing
# environments, faces limitations due to its success. Maintaining compatibility
# with legacy systems and mitigating issues caused, in part, by
# underspecification have hindered its evolution. As a result, modern shells
# often trade POSIX compliance for advanced functionality.
#
# However, the need for compatibility remains critical. Legacy systems still
# require maintenance, and many production environments must restrict utilities.
#
# While GNU Autoconf project (likely the best success story in portable complex
# tool chain) addresses the portability problem by identifying the best tools
# available in the environment/system, for its shell functionality it sticks to
# the lowest-common-demomenator across all historical possibilities, which is
# not a huge issue for it since Autoconf's scripting is never interactive.
#
# Zlash project scope is targeting POSIX-compatible interactive shells, and all
# of these are moderately-to-severely lacking when compared to modern, but POSIX
# non-compatible shells. We aim to address these challenges by probing for and
# building on the features available to current shell, which makes this much
# more viable than building on the lowest-common-denominator from the 1970s.
#
# [^1]: Powershell, Nushell, Fish, Xonsh, Elvish, Murex, etc...
#
# [^2]: Kitty, Wezterm, Ghostty, Alacrity, Warp, Hyper, Extraterm, Tabby
#       (formerly Terminus), Contour, Wave, darktile, rio, cool-retro-term,
#       etc.. See: https://github.com/cdleon/awesome-terminals
#
# [^3]: See: https://github.com/toolleeo/awesome-cli-apps-in-a-csv
#       (just searching page for "Rust" already gives 50+ results)
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#### 1.2.      The Plan
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
##### 1.2.1.   High-Level Plan
#
# 1. We start by relying on *hundreds* of cumulative man-years of experience
#    distilled in GNU Autoconf Manual, Portable Shell Programming section[^1],
#    and the POSIX Standard, Shell Utility section[^2]. We implementing a very
#    basic portable functionality, just sufficient to start probing for
#    successively more advanced features.
#
# 2. Then we probe current shell's capabilities, expanding our functionality on
#    them ONLY if it's required for the following, more advanced probing.
#
# 3. After current shell's capabilities have been sufficiently probed, we build
#    on them successively more advanced functionality to reaching parity of
#    features of every modern POSIX-compatible interactive shell (think ksh93
#    with zsh's completions, bash with ksh93's nested compound variables,
#    discipline functions, automatic documentation, etc...), albeit using a bit
#    more verbose, but cross-shell syntax.
#
# 4. Now we add some features of Powershell, namely advanced functions with
#    validating and completing parameters, custom classes and objects with
#    methods passed through the pipeline, etc...). Then we add and explore new
#    features relational programming enables.
#
# Initial targets for both, the host shell and the feature-parity shells of step
# (3) are Bash 5.0, Zsh 5.9, and Ksh93. Overtime, the current shell target can
# be lowered all the way down to pre-array shells, where some interactive
# features will be lost again if substituting external tools (e.g. `fzf`) are
# not found.
#
# [^1]: https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/html_node/Portable-Shell.html
#
# [^2]: https://pubs.opengroup.org/onlinepubs/9799919799/utilities/V3_chap02.html
#
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
##### 1.2.2.  Performance Expectations
#
# When a Zlash command is executed for the first time, a best available
# specialized implementation will be selected based on capabilities of the
# shell, system, and availability of external tools. Capabiliteis are tested
# only once per shell invocation (by default).
#
# While Zlash will attempt best effort, the additional features it provides
# above base shell capabilities should not be expected to be comparable in
# performance to best industry implementations of equivalent functionality. And
# if no optimizing capabilities are discovered by Zlash, the fallbacks may be
# significantly slower.
#
# Having said that, in some environments there will be no alternatives possible,
# and having some of these features despite performance penalties may be
# preferrable over not having them.
#
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
##### 1.2.2.  Structured Data in `/bin/sh`?
#
# To sketch, we start with four base types:
#
# - Str   : for string values or shell words
# - Ref   : (possibly shell-native) namerefs of other variables by names
# - IxArr : (shell-native or prefix-emulated) indexed arrays
# - Assoc : (shell-native or prefix-emulated) associative arrays
#
# Each has `New-*` constructors, at least Local and Global variants, that can be
# called with optional assignments, like so:
#
# > New-LocalStr myvarname "value"
#
# This will have the effect of `myvarname` variable in current function scope
# holding a value of something like `0x1f5`, which is unique ID of the object.
# Commands like the following become available:
#
# > $myvarname.length
#
# Which will execute a function `0x1f5.length`, created by the constructor, and
# on completion, a variable `REPLY` is set to the shell-supported expansion like
# `${#0x1f5}`, or appropriate fallback to external tool invocation or portable
# implementation.
#
# These "methods" can be getters, setters, pipers, showers, etc..., and behave
# as expected when values of elements are of other object types, including the
# Ref type.
#
# Ksh93 adheres more strictly to POSIX function naming and doesn't allow
# characters like `.` in function names. However, Ksh93 has proper hierarchical
# `namespace`s, `discipline` functions, and user-defined custom types with
# methods, including for nested compount variables. For example, the following
# is valid in `ksh93t+`:
#
# > $ typeset -T StrT=(
# > |     function length {
# > |         REPLY=${#_}
# > |     }
# > | )
# > $ function New_Str {
# > |     typeset -n var="$1"
# > |     StrT ._0x1f5="$2"
# > |     var=._0x1f5
# > | }
# > $ New_Str VAR '12345'
# > $ $VAR.length
# > $ echo $REPLY
# > 5
# > $
#
# Custom object types can be derived from the four base ones either via
# prototyping mechanism, or a more complex one, like Python's metaclass
# mechanism, including dynamic method resolution. # TODO
#
# Object references are accounted (mechanisms varying widely depending on shell
# capabilities) and object is recursivelty unset when refcount reaches zero.
#
#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
##### 1.2.3.  Binary Data in `/bin/sh`?
#
# Most POSIX-compatible shells cannot store plain binary data in their variables
# because they use C-strings internally, which are null (`\0`) terminated. So
# the null (`\0`) character cannot exist in the string content, even when shell
# is able to express it as a literal:
#
# > $ var=$'ab\0cd'
# > $ echo ${#var}
# > 2
#
# Zsh is an exception here. It even handles pattern matching over binary data:
#
# > $ [[ $var == *$'\0cd' ]] && echo ok || echo failed
# > ok
#
# There are two workarounds, with very different semantics:
#
# 1. Shell variable semantic (i.e. global, local, subshell isolation):
#
#    Work with Base64 encoded binary values. Since it's a power of two base, bit
#    manipulation is still easy.
#
# 2. Persistent (with cleanup) object IPC semantic:
#
#    Use temporary files as binary scalar objects and temporary directories as
#    hierarchical objects with methods as scripts:
#
#    > $ echo "$OBJ"
#    > /mnt/ramdisk_zlsh_41369/
#    > $ $OBJ.mymethod arg1 arg2
#
#    Actual implementation is more complex than this, since shells would clear
#    non-exported names before executing the script, but user interface remains
#    essentially the same.
#
#    Zlash can create/reuse a ramdisk (or equivalent), depending on environment
#    capabilities, with fallback utilizing `/tmp` or equivalent.
#
# Complex objects could be moved between the two semantics, opening a
# possibility for efficient coprocess shared complex objects. (where efficiency
# is dependent on shell and system capabiliteis)
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#### 1.3.     Reserved Identifier Namespace
#
# To facilitate prevention of naming collisions with user-definer or imported
# functions or variables, the project reserves the following name prefixes.
#
# - `ZLASH` is a reserved prefix for environment variables.
#
# - `ZLASH`, `Zlash`, `zlash` are reserved name prefixes for shell functions and
#   shell variables. `zlash` prefix is a lower-level interface than `Zlash`.
#
# - `_ZLSH`, `_Zlsh`, `_zlsh`, and `_unsafe_zlsh` are reserved prefixes for
#   shell private functions and shell private variables. `_unsafe_zlsh`-prefixed
#   private functions arguments should be either owned or sanitized by callers.
#
# - `_[1-9]` (default) followed by any number of `[0-9]` are not reserved, but
#   set, dynamic logic variable identifiers. They are set to matched values by a
#   solver, when solver is not provided with names for them. Zlash sets them
#   only in contexts of solvers and solution callbacks. This convention is
#   adopted from SWI-Prolog's anonymous variables, where its chosen for
#   readability of complex solution structures. (`_` part is customizable.)
#
# - `_0` (default) name prefix is partially reserved by the format: `_0Mxxxxxx`,
#   where `M` stands for an arbitrary "marker" character from the `[:alpha:]`
#   set, followed by at least one or more of hexadecimal digits denoted by `x`
#   (upper or lower case). These are reserved for unique identifier generation.
#   The short form is chosen for a more humane representation in observable
#   introspection. (`_0M` part is customizable.)
#
# - If shell has `namespace`s, hiararchical (ksh93) or not, these prefixes are
#   also reserved for the top-level `namespace`s. Which, in Ksh93 case, means
#   additional initial dot (`.`).
#
# - Additionally, a number of functions of the form *Verb_Noun* are provided, as
#   defined in this file, and aliased to *Verb-Noun* form when underlying shell
#   capability allows. These functions are the intended main interactive
#   interface.
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#### 1.4.     Function Naming Conventions
#
# Zlash adopts interactive function naming convention from Powershell for its
# discoverability, where the format is Verb-Noun, with Verb restricted to
# approved verbs[^1], with a few exceptions. Due portability, we adapt the
# convention to Verb_Noun, provide an alias of the form Verb-Noun, and enable
# alias expansion in scripts, if current shell has that option and it is
# disabled.
#
# Non-interactive Zlash functions are not restricted to that form, but will have
# the reserved prefix to avoid collisions. Effort is made to balance name
# lengths, categories, and argument type and order hints. For example,
# `_unsafe_zlsh_prtbl_var_copy`:
#
# - `_unsafe_zlsh_` means its arguments must be fully owned or sanitized by the
#   caller, and the function is a private part of this project, not intended to
#   be used by user;
#
# - `_prtbl_` means it's part of the portable category, to be useable prior
#   shell's capabilities are probed;
#
# - `var_copy` should hint that first argument is a source variable name, while
#   second is a destination variable name.
#
# [^1]: https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands
#       (Or run `Get-Verb` in Powershell, or `pwsh -nop -c get-verb` from other
#       shell if Powershell is installed)
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#### 1.5.     Sourcecode Sections
#
# The sourcecode is grouped into hierarchical sections, marked by comment
# blocks. These, sometimes indentation-breaking, comment blocks serve a dual
# purpose:
#
# 1. Enable quick and interactive TOC/section navigation, provided your editor
#    can support that (e.g. `helm-swoop` or `vim-swoop` for Emacs and Vim
#    respectively), or similar navigation to a manpage. Example "swoops":
#
#     - `^###`     : full Table of Contents;
#
#     - `^###\ `   : only top level ToC;
#
#     - `^### \ 2` : full ToC of only section 2.
#
# 2. Inline source of automatic user documentation generation, distinct from dev
#    documentation, and distinct from user-discoverable help. The contents of
#    these comment blocks are in Markdown syntax, and require minimal processing
#    to generate user documentation from.
#
# Tripple hash (`#`) for top-level sections ensures commenting out
# cross-sectional blocks will not affect navigation during development. Initial
# two characters of each line of these blocks are removed in the documentation
# generation pipeline.
#
# The "specialness" of these comment blocks is delimited at start by a dashed
# line comment and at end with the end of the comment block, i.e. a line not
# starting with a hash mark (`#`), or beginning of another such comment block.
#

#------------------------------------------------------------------------------
### 2.        INITIALIZATION
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#### 2.1.     Portable Minimal Functionality
#
# Before current shell capabilities have been probed, we need shell-portable
# basic functionality, assuming as few constructs and utilities as possible. The
# best references for this are:
#
# - GNU Autoconf Manual, Portable Shell Programming Section:
#   https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/html_node/Portable-Shell.html
#
# - POSIX Standard, Utilities Section, Shell Command Language Chapter:
#   https://pubs.opengroup.org/onlinepubs/9799919799/utilities/V3_chap02.html
#
# - Z-shell FAQ, Chapters 2 and 3:
#   https://zsh.sourceforge.io/FAQ/zshfaq.html
#
#     (Zsh default functionality is only partially POSIX-compatible,
#      necesitating only a subset of POSIX shell language for portability.)
#
# Literature for bonus points:
#
# - https://mywiki.wooledge.org/CategoryShell
#

#____________________________
# `zlash_prtbl_check_sanity`
#
# Check if Zlash assumptions hold under current shell, which are a subset of a
# portable subset (not a mistake) of the POSIX shell language.
#
# Zlash does not support a shell under which this sanity check fails.
#
# On failure, an effort is made to output execution trace.
#
# EXIT STATUS
#     0     Zlash assumptions hold under current shell.
#     >0    Current shell is not supported by Zlash.
#
zlash_prtbl_check_sanity() {
    if ! _zlsh_prtbl_check_sanity >/dev/null 2>&1
    then (
        # Attempt to set execution trace and verbosity
        set -vx || set -v -x || set -x || :

        # Rerun the sanity check
        _zlsh_prtbl_check_sanity
    )
    fi
}

# The following is a non-exhaustive sanity check of a baseline portable POSIX
# language subset.
#
# The checks are all lumped together, since failing one is enough to bail out.
# Isolating each individual test here could have a significant impact on
# initialization performance, depending on underlying shell's subshell
# optimization techniques.
#
# Current implementation priorities: smoke-testing assumptive features;
# minimizing number of subshells for checks in aggregate (since this is executed
# first during initialization, so on each shell invocation); and balancing being
# consice (since this is just a minimal baseline check, before even anything
# Zlash implements), (subjectively) readable, and have traceability helpers
# (`CHECK`). The price it pays is individual checks composability -- checks rely
# on state modified by prior checks within this function's invocation.
#
# The sanity check is meant as a guard to not proceed unless we have enough
# basic and critical capabilities, e.g. subshell isolation, substring removing
# expansions (required for critical fallback implementation of quoting variable
# content), commmand-temporary environment (required for local scope fallback
# implementation), etc...
#
# NOTE: Significant deviations in default behavior, most modifiable via options,
#       nevertheless necesitating omission from the baseline:
#
#       - Bash aliases are not expanded in non-interactive shell mode
#         (`shopt -s expand_aliases` is needed in non-interactive mode)
#
#       - Zsh unquoted parameter expansions are not word-split
#         (`${=var}` expansion flag needs to be used)
#
#       - Zsh unquoted pattern fragments derived from parameter expansions (or
#         command substitutions) are treated as if they were quoted -- expanded
#         pattern metacharacters are not special
#         (`${~var}` unquoted expansion flag needs to be used in pattern context
#          for expansion's pattern metacharacters to be treated as such)
#
#       - Ksh93 function name validation adheres strongly to POSIX specification
#         (`alias`  utilization is needed to relax invocation syntax)
#
_zlsh_prtbl_check_sanity() {
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
    &&  : CHECK '(...)' subshell                   \
    &&  if (exit 1) || (return 1) || _ZLSH_TMP='OK' \
        &&  : CHECK while, read commands,            \
                    redirection, process substitution \
        &&    _ZLSH_TMP_CHECKSUM=                      \
        &&  while read _ZLSH_TMP_CHECKSUM; do           \
                : CHECK break command
                break
            done < <(

                _ZLSH_TMP_CHECKSUM=0 || exit 1
                CHECK() {
                    : CHECK let command, assigning addition
                    let _ZLSH_TMP_CHECKSUM+=1
                } || exit 1

                CHECK CHECK                               \
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
                && CHECK arithmetic context boolean logic translation \
                &&  ! let 0 && let 1 && let 2 && let '-1' && let '-2'  \
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
                && CHECK escaping                          \
                &&    [ "\"" =  '"' ] && [ "\\" =   '\' ]   \
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
                && CHECK concatenation                                    \
                &&    [ "_$_ZLSH_TMP, it's ok" = _NOT\ OK,' it'"'"'s ok' ] \
                                                                            \
                && CHECK string length expansion  \
                &&    [ ${#_ZLSH_TMP} = '6' ]      \
                                                    \
                && CHECK set/empty/assign param expn    \
                &&    [ "${_ZLSH_DONOTSETME-x}"  = 'x' ] \
                &&    [ "${_ZLSH_DONOTSETME:-x}" = 'x' ]  \
                &&    [ "${_ZLSH_DONOTSETME+x}"  = ''  ]   \
                &&    [ "${_ZLSH_DONOTSETME:+x}" = ''  ]    \
                &&    [ "${_ZLSH_DONOTSETME=}"   = ''  ]     \
                &&    [ "${_ZLSH_DONOTSETME}"    = ''  ]      \
                &&    [ "${_ZLSH_DONOTSETME-x}"  = ''  ]       \
                &&    [ "${_ZLSH_DONOTSETME:-x}" = 'x' ]        \
                &&    [ "${_ZLSH_DONOTSETME+x}"  = 'x' ]         \
                &&    [ "${_ZLSH_DONOTSETME:+x}" = ''  ]          \
                &&    [ "${_ZLSH_DONOTSETME:=y}" = 'y' ]           \
                &&    [ "${_ZLSH_DONOTSETME}"    = 'y' ]            \
                &&    [ "${_ZLSH_DONOTSETME-x}"  = 'y' ]             \
                &&    [ "${_ZLSH_DONOTSETME:-x}" = 'y' ]              \
                &&    [ "${_ZLSH_DONOTSETME+x}"  = 'x' ]               \
                &&    [ "${_ZLSH_DONOTSETME:+x}" = 'x' ]                \
                &&    [ "${_ZLSH_DONOTSETME=z}"  = 'y' ]                 \
                &&    [ "${_ZLSH_DONOTSETME:=z}" = 'y' ]                  \
                &&    [ "${_ZLSH_DONOTSETME}"    = 'y' ]                   \
                                                                            \
                &&  nargs() {
                        CHECK distinct variable versus function namespaces
                        nargs=$#

                        first="${1:-}"
                        second="${2:-}"
                        third="${3:-}"
                        fourth="${4:-}"
                    }\
                && CHECK argument passing                      \
                &&    nargs '' '2 3' 4  && [ "$nargs" -eq  3   ]\
                                        && [ "$first"  =  ''   ] \
                                        && [ "$second" = '2 3' ]  \
                                        && [ "$third"  =  '4'  ]   \
                && CHECK parameter argument                         \
                &&    nargs "$_ZLSH_TMP"    && [ "$nargs" -eq  1    ]\
                                            && [ "$first" = 'NOT OK' ]\
                && CHECK empty parameter argument                      \
                &&    _ZLSH_TMP=''                                      \
                &&    nargs "$_ZLSH_TMP"    && [ "$nargs" -eq   1 ]      \
                                            && [ "$first"  =   '' ]       \
                && CHECK no argument                                      \
                &&    nargs && [ "$nargs" -eq 0 ]                          \
                                                                            \
                &&  recursive() {
                        if [ "${1+x}" ]; then
                            nargs "$@"
                        else
                            CHECK recursion
                            recursive '' '2 3' 4
                        fi
                    }\
                &&  recursive   && [ "$nargs" -eq  3     ]  \
                                && [ "$first"  =  ''     ]   \
                                && [ "$second" =  '2 3'  ]    \
                                && [ "$third"  =  '4'    ]     \
                                                                \
                && CHECK process substitution and printf %s   \
                &&    [ "$(printf '%s\n' 'OK')" = 'OK' ]       \
                                                                \
                &&  is_valid() {
                        # is_valid desc [str1 [str2 ...]]
                        # Success if every strN is valid variable identifier
                        desc="$1"
                        _n=$#
                        CHECK shift command
                        shift
                        [ $_n -eq $# ] && return 1
                        CHECK -gt
                        [ $_n -gt $# ] || return 1
                        acc=0
                        CHECK for, continue, and case commands
                        for arg in "$@"; do
                            CHECK "$desc" matching "$arg" for '[_[:alpha:]]*'
                            case "$arg" in
                                [_[:alpha:]]*) :;;
                                *) continue;;
                            esac
                            CHECK "$desc" matching \
                                  "$arg" against '*[^_[:alpha:][:digit:]]*'
                            case "$arg" in
                                *[^_[:alpha:][:digit:]]*) continue;;
                                *)  CHECK arithmetic expansion
                                    acc=$((acc + 1))
                                    ;;
                            esac
                        done
                        CHECK expected number of loops for number of matches
                        [ $# -eq "${acc}" ]
                    }\
                && CHECK pattern matching                  \
                &&    is_valid 'var name' one Two _three_ _4\
                &&  ! is_valid 'bad var name'      '$one'    \
                &&  ! is_valid 'not good var name' 'one two'  \
                &&  ! is_valid 'also bad var name' '1_one'     \
                                                                \
                && CHECK '.' sourcing command               \
                &&  ! [ "${_ZLSH_TMP-}" = 'NOT OK' ]         \
                &&  . <(printf '%s\n' '_ZLSH_TMP="NOT OK"')   \
                &&    [ "${_ZLSH_TMP-}" = 'NOT OK' ]           \
                                                                \
                && CHECK substring removal            \
                &&    [ "${_ZLSH_TMP#?}"   =  'OT OK' ]\
                &&    [ "${_ZLSH_TMP#*O}"  =   'T OK' ] \
                &&    [ "${_ZLSH_TMP##*O}" =      'K' ]  \
                &&    [ "${_ZLSH_TMP%O*}"  = 'NOT '   ]   \
                &&    [ "${_ZLSH_TMP%%O*}" = 'N'      ]    \
                                                            \
                && CHECK 'var= cmd;' temp params \
                &&  _zlsh_tmp() {                 \
                        [ "${_ZLSH_TMP-}" = 'ok' ];\
                    }                               \
                &&  ! _ZLSH_TMP='OK' _zlsh_tmp       \
                &&    _ZLSH_TMP='ok' _zlsh_tmp        \
                &&    [ "${_ZLSH_TMP-}" = 'NOT OK' ]   \
                &&  {
                        # Confirm subshell isolation -- if after subshell exit,
                        # `true` or `:` will fail, overall check cannot succeed,
                        # since the `if-then` component block of the `if`
                        # compound command will not get evaluated, and it is the
                        # only branch to return 0 (success) from the sanity
                        # check.
                        CHECK alias command
                        # NOTE: We only check if `alias` command doesn't fail
                        #   here. Checking alias expansion, attempting to
                        #   renable alias expansions option on failure,
                        #   re-evaluating a function definition command to let
                        #   alias expand, and rechecking, is likely not a
                        #   justified additional complexity for an already
                        #   pretty complex "sanity-check".
                        alias ':'='false'   || exit 1
                        true()   { false; } || exit 1

                        # Output number of `CHECK` commands executed.
                        printf '%s\n' "${_ZLSH_TMP_CHECKSUM}"
                    }\
                ||  return 1
            )\
        &&  : CHECK subshell isolation                  \
        &&  ! [ "${_ZLSH_DONOTSETME+x}" ]                \
        &&  ! eval CHECK failed isolation >/dev/null 2>&1 \
        &&    true                                         \
        ;                                                   \
        then    : CHECK sanity                     \
            &&    [ "$_ZLSH_TMP" = 'OK' ]           \
            &&    [ "$_ZLSH_TMP" = "$_ZLSH_TMP_2" ]  \
            &&  : CHECK checksum                      \
            &&    [ "${_ZLSH_TMP_CHECKSUM--1}" -eq 57 ]\
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
            &&  return 0
            return 1
        elif :; then return 1
        else return 1
        fi
    return 1
}

# `zlsh_prtbl_check_eval "$command"`
#
# Checks (in a silent subshell) if a `$command` would eval successfully.
#
# Used to check non-portable capabilities, including non-portable syntax.
#
# Exit Status: non-zero on failure or no arguments.
#
# NOTE: External side-effects are invisible to subshell isolation and will
#       persist. The command (i.e. arguments to this function) should not have
#       any external side-effects.
#
zlash_prtbl_check_eval() { [ ${1+x} ] && (eval "$@") >/dev/null 2>&1; }

# `zlsh_prtbl_echo [arg ...]`
#
# Portable expected `echo` behavior, avoiding `echo` pitfalls.
#
# Exit Status: non-zero on failure.
#
# NOTE: This should NOT be used to transfer data, but to communicate something
#       to the user, where possibility of a corrupted message is preferable to
#       nothing, and retries or alternatives are either not possible or don't
#       make sense. `printf` write failure here will not short-circuit remaining
#       arguments write attempts, in case failure cause is transient.
#
zlash_prtbl_echo() {
    _ZLSH_TMP_STATUS=0 || return 1
    if [ ${1+x} ]; then
        for _ZLSH_TMP_PARAM; do
            printf '%s ' "$_ZLSH_TMP_PARAM" || _ZLSH_TMP_STATUS=1
        done
        _ZLSH_TMP_PARAM= || ZLSH_TMP_STATUS=1
    fi;
    printf '\n' || _ZLSH_TMP_STATUS=1
    return $_ZLSH_TMP_STATUS
}

# `_unsafe_zlsh_prtbl_var_copy` *src_varname* *dst_varname*
#
#     Copy value of `src_varname` variable into `dst_varname` variable, when
#     better means aren't available.
#
#     > $ src_varname='value'
#     > $ dst_varname=''
#     > $ _unsafe_zlsh_prtbl_var_copy src_varname dst_varname
#     > $ echo "$dst_varname"
#     > value
#
#     **CODE INJECTION** Vulnerabe! Users should never call this function.
#         Callers must either own or sanitize both arguments. Many shells will
#         expand arithmetic and/or array subscript contexts recursively!
#
_unsafe_zlsh_prtbl_var_copy() { eval "$2=\"\$$1\""; }

# `_unsafe_zlsh_prtbl_ref_deref` *nameref_varname* *varname*
#
#     Dereference `nameref_varname` as `varname`. For shells that are capable of
#     automatic namerefs, the `nameref_varname` variable must not be of an
#     automatic nameref type. (When sticking to POSIX syntax, they never are.)
#
#     > $ src_varname='value'
#     > $ nameref_varname='src_varname'
#     > $ varname=''
#     > $ _unsafe_zlsh_prtbl_ref_deref nameref_varname varname
#     > $ echo "$varname"
#     > value
#
_unsafe_zlsh_prtbl_ref_deref() {
    _unsafe_zlsh_prtbl_var_copy "$1" _ZLSH_TMP \
        && eval "$2=\"\$${_ZLSH_TMP}\""         \
        && _ZLSH_TMP=''  # `unset` is not guaranteed prior probing.
}

# `_zlsh_prtbl_str_eq` *str1* *str2*
#
#     Is `str1` equal `str2` alphanumerically?
#
#     > $ var='value'
#     > $ _zlsh_prtbl_str_eq "$var" 'value' && echo ok || echo FAILED
#     > ok
#
_zlsh_prtbl_str_eq() {
    # Using a marker `x` to guard against old shell expansion bugs.
    [ "x$1" = "x$2" ]
}

# `_unsafe_zlsh_prtbl_str_pat` *str* *pat*
#
#     Is `str` matching `pat` shell pattern?
#
#     > $ var='value'
#     > $ _unsafe_zlsh_prtbl_str_eq "$var" 'value' && echo ok || echo FAILED
#     > ok
#
_unsafe_zlsh_prtbl_str_pat() {
    case "$1" in
        $2) return 0;;
    esac
    return 1
}

# Even status negation (`!`) cannot be guaranteed prior probing. And a portable
# negating wrapper (a higher-order multivariadic function) cannot be defined
# before portable quoting is. But we do need a basic alternative for "is string
# not empty" to implement portable quoting functions.
_unsafe_zlsh_prtbl_str_neq() {
    if _unsafe_zlsh_prtbl_str_eq "$1" "$2"
    then
        return 1;
    else
        return 0;
    fi
}

_unsafe_zlsh_prtbl_str_npat() {
    if _unsafe_zlsh_prtbl_str_pat "$1" "$2"
    then
        return 1;
    else
        return 0;
    fi
}

# `_zlsh_prtbl_get_shqstr` *str*
#
#     Shell single-quote a `str` string into `REPLY` variable, which will
#     contain a shell-reusable single-quoted string suitable for `eval`.
#
#     Usable in absense of `${VAR@Q}`, `${(qq)VAR}`, `typeset -p VAR`, and
#     `print %q VAR` capabilities.
#
#     > $ string="it's a string"
#     > $ _zlsh_prtbl_get_shqstr "$string"
#     > $ echo "$REPLY"
#     > 'it'\''s a string'
#     > $ numargs() { echo $#; }
#     > $ numargs $REPLY; eval "numargs $REPLY"
#     > 3
#     > 1
#
_zlsh_prtbl_get_shqstr() {
    _ZLSH_TMP="$1"  # unquoted string
    _ZLSH_TMP_2=''    # single-quote-escaped string
    while _unsafe_zlsh_prtbl_str_neq "$_ZLSH_TMP" ''; do
        _ZLSH_TMP_3="${_ZLSH_TMP%${_ZLSH_TMP#?}}"  # first character
        _ZLSH_TMP="${_ZLSH_TMP#?}"                 # first character removed
        _unsafe_zlsh_prtbl_str_eq "$_ZLSH_TMP_3" \'  \
            && _ZLSH_TMP_2="${_ZLSH_TMP_2}'\''"       \
            || _ZLSH_TMP_2="${_ZLSH_TMP_2}$_ZLSH_TMP_3"
    done
    REPLY="'${_ZLSH_TMP_2}'"
    _ZLSH_TMP_2=''
    _ZLSH_TMP_3=''
}

_zlsh_init() {
    ZLASH_VERSION=0.1

#------------------------------------------------------------------------------
### 2.    CONFIGURATION OPTIONS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#### 2.1. General Configuration Options
#
    # Auto-update `SHELL` environment variable for interactive shells.
    #
    # Some systems, when a user launchs a shell that's different from the one
    # specified for them under `/etc/passwd` will change SHELL, while other
    # systems will not.
    #
    # Some tools use `SHELL` value to determine what completions to install,
    # resulting in what user may or may not be expecting. If you are using
    # multiple shells regularly, and want your "prefered" shell to be the
    # current one, setting this to "always" maybe helpful.
    #
    # A setting of `once` maybe helpful for situations where you run different
    # "main" session(s) of different types of shells, and want `SHELL` to not
    # change for other shell types launched from the "main" ones.
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
    : ${ZLASH_SHELL_UPDATE:='always'}
    export ZLASH_SHELL_UPDATE

    # Default indent level
    : ${ZLASH_INDENT:=4}

    # Do not clear these environment variables when performing environment
    # scrubbing by default. A string containing variable names separated by
    # spaces (` `).
    : ${ZLASH_PROTECTED__ZLASH_VARS:='HOME'}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#### 2.2. Optional External Tools
#
    # Optional Tools. A tool executable may have different names. Possibilities
    # are separated by colons (`:`).
    #
    # After initialization, each tool defined by the variable form of
    # `ZLASH_TOOL_*` will have a function defined in the form `_zlsh_cmd_*` with
    # a possible fallback if no executable was found. However, exit status
    # should always be checked, since if tool wasn't found, the function will
    # return 0. The search for a concrete executable and a possible fallback is
    # done lazily once.

    # Bat, if available, is used for syntax highlighting.
    : ${ZLASH_TOOL_BAT:='bat:batcat'}
    : ${ZLASH_TOOL_BAT__THEME:='gruvbox-dark'}

    # Augeas, if available, is used for structured manipulation of configuration
    # files in many arcane *nix formats.
    : ${ZLASH_TOOL_AUGTOOL:='augprint'}
    : ${ZLASH_TOOL_AUGMATCH:='augprint'}
    : ${ZLASH_TOOL_AUGPRINT:='augprint'}
    : ${ZLASH_TOOL_AUGPARSE:='augparse'}

    : ${ZLASH_TOOL_LSOF:='lsof'}

    # Pipe-Viewer
    : ${ZLASH_TOOL_PV:='pv'}

    : ${ZLASH_TOOL_OSQUERY:='osqueryi'}

    # Tree-sitter, if available, is used for ASTs of various languages it
    # supports, including Bash AST of Zlash-supported shell languages, for deep
    # dynamic introspection, generation, and even interpretation and relational
    # reasoning over dynamic code, or implementation "hole filling".
    : ${ZLASH_TOOL_TREESITTER:='tree-sitter:tree-sitter-cli'}

    # TODO
    #
    # Interactive interpreters/shells, if available, extending current shell
    # with a seamless sub-language with completions to interact with these
    # interpreters natively integrated:
    #   - IPython
    #   - Powershell
    #   ...

    # Standard tools expected by the GNU toolchain. See:
    # https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf.html#Particular-Programs
    #
    : ${ZLASH_TOOL_SED:='gsed:sed'}
    : ${ZLASH_TOOL_AWK:='gawk:mawk:nawk:awk'}
    : ${ZLASH_TOOL_GREP:='grep:ggrep'}
    : ${ZLASH_TOOL_EGREP:='egrep:gegrep'}
    : ${ZLASH_TOOL_FGREP:='fgrep:gfgrep'}
    : ${ZLASH_TOOL_MKDIR_P:='mkdir -p'}
    : ${ZLASH_TOOL_LN_S:='ln -s'}
    : ${ZLASH_TOOL_LEX:='flex:lex'}
    : ${ZLASH_TOOL_YACC:='bison -y:byacc:yacc'}
    : ${ZLASH_TOOL_RANLIB:='ranlib'}
    : ${ZLASH_TOOL_INSTALL:='install'}

    # More Standard Tools
    # TODO: 
    #

    # TODO
    # These tools, if available, will greatly speed up functionality that
    # uses the (soon) provided pure-shell implementation of miniKanren inference
    # engine:
    #   - SWI-Prolog
    #   - Clojure with core.logic
    #   - Z3 (and many other constraint solvers for cli later)
    #   - Sqlite

    # `true` or not.
    : ${ZLASH_IGNORE_ASSERTS:=false}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#### 2.3. Default Providers Configuration
#
# `Provider`s create objects.
#
# Every Zlash object will be getting a unique identifier constrained by
# valid variable name format.
#
    # General Identifier-generating counter and prefix.
    : ${_ZLASH_IGEN:=0}
    : ${_ZLASH_IGEN_PREFIX:='_0x'}

    # Reference Provider
    : ${_ZLASH_IGEN_REF:=0}
    : ${_ZLASH_IGEN_REF_PREFIX:='_0r'}

    # Base64 Provider
    : ${_ZLASH_IGEN_B64_PREFIX:='_0b'}
    : ${_ZLASH_IGEN_B64:=0}

    # Binary File Provider
    : ${_ZLASH_IGEN_BIN_PREFIX:='_0f'}
    : ${_ZLASH_IGEN_BIN:=0}

    # Logic Provider
    : ${_ZLASH_IGEN_LOG_PREFIX:='_'}
    : ${_ZLASH_IGEN_LOG:=1}

#------------------------------------------------------------------------------
###  3.    SHELL TYPE AND VERSION IDENTIFICATION
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
    # A word representing the type of the shell sourcing this, like `bash`,
    # `zsh`, `ksh93`, `dash`, etc...
    : ${ZLASH_SH_TYP:='unknown'}

    # An string representing major dot minor decimal numbered version of the
    # current shell, used by shell-agnosting shell type and version guarding.
    : ${ZLASH_SH_VER:=0.0}

    # An internal string representing the
    # fullpath of the current shell.
    : ${ZLASH_SH_EXE:="$0"}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#### 3.1.  Shell Capabilities Probes
#
# `zlash_cap_`-prefixed, all POSIX-compliant no-argument silent static
# evalualtion tests as non-exhaustive empirical witnesses of various shell
# capabilities. Style of these is very different form the main definitions,
# since this needs to be very defensive and portable.
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

##### 3.1.1. Probing Capabilities Private Interface
#

##### 3.1.1. Subshell Behavior Probes
#
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

##### 3.1.4. Namespaces

    zlash_cap_sh_ns_funvar_distinct() {
        zlash_captest_fixture
        ZLASH_CAPDSC='Namespace is not shared between functions and variables'

        (f () { :; }; f=; f)
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
            ZLASH_SH_TYP="zsh"
            eval 'ZLASH_SH_VER=${(j:.:)${${(s:.:)ZSH_VERSION}[@]:0:2}}' \
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
            ZLASH_SH_TYP="bash"
            ZLASH_SH_VER="${BASH_VERSINFO[0]}.${BASH_VERSINFO[1]}" \
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
            ZLASH_SH_TYP="ksh93"
            ZLASH_SH_VER="93.0"
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
            if ! _compat_test_version_majorminor "$ZLASH_SH_VER" -ge 5.2
            then
                builtin echo "WARNING:" "$ZLASH_SH_TYP" \
                        "$ZLASH_SH_VER" "is too low!" >/dev/stderr
            fi
        elif _compat_test_am_zsh; then
            if ! _compat_test_version_majorminor "$ZLASH_SH_VER" -ge 5.9
            then
                builtin echo "WARNING:" "$ZLASH_SH_TYP" \
                        "$ZLASH_SH_VER" "is too low!" >/dev/stderr
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

_zlsh_init
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
    _compat_test_am_bash && Test-VersionMajorMinor "$ZLASH_SH_VER" "$@"
}
Test_AmZsh() {
    _compat_test_am_zsh && Test-VersionMajorMinor "$ZLASH_SH_VER" "$@"
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
