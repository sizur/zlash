# Zlash
Zero-install logical adaptive structured shell

> Under Heavy Work in Progress.

Project Goals
=============

Launch any *POSIX-compatible*¹ shell, including remote sessions. By sourcing
this file — whether manually or auto-forwarded from another shell instance —
you unlock advanced interactive features. These include structured objects,
object pipelines, binary data processing, custom class definitions, advanced
parameters, automatic help generation, and more. Additionally, Zlash introduces
novel capabilities powered by an integrated relational solver, all tailored to
your environment without requiring installation, automatically optimized by
available, probed tools, with portable fallbacks implemented.

___

1. By a *POSIX-compatible* shell, we mean any shell that is able to interpret
   and execute *POSIX-compliant* shell scripts and interactive commands.

Project Motivation
==================

The increasing popularity and proliferation of modern interactive shells¹,
terminal emulators², and a large number of new, high-quality CLI/TUI
tools/apps³ is a proof of a need that a GUI cannot fulfill generally. That
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

Roadmap
=======

- [x] [POSIX Shell sanity-check of bare-minimum portable functionality](src/init_sanity.sh)
- [x] [Core input validation functions](src/core_validators.sh)
- [x] [Shell string quotation for reuse](src/core_shell_quoting.sh)
- [x] [String matching](src/core_str_matching.sh)
- [x] [Dev-env dependency management](src/_dev.sh)
- [50%] [Core Attributes](src/core_attrs.sh)
- [0%] Core Objects
- [75%] [String operations](src/core_str_ops.sh)
- [50%] [Math](src/core_math.sh)
- [x] [PN-Counters](str/core_pncounters.sh)
- [x] [Stacks](src/core_stack.sh)
- [0%] Iterators


