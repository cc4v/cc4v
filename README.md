# cc4v

![docs/screenshot_logo.png](docs/screenshot_logo.png)

(code of above: [examples/logo_icon](https://github.com/cc4v/cc4v-examples/blob/main/logo-icon/main.odin))

> [!WARNING]
> Currently at very early stage. API design may change.<br>
> (see [docs/coverage.md](docs/coverage.md))

Creative Coding framework in [V language](https://vlang.io/)

Aiming to provide APIs like [openFrameworks](https://openframeworks.cc/documentation/) or [Processing](https://processing.org/reference) on V / [gg](https://modules.vlang.io/gg.html), with a little essence of [Ebitengine](https://ebitengine.org/). (Please check [docs/api_design.md](docs/api_design.md))

Tested on V 0.4.12

## Install

```bash
$ git clone https://github.com/cc4v/cc4v ~/.vmodules/cc
```

## Examples

see [cc4v-examples](https://github.com/cc4v/cc4v-examples) and [docs/coverage.md](docs/coverage.md).

```bash
# NOTE: You should not use ~/.vmodules for this clone
#       Please `cd ~/Documents` or somewhere else.

$ git clone https://github.com/cc4v/cc4v-examples
$ cd cc4v-examples
$ v run ./hello_world
```

## Contribution

Please check [docs/api_design.md](docs/api_design.md), [docs/coverage.md](docs/coverage.md), and [LICENSE.md](LICENSE.md).

Fork and create your version as you like. Feel free to create PR. If you have any questions or ideas, please use [discussions](https://github.com/cc4v/cc4v/discussions) instead of issues. Issues are only for task tracking.
