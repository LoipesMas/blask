import blask/unstyled/accordion.{
  type AccordionItem as UnstyledAccordionItem,
  type AccordionState as UAccordionState, accordion as unstyled_accordion,
}
import gleam/function
import gleam/list
import gleroglero/solid
import sketch as s
import sketch/lustre/element.{type Element}
import sketch/lustre/element/html

pub type AccordionState =
  UAccordionState

pub const init_state = accordion.init_state

pub type AccordionItem(msg) =
  #(String, Element(msg))

pub fn accordion(
  state state: AccordionState,
  on_state_change on_state_change: fn(AccordionState) -> msg,
  items items: List(AccordionItem(msg)),
) -> Element(msg) {
  html.div(accordion_class(), [], [
    unstyled_accordion(
      state: state,
      on_state_change: on_state_change,
      items: list.map(items, convert_item),
      item_holder: html.div(s.class([s.margin_("0.1rem")]), [], _),
      separator: html.hr(s.class([s.margin_("0")]), []),
    ),
  ])
}

fn accordion_class() {
  [
    s.border_radius_("0.5rem"),
    s.border("1px solid #909092"),
    s.background("#151515"),
  ]
  |> s.class
}

fn head_class() {
  [
    s.font_size_("1.2em"),
    s.font_weight("500"),
    s.padding_("0.3rem 0.6rem"),
    s.margin_("0.1rem"),
    s.border_radius_("0.5rem"),
    s.border("none"),
    s.display("flex"),
    s.width_("100%"),
    s.flex_direction("row"),
    s.justify_content("space-between"),
    s.background("#191919"),
    s.hover([s.background("#252525")]),
    s.color("#eeeeee"),
    s.cursor("pointer"),
    s.font_family("inherit"),
  ]
  |> s.class
}

fn body_class() {
  [s.padding_("0.6rem 0.8rem"), s.color("#ddd")]
  |> s.class
}

fn body_class_open() {
  [s.display("block"), s.animation("fade-in 0.3s ease-in forwards;")]
  |> s.class
}

fn body_class_closed() {
  [s.display("none")]
  |> s.class
}

fn icon_class() {
  [
    s.display("block"),
    s.width_("20px"),
    s.height_("20px"),
    s.transition("transform 0.3s ease-out"),
    s.property("stroke", "#eee"),
    s.property("stroke-width", "1px"),
  ]
}

fn icon_class_anim(open: Bool) {
  case open {
    True -> [s.transform("rotate(0.5turn)")]
    False -> []
  }
}

fn convert_item(styled_item: AccordionItem(msg)) -> UnstyledAccordionItem(msg) {
  use open, head_attrs, _body_attrs <- function.identity
  let body_class_anim = case open {
    True -> body_class_open()
    False -> body_class_closed()
  }
  let #(head_text, inner_body) = styled_item
  let head =
    html.button(head_class(), head_attrs, [
      html.text(head_text),
      html.span(
        icon_class() |> list.append(icon_class_anim(open)) |> s.class,
        [],
        [solid.chevron_down() |> element.styled],
      ),
    ])
  let body =
    html.div(body_class_anim, [], [html.div(body_class(), [], [inner_body])])
  #(head, body)
}
