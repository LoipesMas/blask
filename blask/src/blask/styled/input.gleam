import blask/unstyled/input.{
  type FileInput, type InputProps, type NoOnInput, type NoValue, type TextInput,
}
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
    s.height_("1.8rem"),
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

pub fn text() -> InputProps(NoOnInput, NoValue, TextInput, msg) {
  input.text() |> input.with_styles(text_class())
}

pub fn password() -> InputProps(NoOnInput, NoValue, TextInput, msg) {
  input.password() |> input.with_styles(text_class())
}

pub fn file() -> InputProps(NoOnInput, NoValue, FileInput, msg) {
  input.file() |> input.with_styles(file_class())
}

pub fn custom(type_: String) -> InputProps(NoOnInput, NoValue, TextInput, msg) {
  input.custom(type_) |> input.with_styles(text_class())
}

pub const on_input = input.on_input

pub const with_placeholder = input.with_placeholder

pub const with_id = input.with_id

pub const with_name = input.with_name

pub const with_value = input.with_value

pub const with_attributes = input.with_attributes

pub const build = input.build

pub const build_file = input.build_file
