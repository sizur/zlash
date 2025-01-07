# Roadmap

## Shells Supported

### `Bash`

The primary target is `Bash` because of its ubiquity.

### `Zsh`

Adding `Zsh` support is trivial after `Bash`, so that's second target for shell
support.

### `Ksh93`

`Ksh93` is still considered one of the major POSIX-compatible shells, and is
heavily used in some environments. Adding `Ksh` support to our zero-install file
complicates some things due to more restricted parser of `Ksh`.

## Features

### Auto-Serialization Structured Results When Piping

Functions normally use OUT variables for passing structured data efficiently.
This can't work in a pipeline, since commands can (and will) be executed in
isolated subshells.

The plan is for functions to be automatically serializing structures results as null
terminated fields

### Json To/From Conversion

Relying on `jq @sh` to sanitize imported data.

### Binary Data Support

The plan is to use ram-backed session storage mounted within `/tmp/`.

### Secure Data Support

`SecureString`-like funcitonality, using a combination of `gnupg` with the
Binary Data Support, with fallbacks like `openssl` and existing `/tmp/`.

### Logic

Implement logical variables and miniKanren solver.
