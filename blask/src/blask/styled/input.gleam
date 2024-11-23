import gleam/list
import gleam/option
import lustre/attribute as a
import lustre/attribute.{type Attribute}
import lustre/event
import sketch as s
import sketch/lustre/element.{type Element}
import sketch/lustre/element/html

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
}

pub type TextState =
  String

pub type NoOnInput =
  Nil

pub type OnInput(msg) =
  fn(TextState) -> msg

pub type NoValue =
  Nil

pub type Value =
  String

pub type TextInput

pub type FileInput

pub opaque type InputProps(on_input, value, input_class, msg) {
  InputProps(
    on_input: on_input,
    type_: String,
    placeholder: option.Option(String),
    id: option.Option(String),
    name: option.Option(String),
    value: value,
    attributes: List(Attribute(msg)),
  )
}

pub fn text() -> InputProps(NoOnInput, NoValue, TextInput, msg) {
  InputProps(
    on_input: Nil,
    type_: "text",
    placeholder: option.None,
    id: option.None,
    name: option.None,
    value: Nil,
  attributes: [],
  )
}

pub fn password() -> InputProps(NoOnInput, NoValue, TextInput, msg) {
  InputProps(
    on_input: Nil,
    type_: "password",
    placeholder: option.None,
    id: option.None,
    name: option.None,
    value: Nil,
  attributes: [],
  )
}

pub fn file() -> InputProps(NoOnInput, NoValue, FileInput, msg) {
  InputProps(
    on_input: Nil,
    type_: "file",
    placeholder: option.None,
    id: option.None,
    name: option.None,
    value: Nil,
  attributes: [],
  )
}

pub fn custom(type_: String) -> InputProps(NoOnInput, NoValue, TextInput, msg) {
  InputProps(
    on_input: Nil,
    type_: type_,
    placeholder: option.None,
    id: option.None,
    name: option.None,
    value: Nil,
  attributes: [],
  )
}

pub fn on_input(
  props: InputProps(NoOnInput, v, TextInput, msg),
  on_input: OnInput(msg),
) -> InputProps(OnInput(msg), v, TextInput, msg) {
  InputProps(
    on_input: on_input,
    type_: props.type_,
    placeholder: props.placeholder,
    id: props.id,
    name: props.name,
    value: props.value,
    attributes: props.attributes,
  )
}

pub fn with_placeholder(
  props: InputProps(i, v, TextInput, msg),
  placeholder: String,
) -> InputProps(i, v, TextInput, msg) {
  InputProps(..props, placeholder: option.Some(placeholder))
}

pub fn with_id(props: InputProps(i, v, t, m), id: String) -> InputProps(i, v, t, m) {
  InputProps(..props, placeholder: option.Some(id))
}

pub fn with_name(
  props: InputProps(i, v, t, m),
  name: String,
) -> InputProps(i, v, t, m) {
  InputProps(..props, placeholder: option.Some(name))
}

pub fn with_value(
  props: InputProps(i, NoValue, TextInput, m),
  value: Value,
) -> InputProps(i, Value, TextInput, m) {
  InputProps(
    on_input: props.on_input,
    type_: props.type_,
    placeholder: props.placeholder,
    value: value,
    id: props.id,
    name: props.name,
    attributes: props.attributes,
  )
}

pub fn with_attributes(
  props: InputProps(i, v, t, msg),
  attributes: List(Attribute(msg))
) -> InputProps(i, v, t, msg) {
  InputProps(
    on_input: props.on_input,
    type_: props.type_,
    placeholder: props.placeholder,
    value: props.value,
    id: props.id,
    name: props.name,
    attributes: props.attributes |> list.append(attributes),
  )
}

pub fn build(props: InputProps(OnInput(msg), Value, TextInput, msg)) -> Element(msg) {
  html.input(text_class() |> s.class, [
    a.type_(props.type_),
    event.on_input(props.on_input),
    props.placeholder |> option.map(a.placeholder) |> option.unwrap(a.none()),
    props.id |> option.map(a.id) |> option.unwrap(a.none()),
    props.name |> option.map(a.name) |> option.unwrap(a.none()),
    a.value(props.value),
    ..props.attributes
  ])
}

pub fn build_file(
  props: InputProps(NoOnInput, NoValue, FileInput, msg),
) -> Element(msg) {
  html.input(file_class() |> s.class, [
    a.type_(props.type_),
    props.id |> option.map(a.id) |> option.unwrap(a.none()),
    props.name |> option.map(a.name) |> option.unwrap(a.none()),
    ..props.attributes
  ])
}
