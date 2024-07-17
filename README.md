# 🌟 Blask

Blask ([/blask/](https://en.wiktionary.org/wiki/blask)) is a UI component library for [Lustre](https://github.com/lustre-labs/lustre)!

It has both styled and unstyled components, so you can be as much in control as you need/want to.

You can see them showcased here: <https://loipesmas.github.io/blask>

## List of components

### Unstyled

- [x] select
- [x] accordion
- [ ] tabs
- [ ] switch

### Styled

- [x] select
- [x] accordion
- [ ] tabs
- [ ] switch
- [ ] button
- [ ] input (text, number, file, etc)


## Links and usage

[![Package Version](https://img.shields.io/hexpm/v/blask)](https://hex.pm/packages/blask)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/blask/)

```sh
gleam add blask
```
```gleam
import blask
import blask/styled/select

type LanguageOption {
  Gleam
  Haskell
  Rust
  Erlang
}

fn language_to_str(language: LanguageOption) -> String {
  case language {
    Gleam -> "Gleam"
    Haskell -> "Haskell"
    Rust -> "Rust"
    Erlang -> "Erlang"
  }
}


type Model {
    Model(language_select_state: select.SelectState(LanguageOption))
}

type Msg {
  LanguageSelectStateChange(SelectState(LanguageOption))
}

pub fn view(model: Model) -> Element(msg) {
    // somewhere in your view
    select(
      state: model.language_select_state,
      on_state_change: LanguageSelectStateChange,
      display: language_to_str,
    )
}
```

Further documentation can be found at <https://hexdocs.pm/blask>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```
