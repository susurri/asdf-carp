<div align="center">

# asdf-carp [![Build](https://github.com/susurri/asdf-carp/actions/workflows/build.yml/badge.svg)](https://github.com/susurri/asdf-carp/actions/workflows/build.yml) [![Lint](https://github.com/susurri/asdf-carp/actions/workflows/lint.yml/badge.svg)](https://github.com/susurri/asdf-carp/actions/workflows/lint.yml)


[carp](https://carp-lang.github.io/carp-docs/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add carp
# or
asdf plugin add carp https://github.com/susurri/asdf-carp.git
```

carp:

```shell
# Show all installable versions
asdf list-all carp

# Install specific version
asdf install carp latest

# Set a version globally (on your ~/.tool-versions file)
asdf global carp latest

# Now carp commands are available
carp --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/susurri/asdf-carp/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [susurri](https://github.com/susurri/)
