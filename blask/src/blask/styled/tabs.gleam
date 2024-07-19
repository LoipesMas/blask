import blask/internals/utils.{scld}
import blask/unstyled/tabs.{
  type TabsItem as UnstyledTabsItem, type TabsState as UTabsState,
  tabs as unstyled_tabs,
}
import gleam/function
import gleam/list
import lustre/element.{type Element}
import lustre/element/html
import sketch as s

pub type TabsState =
  UTabsState

pub const init_state = tabs.init_state

pub type TabsItem(msg) =
  #(String, Element(msg))

pub fn tabs(
  state state: TabsState,
  on_state_change on_state_change: fn(TabsState) -> msg,
  tabs tab_items: List(TabsItem(msg)),
) -> Element(msg) {
  html.div([tabs_class()], [
    unstyled_tabs(
      state: state,
      on_state_change: on_state_change,
      tabs: list.map(tab_items, convert_item),
    ),
  ])
}

fn tabs_class() {
  [
    s.border_radius_("0.5rem"),
    s.border("2px solid #909092"),
    s.background("#151515"),
  ]
  |> scld("styled-tabs-main")
}

fn head_class() {
  [
    s.font_size_("1.2em"),
    s.font_weight("500"),
    s.padding_("0.6rem 0.6rem"),
    s.border_radius_("0"),
    s.border("none"),
    s.border_right("2px solid #909092"),
    s.border_bottom("2px solid #909092"),
    s.width_("100%"),
    s.hover([s.background("#252525")]),
    s.color("#eeeeee"),
    s.hover([s.color("#fbfbfb")]),
    s.cursor("pointer"),
    s.height_("100%"),
    s.first_child([s.border_top_left_radius_("0.5rem")]),
    s.last_child([s.border_top_right_radius_("0.5rem"), s.border_right("none")]),
  ]
  |> scld("styled-tabs-head")
}

fn head_class_open() {
  [s.background("#222"), s.important(s.border_bottom("2px solid #eeeeee"))]
  |> scld("styled-tabs-head-open")
}

fn head_class_closed() {
  [s.color("gray"), s.background("#111")]
  |> scld("styled-tabs-head-closed")
}

fn body_class() {
  [s.padding_("0.6rem 0.8rem"), s.color("#ddd")]
  |> scld("styled-tabs-body")
}

fn body_class_open() {
  [s.animation("fade-in-o 0.4s ease-in forwards;")]
  |> scld("styled-tabs-body-open")
}

fn body_class_closed() {
  [s.display("none")]
  |> scld("styled-tabs-body-closed")
}

fn convert_item(styled_item: TabsItem(msg)) -> UnstyledTabsItem(msg) {
  use open <- function.identity
  let #(head_text, inner_body) = styled_item
  let head_class_anim = case open {
    True -> head_class_open()
    False -> head_class_closed()
  }
  let body_class_anim = case open {
    True -> body_class_open()
    False -> body_class_closed()
  }
  let head =
    html.button([head_class(), head_class_anim], [html.text(head_text)])
  let body = html.div([body_class(), body_class_anim], [inner_body])
  #(head, body)
}
