import blask/internals/utils.{scld}
import gleam/option
import lustre/attribute as a
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import sketch as s

fn text_class() {
  [
    s.background("#151515"),
    s.border_radius_("0.3rem"),
    s.color("whitesmoke"),
    s.padding_("0.3rem 0.5rem"),
    s.font_family("inherit"),
    s.font_size_("1.07rem"),
    s.border("1px solid #606060"),
    s.outline("none"),
    s.focus([s.border("1px solid #909092")]),
  ]
  |> scld("input-text")
}

fn file_class() {
  [
    s.background("#151515"),
    s.border_radius_("0.3rem"),
    s.color("whitesmoke"),
    s.padding_("0.3rem 0.5rem"),
    s.font_family("inherit"),
    s.font_size_("1.07rem"),
    s.border("1px solid #606060"),
    s.outline("none"),
    s.cursor("pointer"),
    s.focus([s.border("1px solid #909092")]),
    s.pseudo_selector("::file-selector-button", [
      s.color("whitesmoke"),
      s.background("#303030"),
      s.padding_("0.2rem 0.3rem"),
      s.border_radius_("0.2rem"),
      s.border("none"),
      s.font_family("inherit"),
      s.cursor("pointer"),
    ]),
    s.pseudo_selector("::file-selector-button:hover", [s.background("#555")]),
  ]
  |> scld("input-file")
}

pub type TextState =
  String

pub type InputType {
  Text
  Password
  File
  Other(String)
}

fn input_type_to_str(input_type: InputType) -> String {
  case input_type {
    Text -> "text"
    Password -> "password"
    File -> "file"
    Other(type_) -> type_
  }
}

pub type NoOnInput =
  Nil

pub type OnInput(msg) =
  fn(TextState) -> msg

pub type NoValue =
  Nil

pub type Value =
  String

pub opaque type InputProps(on_input, value) {
  InputProps(
    on_input: on_input,
    type_: InputType,
    placeholder: option.Option(String),
    id: option.Option(String),
    name: option.Option(String),
    value: value,
  )
}

pub fn text() -> InputProps(NoOnInput, NoValue) {
  InputProps(
    on_input: Nil,
    type_: Text,
    placeholder: option.None,
    id: option.None,
    name: option.None,
    value: Nil,
  )
}

pub fn password() -> InputProps(NoOnInput, NoValue) {
  InputProps(
    on_input: Nil,
    type_: Password,
    placeholder: option.None,
    id: option.None,
    name: option.None,
    value: Nil,
  )
}

pub fn file() -> InputProps(NoOnInput, NoValue) {
  InputProps(
    on_input: Nil,
    type_: File,
    placeholder: option.None,
    id: option.None,
    name: option.None,
    value: Nil,
  )
}

pub fn custom(type_: String) -> InputProps(NoOnInput, NoValue) {
  InputProps(
    on_input: Nil,
    type_: Other(type_),
    placeholder: option.None,
    id: option.None,
    name: option.None,
    value: Nil,
  )
}

pub fn on_input(
  props: InputProps(NoOnInput, v),
  on_input: OnInput(msg),
) -> InputProps(OnInput(msg), v) {
  InputProps(
    on_input: on_input,
    type_: props.type_,
    placeholder: props.placeholder,
    id: props.id,
    name: props.name,
    value: props.value,
  )
}

pub fn with_placeholder(
  props: InputProps(i, v),
  placeholder: String,
) -> InputProps(i, v) {
  InputProps(..props, placeholder: option.Some(placeholder))
}

pub fn with_id(props: InputProps(i, v), id: String) -> InputProps(i, v) {
  InputProps(..props, placeholder: option.Some(id))
}

pub fn with_name(props: InputProps(i, v), name: String) -> InputProps(i, v) {
  InputProps(..props, placeholder: option.Some(name))
}

pub fn with_value(
  props: InputProps(i, NoValue),
  value: Value,
) -> InputProps(i, Value) {
  InputProps(
    on_input: props.on_input,
    type_: props.type_,
    placeholder: props.placeholder,
    value: value,
    id: props.id,
    name: props.name,
  )
}

pub fn build(props: InputProps(OnInput(msg), Value)) -> Element(msg) {
  let class = case props.type_ {
    Text | Password | Other(_) -> text_class
    File -> file_class
  }
  html.input([
    a.type_(input_type_to_str(props.type_)),
    event.on_input(props.on_input),
    props.placeholder |> option.map(a.placeholder) |> option.unwrap(a.none()),
    props.id |> option.map(a.id) |> option.unwrap(a.none()),
    props.name |> option.map(a.name) |> option.unwrap(a.none()),
    a.value(props.value),
    class(),
  ])
}
