import blask/internals/utils.{scl}
import blask/unstyled/accordion.{
  type AccordionState, accordion as unstyled_accordion,
}
import gleam/list
import gleroglero/solid
import lustre/element.{type Element}
import lustre/element/html
import sketch as s
import sketch/size

pub type AccordionItem(msg) =
  #(String, Element(msg))

pub fn accordion(
  state state: AccordionState,
  on_state_change on_state_change: fn(AccordionState) -> msg,
  items items: List(AccordionItem(msg)),
) -> Element(msg) {
  html.div([accordion_class()], [
    unstyled_accordion(
      state: state,
      on_state_change: on_state_change,
      items: list.map(items, convert_item),
      item_holder: html.div([], _),
    ),
  ])
}

fn accordion_class() {
  [
    s.border_radius_("0.5rem"),
    s.border("2px solid #909092"),
    s.min_width_("300px"),
    s.max_width_("500px"),
    s.background("#151515"),
  ]
  |> scl
}

fn head_class() {
  [
    s.font_weight("bold"),
    s.padding_("0.3rem 0.6rem"),
    s.margin_("0.1rem"),
    s.border_radius_("0.5rem"),
    s.display("flex"),
    s.flex_direction("row"),
    s.justify_content("space-between"),
    s.background("#191919"),
    s.hover([s.background("#252525")]),
  ]
  |> scl
}

fn body_class() {
  [s.padding_("0.6rem 0.8rem")]
  |> scl
}

fn icon_class() {
  [
    s.display("block"),
    s.width_("20px"),
    s.height_("20px"),
    s.transition("transform 0.3s ease-in-out"),
  ]
  |> scl
}

fn rotate180() {
  [s.transform("rotate(0.5turn)")]
  |> scl
}

fn convert_item(
  styled_item: AccordionItem(msg),
) -> #(Element(msg), Element(msg)) {
  let #(head_text, inner_body) = styled_item
  let head =
    html.div([head_class()], [
      html.text(head_text),
      html.span([icon_class()], [solid.chevron_down()]),
    ])
  let body = html.div([body_class()], [inner_body])
  #(head, body)
}
