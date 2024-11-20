import blask/unstyled/tabs.{
  type TabsItem as UnstyledTabsItem, type TabsState as UTabsState,
  tabs as unstyled_tabs,
}
import gleam/function
import gleam/list
import sketch as s
import sketch/lustre/element.{type Element}
import sketch/lustre/element/html

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
  html.div(tabs_class() |> s.class, [], [
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
    s.border("1px solid #909092"),
    s.background("#151515"),
  ]
}

fn head_class() {
  [
    s.font_size_("1.2em"),
    s.font_weight("500"),
    s.padding_("0.6rem 0.6rem"),
    s.border_radius_("0"),
    s.border("none"),
    s.border_right("1px solid #909092"),
    s.border_bottom("1px solid #909092"),
    s.width_("100%"),
    s.hover([s.background("#252525")]),
    s.color("#eeeeee"),
    s.hover([s.color("#fbfbfb")]),
    s.cursor("pointer"),
    s.height_("100%"),
    s.first_child([s.border_top_left_radius_("0.5rem")]),
    s.last_child([s.border_top_right_radius_("0.5rem"), s.border_right("none")]),
    s.font_family("inherit"),
  ]
}

fn head_class_open() {
  [
    s.background("linear-gradient(#222 55%, #333333)"),
    s.important(s.border_bottom("1px solid #eeeeee")),
    s.hover([s.important(s.background("linear-gradient(#282828 50%, #383838)"))]),
  ]
}

fn head_class_closed() {
  [s.color("gray"), s.background("#111")]
}

fn body_class() {
  [
    s.padding_("0.6rem 0.8rem"),
    s.color("#ddd"),
    s.font_weight("300"),
    s.font_size_("1.1rem"),
  ]
}

fn body_class_open() {
  [s.animation("fade-in-o 0.4s ease-in forwards;")]
}

fn body_class_closed() {
  [s.display("none")]
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
  let head = html.button(s.class([]), [], [html.text(head_text)])
  let body = html.div([] |> s.class, [], [inner_body])
  #(
    [head_class(), head_class_anim] |> list.flatten,
    head,
    [body_class(), body_class_anim] |> list.flatten,
    body,
  )
}
