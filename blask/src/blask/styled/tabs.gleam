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

type HeadPosition {
  First
  Middle
  Last
  Only
}

fn idx_to_pos(idx: Int, count: Int) {
  case idx == 0, idx == { count - 1 } {
    True, True -> Only
    True, False -> First
    False, True -> Last
    False, False -> Middle
  }
}

pub fn tabs(
  state state: TabsState,
  on_state_change on_state_change: fn(TabsState) -> msg,
  tabs tab_items: List(TabsItem(msg)),
) -> Element(msg) {
  let tab_items_w_pos =
    list.index_map(tab_items, fn(item, idx) {
      let pos = idx_to_pos(idx, list.length(tab_items))
      #(item, pos)
    })
  html.div([tabs_class()], [
    unstyled_tabs(
      state: state,
      on_state_change: on_state_change,
      tabs: list.map(tab_items_w_pos, convert_item),
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
    s.width_("100%"),
    s.background("#191919"),
    s.hover([s.background("#252525")]),
    s.color("#eeeeee"),
    s.hover([s.color("#fbfbfb")]),
    s.cursor("pointer"),
    s.height_("100%"),
  ]
  |> scld("styled-tabs-head")
}

fn head_class_open() {
  [s.important(s.border_bottom("2px solid #999"))]
  |> scld("styled-tabs-head-open")
}

fn head_class_closed() {
  [s.important(s.border_bottom("2px solid #666666")), s.color("gray")]
  |> scld("styled-tabs-head-closed")
}

fn head_class_first() {
  [s.important(s.border_top_left_radius_("0.5rem"))]
  |> scld("styled-tabs-head-first")
}

fn head_class_last() {
  [s.important(s.border_top_right_radius_("0.5rem"))]
  |> scld("styled-tabs-head-last")
}

fn body_class() {
  [s.padding_("0.6rem 0.8rem"), s.color("#ddd")]
  |> scld("styled-tabs-body")
}

fn convert_item(
  item_w_pos: #(TabsItem(msg), HeadPosition),
) -> UnstyledTabsItem(msg) {
  let #(styled_item, pos) = item_w_pos
  use open <- function.identity
  let #(head_text, inner_body) = styled_item
  let head_class_pos = case pos {
    First -> [head_class_first()]
    Middle -> []
    Last -> [head_class_last()]
    Only -> [head_class_first(), head_class_last()]
  }
  let head_class_anim = case open {
    True -> head_class_open()
    False -> head_class_closed()
  }
  let head =
    html.button([head_class(), head_class_anim, ..head_class_pos], [
      html.text(head_text),
    ])
  let body = html.div([body_class()], [inner_body])
  #(head, body)
}
