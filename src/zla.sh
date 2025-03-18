# -*- mode: shell-script -*-
#
# Project: Zlash
# File:    zla.sh
# Summary: Zero-install Logical Adaptive Structured Shell
# Author:  Yevgeniy Grigoryev
# License: MIT License (https://opensource.org/licenses/MIT)
# Copyright (c) 2024-2025 Yevgeniy Grigoryev
#

# Disabling irrelevant `shellcheck` checks for the whole file:
#
# - Use foo "$@" if function's $1 should mean script's $1.
#   ( https://www.shellcheck.net/wiki/SC2119 )
#
# - Expressions don't expand in single quotes, use double quotes for that.
#   ( https://www.shellcheck.net/wiki/SC2016 )
#
# - foo appears unused. Verify it or export it.
#   ( https://www.shellcheck.net/wiki/SC2034 )
#
# shellcheck disable=SC2119,SC2016,SC2034
#

ZLASH_VERSION=0.2.0
ZLASH_DATE=2025-02-17

_zlsh_docs_init() {

    ZlashDoc about_Zlash 'Zero-install Logical Adaptive Structured Shell

    Add advanced capabilities to any POSIX-compatible shell by sourcing a single
    file.'
}

_ZLSH_DOC_ADD_1__about_Zlash='Project Goals

Launch any *POSIX-compatible*^1^ shell, including remote sessions. By sourcing
this file -- whether manually or auto-forwarded from another shell instance --
you unlock advanced interactive features. These include structured objects,
object pipelines, binary data processing, custom class definitions, advanced
parameters, automatic documentation, and more. Additionally, Zlash introduces
novel capabilities powered by an integrated relational solver, all tailored to
your environment without requiring installation, automatically optimized by
available, probed tools.

___

1. By a *POSIX-compatible* shell, we mean any shell that is able to interpret
   and execute a *POSIX-[compliant]{.underline}* shell script and interactive
   commands.
'
_ZLSH_DOC_ADD_2__about_Zlash='Project Motivation

The increasing popularity and proliferation of modern interactive shells^1^,
terminal emulators^2^, and a large number of new, high-quality CLI/TUI
tools/apps^3^ is a proof of a need that a GUI cannot fulfill generally. That
need is the expressive power and replicability that an interactive
command-line provides.

The *POSIX* standard, while foundational in unifying early computing
environments, faces limitations, in large part due to its success. Maintaining
compatibility with legacy systems and mitigating issues caused, to some
extent, by underspecification have hindered its evolution. As a result, modern
shells often trade *POSIX* compliance for advanced functionality.

However, the need for compatibility remains critical. Legacy systems still
require maintenance, and many production environments must restrict utilities.

While GNU Autoconf project (likely the best success story in portable complex
tool chain) addresses the portability problem by identifying the best
*POSIX-compatible* standard tools available in the environment/system, for its
shell functionality it sticks to the lowest common demomenator across all
historical possibilities, which is not a huge issue for it since Autoconf
is not designed for interactive ergonomics.

*Zlash* project scope is targeting modernization of *POSIX-compatible*
interactive shells. All of which are moderately-to-severely lacking when
compared to modern, but *POSIX* incompatible shells. We aim to address these
challenges by probing for and building on the features available to the current
shell.

___

1. [PowerShell](https://github.com/PowerShell/PowerShell),
   [Nushell](https://github.com/nushell/nushell),
   [Fish](https://github.com/fish-shell/fish-shell),
   [Xonsh](https://github.com/xonsh/xonsh),
   [Elvish](https://github.com/elves/elvish),
   [Murex](https://github.com/lmorg/murex), etc...

2. [Kitty](https://github.com/kovidgoyal/kitty),
   [Wezterm](https://github.com/wezterm/wezterm),
   [Ghostty](https://github.com/ghostty-org/ghostty),
   [Alacrity](https://github.com/alacritty/alacritty),
   [Warp](https://github.com/warpdotdev/Warp),
   [Hyper](https://github.com/vercel/hyper),
   [Extraterm](https://github.com/sedwards2009/extraterm),
   [Tabby](https://github.com/Eugeny/tabby) (formerly Terminus),
   [Contour](https://github.com/contour-terminal/contour),
   [Wave](https://github.com/wavetermdev/waveterm),
   [darktile](https://github.com/liamg/darktile),
   [rio](https://github.com/raphamorim/rio),
   [cool-retro-term](https://github.com/Swordfish90/cool-retro-term), etc...
   See: [awesome-terminals](https://github.com/cdleon/awesome-terminals)

3. See:
   [awesome-cli-apps-in-a-csv](https://github.com/toolleeo/awesome-cli-apps-in-a-csv)
   (Searching the page for "Rust" gives 50+ results.)
'

_ZLSH_DOC__about_Documentation='Zlash Documentation System

By default, documentation entries defined in Pandoc'\''s Markdown format, with most
extensions enabled. The documentation can be rendered to the terminal using
command:

> `help` [ *topic* ]

For example, the current topic can be rendered with `help about_Documentation`.

# Terminal Rendering

If [`pandoc`](https://pandoc.org/) and
[`groff`](https://www.gnu.org/software/groff/) are available, they are used to
render decumentation to the terminal beautifully typeset with justification,
hyphenation, hyperlinks, tables, and inline images.

If [`bat`](https://github.com/sharkdp/bat) is available, codeblocks will be
highlighted.

If [`plantuml.jar`](https://plantuml.com/) (and *Java*) is available, its
diagram codeblocks will be rendered as diagram images.

If `groff` is not available, but `pandoc` and `mandoc` are, they are used to
render documentation to terminal, which may not be justified nor hyphenated and
may lack features (e.g. italics).

If `pandoc` is available, but neither `groff` nor `mandoc`, `pandoc -t ansi`
will be used.

If `pandoc` is not available, current implementation will print the
documentation in the Markdown format. In the future, *Zlash* will have a
fallback Markdown processor.

The maximal width of rendered documentaiton (for the purpose of justification
filling and hyphenation) has a default of `100` to balance readability of
paragraphs with inline code. This is customizable by *Zlash* configuration
setting `GROTTY_LL` and does not apply to code blocks.

Additionally, If `groff` is available on *BSD-type* systems (e.g. *MacOS*),
*Zlash* can provide a `man` function that will use `groff` for rendering
system'\''s manpages instead of `mandoc` (used by `man` on *BSD-type* systems).

# Adding Documentation

Topics can have multiple entries, added using command:

> `zlash_doc_add` *topic* *text*

Here *text* is a string in Markdown format, where the first line is treated
specially (with leading whitespace removed):

- For the first entry of a *topic*, the first line represents a short one line
  blurb about the topic. The rest of the entry is treated as body of a top-level
  part with a `Description` heading.

- For additional entries of a *topic*, the first line is treated as a top-level
  heading.

This makes it easy to create simple documentation, extend existing documentation
based on capabilities discovered or extensions enabled, and recombine
crosscutting parts of topics into larger documents (e.g. including groups of
related functions with their short or long descriptions as definition lists of a
larger topic), with correct nesting.

# Implementation Details
## Internal Representation

Internally, documentation entries are stored in **_ZLSH_DOC__*TOPIC***
variables. Additional entries are stored in **_ZLSH_DOC_ADD_*n*__*TOPIC***
variables, where ***n*** is a sequentional decimal positive integer starting
from `1`.
'
_ZLSH_DOC_SEC3__about_Zlash='Project High-Level Plan

1. We start by relying on *hundreds* of cumulative man-years of experience
   distilled in GNU Autoconf Manual, Portable Shell Programming section[^1], and
   the POSIX Standard, Shell Utility section[^2]. We implementing a very basic
   portable functionality, just sufficient to start probing for successively
   more advanced features.

2. Then we probe current shell'\''s capabilities, expanding our functionality on
   them ONLY if it'\''s required for the following, more advanced probing.

3. After current shell'\''s capabilities have been sufficiently probed, we build
   on them successively more advanced functionality to reaching parity of
   features of every modern POSIX-compatible interactive shell (think ksh93 with
   zsh'\''s completions, bash with ksh93'\''s nested compound variables,
   discipline functions, automatic documentation, etc...), albeit using a bit
   more verbose, but cross-shell syntax.

4. Here we add some features of Powershell, namely advanced functions with
   validating and completing parameters, custom classes and objects with
   methods passed through the pipeline, etc...). Then we add and explore new
   features relational programming enables.

Initial targets for both, the host shell and the feature-parity shells of step
(3) are: Bash 5.2, Zsh 5.9, Ksh93u+m, and Dash 0.5.12 (if external tooling for
autocompletions is available, like `fzf`). Overtime, the current shell version
targets will be lowered.

[^1]: <https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/html_node/Portable-Shell.html>

[^2]: <https://pubs.opengroup.org/onlinepubs/9799919799/utilities/V3_chap02.html>
'
_ZLSH_DOC_SEC4__about_Zlash='Performance Expectations

When a Zlash command is executed for the first time, a best available
specialized implementation will be selected based on capabilities of the
shell, system, and availability of external tools. Capabiliteis are tested
only once per shell invocation (by default).

While Zlash will attempt best effort, the additional features it provides
above base shell capabilities should not be expected to be comparable in
performance to best industry implementations of equivalent functionality. And
if no optimizing capabilities are discovered by Zlash, the fallbacks may be
significantly slower.

Having said that, in some environments there will be no alternatives possible,
and having some of these features despite performance penalties may be
preferrable over not having them.
'
_ZLSH_DOC_SEC5__about_Zlash='Security Expectations

Every non-private function *Zlash* provides, including lower-level functions
(with `zlash_` prefix), perform input validation and escaping, if necessary.

Additionally, the goal is for every function to be automatically property-tested
with randomized input, and ultimately logic-validated (proven).
'
_ZLSH_DOC_SEC6__about_Zlash='Structured Data in *POSIX* `/bin/sh`?

To sketch, we start with four base types:

*Str*
  : String values or shell words

*Ref*
  : Namerefs (possibly shell-native), referencing other variables by their
    names.

*IxArr*
  : (shell-native or prefix-emulated) indexed arrays

*Assoc*
  : (shell-native or prefix-emulated) associative arrays

Each has `New-*` constructors, at least Local and Global variants, that can be
called with optional assignments, like so:

```bash
New-LocalStr myvarname "value"
```

This will have the effect of `myvarname` variable in current function scope
holding a value of something like `0x1f5`, which is unique ID of the object.
Commands like the following become available:

```bash
$myvarname.length
```

Which will execute a function `0x1f5.length`, created by the constructor, and
on completion, a variable `REPLY` is set to the shell-supported expansion like
`${#0x1f5}`, or appropriate fallback to external tool invocation or portable
implementation.

These "methods" can be getters, setters, pipers, showers, etc..., and behave
as expected when values of elements are of other object types, including the
Ref type.

Ksh93 adheres more strictly to POSIX function naming and doesn'\''t allow
characters like `.` in function names. However, Ksh93 has proper hierarchical
`namespace`s, `discipline` functions, and user-defined custom types with
methods, including for nested compount variables. For example, the following
is valid in `ksh93t+`:

```bash {.numberLines}
typeset -T StrT=(
    function length {
        REPLY=${#_}
    }
)
function New_Str {
    typeset -n var="$1"
    StrT ._0x1f5="$2"
    var=._0x1f5
}
New_Str VAR '\''12345'\''
$VAR.length
echo $REPLY

# STDOUT: 5
```

Custom object types can be derived from the four base ones either via
prototyping mechanism, or a more complex one, like Python'\''s metaclass
mechanism, including dynamic method resolution. # TODO

Object references are accounted (mechanisms varying widely depending on shell
capabilities) and object is recursivelty unset when refcount reaches zero.
'
_ZLSH_DOC_SEC7__about_Zlash='Binary Data in `/bin/sh`?

Most POSIX-compatible shells cannot store plain binary data in their variables
because they use C-strings internally, which are null (`\0`) terminated. So
the null (`\0`) character cannot exist in the string content, even when shell
is able to express it as a literal:

```bash
var=$'\''ab\0cd'\''
echo ${#var}

# STDOUT: 2
```

*Zsh* is an exception here. It even handles pattern matching over binary data:

```bash
[[ $var == *$'\''b\0ce'\'' ]] || { [[ $var == *$'\''b\0cd'\'' ]] && echo ok }

# STDOUT: ok
```

There are two workarounds, with very different semantics:

1. Shell variable semantic (i.e. global, local, subshell isolation):

    Work with Base64 encoded binary values. Since it'\''s a power of two base, bit
    manipulation is still easy.

2. Persistent (with cleanup) object IPC semantic:

    Use temporary files as binary scalar objects and temporary directories as
    hierarchical objects with methods as scripts:

    ```bash
    echo "$OBJ"
    # STDOUT: /mnt/ramdisk_zlsh_41369/
    $OBJ.mymethod arg1 arg2
    ```

    Actual implementation is more complex than this, since shells would clear
    non-exported names before executing the script, but user interface remains
    essentially the same.

    *Zlash* can create/reuse a ramdisk (or equivalent), depending on environment
    capabilities, with fallback utilizing `/tmp` or equivalent.

Complex objects could be moved between the two semantics, opening a
possibility for efficient coprocess shared complex objects. (where efficiency
is dependent on shell and system capabiliteis)
'
_ZLSH_DOC_SEC8__about_Zlash='Reserved Namespace

To facilitate prevention of naming collisions with user-definer or imported
functions or variables, the project reserves the following name prefixes.

- `ZLASH` is a reserved prefix for environment variables.

- `ZLASH`, `Zlash`, `zlash` are reserved name prefixes for shell functions and
  shell variables. `zlash` prefix is a lower-level interface than `Zlash`.

- `_ZLSH`, `_Zlsh`, `_zlsh`, and `_unsafe_zlsh` are reserved prefixes for
  shell private functions and shell private variables. `_unsafe_zlsh`-prefixed
  private functions arguments should be either owned or sanitized by callers.

- `_[1-9]` (default) followed by any number of `[0-9]` are not reserved, but
  set, dynamic logic variable identifiers. They are set to matched values by a
  solver, when solver is not provided with names for them. Zlash sets them
  only in contexts of solvers and solution callbacks. This convention is
  adopted from SWI-Prolog'\''s anonymous variables, where its chosen for
  readability of complex solution structures. (`_` part is customizable.)

- `_0` (default) name prefix is partially reserved by the format: `_0Mxxxxxx`,
  where `M` stands for an arbitrary "marker" character from the `[:alpha:]`
  set, followed by at least one or more of hexadecimal digits denoted by `x`
  (upper or lower case). These are reserved for unique identifier generation.
  The short form is chosen for a more humane representation in observable
  introspection. (`_0M` part is customizable.)

- If shell has `namespace`s, hiararchical (ksh93) or not, these prefixes are
  also reserved for the top-level `namespace`s. Which, in Ksh93 case, means
  additional initial dot (`.`).

- Additionally, a number of functions of the form *Verb_Noun* are provided, as
  defined in this file, and aliased to *Verb-Noun* form when underlying shell
  capability allows. These functions are the intended main interactive
  interface.
'
_ZLSH_DOC_SEC9__about_Zlash='Function Naming Conventions

Zlash adopts interactive function naming convention from Powershell for its
discoverability, where the format is Verb-Noun, with Verb restricted to approved
verbs^1^, with a few exceptions. Due portability, we adapt the convention to
Verb_Noun, provide an alias of the form Verb-Noun, and enable alias expansion in
scripts, if current shell has that option and it is disabled.

Non-interactive Zlash functions are not restricted to that form, but will have
the reserved prefix to avoid collisions. Effort is made to balance name lengths,
categories, and argument type and order hints. For example,
`_unsafe_zlsh_var_cp`:

- `_unsafe_zlsh_` means its arguments must be fully owned or sanitized by the
  caller, and the function is a private part of this project, not intended to be
  used by user;

- `_` means it'\''s part of the portable category, to be useable prior
  shell'\''s capabilities are probed;

- `var_copy` should hint that first argument is a source variable name, while
  second is a destination variable name.

___

1. [Approved Verbs For PowerShell Commands](https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-windows-powershell-commands)
   (Or run `Get-Verb` in Powershell, or `pwsh -nop -c get-verb` from other
   shell if Powershell is installed)
'


ZlashConfig__doc__='Zlash Configuration

Internal representation of a Zlash setting is a shell variable with the same
name, prefixed with `ZLASH_CFG_`. If a setting has a `-List` flag, and so is
multi-valued, and if the shell has no multi-value variable capabilitiy (indexed
and/or associative arrays), then ( # TODO: TBD: suffixes or delimiters ).

Each setting can have zero or more `-Pattern` and `-Antipattern` parameters. A
value is accepted only if it matches every pattern AND does not match any
antipattern. Additionally, every setting has an implicit antipattern
`` *[!\`"$]* `` for safety -- settings should be simple values.

Configuration will raise an error if execution environment has already a value
defined for a setting or if a value fails pattern/antipattern validation. So
reinitialization is idempotent -- configuration re-evaluation does not reset
settings to the defaults defined here.
'
ZlashConfig__doc_see__='
`ZlashSetting`, (TODO: `ZlashConfig_ToJson`)
'
ZlashConfig() {
    #________________________
    # General Zlash Settings
    #
    ZlashSetting           \
        -Name PATH_FALLBACK \
        -Doc 'fallback PATH

    When other means to locate an external tool fail, these paths are used as a
    last attempt.
    ' \
        -Values '/usr/gnu/bin' '/usr/ucb/bin' '/usr/local/sbin' \
                '/usr/local/bin' '/usr/sbin' '/usr/bin' '/sbin'  \
                '/bin' '/opt/ast/bin'

    ZlashSetting          \
        -Name ZLASH_STDERR \
        -Doc 'Zlash STDERR redirection

    A global control of `zlash_stderr` invocation redirection, which is used by
    Zlash to output its lower-level *STDERR* stream. This can be used for
    debugging to distinguish Zlash from non-Zlash *STDERR* streams.

    If this empty, or set to `&2`, then `zlash_stderr` function outputs to the
    *STDERR* (file descriptor `2`).

    Any file descriptor between `0` and `9` can be used as *n* in `&n`.

    Any writable path can be used as well. For the special case of a relative
    path of the form `&n`, `\&n` special form can be used to avoid using a file
    descriptor.
    ' \
        -Value  ''

    ZlashSetting                   \
        -Name ZLASH_SILENCED_STDOUT \
        -Doc 'Zlash silenced STDOUT redirection

    A global control of `zlash_null_stdstdout` invocation redirection, which
    is used by Zlash to silence *STDOUT* of a command. This can be used for
    debugging.

    If this empty, or set to `/dev/null`, then `zlash_null_stdout` function
    redirects *STDOUT* of a command it wraps to `/dev/null`.

    Any file descriptor between `0` and `9` can be used as *n* in `&n`.

    Any writable path can be used as well. For the special case of a relative
    path of the form `&n`, `\&n` special form can be used to avoid using a file
    descriptor.
    ' \
        -Value ''

    ZlashSetting                   \
        -Name ZLASH_SILENCED_STDERR \
        -Doc 'Zlash silenced STDERR redirection

    A global control of `zlash_null_stdsterr` invocation redirection, which
    is used by Zlash to silence *STDERR* of a command. This can be used for
    debugging.

    If this empty, or set to `/dev/null`, then `zlash_null_stderr` function
    redirects *STDOUT* of a command it wraps to `/dev/null`.

    Any file descriptor between `0` and `9` can be used as *n* in `&n`.

    Any writable path can be used as well. For the special case of a relative
    path of the form `&n`, `\&n` special form can be used to avoid using a file
    descriptor.
    ' \
        -Value ''

    ZlashSetting                 \
        -Name UPDATE_SHELL_VAR    \
        -Exported                  \
        -Pattern 'always|once|never'\
        -Doc 'update mode of SHELL env variable

    Some distributions have their login shells configured to update `SHELL`
    environment variable when a user launches a login shell that is different
    from the one specified for them under `/etc/passwd`, while other systems
    will not.

    Some tools use `SHELL` value (e.g. to determine what completions to
    install), resulting in what user may or may not be expecting. If you are
    using multiple (Zlash-compatible) shells regularly, and want your prefered
    shell to be the current one, setting this to "always" maybe helpful.

    A setting of `once` maybe helpful for situations where you run different
    "main" session(s) of different types of shells, and want `SHELL` to not
    change for other shell types launched from the "main" ones.
    ' \
        -Value always

    ZlashSetting                       \
        -Name INDENT_WIDTH              \
        -Antipattern '0*|*[![:digit:]]*' \
        -Doc 'indentation width

    Indentation width in (greater than zero) number of spaces.
    ' \
        -Value 4

    ZlashSetting                                      \
        -Name PROTECTED_VARS                           \
        -Antipattern '[!_[:alpha:]]*|*[!_[:alnum:]]*'   \
        -Doc 'variables Zlash should skip when scrubing' \
        -Values HOME

## Optional external tools that may be available on systems under possibly
## different names. Zlash will attempt to lazily resolve a tool's full path (if
## it isn't supplied as such) from a list of possible names.
##
## To tell Zlash to use a specific tool instead of trying to find it, use a
## fullpath single value, like so:
##
##     `ZlashSetting EXE_tool '/full path/exe'`
#
#     ZlashSetting -List EXE_BAT bat batcat -Description '
#     Bat, if available, is used for syntax highlighting.'

#     ZlashSetting EXE_BAT_SHELL_THEME gruvbox-dark -Description '
#     Bat theme for shell syntax.'

#     # Augeas, if available, is used for structured manipulation of config files.
#     ZlashSetting -List EXE_AUGTOOL  augtool
#     ZlashSetting -List EXE_AUGMATCH augmatch
#     ZlashSetting -List EXE_AUGPARSE augparse
#     ZlashSetting -List EXE_AUGPRINT augprint

#     ZlashSetting -List EXE_LSOF lsof

#     ZlashSetting -List EXE_OSQUERY osqueryi

#     #  Other Possibilities
#     #
#     # - gsed sed
#     # - gawk mawk nawk awk
#     # - grep ggrep
#     # - egrep gegrep
#     # - fgrep gfgrep
#     # - `mkdir -p`
#     # - `ln -s`
#     # - flex lex
#     # - `bison -y` byacc yacc
#     # - ranlib
#     # - install
#     #
#     # - Pipe-Viewer (vp)
#     # - Tree-sitter (tree-sitter tree-sitter-cli)
#     # - SQLite
#     # - Powershell
#     # - SWIPRolog
#     # - Python
#     # - IPython
#     # - uv ( https://github.com/astral-sh/uv )
#     # - Z3

# # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ####    2.3.        Default Providers Configuration
# #
# # `Provider`s create objects.
# #
# # Every Zlash object will be getting a unique identifier constrained by
# # valid variable name format.
# #
#     ZlashSetting IGEN 0 \
#         -Antipattern '*[![:digit:]]*' -Description '
#     General generated identifier counter.'

#     ZlashSetting IGEN_PFX _0x \
#         -Antipattern '[!_[:alpha:]]*|*[!_[:alnum:]]*' -Description '
#     General generated identifier prefix.'

}

#------------------------------------------------------------------------------
#               Ensure Minimal Functionality
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
# Before current shell capabilities have been probed, we need shell-portable
# basic functionality, assuming as few constructs and utilities as possible. The
# best references for this are:
#
# - GNU Autoconf Manual, Portable Shell Programming Section:
#   <https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/html_node/Portable-Shell.html>
#
# - POSIX Standard, Utilities Section, Shell Command Language Chapter:
#   <https://pubs.opengroup.org/onlinepubs/9799919799/utilities/V3_chap02.html>
#
# - Z-shell FAQ, Chapters 2 and 3:
#   <https://zsh.sourceforge.io/FAQ/zshfaq.html>
#
#      Zsh default functionality should be assumed as not POSIX-compatible,
#      necesitating only a subset of POSIX shell language that overlaps with
#      most Zsh compatibility modes.
#
# Literature for bonus points:
#
# - <https://mywiki.wooledge.org/CategoryShell>
#
# The functions listed in the following sub-sections after the Sanity Check are
# low-level *Zlash* functionality implementations specialized for current shell
# capabilities, and all have portable fall-back specializations.
#

################################################################################
#/ Sanity Check the underlying shell
#
#------------------------------------------------------------------------------
#, zlash_init_chk_sanity
#
_ZLSH_DOC_TOPIC__zlash_init_chk_sanity='shell sanity check

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
zlash_init_chk_sanity__doc_ext_1='Significant Differences

Significant deviations in default basic behavior, most modifiable via options,
nevertheless necesitating omission from the baseline, with workarounds and in
order of shell availability prevalence:

- *Bash* aliases are not expanded in non-interactive shell mode.

    `shopt -s expand_aliases` is needed in non-interactive mode.

- *Bash* fails to use termorary environment `var= cmd` for some builtins.

    `var= eval cmd` is a workaround.

- *Bash* `return` fails if not executing a function or script. This feature is
    commonly used in Bash to check if a script is being sourced or executed as
    a script. *Zsh* and *Ksh93* have more direct ways to test this, but *Dash*
    has no reliable means of such a test at all.

- *Zsh* unquoted parameter expansions are not word-split.

    `${=var}` expansion flag needs to be used.

- *Zsh* unquoted pattern fragments derived from parameter expansions (or
    command substitutions) are treated as if they were quoted -- expanded
    pattern metacharacters are not special.

    `${~var}` unquoted expansion flag needs to be used in pattern context for
    expansion'\''s pattern metacharacters to be treated as such.

- *Zsh* does not have `0`-prefixed octal literals, not even in arithmetic
    context. `0x`-prefixed hexadecimal literals are available in arithmetic
    context ( `$((...))` ), but not in numeric context,
    ( `[ ... -eq ... ]` ).

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

- *Dash* has no power operator in arithmetic context:
    `$((... ** ...))`.

- *Dash* has no sequence operator in arithmetic context:
    `$((... , ...))`.

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
zlash_init_chk_sanity() {
    if [ "${DEBUG-}" ]; then
        (   # Attempt to set execution trace and verbosity.
            eval 'set -vx || set -v -x || set -x || set -v' >/dev/null 2>&1 ||:
            _zlsh_init_chk_sanity
        ) && return 0
    else _zlsh_init_chk_sanity && return 0
    fi
    return 1
}
_zlsh_init_chk_sanity() {
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
        &&  : CHECK command substitution                  \
        &&    _ZLSH_TMP_CHECKSUM=$(_zlsh_init_chk_sanity_helper)\
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
        else return 1
        fi
    return 1
}
_zlsh_init_chk_sanity_helper() {
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

#------------------------------------------------------------------------------
#! Sanity check the underlying shell
#  avoiding as many features as possible before success, like negation (`!`),
#  `[` command, `{...}` command group, and redirection.
if   test "${ZLASH_INIT_CHK_ALL-}"    = 'SKIP'; then :
elif test "${_ZLSH_INIT_CHK_SANITY-}" =  'OK' ; then :
elif zlash_init_chk_sanity; then _ZLSH_INIT_CHK_SANITY='OK'
elif test "${DEBUG-}"; then false
else echo
    echo 'ERROR: FAILED Sanity Check!'
    echo '  Current shell is not POSIX-compatible.'
    echo '  For attempted execution trace, run:'
    echo
    echo '    DEBUG=1 zlash_init_chk_sanity'
    echo; false; fi

###############################################################################
#/ Raw Validators
#
_ZLSH_DOC_TOPIC__about_rawvalidators='about Zlash raw validators

Raw validators are not object-aware. They validate shell-native types, of which
only plain strings are portable.
' # TODO

# Raw validator validation. On failure, `_zlsh_chk_rawvalidators` variable will
# contain the name of the failed test.
_zlsh_chk_rawvalidators() {
    for _zlsh_chk_rawvalidators in\
        _zlsh_chk_is_digits        \
        _zlsh_chk_is_xdigits        \
        _zlsh_chk_is_vname_sfx       \
        _zlsh_chk_is_vname            \
        _zlsh_chk_is_fname_sfx         \
        _zlsh_chk_is_fname              \
        _zlsh_chk_var_is_set             \
        _zlsh_chk_var_is_noempty          \
        _zlsh_chk_var_match_pat            \
        _zlsh_chk_var_has_substr            \
        _zlsh_chk_var_has_pfx                \
        _zlsh_chk_var_has_sfx
    do $_zlsh_chk_rawvalidators || return 1; done &&\
    unset -v _zlsh_chk_rawvalidators; }

#------------------------------------------------------------------------------
#, zlash_is_digits
_ZLSH_DOC_TOPIC__zlash_is_digits='validation of one or more decimal digits

Succeeds if the supplied argument contains only decimal digits and is not empty.
'
_ZLSH_DOC__USAGE__zlash_is_digits='Usage

zlash_is_digits str
'
_ZLSH_DOC_PARAMS__zlash_is_digits='Parameters

1. *str*: a string needing validation
'
zlash_is_digits() {
    if [ $# -eq 1 ]; then _zlsh_is_digits "$1"
    else _zlsh_usage zlash_is_digits && return 64; fi; }
_zlsh_is_digits() {
    [ "${1:+x}" ] && case $1 in
        *[![:digit:]]*) return 1;;
        *) return 0; esac; }

_zlsh_chk_is_digits() {
    zlash_is_digits '0123456789' &&\
    for _zlsh_chk_is_digits in '-1' '0.1' 'a' ' 1' '1 ' ' ' ''; do
        ! zlash_is_digits "$_zlsh_chk_is_digits" || return 1; done &&\
    unset -v _zlsh_chk_is_digits; }

#------------------------------------------------------------------------------
#, zlash_is_xdigits
_ZLSH_DOC_TOPIC__zlash_is_digits='validation of one or more hexadecimal digits

Succeeds if the supplied argument contains only hexdecimal digits and is not
empty.
'
_ZLSH_DOC__USAGE__zlash_is_digits='Usage

zlash_is_xdigits str
'
_ZLSH_DOC_PARAMS__zlash_is_xdigits='Parameters

1. *str*: a string needing validation
'
zlash_is_xdigits() {
    if [ $# -eq 1 ]; then _zlsh_is_xdigits "$1"
    else _zlsh_usage zlash_is_xdigits && return 64; fi; }
_zlsh_is_xdigits() {
    [ "${1:+x}" ] && case $1 in
        *[![:xdigit:]]*) return 1;;
        *) return 0; esac; }

_zlsh_chk_is_xdigits() {
    zlash_is_xdigits '0123456789abcdefABCDEF' &&\
    for _zlsh_chk_is_xdigits in '-1' '0.1' 'g' 'G' ' 1' '1 ' ' ' ''; do
        ! zlash_is_xdigits "$_zlsh_chk_is_xdigits" || return 1; done &&\
    unset -v _zlsh_chk_is_xdigits; }

#------------------------------------------------------------------------------
#, zlash_is_vname_sfx
_ZLSH_DOC_TOPIC__zlash_is_vname_sfx='validation of a variable name suffix

Validates that a string is suitable to be used as a variable name suffix. That
is, only containing characters from the class `[_A-Za-z0-9]` under `LANG=C`.
'
_ZLSH_DOC_USAGE__zlash_is_vname_sfx='Usage

zlash_is_vname_sfx str
'
_ZLSH_DOC_PARAMS__zlash_is_vname_sfx='Parameters

1. *str*: a string needing validation
'
zlash_is_vname_sfx() {
    if [ $# -eq 1 ]; then _zlsh_is_vname_sfx "$1"
    else _zlsh_usage zlash_is_vname_sfx && return 64; fi; }
_zlsh_is_vname_sfx() {
    [ "${1:+x}" ] && case $1 in
        *[!_[:alnum:]]*) return 1;;
        *) return 0; esac; }

_zlsh_chk_is_vname_sfx() {
    zlash_is_vname_sfx '0O_' &&\
    for _zlsh_chk_is_vname_sfx in 'a b' 'a ' ' a' '$a' '\a' '"a"' "'a'" '`a`'
    do ! zlash_is_vname_sfx "$_zlsh_chk_is_vname_sfx" || return 1
    done && unset -v _zlsh_chk_is_vname_sfx; }

#------------------------------------------------------------------------------
#, zlash_is_vname
_ZLSH_DOC_TOPIC__zlash_is_vname='validation of a variable name

Validates that a string is suitable to be used as a variable name. That
is, only containing characters from the class `[_A-Za-z0-9]` under `LANG=C`,
with additional constraint on the first character not being numeric.
'
_ZLSH_DOC_USAGE__zlash_is_vname='Usage

zlash_is_vname str
'
_ZLSH_DOC_PARAMS__zlash_is_vname='Parameters

1. *str*: a string needing validation
'
zlash_is_vname() {
    if [ $# -eq 1 ]; then _zlsh_is_vname "$1"
    else _zlsh_usage zlash_is_vname && return 64; fi; }
_zlsh_is_vname() {
    [ "${1:+x}" ] && case $1 in
        [!_[:alpha:]]*|*[!_[:alnum:]]*) return 1;;
        *) return 0; esac; }

_zlsh_chk_is_vname() {
    zlash_is_vname '_0O' &&\
    for _zlsh_chk_is_vname in '0a' 'a b' 'a ' ' a' '$a' '\a' '"a"' "'a'" '`a`'
    do ! zlash_is_vname "$_zlsh_chk_is_vname" || return 1
    done && unset -v _zlsh_chk_is_vname; }

#------------------------------------------------------------------------------
#, zlash_is_fname
_ZLSH_DOC_TOPIC__zlash_is_fname='validation of a function name
'
_ZLSH_DOC_USAGE__zlash_is_fname='Usage

zlash_is_fname str
'
_ZLSH_DOC_PARAMS__zlash_is_fname='Parameters

1. *str*: a string needing validation
'
zlash_is_fname() {
    if [ $# -eq 1 ]; then _zlsh_is_fname "$1"
    else _zlsh_usage zlash_is_fname && return 64; fi; }
_zlsh_is_fname() {
    [ "${1:+x}" ] && case $1 in
        [!_[:alpha:]]*|*[!_[:alnum:]]*) return 1;;
        *) return 0; esac; }

_zlsh_chk_is_fname_sfx() {
    zlash_is_fname_sfx '0O_' &&\
    for _zlsh_chk_is_fname_stf in 'a b' 'a ' ' a' '$a' '\a' '"a"' "'a'" '`a`'
    do ! zlash_is_fname_sfx "$_zlsh_chk_is_fname_sfx" || return 1
    done && unset -v _zlsh_chk_is_fname_sfx; }

#------------------------------------------------------------------------------
#, zlash_is_fname_sfx
_ZLSH_DOC_TOPIC__zlash_is_fname_sfx='validation of a function name suffix
'
_ZLSH_DOC_USAGE__zlash_is_fname_sfx='Usage

zlash_is_fname_sfx str
'
_ZLSH_DOC_PARAMS__zlash_is_fname_sfx='Parameters

1. *str*: a string needing validation
'
zlash_is_fname_sfx() {
    if [ $# -eq 1 ]; then _zlsh_is_fname_sfx "$1"
    else _zlsh_usage zlash_is_fname_sfx && return 64; fi; }
_zlsh_is_fname_sfx() {
    [ "${1:+x}" ] && case $1 in
        *[!_[:alnum:]]*) return 1;;
        *) return 0; esac; }

_zlsh_chk_is_fname() {
    zlash_is_fname '_0O' &&\
    for _zlsh_chk_is_fname in '0a' 'a b' 'a ' ' a' '$a' '\a' '"a"' "'a'" '`a`'
    do ! zlash_is_fname "$_zlsh_chk_is_fname" || return 1
    done && unset -v _zlsh_chk_is_fname; }

#------------------------------------------------------------------------------
#, zlash_var_is_set
_ZLSH_DOC_TOPIC__zlash_var_is_set='validation of existence of a variable

Succeeds if a provided name is a defined variable, empty or not.

Useful for nameref ergonomics, when shell does not support them natively.
'
_ZLSH_DOC_USAGE__zlash_var_is_set='Usage

zlash_var_is_set vname
'
_ZLSH_DOC_PARAMS__zlash_var_is_set='Parameters

1. *vname*: a variable name
'
zlash_var_is_set() {
    if [ $# -eq 1 ] && _zlsh_is_vname "$1"; then _zlsh_var_is_set "$1"
    else _zlsh_usage zlash_var_is_set && return 64; fi; }
_zlsh_var_is_set() { eval '[ "${'"$1"'+x}" ]'; }

_zlsh_chk_var_is_set() {
    unset -v _ZLSH_DONOTSETME ||:
    ! zlash_var_is_set _ZLSH_DONOTSETME &&\
    _ZLSH_DONOTSETME=noempty  &&   zlash_var_is_set _ZLSH_DONOTSETME &&\
    unset -v _ZLSH_DONOTSETME && ! zlash_var_is_set _ZLSH_DONOTSETME &&\
    _ZLSH_DONOTSETME=         &&   zlash_var_is_set _ZLSH_DONOTSETME &&\
    unset -v _ZLSH_DONOTSETME; }

#------------------------------------------------------------------------------
#, zlash_var_is_noempty
_ZLSH_DOC_TOPIC__zlash_var_is_noempty='validation that a variable is not empty

Succeeds if a provided name is a defined variable with a non-empty value. This
implies `zlash_var_is_set`.

Useful for nameref ergonomics, when shell does not support them natively.
'
_ZLSH_DOC_USAGE__zlash_var_is_noempty='Usage

zlash_var_is_noempty vname
'
_ZLSH_DOC_PARAMS__zlash_var_is_noempty='Parameters

1. *vname*: a variable name
'
zlash_var_is_noempty() {
    if [ $# -eq 1 ] && _zlsh_is_vname "$1"; then _zlsh_var_is_noempty "$1"
    else _zlsh_usage zlash_var_is_noempty && return 64; fi; }
_zlsh_var_is_noempty() { eval '[ "${'"$1"':+x}" ]'; }

_zlsh_chk_var_is_noempty() {
    unset -v _ZLSH_DONOTSETME ||:
    ! zlash_var_is_noempty _ZLSH_DONOTSETME &&\
    _ZLSH_DONOTSETME=' '      &&   zlash_var_is_noempty _ZLSH_DONOTSETME &&\
    unset -v _ZLSH_DONOTSETME && ! zlash_var_is_noempty _ZLSH_DONOTSETME &&\
    _ZLSH_DONOTSETME=         && ! zlash_var_is_noempty _ZLSH_DONOTSETME &&\
    _ZLSH_DONOTSETME=''       && ! zlash_var_is_noempty _ZLSH_DONOTSETME &&\
    unset -v _ZLSH_DONOTSETME; }

#------------------------------------------------------------------------------
#, zlash_var_match_pat
_ZLSH_DOC_TOPIC__zlash_var_match_pat='
validate variable contents match a shell pattern

The pattern cannot contain references to positional parameters, e.g `$#`, `$@`,
`$1`, `$2`, etc.... They can be quoted within the pattern to match them
literally, or assigned to non-positional parameters to reference them in the
pattern.
'
_ZLSH_DOC_USAGE__zlash_var_match_pat='Usage

zlash_var_match_pat var pat
'
_ZLSH_DOC_PARAMS__zlash_var_match_pat='Parameters

1. *var*: a name of a variable containing a string
2. *pat*: a non-empty shell pattern as a string (should not contain non-literal
   references to positional parameters, e.g `$#`, `$@`, `$1`, `$2`, etc...)
'
# TODO: Write an Examples doc section.
zlash_var_match_pat() {
    if  case $# in
            2)  _zlsh_is_vname "$1" && _zlsh_var_is_set "$1" &&\
                [ "${2:+x}" ]       ;;
            *)  false; esac
    then _zlsh_var_match_pat "$1" "$2"
    else _zlsh_usage zlash_var_match_pat && return 64; fi; }
# TODO: The overhead of the (needed for portability) eval is inefficient for
#       small strings, so the implementation needs to be specialized after
#       dynamic pattern syntax has been probed.
[ "${DEBUG-}" ] &&\
_zlsh_var_match_pat() {  # DEBUG
    _zlsh_var_match_pat="case \$$1 in $2) return 0;; *) return 1; esac" &&\
    eval "$_zlsh_var_match_pat"; } ||\
_zlsh_var_match_pat() {
    eval "case \$$1 in $2) return 0;; *) return 1; esac"; }

_zlsh_chk_var_match_pat() {
    _zlsh_chk_var_match_pat_A='~/a bbcdd e'                    &&\
    _zlsh_chk_var_match_pat_B='~/a bb*dd e'                       \
    &&   zlash_var_match_pat _zlsh_chk_var_match_pat_A             \
                                '"$_zlsh_chk_var_match_pat_A"'      \
    && ! zlash_var_match_pat _zlsh_chk_var_match_pat_A               \
                                '"$_zlsh_chk_var_match_pat_B"'        \
    &&   zlash_var_match_pat _zlsh_chk_var_match_pat_A '\~/a\ bb*dd\ e'\
    &&   zlash_var_match_pat _zlsh_chk_var_match_pat_A '"~/a bb"*"dd e"'\
    && ! zlash_var_match_pat _zlsh_chk_var_match_pat_A '\~/a\ bb\*dd\ e' \
    &&   zlash_var_match_pat _zlsh_chk_var_match_pat_B '\~/a\ bb\*dd\ e'  \
    &&   zlash_var_match_pat _zlsh_chk_var_match_pat_B     '*"*"*'         \
    && ! zlash_var_match_pat _zlsh_chk_var_match_pat_B      '*f*'           \
    &&   zlash_var_match_pat _zlsh_chk_var_match_pat_B    '"~"*"*"*'         \
    && ! zlash_var_match_pat _zlsh_chk_var_match_pat_B   '"*~"*"*"*'          \
    &&   zlash_var_match_pat _zlsh_chk_var_match_pat_B     '*"*"*e'           \
    && ! zlash_var_match_pat _zlsh_chk_var_match_pat_B    '*"*"*"e*"'         \
    &&   zlash_var_match_pat _zlsh_chk_var_match_pat_B    '"~"*"*"*e'         \
    && ! zlash_var_match_pat _zlsh_chk_var_match_pat_B  '"~*"*"*"*"e*"'     &&\
    unset -v _zlsh_chk_var_match_pat_A _zlsh_chk_var_match_pat_B; }

#------------------------------------------------------------------------------
#, zlash_var_has_substr
_ZLSH_DOC_TOPIC__zlash_var_has_substr='
validate variable content contains a substring

Succeeds if a variable contains a string.
'
_ZLSH_DOC_USAGE__zlash_var_has_substr='Usage

zlash_var_has_substr var substr
'
_ZLSH_DOC_PARAMS__zlash_var_has_substr='Parameters

1. *var*: a name of a variable containing a string
2. *substr*: a non-empty substring to search for
'
zlash_var_has_substr() {
    if  case $# in
            2)  _zlsh_is_vname "$1" && _zlsh_var_is_set "$1" &&\
                [    "${2:+x}"    ] ;;
            *)  false; esac
    then _zlsh_var_has_substr "$1" "$2"
    else _zlsh_usage zlash_var_has_substr; return 64; fi; }
_zlsh_var_has_substr() {
    _zlsh_q "$2" && _zlsh_var_match_pat "$1" "*$zlash_q*"; }

_zlsh_chk_var_has_substr() {
    _zlsh_chk_var_has_substr='abc'                    &&\
    zlash_var_has_substr _zlsh_chk_var_has_substr b   && \
    ! zlash_var_has_substr _zlsh_chk_var_has_substr d &&  \
    unset -v _zlsh_chk_var_has_substr; }

#------------------------------------------------------------------------------
#, zlash_var_has_pfx
_ZLSH_DOC_TOPIC__zlash_var_has_pfx='
validate variable content has a prefix

Succeeds if a variable has a supplied prefix.
'
_ZLSH_DOC_USAGE__zlash_var_has_pfx='Usage

zlash_var_has_pfx var pfx
'
_ZLSH_DOC_PARAMS__zlash_var_has_pfx='Parameters

1. *var*: a name of a variable containing a string
2. *pfx*: a non-empty prefix string to match
'
zlash_var_has_pfx() {
    if  case $# in
            2)  _zlsh_is_vname "$1" && _zlsh_var_is_set "$1" &&\
                     [    "${2:+x}"    ] ;;
            *)  false; esac
    then _zlsh_var_has_pfx "$1" "$2"
    else _zlsh_usage zlash_var_has_pfx; return 64; fi; }
_zlsh_var_has_pfx() {
    _zlsh_q "$2" && _zlsh_var_match_pat "$1" "$zlash_q*"; }

_zlsh_chk_var_has_pfx() {
    _zlsh_chk_var_has_pfx='a b c'                    &&\
        zlash_var_has_pfx _zlsh_chk_var_has_pfx 'a ' && \
    !   zlash_var_has_pfx _zlsh_chk_var_has_pfx ' b' &&  \
    unset -v _zlsh_chk_var_has_pfx; }

#------------------------------------------------------------------------------
#, zlash_var_has_sfx
_ZLSH_DOC_TOPIC__zlash_var_has_sfx='
validate variable content has a suffix

Succeeds if a variable has a supplied suffix.
'
_ZLSH_DOC_USAGE__zlash_var_has_sfx='Usage

zlash_var_has_sfx var sfx
'
_ZLSH_DOC_PARAMS__zlash_var_has_sfx='Parameters

1. *var*: a name of a variable containing a string
2. *sfx*: a non-empty suffix string to match
'
zlash_var_has_sfx() {
    if  case $# in
            2)  _zlsh_is_vname "$1" && _zlsh_var_is_set "$1" &&\
                [    "${2:+x}"    ] ;;
            *)  false; esac
    then _zlsh_var_has_sfx "$1" "$2"
    else _zlsh_usage zlash_var_has_sfx; return 64; fi; }
_zlsh_var_has_sfx() {
    _zlsh_q "$2" && _zlsh_var_match_pat "$1" "*$zlash_q"; }

_zlsh_chk_var_has_sfx() {
    _zlsh_chk_var_has_sfx='a b c'                    &&\
        zlash_var_has_sfx _zlsh_chk_var_has_sfx ' c' && \
    !   zlash_var_has_sfx _zlsh_chk_var_has_sfx 'b ' &&  \
    unset -v _zlsh_chk_var_has_sfx; }

###############################################################################
#/ Shell Quoting
#
#------------------------------------------------------------------------------
#, zlash_q
_ZLSH_DOC_TOPIC__zlash_q='single-quote a string for shell eval

Single-quote a value to be reused by shell. The quoted string is stored in
`zlash_q` variable.

Optional second argument is a variable name the quoted string will be stored in.
If it is not provided, the result will be output to *STDOUT*.

On failure, `zlash_q` variable is undefined.

Used for disabling interpolation for `eval`.
'
_ZLSH_DOC_USAGE__zlash_q='USAGE
zlash_q str [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_q='Parameters

1. *str*: string to single-quote
2. *out_vname*: optional variable name where the single-quoted string should be
   stored, instead of output to *STDOUT*
'
zlash_q() {
    if  case $# in
            2) _zlsh_is_vname "$2";;
            1) true               ;;
            *) false; esac
    then _zlsh_q "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_q"
        else printf '%s\n' "$zlash_q"; fi
    else _zlsh_usage zlash_q && return 64; fi; }
_zlsh_q() {
    _zlsh_q_IN=$1 &&\
    _zlsh_q_HEAD= && \
    _zlsh_q_TAIL= &&  \
    zlash_q=\'    || return 1
    while [ "${_zlsh_q_IN:+x}" ]; do
        # If no single-quote, append and break.
        case $_zlsh_q_IN in
            *"'"*) :;;
            *) zlash_q=$zlash_q$_zlsh_q_IN || return 1; break;;
        esac
        # Chop-off head with first single-quote, append with append sequence.
        _zlsh_q_TAIL=${_zlsh_q_IN#*"'"}             &&\
        _zlsh_q_HEAD=${_zlsh_q_IN%%"$_zlsh_q_TAIL"} && \
        _zlsh_q_IN=$_zlsh_q_TAIL                    &&  \
        zlash_q="$zlash_q$_zlsh_q_HEAD\''"          || return 1
    done
    # Final closing single-quote, cleanup.
    zlash_q=$zlash_q\' &&\
    unset -v _zlsh_q_IN _zlsh_q_HEAD  _zlsh_q_TAIL; }

_zlsh_chk_q() {
    for _zlsh_chk_q in\
        '' ' ' 'a b' '$a' '`zlash_q`' '$(zlash_q)' '$((1 + 1))' '\$a'
    do zlash_q "$_zlsh_chk_q"   _zlsh_chk_q_2     &&\
        [      "$zlash_q" =   "$_zlsh_chk_q_2" ]  && \
        eval "[ $zlash_q  = \"\$_zlsh_chk_q\"  ]" || return 1
    done && unset -v _zlsh_chk_q _zlsh_chk_q_2; }

# TODO: Implement a zlash_str_repr that splits by unprintables, zlash_q
#       elements, and joins by zlash_qq of contiguous CC variables representing
#       the unprintables.

# TODO
zlash_var_q() {
    _zlsh_var_q "$1"
}
_zlsh_var_q() {
    eval "_zlsh_var_q=\$$1" && _zlsh_q "$_zlsh_var_q" && zlash_var_q=$zlash_q
}

#------------------------------------------------------------------------------
#, zlash_qq
_ZLSH_DOC_TOPIC__zlash_qq='double-quote a string for shell eval

Double-quote a value to be reused by shell. The quoted string is stored in
`zlash_qq` variable. Only back-slash (`\`) and double-quote (`"`) are escaped
with back-slashes. Dollar-sign (`$`) and back-tick (`` ` ``) are not escaped and
retain their shell-special meaning.

Optional second argument is a variable name the quoted string will be stored in.
If it is not provided, the result will be output to *STDOUT*.

On failure, `zlash_qq` variable is undefined.

Used for enabling interpolation for `eval`.
'
_ZLSH_DOC_USAGE__zlash_qq='Usage
zlash_qq str [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_qq='Parameters

1. *str*: string to double-quote
2. *out_vname*: optional variable name where the double-quoted string should be
   stored, instead of output to *STDOUT*
'
zlash_qq() {
    if   [ $# != 1 ] \
    && { [ $# != 2 ] || [ ${2:+x} != x ] || ! _zlsh_is_vname "$2"; }
    then
        zlash_usage zlash_qq
        return 64
    fi
    if _zlsh_qq "$@"
    then
        if [ $# = 2 ]
        then eval "$2=\$zlash_qq"
        else printf '%s\n' "$zlash_qq"
        fi
    else return 1
    fi
}
_zlsh_qq() {  # portable fallback.
    _zlsh_qq_IN=$1 &&\
    _zlsh_qq_HEAD= && \
    _zlsh_qq_TAIL= &&  \
    _zlsh_qq_CHAR= &&   \
    _zlsh_qq_TEMP= &&    \
    zlash_qq=\"    || return 1
    while [ ${_zlsh_qq_IN:+x} ]; do
        # If no double-quote or back-slash, append and break.
        case $1 in
            *[\\\"]*) :;;
            *) zlash_qq=$zlash_qq$_zlsh_qq_IN || return 1; break;;
        esac
        # Chop-off head with first double-quote or back-slash, append escaped.
        _zlsh_qq_TAIL=${_zlsh_qq_IN#*[\\\"]}             &&\
        _zlsh_qq_TEMP=${_zlsh_qq_IN%%"$_zlsh_qq_TAIL"}   && \
        _zlsh_qq_HEAD=${_zlsh_qq_TEMP%?}                 &&  \
        _zlsh_qq_CHAR=${_zlsh_qq_TEMP##"$_zlsh_qq_HEAD"} &&   \
        _zlsh_qq_IN=$_zlsh_qq_TAIL                       &&    \
        zlash_qq=$zlash_qq$_zlsh_qq_HEAD\\$_zlsh_qq_CHAR || return 1
    done
    # Final closing double-quote, cleanup.
    zlash_qq=$zlash_qq\" &&\
    unset -v _zlsh_qq_IN _zlsh_qq_HEAD _zlsh_qq_TAIL _zlsh_qq_CHAR _zlsh_qq_TEMP
}

#------------------------------------------------------------------------------
#! Check raw validators
if [ "${ZLASH_INIT_CHK_ALL-}" != 'SKIP' ] && ! _zlsh_chk_rawvalidators; then
    printf '%s\n' "ERROR in init check: $_zlsh_chk_rawvalidators" >&2 &&\
    false; fi

###############################################################################
#/ Positive-Negative Counters Implementation
#
# Our first object-like primitive, with portable fallback implementation having
# state in two variables per "object":
#
#   - _ZLSH_PNCTR_P_<name> positive decimal integer of increments
#   - _ZLSH_PNCTR_N_<name> positive decimal integer of decrements
#
_ZLSH_DOC_TOPIC__about_pncounters='about Zlash PN-counters
' # TODO

_zlsh_chk_pncounters() {
    # CN :   current   number of PN-counters at the start of the check
    # CR : constructed number of PN-counters at the start of the check
    # CN2:   current   number of PN-counters
    # CR2: constructed number of PN-counters
    #  V :             value  of the PN-counter
    #  P :      positive part of the PN-counter value
    #  N :      negative part of the PN-counter value
    zlash_metric_pncounters_gauge           _zlsh_chk_pncounters_CN &&\
    zlash_metric_pncounters_created_counter _zlsh_chk_pncounters_CR    \
    &&   _zlsh_chk_pncounters_metrics_helper 0 0\
    && ! zlash_is_pncounter _zlsh_chk_pncounters \
    &&   zlash_mk_pncounter _zlsh_chk_pncounters  \
    &&   zlash_is_pncounter _zlsh_chk_pncounters   \
    &&   _zlsh_chk_pncounters_metrics_helper 1 1    \
    &&   _zlsh_chk_pncounters_helper  0 0 0          \
    &&   zlash_pncounter_incr _zlsh_chk_pncounters\
    &&   _zlsh_chk_pncounters_helper  1 1 0        \
    &&   zlash_pncounter_incr _zlsh_chk_pncounters 3\
    &&   _zlsh_chk_pncounters_helper  4 4 0          \
    &&   zlash_pncounter_decr _zlsh_chk_pncounters    \
    &&   _zlsh_chk_pncounters_helper  3 4 1            \
    &&   zlash_pncounter_decr _zlsh_chk_pncounters 5    \
    &&   _zlsh_chk_pncounters_helper -2 4 6              \
    && ! zlash_mk_pncounter _zlsh_chk_pncounters 2>/dev/null\
    &&   _zlsh_chk_pncounters_helper -2 4 6                  \
    &&   _zlsh_chk_pncounters_metrics_helper 1 1              \
    &&   zlash_rm_pncounter _zlsh_chk_pncounters \
    && ! zlash_is_pncounter _zlsh_chk_pncounters  \
    &&   _zlsh_chk_pncounters_metrics_helper 0 1 &&\
    unset -v    _zlsh_chk_pncounters_CN  _zlsh_chk_pncounters_CR\
                _zlsh_chk_pncounters_CN2 _zlsh_chk_pncounters_CR2\
        _zlsh_chk_pncounters_V _zlsh_chk_pncounters_P _zlsh_chk_pncounters_N; }
_zlsh_chk_pncounters_helper() {
    zlash_pncounter_val _zlsh_chk_pncounters _zlsh_chk_pncounters_V &&\
    [ "$_zlsh_chk_pncounters_V"  -eq "$1" ]                         && \
    [     "$zlash_pncounter_val" -eq "$1" ]                         &&  \
    zlash_pncounter_p   _zlsh_chk_pncounters _zlsh_chk_pncounters_P &&\
    [ "$_zlsh_chk_pncounters_P"  -eq "$2" ]                         && \
    [      "$zlash_pncounter_p"  -eq "$2" ]                         &&  \
    zlash_pncounter_n   _zlsh_chk_pncounters _zlsh_chk_pncounters_N &&\
    [ "$_zlsh_chk_pncounters_N"  -eq "$3" ]                         && \
    [      "$zlash_pncounter_n"  -eq "$3" ]; }
_zlsh_chk_pncounters_metrics_helper() {
    zlash_metric_pncounters_gauge           _zlsh_chk_pncounters_CN2   &&\
    zlash_metric_pncounters_created_counter _zlsh_chk_pncounters_CR2      \
    && [ "$zlash_metric_pncounters_gauge" -eq "$_zlsh_chk_pncounters_CN2" ]\
    && [ "$zlash_metric_pncounters_gauge"        \
        -eq $((_zlsh_chk_pncounters_CN + $1)) ]   \
    && [ "$zlash_metric_pncounters_created_counter"\
        -eq "$_zlsh_chk_pncounters_CR2"       ]     \
    && [ "$zlash_metric_pncounters_created_counter"  \
        -eq $((_zlsh_chk_pncounters_CR + $2)) ]; }

#------------------------------------------------------------------------------
#, zlash_ensure_pncounter
_ZLSH_DOC_TOPIC__zlash_ensure_pncounter='ensure a PN-counter

Checks that a PN-counter by a given name exists. If not, creates it, with
optional parameters.
'
_ZLSH_DOC_USAGE__zlash_ensure_pncounter='Usage

zlash_ensure_pncounter name [ini_incr [ini_decr]]
'
_ZLSH_DOC_PARAMS__zlash_ensure_pncounter='Parameters

1. *name*: a global PN-counter identifier to ensure
2. *ini_incr*: an optional initial decimal integer of increments (default: 0)
3. *ini_decr*: an optional initial decimal integer of decrements (default: 0)
'
zlash_ensure_pncounter() {
    if [ $# -gt 0 ] && _zlsh_is_vname "$1"
    then _zlsh_ensure_pncounter "$@"
    else _zlsh_usage zlash_metric_rawstacks_gauge && return 64; fi; }
_zlsh_ensure_pncounter() {
    _zlsh_is_pncounter "$1" || _zlsh_mk_pncounter "$@"; }

#------------------------------------------------------------------------------
#, zlash_mk_pncounter
_ZLSH_DOC_TOPIC__zlash_mk_pncounter='create a Positive-Negative counter

A lower-level function creating a new global PN-counter by name. PN-counter
names have their own global namespace, so they will not clash with other types
of names, but should still be prefixed appropriately to not clash with other
PN-counters.
'
_ZLSH_DOC_USAGE__zlash_mk_pncounter='Usage

zlash_mk_pncounter name [ini_incr [ini_decr]]
'
_ZLSH_DOC_PARAMS__zlash_mk_pncounter='Parameters

1. *name*: a global identifier for the new PN-counter
2. *ini_incr*: an optional initial decimal integer of increments (default: 0)
3. *ini_decr*: an optional initial decimal integer of decrements (default: 0)
'
zlash_m_pancounter() {
    if  case $# in
            3)  _zlsh_is_vname_sfx "$1" &&\
                _zlsh_is_digits    "$2" && \
                _zlsh_is_digits    "$3" ;;
            2)  _zlsh_is_vname_sfx "$1" &&\
                _zlsh_is_digits    "$2" ;;
            1)  _zlsh_is_vname_sfx "$1" ;;
            *)  false; esac
    then if _zlsh_is_pncounter "$1"; then
            printf '%s\n' "ERROR creating PN-counter: '$1' already exists" >&2
            return 1
        else _zlsh_mk_pncounter "$1" "${2-0}" "${3-0}"; fi
    else _zlsh_usage zlash_mk_pncounter && return 64; fi; }
_zlsh_mk_pncounter() {
    : $((_ZLSH_PNCTR_P_$1 = ${2-0})) $((_ZLSH_PNCTR_N_$1 = ${3-0})) &&\
    _zlsh_pncounter_incr _ZLSH_LCYC_PNCTR; }

#------------------------------------------------------------------------------
#, zlash_is_pncounter
_ZLSH_DOC_TOPIC__zlash_is_pncounter='check if name is for an existing PN-counter
'
_ZLSH_DOC_USAGE__zlash_is_pncounter='Usage

zlash_is_pncounter name
'
_ZLSH_DOC_PARAMS__zlash_is_pncounter='Parameters

1. *name*: a global identifier for an existing PN-counter
'
zlash_is_pncounter() {
    if  case $# in
            1) _zlsh_is_vname_sfx "$1" ;;
            *) false; esac
    then _zlsh_is_pncounter "$1"
    else _zlsh_usage zlash_is_pncounter && return 64; fi; }
_zlsh_is_pncounter() { eval "[ \"\${_ZLSH_PNCTR_P_$1:+x}\" ]"; }

#------------------------------------------------------------------------------
#, zlash_rm_pncounter
_ZLSH_DOC_TOPIC__zlash_rm_pncounter='destroy a PN-counter by name
'
_ZLSH_DOC_USAGE__zlash_rm_pncounter='Usage

zlash_rm_pncounter name
'
_ZLSH_DOC_PARAMS__zlash_rm_pncounter='Parameters

1. *name*: a global identifier for an existing PN-counter
'
zlash_rm_pncounter() {
    if  case $# in
            1) _zlsh_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" ;;
            *) false; esac
    then _zlsh_rm_pncounter "$1"
    else _zlsh_usage zlash_rm_pncounter && return 64; fi; }
_zlsh_rm_pncounter() {
    unset -v "_ZLSH_PNCTR_P_$1" "_ZLSH_PNCTR_N_$1" &&\
    _zlsh_pncounter_decr _ZLSH_LCYC_PNCTR; }

#------------------------------------------------------------------------------
#, zlash_pncounter_incr
_ZLSH_DOC_TOPIC__zlash_pncounter_incr='increment a PN-counter by name

Increment a PN-Counter by name. Optional argument is number of times to
increment.
'
_ZLSH_DOC_USAGE__zlash_pncounter_incr='Usage

zlash_pncounter_incr name [n]
'
_ZLSH_DOC_PARAMS__zlash_pncounter_incr='Parameters

1. *name*: a global identifier for an existing PN-counter
2. *n*: an optional positive decimal integer times to increment (default: 1)
'
zlash_pncounter_incr() {
    if  case $# in
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" &&
                _zlsh_is_digits    "$2" ;;
            1)  _zlsh_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" ;;
            *)  false; esac
    then _zlsh_pncounter_incr "$1" "${2-1}"
    else _zlsh_usage zlash_pncounter_incr && return 64; fi; }
_zlsh_pncounter_incr() { : $((_ZLSH_PNCTR_P_$1 += ${2-1})); }

#------------------------------------------------------------------------------
#, zlash_pncounter_decr
_ZLSH_DOC_TOPIC__zlash_pncounter_decr='decrement a PN-counter by name

Decrement a PN-Counter by name. Optional argument is number of times to
decrement.
'
_ZLSH_DOC_USAGE__zlash_pncounter_decr='Usage

zlash_pncounter_decr name [n]
'
_ZLSH_DOC_PARAMS__zlash_pncounter_decr='Parameters

1. *name*: a global identifier for an existing PN-counter
2. *n*: an optional positive decimal integer times to decrement (default: 1)
'
zlash_pncounter_decr() {
    if  case $# in
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" &&\
                _zlsh_is_digits    "$2" ;;
            1)  _zlsh_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" ;;
            *)  false; esac
    then _zlsh_pncounter_decr "$1" "${2-1}"
    else _zlsh_usage zlash_pncounter_decr && return 64; fi; }
_zlsh_pncounter_decr() { : $((_ZLSH_PNCTR_N_$1 += ${2-1})); }

#------------------------------------------------------------------------------
#, zlash_pncounter_val
_ZLSH_DOC_TOPIC__zlash_pncounter_val='get a PN-counter value

On success, stores the counter'\''s value in the `zlash_pncounter_val` variable.
'
_ZLSH_DOC_USAGE__zlash_pncounter_val='Usage

zlash_pncounter_val name [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_pncounter_val='Parameters

1. *name*: a global identifier for an existing PN-counter
2. *out_vname*: an optional variable name to store result instead of outputing
   it to *STDOUT*
'
zlash_pncounter_val() {
    if  case $# in
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" &&\
                _zlsh_is_vname     "$2" ;;
            1)  _zlsh_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" ;;
            *)  false; esac
    then _zlsh_pncounter_val "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_pncounter_val"
        else printf '%s\n' "$zlash_pncounter_val"; fi
    else _zlsh_usage zlash_pncounter_val && return 64; fi; }
_zlsh_pncounter_val() {
    zlash_pncounter_val=$((_ZLSH_PNCTR_P_$1 - _ZLSH_PNCTR_N_$1));
    #nocomment highlighting-helper ""
}

#------------------------------------------------------------------------------
#, zlash_pncounter_n
_ZLSH_DOC_TOPIC__zlash_pncounter_p='get PN-Counter P-value

On success, stores the positive part of the Positive-Negative Counter in the
`zlash_pncounter_p` variable.
'
_ZLSH_DOC_USAGE__zlash_pncounter_p='Usage

zlash_pncounter_p name [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_pncounter_p='Parameters

1. *name*: a global identifier for an existing PN-counter
2. *out_vname*: an optional variable name to store result instead of outputing
   it to *STDOUT*
'
zlash_pncounter_p() {
    if  case $# in
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" &&\
                _zlsh_is_vname     "$2" ;;
            1)  _zlsh_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" ;;
            *)  false; esac
    then _zlsh_pncounter_p "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_pncounter_p"
        else printf '%s\n' "$zlash_pncounter_p"; fi
    else _zlsh_usage zlash_pncounter_p && return 64; fi; }
_zlsh_pncounter_p() { zlash_pncounter_p=$((_ZLSH_PNCTR_P_$1)); }

#------------------------------------------------------------------------------
#, zlash_pncounter_n
_ZLSH_DOC_TOPIC__zlash_pncounter_n='get PN-Counter N-value

On success, stores the negative part of the Positive-Negative Counter in the
`zlash_pncounter_n` variable.
'
_ZLSH_DOC_USAGE__zlash_pncounter_n='Usage

zlash_pncounter_n name [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_pncounter_n='Parameters

1. *name*: a global identifier for an existing PN-counter
2. *out_vname*: an optional variable name to store result instead of outputing
   it to *STDOUT*
'
zlash_pncounter_n() {
    if  case $# in
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" &&\
                _zlsh_is_vname     "$2" ;;
            1)  _zlsh_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" ;;
            *)  false; esac
    then _zlsh_pncounter_n "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_pncounter_n"
        else printf '%s\n' "$zlash_pncounter_n"; fi
    else _zlsh_usage zlash_pncounter_n && return 64; fi; }
_zlsh_pncounter_n() { zlash_pncounter_n=$((_ZLSH_PNCTR_N_$1)); }

#------------------------------------------------------------------------------
#, zlash_pncounter_pix
_ZLSH_DOC_TOPIC__zlash_pncounter_pix='get PN-counter positive index hexadecimal

P-value (the positive part of the PN-counter) can be thought of as increment
index.

The result of this function can be used directly as a (more compact than a
decimal integer) key in a mapping, e.g. for unique identifier generation.
'
_ZLSH_DOC_USAGE__zlash_pncounter_pix='Usage

zlash_pncounter_pix name [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_pncounter_pix='Parameters

1. *name*: a global identifier for an existing PN-counter
2. *out_vname*: an optional variable name to store result instead of outputing
   it to *STDOUT*
'
zlash_pncounter_pix() {
    if  case $# in
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" &&\
                _zlsh_is_vname     "$2" ;;
            1)  _zlsh_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" ;;
            *)  false; esac
    then _zlsh_pncounter_pix "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_pncounter_pix"
        else printf '%s\n' "$zlash_pncounter_pix"; fi
    else _zlsh_usage zlash_pncounter_pix && return 64; fi; }
_zlsh_pncounter_pix() {
    _zlsh_deci2hexi $((_ZLSH_PNCTR_P_$1)) &&\
    zlash_pncounter_pix=$zlash_deci2hexi; }

#------------------------------------------------------------------------------
#, zlash_pncounter_tix
_ZLSH_DOC_TOPIC__zlash_pncounter_tix='get PN-counter ticks index hexadecimal

P+N value (the positive and negative parts sum of the PN-counter) can be thought
of as change index, or ticks (increments and decrements).

The result of this function can be used directly as a (more compact than a
decimal integer) key in a mapping, e.g. for identifying sections of balanced
nestings, during parsing or composition.
'
_ZLSH_DOC_USAGE__zlash_pncounter_tix='Usage

zlash_pncounter_tix name [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_pncounter_tix='Parameters

1. *name*: a global identifier for an existing PN-counter
2. *out_vname*: an optional variable name to store result instead of outputing
   it to *STDOUT*
'
zlash_pncounter_tix() {
    if  case $# in
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" &&\
                _zlsh_is_vname     "$2" ;;
            1)  _zlsh_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" ;;
            *)  false; esac
    then _zlsh_pncounter_tix "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_pncounter_tix"
        else printf '%s\n' "$zlash_pncounter_tix"; fi
    else _zlsh_usage zlash_pncounter_tix && return 64; fi; }
_zlsh_pncounter_tix() {
    _zlsh_deci2hexi $((_ZLSH_PNCTR_P_$1 + _ZLSH_PNCTR_N_$1)) &&\
    zlash_pncounter_tix=$zlash_deci2hexi; }

#------------------------------------------------------------------------------
#, zlash_pncounter_repr
_ZLSH_DOC_TOPIC__zlash_pncounter_repr='get a representation of a PN-counter

Output a represenation of the Positive-Negative counter, safe to be evaluated to
reconstruct the PN-counter.
'
_ZLSH_DOC_USAGE__zlash_pncounter_repr='Usage

zlash_pncounter_repr name [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_pncounter_repr='Parameters

1. *name*: a global PN-counter identifier
2. *out_vname*: optional variable name to store the representation in, instead
   of printing it to *STDOUT*
'
zlash_pncounter_repr() {
    if  case $# in
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" &&\
                _zlsh_is_vname     "$2" ;;
            1)  _zlsh_is_vname_sfx "$1" && _zlsh_is_pncounter "$1" ;;
            *)  false; esac
    then _zlsh_pncounter_repr "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_pncounter_repr"
        else printf '%s\n' "$zlash_pncounter_repr"; fi
    else _zlsh_usage zlash_pncounter_repr && return 64; fi; }
_zlsh_pncounter_repr() {
    zlash_pncounter_repr="zlash_mk_pncounter $1 $((_ZLSH_PNCTR_P_$1))" &&\
    zlash_pncounter_repr=$zlash_pncounter_repr\ $((_ZLSH_PNCTR_N_$1)); }

#------------------------------------------------------------------------------
#, zlash_metric_pncounters_gauge
_ZLSH_DOC_TOPIC__zlash_metric_pncounters_gauge='PN-counters gauge

On success, a gauge measurement of current number of Positive-Negative counters
is observed and stored in the `zlash_metric_pncounters_gauge` variable.
'
_ZLSH_DOC_USAGE__zlash_metric_pncounters_gauge='Usage

zlash_metric_pncounters_gauge [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_metric_pncounters_gauge='Parameters

1. *out_vname*: an optional variable name to store the observation in, instead
   of printing to *STDOUT*
'
zlash_metric_pncounters_gauge() {
    if  case $# in
            1) _zlsh_is_vname "$1" ;;
            0) true                ;;
            *) false; esac
    then _zlsh_metric_pncounters_gauge && if [ $# -eq 1 ]
        then   eval    "$1=\$zlash_metric_pncounters_gauge"
        else printf '%s\n' "$zlash_metric_pncounters_gauge"; fi
    else _zlsh_usage zlash_metric_pncounters_gauge && return 64; fi; }
_zlsh_metric_pncounters_gauge() {
    _zlsh_pncounter_val _ZLSH_LCYC_PNCTR &&\
    zlash_metric_pncounters_gauge=$zlash_pncounter_val; }

#------------------------------------------------------------------------------
#, zlash_metric_pncounters_created_counter
_ZLSH_DOC_TOPIC__zlash_metric_pncounters_created_counter='
PN-counters constructed counter

On success, a counter measurement of number of Positive-Negative counters
constructed is observed and stored in the
`zlash_metric_pncounters_created_counter` variable.
'
_ZLSH_DOC_USAGE__zlash_metric_pncounters_created_counter='Usage

zlash_metric_pncounters_created_counter [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_metric_pncounters_created_counter='Parameters

1. *out_vname*: an optional variable name to store the observation in, instead
   of printing to *STDOUT*
'
zlash_metric_pncounters_created_counter() {
    if  case $# in
            1) _zlsh_is_vname "$1" ;;
            0) true                ;;
            *) false; esac
    then _zlsh_metric_pncounters_created_counter && if [ $# -eq 1 ]
        then   eval    "$1=\$zlash_metric_pncounters_created_counter"
        else printf '%s\n' "$zlash_metric_pncounters_created_counter"; fi
    else _zlsh_usage zlash_metric_pncounters_created_counter && return 64; fi
}
_zlsh_metric_pncounters_created_counter() {
    _zlsh_pncounter_p _ZLSH_LCYC_PNCTR &&\
    zlash_metric_pncounters_created_counter=$zlash_pncounter_p; }

#------------------------------------------------------------------------------
#! A bootstrapped special PN-counter for PN-counter metrics
#  This one can't be ensured without bootstrapping, since the constructor is
#  using it.
if ! _zlsh_is_pncounter _ZLSH_LCYC_PNCTR; then
    _ZLSH_PNCTR_P__ZLSH_LCYC_PNCTR=1
    _ZLSH_PNCTR_N__ZLSH_LCYC_PNCTR=0; fi

#------------------------------------------------------------------------------
#! Check PN-counters
if [ "${ZLASH_INIT_CHK_ALL-}" != 'SKIP' ] && ! _zlsh_chk_pncounters; then
    printf '%s\n' "ERROR in init check: _zlsh_chk_pncounters" >&2 &&\
    false; fi

###############################################################################
#/ Lower-Level Rawstack Implementation
#
_ZLSH_DOC_TOPIC__about_rawstacks='about Zlash lower-level rawstacks

Rawstacks are not object-aware. Their elements are plain strings only, and their
names are plain identifier suffixes. Rawstacks should not be used to build
nested structures directly, as `zlash_rawstack_repr` will fail to represent
referenced objects.
' # TODO

#------------------------------------------------------------------------------
#, zlash_metric_rawstacks_gauge
_ZLSH_DOC_TOPIC__zlash_metric_rawstacks_gauge='rawstacks gauge

On success, a gauge measurement of current number of stacks is observed and
stored in the `zlash_metric_rawstacks_gauge` variable.
'
_ZLSH_DOC_USAGE__zlash_metric_rawstacks_gauge='Usage

zlash_metric_rawstacks_gauge [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_metric_rawstacks_gauge='Parameters

1. *out_vname*: an optional variable name to store the observation in, instead
   of printing to *STDOUT*
'
zlash_metric_rawstacks_gauge() {
    if  case $# in
            1) _zlsh_is_vname "$1" ;;
            0) true                ;;
            *) false; esac
    then _zlsh_metric_rawstacks_gauge && if [ $# -eq 1 ]
        then   eval    "$1=\$zlash_metric_rawstacks_gauge"
        else printf '%s\n' "$zlash_metric_rawstacks_gauge"; fi
    else _zlsh_usage zlash_metric_rawstacks_gauge && return 64; fi; }
_zlsh_metric_rawstacks_gauge() {
    _zlsh_ensure_pncounter _ZLSH_LCYC_RSTK &&\
    _zlsh_metric_rawstacks_gauge() {
        _zlsh_pncounter_val _ZLSH_LCYC_RSTK &&\
        zlash_metric_rawstacks_gauge=$zlash_pncounter_val
    } && _zlsh_metric_rawstacks_gauge; }

#------------------------------------------------------------------------------
#, zlash_metric_rawstacks_created_counter
_ZLSH_DOC_TOPIC__zlash_metric_rawstacks_created_counter='
rawstacks constructed counter

On success, a counter measurement of number of rawstacks constructed is observed
and stored in the `zlash_metric_rawstacks_created_counter` variable.
'
_ZLSH_DOC_USAGE__zlash_metric_rawstacks_created_counter='Usage

zlash_metric_rawstacks_created_counter [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_metric_rawstacks_created_counter='Parameters

1. *out_vname*: an optional variable name to store the observation in, instead
   of printing to *STDOUT*
'
zlash_metric_rawstacks_created_counter() {
    if  case $# in
            1) _zlsh_is_vname "$1" ;;
            0) true                ;;
            *) false; esac
    then _zlsh_metric_rawstacks_created_counter && if [ $# -eq 1 ]
        then   eval    "$1=\$zlash_metric_rawstacks_created_counter"
        else printf '%s\n' "$zlash_metric_rawstacks_created_counter"; fi
    else _zlsh_usage zlash_metric_rawstacks_created_counter && return 64; fi; }
_zlsh_metric_rawstacks_created_counter() {
    _zlsh_ensure_pncounter _ZLSH_LCYC_RSTK &&\
    _zlsh_metric_rawstacks_created_counter() {
        _zlsh_pncounter_p _ZLSH_LCYC_RSTK &&\
        zlash_metric_rawstacks_created_counter=$zlash_pncounter_p
    } && _zlsh_metric_rawstacks_created_counter; }

#------------------------------------------------------------------------------
#, zlash_mk_rawstack
_ZLSH_DOC_TOPIC__zlash_mk_rawstack='create a new rawstack

A lower-level function creating a new global stack by name. Stack names have
their own global namespace, so they will not clash with other types of names,
but should still be prefixed appropriately to not clash with other stacks.

Optional arguments after the first will be initial elements of the new stack.
'
_ZLSH_DOC_USAGE__zlash_mk_rawstack='Usage

zlash_mk_rawstack name [item ...]
'
_ZLSH_DOC_PARAMS__zlash_mk_rawstack='Parameters

1. *name*: a global identifier for the new rawstack
2. *item*: optional initial element(s) of the new rawstack
'
zlash_mk_rawstack() {
    if [ $# -gt 0 ] && _zlsh_is_vname_sfx "$1"
    then if _zlsh_is_rawstack "$1"; then
            printf '%s\n' "ERROR creating stack: '$1' already exists" >&2
            return 1
        else _zlsh_mk_rawstack "$@"; fi
    else _zlsh_usage zlash_mk_rawstack && return 64; fi; }
_zlsh_mk_rawstack() {
    _zlsh_ensure_pncounter _ZLSH_LCYC_RSTK &&\
    _zlsh_mk_rawstack() {
        _zlsh_mk_rawstack_N=0 &&\
        _zlsh_mk_rawstack=$1  && shift &&\
        while [ $# -gt 0 ]; do
            # On break, error is consummed, so condition needs to be checked
            # again after the loop.
            eval "_ZLSH_RSTK_${_zlsh_mk_rawstack_N}_$_zlsh_mk_rawstack=\$1"\
            && _zlsh_mk_rawstack_N=$((_zlsh_mk_rawstack_N + 1))\
            && shift || break
        done && [ $# -eq 0 ] &&\
        : $((_ZLSH_RSTK_N_$_zlsh_mk_rawstack = _zlsh_mk_rawstack_N)) &&\
        _zlsh_pncounter_incr _ZLSH_LCYC_RSTK  #nocomment highlighting-helper ""
    } && _zlsh_mk_rawstack "$@"; }

#------------------------------------------------------------------------------
#, zlash_is_rawstack
_ZLSH_DOC_TOPIC__zlash_is_rawstack='check if name is for an existing rawstack
'
_ZLSH_DOC_USAGE__zlash_is_rawstack='Usage

zlash_is_rawstack name
'
_ZLSH_DOC_PARAMS__zlash_is_rawstack='Parameters

1. *name*: a global identifier for an existing rawstack
'
zlash_is_rawstack() {
    if  case $# in
            1) _zlsh_is_vname_sfx "$1" ;;
            *) false; esac
    then _zlsh_is_rawstack "$1"
    else _zlsh_usage zlash_is_rawstack && return 64; fi; }
_zlsh_is_rawstack() { eval "[ \"\${_ZLSH_RSTK_N_$1:+x}\" ]"; }

#------------------------------------------------------------------------------
#, zlash_rm_rawstack
_ZLSH_DOC_TOPIC__zlash_rm_rawstack='destroy a rawstack
'
_ZLSH_DOC_USAGE__zlash_rm_rawstack='Usage

zlash_rm_rawstack name
'
_ZLSH_DOC_PARAMS__zlash_rm_rawstack='Parameters

1. *name*: a global identifier for an existing stack
'
zlash_rm_rawstack() {
    if  case $# in
            1) _zlsh_is_vname_sfx "$1" && _zlsh_is_rawstack "$1" ;;
            *) false; esac
    then _zlsh_rm_rawstack "$1"
    else _zlsh_usage zlash_rm_rawstack && return 64; fi; }
_zlsh_rm_rawstack() {
    _zlsh_rm_rawstack=$((_ZLSH_RSTK_N_$1)) &&\
    while [ "$_zlsh_rm_rawstack" -gt 0 ]; do
        _zlsh_rm_rawstack=$((_zlsh_rm_rawstack - 1))     &&\
        unset -v "_ZLSH_RSTK_${_zlsh_rm_rawstack}_$1" || break
    done && [ "$_zlsh_rm_rawstack" -eq 0 ] &&\
    unset -v "_ZLSH_RSTK_N_$1" && _zlsh_pncounter_decr _ZLSH_LCYC_RSTK; }

#------------------------------------------------------------------------------
#, zlash_rawstack_len
_ZLSH_DOC_TOPIC__zlash_rawstack_len='get rawstack size

On success, the length of the stack is stored in the `zlash_rawstack_len` variable.
'
_ZLSH_DOC_USAGE__zlash_rawstack_len='Usage

zlash_rawstack_len name [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_rawstack_len='Parameters

1. *name*: a global rawstack identifier
2. *out_vname*: optional variable name to store the length in, instead of
   printing it to *STDOUT*
'
zlash_rawstack_len() {
    if  case $# in
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_rawstack "$1" &&\
                _zlsh_is_vname     "$2" ;;
            1)  _zlsh_is_vname_sfx "$1" && _zlsh_is_rawstack "$1" ;;
            *)  false; esac
    then _zlsh_rawstack_len "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_rawstack_len"
        else printf '%s\n' "$zlash_rawstack_len"; fi
    else _zlsh_usage zlash_rawstack_len && return 64; fi; }
_zlsh_rawstack_len() { : $((zlash_rawstack_len = _ZLSH_RSTK_N_$1)); }

#------------------------------------------------------------------------------
#, zlash_rawstack_peek
_ZLSH_DOC_TOPIC__zlash_rawstack_peek='peek at the top of the rawstack

On success, the top item of the stack is stored (without removing it) in the
`zlash_rawstack_peek` variable.
'
_ZLSH_DOC_USAGE__zlash_rawstack_peek='Usage

zlash_rawstack_peek name [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_rawstack_peek='Parameters

1. *name*: a global rawstack identifier
2. *out_vname*: optional variable name to store the item in, instead of
   printing it to *STDOUT*
'
zlash_rawstack_peek() {
    if  case $# in
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_rawstack "$1" &&\
                _zlsh_is_vname     "$2" ;;
            1)  _zlsh_is_vname_sfx "$1" && _zlsh_is_rawstack "$1" ;;
            *)  false; esac
    then _zlsh_rawstack_peek "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_rawstack_peek"
        else printf '%s\n' "$zlash_rawstack_peek"; fi
    else _zlsh_usage zlash_rawstack_peek && return 64; fi; }
_zlsh_rawstack_peek() {
    [ $((_ZLSH_RSTK_N_$1)) -gt 0 ] &&\
    eval "zlash_rawstack_peek=\$_ZLSH_RSTK_$((_ZLSH_RSTK_N_$1 - 1))_$1"; }

#------------------------------------------------------------------------------
#, zlash_rawstack_at
_ZLSH_DOC_TOPIC__zlash_rawstack_at='get an item at an index of a rawstack

On success, the item at the specified index (where index of zero is the bottom)
of the stack is stored (without removal) in the `zlash_rawstack_at` variable.
'
_ZLSH_DOC_USAGE__zlash_rawstack_at='Usage

zlash_rawstack_at name index [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_rawstack_at='Parameters

1. *name*: a global rawstack identifier
2. *index*: a non-negative decimal integer less than the length of the stack
3. *out_vname*: optional variable name to store the item in, instead of
   printing it to *STDOUT*
'
zlash_rawstack_at() {
    if  case $# in
            3)  _zlsh_is_vname_sfx "$1" && _zlsh_is_rawstack "$1" &&\
                _zlsh_is_digits    "$2" &&\
                _zlsh_is_vname     "$3" ;;
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_rawstack "$1" &&\
                _zlsh_is_digits    "$2" ;;
            *)  false; esac
    then _zlsh_rawstack_at "$1" "$2" && if [ $# -eq 3 ]
        then   eval    "$3=\$zlash_rawstack_at"
        else printf '%s\n' "$zlash_rawstack_at"; fi
    else _zlsh_usage zlash_rawstack_at && return 64; fi; }
_zlsh_rawstack_at() {
    [ $((_ZLSH_RSTK_N_$1)) -gt "$2" ] &&\
    eval "zlash_rawstack_at=\$_ZLSH_RSTK_$2_$1"; }

#------------------------------------------------------------------------------
#, zlash_rawstack_push
_ZLSH_DOC_TOPIC__zlash_rawstack_push='push item(s) onto a rawstack

Store one or more items on a stack, pushed down in the argument oder.
'
_ZLSH_DOC_USAGE__zlash_rawstack_push='Usage

zlash_rawstack_push name item [item ...]
'
_ZLSH_DOC_PARAMS__zlash_rawstack_push='Parameters

1. *name*: a global rawstack identifier
2. *item*: an item to store
'
zlash_rawstack_push() {
    if [ $# -gt 1 ] && _zlsh_is_vname_sfx "$1" && _zlsh_is_rawstack "$1"
    then _zlsh_rawstack_push "$@"
    else _zlsh_usage zlash_rawstack_push && return 64; fi; }
_zlsh_rawstack_push() {
    _zlsh_rawstack_push_N=$((_ZLSH_RSTK_N_$1)) &&\
    _zlsh_rawstack_push=$1 &&      shift         && \
    while [ $# -gt 0 ]; do
        eval "_ZLSH_RSTK_${_zlsh_rawstack_push_N}_$_zlsh_rawstack_push=\$1" &&\
        _zlsh_rawstack_push_N=$((_zlsh_rawstack_push_N + 1)) && shift || break
    done && [ $# -eq 0 ] &&\
    : $((_ZLSH_RSTK_N_$_zlsh_rawstack_push = _zlsh_rawstack_push_N));
    #nocomment highlighting-helper ""
}

#------------------------------------------------------------------------------
#, zlash_rawstack_pop
_ZLSH_DOC_TOPIC__zlash_rawstack_pop='pop an item from the top of the rawstack

On success, the item at the at the top of the stack is removed and stored in the
`zlash_rawstack_pop` variable.
'
_ZLSH_DOC_USAGE__zlash_rawstack_pop='Usage

zlash_rawstack_pop name [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_rawstack_pop='Parameters

1. *name*: a global rawstack identifier
2. *out_vname*: optional variable name to store the popped item in, instead of
   printing it to *STDOUT*
'
zlash_rawstack_pop() {
    if  case $# in
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_rawstack "$1" &&\
                _zlsh_is_vname     "$2" ;;
            1)  _zlsh_is_vname_sfx "$1" && _zlsh_is_rawstack "$1" ;;
            *)  false; esac
    then _zlsh_rawstack_pop "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_rawstack_pop"
        else printf '%s\n' "$zlash_rawstack_pop"; fi
    else _zlsh_usage zlash_rawstack_pop && return 64; fi; }
_zlsh_rawstack_pop() {
    [ $((_ZLSH_RSTK_N_$1)) -gt 0 ] &&\
    eval "zlash_rawstack_pop=\$_ZLSH_RSTK_$((_ZLSH_RSTK_N_$1 - 1))_$1"\
        "&& _ZLSH_RSTK_N_$1=$((_ZLSH_RSTK_N_$1 - 1))"; }

#------------------------------------------------------------------------------
#, zlash_rawstack_repr
_ZLSH_DOC_TOPIC__zlash_rawstack_repr='get a representation of a rawstack

Output a represenation of the stack, safe to be evaluated to reconstruct the
stack.
'
_ZLSH_DOC_USAGE__zlash_rawstack_repr='Usage

zlash_rawstack_pop name [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_rawstack_repr='Parameters

1. *name*: a global rawstack identifier
2. *out_vname*: optional variable name to store the representation in, instead
   of printing it to *STDOUT*
'
zlash_rawstack_repr() {
    if  case $# in
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_rawstack "$1" &&\
                _zlsh_is_vname     "$2" ;;
            1)  _zlsh_is_vname_sfx "$1" && _zlsh_is_rawstack "$1" ;;
            *)  false; esac
    then _zlsh_rawstack_repr "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_rawstack_repr"
        else printf '%s\n' "$zlash_rawstack_repr"; fi
    else _zlsh_usage zlash_rawstack_repr && return 64; fi; }
_zlsh_rawstack_repr() {
    _zlsh_rawstack_repr_I=0 &&\
    _zlsh_rawstack_repr="zlash_mk_rawstack $1" &&\
    while [ $((_ZLSH_RSTK_N_$1)) -gt "$_zlsh_rawstack_repr_I" ]; do
        eval "_zlsh_q \"\$_ZLSH_RSTK_${_zlsh_rawstack_repr_I}_$1\""\
        && _zlsh_rawstack_repr=$_zlsh_rawstack_repr\ $zlash_q\
        && _zlsh_rawstack_repr_I=$((_zlsh_rawstack_repr_I + 1)) || break
    done && [ $((_ZLSH_RSTK_N_$1)) -eq "$_zlsh_rawstack_repr_I" ] &&\
        zlash_rawstack_repr=$_zlsh_rawstack_repr; }

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
        _zlsh_mk_rawdeque=$1          &&        shift            &&\
        _zlsh_mk_rawstack "_ZLSH_RDEQ_T_$_zlsh_mk_rawdeque" "$@" && \
        _zlsh_mk_rawstack "_ZLSH_RDEQ_H_$_zlsh_mk_rawdeque"      &&  \
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
_zlsh_is_rawdeque() { _zlsh_is_rawstack "_ZLSH_RDEQ_H_$1"; }

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
    _zlsh_rm_rawstack "_ZLSH_RDEQ_H_$1" &&\
    _zlsh_rm_rawstack "_ZLSH_RDEQ_T_$1" && \
    _zlsh_pncounter_decr _ZLSH_LCYC_DEQ; }

#------------------------------------------------------------------------------
#, zlash_rawdeque_len
_ZLSH_DOC_TOPIC__zlash_rawdeque_len='get rawdeque size

On success, the length of the rawdeque is stored in the `zlash_rawdeque_len`
variable.
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
    _zlsh_rawstack_len "_ZLSH_RDEQ_H_$1" &&\
    zlash_rawdeque_len=$zlash_rawstack_len  && \
    _zlsh_rawstack_len "_ZLSH_RDEQ_T_$1" &&  \
    zlash_rawdeque_len=$((zlash_rawdeque_len + zlash_rawstack_len)); }

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
    _zlsh_rawstack_len "_ZLSH_RDEQ_H_$1" &&\
    if [ "$zlash_rawstack_len" -gt "$2" ]; then
        _zlsh_rawstack_at "_ZLSH_RDEQ_H_$1" "$2" &&\
        zlash_rawdeque_at=$zlash_rawstack_at
    else _zlsh_rawdeque_at=$(($2 - zlash_rawstack_len))      &&\
        _zlsh_rawstack_len "_ZLSH_RDEQ_T_$1"                 && \
        [ "$zlash_rawstack_len" -gt "$_zlsh_rawdeque_at" ]   &&  \
        _zlsh_rawstack_at "_ZLSH_RDEQ_T_$1"                       \
            $((zlash_rawstack_len - 1 - $_zlsh_rawdeque_at)) &&    \
        zlash_rawdeque_at=$zlash_rawstack_at; fi; }

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
    _zlsh_rawstack_push "_ZLSH_RDEQ_T_$_zlsh_rawdeque_push" "$@"; }

#------------------------------------------------------------------------------
#, zlash_rawdeque_pop
_ZLSH_DOC_TOPIC__zlash_rawdeque_pop='pop an item from the end of the rawdeque

On success, the item at the at the end of the rawdeque is removed and stored in
the `zlash_rawdeque_pop` variable.
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
    # stack in reverse order. We use a temporary stack for that, which must be
    # dependent the current deque to ensure isolation.
    if [ $# -eq 2 ]; then _zlsh_rawstack_push "_ZLSH_RDEQ_H_$1" "$2"
    else _zlsh_rawdeque_unshift_T="_zlsh_rawdeque_unshift_$1" &&\
        _zlsh_rawdeque_unshift=$1 &&          shift           && \
        _zlsh_mk_rawstack "$_zlsh_rawdeque_unshift_T" "$@"    &&  \
        while _zlsh_rawstack_pop "$_zlsh_rawdeque_unshift_T"; do
            _zlsh_rawstack_push "_ZLSH_RDEQ_H_$_zlsh_rawdeque_unshift"\
                                "$zlash_rawstack_pop"                 || break
        done && _zlsh_rawstack_len "$_zlsh_rawdeque_unshift_T" &&\
        if [ "$zlash_rawstack_len" -eq 0 ]; then
            _zlsh_rm_rawstack "$_zlsh_rawdeque_unshift_T"
        else _zlsh_rawdeque_unshift_E='ERROR while executing _zlsh_rawdeque_unshift ' &&\
            _zlsh_rawdeque_unshift_E=$_zlsh_rawdeque_unshift_E$_zlsh_rawdeque_unshift &&\
            for _zlsh_rawdeque_unshift_P; do _zlsh_q "$_zlsh_rawdeque_unshift_P"   &&\
                _zlsh_rawdeque_unshift_E=$_zlsh_rawdeque_unshift_E\ $zlash_q; done &&\
            _zlsh_rawdeque_unshift_E=$_zlsh_rawdeque_unshift_E"; $zlash_rawstack_len " &&\
            _zlsh_rawdeque_unshift_E=$_zlsh_rawdeque_unshift_E"items failed to unshift" &&\
            printf '%s\n' "$_zlsh_rawdeque_unshift_E" >&2 &&\
            _zlsh_rm_rawstack "$_zlsh_rawdeque_unshift_T" && return 1
            # TODO: Decide if a more advanced cleanup or recovery should be
            #   attempted here, like keep attempting until remaining number
            #   stabilizes, save the temporary stack for caller's recovery, or
            #   attempt to unwind changes.
        fi; fi; }

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

#------------------------------------------------------------------------------
#, zlash_rawdeque_repr
_ZLSH_DOC_TOPIC__zlash_rawdeque_repr='get a representation of a rawdeque

Output a represenation of the rawdeque, safe to be evaluated to reconstruct the
stack.
'
_ZLSH_DOC_USAGE__zlash_rawdeque_repr='Usage

zlash_rawdeque_repr name [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_rawdeque_repr='Parameters

1. *name*: a global rawdeque identifier
2. *out_vname*: optional variable name to store the representation in, instead
   of printing it to *STDOUT*
'
zlash_rawdeque_repr() {
    if  case $# in
            2)  _zlsh_is_vname_sfx "$1" && _zlsh_is_rawdeque "$1" &&\
                _zlsh_is_vname     "$2" ;;
            1)  _zlsh_is_vname_sfx "$1" && _zlsh_is_rawdeque "$1" ;;
            *)  false; esac
    then _zlsh_rawdeque_repr "$1" && if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_rawdeque_repr"
        else printf '%s\n' "$zlash_rawdeque_repr"; fi
    else _zlsh_usage zlash_rawdeque_repr && return 64; fi; }
_zlsh_rawdeque_repr() {
    _zlsh_rawdeque_repr="zlash_mk_rawdeque $1" &&\
    _zlsh_rawstack_len "_ZLSH_RDEQ_H_$1"       && \
    _zlsh_rawdeque_repr_I=$zlash_rawstack_len  &&  \
    while [ "$_zlsh_rawdeque_repr_I" -gt 0 ]; do
        _zlsh_rawdeque_repr_I=$((_zlsh_rawdeque_repr_I - 1))         &&\
        _zlsh_rawstack_at "_ZLSH_RDEQ_H_$1" "$_zlsh_rawdeque_repr_I" && \
        _zlsh_q "$zlash_rawstack_at"                                 &&  \
        _zlsh_rawdeque_repr=$_zlsh_rawdeque_repr\ $zlash_q           || break
    done && [ "$_zlsh_rawdeque_repr_I" -eq 0 ] &&\
    _zlsh_rawstack_len "_ZLSH_RDEQ_T_$1"       && \
    while [ "$_zlsh_rawdeque_repr_I" -lt "$zlash_rawstack_len" ]; do
        _zlsh_rawstack_at "_ZLSH_RDEQ_T_$1" "$_zlsh_rawdeque_repr_I" &&\
        _zlsh_q "$zlash_rawstack_at"                                 && \
        _zlsh_rawdeque_repr=$_zlsh_rawdeque_repr\ $zlash_q           &&  \
        _zlsh_rawdeque_repr_I=$((_zlsh_rawdeque_repr_I + 1))         || break
    done && [ "$_zlsh_rawdeque_repr_I" -eq "$zlash_rawstack_len" ] &&\
    zlash_rawdeque_repr=$_zlsh_rawdeque_repr; }

###############################################################################
#/ Decimal-Hexadecimal Non-Negative Integer Conversion
#
#------------------------------------------------------------------------------
#, zlash_deci2hexi
_ZLSH_DOC_TOPIC__zlash_deci2hexi='decimal integer to hexadecimal

Convert a non-negative decimal integer to a hexadecimal.
'
_ZLSH_DOC_USAGE__zlash_deci2hexi='Usage
zlash_deci2hexi decimal [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_deci2hexi='Parameters
1. *decimal*: a non-negative decimal integer
2. *out_vname*: an optional variable name to store result instead of outputing
   it to *STDOUT*
'
zlash_deci2hexi() {
    if  case $# in
            2)  _zlsh_is_digits "$1" &&\
                _zlsh_is_vname  "$2" ;;
            1)  _zlsh_is_digits "$1" ;;
            *)  false
        esac
    then _zlsh_deci2hexi "$1" &&\
        if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_deci2hexi"
        else printf '%s\n' "$zlash_deci2hexi"
        fi
    else _zlsh_usage zlash_deci2hexi && return 64
    fi
}
_zlsh_deci2hexi() {
    # See shellbench/to_hex.sh for why this implementation is selected as a
    # portable fallback. (It's performance.)
    zlash_deci2hexi='' &&\
    _zlsh_deci2hexi=$1 && \
    while [ "$_zlsh_deci2hexi" != 0 ]; do
        case $((_zlsh_deci2hexi%16)) in
            ?) zlash_deci2hexi=$((_zlsh_deci2hexi%16))$zlash_deci2hexi;;
            10) zlash_deci2hexi=a$zlash_deci2hexi;;
            11) zlash_deci2hexi=b$zlash_deci2hexi;;
            12) zlash_deci2hexi=c$zlash_deci2hexi;;
            13) zlash_deci2hexi=d$zlash_deci2hexi;;
            14) zlash_deci2hexi=e$zlash_deci2hexi;;
            15) zlash_deci2hexi=f$zlash_deci2hexi;;
        esac &&\
        _zlsh_deci2hexi=$((_zlsh_deci2hexi/16)) || return 1
    done
}

#------------------------------------------------------------------------------
#, zlash_hexi2deci
_ZLSH_DOC_TOPIC__zlash_hexi2deci='hexadecimal integer to decimal

Convert a non-negative hexadecimal integer to a decimal.
'
_ZLSH_DOC_USAGE__zlash_hexi2deci='Usage
zlash_deci2hexi hexadecimal [out_vname]
'
_ZLSH_DOC_PARAMS__zlash_hexi2deci='Parameters
1. *hexadecimal*: a non-negative hexadecimal integer
2. *out_vname*: an optional variable name to store result instead of outputing
   it to *STDOUT*
'
zlash_hexi2deci() {
    if  case $# in
            2)  _zlsh_is_xdigits "$1" &&\
                _zlsh_is_vname   "$2" ;;
            1)  _zlsh_is_xdigits "$1" ;;
            *)  false
        esac
    then _zlsh_hexi2deci "$1" &&\
        if [ $# -eq 2 ]
        then   eval    "$2=\$zlash_hexi2deci"
        else printf '%s\n' "$zlash_hexi2deci"
        fi
    else _zlsh_usage zlash_hexi2deci && return 64
    fi
}
_zlsh_hexi2deci() {
    zlash_hexi2deci=0   &&\
    _zlsh_hexi2deci=$1  && \
    _zlsh_hexi2deci_P=1 &&  \
    while [ "${_zlsh_hexi2deci:+x}" ]; do
        case $_zlsh_hexi2deci in
            *0) :;;
            *1) zlash_hexi2deci=$((    _zlsh_hexi2deci_P + zlash_hexi2deci));;
            *2) zlash_hexi2deci=$((2 * _zlsh_hexi2deci_P + zlash_hexi2deci));;
            *3) zlash_hexi2deci=$((3 * _zlsh_hexi2deci_P + zlash_hexi2deci));;
            *4) zlash_hexi2deci=$((4 * _zlsh_hexi2deci_P + zlash_hexi2deci));;
            *5) zlash_hexi2deci=$((5 * _zlsh_hexi2deci_P + zlash_hexi2deci));;
            *6) zlash_hexi2deci=$((6 * _zlsh_hexi2deci_P + zlash_hexi2deci));;
            *7) zlash_hexi2deci=$((7 * _zlsh_hexi2deci_P + zlash_hexi2deci));;
            *8) zlash_hexi2deci=$((8 * _zlsh_hexi2deci_P + zlash_hexi2deci));;
            *9) zlash_hexi2deci=$((9 * _zlsh_hexi2deci_P + zlash_hexi2deci));;
            *a|*A) zlash_hexi2deci=$((10*_zlsh_hexi2deci_P+zlash_hexi2deci));;
            *b|*B) zlash_hexi2deci=$((11*_zlsh_hexi2deci_P+zlash_hexi2deci));;
            *c|*C) zlash_hexi2deci=$((12*_zlsh_hexi2deci_P+zlash_hexi2deci));;
            *d|*D) zlash_hexi2deci=$((13*_zlsh_hexi2deci_P+zlash_hexi2deci));;
            *e|*E) zlash_hexi2deci=$((14*_zlsh_hexi2deci_P+zlash_hexi2deci));;
            *f|*F) zlash_hexi2deci=$((15*_zlsh_hexi2deci_P+zlash_hexi2deci));;
        esac &&\
        _zlsh_hexi2deci_P=$((16 * _zlsh_hexi2deci_P)) &&\
        _zlsh_hexi2deci=${_zlsh_hexi2deci%?}          || return 1
    done
}


##############
#_ Byte Map
#
# https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap08.html#tag_08_02
# https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap07.html#tag_07_02
_zlsh_init_byte_map() {
    # Initialize a PN-counter to track LC_ALL integrity and to not do successful
    # work twice.
    _zlsh_mk_pncounter _zlsh_init_byte_map || return 1
    # We only need one PN-counter, created on the first invocation only.
    _zlsh_init_byte_map() {
        _zlsh_pncounter_val _zlsh_init_byte_map &&\
        case $zlash_pncounter_val in
            0)  # No failed cleanup detected.
                _zlsh_pncounter_p _zlsh_init_byte_map &&\
                if [ "$zlash_pncounter_p" -gt 0 ]; then
                    # Already initialized successfully. Verify that LC_ALL is
                    # not saved for restoring.
                    if [ "${_ZLSH_ENV__LC_ALL+x}"]; then
                        printf '%s\n' 'ERROR: Unexplected stash of LC_ALL' >&2
                        return 1
                    else
                        return 0
                    fi
                else
                    # Save the current LC_ALL if it is set.
                    if [ "${LC_ALL+x}" ]; then
                        _ZLSH_ENV__LC_ALL=$LC_ALL
                    fi
                fi
                ;;
            1)  # Last call did not clean up, we should not clobber the saved
                # LC_ALL. Verify that LC_ALL it is either set to C, the saved
                # value, or both are not set, then stabilize the PN-counter.
                
                _zlsh_pncounter_decr _zlsh_init_byte_map
                ;;
            *)  # Unexpected stabilization failure, panic!
                printf '%s\n' 'ERROR: unexpected state in init byte map' >&2
                return 1
        esac &&\
        _zlsh_pncounter_incr _zlsh_init_byte_map &&\
        LC_ALL=C &&\
        _zlsh_init_byte_map_ && ZLASH_STATUS=0 || ZLASH_STATUS=$? || return 1
        if [ "${_ZLSH_ENV__LC_ALL+x}" ]; then
            LC_ALL=$_ZLSH_ENV__LC_ALL &&\
                unset -v _ZLSH_ENV__LC_ALL
        else
            unset -v LC_ALL
        fi
        _zlsh_pncounter_decr _zlsh_init_byte_map
    }
    _zlsh_init_byte_map
}
_zlsh_init_byte_map_() {
    # NOTE: Most shells will have ZLASH_BYTE_MAP length of 256, since they can't
    #       store NULL bytes and the last byte is doubled (for multibyte match
    #       failure detection). However, some whells (like Zsh, when not in a
    #       compatibility mode) can handle NULL bytes, then ZLASH_BYTE_MAP
    #       length will be 257. This difference is handled by specializations of
    #       the interfacing functions.

    _zlsh_mk_pncounter _zlsh_init_byte_map


    _ZLSH_TMP_I=1     && _ZLSH_TMP_MAP=''  &&\
    _ZLSH_TMP_TMP=''  && _ZLSH_TMP_FMT=''  && \
    _ZLSH_TMP_DECs='' && _ZLSH_TMP_BYTE='' &&  \
    ZLASH_BYTE_MAP=''                      || return 1
    # Construct decimal values to interpolate as printf '\\%03o' arguments.
    while [ "$_ZLSH_TMP_I" -lt 256 ]; do
        _ZLSH_TMP_DECs=$_ZLSH_TMP_DECs\ $_ZLSH_TMP_I &&\
        _ZLSH_TMP_I=$((_ZLSH_TMP_I + 1))             || return 1
    done
    # Get and use the format string to get the ZLASH_BYTE_MAP.
    eval "_ZLSH_TMP_FMT=\$(printf '\\\\%03o' $_ZLSH_TMP_DECs)" &&\
    ZLASH_BYTE_MAP=$(printf "${_ZLSH_TMP_FMT}x")               && \
    ZLASH_BYTE_MAP=${ZLASH_BYTE_MAP%x}                         &&  \
    _ZLSH_TMP_MAP=$ZLASH_BYTE_MAP                              &&   \
    _ZLSH_TMP_I=1                                              || return 1
    # Get indivudual values for ZLASH_BYTE_decimal.
    while [ "$_ZLSH_TMP_I" -lt 256 ]; do
        _ZLSH_TMP_TMP=${_ZLSH_TMP_MAP#?}                  &&\
        _ZLSH_TMP_BYTE=${_ZLSH_TMP_MAP%%"$_ZLSH_TMP_TMP"} && \
        _ZLSH_TMP_MAP=$_ZLSH_TMP_TMP                      &&  \
        eval "ZLASH_BYTE_$_ZLSH_TMP_I=\$_ZLSH_TMP_BYTE"   &&   \
        _ZLSH_TMP_I=$((_ZLSH_TMP_I + 1))                  || return 1
    done
    # Double the last byte to detect multibyte match failure.
    ZLASH_BYTE_MAP=$ZLASH_BYTE_MAP$ZLASH_BYTE_255 &&\
    ZLASH_BYTE_0=$(printf '\000z')                && \
    ZLASH_BYTE_0=${ZLASH_BYTE_0%z}                || return 1
    # Prepend NULL if shell can handle it, sanity-check length.
    if [ ${#ZLASH_BYTE_0} = 1 ]; then
        ZLASH_BYTE_MAP=$ZLASH_BYTE_0$ZLASH_BYTE_MAP &&\
        [ ${#ZLASH_BYTE_MAP} = 257 ]                || return 1
    else
        [ ${#ZLASH_BYTE_MAP} = 256 ] || return 1
    fi
    # Bookkeeping.
    unset -v  _ZLSH_TMP_I   _ZLSH_TMP_MAP  _ZLSH_TMP_TMP   \
              _ZLSH_TMP_FMT _ZLSH_TMP_DECs _ZLSH_TMP_BYTE &&\
    if _zlsh_is_digits "${ZLASH_INITIALIZED__BYTE_MAP-}"
    then ZLASH_INITIALIZED__BYTE_MAP=$((ZLASH_INITIALIZED__BYTE_MAP + 1))
    else ZLASH_INITIALIZED__BYTE_MAP=1
    fi
}

# Control Codes
_zlsh_ensure_cc_map() {
    if [ "${ZLASH_INITIALIZED__CC_MAP:+x}" ]
    then return 0
    else _zlsh_init_cc_map
    fi
}
_zlsh_init_cc_map() {
    # "Want to escape a single quote? echo 'This is how it'\''s done'."
    # shellcheck disable=SC1003  # No, we do not.
    _zlsh_ensure_byte_map\
    &&  _zlsh() {  # A temp func initializing attributes of a control code.
        if ! eval "                                 \
                ZLASH_CC_$1=\$ZLASH_BYTE_$2          \
            &&  ZLASH_CC_$2=\$1                       \
            && { [ \"\$3\" ] && ZLASH_CC_${1}__ESC=\$3 \
                    || unset -v ZLASH_CC_${1}__ESC;    }\
            && { [ \"\$4\" ] && ZLASH_CC_${1}__carret=\$4\
                    || unset -v ZLASH_CC_${1}__carret; }  \
            && { [ \"\$5\" ] && ZLASH_CC_${1}__C_esc=\$5   \
                    || unset -v ZLASH_CC_${1}__C_esc;  }    \
            && { [ \"\$6\" ] && ZLASH_CC_${1}__utf8=\$6      \
                    || unset -v ZLASH_CC_${1}__utf8;   }      \
            && _ZLSH_DOC__ZLASH_CC_$1=\$7"
        then
            printf '%s\n' "ERROR defining CC '$1'" >&2
            return 1
        fi
    }\
    &&    : _zlsh positional parameters :        \
             1   2   3   4  5   6   7             \
                 Dec    Carret  Utf8pic            \
             Name    ESC+   C-esc   Description     \
    && _zlsh NUL   0 '' '@' '0' '␀' 'Null'           \
    && _zlsh SOH   1 '' 'A' ''  '␁' 'Start of Heading'\
    && _zlsh STX   2 '' 'B' ''  '␂' 'Start of Text'    \
    && _zlsh ETX   3 '' 'C' ''  '␃'   'End of Text'     \
    && _zlsh EOT   4 '' 'D' ''  '␄' 'End of Transmission'\
    && _zlsh ENQ   5 '' 'E' ''  '␅' 'Enquiry'             \
    && _zlsh ACK   6 '' 'F' ''  '␆' 'Acknowledge'          \
    && _zlsh BELL  7 '' 'G' 'a' '␇' 'Bell'                  \
    && _zlsh BS    8 '' 'H' 'b' '␈' 'Backspace'              \
    && _zlsh HT    9 '' 'I' 't' '␉' 'Horizontal Tabulation'   \
    && _zlsh LF   10 '' 'J' 'n' '␊' 'Line Feed'                \
    && _zlsh VT   11 '' 'K' 'v' '␋' 'Vertical Tabulation'       \
    && _zlsh FF   12 '' 'L' 'f' '␌' 'Form Feed'                  \
    && _zlsh CR   13 '' 'M' 'r' '␍' 'Carriage Return'             \
    && _zlsh SO   14 '' 'N' ''  '␎' 'Shift Out'                    \
    && _zlsh SI   15 '' 'O' ''  '␏' 'Shift In'                      \
    && _zlsh DLE  16 '' 'P' ''  '␐' 'Data Link Escape'               \
    && _zlsh DC1  17 '' 'Q' ''  '␑' 'Decive Control One'              \
    && _zlsh DC2  18 '' 'R' ''  '␒' 'Device Control Two'               \
    && _zlsh DC3  19 '' 'S' ''  '␓' 'Device Control Three'              \
    && _zlsh DC4  20 '' 'T' ''  '␔' 'Device Control Four'                \
    && _zlsh NAK  21 '' 'U' ''  '␕' 'Negative Acknowledge'                \
    && _zlsh SYN  22 '' 'V' ''  '␖' 'Synchronous Idle'                     \
    && _zlsh ETB  23 '' 'W' ''  '␗' 'End of Transmission Block'             \
    && _zlsh CAN  24 '' 'X' ''  '␘' 'Cancel'                                 \
    && _zlsh EM   25 '' 'Y' ''  '␙' 'End of Medium'                           \
    && _zlsh SUB  26 '' 'Z' ''  '␚' 'Substitute'                               \
    && _zlsh ESC  27 '' '[' 'e' '␛' 'Escape'                                   \
    && _zlsh FS   28 '' '\' ''  '␜'   'File Separator'                         \
    && _zlsh GS   29 '' ']' ''  '␝'  'Group Separator'                         \
    && _zlsh RS   30 '' '^' ''  '␞' 'Record Separator'                         \
    && _zlsh US   31 '' '_' ''  '␟'   'Unit Separator'                         \
    && _zlsh SP   32 '' ''  ''  '␠' 'Space'                                    \
    && _zlsh DEL 127 '' '?' ''  '␡' 'Delete'                                   \
    \
    && _zlsh PAD 128 '@' '' ''  ''  'Padding'            \
    && _zlsh HOP 129 'A' '' ''  ''  'Higher Octet Preset' \
    && _zlsh BPH 130 'B' '' ''  ''  'Break Permitted Here' \
    && _zlsh NBH 131 'C' '' ''  ''  'No Break Here'         \
    && _zlsh IND 132 'D' '' ''  ''  'Line Down'              \
    && _zlsh NEL 133 'E' '' ''  ''  'Next Line'               \
    && _zlsh SSA 134 'F' '' ''  ''  'Start of Selected Area'   \
    && _zlsh ESA 135 'G' '' ''  ''  'End of Selected Area'      \
    && _zlsh HTS 136 'H' '' ''  ''  'Horizontal Tabulation Set'  \
    && _zlsh HTJ 137 'I' '' ''  ''  'Horizontal Tab Justify Right'\
    && _zlsh VTS 138 'J' '' ''  ''  'Vertical Tabulation Set'      \
    && _zlsh PLD 139 'K' '' ''  ''  'Partial Line Down'             \
    && _zlsh PLU 140 'L' '' ''  ''  'Partial Line Up'                \
    && _zlsh RI  141 'M' '' ''  ''  'Line Up'                         \
    && _zlsh SS2 142 'N' '' ''  ''  'Single-Shift 2'                   \
    && _zlsh SS3 143 'O' '' ''  ''  'Single-Shift 3'                    \
    && _zlsh DCS 144 'P' '' ''  ''  'Device Control String'              \
    && _zlsh PU1 145 'Q' '' ''  ''  'Private Use 1'                       \
    && _zlsh PU2 146 'R' '' ''  ''  'Private Use 2'                        \
    && _zlsh STS 147 'S' '' ''  ''  'Set Transmit State'                    \
    && _zlsh CCH 148 'T' '' ''  ''  'Cancel Character'                       \
    && _zlsh MW  149 'U' '' ''  ''  'Message Waiting'                         \
    && _zlsh SPA 150 'V' '' ''  ''  'Start of Protected Area'                  \
    && _zlsh EPA 151 'W' '' ''  ''    'End of Protected Area'                  \
    && _zlsh SOS 152 'X' '' ''  ''  'Start of String'                          \
    && _zlsh SGC 153 'Y' '' ''  ''  'Single Graphic Character Introducer'      \
    && _zlsh SCI 154 'Z' '' ''  ''  'Single Character Introducer'              \
    && _zlsh CSI 155 '[' '' ''  ''  'Control Sequence Introducer'              \
    && _zlsh ST  156 '\' '' ''  ''  'String Terminator'                        \
    && _zlsh OSC 157 ']' '' ''  ''  'Operating System Command'                 \
    && _zlsh PM  158 '^' '' ''  ''  'Privacy Message'                          \
    && _zlsh APM 159 '_' '' ''  ''  'Application Program Command'              \
    \
    && unset -f _zlsh\
    && if _zlsh_is_digits "${ZLASH_INITIALIZED__CC_MAP-}"
        then ZLASH_INITIALIZED__CC_MAP=$((ZLASH_INITIALIZED__CC_MAP+1))
        else ZLASH_INITIALIZED__CC_MAP=1
    fi
}

#------------------------------------------------------------------------------
#               Lower-Level Output-Related Functionality
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#

zlash_echo__doc__='echo, avoiding echo pitfalls

Print arguments to *STDOUT*, separated by a space.

Expected `echo` behavior, avoiding non-portable `echo` pitfalls like arguments
shadowed by implementation-specific flags (POSIX mandates exception for `echo`
of the standard `--` argument handling) and inconsistent newline output across
implementations.
'
zlash_echo__doc_see__='
<https://www.in-ulm.de/%7Emascheck/various/echo+printf/>
'
zlash_echo__doc_posparams__='[ *str* ... ]'
zlash_echo() {
    while [ "${2+x}" ]; do
        printf '%s ' "$1" &&\
        shift             || return $?
    done
    if [ "${1:+x}" ]; then
        printf '%s\n' "$1"
    else
        printf '\n'
    fi
}


zlash_stderr__doc__='echo to STDERR

Output arguments separated by a space to *STDERR*. This is used by Zlash
lower-level functions to output errors as error stream.

A `ZLASH_STDERR` configuration setting can be used to redirect all
`zlash_stderr` invocations.
'
zlash_stderr__doc_see__='
`ZLASH_STDERR`, `zlash_echo`, `zlash_null_stderr`
'
zlash_stderr__doc_posparams__='[ *str* ... ]'
zlash_stderr() {
    case ${ZLASH_CFG_ZLASH_STDERR-} in
        '')              zlash_echo "$@" >&2                           ;;
        '&'[[:digit:]])  zlash_echo "$@" >&${ZLASH_CFG_ZLASH_STDERR#?} ;;
        '\&'[[:digit:]]) zlash_echo "$@" >"${ZLASH_CFG_ZLASH_STDERR#?}";;
        *)               zlash_echo "$@" > "$ZLASH_CFG_ZLASH_STDERR"   ;;
    esac
}


zlash_null__doc__='silence a command

Silences both *STDOUT* and *STDERR* of a command by wrapping it in both
`zlash_null_stdout` and `zlash_null_stderr`.

`ZLASH_SILENCED_STDOUT` and `ZLASH_SILENCED_STDERR` configuration settings can
be used to control redirections of `zlash_silent` invocations globally.
'
zlash_null__doc_see__='
`zlash_null_stdout`, `zlash_null_stderr`,
`ZLASH_SILENCED_STDOUT`, `ZLASH_SILENCED_STDERR`
'
zlash_null__doc_posparams__='*cmd* [ *arg* ... ]'
zlash_null() {
    if [ $# = 0 ]; then
        zlash_usage zlash_null
        return 64
    fi
    _zlsh_null "$@"
}
_zlsh_null() { _zlsh_null_stderr _zlsh_null_stdout "$@"; }

zlash_null_stdout__doc__='silence STDOUT of a command

Silences *STDOUT* of a command.

`ZLASH_SILENCED_STDOUT` configuration setting can be used to control
redirections of `zlash_nulld_stdout` invocations globally.
'
zlash_null_stdout__doc_see__='
`ZLASH_SILENCED_STDOUT`, `zlash_null_stderr`, `zlash_null`
'
zlash_null_stdout__doc_posparams__='*cmd* [ *arg* ... ]'
zlash_null_stdout() {
    if [ $# = 0 ]; then
        zlash_usage zlash_null_stdout
        return 64
    fi
    _zlsh_null_stdout "$@"
}
_zlsh_null_stdout() {
    _zlsh_silenced_stdout_CMD=$1 &&\
    shift                        || return 1

    case ${ZLASH_CFG_ZLASH_SILENCED_STDOUT-} in
        '')
            "$_zlsh_silenced_stdout_CMD" "$@" > /dev/null \
                || return $?;;
        '&'[[:digit:]])
            "$_zlsh_silenced_stdout_CMD"                   \
                "$@" >&${ZLASH_CFG_ZLASH_SILENCED_STDOUT#?} \
                || return $?;;
        '\&'[[:digit:]])
            "$_zlsh_silenced_stdout_CMD"                     \
                "$@" > "${ZLASH_CFG_ZLASH_SILENCED_STDOUT#?}" \
                || return $?;;
        *)
            "$_zlsh_silenced_stdout_CMD"                   \
                "$@" > "${ZLASH_CFG_ZLASH_SILENCED_STDOUT}" \
                || return $?;;
    esac

    unset -v _zlsh_silenced_stdout_CMD
}

#___________________________
#_FUN zlash_null_stderr
#
zlash_null_stderr__DOC__BLURB='
silence a command
'
zlash_null_stderr__DOC__USAGE='
zlash_null_stderr cmd [arg ...]
'
zlash_null_stderr__DOC__DESCR='
Silences *STDERR* of a command.

`ZLASH_SILENCED_STDERR` configuration setting can be used to control
redirections of `zlash_null_stderr` invocations globally.
'
zlash_null_stderr__DOC__LINKS='
`ZLASH_SILENCED_STDERR`,
`zlash_null_stdout`
'
zlash_null_stderr() {
    if [ $# = 0 ]; then
        zlash_usage zlash_null_stderr
        return 64
    fi
    _zlsh_null_stderr "$@"
}
_zlsh_null_stderr() {
    _zlsh_null_stderr_CMD=$1 &&\
    shift                    || return 1

    case ${ZLASH_CFG_ZLASH_SILENCED_STDERR-} in
        '')
            "$_zlsh_null_stderr_CMD" "$@" 2> /dev/null \
                || return $?;;
        '&'[[:digit:]])
            "$_zlsh_null_stderr_CMD"                        \
                "$@" 2>&${ZLASH_CFG_ZLASH_SILENCED_STDERR#?} \
                || return $?;;
        '\&'[[:digit:]])
            "$_zlsh_null_stderr_CMD"                          \
                "$@" 2> "${ZLASH_CFG_ZLASH_SILENCED_STDERR#?}" \
                || return $?;;
        *)
            "$_zlsh_null_stderr_CMD"                      \
                "$@" 2> "$ZLASH_CFG_ZLASH_SILENCED_STDERR" \
                || return $?;;
    esac

    unset -v _zlsh_null_stderr_CMD
}

#____________________
#_FUN zlash_tty_size
#
zlash_tty_size__DOC__BLURB='
get terminal dimensions
'
zlash_tty_size__DOC__USAGE='
zlash_tty_size && { rows=$zlash_tty_rows; cols=$zlash_tty_cols; }
'
zlash_tty_size__DOC__DESCR='
Sets `zlash_tty_rows` and `zlash_tty_cols` variables to the dimentions of the
terminal, on success.
'
zlash_tty_size() { _zlsh_tty_size; }
_zlsh_tty_size() {  # portable fallback
    if _zlsh_tty_size="$(zlash_null_stderr stty size)"
    then
        zlash_tty_rows=${_zlsh_tty_size%%[[:space:]]*} &&\
        zlash_tty_cols=${_zlsh_tty_size##*[[:space:]]} && return 0
    else
        zlash_tty_rows=$(zlash_null_stderr tput lines) &&\
        zlash_tty_cols=$(zlash_null_stderr tput cols ) && return 0
    fi
    return 1
}

#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
#/  String Manipulation Functionality
#


zlash_str_repeat() {
    if { [ $# != 2 ] || [ "$1" = '' ]                           \
                     || [ "$2" = 0 ] || ! _zlsh_is_digits "$2"; }\
    && { [ $# != 3 ] || [ "$1" = '' ]                             \
                     || [ "$2" = 0 ] || ! _zlsh_is_digits "$2"     \
                                     || ! _zlsh_is_vname  "$3"; }
    then
        _zlsh_usage zlash_str_repeat
        return 64
    fi
    _zlsh_str_repeat "$1" "$2" &&\
    if [ $# = 3 ]
    then eval      "$3=\$zlash_str_repeat"
    else printf '%s\n' "$zlash_str_repeat"
    fi
}
_zlsh_str_repeat() {
    zlash_str_repeat=''   &&\
    _zlsh_str_repeat_S=$1 && \
    _zlsh_str_repeat_N=$2 &&  \
    _zlsh_str_repeat_K=1  || return 1
    while [ "$_zlsh_str_repeat_K" -lt "$_zlsh_str_repeat_N" ]; do
        if [ "$((_zlsh_str_repeat_K * 2))" -le "$_zlsh_str_repeat_N" ]; then
            _zlsh_str_repeat_S=$_zlsh_str_repeat_S$_zlsh_str_repeat_S
            _zlsh_str_repeat_K=$((_zlsh_str_repeat_K * 2))
        else
            zlash_str_repeat=$zlash_str_repeat$_zlsh_str_repeat_S
            _zlsh_str_repeat_N=$((_zlsh_str_repeat_N - _zlsh_str_repeat_K))
            _zlsh_str_repeat_K=1
            _zlsh_str_repeat_S=$1
        fi
    done
    zlash_str_repeat=$zlash_str_repeat$_zlsh_str_repeat_S
}

zlash_str_slice() {
    if { [ $# != 3 ]                \
            || ! _zlsh_is_vname  "$1"\
            || ! [ "${1+x}" ]         \
            || ! _zlsh_is_digits "$2"  \
            || ! _zlsh_is_digits "$3"; }\
    && { [ $# != 4 ]                     \
            || ! _zlsh_is_vname  "$1"     \
            || ! [ "${1+x}" ]              \
            || ! _zlsh_is_digits "$2"       \
            || ! _zlsh_is_digits "$3"        \
            || ! _zlsh_is_vname  "$4"; }
    then
        _zlsh_usage zlash_str_slice
        return 64
    fi
    _zlsh_str_slice "$1" "$2" "$3" &&\
    if [ $# = 4 ]
    then eval "$4=\$zlash_str_slice"
    else printf '%s\n' "$zlash_str_slice"
    fi
}
_zlsh_str_slice() {
    # OL: original string length
    # SI: slice index
    # SL: slice length
    # TL: (tail) length to chop off (at the end of the original string)
    zlash_str_slice=''                &&\
    _zlsh_str_slice_SI=$2             && \
    eval "_zlsh_str_slice_OL=\${#$1}" || return 1
    # If index is larger or equal to length of the original string, then slice
    # will be empty.
    [ "$2" -lt "$_zlsh_str_slice_OL" ] || return 0
    # Clamp the length of the slice if it is out of bounds.
    if [ "$(($2 + $3))" -gt "$_zlsh_str_slice_OL" ]; then
        _zlsh_str_slice_TL=0 &&\
        _zlsh_str_slice_SL=$((_zlsh_str_slice_OL - $2))
    else
        _zlsh_str_slice_SL=$3 &&\
        _zlsh_str_slice_TL=$((_zlsh_str_slice_OL - $2 - $3))
    fi &&\
    if [ "$_zlsh_str_slice_TL" = "$2" ]; then
        # Symmetric slice.
        if [ "$2" = 0 ]; then
            # No side needs chopping, the slice is the original string.
            eval "zlash_str_slice=\$$1" &&\
            return 0
        else
            # Same length needs to be chopped from both ends.
            _zlsh_str_slice_pat "$2"                                      &&\
            eval "zlash_str_slice=\${$1#$_zlsh_str_slice_pat} &&"            \
                "zlash_str_slice=\${zlash_str_slice%$_zlsh_str_slice_pat}" && \
            return 0
        fi
    elif [ "$2" -lt "$_zlsh_str_slice_TL" ]\
    &&   [ "$2"  !=  0                    ]; then
        # Head to chop is shorter than tail, chopping head off first.
        _zlsh_str_slice_pat "$2"                           &&\
        eval "zlash_str_slice=\${$1#$_zlsh_str_slice_pat}" && \
        _zlsh_str_slice_OL=$((_zlsh_str_slice_OL - $2))    &&  \
        _zlsh_str_slice_SI=0
    elif [ "$_zlsh_str_slice_TL" -lt "$2" ]\
    &&   [ "$_zlsh_str_slice_TL"  !=  0   ]; then
        # Tail to chop is shorter than head, chopping tail off first.
        _zlsh_str_slice_pat "$_zlsh_str_slice_TL"                       &&\
        eval "zlash_str_slice=\${$1%$_zlsh_str_slice_pat}"              && \
        _zlsh_str_slice_OL=$((_zlsh_str_slice_OL - _zlsh_str_slice_TL)) &&  \
        _zlsh_str_slice_TL=0
    else
        # No smaller chopping was done, we need to initialize the work string as
        # if work was done, for the next step.
        eval "zlash_str_slice=\$$1"
    fi &&\
    if [ "$_zlsh_str_slice_TL" = 0 ]; then
        # Head left to chop.  No tail to chop.
        if [ "$_zlsh_str_slice_SI" -le "$_zlsh_str_slice_SL" ]; then
            # Head is shorter or equal slice length, just chop it off.
            _zlsh_str_slice_pat "$_zlsh_str_slice_SI" &&\
            eval "zlash_str_slice=\${zlash_str_slice#$_zlsh_str_slice_pat}"
        else
            # Head is longer than slice lenth. Use double-expansion method to
            # chop it off.
            _zlsh_str_slice_pat "$_zlsh_str_slice_SL" &&\
            eval "zlash_str_slice=\${zlash_str_slice#\"\${zlash_str_slice%$_zlsh_str_slice_pat}\"}"
        fi
    else
        # Tail left to chop.  No head to chop.
        if [ "$_zlsh_str_slice_TL" -le "$_zlsh_str_slice_SL" ]; then
            # Tail is shorter or equal slice length, just chop it off.
            _zlsh_str_slice_pat "$_zlsh_str_slice_TL" &&\
            eval "zlash_str_slice=\${zlash_str_slice%$_zlsh_str_slice_pat}"
        else
            # Tail is longer than slice lenth. Use double-expansion method to
            # chop it off.
            _zlsh_str_slice_pat "$_zlsh_str_slice_SL" &&\
            eval "zlash_str_slice=\${zlash_str_slice%\"\${zlash_str_slice#$_zlsh_str_slice_pat}\"}"
        fi
    fi
}
_zlsh_str_slice_pat() {
    if ! eval "[ \"\${_ZLSH_PAT_ANY_$1+x}\" ]"; then
        _zlsh_str_repeat '?' "$1" &&\
        eval "_ZLSH_PAT_ANY_$1=\$zlash_str_repeat" &&\
        _zlsh_str_slice_pat=$zlash_str_repeat
    else
        eval "_zlsh_str_slice_pat=\$_ZLSH_PAT_ANY_$1"
    fi
}


zlash_byte2deci() {
    if { [ $# != 1 ]              \
            ||   [ ${#1} != 1 ]; } \
    && { [ $# != 2 ]                \
            ||   [ ${#1} != 1 ]      \
            || ! _zlsh_is_vname "$2"; }
    then
        _zlsh_usage zlash_byte2deci
        return 64
    fi
    _zlsh_byte2deci "$1" &&\
    if [ $# = 2 ]
    then eval "$2=\$zlash_byte2deci"
    else printf '%s' "$zlash_byte2deci"
    fi
}
_zlsh_byte2deci() {
    _zlsh_byte2deci_TMP=${ZLASH_BYTE_MAP%%"$1"*}   &&\
    zlash_byte2deci=$((${#_zlsh_byte2deci_TMP}+1)) && \
    [ "$zlash_byte2deci" != 256 ]
}

zlash_deci2byte() {
    # NOTE: Since most shells cannot store a null byte, this public interface
    #   handles null byte for implementation, if no second argument is supplied.
    #   This breaks the pattern all other `zlash_*` function validations, making
    #   it difficult to abstract. Alternatively, we can opt to reject null byte
    #   for all cases.
    if { [ $# != 1 ]                    \
            || ! _zlsh_is_digits "$1"    \
            ||   [   255   -lt   "$1" ]; }\
    && { [ $# != 2 ]                       \
            || ! _zlsh_is_digits "$1"       \
            ||   [   255   -lt   "$1" ]      \
            ||   [     0    =    "$1" ]       \
            || ! _zlsh_is_vname  "$2"; }
    then
        _zlsh_usage zlash_deci2byte
        return 64
    fi
    if [ $# = 1 ]; then
        if [ "$1" = 0 ]
        then printf '\000'
        else
            _zlsh_deci2byte "$1" &&\
            printf '%s' "$zlash_deci2byte"
        fi
    else
        _zlsh_deci2byte "$1" &&\
        eval "$2=\$zlash_deci2byte"
    fi
}
_zlsh_deci2byte() { eval "zlash_deci2byte=\$ZLASH_BYTE_$1"; }

#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
#   Zlash Namespaces
#
zlash_mk_ns() {
    if   [ $# != 1 ] \
             || ! _zlsh_is_vname_sfx "$1"
    then
        zlash_usage zlash_mk_ns
        return 64
    fi
    _zlsh_mk_ns "$@"
}
_zlsh_mk_ns() {
    if _zlsh_is_ns "$1"; then
        _zlsh_q "$1"
        zlash_stderr "ERROR: zlash_dict $zlash_q already exists."
        return 1
    fi
    eval "_ZLSH_NS_LEN__$1=0 && _ZLSH_NS_NAMES__$1=' '"
}

zlash_is_ns() {
    if   [ $# != 1 ] \
    || ! _zlsh_is_vname_sfx "$1"
    then
        zlash_usage zlash_is_ns
        return 64
    fi
    _zlsh_is_ns "$@"
}
_zlsh_is_ns() { eval "[ \${_ZLSH_NS_LEN__$1:+x} ]"; }

zlash_ns_set() {
    if   [ $# != 3 ]           \
    || ! _zlsh_is_vname_sfx "$1"\
    || ! _zlsh_is_ns "$1"        \
    || ! _zlsh_is_vname_sfx "$2"
    then
        zlash_usage zlash_ns_set
        return 64
    fi
    _zlsh_ns_set "$@"
}
_zlsh_ns_set() {
    if _zlsh_in_ns "$1" "$2"; then
        eval "_ZLSH_NS__$1__$2=\$3"
    else
        eval "_ZLSH_NS__$1__$2=\$3 &&"                      \
            " _ZLSH_NS_LEN__$1=\$((_ZLSH_NS_LEN__$1 + 1)) &&"\
            " _ZLSH_NS_NAMES__$1=\$_ZLSH_NS_NAMES__$1\$2' '"
    fi
}

zlash_in_ns() {
    if   [ $# -ne 2 ]          \
    || ! _zlsh_is_vname_sfx "$1"\
    || ! _zlsh_is_ns "$1"        \
    || ! _zlsh_is_vname_sfx "$2"
    then
        zlash_usage zlash_in_ns
        return 64
    fi
    _zlsh_in_ns "$@"
}
_zlsh_in_ns() { eval "[ \${_ZLSH_NS__$1__$2+x} ]"; }

zlash_ns_unset() {
    if   [ $# -ne 2 ]          \
    || ! _zlsh_is_vname_sfx "$2"\
    || ! _zlsh_is_ns "$1"        \
    || ! _zlsh_is_vname_sfx "$2"
    then
        zlash_usage zlash_ns_unset
        return 64
    fi
    _zlsh_ns_unset "$@"
}
_zlsh_ns_unset() {  # portable fallback
    if _zlsh_in_ns "$1" "$2"; then
        eval "_zlsh_ns_unset_NAMES=_ZLSH_NS_NAMES__$1" || return 1
        _zlsh_ns_unset__NAMES=${_zlsh_ns_unset__NAMES%%${_zlsh_ns_unset__NAMES#"$2"}}
        unset -v "_ZLSH_NS__$1__$2" && \
        eval "_ZLSH_NS_LEN__$1=\$((_ZLSH_NS_LEN__$1 - 1)) &&"\
             " _ZLSH_NS_NAMES__$1=\$_ZLSH_NS_NAMES__$1' '$2"
    fi
}

#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
#####  3.1.5.        Variable Reference/Dereference/Copy
# |              |                       |
# |:-------------|:----------------------|
# |`zlash_var_cp`| copy variable by name |
#

zlash_var_cp__DOC__BLURB='
copy variable by name
'
zlash_var_cp__DOC__USAGE='
zlash_var_cp src_vname dst_vname
'
zlash_var_cp__DOC__DESCR='
Copy value of valiable who'\''s name is the first argument into a variable
who'\''s name is the second argument.

Used for dereferencing of namerefs and dynamic assignments. For example, a
dereferencing expansion, then a dereferencing assignment:

```bash
; src="value"
; nameref="src"
; zlash_var_cp $nameref copy && echo "$copy"
# value
; copy="change"
; zlash_var_cp copy $nameref && echo "$src"
# change
```
'
zlash_var_cp() { _zlsh_var_cp "$@"; }
_zlsh_var_cp() {  # portable fallback
    if [ $# -eq 2 ]         \
    && zlash_is_vname "${1-}"\
    && zlash_is_vname "${2-}"
    then
        # Assignment does not word-split, and expands non-recursively.
        eval "$2=\$$1" || return 1
    else
        zlash_usage zlash_var_cp
        return 64
    fi
}
# `_unsafe` variant can be used if arguments are owned or already sanitized.
_unsafe_zlsh_var_cp() { eval "$2=\$$1"; }

#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
#####  3.1.6.        Basic Help Functionality
# |               |                                                |
# |:--------------|:-----------------------------------------------|
# |`zlash_help`   | help in manpage format (justified, hyphenated) |
# |`zlash_help_md`| help in markdown format                        |
#

zlash_help__DOC__BLURB='
show manual for a Zlash topic
'
zlash_help__DOC__USAGE='
zlash_help topic
'
zlash_help__DOC__LINKS='
zlash_help  \
zlash_help_md
'
zlash_help__DOC__NOTES='
*WorkInProgress* implementation currently, in addition to process substitution
shell capability (which is not available in *Dash*), assumes availability of a
number of tools:

  - `pandoc`
  - `groff`
  - `sed`
  - `wc`
  - `stty`
'
# TODO:  Implement `mdoc` renderer, and specialization selector.
# FIXME: Use ZlashConfiguration tooling mechanism, even for the
#        fallback specialization.
zlash_help() { _zlsh_help_FIXME "$@"; }
_zlsh_help_FIXME() {
    # Specializations using `groff` for TTY output should use the
    # `-rLL=${COLUMNS}n` argument.
    zlash_help=
    if   [ $# -ne 1 ] \
    || ! zlash_is_vname "${1-}"
    then
        zlash_usage zlash_help
        return 64
    fi
    zlash_help_md "$1" || return 1
    zlash_posparams_mk_clob _zlsh_help_FIXME_GROFF_ARGS \
        -t -man -T utf8 -P -i -r IN=4n || return 1
    zlash_tty_size || return 1
    if [ -t 1 ]; then
        zlash_posparams_add _zlsh_help_FIXME_GROFF_ARGS \
                            "-rLL=${zlash_tty_cols}n"   || return 1; fi
    zlash_help=$(zlash_null_stderr _zlsh_help_FIXME_helper)$ZLASH_BR \
    || zlash_help=$zlash_help_md$ZLASH_BR                        || return 1
    # If showing on terminal and text is too big, pipe to `less`.
    if [ -t 1 ]                       \
           && zlash_line_count "$zlash_help" \
           && [ "$zlash_tty_rows" -lt "$zlash_line_count" ]
    then
        zlash_echo "$zlash_help" | less -R
    else
        zlash_echo "$zlash_help"
    fi
}
# Pandoc Lua filter to apply during MD to MAN conversion.
# TODO: Pandoc doesn't implement --footnote-location for man output. We should
#   add section-local footnotes functionality to the filter, walking document,
#   noting sections, collection footnotes, and processing them per section.
#   Until then, our doc will emulate that manually with suberscript, a
#   horizontal rule, and ordered list.
# TODO: Currently, Code elements (inline code) line-breaks, hyphenates, and has
#   flexible spaces. It should have none of that.
_zlsh_help_FIXME_LUA_FILTER='
return {
    Header = function (el)
        if FORMAT:match("^man") and el.level == 1 then
            return el:walk {
                Str = function(el)
                    return pandoc.Str(pandoc.text.upper(el.text))
                end
            }
        end
    end,
    Code = function (el)
        if FORMAT:match("^ansi") then
            return pandoc.Strong(el.text)
        elseif FORMAT:match("^man") then
            return pandoc.Strong(el.text)
        end
    end,
    Link = function (el)
        if not el.target:match("^[a-zA-Z][a-zA-Z0-9+.-]*://")
           and (FORMAT:match("^man")) then
            return el.content
        end
        if FORMAT:match("^man") then
            return {
                pandoc.RawInline(FORMAT, "\\X'\''tty: link " ..
                    string.gsub(
                        string.gsub(
                            string.gsub(el.target, " ", "%20"),
                            "\t", "%09"),
                         "\n", "%0A") .. "'\''"),
                pandoc.Span(el.content),
                --(pandoc.Span(el.content):walk {
                --    Str = function (el)
                --        return pandoc.RawInline(
                --            string.gsub(
                --                el.text,
                --                "\\-", "\\&\\-"))
                --    end,
                --}),
                pandoc.RawInline(FORMAT, "\\X'\''tty: link'\''"),
            }
        end
    end,
    Note = function (el)
        if FORMAT:match("^man") or FORMAT:match("^ansi") then
            return {}
        end
    end,
    Superscript = function (el)
        if FORMAT == "man" then
            local text = pandoc.utils.stringify(el.content)
            if text == "1" or text == "2" or text == "3" then
                return pandoc.RawInline(FORMAT, "\\[S"..text.."]")
            else
                return pandoc.Str("["..text.."]")
            end
        end
    end,
    HorizontalRule = function (el)
        if FORMAT:match("^man") then
            return pandoc.RawInline(FORMAT, "\n\\l'\''(\\n(.ln-\\n(.in)/3n'\''")
        end
    end,
}
'
# _zlsh_help_FIXME_helper() {
#     { zlash_echo "$zlash_help_md"                || return 1; }\
#     | { pandoc  --standalone --from=gfm --to=man               \
#                 --lua-filter=<(                                 \
#                     zlash_echo "$_zlsh_help_FIX_ME_LUA_FILTER"    \
#                 )                               || return 1; }    \
#     | { zlash_posparams_apply                                      \
#             _zlsh_help_FIXME_GROFF_ARGS groff   || return 1; }      \
#     | { sed '1d;$d'                             || return 1; }
# }

ZLASH_PANDOC_LUA_PART__Header__lvl1_upper='
if el.level == 1 then
    el = el:walk {
        Str = function(el)
            return pandoc.Str(pandoc.text.upper(el.text))
        end
    }
end
'
ZLASH_PANDOC_LUA_PART__Code__Strong='
el = pandoc.Strong(el.text)
'
ZLASH_PANDOC_LUA_PART__Note__no='
el = {}
'
ZLASH_PANDOC_LUA_PART__Superscript__roff_S123='
local text = pandoc.utils.stringify(el.content)
if text:match("[123]") then
    el = pandoc.RawInline(FORMAT, "\\[S"..text.."]")
end
'
ZLASH_PANDOC_LUA_PART__Link__only_abs='
if not el.target:match("^[a-zA-Z][a-zA-Z0-9+.-]*://") then
    return pandoc.Span(el.content)
end
'
ZLASH_PANDOC_LUA_PART__Link__roff='
if el.target:match("[ \\t\\n'\'']") then
    el = pandoc.Span(el.content)
else
    el = {
        pandoc.RawInline(FORMAT, "\\X'\''tty: link " ..
        pandoc.Span(el.content),
        pandoc.RawInline(FORMAT, "\\X'\''tty: link'\''"),
    }
end
'
ZLASH_PANDOC_LUA_PART__HorizontalRule__roff_third='
el = pandoc.RawInline(FORMAT, "\n\\l'\''(\\n(.ln-\\n(.in)/3n'\''")
'

zlash_help_md__DOC__BLURB='
get help for a Zlash topic in Markdown format
'
zlash_help_md__DOC__USAGE='
zlash_help_md topic && topic_md=$zlash_help_md
'
zlash_help_md__DOC__LINKS=$zlash_help__DOC__LINKS
zlash_help_md() { _zlsh_help_md "$@"; }
_zlsh_help_md() {
    # Specializations should list available topics when no argument is provided
    # (and modify `zlash_help_md__DOC__USAGE` to reflect that change).
    if   [ $# -ne 1 ] \
    || ! zlash_is_fname "${1-}"
    then
        zlash_usage zlash_help_md
        return 64
    fi
    _zlsh_help_md_FUNC=
    zlash_help_md=''

    # TOPIC
    eval "_zlsh_help_DOC=\${${1}__DOC__BLURB-}" || return 1
    if ! [ "${_zlsh_help_DOC-}" ]; then
        zlash_q "$1"
        zlash_stderr "Topic $zlash_q does not exist."
        return 1
    fi
    zlash_trim "$_zlsh_help_DOC"                             &&\
    zlash_help_md='# TOPIC'$ZLASH_BR$ZLASH_BR'***'$1'*** - ' && \
    zlash_help_md=$zlash_help_md$zlash_trim$ZLASH_BR         || return 1

    # SYNOPSIS
    eval "_zlsh_help_DOC=\${${1}__DOC__USAGE-}" || return 1
    if [ "${_zlsh_help_DOC-}" ]; then
        # If topis__DOC__USAGE is set, use it as SYNOPSIS.
        _zlsh_help_md_FUNC=true
        zlash_help_md=$zlash_help_md$ZLASH_BR'# SYNOPSIS'$ZLASH_BR &&\
        zlash_help_md=$zlash_help_md$ZLASH_BR'```bash'             && \
        zlash_help_md=$zlash_help_md$_zlsh_help_DOC'```'$ZLASH_BR  || return 1
    else
        eval "_zlsh_help_DOC=\${${1}__DOC__SYNOPSIS-}" || return 1
        if [ "${_zlsh_help_DOC-}" ]; then
            # If topis__DOC__USAGE is not set, use topic__DOC__SYNOPSIS, if set.
            zlash_help_md=$zlash_help_md$ZLASH_BR'# SYNOPSIS'$ZLASH_BR &&\
            zlash_help_md=$zlash_help_md$_zlsh_help_DOC            || return 1
        fi
    fi

    # DESCRIPTION
    eval "_zlsh_help_DOC=\${${1-}__DOC__DESCR-}" || return 1
    if [ "${_zlsh_help_DOC-}" ]; then
        zlash_help_md=$zlash_help_md$ZLASH_BR'# DESCRIPTION'$ZLASH_BR
        zlash_help_md=$zlash_help_md$_zlsh_help_DOC
    fi

    # 'NOTE'
    eval "_zlsh_help_DOC=\${${1-}__DOC__NOTES-}" || return 1
    if [ "${_zlsh_help_DOC-}" ]; then
        zlash_help_md=$zlash_help_md$ZLASH_BR'# NOTE'$ZLASH_BR
        zlash_help_md=$zlash_help_md$_zlsh_help_DOC
    fi

    # RELATED
    eval "_zlsh_help_DOC=\${${1-}__DOC__LINKS-}" || return 1
    if [ "${_zlsh_help_DOC-}" ]; then
        zlash_help_md=$zlash_help_md$ZLASH_BR'# RELATED'$ZLASH_BR
        zlash_help_md=$zlash_help_md$_zlsh_help_DOC
    fi

    # EXIT CODE
    eval "_zlsh_help_DOC=\${${1-}__DOC__EXIT-}" || return 1
    if [ "${_zlsh_help_DOC-}" ]; then
        # Set empty topic__DOC__EXIT should skip EXIT CODE section.
        if [ ${_zlsh_help_DOC-} ]; then
            zlash_help_md=$zlash_help_md$ZLASH_BR'# EXIT CODE'$ZLASH_BR
            zlash_help_md=$zlash_help_md$_zlsh_help_DOC
        fi
    elif [ ${_zlsh_help_md_FUNC+x} ]; then
        zlash_help_md=$zlash_help_md$ZLASH_BR'# EXIT CODE'$ZLASH_BR$ZLASH_BR
        zlash_help_md=$zlash_help_md'|    |          |'$ZLASH_BR
        zlash_help_md=$zlash_help_md'|---:|:---------|'$ZLASH_BR
        zlash_help_md=$zlash_help_md'| `0`| Success. |'$ZLASH_BR
        zlash_help_md=$zlash_help_md'|`>0`| Failure. |'$ZLASH_BR
    fi
    unset -v _zlsh_help_DOC _zlsh_help_md_FUNC
}

zlash_docsec__DOC__BLURB='
get a section of a documentation topic
'
zlash_docsec__DOC__USAGE='
zlash_docsec topic section && doc=$zlash_docsec
'
zlash_docsec__DOC__DESCR='
If the section of the documentation topic exists, stores it in the
`zlash_docsec` variable.

On failure, `zlash_docsec` variable is undefined.
'
zlash_docsec() { _zlsh_docsec "$@"; }
_zlsh_docsec() {  # portable fallback
    zlash_docsec= || return 1
    if   [ $# -ne 2 ]              \
    || ! zlash_is_vname     "${1-}" \
    || ! zlash_is_vname_sfx "${2-}"
    then
        zlash_usage zlash_docsec
        return 64
    fi
    eval "zlash_docsec=\${$1__DOC__$2-}" &&\
    [ "${zlash_docsec-}" ]               && \
    zlash_trim "$zlash_docsec"           &&  \
    zlash_docsec=$zlash_trim
}

zlash_usage__DOC__BLURB='
show usage of a function
'
zlash_usage__DOC__USAGE='
zlash_usage fname
'
zlash_usage__DOC__DESCR='
Output usage of a function named by the first argument to *STDERR*.
'
zlash_usage() { _zlsh_usage "$@"; }
_zlsh_usage() {  # portable fallback
    zlash_usage= || return 1
    if [ $# -eq 1 ]                \
    && zlash_is_fname "${1-}"       \
    && {   zlash_docsec "$1" USAGE   \
        || zlash_docsec "$1" SYNTAX   \
        || zlash_docsec "$1" SYNOPSIS; }
    then :
    else
        zlash_usage zlash_usage
        return 64
    fi
    zlash_usage='# '$zlash_docsec
    zlash_stderr "$zlash_usage"
}

man() {
    if [ $# -eq 2 ]          \
    && zlash_is_digits "$1"   \
    || { [ $# -eq 1 ]          \
        && { zlash_is_vname "$1"\
            || [ -r "$1" ];     }\
    }\
    && _zlsh_man_FILE=$(zlash_null_stderr command man -w "$@")   \
    && zlash_posparams_mk_clob _zlsh_man_GROG_ARGS                \
        -k -T utf8 -P -i -W font -r LL=${ZLASH_CFG_MAN_LL:-100}n - \
    && _zlsh_man_GROFF=$(
        cat "$_zlsh_man_FILE" \
        | zcat  --force        \
        | zlash_posparams_apply _zlsh_man_GROG_ARGS grog
    )\
    && _zlsh_man_PAGE=$(
        cat "$_zlsh_man_FILE" \
        | zcat --force         \
        | eval "${_zlsh_man_GROFF}"
    )\
    && { printf '%s\n' "$_zlsh_man_PAGE" | zlash_man_pager; }
    then
        unset -v _zlsh_man_FILE _zlsh_man_GROFF
    else
        command man "$@"
    fi
}

# panman() {
#     pandoc -s -t man --lua-filter=<(
#         printf %s\\n "$_zlsh_help_FIXME_LUA_FILTER") "$@"                   \
#     | groff -t -man -k -T utf8 -P -i -r LL=${ZLASH_CFG_MAN_LL:-100}n -W all -\
#     | zlash_man_pager
# }

zlash_man_pager() {
    if [ -t 1 ]; then
        if [ "${MANPAGER+x}" ]; then
            $MANPAGER "$@"
        elif [ "${PAGER+x}" ]; then
            $PAGER "$@"
        else
            less -sRF "$@"
        fi
    else
        cat "$@"
    fi
}

#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
#####  3.1.7.        Basic String Manipulation
#

zlash_trim__doc__='
Remove prefix and suffix whitespaces from a string

Removes all leading and trailing whitespace from a string, storing the result in
`zlash_trimed` variable.

On failure, `zlash_trimmed` variable is undefined.
'
zlash_trim__args__=str
zlash_trim() {
    if [ $# -ne 1 ]; then
        _zlsh_usage zlash_trim
        return 64
    fi
    _zlsh_trim "$@"
}
_zlsh_trim() {
    zlash_trimmed=${1#"${1%%[![:space:]]*}"} &&\
    zlash_trimmed=${zlash_trimmed%"${zlash_trimmed##*[![:space:]]}"}
}

zlash_trim_head() {
    if [ $# -ne 1 ]; then
        _zlsh_usage zlash_trim_head
        return 64
    fi
    _zlsh_trim_head "$@"
}
_zlsh_trim_head() {
    zlash_trimmed=${1#"${1%%[![:space:]]*}"}
}

zlash_trim_tail() {
    if [ $# -ne 1 ]; then
        _zlsh_usage zlash_trim_tail
        return 64
    fi
    _zlsh_trim_tail "$@"
}
_zlsh_trim_tail() {
    zlash_trimmed=${1%"${1##*[![:space:]]}"}
}

# TODO: Convert this to use `zlash_foreach_line`, after that's implemented.
zlash_line_count__DOC__BLURB='
count number of lines in a string
'
zlash_line_count__DOC__USAGE='
zlash_line_count str_vname count_vname
'
zlash_line_count__DOC__DESCR='
Count number of lines in a string (stored in variable who'\''s name is passed as
the first argument) and store the resulting a variable who'\''s name is passed
as the second argument.
'
zlash_line_count() {
    if   [ $# -ne 2 ]      \
    || ! _zlsh_is_vname "$1"\
    || ! _zlsh_is_vname "$2"
    then
        _zlsh_usage zlash_line_count
        return 64
    fi
    _zlsh_line_count "$1" &&\
    eval "$2=\$zlash_line_count"
}
_zlsh_line_count() {
    zlash_line_count=0     &&\
    zlash_foreach_line_in "$1"\
        eval 'zlash_line_count=$((zlash_line_count + 1))'
}

zlash_foreach_line_in__DOC__BLURB='
for each line in a variable, eval a command
'
zlash_foreach_line_in__DOC__USAGE='
zlash_foreach_line_in vname eval "singleline=\$ZLASH_EL"
'
zlash_foreach_line_in__DOC__DESCR='
For each line in a variable (named by the `vname` [first] argument), evaluate a
command (the [third] argument), during evaluation of which `ZLASH_EL`
variable is set to the current line string.

The second argument must allways be a string: `eval` (to avoid confusion). If it
is not, `zlash_foreach_line_in` function will fail with incorrect usage error.
'
zlash_foreach_line_in() {
    if   [  $# -ne  3     ]\
    ||   [ "$2" != 'eval' ] \
    || ! _zlsh_is_vname "$1"
    then
        _zlsh_usage zlash_foreach_line_in
        return 64
    fi
    _zlsh_foreach_line_in "$1" "$3"
}
_zlsh_foreach_line_in() {
    ZLASH_EL=                &&\
    _zlsh_foreach_line_in=$1 || return 1
    while true; do
        case $_zlsh_foreach_line_in in
            *"$ZLASH_BR"*) :;;
            *) ZLASH_EL=$_zlsh_foreach_line_in || return 1; break;;
        esac
        ZLASH_EL=${_zlsh_foreach_line_in%%"$ZLASH_BR"*}             &&\
        _zlsh_foreach_line_in=${_zlsh_foreach_line_in#*"$ZLASH_BR"} && \
        eval "$2" || return $?
    done
    eval "$2" &&\
    unset -v _zlsh_foreach_line_in
}

zlash_lower__DOC__BLURB='convert string to lower-case'
zlash_lower__DOC__USAGE='
zlash_lower str vname
'
zlash_lower__DOC__DESCR='
Convert supplied string to lower-case.

The second argument is a variable name the result is assigned to.

When the shell does not natively support text case modification, the fallback is
using the 6th bit of *ASCII* representation of characters that match
`[[:alpha:]]` pattern.
'
zlash_lower() {
    if   [ $# -ne 2 ] \
    || ! _zlsh_is_vname "$2"
    then
        _zlsh_usage zlash_lower
        return 64
    fi
    _zlsh_lower "$1" &&\
    eval "$2=\$zlash_lower"
}
_zlsh_lower() {
    zlash_lower=      && _zlsh_lower_1=$1  &&\
    _zlsh_lower_HEAD= && _zlsh_lower_TAIL= && \
    _zlsh_lower_CHAR= && _zlsh_lower_CODE= &&  \
    _zlsh_lower_TMEP= || return 1
    while [ "$_zlsh_lower_1" ]; do
        case $_zlsh_lower_1 in
            *[[:alpha:]]*) :;;
            *)  zlash_lower=$zlash_lower$_zlsh_lower_1 || return 1
                break;;
        esac
        _zlsh_lower_TAIL=${_zlsh_lower_1#*[[:alpha:]]}           &&\
        _zlsh_lower_TEMP=${_zlsh_lower_1%%"$_zlsh_lower_TAIL"}   && \
        _zlsh_lower_HEAD=${_zlsh_lower_TEMP%[[:alpha:]]}         &&  \
        _zlsh_lower_CHAR=${_zlsh_lower_TEMP#"$_zlsh_lower_HEAD"} &&   \
        _zlsh_lower_1=$_zlsh_lower_TAIL                          &&    \
        _zlsh_lower_CODE=$(printf '%d\n' "'$_zlsh_lower_CHAR")   || return 1
        if [ $((_zlsh_lower_CODE & 0x20)) -ne 0 ]; then
            zlash_lower=$zlash_lower$_zlsh_lower_HEAD$_zlsh_lower_CHAR \
                || return 1
        else
            zlash_lower=$zlash_lower$_zlsh_lower_HEAD$(
                printf "\\$(printf '%o\n' $((_zlsh_lower_CODE | 0x20)))\\n"
            ) || return 1
        fi
    done
}

zlash_upper__DOC__BLURB='convert string to upper-case'
zlash_upper__DOC__USAGE='
zlash_upper str vname
'
zlash_upper__DOC__DESCR='
Convert supplied string to upper-case.

The second argument is a variable name the result is assigned to.

When the shell does not natively support text case modification, the fallback is
using the 6th bit of *ASCII* representation of characters that match
`[[:alpha:]]` pattern.
'
zlash_upper() {
    if   [ $# -ne 2 ] \
    || ! _zlsh_is_vname "$2"
    then
        _zlsh_usage zlash_upper
        return 64
    fi
    _zlsh_upper "$1" &&\
    eval "$2=\$zlash_upper"
}
_zlsh_upper() {
    zlash_upper=      && _zlsh_upper_1=$1  &&\
    _zlsh_upper_HEAD= && _zlsh_upper_TAIL= && \
    _zlsh_upper_CHAR= && _zlsh_upper_CODE= &&  \
    _zlsh_upper_TMEP= || return 1
    while [ ${_zlsh_upper_1:+x} ]; do
        case $_zlsh_upper_1 in
            *[[:alpha:]]*) :;;
            *)  zlash_upper=$zlash_upper$_zlsh_upper_1 || return 1
                break;;
        esac
        _zlsh_upper_TAIL=${_zlsh_upper_1#*[[:alpha:]]}           &&\
        _zlsh_upper_TEMP=${_zlsh_upper_1%%"$_zlsh_upper_TAIL"}   && \
        _zlsh_upper_HEAD=${_zlsh_upper_TEMP%[[:alpha:]]}         &&  \
        _zlsh_upper_CHAR=${_zlsh_upper_TEMP#"$_zlsh_upper_HEAD"} &&   \
        _zlsh_upper_1=$_zlsh_upper_TAIL                          &&    \
        _zlsh_upper_CODE=$(printf '%d\n' "'$_zlsh_upper_CHAR")   || return 1
        if [ $((_zlsh_upper_CODE & 0x20)) -eq 0 ]; then
            zlash_upper=$zlash_upper$_zlsh_upper_HEAD$_zlsh_upper_CHAR \
                || return 1
        else
            zlash_upper=$zlash_upper$_zlsh_upper_HEAD$(
                printf "\\$(printf '%o\n' $((_zlsh_upper_CODE - 0x20)))\\n"
            ) || return 1
        fi
    done
}

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

#-----------------------
_ZLSH_SYMPY_BOOL_PFX='
import sys
from sympy import sympify, Not, simplify_logic
form=sys.argv[1]
if form != "dnf" and form != "cnf":
    form = None
if len(sys.argv) > 2:
    expr = sympify(sys.argv[2], evaluate=False)
else:
    expr = sympify(sys.stdin.read().strip(), evaluate=False)
'
_ZLSH_SYMPY_BOOL_NEGATE=$_ZLSH_SYMPY_BOOL_PFX'
print(simplify_logic(Not(expr), form=form, deep=True, force=True))
'
_ZLSH_SYMPY_BOOL_SIMPLIFY=$_ZLSH_SYMPY_BOOL_PFX'
print(simplify_logic(expr, form=form, deep=True, force=True))
'
# _zlsh_bool_expr_negate() {
#     python3 <(printf '%s\n' "$_ZLSH_SYMPY_BOOL_NEGATE") '' "$@"
# }
# _zlsh_bool_expr_negate_dnf() {
#     python3 <(printf '%s\n' "$_ZLSH_SYMPY_BOOL_NEGATE") dnf "$@"
# }
# _zlsh_bool_expr_negate_cnf() {
#     python3 <(printf '%s\n' "$_ZLSH_SYMPY_BOOL_NEGATE") cnf "$@"
# }
# _zlsh_bool_expr_simplify() {
#     python3 <(printf '%s\n' "$_ZLSH_SYMPY_BOOL_SIMPLIFY") '' "$@"
# }
# _zlsh_bool_expr_simplify_dnf() {
#     python3 <(printf '%s\n' "$_ZLSH_SYMPY_BOOL_SIMPLIFY") dnf "$@"
# }
# _zlsh_bool_expr_simplify_cnf() {
#     python3 <(printf '%s\n' "$_ZLSH_SYMPY_BOOL_SIMPLIFY") cnf "$@"
# }

# _ZLSH_SYMPY_MATH_SIMPLIFY='
# import sys
# from sympy import sympify, simplify
# if len(sys.argv) > 1:
#     expr = sympify(sys.argv[1], evaluate=False)
# else:
#     expr = sympify(sys.stdin.read().strip(), evaluate=False)
# print(simplify(expr))
# '
# _zlsh_math_expr_simplify() {
#     python3 <(printf '%s\n' "$_ZLSH_SYMPY_MATH_SIMPLIFY") "$@"
# }

#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
#####  3.1.8.        Lower-Level Iterators
#
about_zlash_itr__DOC__BLURB='
About Lower-Level Zlash Iterators
'
about_zlash_itr__DOC__DESCR='
The `zlash_itr_*` set of functions enables a generic and *POSIX-compliant* and
portable iteration of Zlash collections in the iteration execution context.

(TODO: explain more)
'

zlash_itr_is__DOC__BLURB='
check if an iterator exists
'
zlash_itr_is__DOC__USAGE='
zlash_itr_is name
'
zlash_itr_is() { _zlsh_itr_is "$@"; }
_zlsh_itr_is() {  # portable fallabck specialization
    if [ $# -ne 1 ] || ! zlash_is_vname_sfx "${1-}"; then
        zlash_echo "USAGE: $zlash_itr_is__DOC__USAGE" >&2
        return 64
    fi
    eval "[ \${_ZLSH_ITR_NXT_${1}+x} ]"
}

zlash_itr_mk__DOC__BLURB='
make a new iterator
'
zlash_itr_mk__DOC__USAGE='
zlash_itr_mk name action
'
zlash_itr_mk() { _zlsh_itr_mk "$@"; }
_zlsh_itr_mk() {  # portable fallabck specialization
    if [ $# -ne 2 ] || ! zlash_is_vname_sfx "${1-}"; then
        zlash_echo "USAGE: $zlash_itr_mk__DOC__USAGE" >&2
        return 64
    fi
    if zlash_itr_is "$1"; then
        zlash_q "$1"
        zlash_echo "ERROR: zlash_itr $zlash_q already exists"\! >&2
        return 1
    fi
    eval "_ZLSH_ITR_NXT_${1}=\$2   &&"\
        " _ZLSH_ITR_PRV_${1}=false &&" \
        " _ZLSH_ITR_MUT_${1}=false &&"  \
        " _ZLSH_ITR_FIN_${1}=true"
}

zlash_itr_rm__DOC__BLURB='
remove an existing iterator
'
zlash_itr_rm__DOC__USAGE='
zlash_itr_rm name
'
zlash_itr_rm() { _zlsh_itr_rm "$@"; }
_zlsh_itr_rm() {  # portable fallabck specialization
    if [ $# -ne 1 ] || ! zlash_is_vname_sfx "${1-}"; then
        zlash_echo "USAGE: $zlash_itr_rm__DOC__USAGE" >&2
        return 64
    fi
    if zlash_itr_is "$1"; then
        zlash_q "$1"
        zlash_echo "ERROR: zlash_itr $zlash_q already exists"\! >&2
        return 1
    fi
    _zlsh_itr_rm_FIN="_ZLSH_ITR_FIN_${1}"
    if ! eval "$_zlsh_itr_rm_FIN"; then
        zlash_q "$1"
        zlash_echo "ERROR: zlash_itr $zlash_q failed cleanup"\! >&2
        return 1
    fi
    unset -v _zlsh_itr_rm_FIN \
      "_ZLSH_ITR_NXT_${1}" "_ZLSH_ITR_PRV_${1}_CURR"\
      "_ZLSH_ITR_${1}_PREV" "_ZLSH_ITR_${1}_CHNG" \
      "_ZLSH_ITR_${1}_CLNP"  
}



#  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -
#####  3.1.9.        Portable Positional Parameters Storage Functionality
#
# Positional parameters `$1`-`$9`, special patameters `$@`, `$*`, and `$#`,
# along with `shift` and `set -- ...` functions, are the only array-related
# functionality guaranteed by the *POSIX* standard.
#
# This, together with `zlash_q` non-interpolative quoting is utilized to store
# positional parameters for later retrival, enabling a method of working with
# multiple arrays in a portable manner.
#
# In particular, this method is used to bootstrap ZlashSettings parameter
# parsing, which is needed prior we begin shell capabilities probing.
#
# |                     |                                                     |
# |:--------------------|:----------------------------------------------------|
# |`zlash_posparams_mk` | new positional parameters store                     |
# |`zlash_posparams_cp` | copy positional parameters store                    |
# |`zlash_posparams_rm` | remove positional parameters store                  |
# |`zlash_posparams_add`| add parameters to a positional parameters store     |
# |`zlash_posparams_src`|source for setting positional parameters from a store|
#

zlash_posparams_mk__DOC__BLURB='
create a new positional parameters store
'
zlash_posparams_mk__DOC__USAGE='
zlash_posparams_mk  name [param ...]
zlash_posparams_add name [param ...]
zlash_posparams_mk  name "$@"
zlash_posparams_src name && eval "$zlash_posparams_src"
zlash_posparams_cp  src_name dst_name
zlash_posparams_rm  name
'
zlash_posparams_mk__DOC__DESCR='

'
zlash_posparams_mk() { _zlsh_posparams_mk "$@"; }
_zlsh_posparams_mk() {  # portable fallback
    if   [ $# -lt 1 ] \
    || ! zlash_is_vname_sfx "${1-}"
    then
        zlash_usage zlash_posparams_mk
        return 1
    fi
    eval _zlsh_posparams_NAME=\$1 || return 1
    if zlash_posparams_is "$1"
    then
        zlash_q "$1" &&\
            zlash_echo "ERROR: zlash_posparams $zlash_q already exists!" >&2
        return 1
    fi
    eval "_ZLSH_POSPARAMS_$1=''" || return 1
    if [ $# -gt 1 ]; then
        zlash_posparams_add "$@"; fi
}

zlash_posparams_mk_clob() {
    if   [ $# -lt 1 ] \
    || ! zlash_is_vname_sfx "${1-}"
    then
        zlash_usage zlash_posparams_mk_clob
        return 1
    fi
    if  zlash_posparams_is "$1"; then
        zlash_posparams_rm "$1" || return 1; fi
    zlash_posparams_mk "$@"
}

zlash_posparams_is() { _zlsh_posparams_is "$@"; }
_zlsh_posparams_is() {  # portable fallback
    if [ $# -ne 1 ] || ! zlash_is_vname_sfx "${1-}"
    then
        zlash_usage zlash_posparams_is
        return 1
    fi
    eval "[ \${_ZLSH_POSPARAMS_${1}+x} ]"
}

zlash_posparams_cp() { _zlsh_posparams_cp "$@"; }
_zlsh_posparams_cp() {  # portable fallback
    if ! zlash_is_vname_sfx "${1-}" \
    || ! zlash_is_vname_sfx "${2-}"  \
    ||   [ $# -ne 2 ]
    then
        zlash_usage zlash_posparams_cp
        return 1
    fi
    if ! zlash_posparams_is "$1"
    then
        zlash_q "$1" &&\
        zlash_echo  "ERROR: zlash_posparams $zlash_q does not exist!" >&2
        return 1
    fi
    eval "_ZLSH_POSPARAMS_$2=\$_ZLSH_POSPARAMS_$1"
}

zlash_posparams_rm() { _zlsh_posparams_rm "$@"; }
_zlsh_posparams_rm() {  # portable fallback
    if   [ $# -ne 1 ] \
    || ! zlash_is_vname_sfx "${1-}"
    then
        zlash_usage zlash_posparams_rm
        return 1
    fi
    if ! zlash_posparams_is "$1"
    then
        zlash_q "$1" &&\
        zlash_echo  "ERROR: zlash_posparams $zlash_q does not exist!" >&2
        return 1
    fi
    unset -v "_ZLSH_POSPARAMS_$1"
}

zlash_posparams_add() { _zlsh_posparams_add "$@"; }
_zlsh_posparams_add() {  # portable fallback
    if   [ $# -lt 2 ] \
    || ! zlash_is_vname_sfx "${1-}"
    then
        zlash_echo "USAGE: zlash_posparams_add name arg [arg ...]" >&2
        return 1
    fi
    if ! zlash_posparams_is "$1"
    then
        zlash_q "$1"
        zlash_echo  "ERROR: zlash_posparams $zlash_q does not exist!" >&2
        return 1
    fi
    _zlsh_posparams_SELF=_ZLSH_POSPARAMS_$1 && shift || return 1
    while [ ${1+x} ]; do
        # Single-quote and append argument, separated by space.
        zlash_q "$1"                                                      \
        && eval "$_zlsh_posparams_SELF=\$$_zlsh_posparams_SELF\\ \$zlash_q"\
        && shift                                                            \
        || return 1
    done
    unset -v _zlsh_posparams_SELF
}

zlash_posparams_src() { _zlsh_posparams_src "$@"; }
_zlsh_posparams_src() {  # portable fallback
    zlash_posparams_src= || return 1
    if   [ $# -ne 1 ] \
    || ! zlash_is_vname_sfx "${1-}"
    then
        zlash_usage zlash_posparams_src
        return 1
    fi
    if ! zlash_posparams_is "$1"
    then
        zlash_q "$1"
        zlash_echo  "Error: zlash_posparams $zlash_q does not exist!" >&2
        return 1
    fi
    eval _zlsh_posparams_SELF=\$_ZLSH_POSPARAMS_$1     &&\
    zlash_posparams_src="set -- $_zlsh_posparams_SELF" && \
    unset -v _zlsh_posparams_SELF
}

zlash_posparams_apply__DOC__USAGE='
zlash_posparams_apply name cmd
'
zlash_posparams_apply() { _zlsh_posparams_apply "$@"; }
_zlsh_posparams_apply() {  # portable fallback
    if ! zlash_posparams_is "${1-}" \
    || ! [ "${2-}"  ]                \
    ||   [ $# -ne 2 ]
    then
        zlash_usage zlash_posparams_apply
        return 1
    fi
    zlash_q "$2" && _zlsh_posparams_apply_CMD="$zlash_q"    &&\
    zlash_posparams_src "$1" && eval "$zlash_posparams_src" && \
    eval "$_zlsh_posparams_apply_CMD" "$@"                  &&  \
    unset -v _zlsh_posparams_apply_CMD
}

ZlashSetting() { _ZlshSetting "$@"; }
_ZlshSetting() {  # portable bootstrapping specialization
    _ZlshSetting_NAME=
    _ZlshSetting_VALQS=
    _ZlshSetting_LIST=false
    _ZlshSetting_EXPORTED=false
    while [ ${1+x} ]; do
        case $1 in
            -*) :;;
            *)
                if [ "${_ZlshSetting_NAME-}" ]; then
                    zlash_q "$1"
                    _ZlshSetting_VALQS=$_ZlshSetting_VALQS$(
                        printf ' %s\n' "$zlash_q")
                else
                    if zlash_is_vname_sfx "$1"
                    then _ZlshSetting_NAME=ZLASH_$1
                    else :
                    fi
                fi
            ;;
        esac
    done
}

zlash_igen() { _zlsh_igen "$@"; }
_zlsh_igen() {  # portable fallback
    :
}

# _zlsh_init() {
#     ZLASH_VERSION=0.1

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#### 3.2.    Bootstrapping Capability Probes
#
# `_zlsh_probe_`-prefixed, all POSIX-compliant no-argument silent static
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
# Capability names are test function names with `_zlsh_probe_` prefix
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

zlash_cap() {
    :
}

##### 3.1.1. Subshell Behavior Probes
#

# Reset OUT reporting variables. (also a capabilities testing observability point)
zlash_probe_fixture() {

    # A short description and/or example snippet of capability.
    ZLASH_DOC=''

    # Capability dependencies (space separated) for finding a more
    # fundamental failing capability on failure.
    ZLASH_REQ=''

    # Capability provisions on success (space separated).
    # TODO: explain format and use.
    ZLASH_FOR=''
}

    # Subshell execution environment should isolated from enclosing execution
    # environment.
    _zlsh_probe_sh_subsh_env() {
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
    _zlsh_probe_sh_subsh_ret() {
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

    _zlsh_probe_sh_truefalse() {
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
    if ! _zlsh_probe_sh_truefalse; then
        true()  { return 0; }
        false() { return 1; }
    fi

##### 3.1.2. Unset Behavior
#
# see: https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#unset
#
    # Unsafe means arguments must be either controlled or sanitized.
    # Used to test variations of variable removal.
    _unsafe__zlsh_probe_sh_rm_var() {
        (
            _ZLASH_VAR='OK'                    \
                && [ "${_ZLASH_VAR:-}" = 'OK' ] \
                && eval "$1 _ZLASH_VAR"          \
                && [ "${_ZLASH_VAR:-}" = '' ]
        )
    }

    # `unset` variable delition capability.
    _zlsh_probe_sh_unset() {
        zlash_captest_fixture
        ZLASH_CAPDSC='unset VAR  # removes variable `VAR`'
        ZLASH_CAPFOR='rm_var_cmd'

        if _unsafe__zlsh_probe_sh_rm_var 'unset'; then
            ZLASH_CAP_SH_UNSET=true
        else
            ZLASH_CAP_SH_UNSET=false
            return 1
        fi
    } >/dev/null 2>&1

    # `unset -v` explicit variable deletion capability.
    _zlsh_probe_sh_unset_v() {
        zlash_captest_fixture
        ZLASH_CAPDSC='unset -v VAR  # removes variable `VAR`'
        ZLASH_CAPFOR='rm_var_cmd'

        if _unsafe__zlsh_probe_sh_rm_var 'unset -v'; then
            ZLASH_CAP_SH_UNSET_V=true
        else
            ZLASH_CAP_SH_UNSET_V=false
            return 1
        fi
    } >/dev/null 2>&1

    # Provides $ZLASH_CMD_RM_VAR on success.
    _zlsh_probe_cmd_rm_var() {
        zlash_captest_fixture
        ZLASH_CAPDSC='$ZLASH_CMD_RM_VAR VAR  # remove variable VAR'

        # Prefer the explicit variants.
        if ${ZLASH_CAP_SH_UNSET_V:-false} \
        ||   _zlsh_probe_sh_unset_v
        then
            ZLASH_CMD_RM_VAR='unset -v'
        elif ${ZLASH_CAP_SH_UNSET:-false} \
        ||     _zlsh_probe_sh_unset
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
    _zlsh_probe_rm_fun_unset_f() {
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
    _zlsh_probe_rm_fun_unset() {
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
    _zlsh_probe_cmd_rm_fun() {
        zlash_captest_fixture
        ZLASH_CAPDSC='$ZLASH_CMD_RM_FUN fun  # removes function `fun`'

        # Prefer explicit.
        if [ "${ZLASH_CAP_RM_FUN_UNSET_F:-}" = 'true' ] \
        || _zlsh_probe_rm_fun_unset_f
        then
            ZLASH_CMD_RM_FUN='unset -f'
        elif [ "${ZLASH_CAP_RM_FUN_UNSET:-}" = 'true' ] \
        || _zlsh_probe_rm_fun_unset
        then
            ZLASH_CMD_RM_FUN='unset'
        else
            ZLASH_CAP_CMD_RM_FUN=false
            return 1
        fi
        ZLASH_CAP_CMD_RM_FUN=true
    } >/dev/null 2>&1

##### 3.1.4. Namespaces

    _zlsh_probe_sh_ns_funvar_distinct() {
        zlash_captest_fixture
        ZLASH_CAPDSC='Namespace is not shared between functions and variables'

        (f () { :; }; f=; f)
    } >/dev/null 2>&1

##### 3.1.3. Local Variables?

    _unsafe__zlsh_probe_sh_local_var() {
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

    _zlsh_probe_sh_local() {
        zlash_captest_fixture
        if _unsafe__zlsh_probe_local 'local'; then
            ZLASH_CAP_SH_LOCAL=true
        else
            ZLASH_CAP_SH_LOCAL=false
            return 1
        fi
    } >/dev/null 2>&1

    _zlsh_probe_sh_local_declare() {
        zlash_captest_fixture
        if _unsafe__zlsh_probe_local 'declare'; then
            ZLASH_CAP_SH_LOCAL_DECLARE=true
        else
            ZLASH_CAP_SH_LOCAL_DECLARE=false
            return 1
        fi
    } >/dev/null 2>&1

    _zlsh_probe_sh_local_typeset() {
        zlash_captest_fixture
        if _unsafe__zlsh_probe_local 'typeset'; then
            ZLASH_CAP_SH_LOCAL_TYPESET=true
        else
            ZLASH_CAP_SH_LOCAL_TYPESET=false
            return 1
        fi
    } >/dev/null 2>&1

    # Provides $ZLASH_CMD_LOCAL_VAR on success.
    _zlsh_probe_cmd_local_var() {
        zlash_captest_fixture
        ZLASH_CAPDSC='$ZLASH_CMD_LOCAL_VAR var  # declare function-local `var`'

        # `local` is most specific. `typeset` is most portable.
        if ${ZLASH_CAP_SH_LOCAL:-false} \
        ||   _zlsh_probe_sh_local
        then
            ZLASH_CMD_LOCAL_VAR='local'
        elif ${ZLASH_CAP_SH_LOCAL_DECLARE:-false} \
        ||     _zlsh_probe_sh_local_declare
        then
            ZLASH_CMD_LOCAL_VAR='declare'
        elif ${ZLASH_CAP_SH_LOCAL_TYPESET:-false} \
        ||     _zlsh_probe_sh_local_typeset
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

    _zlsh_probe_sh_altfundef() {
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

    _zlsh_probe_sh_mixfundef() {
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

    _unsafe__zlsh_probe_global_var() {
        ZLASH_CAPREQS='cmd_local_var'

        ${ZLASH_CAP_CMD_LOCAL_VAR:-false} \
            || _zlsh_probe_cmd_local_var     \
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
    _zlsh_probe_ixarr_declare_a() {
        _unsafe_test_cap_ixarr 'declare -a'
    } >/dev/null 2>&1

    # `delcare -a ARR` sets zero-based indexed array attribute on variable ARR.
    _zlsh_probe_ixarr_typeset_a() {
        _unsafe_test_cap_ixarr 'typeset -a'
    } >/dev/null 2>&1

    _zlsh_probe_ixarr() {
        _zlsh_probe_ixarr_declare_a \
            || _zlsh_probe_ixarr_typeset_a
    } >/dev/null 2>&1

    if _zlsh_probe_ixarr_declare_a; then
        :
    fi

##### 3.1.1 How does shell report type of a command?

    # Bash and Ksh variants
    _zlsh_probe_builtin_type_ta() {
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
    _zlsh_probe_builtin_whence_wa() {
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

    _zlsh_probe_builtin_lists_builtins() {
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
        if _zlsh_probe_builtin_type_ta; then
            _unsefe_test_word_isa() {
                case "$(type -ta "$1")" in
                    *"$2"*) return 0;;
                    *) return 1;;
                esac
            }
        elif _zlsh_probe_builtin_whence_wa; then
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

    _zlsh_probe_keyword_is_keyword() {
        ZLASH_CAPDSC='keywords like "if" are "keyword"'
        ZLASH_CAPREQS=""
        _unsefe_test_word_isa if keyword
    } >/dev/null 2>&1

    _zlsh_probe_keyword_is_reserved() {
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
    if _zlsh_probe_builtin_lists_builtins; then
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
    if _zlsh_probe_keyword_is_keyword; then
        _unsefe_test_word_isa_keyword() {
            _unsefe_test_word_isa "$1" keyword
        }
    elif _zlsh_probe_keyword_is_reserved; then
        _unsefe_test_word_isa_keyword() {
            _unsefe_test_word_isa "$1" reserved
        }
    else
        _unsefe_test_word_isa_keyword() {
            _unsefe_test_word_isa "$1" reserved
        }
    fi

    _zlsh_probe_echo_builtin() {
        ZLASH_CAPDSC='"echo" is a builtin'
        ZLASH_CAPREQS=""
        _unsefe_test_word_isa_builtin echo
    } >/dev/null 2>&1

    _zlsh_probe_printf_builtin() {
        ZLASH_CAPDSC='"printf" is a builtin'
        ZLASH_CAPREQS=""
        _unsefe_test_word_isa_builtin printf
    } >/dev/null 2>&1

    _zlsh_probe_enable_builtin() {
        ZLASH_CAPDSC='"enable" is a builtin'
        ZLASH_CAPREQS=""
        _unsefe_test_word_isa_builtin enable
    } >/dev/null 2>&1

    _zlsh_probe_builtin_builtin() {
        ZLASH_CAPDSC='"builtin" is a builtin'
        ZLASH_CAPREQS=""
        _unsefe_test_word_isa_builtin builtin
    } >/dev/null 2>&1

    # Ksh-like way of builtin disabling
    _zlsh_probe_rm_builtin_d() {
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
                FAILED) ! _zlsh_probe_echo_builtin && return 0;;
            esac
            return 1
        )
    } >/dev/null 2>&1

    # Bash-like way of builtin disabling
    _zlsh_probe_rm_builtin_enable_n() {
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
                FAILED) ! _zlsh_probe_echo_builtin && return 0;;
            esac
            return 1
        )
    } >/dev/null 2>&1

    # Bash and Zsh do this, but not Ksh variants.
    _zlsh_probe_builtin_calls_builtins() {
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
    _zlsh_probe_command_calls_builtins() {
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
    _zlsh_probe_double_braket_str_eq() {
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
    _zlsh_probe_double_braket_str_pat() {
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

    _zlsh_probe_builtin_calls_builtin() {
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
    _zlsh_probe_printf_q() {
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

    # `printf` to a variable.
    _zlsh_probe_printf_to_var() {
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
    _zlsh_probe_exp_indirect_naked() {
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
    _zlsh_probe_exp_indirect_bang() {
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
    _zlsh_probe_exp_indirect_P() {
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
    _zlsh_probe_return_override() {
        _unsefe_test_word_isa_builtin return && \
        ( eval 'return() { :; }' ) >/dev/null 2>&1
    }

    _zlsh_probe_alt_zlash_func_decl() {
        ( eval 'function name { :; }' ) >/dev/null 2>&1
    }

    # Some shells will tolerate this type of declaration.
    _zlsh_probe_mix_zlash_func_decl() {
        ( eval 'function name() { :; }' ) >/dev/null 2>&1
    }

    # Invalid in strict POSIX compliance.
    _zlsh_probe_zlash_func_name_with_dot() {
        ( eval '.name() { :; }' ) >/dev/null 2>&1
    }

    # Invalid in strict POSIX compliance.
    _zlsh_probe_zlash_func_name_with_colon() {
        ( eval ':name() { :; }' ) >/dev/null 2>&1
    }

    # Invalid in strict POSIX compliance.
    _zlsh_probe_zlash_func_name_with_at() {
        ( eval '@name() { :; }' ) >/dev/null 2>&1
    }

    # Invalid in strict POSIX compliance.
    _zlsh_probe_zlash_func_name_with_hash() {
        ( eval 'name#5() { :; }' ) >/dev/null 2>&1
    }

    # Invalid in strict POSIX compliance.
    # Supports Ksh93 namespacing.
    _zlsh_probe_var_name_with_dot() {
        ( eval '.name=' ) >/dev/null 2>&1
    }

    # Invalid in strict POSIX compliance.
    # Is Ksh93-specific.
    _zlsh_probe_special_ns_var_sh_version() {
        ( eval '[ -n "${.sh.version}" ]' ) >/dev/null 2>&1
    }

    _zlsh_probe_arith_lit_oct() {
        let '077+077==126' >/dev/null 2>&1 \
            && ! let '08'  >/dev/null 2>&1
    }

    _zlsh_probe_arith_lit_hex() {
        let '0xFF+0xff==510' >/dev/null 2>&1 \
            && ! let '0xG'   >/dev/null 2>&1
    }

    _zlsh_probe_arith_lit_bin() {
        let '0b11+0b11==6' >/dev/null 2>&1 \
            && ! let '0b2' >/dev/null 2>&1
    }

    _zlsh_probe_arith_lit_nbase() {
        let '3#22+3#22==16' >/dev/null 2>&1 \
            && ! let '3#3'  >/dev/null 2>&1
    }

    # Arbitrary precision decimals (Ksh93 uses libmath)
    _zlsh_probe_arith_arbp() {
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
    _zlsh_probe_arith_float() {
        let '0.1+0.2!=0.3 && 0.1+0.2<0.3001 && 0.1+0.2>0.2999' >/dev/null 2>&1
    }

    _zlsh_probe_arith_sqrt() {
        ( eval let 'sqrt(9)==3' ) >/dev/null 2>&1
    }

    _zlsh_probe_compound_vars() {
        ( eval 'v=( x="X" y="Y" ); [ "${v.y}" = "Y" ]' ) >/dev/null 2>&1
    }

    # _compat_test_bash_witness() {
    #     # BASH_VERSINFO is readonly
    #     ! ( BASH_VERSINFO=(0) ) >/dev/null 2>&1 \
    #         || return 1

    #     # `shopt` is a builtin
    #     [ "x$(builtin type -t builtin 2>/dev/null)" = "xbuiltin" ]      \
    #         && [ "x$(builtin type -t shopt   2>/dev/null)" = "xbuiltin" ]\
    #         || return 1
    # }

#     # https://git.savannah.gnu.org/cgit/bash.git/tree/NEWS
#     _test_bash_5_2_witness() {
#         (
#             # The new `globskipdots' shell option forces pathname expansion
#             # never to return `.' or `..' unless explicitly matched. It is
#             # enabled by default.
#             [[ -n "$(builtin shopt -p globskipdots 2>/dev/null)" ]] || return 1

#             # The `unset' builtin allows a subscript of `@' or `*' to unset a
#             # key with that value for associative arrays instead of unsetting
#             # the entire array (which you can still do with `unset arrayname').
#             # For indexed arrays, it removes all elements of the array without
#             # unsetting it (like `A=()').
#             declare -A assoc=([one]=1 ['@']=2 [three]=3 ['*']=4 [five]=5)
#             [[ ${assoc['@']} -eq 2 ]] || return 1
#             [[ ${#assoc[@]}  -eq 5 ]] || return 1
#             unset -v 'assoc[@]'
#             [[ ${#assoc[@]} -eq 4 ]] || return 1
#             unset -v 'assoc[*]'
#             [[ ${#assoc[@]} -eq 3 ]] || return 1

#             # There is a new parameter transformation operator: @k. This is like
#             # @K, but expands the result to separate words after word splitting.
#             eval 'declare -a list=("${assoc[@]@k}")' || return 1
#             [[ ${#list[@]} -eq 6 ]] || return 1
#         )
#     }

#     _test_bash_5_1_witness() {
#         # SRANDOM: a new variable that expands to a 32-bit random number that is
#         # not produced by an LCRNG, and uses getrandom/getentropy, falling back
#         # to /dev/urandom or arc4random if available. There is a fallback
#         # generator if none of these are available.
#         eval '[[ -v SRANDOM ]]' 2>/dev/null \
#             && [[ SRANDOM -ne SRANDOM ]]     \
#             || return 1

#         # Associative arrays may be assigned using a list of key-value pairs
#         # within a compound assignment. Compound assignments where the words are
#         # not of the form [key]=value are assumed to be key-value assignments. A
#         # missing or empty key is an error; a missing value is treated as NULL.
#         # Assignments may not mix the two forms.
#         (
#             declare -A assoc=(one 1 two 2)
#             eval '[[ -v assoc[two] ]]' 2>/dev/null \
#                 && [[    assoc[two] -eq 2 ]]        \
#                 && [[ ${#assoc[@]}  -eq 2 ]]         \
#                 || return 1
#         )
#     }

#     # TODO more

#     _compat_test_zsh_witness() {
#         # ZSH_EVAL_CONTEXT and ZSH_SUBSHELL are readonly
#         ! ( ZSH_EVAL_CONTEXT="" && (( ZSH_SUBSHELL++ )) ) >/dev/null 2>&2 \
#             || return 1

#         # `setopt` is a builtin
#         [ "x$(builtin whence -w builtin 2>/dev/null)"     \
#             = "xbuiltin: builtin" ]                        \
#             && [ "x$(builtin whence -w setopt  2>/dev/null)"\
#                 = "xsetopt: builtin" ]                       \
#             || return 1
#     }

#     _compat_test_ksh93_witness() {
#         # `return` is one of "special" builtins that cannot be overriden by
#         # functions.
#         ! ( eval 'function return { :; }' ) >/dev/null 2>&1 \
#             || return 1

#         # `.sh` is a builtin namespace.
#         ( eval '[[ -n "${.sh.version}" ]]' ) >/dev/null 2>&1 \
#             || return 1

#         # Advanced math
#         ( eval '[[ $((sqrt(9))) -eq 3 ]]' ) >/dev/null 2>&1 \
#             || return 1

#         # Compound variables
#         ( eval 'v=( x="X" y="Y" ); [ "${v.y}" = "Y" ]' ) 2>/dev/null \
#             || return 1
#     }

#     _compat_test_am_zsh() {
#         if ! _compat_test_bash_witness \
#         && ! _compat_test_ksh93_witness \
#         &&   _compat_test_zsh_witness
#         then
#             ZLASH_SH_TYP="zsh"
#             eval 'ZLASH_SH_VER=${(j:.:)${${(s:.:)ZSH_VERSION}[@]:0:2}}' \
#                 || return 1
#             _compat_test_am_zsh() { builtin return 0; }
#             builtin return 0
#         else
#             _compat_test_am_zsh() { return 1; }
#             return 1
#         fi
#     }

#     _compat_test_am_bash() {
#         if ! _compat_test_zsh_witness  \
#         && ! _compat_test_ksh93_witness \
#         &&   _compat_test_bash_witness
#         then
#             ZLASH_SH_TYP="bash"
#             ZLASH_SH_VER="${BASH_VERSINFO[0]}.${BASH_VERSINFO[1]}" \
#                 || return 1
#             # NOTE: These are not to be cleared during env scrubbing, if
#             #       scrubbed subshell doesn't want to lose their "specialness",
#             #       as per bash manpage.
#             ZLASH_PROTECTED__ZLASH_VARS="$( (
#                 IFS=":"
#                 declare -a protected_vars
#                 protected_vars=(
#                     BASHPID       BASH_ALIASES  BASH_ARGV0      BASH_CMDS
#                     BASH_COMMAND  BASH_SUBSHELL COMP_WORDBREAKS DIRSTACK
#                     EPOCHREALTIME EPOCHSECONDS  FUNCNAME        GROUPS
#                     LINENO        RANDOM        SECONDS         SRANDOM
#                     BASH_COMPAT   BASH_XTRACEFD HOSTFILE        MAILCHECK
#                 )
#                 protected_vars+=("$ZLASH_PROTECTED__ZLASH_VARS")
#                 echo "$protected_vars"
#             ) )" || return 1
#             _compat_test_am_bash() { builtin return 0; }
#             builtin return 0
#         else
#             _compat_test_am_bash() { return 1; }
#             return 1
#         fi
#     }

#     # `shopt` and `setopt` are not Ksh builtins.
#     # `.sh.version` is an illegal veriable name in Bash and Zsh.
#     _compat_test_am_ksh93() {
#         if ! _compat_test_bash_witness \
#         && ! _compat_test_zsh_witness   \
#         &&   _compat_test_ksh93_witness
#         then
#             ZLASH_SH_TYP="ksh93"
#             ZLASH_SH_VER="93.0"
#             _compat_test_am_ksh93() { return 0; }
#             return 0
#         else
#             _compat_test_am_ksh93() { return 1; }
#             return 1
#         fi
#     }

#     # Initial POSIX-compliant implementation of a version test function,
#     # to be specialized after sanity checks and shell type and version
#     # discrimination, by appropriate and more performant implementation.
#     #
#     # Example:
#     #
#     #     _compat_test_version_majorminor "${VERSION:-0.0}" -ge 4.4 -lt 5.0
#     #
#     _compat_test_version_majorminor() {
#         if [ "$#" -eq 0 ]; then
#             echo "ERROR: Illegal _compat_test_version_majorminor" \
#                  "call with no arguments." >&2
#             return 1
#         fi
#         [ "$#" -eq 1 ] && return 0
#         _LEFT="$1"
#         shift
#         if ! [ "$((${_LEFT%%.*}))" = "${_LEFT%%.*}" ] \
#         || ! [ "$((${_LEFT#*.}))"  = "${_LEFT#*.}"  ]
#         then
#             echo "ERROR: _compat_test_version_majorminor numbers must be of " \
#                  "the decimal form: <major>.<minor>" >&2
#             return 1
#         fi
#         while [ "$#" -gt 0 ]; do
#             _OP="$1"
#             _RIGHT="$2"
#             shift 2
#             if ! [ "$((${_RIGHT%%.*}))" = "${_RIGHT%%.*}" ] \
#             || ! [ "$((${_RIGHT#*.}))"  = "${_RIGHT#*.}"  ]
#             then
#                 echo "ERROR: _compat_test_version_majorminor numbers must be" \
#                      "of the decimal form: <major>.<minor>" >&2
#                 return 1
#             fi
#             case "$_OP" in
#                 -ge|-le|-eq|-gt|-lt)
#                     if [ "${_LEFT%%.*}" -eq "${_RIGHT%%.*}" ]; then
#                         test "${_LEFT#*.}" "$_OP" "${_RIGHT#*.}" \
#                             && continue || return $?
#                     else
#                         test "${_LEFT%%.*}" "$_OP" "${_RIGHT%%.*}" \
#                             && continue || return $?
#                     fi
#                     ;;
#                 *)
#                     echo "ERROR: _compat_test_version_majorminor comparison" \
#                          "operator must be one of: -gt -lt -ge -le -eq" >&2
#                     return 1
#                     ;;
#             esac
#         done
#         return 0
#     }

#     # Test supported shell type and version.
#     #
#     # TODO: Gradually lower minimal version
#     #       with more specialization using `Test_AmBash`, `Test_AmZsh`, etc...
#     _compat_id_shell_type() {
#         if   _compat_test_am_bash; then
#             if ! _compat_test_version_majorminor "$ZLASH_SH_VER" -ge 5.2
#             then
#                 builtin echo "WARNING:" "$ZLASH_SH_TYP" \
#                         "$ZLASH_SH_VER" "is too low!" >/dev/stderr
#             fi
#         elif _compat_test_am_zsh; then
#             if ! _compat_test_version_majorminor "$ZLASH_SH_VER" -ge 5.9
#             then
#                 builtin echo "WARNING:" "$ZLASH_SH_TYP" \
#                         "$ZLASH_SH_VER" "is too low!" >/dev/stderr
#             fi
#         elif _compat_test_am_ksh93; then
#             echo "ERROR: ksh93 is not yet supported!" >/dev/stderr
#             return 1
#         else
#             # TODO: check if POSIX guarantees /dev in all environments.
#             echo "ERROR: failed to identify a supported shell type!" >&2
#             return 1
#         fi
#     }

#     _compat_id_shell_type || exit 1
# }

# _zlsh_init
# # NOTE: POSIX compliance can be dropped from here, in favor of shell-specific
# #       extenstions.

# # NOTE: General Spacialization Pattern. Pre-specialized definitions are under
# #       `Zlash::` namespace, for maximal dynamic introspection (dynamic
# #       dependency resolution via dryrun debug traps, and minimal version
# #       identification per function) and automatic forwarding of functionality
# #       subsets to any remote supported shells.
# # NOTE: Ksh adheres strictly to POSIX function name format, which is the same
# #       as variable name format.  So despite Bash and Zsh supporting much more
# #       variety of characters in functino names, to remain portable, we must
# #       limit outselves in function naming, but can still use aliases to get
# #       desired effect on all POSIX shells.
# alias Initialize-MinShellOpts=Initialize_MinShellOpts
# alias Zlash::Initialize-MinShellOpts=Zlash__Initialize_MinShellOpts
# Initialize_MinShellOpts() {
#     Zlash::Initialize-MinShellOpts \
#         && Initialize-MinShellOpts
# }
# Zlash__Initialize_MinShellOpts() {
#     # TODO: Check what versions support these options.
#     _compat_test_am_bash && \
#         Initialize_MinShellOpts() {
#             builtin local opt
#             for opt in nounset pipefail; do
#                 builtin set -o $opt; done
#             builtin shopt -s huponexit expand_aliases shift_verbose
#         }
#     _compat_test_am_zsh && \
#         Initialize_MinShellOpts() {
#             builtin setopt \
#                     nolocaloptions ksharrays nounset pipefail errreturn \
#                     hup aliases interactivecomments
#         }
#     _compat_test_am_ksh93 && \
#         Initialize_MinShellOpts() {
#             echo "Not Implemented!" >/dev/stderr
#             exit 1
#         }
# }

# Initialize-MinShellOpts
# # NOTE: Can use alias expansion non-interactively from here.

# alias Test-VersionMajorMinor=Test_VersionMajorMinor
# alias Zlash::Test-VersionMajorMinor=Zlash__Test_VersionMajorMinor
# Test_VersionMajorMinor() {
#     Zlash::Test-VersionMajorMinor \
#         && Test-VersionMajorMinor "$@"
# }
# Zlash__Test_VersionMajorMinor() {
#     # Default unspecialized Test_VersionMajorMinor
#     Test_VersionMajorMinor() { _compat_test_version_majorminor "$@"; }

#     # TODO: Specialize as needed, like so:
#     #
#     # Test-AmBash -ge 5.2         && Test_VersionMajorMinor() { ... }
#     # Test-AmBash -ge 5.0 -lt 5.2 && Test_VersionMajorMinor() { ... }
#     # Test-AmBash -ge 4.4 -lt 5.0 && Test_VersionMajorMinor() { ... }
#     # Test-AmBash -ge 4.0 -lt 4.4 && Test_VersionMajorMinor() { ... }
#     # Test-AmZsh  -ge 5.0         && Test_VersionMajorMinor() { ... }
#     # ... etc...
# }

# alias Test-AmBash=Test_AmBash
# alias Test-AmZsh=Test_AmZsh
# alias Test-AmKsh=Test_AmKsh
# Test_AmBash() {
#     _compat_test_am_bash && Test-VersionMajorMinor "$ZLASH_SH_VER" "$@"
# }
# Test_AmZsh() {
#     _compat_test_am_zsh && Test-VersionMajorMinor "$ZLASH_SH_VER" "$@"
# }
# Test_AmKsh() { _compat_test_am_ksh93; }

# #------------------------------------------------------------------------------
# ### 4.    FOUNDATIONAL BOOTSTRAPPING DEFINITIONS
# # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# #
# # Bootstrapping foundational definitions here.  Their attibute definitions
# # for parameters and help are added later, after attribute mechanisms are
# # defined.
# #

# # Avoiding `echo` pitfalls. See: https://www.etalabs.net/sh_tricks.html
# alias Write-Out=Write_Out
# alias Zlash::Write-Out=Zlash__Write_Out
# Write_Out() {
#     Zlash::Write-Out \
#         && Write-Out
# }
# Zlash__Write_Out() {
#     # Default fallback
#     Write_Out() { echo -- "$*"; }

#     Test-AmBash && \
#         Write_Out() {
#             local IFS=$' '
#             builtin printf $'%s\n' "$*"
#         }

#     # Zsh comp makes this faster (see ./shellbench/write-echo.sh)
#     Test-AmZsh && \
#         Write_Out() {
#             [[ "$IFS" == ' '* ]] || local IFS=$' '
#             builtin printf $'%s\n' "$*"
#         }
# }

# alias Write-Err=Write_Err
# Write_Err() { Write-Out "$@" >/dev/stderr; }

# alias Invoke-Silent=Invoke_Silent
# alias Invoke-OnlyOut=Invoke_OnlyOut
# alias Invoke-NoFail=Invoke_NoFail
# Invoke_Silent()  { "$@" 2>/dev/null 1>/dev/null; }
# Invoke_OnlyOut() { "$@" 2>/dev/null; }

# # `builtin` works differently in Ksh.  Additionally,
# # Ksh has "special" builtins, which have higher precedence than
# # functions, and cannot be overriden by aliases.


# Invoke_NoFail()  { "$@" || builtin return 0; }  # TODO: spec ksh

# # Making `$funcstack` work in Bash as in Zsh.
# Test-AmBash -ge 5.0 && \
#     builtin declare -gn funcstack="FUNCNAME"

# # Common naming of basic variable declarations
# Test-AmBash && {  # TODO: spec more versions
#     alias New-LocalName='builtin local'
#     alias New-LocalNameRef='builtin local -n'
#     alias New-LocalShadow='builtin local -I'
#     alias New-LocalInt='builtin local -i'
#     alias New-LocalIxArr='builtin local -a'
#     alias New-LocalAssoc='builtin local -A'
#     alias New-GlobalName='builtin declare -g'
#     alias New-GlobalNameRef='builtin declare -gn'
#     alias New-GlobalInt='builtin declare -gi'
#     alias New-GlobalIxArr='builtin declare -ga'
#     alias New-GlobalAssoc='builtin declare -gA'
# }
# Test-AmZsh && {  # TODO: spec more versions
#     alias New-LocalName='builtin local'
#     alias New-LocalInt='builtin local -i'
#     alias New-LocalFloat='builtin local -F'
#     alias New-LocalIxArr='builtin local -a'
#     alias New-LocalAssoc='builtin local -A'
#     alias New-GlobalName='builtin typeset -g'
#     alias New-GlobalInt='builtin typeset -gi'
#     alias New-GlobalFloat='builtin typeset -gF'
#     alias New-GlobalIxArr='builtin typeset -ga'
#     alias New-GlobalAssoc='builtin typeset -gA'
# }
# Test-AmKsh && {  # TODO: spec more versions
#     alias New-LocalName=typeset
#     alias New-LocalNameRef='typeset -n'
#     alias New-LocalInt='typeset -i'
#     alias New-LocalIxArr='typeset -a'
#     alias New-LocalAssoc='typeset -A'
#     alias New-LocalCompound='typeset -C'
#     alias New-GlobalName='typeset -g'
#     alias New-GlobalInt='typeset -gi'
#     alias New-GlobalFloat='typeset -gF'
#     alias New-GlobalIxArr='typeset -ga'
#     alias New-GlobalAssoc='typeset -gA'
#     alias New-GlobalCompound='typeset -gC'
#     alias Move-Variable='typeset -m'
# }

# # TODO: add more flag tests.
# # TODO: decide if these should be moved and made inline later.
# Test_IsFile()             { [[   -f "$1"   ]]; }
# Test_IsExecutable()       { [[   -x "$1"   ]]; }
# Test_IsReadable()         { [[   -r "$1"   ]]; }
# Test_IsWritable()         { [[   -w "$1"   ]]; }
# Test_IsDirectory()        { [[   -d "$1"   ]]; }
# Test_IsPipe()             { [[   -p "$1"   ]]; }
# Test_IsSocket()           { [[   -S "$1"   ]]; }
# Test_IsTerminal()         { [[   -t "$1"   ]]; }
# Test_IsShellRestricted()  { [[ "$-" == *r* ]]; }
# Test_IsShellPrivileged()  { [[ "$-" == *p* ]]; }  # TODO: check zsh is same
# Test_IsShellInteractive() { [[ "$-" == *i* ]]; }
# alias Test-IsShellInteractive=Test_IsShellInteractive

# # TODO: what are the minimal shell versions for str slicing?
# Test_IsFullPath() { [[ "${1:0:1}" == "/" ]]; }

# # NOTE: `Test-IsAssocName` should not be done by this for perf reason.
# #       Caller should validate association array exists.
# # TODO: clarify versions, and provide lower version implementations.
# Test_IsAssocKey() { [[ -v "$1"'[$2]' ]]; }

# alias Test-IsAliasName=Test_IsAliasName
# alias Test-IsVarName=Test_IsVarName
# alias Test-IsFuncName=Test_IsFuncName
# Test-AmKsh && {
#     Test_IsAliasName() { Invoke-Silent  alias     "$1"; }
#     Test_IsVarName()   { Invoke-Silent typeset -p "$1"; }
#     Test_IsFuncName()  { Invoke-Silent typeset -f "$1"; }
# } || {
#     Test_IsAliasName() { Invoke-Silent builtin  alias     "$1"; }
#     Test_IsVarName()   { Invoke-Silent builtin typeset -p "$1"; }
#     Test_IsFuncName()  { Invoke-Silent builtin typeset -f "$1"; }
# }

# # NOTE: This is a weak test, used for bootstrapping. Better tests are:
# #         - `Test-IsIxArrName`
# #         - `Test-IsAssocName`
# #         - `Test-IsAssocOrIxArrName`
# Test-AmBash && \
#     _Test_IsArrName() {
#         [[ "$(Invoke-Silent builtin declare -p "$1")" == 'declare -a'* ]]
#     }
# Test-AmZsh && \
#     _Test_IsArrName() {
#         [[ "$(Invoke-Silent builtin typeset -p "$1")" == 'typeset -a'* ]]
#     }
# Test-AmKsh && \
#     _Test_IsArrName() {
#         [[ "$(Invoke-Silent typeset -p "$1")" == 'typeset -a'* ]]
#     }

# # Basic exception bootstrapping definitions,
# # redefined/inlined after required definitions are complete.

# # Errors Stack
# _Test_IsArrName ZLASH_ERRORS || {
#     New-GlobalIxArr ZLASH_ERRORS
#     ZLASH_ERRORS=()
# }

# alias Push-Error=Push_Error
# Push_Error() {
#     ZLASH_ERRORS=("$1" "${ZLASH_ERRORS[@]:0:${ZLASH_MAX_ERRORS:-100}}")
# }

# Test-AmKsh && {
#     alias Pass='return 0'
#     alias Fail='return 1'
# } || {
#     alias Pass='builtin return 0'
#     alias Fail='builtin return 1'
# }

# alias New-ErrorAlias=New_ErrorAlias
# Test-AmBash && \
#     New_ErrorAlias() {
#         New-LocalName name
#         name="$(builtin printf %q\\n "$1")"
#         alias "$1"="Push-Error \"$name in ( \${FUNCNAME[@]} )\"; Fail"
#     }
# Test-AmZsh && \
#     New_ErrorAlias() {
#         New-LocalName name
#         name="$(builtin printf %q\\n "$1")"
#         alias "$name"="Push-Error \"$name in ( \${funcstack[@]} )\"; Fail"
#     }
# Test-AmKsh && \
#     New_ErrorAlias() {
#         New-LocalName name
#         name="$(printf %q\\n "$1")"
#         alias "$name"="Push-Error \"$name in \${.sh.fun}\"; Fail"
#     }

# New-ErrorAlias Error::NotExpected
# New-ErrorAlias Error::NotImplemented

# alias Test-IsShellLogin=Test_IsShellLogin
# Test_IsShellLogin() { Error::NotImplemented; }
# Test-AmBash && \
#     Test_IsShellLogin() { builtin shopt -q login_shell; }

# Test_IsAssocOrIxArrName() { Error::NotImplemented; }
# Test_IsAssocName()        { Error::NotImplemented; }
# Test_IsIxArrName()        { Error::NotImplemented; }
# Test_IsKeywordName()      { Error::NotImplemented; }
# Test_IsBuiltinName()      { Error::NotImplemented; }
# Test_IsExeName()          { Error::NotImplemented; }
# # TODO: implement Zsh versions
# Test-AmBash -ge 5.0 && {  # TODO: implement lower Bash versions
#     Test_IsAssocOrIxArrName() {
#         Test-IsVarName "$1" && local -n ref="$1" && [[ "${ref@a}" == *[aA]* ]]
#     }
#     Test_IsAssocName() {
#         Test-IsVarName "$1" && local -n ref="$1" && [[ "${ref@a}" == *A* ]]
#     }
#     Test_IsIxArrName() {
#         Test-IsVarName "$1" && local -n ref="$1" && [[ "${ref@a}" == *a* ]]
#     }
# }
# Test-AmBash && {
#     Test_IsKeywordName() {
#         [[ "$(Invoke-OnlyOut builtin type -ta "$1")" == *keyword* ]]
#     }
#     Test_IsBuiltinName() {
#         [[ "$(Invoke-OnlyOut builtin type -ta "$1")" == *builtin* ]]
#     }
#     Test_IsExeName() {
#         [[ "$(Invoke-OnlyOut builtin type -ta "$1")" == *file* ]]
#     }
# }
