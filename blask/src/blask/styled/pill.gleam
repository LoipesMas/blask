import lustre/event
import gleroglero/solid
import gleam/option.{type Option, Some, None}
import sketch as s
import sketch/lustre/element.{type Element}
import sketch/lustre/element/html

fn pill_styles() {
  [
    s.color("#222"),
    s.background("#eee"),
    s.padding_("0.2em 0.5em"),
    s.border_radius_("0.8em"),
    s.width_("fit-content"),
    s.display("flex"),
    s.font_size_("0.85rem"),
    s.margin_("auto"),
  ]
}

pub type NotClosable =
  Nil

pub type Closable {}

pub type NoContent =
  Nil

pub opaque type PillProps(closable, has_content, msg) {
  PillProps(content: has_content, on_close: Option(msg))
}

pub fn simple(text: String) -> Element(msg) {
  html.div(s.class(pill_styles()), [], [html.text(text)])
}

pub fn new() -> PillProps(NotClosable, NoContent, msg) {
  PillProps(content: Nil, on_close: None)
}

pub fn with_text(
  props props: PillProps(closable, NoContent, msg),
  text text: String,
) -> PillProps(closable, Element(msg), msg) {
  PillProps(on_close: props.on_close, content: html.text(text))
}

pub fn with_content(
  props props: PillProps(closable, NoContent, msg),
  content content: Element(msg),
) -> PillProps(closable, Element(msg), msg) {
  PillProps(on_close: props.on_close, content:)
}

pub fn with_close_button(
  props props: PillProps(NotClosable, content, msg),
  on_close on_close: msg,
) -> PillProps(Closable, content, msg) {
  PillProps(on_close: Some(on_close), content:props.content)
}

fn close_icon_style() {
  [
    s.display("block"),
    s.width_("20px"),
    s.height_("20px"),
    s.transition("transform 0.3s ease-out"),
    s.property("stroke", "#eee"),
    s.property("stroke-width", "1px"),
    s.cursor("pointer"),
  ]
}
pub fn build(props: PillProps(closable, Element(msg), msg)) -> Element(msg) {
  let close_button = case props.on_close {
    Some(msg) -> html.span(s.class(close_icon_style()), [event.on_click(msg)], [solid.x_mark() |> element.styled])
    None -> element.none()
  }
  html.div(s.class(pill_styles()), [], [props.content, close_button])
}
