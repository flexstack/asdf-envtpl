<div align="center">

# asdf-envtpl [![Build](https://github.com/flexstack/asdf-envtpl/actions/workflows/build.yml/badge.svg)](https://github.com/flexstack/asdf-envtpl/actions/workflows/build.yml) [![Lint](https://github.com/flexstack/asdf-envtpl/actions/workflows/lint.yml/badge.svg)](https://github.com/flexstack/asdf-envtpl/actions/workflows/lint.yml)

[envtpl](https://github.com/flexstack/envtpl) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Install

Plugin:

```shell
asdf plugin add envtpl
# or
asdf plugin add envtpl https://github.com/flexstack/asdf-envtpl.git
```

envtpl:

```shell
# Show all installable versions
asdf list-all envtpl

# Install specific version
asdf install envtpl latest

# Set a version globally (on your ~/.tool-versions file)
asdf global envtpl latest

# Now envtpl commands are available
envtpl --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/flexstack/asdf-envtpl/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Jared Lunde](https://github.com/flexstack/)
